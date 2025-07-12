use actix_web::{post, get, web, HttpResponse};
use crate::models::patient::NewPatient;
use crate::db;

#[post("/patients")]
pub async fn create(data: web::Json<NewPatient>) -> HttpResponse {
    match db::create_patient(data.into_inner()).await {
        Ok(patient) => HttpResponse::Ok().json(patient),
        Err(_) => HttpResponse::InternalServerError().finish(),
    }
}

#[get("/patients/{id}")]
pub async fn get(path: web::Path<i32>) -> HttpResponse {
    match db::fetch_patient(path.into_inner()).await {
        Some(p) => HttpResponse::Ok().json(p),
        None => HttpResponse::NotFound().finish(),
    }
}