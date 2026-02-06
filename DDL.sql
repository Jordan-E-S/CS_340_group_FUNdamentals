-- Jordan Smith & Arthur Franklyn
-- Code yanked from phpMyAdmin export process
--
-- phpMyAdmin SQL Dump
-- version 5.2.3-1.el9.remi
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Feb 05, 2026 at 06:57 PM
-- Server version: 10.11.15-MariaDB-log
-- PHP Version: 8.4.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cs340_smitjor8`
--

-- --------------------------------------------------------

--
-- Table structure for table `BoardGames`
--

CREATE TABLE `BoardGames` (
  `boardGameID` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `publisher` varchar(100) NOT NULL,
  `minPlayers` int(11) NOT NULL,
  `maxPlayers` int(11) NOT NULL,
  `complexity` int(11) NOT NULL,
  `GameGenres_gameGenreID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `BoardGames`
--

INSERT INTO `BoardGames` (`boardGameID`, `title`, `publisher`, `minPlayers`, `maxPlayers`, `complexity`, `GameGenres_gameGenreID`) VALUES
(1, 'Catan', 'Kosmos', 3, 4, 2, 1),
(2, 'Pandemic', 'Z-Man Games', 2, 4, 3, 3),
(3, 'Codenames', 'Czech Games Edition', 2, 8, 1, 2),
(4, 'Ticket to Ride', 'Days of Wonder', 2, 5, 2, 4),
(5, 'Azul', 'Next Move Games', 2, 4, 2, 4);

-- --------------------------------------------------------

--
-- Table structure for table `CheckoutItems`
--

CREATE TABLE `CheckoutItems` (
  `checkoutItemID` int(11) NOT NULL,
  `BoardGames_boardGameID` int(11) NOT NULL,
  `Checkouts_checkoutID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `CheckoutItems`
--

INSERT INTO `CheckoutItems` (`checkoutItemID`, `BoardGames_boardGameID`, `Checkouts_checkoutID`) VALUES
(13, 1, 1),
(14, 3, 1),
(15, 2, 2),
(16, 4, 2);

-- --------------------------------------------------------

--
-- Table structure for table `Checkouts`
--

CREATE TABLE `Checkouts` (
  `checkoutID` int(11) NOT NULL,
  `checkoutDate` date NOT NULL,
  `dueDate` date NOT NULL,
  `returnDate` date DEFAULT NULL,
  `Patrons_patronID` int(11) NOT NULL,
  `Staff_staffID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Checkouts`
--

INSERT INTO `Checkouts` (`checkoutID`, `checkoutDate`, `dueDate`, `returnDate`, `Patrons_patronID`, `Staff_staffID`) VALUES
(1, '2026-01-01', '0000-00-00', NULL, 1, 1),
(2, '2026-02-05', '2026-02-06', '2026-02-06', 2, 2),
(3, '2026-02-06', '2026-02-20', NULL, 3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `GameGenres`
--

CREATE TABLE `GameGenres` (
  `gameGenreID` int(11) NOT NULL,
  `genre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `GameGenres`
--

INSERT INTO `GameGenres` (`gameGenreID`, `genre`) VALUES
(1, 'Strategy'),
(2, 'Party'),
(3, 'Cooperative'),
(4, 'Family');

-- --------------------------------------------------------

--
-- Table structure for table `Patrons`
--

CREATE TABLE `Patrons` (
  `patronID` int(11) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phoneNumber` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Patrons`
--

INSERT INTO `Patrons` (`patronID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(1, 'Optimus', 'Prime', 'op@gmail.com', '8031231984'),
(2, 'Ray', 'Bradbury', 'Ray@hotmail.com', '1238675309'),
(3, 'George', 'Washington', 'cherrytree@yahoo.com', '9990041776');

-- --------------------------------------------------------

--
-- Table structure for table `Staff`
--

CREATE TABLE `Staff` (
  `staffID` int(11) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Staff`
--

INSERT INTO `Staff` (`staffID`, `firstName`, `lastName`) VALUES
(1, 'Bagel', 'Smith'),
(2, 'Zoe', 'Smith'),
(3, 'Molly', 'Smith');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `BoardGames`
--
ALTER TABLE `BoardGames`
  ADD PRIMARY KEY (`boardGameID`),
  ADD KEY `fk_BoardGames_GaneGenres1_idx` (`GameGenres_gameGenreID`);

--
-- Indexes for table `CheckoutItems`
--
ALTER TABLE `CheckoutItems`
  ADD PRIMARY KEY (`checkoutItemID`),
  ADD KEY `fk_CheckoutItems_BoardGames_idx` (`BoardGames_boardGameID`),
  ADD KEY `fk_CheckoutItems_Checkouts1_idx` (`Checkouts_checkoutID`);

--
-- Indexes for table `Checkouts`
--
ALTER TABLE `Checkouts`
  ADD PRIMARY KEY (`checkoutID`),
  ADD KEY `fk_Checkouts_Patrons_idx` (`Patrons_patronID`),
  ADD KEY `fk_Checkouts_Staff1_idx` (`Staff_staffID`);

--
-- Indexes for table `GameGenres`
--
ALTER TABLE `GameGenres`
  ADD PRIMARY KEY (`gameGenreID`);

--
-- Indexes for table `Patrons`
--
ALTER TABLE `Patrons`
  ADD PRIMARY KEY (`patronID`),
  ADD UNIQUE KEY `email_UNIQUE` (`email`);

--
-- Indexes for table `Staff`
--
ALTER TABLE `Staff`
  ADD PRIMARY KEY (`staffID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `BoardGames`
--
ALTER TABLE `BoardGames`
  MODIFY `boardGameID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `CheckoutItems`
--
ALTER TABLE `CheckoutItems`
  MODIFY `checkoutItemID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `Checkouts`
--
ALTER TABLE `Checkouts`
  MODIFY `checkoutID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `GameGenres`
--
ALTER TABLE `GameGenres`
  MODIFY `gameGenreID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `Patrons`
--
ALTER TABLE `Patrons`
  MODIFY `patronID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `Staff`
--
ALTER TABLE `Staff`
  MODIFY `staffID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `BoardGames`
--
ALTER TABLE `BoardGames`
  ADD CONSTRAINT `fk_BoardGames_GaneGenres1` FOREIGN KEY (`GameGenres_gameGenreID`) REFERENCES `GameGenres` (`gameGenreID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `CheckoutItems`
--
ALTER TABLE `CheckoutItems`
  ADD CONSTRAINT `fk_CheckoutItems_BoardGames` FOREIGN KEY (`BoardGames_boardGameID`) REFERENCES `BoardGames` (`boardGameID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_CheckoutItems_Checkouts1` FOREIGN KEY (`Checkouts_checkoutID`) REFERENCES `Checkouts` (`checkoutID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Checkouts`
--
ALTER TABLE `Checkouts`
  ADD CONSTRAINT `fk_Checkouts_Patrons` FOREIGN KEY (`Patrons_patronID`) REFERENCES `Patrons` (`patronID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Checkouts_Staff1` FOREIGN KEY (`Staff_staffID`) REFERENCES `Staff` (`staffID`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
