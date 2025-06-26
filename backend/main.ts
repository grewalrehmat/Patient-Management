import express, { Application, Request, Response } from "express"
import Log from "./logger.js";
import { PrismaClient } from './generated/prisma/client.js';

const prisma = new PrismaClient();

const app: Application = express();

app.use(express.json());


app.get("/", (req: Request, res: Response) => {
    Log("/", "GET", 200);
    res.send("HALO");
    // res.type("json");
});

const auth_url = "http://auth:3000/login";
app.post("/login", async (req: Request, res: Response) => {

    Log("/login", "POST", 200);

    console.log("19", req.body);

    let Response = await fetch(auth_url, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            email: "user@medvault.com",
            password: "supersecret"
        })
    });


    console.log("Responce from auth container: ", await Response.json());
});

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


const port = process.env.BACKEND_PORT || 8080;
app.listen(port, () => {
    console.log(`Backend running on port ${port}`);
});