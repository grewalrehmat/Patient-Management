use serde::Deserialize;
use diesel::prelude::*;

#[derive(Queryable, Debug)]
#[diesel(table_name = employees)]
pub struct Employee {
    pub employeeid: i32,
    pub name: String,
    pub phone_number: Option<String>,
    pub email: String,
    pub pwd: String,
    pub role: String,
}

#[derive(Debug, Deserialize)]
pub struct LoginRequest {
    pub email: String,
    pub password: String,
}
// These aliases let other modules import as expected
pub type User = Employee;
pub type UserLogin = LoginRequest;