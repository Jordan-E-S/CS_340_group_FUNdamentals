-- Jordan Smith & Arthur Franklyn
-- CS340 Final Project
-- PL/SQL Procedures File
-- Contains RESET procedure and one CUD example

-- =====================================================
-- RESET PROCEDURE
-- =====================================================
-- This procedure calls the DDL reset procedure
-- defined in ddl.sql

DROP PROCEDURE IF EXISTS sp_reset_boardgamedb;
DELIMITER //

CREATE PROCEDURE sp_reset_boardgamedb()
BEGIN
    CALL sp_load_boardgamedb();
END //

DELIMITER ;

-- To reset the database:
-- CALL sp_reset_boardgamedb();



-- =====================================================
-- CUD EXAMPLE #1 (INSERT) – Add Patron
-- =====================================================

DROP PROCEDURE IF EXISTS sp_add_patron;
DELIMITER //

CREATE PROCEDURE sp_add_patron(
    IN p_firstName VARCHAR(50),
    IN p_lastName VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(20)
)
BEGIN
    INSERT INTO Patrons
    (firstName, lastName, email, phoneNumber)
    VALUES
    (p_firstName, p_lastName, p_email, p_phone);
END //

DELIMITER ;

-- Example usage:
-- CALL sp_add_patron('Tony', 'Stark', 'ironman@avengers.com', '5550000000');



-- =====================================================
-- CUD EXAMPLE #2 (UPDATE) – Update BoardGame Complexity
-- =====================================================
-- Optional but demonstrates another CUD operation

DROP PROCEDURE IF EXISTS sp_update_boardgame_complexity;
DELIMITER //

CREATE PROCEDURE sp_update_boardgame_complexity(
    IN p_boardGameID INT,
    IN p_newComplexity INT
)
BEGIN
    UPDATE BoardGames
    SET complexity = p_newComplexity
    WHERE boardGameID = p_boardGameID;
END //

DELIMITER ;

-- Example usage:
-- CALL sp_update_boardgame_complexity(1, 4);
