import express, { Application, Request, Response } from "express"
import Log from "./logger.js";
import { PrismaClient } from './generated/prisma/client.js';

const prisma = new PrismaClient();

const app: Application = express();

app.use(express.json());

/*
1. Backend fetches the email, pwd and role : Done
2. checks with the db(auth)
3. generates a JWT
4. logs user in
5. then serves data like past patients name and their medical history
6. reports are uploaded on cloud
*/

app.get("/", (req: Request, res: Response) => {
    Log("/", "GET", 200);
    res.send("HALO");
    // res.type("json");
});

const auth_url = "http://0.0.0.0:3000/login";
app.post("/login", async (req: Request, res: Response) => {

    Log("/login", "POST", 200);

    console.log("19", req.body);
    let payload = req.body;

    if (!payload && !payload.email && !payload.password){
        res.json({
            error:"No playload send with POST request."
        });
    }
    let Response;
    try{
        Response = await fetch(auth_url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                email: payload.email,
                password: payload.password
            })
        });
    }
    catch(e){
        console.log("Some problem occured while contacting auth container. Error: "+e);
        res.json({
            error:"Unable to login, Some error occured in backend.",
            e
        });
    }
    let responce = await Response.json();
    console.log("Responce from auth container: ", responce);
    res.send(responce);
});

/*
app.post("/add-patient", async (req: Request, res: Response) => {
    try {
        interface addPatient{
            name:string,
            age:number,
            gender:"male"|"female",
            phone_number:string
        }
        const { name, age, gender, phone_number }:addPatient = req.body;

        const newPatient = await prisma.patient.create({
            data: {
                name,
                age,
                gender,
                phone_number,
            },
        });

        Log("/patient", "POST", 201);
        res.status(201).json(newPatient);

    } catch (error: any) {
        Log("/patient", "POST", 500);
        console.error(error);
        res.status(500).json({ error: error.message || "Internal Server Error" });
    }
});

app.get("/get-patients", async (_req: Request, res: Response) => {
    try {
        const patients = await prisma.patient.findMany();

        Log("/get-patients", "GET", 200);
        res.status(200).json(patients);

    } catch (error: any) {
        Log("/get-patients", "GET", 500);
        console.error(error);
        res.status(500).json({ error: error.message || "Internal Server Error" });
    }
});

app.put("/edit-patient/:id", async (req: Request, res: Response) => {
    try {
        const patientid = parseInt(req.params.id);

        const { name, age, gender, phone_number }: {
            name?: string;
            age?: number;
            gender?: "male" | "female";
            phone_number?: string;
        } = req.body;

        const updated = await prisma.patient.update({
            where: { patientid },
            data: {
                name,
                age,
                gender,
                phone_number
            },
        });

        Log("/edit-patient/:id", "PUT", 200);
        res.status(200).json({ message: "Patient updated", patient: updated });

    } catch (error: any) {
        Log("/edit-patient/:id", "PUT", 500);
        console.error(error);
        res.status(500).json({ error: error.message || "Internal Server Error" });
    }
});

app.delete("/edit-patient/:id", async (req: Request, res: Response) => {
    try {
        const patientid = parseInt(req.params.id);

        const deleted = await prisma.patient.delete({
            where: { patientid },
        });

        Log("/edit-patient/:id", "DELETE", 200);
        res.status(200).json({ message: "Patient deleted", deleted });

    } catch (error: any) {
        Log("/edit-patient/:id", "DELETE", 500);
        console.error(error);
        res.status(500).json({ error: error.message || "Internal Server Error" });
    }
});
*/

const port = process.env.BACKEND_PORT || 8080;
app.listen(port, () => {
    console.log(`Backend running on port ${port}`);
});