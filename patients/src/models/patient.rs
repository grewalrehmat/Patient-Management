use serde::{Serialize, Deserialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct Patient {
    pub id: i32,
    pub name: String,
    pub age: i32,
    pub gender: String,
}

#[derive(Debug, Deserialize)]
pub struct NewPatient {
    pub name: String,
    pub age: i32,
    pub gender: String,
}