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

app.post("/patient", async (req: Request, res: Response) => {
    try {
        const { name, age, gender, phone_number } = req.body;

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


const port = process.env.BACKEND_PORT || 8080;
app.listen(port, () => {
    console.log(`Backend running on port ${port}`);
});