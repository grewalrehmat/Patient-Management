var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
import express from 'express';
import passport from 'passport';
import { Strategy as JwtStrategy, ExtractJwt } from 'passport-jwt';
import jwt from 'jsonwebtoken';
import { PrismaClient } from './generated/prisma/client.js';
const prisma = new PrismaClient();
// const patients = await prisma.patient.findMany();
//
const JWT_SECRET = process.env.JWT_SECRET || "ThisistheMAKESHIFTenvVariableWhichWIllbEChangedAfterWords"; // Or use dotenv
const opts = {
    jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
    secretOrKey: JWT_SECRET
};
passport.use(new JwtStrategy(opts, (_jwt_payload, done) => __awaiter(void 0, void 0, void 0, function* () {
    let user;
    // (async ()=>{
    //   const patient = await prisma.patient.findUnique({
    //     where:{
    //       email:
    //     }
    //   });
    // })();
    if (user)
        return done(null, user);
    else
        return done(null, false);
})));
const app = express();
app.use(express.json());
app.use(passport.initialize());
app.post('/login', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    console.log(" [Container:Auth] Post request received at /login ");
    const { email, password } = req.body;
    console.log(email, password);
    const user = yield prisma.employee.findFirst({
        where: {
            email: email,
        }
    });
    console.log(user);
    if (!user) {
        console.log("No user");
        return res.status(401).json({ message: 'Invalid email or password' });
    }
    // const isMatch = await bcrypt.compare(password, user.pwd); // When the passwords stored are hashed.
    const isMatch = password === user.pwd ? true : false;
    console.log(isMatch, password, user.pwd);
    if (!isMatch) {
        return res.status(401).json({ message: 'Invalid email or password' });
    }
    const payload = { userId: user.employeeid };
    const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '1h' });
    res.json({ token });
}));
// POST /verify
app.post('/verify', (req, res) => {
    console.log(" [Container:Auth] Post request received at /verify ");
    const { token } = req.body;
    if (!token)
        return res.status(400).json({ error: 'Token missing' });
    try {
        const decoded = jwt.verify(token, JWT_SECRET);
        res.json({ valid: true, user: decoded });
    }
    catch (err) {
        res.status(401).json({ valid: false, error: 'Invalid or expired token' });
    }
});
app.get("/ping", (_req, res) => {
    res.status(200).json({
        status: "OK",
        timestamp: new Date().toISOString(),
        uptime: process.uptime().toFixed(2) + "s"
    });
});
// /protected — Protected route
// app.get('/protected', passport.authenticate('jwt', { session: false }), (req, res) => {
//         res.json({ message: `Hello ${req.user.username}` });
//     }
// );
app.listen(3000, () => {
    console.log('✅ Auth server running at http://localhost:3000');
});
