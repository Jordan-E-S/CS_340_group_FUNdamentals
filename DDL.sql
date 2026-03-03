-- Jordan Smith & Arthur Franklyn
-- CS340 Final Project
-- Board Game Library Database
-- Auto-populating DDL (no stored procedures)

SET FOREIGN_KEY_CHECKS=0;

-- -----------------------------------------------------
-- Drop Tables (Order Matters)
-- -----------------------------------------------------
DROP TABLE IF EXISTS CheckoutItems;
DROP TABLE IF EXISTS Checkouts;
DROP TABLE IF EXISTS BoardGames;
DROP TABLE IF EXISTS Patrons;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS GameGenres;

-- -----------------------------------------------------
-- Table: GameGenres
-- -----------------------------------------------------
CREATE TABLE GameGenres (
  gameGenreID INT NOT NULL AUTO_INCREMENT,
  genre VARCHAR(50) NOT NULL,
  PRIMARY KEY (gameGenreID),
  UNIQUE (genre)
) ENGINE=InnoDB;

INSERT INTO GameGenres (genre) VALUES
('Strategy'),
('Party'),
('Cooperative'),
('Family');

-- -----------------------------------------------------
-- Table: Staff
-- -----------------------------------------------------
CREATE TABLE Staff (
  staffID INT NOT NULL AUTO_INCREMENT,
  firstName VARCHAR(50) NOT NULL,
  lastName VARCHAR(50) NOT NULL,
  PRIMARY KEY (staffID)
) ENGINE=InnoDB;

INSERT INTO Staff (firstName, lastName) VALUES
('Bagel', 'Smith'),
('Zoe', 'Smith'),
('Molly', 'Smith');

-- -----------------------------------------------------
-- Table: Patrons
-- -----------------------------------------------------
CREATE TABLE Patrons (
  patronID INT NOT NULL AUTO_INCREMENT,
  firstName VARCHAR(50) NOT NULL,
  lastName VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL,
  phoneNumber VARCHAR(20),
  PRIMARY KEY (patronID),
  UNIQUE (email)
) ENGINE=InnoDB;

INSERT INTO Patrons (firstName, lastName, email, phoneNumber) VALUES
('Optimus', 'Prime', 'op@gmail.com', '8031231984'),
('Ray', 'Bradbury', 'Ray@hotmail.com', '1238675309'),
('George', 'Washington', 'cherrytree@yahoo.com', '9990041776');

-- -----------------------------------------------------
-- Table: BoardGames
-- -----------------------------------------------------
CREATE TABLE BoardGames (
  boardGameID INT NOT NULL AUTO_INCREMENT,
  title VARCHAR(100) NOT NULL,
  publisher VARCHAR(100) NOT NULL,
  minPlayers INT NOT NULL,
  maxPlayers INT NOT NULL,
  complexity INT NOT NULL,
  GameGenres_gameGenreID INT NOT NULL,
  PRIMARY KEY (boardGameID),
  CONSTRAINT fk_BoardGames_GameGenres
    FOREIGN KEY (GameGenres_gameGenreID)
    REFERENCES GameGenres(gameGenreID)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO BoardGames 
(title, publisher, minPlayers, maxPlayers, complexity, GameGenres_gameGenreID)
VALUES
('Catan', 'Kosmos', 3, 4, 2, 1),
('Pandemic', 'Z-Man Games', 2, 4, 3, 3),
('Codenames', 'Czech Games Edition', 2, 8, 1, 2),
('Ticket to Ride', 'Days of Wonder', 2, 5, 2, 4),
('Azul', 'Next Move Games', 2, 4, 2, 4);

-- -----------------------------------------------------
-- Table: Checkouts
-- -----------------------------------------------------
CREATE TABLE Checkouts (
  checkoutID INT NOT NULL AUTO_INCREMENT,
  checkoutDate DATE NOT NULL,
  dueDate DATE NOT NULL,
  returnDate DATE DEFAULT NULL,
  Patrons_patronID INT NOT NULL,
  Staff_staffID INT NOT NULL,
  PRIMARY KEY (checkoutID),
  CONSTRAINT fk_Checkouts_Patrons
    FOREIGN KEY (Patrons_patronID)
    REFERENCES Patrons(patronID)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_Checkouts_Staff
    FOREIGN KEY (Staff_staffID)
    REFERENCES Staff(staffID)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO Checkouts 
(checkoutDate, dueDate, returnDate, Patrons_patronID, Staff_staffID)
VALUES
('2026-01-01', '2026-01-08', NULL, 1, 1),
('2026-02-05', '2026-02-06', '2026-02-06', 2, 2),
('2026-02-06', '2026-02-20', NULL, 3, 3);

-- -----------------------------------------------------
-- Table: CheckoutItems (M:M)
-- -----------------------------------------------------
CREATE TABLE CheckoutItems (
  checkoutItemID INT NOT NULL AUTO_INCREMENT,
  BoardGames_boardGameID INT NOT NULL,
  Checkouts_checkoutID INT NOT NULL,
  PRIMARY KEY (checkoutItemID),
  UNIQUE (BoardGames_boardGameID, Checkouts_checkoutID),
  CONSTRAINT fk_CheckoutItems_BoardGames
    FOREIGN KEY (BoardGames_boardGameID)
    REFERENCES BoardGames(boardGameID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_CheckoutItems_Checkouts
    FOREIGN KEY (Checkouts_checkoutID)
    REFERENCES Checkouts(checkoutID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO CheckoutItems 
(BoardGames_boardGameID, Checkouts_checkoutID)
VALUES
(1, 1),
(3, 1),
(2, 2),
(4, 2);

SET FOREIGN_KEY_CHECKS=1;
