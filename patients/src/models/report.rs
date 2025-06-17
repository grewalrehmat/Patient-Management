use serde::{Serialize, Deserialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct Report {
    pub id: i32,
    pub patient_id: i32,
    pub file_path: String,
    pub uploaded_on: chrono::NaiveDateTime,
}