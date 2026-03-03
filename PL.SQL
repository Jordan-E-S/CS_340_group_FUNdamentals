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

    SET FOREIGN_KEY_CHECKS=1;
END //

DELIMITER ;
