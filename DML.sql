-- Jordan Smith & Arthur Franklyn
-- ========================================
-- DML Queries for Board Game Library DB
-- Variables are denoted with @variableName
-- ========================================

-- ========================================
-- SELECT (Browse) Queries
-- ========================================

-- BoardGames browse (JOIN to show genre name instead of genre ID)
SELECT bg.boardGameID, bg.title, bg.publisher, bg.minPlayers, bg.maxPlayers, bg.complexity,
       gg.genre AS genreName
FROM BoardGames bg
JOIN GameGenres gg ON bg.GameGenres_gameGenreID = gg.gameGenreID
ORDER BY bg.title;

-- GameGenres browse
SELECT gameGenreID, genre
FROM GameGenres
ORDER BY genre;

-- Patrons browse
SELECT patronID, firstName, lastName, email, phoneNumber
FROM Patrons
ORDER BY lastName, firstName;

-- Staff browse
SELECT staffID, firstName, lastName
FROM Staff
ORDER BY lastName, firstName;

-- Checkouts browse (JOIN to show patron/staff names)
SELECT c.checkoutID, c.checkoutDate, c.dueDate, c.returnDate,
       CONCAT(p.firstName, ' ', p.lastName) AS patronName,
       CONCAT(s.firstName, ' ', s.lastName) AS staffName,
       c.Patrons_patronID, c.Staff_staffID
FROM Checkouts c
JOIN Patrons p ON c.Patrons_patronID = p.patronID
JOIN Staff s ON c.Staff_staffID = s.staffID
ORDER BY c.checkoutID;

-- CheckoutItems browse (JOIN to show game title + patron name)
SELECT ci.checkoutItemID,
       ci.Checkouts_checkoutID,
       ci.BoardGames_boardGameID,
       bg.title AS gameTitle,
       CONCAT(p.firstName, ' ', p.lastName) AS patronName
FROM CheckoutItems ci
JOIN BoardGames bg ON ci.BoardGames_boardGameID = bg.boardGameID
JOIN Checkouts c   ON ci.Checkouts_checkoutID = c.checkoutID
JOIN Patrons p     ON c.Patrons_patronID = p.patronID
ORDER BY ci.checkoutItemID;

-- ========================================
-- FK-Friendly Dropdown Queries (Required by rubric)
-- ========================================

-- Genres dropdown (BoardGames FK)
SELECT gameGenreID, genre
FROM GameGenres
ORDER BY genre;

-- Patrons dropdown (Checkouts FK)
SELECT patronID, CONCAT(firstName, ' ', lastName) AS patronName
FROM Patrons
ORDER BY lastName, firstName;

-- Staff dropdown (Checkouts FK)
SELECT staffID, CONCAT(firstName, ' ', lastName) AS staffName
FROM Staff
ORDER BY lastName, firstName;

-- BoardGames dropdown (CheckoutItems FK)
SELECT boardGameID, title
FROM BoardGames
ORDER BY title;

-- Checkouts dropdown (CheckoutItems FK, show patron name)
SELECT c.checkoutID, CONCAT(p.firstName, ' ', p.lastName) AS patronName
FROM Checkouts c
JOIN Patrons p ON c.Patrons_patronID = p.patronID
ORDER BY c.checkoutID;

-- ========================================
-- INSERT Queries
-- ========================================

-- Add a new board game
INSERT INTO BoardGames (title, publisher, minPlayers, maxPlayers, complexity, GameGenres_gameGenreID)
VALUES (@titleInput, @publisherInput, @minPlayersInput, @maxPlayersInput, @complexityInput, @genreIDInput);

-- Add a new patron
INSERT INTO Patrons (firstName, lastName, email, phoneNumber)
VALUES (@firstNameInput, @lastNameInput, @emailInput, @phoneInput);

-- Add a new staff member (optional)
INSERT INTO Staff (firstName, lastName)
VALUES (@staffFirstNameInput, @staffLastNameInput);

-- Add a new genre (optional)
INSERT INTO GameGenres (genre)
VALUES (@genreInput);

-- Add a new checkout (optional)
INSERT INTO Checkouts (checkoutDate, dueDate, returnDate, Patrons_patronID, Staff_staffID)
VALUES (@checkoutDateInput, @dueDateInput, @returnDateInput, @patronIDInput, @staffIDInput);

-- Add a new checkout item (M:M insert)
INSERT INTO CheckoutItems (BoardGames_boardGameID, Checkouts_checkoutID)
VALUES (@boardGameIDInput, @checkoutIDInput);

-- ========================================
-- UPDATE Queries
-- ========================================

-- Update board game info (entity update)
UPDATE BoardGames
SET title = @titleInput,
    publisher = @publisherInput,
    minPlayers = @minPlayersInput,
    maxPlayers = @maxPlayersInput,
    complexity = @complexityInput,
    GameGenres_gameGenreID = @genreIDInput
WHERE boardGameID = @boardGameIDInput;

-- Update patron info (optional)
UPDATE Patrons
SET firstName = @firstNameInput,
    lastName = @lastNameInput,
    email = @emailInput,
    phoneNumber = @phoneInput
WHERE patronID = @patronIDInput;

-- Update checkout item (M:M FK update requirement)
UPDATE CheckoutItems
SET BoardGames_boardGameID = @boardGameIDInput,
    Checkouts_checkoutID = @checkoutIDInput
WHERE checkoutItemID = @checkoutItemIDInput;

-- ========================================
-- DELETE Queries
-- ========================================

-- Delete patron (entity delete)
DELETE FROM Patrons
WHERE patronID = @patronIDInput;

-- Delete checkout item (M:M delete without deleting parents)
DELETE FROM CheckoutItems
WHERE checkoutItemID = @checkoutItemIDInput;


