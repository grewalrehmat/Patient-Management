use actix_web::{
    App, HttpServer, HttpResponse, web,
    dev::{Service, ServiceRequest, ServiceResponse, Transform},
    Error,
};
use futures::future::{ready, LocalBoxFuture, Ready};
use std::future;
use std::rc::Rc;
use reqwest::Client;
use dotenvy::dotenv;

mod handlers;
mod middleware;
mod models;
mod utils;
mod db;
mod schema;

use handlers::{auth, health};

#[derive(Clone)]
pub struct JwtMiddleware;

impl<S> Transform<S, ServiceRequest> for JwtMiddleware
where
    S: Service<ServiceRequest, Response = ServiceResponse<actix_web::body::BoxBody>, Error = Error> + 'static,
{
    type Response = ServiceResponse<actix_web::body::BoxBody>;
    type Error = Error;
    type InitError = ();
    type Transform = JwtMiddlewareImpl<S>;
    type Future = Ready<Result<Self::Transform, Self::InitError>>;

    fn new_transform(&self, service: S) -> Self::Future {
        ready(Ok(JwtMiddlewareImpl {
            service: Rc::new(service),
        }))
    }
}

pub struct JwtMiddlewareImpl<S> {
    service: Rc<S>,
}

impl<S> Service<ServiceRequest> for JwtMiddlewareImpl<S>
where
    S: Service<ServiceRequest, Response = ServiceResponse<actix_web::body::BoxBody>, Error = Error> + 'static,
{
    type Response = ServiceResponse<actix_web::body::BoxBody>;
    type Error = Error;
    type Future = LocalBoxFuture<'static, Result<Self::Response, Self::Error>>;

    fn poll_ready(
        &self,
        cx: &mut std::task::Context<'_>,
    ) -> std::task::Poll<Result<(), Self::Error>> {
        self.service.poll_ready(cx)
    }

    fn call(&self, req: ServiceRequest) -> Self::Future {
        let auth_header = req.headers().get("Authorization").cloned();
        let srv = Rc::clone(&self.service);

        Box::pin(async move {
            if let Some(header_value) = auth_header {
                if let Ok(auth_str) = header_value.to_str() {
                    if let Some(token) = auth_str.strip_prefix("Bearer ") {
                        let client = Client::new();
                        let res = client
                            .post("http://localhost:3000/verify")
                            .header("Authorization", format!("Bearer {}", token))
                            .send()
                            .await;

                        if let Ok(r) = res {
                            if r.status().is_success() {
                                return srv.call(req).await;
                            }
                        }

                        return Ok(req.into_response(
                            HttpResponse::Unauthorized()
                                .body("Invalid token")
                                .map_into_boxed_body(),
                        ));
                    }
                }
            }

            Ok(req.into_response(
                HttpResponse::Unauthorized()
                    .body("Missing token")
                    .map_into_boxed_body(),
            ))
        })
    }
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    println!("🔍 Loading environment...");
    dotenv().ok();
    println!("✅ Environment loaded");

    db::init(); // make sure this isn't async or handle with .await if it is
    println!("✅ Database initialized");

    println!("🚀 Starting Actix Web server on port 8080...");

HttpServer::new(|| {
    App::new()
        .service(health::health_check)
        .service(
            web::scope("/api")
                .service(auth::login)
        )
        .service(
            web::scope("/api/protected")
                .wrap(JwtMiddleware)
                .route("/test", web::get().to(|| async { "Protected route hit ✅" }))
        )
})
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}