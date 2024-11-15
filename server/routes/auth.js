const express = require('express');
const cors = require('cors'); // Import the cors package
const jwt = require('jsonwebtoken');
const User = require('../models/user');
const auth = require('../middlewares/auth');

const app = express();
app.use(cors()); // Use CORS middleware
app.use(express.json());

const authRouter = express.Router();

authRouter.post('/api/signup', async (req, res) => {
    try {
        const { email, name, profilePic } = req.body;

        let user = await User.findOne({ email });

        if (!user) {
            user = new User({
                email,
                profilePic,
                name,
            });
            user = await user.save();
        }
        const token = jwt.sign({id: user._id},"passwordKey");
        res.json({ user, token });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

authRouter.get("/", auth, async (req,res)=>{
    const user = await User.findById(req.user);
    res.json({user, token: req.token});

});

module.exports = authRouter; 