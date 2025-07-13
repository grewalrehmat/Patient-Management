# API

## Add patient
- Route: `./add-patient`
- HTTP Request: `POST`

Expected JSON:
```JSON
{ 
    "name":String,
    "age":number,
    "gender":"male"||"female",
    "phone_number":String, 
}
```
- Adds the patient to the database.

# Get All Patients
- Route: `./get-patients`
- HTTP Request:`GET`

Returned JSON:
```JSON
[
    {
        "patientid": number,
        "name": string,
        "age": number,
        "gender": "male"||"female",
        "phone_number": number
    },
    ....
]
```

# Edit Patient Record in DB
### 1. Edit details of some patient.
- Route: `./edit-patient/:patientid`
- hTTP Method: `PUT`

Expected JSON:
```JSON
{
    "name":string,
    "age":number,
    "gender":"male"||"female",
    "phone_number":string
}
// All the feilds are optional.
```

### 2. Delete a patient by patientid.
- Route: `./edit-patient/:patientid`
- hTTP Method: `DELETE`
