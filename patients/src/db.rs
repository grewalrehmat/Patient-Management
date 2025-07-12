use crate::models::{user::User, patient::{Patient, NewPatient}};
use dotenvy::dotenv;

pub fn init() {
    dotenv().ok();
}

pub async fn get_user_by_email(email: &str) -> Option<User> {
    // Diesel logic to fetch user
    None // Replace with real query
}

pub async fn create_patient(new: NewPatient) -> Result<Patient, ()> {
    // Diesel logic
    Err(())
}

pub async fn fetch_patient(id: i32) -> Option<Patient> {
    // Diesel logic
    None
}
