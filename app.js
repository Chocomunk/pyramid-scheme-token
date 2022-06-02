"use strict";

const express = require("express");
const mysql = require("promise-mysql");

const QUERY_STRING = `
    SELECT painting.id, title, artist, price, img_path, name AS category 
    FROM painting 
    JOIN category ON painting.category = category.id
`

// TODO: Figure out how to non-magic-value this function
function buildQuery(category, low, high) {
    let query = QUERY_STRING;

    // Add category filter
    if (category)   query += `AND category.name = "${category}"`;

    // Use an `array.join` to build the price filter
    const prices = new Array();
    if (low !== undefined)  prices.push(`price >= ${low}`);     // Allow '0'
    if (high !== undefined) prices.push(`price <= ${high}`);
    if (prices.length)  query += ` WHERE ${prices.join(" AND ")}`

    return query;
}

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

// TODO: error handling on category doesn't exist. Price out-of-range is fine.
// NOTE: Calling /api/pictures will also serve all pictures
app.get("/api/pictures", async (req, res) => {
    let query = buildQuery(req.query["category"], 
                            req.query["low"], req.query["high"]);
    try {
        const rows = await queryDB(query);
        res.json(rows);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

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