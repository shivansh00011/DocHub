const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const http = require("http");

const authRouter = require("./routes/auth");
const documentRouter = require("./routes/document");
const Document = require("./models/document");


const PORT = process.env.PORT || 3001; // Use || instead of |
const app = express();

var server = http.createServer(app);
var io = require("socket.io")(server);

// Middleware setup
app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);

// MongoDB connection string
const DB = "mongodb+srv://shivansh:shivansh01@cluster0.9mtqz.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

mongoose
  .connect(DB, { useNewUrlParser: true, useUnifiedTopology: true }) // Optional: Add these options for better compatibility
  .then(() => {
    console.log("Connection successful!");

  
  })
  .catch((err) => {
    console.error("Database connection error:", err);
  });

  io.on("connection", (socket) => {
    socket.on("join", (documentId) => {
      socket.join(documentId);
    });
  
    socket.on("typing", (data) => {
      socket.broadcast.to(data.room).emit("changes", data);
    });
  
    socket.on("save", (data) => {
      saveData(data);
    });
  });
  
  const saveData = async (data) => {
    let document = await Document.findById(data.room);
    document.content = data.delta;
    document = await document.save();
  };



  // Start the server only after the database connection is successful
  server.listen(PORT, "0.0.0.0", () => {
    console.log(`Connected at port ${PORT}`);
    console.log("Hey, this is changing");
  });
