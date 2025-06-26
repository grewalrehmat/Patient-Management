var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
import express from "express";
import Log from "./logger.js";
import { PrismaClient } from './generated/prisma/client.js';
const prisma = new PrismaClient();
const app = express();
app.use(express.json());
app.get("/", (req, res) => {
    Log("/", "GET", 200);
    res.send("HALO");
    // res.type("json");
});
const auth_url = "http://auth:3000/login";
app.post("/login", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    Log("/login", "POST", 200);
    console.log("19", req.body);
    let Response = yield fetch(auth_url, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            email: "user@medvault.com",
            password: "supersecret"
        })
    });
    console.log("Responce from auth container: ", yield Response.json());
}));
app.post("/add-patient", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { name, age, gender, phone_number } = req.body;
        const newPatient = yield prisma.patient.create({
            data: {
                name,
                age,
                gender,
                phone_number,
            },
        });
        Log("/patient", "POST", 201);
        res.status(201).json(newPatient);
    }
    catch (error) {
        Log("/patient", "POST", 500);
        console.error(error);
        res.status(500).json({ error: error.message || "Internal Server Error" });
    }
}));
app.get("/get-patients", (_req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const patients = yield prisma.patient.findMany();
        Log("/get-patients", "GET", 200);
        res.status(200).json(patients);
    }
    catch (error) {
        Log("/get-patients", "GET", 500);
        console.error(error);
        res.status(500).json({ error: error.message || "Internal Server Error" });
    }
}));
app.put("/edit-patient/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const patientid = parseInt(req.params.id);
        const { name, age, gender, phone_number } = req.body;
        const updated = yield prisma.patient.update({
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
    }
    catch (error) {
        Log("/edit-patient/:id", "PUT", 500);
        console.error(error);
        res.status(500).json({ error: error.message || "Internal Server Error" });
    }
}));
app.delete("/edit-patient/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const patientid = parseInt(req.params.id);
        const deleted = yield prisma.patient.delete({
            where: { patientid },
        });
        Log("/edit-patient/:id", "DELETE", 200);
        res.status(200).json({ message: "Patient deleted", deleted });
    }
    catch (error) {
        Log("/edit-patient/:id", "DELETE", 500);
        console.error(error);
        res.status(500).json({ error: error.message || "Internal Server Error" });
    }
}));
const port = process.env.BACKEND_PORT || 8080;
app.listen(port, () => {
    console.log(`Backend running on port ${port}`);
});
