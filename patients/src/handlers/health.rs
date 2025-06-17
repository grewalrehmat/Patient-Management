use actix_web::{get, HttpResponse, Responder};

#[get("/health")]
pub async fn health_check() -> impl Responder {
    HttpResponse::Ok().body("✅ Server is alive and kicking.")
}