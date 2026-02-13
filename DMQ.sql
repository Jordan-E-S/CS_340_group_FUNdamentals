-- Jordan Smith & Arthur Franklyn
-- Original code was fed through chat gpt with the following prompt: Reformat the following
-- code to increase readability and ensure conistent formatting. Add comments to allow easy navigation.
-- ========================================
-- Data Manipulation Queries for Board Game DB
-- Variables are denoted with @variableName
-- ========================================

-- ========================================
-- SELECT Queries
-- ========================================

-- Select all board games
SELECT * FROM BoardGames;

-- Select all genres
SELECT * FROM GameGenres;

-- Select all patrons
SELECT * FROM Patrons;

-- Select all staff
SELECT * FROM Staff;

-- Select all checkouts with patron and staff info
SELECT c.checkoutID, c.checkoutDate, c.dueDate, c.returnDate,
       p.firstName AS patronFirstName, p.lastName AS patronLastName,
       s.firstName AS staffFirstName, s.lastName AS staffLastName
FROM Checkouts c
JOIN Patrons p ON c.Patrons_patronID = p.patronID
JOIN Staff s ON c.Staff_staffID = s.staffID;

-- Select all checkout items with board game titles
SELECT ci.checkoutItemID, ci.Checkouts_checkoutID, bg.title AS boardGameTitle
FROM CheckoutItems ci
JOIN BoardGames bg ON ci.BoardGames_boardGameID = bg.boardGameID;

-- ========================================
-- INSERT Queries
-- ========================================

-- Add a new board game
INSERT INTO BoardGames (title, publisher, minPlayers, maxPlayers, complexity, GameGenres_gameGenreID)
VALUES (@titleInput, @publisherInput, @minPlayersInput, @maxPlayersInput, @complexityInput, @genreIDInput);

-- Add a new patron
INSERT INTO Patrons (firstName, lastName, email, phoneNumber)
VALUES (@firstNameInput, @lastNameInput, @emailInput, @phoneInput);

-- Add a new staff member
INSERT INTO Staff (firstName, lastName)
VALUES (@firstNameInput, @lastNameInput);

-- Add a new genre
INSERT INTO GameGenres (genre)
VALUES (@genreInput);

-- Add a new checkout
INSERT INTO Checkouts (checkoutDate, dueDate, returnDate, Patrons_patronID, Staff_staffID)
VALUES (@checkoutDateInput, @dueDateInput, @returnDateInput, @patronIDInput, @staffIDInput);

-- Add a new checkout item
INSERT INTO CheckoutItems (BoardGames_boardGameID, Checkouts_checkoutID)
VALUES (@boardGameIDInput, @checkoutIDInput);

-- ========================================
-- UPDATE Queries
-- ========================================

-- Update board game info
UPDATE BoardGames
SET title = @titleInput,
    publisher = @publisherInput,
    minPlayers = @minPlayersInput,
    maxPlayers = @maxPlayersInput,
    complexity = @complexityInput,
    GameGenres_gameGenreID = @genreIDInput
WHERE boardGameID = @boardGameIDInput;

-- Update patron info
UPDATE Patrons
SET firstName = @firstNameInput,
    lastName = @lastNameInput,
    email = @emailInput,
    phoneNumber = @phoneInput
WHERE patronID = @patronIDInput;

-- Update staff info
UPDATE Staff
SET firstName = @firstNameInput,
    lastName = @lastNameInput
WHERE staffID = @staffIDInput;

-- Update genre name
UPDATE GameGenres
SET genre = @genreInput
WHERE gameGenreID = @genreIDInput;

-- Update checkout info
UPDATE Checkouts
SET checkoutDate = @checkoutDateInput,
    dueDate = @dueDateInput,
    returnDate = @returnDateInput,
    Patrons_patronID = @patronIDInput,
    Staff_staffID = @staffIDInput
WHERE checkoutID = @checkoutIDInput;


