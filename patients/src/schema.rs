diesel::table! {
    employees (employeeid) {
        employeeid -> Int4,
        #[max_length = 100]
        name -> Varchar,
        #[max_length = 20]
        phone_number -> Nullable<Varchar>,
        #[max_length = 100]
        email -> Varchar,
        #[max_length = 255]
        pwd -> Varchar,
        #[max_length = 50]
        role -> Varchar,
    }
}

diesel::table! {
    patients (patientid) {
        patientid -> Int4,
        #[max_length = 100]
        name -> Varchar,
        age -> Int4,
        #[max_length = 10]
        gender -> Varchar,
        #[max_length = 20]
        phone_number -> Nullable<Varchar>,
    }
}

diesel::table! {
    prescribe (id) {
        employeeid -> Int4,
        patientid -> Int4,
        id -> Int4,
    }
}

diesel::table! {
    reports (reportid) {
        reportid -> Int4,
        patientid -> Nullable<Int4>,
        #[sql_name = "type"]
        #[max_length = 100]
        type_ -> Varchar,
        date_uploaded -> Nullable<Timestamp>,
    }
}

diesel::joinable!(prescribe -> employees (employeeid));
diesel::joinable!(prescribe -> patients (patientid));
diesel::joinable!(reports -> patients (patientid));

diesel::allow_tables_to_appear_in_same_query!(
    employees,
    patients,
    prescribe,
    reports,
);
