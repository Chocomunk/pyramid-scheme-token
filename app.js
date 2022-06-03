"use strict";

const express = require("express");
const mysql = require("promise-mysql");
const fmt = mysql.format;           // Shorthand for escape formatting

// TODO: Figure out how to non-magic-value this function
function buildListQuery(category, low, high) {
    let query = `
        SELECT painting.id, title, artist, price, img_path, name AS category 
        FROM painting 
        JOIN category ON painting.category = category.id
    `;

    // Add category filter
    if (category)   query += fmt(`AND category.name = ?`, [category]);

    // Use an `array.join` to build the price filter. Allow `0` value for prices
    const prices = new Array();
    if (low !== undefined && low !== '') prices.push(fmt(`price >= ?`, [low]));
    if (high !== undefined && high !== '') prices.push(fmt(`price <= ?`, [high]));
    if (prices.length)  query += ` WHERE ${prices.join(" AND ")}`

    // Return escaped sql query
    return query + ';';
}

function buildProdQuery(prodId) {
    return fmt(
        `
        SELECT paint.id, title, artist, price, img_path, name AS category 
        FROM (SELECT * FROM painting WHERE painting.id=?) as paint
        JOIN category ON paint.category = category.id
        `, 
        [prodId]
    );
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

// TODO: error handling on prodId doesn't exist.
app.get("/api/pictures/:prodId", async (req, res) => {
    let query = buildProdQuery(req.params.prodId);
    try {
        const rows = await queryDB(query);
        res.json(rows[0]);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// TODO: error handling on category doesn't exist. Price out-of-range is fine.
// NOTE: Calling /api/pictures will also serve all pictures
app.get("/api/pictures", async (req, res) => {
    let query = buildListQuery(req.query["category"], 
                                    req.query["low"], req.query["high"]);
    try {
        const rows = await queryDB(query);
        res.json(rows);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// TODO: Deprecate this in favor of /api/pictures
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