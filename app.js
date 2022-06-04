"use strict";

// Imports
const express = require("express");
const mysql = require("promise-mysql");
const multer = require("multer");

const fmt = mysql.format;           // Shorthand for escape formatting

// Error messages
const ERRMSG_INVALID_FILTER = "No pictures found under the given filters.";
const ERRMSG_INVALID_PRODID = "The provided prodId is invalid";
const ERRMSG_BUY_PARAMS = "Parameter 'prodId' is required.";

// ------------------------------ Database/Queries ------------------------------

/**
 * Build a query to get a (filtered) list of products from the database.
 * @param {string} category The category to filter by
 * @param {string} low The lower-bound for the price filter
 * @param {string} high The upper-bound for the price fitler
 * @returns The formatted and escaped sql query
 */
function buildListQuery(category, low, high) {
    let query = `
        SELECT painting.id, title, artist, price, img_path, name AS category, description
        FROM painting 
        JOIN category ON painting.category = category.id
    `;

    // Add category filter
    if (category) query += fmt(`AND category.name = ?`, [category]);

    // Use an `array.join` to build the price filter. Allow `0` value for prices
    const prices = new Array();
    if (low !== undefined && low !== '') prices.push(fmt(`price >= ?`, [low]));
    if (high !== undefined && high !== '') prices.push(fmt(`price <= ?`, [high]));
    if (prices.length) query += ` WHERE ${prices.join(" AND ")}`;

    // Return escaped sql query
    return query + ';';
}

/**
 * Build a query to get a single product entry from the database.
 * @param {string} prodId The unique id of the product to query for
 * @returns The formatted and escaped sql query
 */
function buildProdQuery(prodId) {
    return fmt(
        `
        SELECT paint.id, title, artist, price, img_path, name AS category, description
        FROM (SELECT * FROM painting WHERE painting.id=?) as paint
        JOIN category ON paint.category = category.id
        `,
        [prodId]
    );
}

/**
 * Updates the database to set the price of a specific product.
 * @param {string} prodId The unique id of the product to update
 * @param {string} price The new price to assign to the product
 * @returns The formatted and escaped sql query
 */
function buildSetPriceQuery(prodID, price) {
    return fmt(`UPDATE painting SET price=? WHERE id=?`, [price, prodID]);
}

/**
 * Attempts to connect to the 'pst' database on root@localhost.
 * @returns The db connection
 */
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

/**
 * Executes a query against the application database.
 * @param {string} query The query to send to the db
 * @returns The query result
 */
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

// ------------------------------ Express Setup ------------------------------

const app = express();
// Handle post request bodies
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(multer().none());

// ------------------------------ API Endpoints ------------------------------

/** Query the database for a single product and return it's data. */
app.get("/api/pictures/:prodId", async (req, res) => {
    let query = buildProdQuery(req.params.prodId);
    try {
        const rows = await queryDB(query);
        if (rows.length === 0) {
            res.status(400).send(ERRMSG_INVALID_PRODID);
            return;
        }
        res.json(rows[0]);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

/** Query the database for a list of products and return the resulting list. */
app.get("/api/pictures", async (req, res) => {
    let query = buildListQuery(req.query["category"],
        req.query["low"], req.query["high"]);
    try {
        const rows = await queryDB(query);
        if (!rows.length) {
            res.status(400).send(ERRMSG_INVALID_FILTER);
            return;
        }
        res.json(rows);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

/** Query the database for the set of all catagories */
app.get("/api/categories/", async (req, res) => {
    try {
        const rows = await queryDB("SELECT name FROM category;");
        res.json(rows.map(row => row["name"]));
    } catch (err) {
        res.status(500).send(err.message);
    }
});

/** Update a product in the database to reflect it's purchasing. */
app.post("/api/buy/", async (req, res) => {
    if (!req.body.prodId)
        res.status(400).send(ERRMSG_BUY_PARAMS);

    let prod_query = buildProdQuery(req.body.prodId);
    try {
        const prod_rows = await queryDB(prod_query);
        if (!prod_rows.length) {
            res.status(400).send(ERRMSG_INVALID_PRODID);
            return;
        }

        /* Compute the new price of the product.
            Ideally we would update the price depending on demand, but for this
            project we decide to increase the price by the length of the artist
            name on each purchase. This is simply an arbitrary choice of pricing.
        */
        let art = prod_rows[0];
        let price = art.price + art.artist.length;
        let price_query = buildSetPriceQuery(req.body.prodId, price);
        await queryDB(price_query);

        art.price = price;
        res.json(art);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

/** Add a feedback entry into the database. */
app.post("/api/contact", async (req, res) => {
    const name = req.body.name;
    const email = req.body.email;
    const message = req.body.message;

    if (name && email && message) {
        try {
            const qry = fmt(
                "INSERT INTO contact(name, email, message) VALUES (?, ?, ?);",
                [name, email, message]
            );
            await queryDB(qry);
            res.json({ message: "success" });
        } catch (err) {
            res.status(500).send(err.message);
        }
    } else {
        res.status(400).send("Missing name, email, or message field");
    }
});

/** Add a review for a painting into the database. */
app.post("/api/review/", async (req, res) => {
    const painting = req.body.painting;
    const name = req.body.name;
    const message = req.body.message;

    if (painting && name && message) {
        try {
            const qry = fmt(
                "INSERT INTO review(painting, name, message) VALUES (?, ?, ?);",
                [painting, name, message]
            );
            await queryDB(qry);
            res.json({ message: "success" });
        } catch (err) {
            res.status(500).send(err.message);
        }
    } else {
        res.status(400).send("Missing painting, name, or message field");
    }
});

app.get("/api/reviews/:prodId", async (req, res) => {
    try {
        const qry = fmt(
            "SELECT name, message FROM review WHERE painting = ?",
            [req.params.prodId]
        );
        const rows = await queryDB(qry);
        res.json(rows);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// ------------------------------ Main ------------------------------

// serve static files
app.use(express.static("public"));

const PORT = process.env.PORT || 8000;
app.listen(PORT);