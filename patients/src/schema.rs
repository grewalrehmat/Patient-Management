// @generated automatically by Diesel CLI.

diesel::table! {
    patients (id) {
        id -> Int4,
        name -> Varchar,
        age -> Int4,
        gender -> Varchar,
    }
}

diesel::table! {
    reports (id) {
        id -> Int4,
        patient_id -> Nullable<Int4>,
        file_path -> Varchar,
        uploaded_on -> Timestamp,
    }
}

diesel::table! {
    users (id) {    
        id -> Int4,
        email -> Varchar,
        hashed_pw -> Varchar,
        role -> Array<Nullable<Text>>,
    }
}

diesel::joinable!(reports -> patients (patient_id));

diesel::allow_tables_to_appear_in_same_query!(
    patients,
    reports,
    users,
);
