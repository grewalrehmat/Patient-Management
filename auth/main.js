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
import bcrypt from 'bcryptjs';
const users = [
    {
        _id: 'u1',
        email: 'user@medvault.com',
        passwordHash: bcrypt.hashSync('supersecret', 10),
        username: 'meduser'
    }
];
const JWT_SECRET = 'Hello_there_I_am_a_pool_of_electrons'; // Or use dotenv
const opts = {
    jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
    secretOrKey: JWT_SECRET
};
passport.use(new JwtStrategy(opts, (jwt_payload, done) => __awaiter(void 0, void 0, void 0, function* () {
    const user = users.find(u => u._id === jwt_payload.userId);
    if (user)
        return done(null, user);
    else
        return done(null, false);
})));
const app = express();
app.use(express.json());
app.use(passport.initialize());
app.post('/login', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { email, password } = req.body;
    const user = users.find(u => u.email === email);
    if (!user)
        return res.status(401).json({ message: 'Invalid email or password' });
    const isMatch = yield bcrypt.compare(password, user.passwordHash);
    if (!isMatch)
        return res.status(401).json({ message: 'Invalid email or password' });
    const payload = { userId: user._id };
    const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '1h' });
    res.json({ token });
}));
// POST /verify
app.post('/verify', (req, res) => {
    const authHeader = req.headers.authorization;
    const token = authHeader === null || authHeader === void 0 ? void 0 : authHeader.split(' ')[1];
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
app.get("/ping", (req, res) => {
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
