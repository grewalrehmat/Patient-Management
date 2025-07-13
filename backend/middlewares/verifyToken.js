// middlewares/verifyToken.js
import axios from 'axios';

export const verifyToken = async (req, res, next) => {
  try {
    const authHeader = req.headers['authorization'];
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ message: 'Missing or invalid Authorization header' });
    }

    const token = authHeader.split(' ')[1];

    // Send to Auth container (use internal Docker network name for "auth")
    const response = await axios.post('http://auth:PORT/verify', { token });

    if (response.data && response.data.valid === false) {
      return res.status(401).json({ message: 'Invalid token' });
    }

    req.user = response.data; // This should include employee info from token
    next();
  } catch (err) {
    console.error('Token verification failed:', err.message);
    return res.status(401).json({ message: 'Token verification failed' });
  }
};
