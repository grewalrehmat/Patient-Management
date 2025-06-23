use actix_web::{
    body::{EitherBody, MessageBody, BoxBody},
    dev::{Service, ServiceRequest, ServiceResponse, Transform},
    Error, HttpMessage, HttpResponse,
};
use futures_util::future::{ok, LocalBoxFuture, Ready};
use jsonwebtoken::{decode, DecodingKey, Validation};
use serde::{Deserialize};
use std::{rc::Rc, task::{Context, Poll}, future::ready};

pub struct JwtMiddleware;

impl<S> Transform<S, ServiceRequest> for JwtMiddleware
where
    S: Service<ServiceRequest, Response = ServiceResponse<BoxBody>, Error = Error> + 'static,
{
    type Response = ServiceResponse<BoxBody>;
    type Error = Error;
    type InitError = ();
    type Transform = JwtMiddlewareImpl<S>;
    type Future = Ready<Result<Self::Transform, Self::InitError>>;

    fn new_transform(&self, service: S) -> Self::Future {
        ok(JwtMiddlewareImpl {
            service: Rc::new(service),
        })
    }
}

#[derive(Clone)]
pub struct JwtMiddlewareImpl<S> {
    service: Rc<S>,
}

#[derive(Debug, Deserialize)]
struct Claims {
    sub: String,
    exp: usize,
}

impl<S> Service<ServiceRequest> for JwtMiddlewareImpl<S>
where
    S: Service<ServiceRequest, Response = ServiceResponse<BoxBody>, Error = Error> + 'static,
{
    type Response = ServiceResponse<BoxBody>;
    type Error = Error;
    type Future = LocalBoxFuture<'static, Result<Self::Response, Self::Error>>;

    fn poll_ready(&self, ctx: &mut Context<'_>) -> Poll<Result<(), Self::Error>> {
        self.service.poll_ready(ctx)
    }

    fn call(&self, req: ServiceRequest) -> Self::Future {
        let srv = Rc::clone(&self.service);

        Box::pin(async move {
            let token_opt = req
                .headers()
                .get("Authorization")
                .and_then(|h| h.to_str().ok())
                .map(|s| s.trim_start_matches("Bearer ").to_string());

            if let Some(token) = token_opt {
                let decoding_key = DecodingKey::from_secret("your-secret-key".as_ref());
                match decode::<Claims>(&token, &decoding_key, &Validation::default()) {
                    Ok(_) => {
                        let res = srv.call(req).await?;
                        Ok(res)
                    }
                    Err(_) => {
                        let res = req.into_response(
                            HttpResponse::Unauthorized()
                                .body("Invalid token")
                                .map_into_boxed_body(),
                        );
                        Ok(res)
                    }
                }
            } else {
                let res = req.into_response(
                    HttpResponse::Unauthorized()
                        .body("Missing token")
                        .map_into_boxed_body(),
                );
                Ok(res)
            }
        })
    }
}