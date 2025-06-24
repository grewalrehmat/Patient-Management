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
const port = process.env.BACKEND_PORT || 8080;
app.listen(port, () => {
    console.log(`Backend running on port ${port}`);
});
