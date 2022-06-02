"use strict";

const express = require("express");
const mysql = require("promise-mysql");

async function getDB() {
    let database = await mysql.createConnection({
        host: "localhost",
        port: "3306",
        user: "root",
        password: "root",
        database: "pst"
    });
    return database;
}

async function queryDB(query) {
    let db;
    try {
        db = await getDB();
        return await db.query(query);
    } finally {
        if (db) {
            db.end();
        }
    }
}

const app = express();

app.get("/api/pictures/all", async (req, res) => {
    try {
        const rows = await queryDB(`
            SELECT painting.id, title, artist, price, img_path, name AS category 
            FROM painting 
            JOIN category ON painting.category = category.id;
        `);
        res.json(rows);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

app.get("/api/categories/", async (req, res) => {
    try {
        const rows = await queryDB("SELECT name FROM category;");
        res.json(rows.map(row => row["name"]));
    } catch (err) {
        res.status(500).send(err.message);
    }
});

app.use(express.static("public"));

const PORT = process.env.PORT || 8000;
app.listen(PORT);