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


passport.use(
    new JwtStrategy(opts, async (jwt_payload, done) => {
        const user = users.find(u => u._id === jwt_payload.userId);
        if (user) return done(null, user);
        else return done(null, false);
    })
);

const app = express();
app.use(express.json());
app.use(passport.initialize());


app.post('/login', async (req, res) => {
    const { email, password } = req.body;
    const user = users.find(u => u.email === email);

    if (!user) return res.status(401).json({ message: 'Invalid email or password' });

    const isMatch = await bcrypt.compare(password, user.passwordHash);
    if (!isMatch) return res.status(401).json({ message: 'Invalid email or password' });

    const payload = { userId: user._id };
    const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '1h' });

    res.json({ token });
});


// POST /verify
app.post('/verify', (req, res) => {
  const authHeader = req.headers.authorization;
  const token = authHeader?.split(' ')[1];

  if (!token) return res.status(400).json({ error: 'Token missing' });

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    res.json({ valid: true, user: decoded });
  } catch (err) {
    res.status(401).json({ valid: false, error: 'Invalid or expired token' });
  }
});


// /protected — Protected route
// app.get('/protected', passport.authenticate('jwt', { session: false }), (req, res) => {
//         res.json({ message: `Hello ${req.user.username}` });
//     }
// );

app.listen(3000, () => {
    console.log('✅ Auth server running at http://localhost:3000');
});
