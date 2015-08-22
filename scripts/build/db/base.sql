-- phpMyAdmin SQL Dump
-- version 4.1.8
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Sep 24, 2014 at 10:09 AM
-- Server version: 5.5.37-cll
-- PHP Version: 5.4.23

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `cloneui_gymia_shorty`
--

-- --------------------------------------------------------

--
-- Table structure for table `gymia_shorty_url`
--

CREATE TABLE IF NOT EXISTS `gymia_shorty_url` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `shortcode` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `shortcode_hash` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `url` text COLLATE utf8_unicode_ci NOT NULL,
  `redirect_count` int(10) unsigned NOT NULL DEFAULT '0',
  `date_last_access` int(10) unsigned DEFAULT NULL,
  `date_created` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `shortcode_hash` (`shortcode_hash`),
  KEY `date_created` (`date_created`),
  KEY `date_last_access` (`date_last_access`),
  KEY `redirect_count` (`redirect_count`),
  KEY `shortcode` (`shortcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;