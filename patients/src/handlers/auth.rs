use actix_web::{post, web, HttpResponse};
use crate::models::user::UserLogin;
use crate::utils::{auth::create_jwt, hash::verify_password};
use crate::db;

#[post("/login")]
pub async fn login(user: web::Json<UserLogin>) -> HttpResponse {
    match db::get_user_by_email(&user.email).await {
        Some(db_user) => {
            if verify_password(&user.password, &db_user.hashed_pw) {
                match create_jwt(&db_user) {
                    Ok(token) => HttpResponse::Ok().json(token),
                    Err(_) => HttpResponse::InternalServerError().body("Token failure"),
                }
            } else {
                HttpResponse::Unauthorized().body("Wrong password")
            }
        }
        None => HttpResponse::NotFound().body("User not found"),
    }
}