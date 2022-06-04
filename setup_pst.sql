-- Notes:
--      Base price is the fundamental price of the token before owner royalties
--      The "buy-in-price" in the price owed to every previous owner on each new purchase
--          On each purchase the **current owner** gains `base_price + buy_in`
--              then the ownership is transferred to the buyer.
--          All previous owners only recieve `buy_in` on each new purchase.
--          For N existing owners, the price should be `base_price + N * buy_in`
--      We (the developers) are always the first owner (so we recieve royalties)
--      Any user can buy a token again to recieve additional royalties

-- Tables:
-- Tokens table: token_ticker, img_path, base_price, buy_in_price, owner_count
-- (maybe) Users table: username, password (base64 encoded), balance, is_admin
-- (maybe) Purchases table: username, token_ticker

-- Is there a better way of keeping track of transactions so that seeing all of
--  a token's transactions is fast?

DROP TABLE IF EXISTS painting;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS contact;

CREATE TABLE category(
    id      INT             PRIMARY KEY,
    name    VARCHAR(63)     NOT NULL
);

INSERT INTO category VALUES
	(1,	'Abstract'),
	(2,	'Landscape'),
	(3,	'Portrait'),
	(4,	'Miscellaneous');

CREATE TABLE painting(
  id        INT             AUTO_INCREMENT,     -- 2345678
  title     VARCHAR(63)     NOT NULL,           -- move.jpg
  artist    VARCHAR(63)     NOT NULL,           -- Alvin On
  price     NUMERIC(10,2)   NOT NULL,           -- 999.99
  img_path  VARCHAR(127),                       -- imgs/move.png
  category  INT, 
  PRIMARY KEY (id),
  FOREIGN KEY (category) REFERENCES category(id)
);

INSERT INTO painting(title, artist, price, img_path, category) VALUES
	('Vigilant Cow', 'Mario Ruiz', 750.00, 'imgs/cow.png', 4),
	('move.png', 'Alvin On', 250.00, 'imgs/move.png', 3),
	('Smiling Face', 'Mario Ruiz', 250.00, 'imgs/smiling-face.png', 3),
	('space-cat.png', 'Alvin On', 750.00, 'imgs/space-cat.png', 4),
	('Useless Squiggle', 'Mario Ruiz', 100.00, 'imgs/squiggle.png', 1),
	('Tree on a Hill', 'Mario Ruiz', 250.00, 'imgs/tree-on-a-hill.png', 2),
	('Green Dinosaur', 'Susu Le', 2000.00, 'imgs/green-dinosaur.png', 3),
	('Red Trapezoid', 'Susu Le', 1000.00, 'imgs/red-trapezoid.png', 3),
	('Untitled No. 27', 'Kevin Yu', 2500.00, 'imgs/untitled-no-27.png', 1),
	('Ode To Caltech', 'Kevin Yu', 1500.00, 'imgs/ode-to-caltech.png', 1),
	('Landscape in Black & White No. 3', 'Kevin Yu', 1750.00, 'imgs/landscape-in-black-white-no-3.png', 2),
	('Flowers', 'Ivy Tang', 1000.00, 'imgs/flowers.png', 1),
	('The First Supper', 'Ivy Tang', 500.00, 'imgs/the-first-supper.png', 1),
	('Pain', 'Ivy Tang', 750.00, 'imgs/pain.png', 4);


CREATE TABLE contact(
  id        INT             AUTO_INCREMENT,     -- 2345678
  name      VARCHAR(63)     NOT NULL,           -- move.jpg
  email     VARCHAR(63)     NOT NULL,           -- Alvin On
  message   TEXT            NOT NULL,           -- 999.99
  PRIMARY KEY (id)
);

INSERT INTO contact(name, email, message) VALUES
	('Mario Ruiz', 'mjruiz@caltech.edu', 'This website is a total scam.  Very bad!'),
	('Alvin On', 'aon@caltech.edu', 'chungus');