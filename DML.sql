-- Jordan Smith & Arthur Franklyn
-- CS340 Final Project
-- DML File
-- Contains all CRUD SQL queries used by the application
-- Stored procedure versions of some operations are located in pl.sql


-- =====================================================
-- GAMEGENRES
-- =====================================================

-- READ all genres
SELECT * FROM GameGenres;

-- INSERT genre
INSERT INTO GameGenres (genre)
VALUES (?);

-- DELETE genre
DELETE FROM GameGenres
WHERE gameGenreID = ?;



-- =====================================================
-- BOARDGAMES
-- =====================================================

-- READ board games with genre name (JOIN)
SELECT 
    bg.boardGameID,
    bg.title,
    bg.publisher,
    bg.minPlayers,
    bg.maxPlayers,
    bg.complexity,
    bg.GameGenres_gameGenreID,
    g.genre
FROM BoardGames bg
INNER JOIN GameGenres g
    ON bg.GameGenres_gameGenreID = g.gameGenreID;

-- INSERT board game
INSERT INTO BoardGames
(title, publisher, minPlayers, maxPlayers, complexity, GameGenres_gameGenreID)
VALUES (?, ?, ?, ?, ?, ?);

-- UPDATE board game
UPDATE BoardGames
SET title = ?,
    publisher = ?,
    minPlayers = ?,
    maxPlayers = ?,
    complexity = ?,
    GameGenres_gameGenreID = ?
WHERE boardGameID = ?;

-- DELETE board game
DELETE FROM BoardGames
WHERE boardGameID = ?;



-- =====================================================
-- PATRONS
-- =====================================================

-- READ patrons
SELECT * FROM Patrons;

-- INSERT patron
INSERT INTO Patrons
(firstName, lastName, email, phoneNumber)
VALUES (?, ?, ?, ?);

-- DELETE patron
DELETE FROM Patrons
WHERE patronID = ?;



-- =====================================================
-- STAFF
-- =====================================================

-- READ staff
SELECT * FROM Staff;



-- =====================================================
-- CHECKOUTS
-- =====================================================

-- READ checkouts with patron and staff names (JOIN)
SELECT 
    c.checkoutID,
    c.checkoutDate,
    c.dueDate,
    c.returnDate,
    p.firstName AS patronFirstName,
    p.lastName AS patronLastName,
    s.firstName AS staffFirstName,
    s.lastName AS staffLastName
FROM Checkouts c
INNER JOIN Patrons p 
    ON c.Patrons_patronID = p.patronID
INNER JOIN Staff s 
    ON c.Staff_staffID = s.staffID;

-- INSERT checkout
INSERT INTO Checkouts
(checkoutDate, dueDate, returnDate, Patrons_patronID, Staff_staffID)
VALUES (?, ?, ?, ?, ?);



-- =====================================================
-- CHECKOUTITEMS (M:M Relationship)
-- =====================================================

-- READ checkout items with related data (JOIN)
SELECT 
    ci.checkoutItemID,
    ci.Checkouts_checkoutID,
    ci.BoardGames_boardGameID,
    p.firstName AS patronName,
    bg.title
FROM CheckoutItems ci
INNER JOIN Checkouts c 
    ON ci.Checkouts_checkoutID = c.checkoutID
INNER JOIN Patrons p 
    ON c.Patrons_patronID = p.patronID
INNER JOIN BoardGames bg 
    ON ci.BoardGames_boardGameID = bg.boardGameID;

-- INSERT checkout item
INSERT INTO CheckoutItems
(BoardGames_boardGameID, Checkouts_checkoutID)
VALUES (?, ?);

-- UPDATE checkout item
UPDATE CheckoutItems
SET BoardGames_boardGameID = ?,
    Checkouts_checkoutID = ?
WHERE checkoutItemID = ?;

-- DELETE checkout item
DELETE FROM CheckoutItems
WHERE checkoutItemID = ?;
