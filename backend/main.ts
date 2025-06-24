import express, { Application, Request, Response } from "express"
import Log from "./logger.js";

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

const port = process.env.BACKEND_PORT || 8080;
app.listen(port, () => {
    console.log(`Backend running on port ${port}`);
});