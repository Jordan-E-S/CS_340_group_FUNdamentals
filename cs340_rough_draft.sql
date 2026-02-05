-- phpMyAdmin SQL Dump
-- version 5.2.3-1.el9.remi
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Feb 04, 2026 at 06:29 PM
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
  `gameGenreID` varchar(45) NOT NULL,
  `GameGenres_gameGenreID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `CheckoutItems`
--

CREATE TABLE `CheckoutItems` (
  `checkoutItemID` int(11) NOT NULL,
  `checkoutID` int(11) NOT NULL,
  `boardGameID` int(11) NOT NULL,
  `BoardGames_boardGameID` int(11) NOT NULL,
  `BoardGames_GameGenres_gameGenreID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Checkouts`
--

CREATE TABLE `Checkouts` (
  `checkoutID` int(11) NOT NULL,
  `patronID` int(11) NOT NULL,
  `staffID` int(11) NOT NULL,
  `checkoutDate` date NOT NULL,
  `dueDate` date NOT NULL,
  `returnDate` date DEFAULT NULL,
  `Patrons_patronID` int(11) NOT NULL,
  `Staff_staffID` int(11) NOT NULL,
  `CheckoutItems_checkoutItemID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `GameGenres`
--

CREATE TABLE `GameGenres` (
  `gameGenreID` int(11) NOT NULL,
  `genre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
-- Indexes for dumped tables
--

--
-- Indexes for table `BoardGames`
--
ALTER TABLE `BoardGames`
  ADD PRIMARY KEY (`boardGameID`,`GameGenres_gameGenreID`),
  ADD KEY `fk_BoardGames_GaneGenres1_idx` (`GameGenres_gameGenreID`);

--
-- Indexes for table `CheckoutItems`
--
ALTER TABLE `CheckoutItems`
  ADD PRIMARY KEY (`checkoutItemID`,`BoardGames_boardGameID`,`BoardGames_GameGenres_gameGenreID`),
  ADD KEY `fk_CheckoutItems_BoardGames1_idx` (`BoardGames_boardGameID`,`BoardGames_GameGenres_gameGenreID`);

--
-- Indexes for table `Checkouts`
--
ALTER TABLE `Checkouts`
  ADD PRIMARY KEY (`checkoutID`,`Patrons_patronID`,`Staff_staffID`,`CheckoutItems_checkoutItemID`),
  ADD KEY `fk_Checkouts_Patrons_idx` (`Patrons_patronID`),
  ADD KEY `fk_Checkouts_Staff1_idx` (`Staff_staffID`),
  ADD KEY `fk_Checkouts_CheckoutItems1_idx` (`CheckoutItems_checkoutItemID`);

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
  MODIFY `boardGameID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `CheckoutItems`
--
ALTER TABLE `CheckoutItems`
  MODIFY `checkoutItemID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Checkouts`
--
ALTER TABLE `Checkouts`
  MODIFY `checkoutID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `GameGenres`
--
ALTER TABLE `GameGenres`
  MODIFY `gameGenreID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Patrons`
--
ALTER TABLE `Patrons`
  MODIFY `patronID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Staff`
--
ALTER TABLE `Staff`
  MODIFY `staffID` int(11) NOT NULL AUTO_INCREMENT;

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
  ADD CONSTRAINT `fk_CheckoutItems_BoardGames1` FOREIGN KEY (`BoardGames_boardGameID`,`BoardGames_GameGenres_gameGenreID`) REFERENCES `BoardGames` (`boardGameID`, `GameGenres_gameGenreID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Checkouts`
--
ALTER TABLE `Checkouts`
  ADD CONSTRAINT `fk_Checkouts_CheckoutItems1` FOREIGN KEY (`CheckoutItems_checkoutItemID`) REFERENCES `CheckoutItems` (`checkoutItemID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Checkouts_Patrons` FOREIGN KEY (`Patrons_patronID`) REFERENCES `Patrons` (`patronID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Checkouts_Staff1` FOREIGN KEY (`Staff_staffID`) REFERENCES `Staff` (`staffID`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
