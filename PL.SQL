-- Jordan Smith & Arthur Franklyn
-- CS340 Final Project
-- PL/SQL: Reset Database Procedure
-- Demonstrates one CUD operation (DELETE) for RESET button

DROP PROCEDURE IF EXISTS sp_reset_boardgamedb;
DELIMITER //

CREATE PROCEDURE sp_reset_boardgamedb()
BEGIN
    -- =====================================================
    -- DELETE all existing data (CUD operation)
    -- =====================================================
    SET FOREIGN_KEY_CHECKS=0;

    DELETE FROM CheckoutItems;
    DELETE FROM Checkouts;
    DELETE FROM BoardGames;
    DELETE FROM Patrons;
    DELETE FROM Staff;
    DELETE FROM GameGenres;

    -- =====================================================
    -- Re-insert sample data
    -- =====================================================
    INSERT INTO GameGenres (gameGenreID, genre) VALUES
        (1, 'Strategy'),
        (2, 'Party'),
        (3, 'Cooperative'),
        (4, 'Family');

    INSERT INTO Staff (staffID, firstName, lastName) VALUES
        (1, 'Bagel', 'Smith'),
        (2, 'Zoe', 'Smith'),
        (3, 'Molly', 'Smith');

    INSERT INTO Patrons (patronID, firstName, lastName, email, phoneNumber) VALUES
        (1, 'Optimus', 'Prime', 'op@gmail.com', '8031231984'),
        (2, 'Ray', 'Bradbury', 'Ray@hotmail.com', '1238675309'),
        (3, 'George', 'Washington', 'cherrytree@yahoo.com', '9990041776');

    INSERT INTO BoardGames 
        (boardGameID, title, publisher, minPlayers, maxPlayers, complexity, GameGenres_gameGenreID)
    VALUES
        (1, 'Catan', 'Kosmos', 3, 4, 2, 1),
        (2, 'Pandemic', 'Z-Man Games', 2, 4, 3, 3),
        (3, 'Codenames', 'Czech Games Edition', 2, 8, 1, 2),
        (4, 'Ticket to Ride', 'Days of Wonder', 2, 5, 2, 4),
        (5, 'Azul', 'Next Move Games', 2, 4, 2, 4);

    INSERT INTO Checkouts 
        (checkoutID, checkoutDate, dueDate, returnDate, Patrons_patronID, Staff_staffID)
    VALUES
        (1, '2026-01-01', '2026-01-08', NULL, 1, 1),
        (2, '2026-02-05', '2026-02-06', '2026-02-06', 2, 2),
        (3, '2026-02-06', '2026-02-20', NULL, 3, 3);

    INSERT INTO CheckoutItems 
        (checkoutItemID, BoardGames_boardGameID, Checkouts_checkoutID)
    VALUES
        (13, 1, 1),
        (14, 3, 1),
        (15, 2, 2),
        (16, 4, 2);

    -- reset AUTO_INCREMENT values to avoid drift (next available IDs)
    ALTER TABLE GameGenres AUTO_INCREMENT = 5;      -- existing genres 1–4
    ALTER TABLE Staff AUTO_INCREMENT = 4;           -- existing staff 1–3
    ALTER TABLE Patrons AUTO_INCREMENT = 4;         -- existing patrons 1–3
    ALTER TABLE BoardGames AUTO_INCREMENT = 6;      -- existing games 1–5
    ALTER TABLE Checkouts AUTO_INCREMENT = 4;       -- existing checkouts 1–3
    ALTER TABLE CheckoutItems AUTO_INCREMENT = 17;  -- existing items 13–16

    SET FOREIGN_KEY_CHECKS=1;
END //

DELIMITER ;

-- =====================================================
-- Additional stored procedures for C/U/D operations
-- =====================================================

-- CREATE procedures -----------------------------------------------------
DROP PROCEDURE IF EXISTS sp_add_patron;
DELIMITER //
CREATE PROCEDURE sp_add_patron(
  IN p_firstName VARCHAR(50),
  IN p_lastName VARCHAR(50),
  IN p_email VARCHAR(100),
  IN p_phoneNumber VARCHAR(20)
)
BEGIN
  INSERT INTO Patrons(firstName, lastName, email, phoneNumber)
  VALUES (p_firstName, p_lastName, p_email, p_phoneNumber);
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_add_checkout_item;
DELIMITER //
CREATE PROCEDURE sp_add_checkout_item(
  IN p_boardGameID INT,
  IN p_checkoutID INT
)
BEGIN
  INSERT INTO CheckoutItems(BoardGames_boardGameID, Checkouts_checkoutID)
  VALUES (p_boardGameID, p_checkoutID);
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_add_boardgame;
DELIMITER //
CREATE PROCEDURE sp_add_boardgame(
  IN p_title VARCHAR(100),
  IN p_publisher VARCHAR(100),
  IN p_minPlayers INT,
  IN p_maxPlayers INT,
  IN p_complexity INT,
  IN p_genreID INT
)
BEGIN
  INSERT INTO BoardGames(title, publisher, minPlayers, maxPlayers, complexity, GameGenres_gameGenreID)
  VALUES (p_title, p_publisher, p_minPlayers, p_maxPlayers, p_complexity, p_genreID);
END//
DELIMITER ;

-- UPDATE procedures -----------------------------------------------------
DROP PROCEDURE IF EXISTS sp_update_boardgame;
DELIMITER //
CREATE PROCEDURE sp_update_boardgame(
  IN p_boardGameID INT,
  IN p_title VARCHAR(100),
  IN p_publisher VARCHAR(100),
  IN p_minPlayers INT,
  IN p_maxPlayers INT,
  IN p_complexity INT,
  IN p_genreID INT
)
BEGIN
  UPDATE BoardGames
  SET title = p_title,
      publisher = p_publisher,
      minPlayers = p_minPlayers,
      maxPlayers = p_maxPlayers,
      complexity = p_complexity,
      GameGenres_gameGenreID = p_genreID
  WHERE boardGameID = p_boardGameID;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_update_checkout_item;
DELIMITER //
CREATE PROCEDURE sp_update_checkout_item(
  IN p_checkoutItemID INT,
  IN p_newBoardGameID INT,
  IN p_newCheckoutID INT
)
BEGIN
  UPDATE CheckoutItems
  SET BoardGames_boardGameID = p_newBoardGameID,
      Checkouts_checkoutID = p_newCheckoutID
  WHERE checkoutItemID = p_checkoutItemID;
END//
DELIMITER ;

-- DELETE procedures -----------------------------------------------------
DROP PROCEDURE IF EXISTS sp_delete_genre;
DELIMITER //
CREATE PROCEDURE sp_delete_genre(IN p_gameGenreID INT)
BEGIN
  DELETE FROM GameGenres WHERE gameGenreID = p_gameGenreID;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_delete_checkout_item;
DELIMITER //
CREATE PROCEDURE sp_delete_checkout_item(IN p_checkoutItemID INT)
BEGIN
  DELETE FROM CheckoutItems WHERE checkoutItemID = p_checkoutItemID;
END//
DELIMITER ;

-- additional procedures for genres and patrons
DROP PROCEDURE IF EXISTS sp_add_genre;
DELIMITER //
CREATE PROCEDURE sp_add_genre(IN p_genre VARCHAR(50))
BEGIN
  INSERT INTO GameGenres(genre) VALUES (p_genre);
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_delete_patron;
DELIMITER //
CREATE PROCEDURE sp_delete_patron(IN p_patronID INT)
BEGIN
  DELETE FROM Patrons WHERE patronID = p_patronID;
END//
DELIMITER ;
