import express from 'express';
import passport from 'passport';
import { Strategy as JwtStrategy, ExtractJwt } from 'passport-jwt';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import { Pool } from 'pg';
// ca274b11fac385a474fb661c84f2fcb1781e234d
// const users = [
//     {
//         _id: 'u1',
//         email: 'user@medvault.com',
//         passwordHash: bcrypt.hashSync('supersecret', 10),
//         username: 'meduser'
//     }
// ];
// Setup PostgreSQL connection pool using the DATABASE_URL from .env
const pool = new Pool({
    connectionString: process.env.DATABASE_URL
});
const JWT_SECRET = process.env.JWT_SECRET;
const opts = {
    jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
    secretOrKey: JWT_SECRET
};
passport.use(new JwtStrategy(opts, async (jwt_payload, done) => {
    try {
        // Find user in the employees table by their ID
        const { rows } = await pool.query('SELECT employeeid, email, name FROM employees WHERE employeeid = $1', [jwt_payload.userId]);
        if (rows.length > 0) {
            const dbUser = rows[0];
            // Map database user to application user object
            const user = {
                _id: dbUser.employeeid,
                email: dbUser.email,
                username: dbUser.name
            };
            return done(null, user);
        }
        else {
            return done(null, false);
        }
    }
    catch (error) {
        return done(error, false);
    }
}));
const app = express();
app.use(express.json());
app.use(passport.initialize());
app.post('/login', async (req, res) => {
    const { email, password } = req.body;
    try {
        // Find user by email in the employees table
        const { rows } = await pool.query('SELECT employeeid, pwd FROM employees WHERE email = $1', [email]);
        if (rows.length === 0) {
            return res.status(401).json({ message: 'Invalid email or password' });
        }
        const dbUser = rows[0];
        // Compare provided password with the stored hash (pwd)
        const isMatch = await bcrypt.compare(password, dbUser.pwd);
        if (!isMatch) {
            return res.status(401).json({ message: 'Invalid email or password' });
        }
        // User is authenticated, create JWT
        const payload = { userId: dbUser.employeeid };
        const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '1h' });
        res.json({ token });
    }
    catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});
// POST /verify
app.post('/verify', (req, res) => {
    const authHeader = req.headers.authorization;
    const token = authHeader?.split(' ')[1];
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
// /protected — Protected route
// app.get('/protected', passport.authenticate('jwt', { session: false }), (req: Request, res: Response) => {
//     // @ts-ignore
//     res.json({ message: `Hello ${req.user.username}` });
// });
// /protected 
// app.get('/protected', passport.authenticate('jwt', { session: false }), (req, res) => {
//         res.json({ message: `Hello ${req.user.username}` });
//     }
// );
app.listen(3000, () => {
    console.log('✅ Auth server running at http://localhost:3000');
});
