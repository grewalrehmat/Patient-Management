use actix_web::{App, HttpServer, web};
use actix_web_lab::middleware::from_fn;

mod handlers;
mod middleware;
mod models;
mod utils;
mod db;
mod schema;

use handlers::{auth, patients, reports, health};

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenvy::dotenv().ok();
    db::init(); // ✅ Init DB

    HttpServer::new(|| {
        App::new()
            // Public routes
            .service(health::health_check)
            .service(auth::login)

            // Protected routes (JWT middleware only here)
            .service(
                web::scope("") // you can use "/api" or similar if needed
                    .wrap(from_fn(middleware::auth_guard::jwt_middleware))
                    .service(patients::create)
                    .service(patients::get)
                    .service(reports::upload)
            )
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}