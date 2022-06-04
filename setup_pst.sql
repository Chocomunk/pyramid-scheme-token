/*
  NAME: Mario Ruiz and Alvin On
  DATE: 6/3/2022

  This file intializes database tables for the PST exchange website. It keeps track
  of painting products, painting categories, and user feedback.
*/

DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS painting;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS contact;

/* Stores unique painting categories that must be assigned to each product */
CREATE TABLE category(
    id      INT             PRIMARY KEY,
    name    VARCHAR(63)     NOT NULL
);

INSERT INTO category VALUES
	(1,	'Abstract'),
	(2,	'Landscape'),
	(3,	'Portrait'),
	(4,	'Miscellaneous');

/* 
  Stores information about each painting. Tracks painting info, pricing, and 
  provides a link to the painting image
 */
CREATE TABLE painting(
  id            INT             AUTO_INCREMENT,     -- 2345678
  title         VARCHAR(63)     NOT NULL,           -- move.jpg
  artist        VARCHAR(63)     NOT NULL,           -- Alvin On
  price         NUMERIC(10,2)   NOT NULL,           -- 999.99
  img_path      VARCHAR(127)    NOT NULL,           -- imgs/move.png
  category      INT,                                -- 1
  description   TEXT,                               -- A nice painting.
  PRIMARY KEY (id),
  FOREIGN KEY (category) REFERENCES category(id)
);

INSERT INTO painting(title, artist, price, img_path, category, description) VALUES
	('Vigilant Cow', 'Mario Ruiz', 750.00, 'imgs/cow.png', 4, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Vulpuatiadis minim veniam, quis nostrud exercitation ullamco laborisnisi ut aliquip ex ea commodo. Facilisi etiam dignissim diam quis enim lobortis scelerisque fermentum."),
	('move.png', 'Alvin On', 250.00, 'imgs/move.png', 3, "Accumsan tortor posuere ac ut consequat. Fusce ut placerat orci nulla pellentesque dignissim. Nec ultrices dui sapien eget. Amet est placerat in egestas erat imperdiet. Viverra vitae congue eu consequat ac felis donec. Purus sit amet luctus venenatis lectus magna fringilla urna porttitor. Platea dictumst quisque sagittis purus sit amet. Sed viverra ipsum nunc aliquet bibendum."),
	('Smiling Face', 'Mario Ruiz', 250.00, 'imgs/smiling-face.png', 3, "Dui faucibus in ornare quam. Consequat interdum varius sit amet. Mollis nunc sed id semper risus in hendrerit gravida. Nec tincidunt praesent semper feugiat nibh sed pulvinar proin. Gravida in fermentum et sollicitudin ac orci. Vulputate eu scelerisque felis imperdiet proin fermentum leo vel. Sit amet cursus sit amet dictum sit."),
	('space-cat.png', 'Alvin On', 750.00, 'imgs/space-cat.png', 4, "Cursus mattis molestie a iaculis at erat pellentesque. Metus dictum at tempor commodo ullamcorper a lacus vestibulum sed. Sed augue lacus viverra vitae congue eu consequat ac felis. Vivamus arcu felis bibendum ut tristique et egestas quis. Malesuada fames ac turpis egestas sed tempus urna. Massa id neque aliquam vestibulum morbi blandit cursus risus at. Imperdiet sed euismod nisi porta lorem. Quam adipiscing vitae proin sagittis nisl rhoncus mattis rhoncus."),
	('Useless Squiggle', 'Mario Ruiz', 100.00, 'imgs/squiggle.png', 1, "Ut tellus elementum sagittis vitae et leo duis. Senectus et netus et malesuada fames ac. Fringilla phasellus faucibus scelerisque eleifend donec. Viverra vitae congue eu consequat ac. Pulvinar neque laoreet suspendisse interdum. At ultrices mi tempus imperdiet nulla malesuada pellentesque elit. Nibh tortor id aliquet lectus proin. Metus vulputate eu scelerisque felis imperdiet."),
	('Tree on a Hill', 'Mario Ruiz', 250.00, 'imgs/tree-on-a-hill.png', 2, 'Ut tellus elementum sagittis vitae et leo duis. Senectus et netus et malesuada fames ac. Fringilla phasellus faucibus scelerisque eleifend donec. Viverra vitae congue eu consequat ac. Pulvinar neque laoreet suspendisse interdum. At ultrices mi tempus imperdiet nulla malesuada pellentesque elit. Nibh tortor id aliquet lectus proin. Metus vulputate eu scelerisque felis imperdiet.'),
	('Green Dinosaur', 'Susu Le', 2000.00, 'imgs/green-dinosaur.png', 3, 'Quis eleifend quam adipiscing vitae proin. Dolor sed viverra ipsum nunc aliquet bibendum. Amet mauris commodo quis imperdiet. A lacus vestibulum sed arcu non odio. Vel pretium lectus quam id leo in. Cursus risus at ultrices mi tempus imperdiet nulla malesuada. Orci eu lobortis elementum nibh tellus molestie. A cras semper auctor neque.'),
	('Red Trapezoid', 'Susu Le', 1000.00, 'imgs/red-trapezoid.png', 3, 'Consequat interdum varius sit amet. At lectus urna duis convallis convallis tellus id interdum. Amet nulla facilisi morbi tempus iaculis urna id. Scelerisque varius morbi enim nunc faucibus a pellentesque. Eu turpis egestas pretium aenean pharetra magna. Dui ut ornare lectus sit amet est placerat. Mauris nunc congue nisi vitae.'),
	('Untitled No. 27', 'Kevin Yu', 2500.00, 'imgs/untitled-no-27.png', 1, 'Eget dolor morbi non arcu risus quis varius. Pharetra et ultrices neque ornare. Interdum posuere lorem ipsum dolor sit amet. Porttitor rhoncus dolor purus non enim praesent elementum. Convallis posuere morbi leo urna molestie at. Venenatis lectus magna fringilla urna porttitor. Bibendum est ultricies integer quis auctor. Suspendisse faucibus interdum posuere lorem ipsum dolor sit.'),
	('Ode To Caltech', 'Kevin Yu', 1500.00, 'imgs/ode-to-caltech.png', 1, 'Eget nunc scelerisque viverra mauris in aliquam sem fringilla ut. Elementum tempus egestas sed sed risus pretium quam vulputate dignissim. Aliquet eget sit amet tellus. Vel fringilla est ullamcorper eget nulla facilisi etiam dignissim diam. Euismod lacinia at quis risus sed vulputate odio ut. Euismod in pellentesque massa placerat duis ultricies lacus. Et ultrices neque ornare aenean. Facilisi etiam dignissim diam quis enim lobortis.'),
	('Landscape in Black & White No. 3', 'Kevin Yu', 1750.00, 'imgs/landscape-in-black-white-no-3.png', 2, 'Sed tempus urna et pharetra pharetra massa massa ultricies. In massa tempor nec feugiat nisl pretium. Sit amet porttitor eget dolor. Venenatis lectus magna fringilla urna. Nec tincidunt praesent semper feugiat. Eget velit aliquet sagittis id consectetur purus ut faucibus. Interdum posuere lorem ipsum dolor. Ipsum consequat nisl vel pretium lectus quam.'),
	('Flowers', 'Ivy Tang', 1000.00, 'imgs/flowers.png', 1, 'Leo vel fringilla est ullamcorper eget nulla facilisi. Sed egestas egestas fringilla phasellus faucibus scelerisque eleifend donec. Morbi tincidunt augue interdum velit euismod in. Libero nunc consequat interdum varius. Et malesuada fames ac turpis egestas sed tempus urna et. Rhoncus mattis rhoncus urna neque viverra justo nec ultrices. Pulvinar elementum integer enim neque volutpat ac tincidunt.'),
	('The First Supper', 'Ivy Tang', 500.00, 'imgs/the-first-supper.png', 1, 'Pretium vulputate sapien nec sagittis aliquam malesuada bibendum arcu. Tellus elementum sagittis vitae et leo. Ullamcorper malesuada proin libero nunc consequat interdum varius sit. Sed blandit libero volutpat sed cras ornare arcu dui. Quam pellentesque nec nam aliquam sem et. Auctor eu augue ut lectus arcu bibendum. '),
	('Pain', 'Ivy Tang', 750.00, 'imgs/pain.png', 4, 'Aenean euismod elementum nisi quis. Et leo duis ut diam. Enim sit amet venenatis urna cursus eget nunc scelerisque. Nec sagittis aliquam malesuada bibendum arcu. Quis imperdiet massa tincidunt nunc pulvinar sapien. Purus in mollis nunc sed id semper. Odio facilisis mauris sit amet massa vitae tortor. Dui id ornare arcu odio ut sem nulla pharetra diam.'),
	('belephant', 'Alvin On', 500.00, 'imgs/belephant.png', 3, 'Its Billy the Belephant!'),
	('color-bomb', 'Alvin On', 300.00, 'imgs/color-bomb.png', 4, 'Boom boom colors!');

/* 
  Stores user reviews for product. Stores the user's name, their review 
  message, and the id of the product they reviewed. 
*/
CREATE TABLE review(
  id        INT             AUTO_INCREMENT,
  painting  INT             NOT NULL,
  name      VARCHAR(63)     NOT NULL,
  message   TEXT            NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (painting) REFERENCES painting(id)
);

INSERT INTO review(painting, name, message) VALUES
	('1', 'Mario Ruiz', 'Cow is cute.  Would buy again.');

/* Stores user-submitted feedback. Tracks user contact and their comments. */
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