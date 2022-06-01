"use strict";

const express = require("express");
const app = express();

app.use(express.static("public"));

app.get("/", (req, res) => {
    res.send("Hello world!");
});

const PORT = process.env.PORT || 8000;
app.listen(PORT);