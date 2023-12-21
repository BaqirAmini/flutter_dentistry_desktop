-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 21, 2023 at 12:01 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.0.25

-- Create database
CREATE DATABASE IF NOT EXISTS dentistry_db;
USE dentistry_db;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dentistry_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `apt_ID` int(128) NOT NULL,
  `cli_ID` int(128) NOT NULL,
  `pat_ID` int(128) NOT NULL,
  `service_ID` int(11) DEFAULT NULL,
  `installment` int(2) DEFAULT 1,
  `round` int(2) NOT NULL DEFAULT 1,
  `discount` double(12,2) DEFAULT NULL,
  `total_fee` decimal(12,2) DEFAULT 0.00,
  `paid_amount` decimal(12,2) NOT NULL,
  `due_amount` decimal(12,2) NOT NULL,
  `meet_date` date DEFAULT NULL,
  `staff_ID` int(128) DEFAULT NULL,
  `note` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`apt_ID`, `cli_ID`, `pat_ID`, `service_ID`, `installment`, `round`, `discount`, `total_fee`, `paid_amount`, `due_amount`, `meet_date`, `staff_ID`, `note`) VALUES
(43, 0, 72, 2, 5, 1, 5.00, '0.00', '850.00', '2150.00', '2023-11-21', 17, NULL),
(46, 0, 75, 7, 1, 1, 0.00, '0.00', '1000.00', '1000.00', '2023-11-15', 17, NULL),
(47, 0, 76, 15, 5, 1, 10.00, '0.00', '3500.00', '10000.00', '2023-11-23', 17, NULL),
(48, 0, 79, 7, 1, 1, 0.00, '0.00', '1500.00', '0.00', '2023-11-25', 17, NULL),
(49, 0, 80, 9, 6, 1, 15.00, '0.00', '500.00', '1625.00', '2023-11-01', 17, NULL),
(50, 0, 81, 12, 1, 1, 5.00, '0.00', '950.00', '0.00', '2023-11-09', 17, NULL),
(51, 0, 82, 7, 6, 1, 0.00, '0.00', '1200.00', '8800.00', '2023-12-04', 17, NULL),
(52, 0, 84, 5, 1, 1, 5.00, '0.00', '1425.00', '0.00', '0000-00-00', 17, NULL),
(55, 0, 86, 3, 0, 1, 0.00, '0.00', '0.00', '0.00', '2023-12-08', 17, NULL),
(58, 0, 80, 3, 0, 1, 0.00, '0.00', '1000.00', '0.00', '2023-12-08', 17, NULL),
(59, 0, 80, 8, 0, 1, 0.00, '0.00', '500.00', '0.00', '2023-12-08', 17, NULL),
(60, 0, 81, 13, 2, 1, 0.00, '0.00', '500.00', '500.00', '2023-12-07', 17, NULL),
(61, 0, 82, 12, 2, 1, 0.00, '0.00', '600.00', '600.00', '2023-12-09', 17, NULL),
(63, 0, 86, 3, 1, 2, 5.00, '0.00', '500.00', '200.00', '2023-12-11', 17, NULL),
(64, 0, 86, 2, 4, 1, 0.00, '0.00', '1000.00', '3000.00', '2023-12-07', 17, NULL),
(68, 0, 84, 11, 0, 2, 0.00, '0.00', '3000.00', '0.00', '2023-12-14', 17, NULL),
(69, 0, 84, 1, 0, 3, 0.00, '0.00', '500.00', '0.00', '2023-12-14', 17, NULL),
(74, 0, 92, 14, 0, 1, 0.00, '0.00', '800.00', '0.00', '2023-12-14', 17, NULL),
(77, 0, 92, 1, 0, 2, 0.00, '0.00', '700.00', '0.00', '2023-12-14', 17, NULL),
(79, 0, 93, 7, 7, 2, 15.00, '0.00', '890.00', '2000.00', '2023-12-18', 17, NULL),
(80, 0, 86, 7, 0, 3, 0.00, '0.00', '500.00', '0.00', '2023-12-17', 17, NULL),
(81, 0, 86, 7, 0, 4, 2.00, '0.00', '588.00', '0.00', '2023-12-17', 17, NULL),
(82, 0, 86, 3, 0, 5, 0.00, '0.00', '450.00', '0.00', '2023-12-11', 17, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `clinics`
--

CREATE TABLE `clinics` (
  `cli_ID` int(128) NOT NULL,
  `cli_logo` varchar(128) DEFAULT 'logo.png',
  `cli_name` varchar(64) NOT NULL,
  `open_date` date DEFAULT NULL,
  `cli_addr` varchar(64) DEFAULT NULL,
  `founder` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `clinics`
--

INSERT INTO `clinics` (`cli_ID`, `cli_logo`, `cli_name`, `open_date`, `cli_addr`, `founder`) VALUES
(1, 'logo.png', 'testing', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `conditions`
--

CREATE TABLE `conditions` (
  `cond_ID` int(11) NOT NULL,
  `name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `conditions`
--

INSERT INTO `conditions` (`cond_ID`, `name`) VALUES
(1, 'آیا دچار افت فشار خون و یا بلند رفتن فشار خون که موجب بعضی علایم یا مشکلات گردد، هستید؟'),
(2, 'امراض قلبی دارید و یا قبلا دچار آن شده اید؟'),
(4, 'داشتن امراض جلدی و یا حساسیت جلدی'),
(5, 'آیا زردی سیاه دارید؟'),
(6, 'درد در قفسه سینه'),
(7, 'آیا حمل دارید اگر بله، چند مدت میشود؟'),
(8, 'آیا دخانیات مصرف میکنید؟'),
(9, 'سابقه مرض شکر');

-- --------------------------------------------------------

--
-- Table structure for table `condition_details`
--

CREATE TABLE `condition_details` (
  `cond_detail_ID` int(128) NOT NULL,
  `cond_ID` int(11) DEFAULT NULL,
  `result` tinyint(1) NOT NULL DEFAULT 0,
  `severty` varchar(64) DEFAULT NULL,
  `duration` varchar(64) DEFAULT NULL,
  `diagnosis_date` date DEFAULT NULL,
  `pat_ID` int(128) DEFAULT NULL,
  `notes` tinytext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `condition_details`
--

INSERT INTO `condition_details` (`cond_detail_ID`, `cond_ID`, `result`, `severty`, `duration`, `diagnosis_date`, `pat_ID`, `notes`) VALUES
(17, 1, 0, NULL, NULL, NULL, 72, NULL),
(18, 2, 0, NULL, NULL, NULL, 72, NULL),
(19, 4, 1, NULL, NULL, NULL, 72, NULL),
(20, 5, 0, NULL, NULL, NULL, 72, NULL),
(21, 6, 0, NULL, NULL, NULL, 72, NULL),
(22, 7, 0, NULL, NULL, NULL, 72, NULL),
(23, 8, 0, NULL, NULL, NULL, 72, NULL),
(24, 9, 0, NULL, NULL, NULL, 72, NULL),
(41, 1, 1, NULL, NULL, NULL, 75, NULL),
(42, 2, 0, NULL, NULL, NULL, 75, NULL),
(43, 4, 0, NULL, NULL, NULL, 75, NULL),
(44, 5, 0, NULL, NULL, NULL, 75, NULL),
(45, 6, 1, NULL, NULL, NULL, 75, NULL),
(46, 7, 0, NULL, NULL, NULL, 75, NULL),
(47, 8, 0, NULL, NULL, NULL, 75, NULL),
(48, 9, 0, NULL, NULL, NULL, 75, NULL),
(49, 1, 0, NULL, NULL, NULL, 76, NULL),
(50, 2, 0, NULL, NULL, NULL, 76, NULL),
(51, 4, 0, NULL, NULL, NULL, 76, NULL),
(52, 5, 1, NULL, NULL, NULL, 76, NULL),
(53, 6, 0, NULL, NULL, NULL, 76, NULL),
(54, 7, 0, NULL, NULL, NULL, 76, NULL),
(55, 8, 0, NULL, NULL, NULL, 76, NULL),
(56, 9, 0, NULL, NULL, NULL, 76, NULL),
(57, 1, 0, NULL, NULL, NULL, 79, NULL),
(58, 2, 0, NULL, NULL, NULL, 79, NULL),
(59, 4, 1, 'شدید', 'بیشتر', '2022-10-19', 79, 'بعضی خوراکها مثل غله جات بیشترش میکند'),
(60, 5, 0, NULL, NULL, NULL, 79, NULL),
(61, 6, 0, NULL, NULL, NULL, 79, NULL),
(62, 7, 0, NULL, NULL, NULL, 79, NULL),
(63, 8, 1, 'نامعلوم', 'نامعلوم', '0000-00-00', 79, ''),
(64, 9, 0, NULL, NULL, NULL, 79, NULL),
(65, 1, 0, NULL, NULL, NULL, 80, NULL),
(66, 2, 1, 'نامعلوم', '1 ماه', '2023-11-22', 80, 'سییییسیشسشس'),
(67, 4, 0, NULL, NULL, NULL, 80, NULL),
(68, 5, 1, 'شدید', '6 ماه', '2023-11-29', 80, ''),
(69, 6, 0, NULL, NULL, NULL, 80, NULL),
(70, 7, 1, 'خفیف', '1 هفته', '2023-11-03', 80, 'سسسسسسسسسسسسسسسسسببب'),
(71, 8, 0, NULL, NULL, NULL, 80, NULL),
(72, 9, 0, NULL, NULL, NULL, 80, NULL),
(73, 1, 1, 'شدید', 'نامعلوم', NULL, 81, 'فقط فشار خون بالا دارد'),
(74, 2, 0, NULL, NULL, NULL, 81, NULL),
(75, 4, 0, NULL, NULL, NULL, 81, NULL),
(76, 5, 0, NULL, NULL, NULL, 81, NULL),
(77, 6, 1, 'متوسط', '1 ماه', NULL, 81, NULL),
(78, 7, 0, NULL, NULL, NULL, 81, NULL),
(79, 8, 0, NULL, NULL, NULL, 81, NULL),
(80, 9, 0, NULL, NULL, NULL, 81, NULL),
(81, 1, 0, NULL, NULL, NULL, 82, NULL),
(82, 2, 0, NULL, NULL, NULL, 82, NULL),
(83, 4, 1, 'شدید', '1 ماه', NULL, 82, NULL),
(84, 5, 0, NULL, NULL, NULL, 82, NULL),
(85, 6, 0, NULL, NULL, NULL, 82, NULL),
(86, 7, 0, NULL, NULL, NULL, 82, NULL),
(87, 8, 1, 'شدید', 'بیشتر', '2020-12-25', 82, 'بیشتر از سه سال'),
(88, 9, 0, NULL, NULL, NULL, 82, NULL),
(95, 1, 0, NULL, NULL, NULL, 84, NULL),
(96, 2, 0, NULL, NULL, NULL, 84, NULL),
(97, 4, 0, NULL, NULL, NULL, 84, NULL),
(98, 5, 0, NULL, NULL, NULL, 84, NULL),
(99, 6, 1, 'خفیف', '1 ماه', NULL, 84, NULL),
(100, 7, 0, NULL, NULL, NULL, 84, NULL),
(101, 8, 0, NULL, NULL, NULL, 84, NULL),
(102, 9, 0, NULL, NULL, NULL, 84, NULL),
(111, 1, 0, NULL, NULL, NULL, 86, NULL),
(112, 2, 0, NULL, NULL, NULL, 86, NULL),
(113, 4, 0, NULL, NULL, NULL, 86, NULL),
(114, 5, 0, NULL, NULL, NULL, 86, NULL),
(115, 6, 0, NULL, NULL, NULL, 86, NULL),
(116, 7, 0, NULL, NULL, NULL, 86, NULL),
(117, 8, 0, NULL, NULL, NULL, 86, NULL),
(118, 9, 1, 'متوسط', 'نامعلوم', '2018-12-05', 86, 'خیلی وقت پیش داشت'),
(155, 1, 0, NULL, NULL, NULL, 92, NULL),
(156, 2, 0, NULL, NULL, NULL, 92, NULL),
(157, 4, 0, NULL, NULL, NULL, 92, NULL),
(158, 5, 0, NULL, NULL, NULL, 92, NULL),
(159, 6, 1, 'خفیف', '6 ماه', '2023-07-16', 92, NULL),
(160, 7, 0, NULL, NULL, NULL, 92, NULL),
(161, 8, 0, NULL, NULL, NULL, 92, NULL),
(162, 9, 0, NULL, NULL, NULL, 92, NULL),
(163, 1, 0, NULL, NULL, NULL, 86, NULL),
(164, 2, 0, NULL, NULL, NULL, 86, NULL),
(165, 4, 0, NULL, NULL, NULL, 86, NULL),
(166, 5, 0, NULL, NULL, NULL, 86, NULL),
(167, 6, 1, 'شدید', 'نامعلوم', '2021-12-26', 86, ''),
(168, 7, 0, NULL, NULL, NULL, 86, NULL),
(169, 8, 0, NULL, NULL, NULL, 86, NULL),
(170, 1, 0, NULL, NULL, NULL, 93, NULL),
(171, 9, 0, NULL, NULL, NULL, 86, NULL),
(172, 2, 0, NULL, NULL, NULL, 93, NULL),
(173, 4, 0, NULL, NULL, NULL, 93, NULL),
(174, 5, 0, NULL, NULL, NULL, 93, NULL),
(175, 6, 1, 'شدید', 'نامعلوم', '2021-12-26', 93, ''),
(176, 7, 0, NULL, NULL, NULL, 93, NULL),
(177, 8, 0, NULL, NULL, NULL, 93, NULL),
(178, 9, 0, NULL, NULL, NULL, 93, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

CREATE TABLE `expenses` (
  `exp_ID` int(128) NOT NULL,
  `cli_ID` int(128) NOT NULL,
  `exp_name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `expenses`
--

INSERT INTO `expenses` (`exp_ID`, `cli_ID`, `exp_name`) VALUES
(5, 0, 'تجهیزات کلینیک'),
(6, 0, 'خوراک'),
(7, 0, 'نیازمندیهای صحی'),
(10, 0, 'مصارف شهرداری');

-- --------------------------------------------------------

--
-- Table structure for table `expense_detail`
--

CREATE TABLE `expense_detail` (
  `exp_detail_ID` int(128) NOT NULL,
  `exp_ID` int(128) NOT NULL,
  `cli_ID` int(128) NOT NULL,
  `purchased_by` int(128) NOT NULL,
  `item_name` varchar(64) NOT NULL,
  `quantity` double(12,2) NOT NULL,
  `qty_unit` varchar(64) DEFAULT NULL,
  `unit_price` decimal(6,2) NOT NULL,
  `total` decimal(12,2) NOT NULL,
  `purchase_date` date NOT NULL,
  `invoice` varchar(128) DEFAULT NULL,
  `note` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `expense_detail`
--

INSERT INTO `expense_detail` (`exp_detail_ID`, `exp_ID`, `cli_ID`, `purchased_by`, `item_name`, `quantity`, `qty_unit`, `unit_price`, `total`, `purchase_date`, `invoice`, `note`) VALUES
(7, 5, 0, 17, 'میز کار', 1.00, 'متر', '1200.00', '1200.00', '2020-07-31', NULL, 'واحد نیز اضافه شد.'),
(15, 5, 0, 23, 'فرش', 7.00, 'متر', '750.00', '5250.00', '2022-07-04', NULL, 'موکت متوسط با رنگ سرخ'),
(17, 5, 0, 21, 'موبل', 3.00, 'عدد', '1150.00', '3450.00', '2023-06-21', NULL, 'سه تا کوچ برای اتاق انتظار'),
(18, 7, 0, 23, 'قالب دندان', 30.00, 'عدد', '200.00', '6000.00', '2023-10-01', NULL, 'قالب دندان بزرگسال');

-- --------------------------------------------------------

--
-- Table structure for table `fee_payments`
--

CREATE TABLE `fee_payments` (
  `payment_ID` int(11) NOT NULL,
  `installment_counter` int(11) DEFAULT 1,
  `payment_date` date NOT NULL,
  `paid_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `due_amount` decimal(12,2) DEFAULT 0.00,
  `whole_fee_paid` tinyint(1) DEFAULT 0,
  `staff_ID` int(11) DEFAULT NULL,
  `apt_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `pat_ID` int(128) NOT NULL,
  `cli_ID` int(128) NOT NULL,
  `staff_ID` int(128) NOT NULL,
  `firstname` varchar(64) NOT NULL,
  `lastname` varchar(64) DEFAULT NULL,
  `sex` varchar(6) NOT NULL DEFAULT 'Male',
  `age` int(3) NOT NULL,
  `marital_status` varchar(16) DEFAULT NULL,
  `phone` varchar(12) DEFAULT NULL,
  `reg_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `blood_group` varchar(12) DEFAULT NULL,
  `address` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`pat_ID`, `cli_ID`, `staff_ID`, `firstname`, `lastname`, `sex`, `age`, `marital_status`, `phone`, `reg_date`, `blood_group`, `address`) VALUES
(72, 0, 17, 'ثریا', '', 'مرد', 10, 'مجرد', '0772020420', '2023-11-24 04:37:48', 'نامعلوم', 'Kabul, Kartiparwan'),
(75, 0, 17, 'فایقه', 'رحمتی', 'زن', 22, 'مجرد', '0791022322', '2023-11-24 15:37:13', 'AB+', 'کابل، قلعه شهاده'),
(76, 0, 17, 'زهره', 'نوروزی', 'زن', 30, 'مجرد', '0771232322', '2023-11-25 06:34:08', 'نامعلوم', ''),
(79, 0, 17, 'حسین', 'احسانی', 'مرد', 24, 'متأهل', '0701010203', '2023-11-26 15:55:20', 'O-', 'کابل، کارته سه'),
(80, 0, 17, 'ملیحه', '', 'زن', 27, 'متأهل', '0791023232', '2023-11-26 16:19:04', 'نامعلوم', ''),
(81, 0, 17, 'Fatima', 'Rahimi', 'زن', 38, 'متأهل', '0702020232', '2023-11-26 16:28:49', 'AB+', ''),
(82, 0, 17, 'میرزاحسین', 'فیضی', 'مرد', 27, 'متأهل', '0700010232', '2023-12-05 16:15:47', 'نامعلوم', ''),
(84, 0, 17, 'Rahim', 'Nasimi', 'مرد', 26, 'مجرد', '0771023232', '2023-12-06 16:23:38', 'نامعلوم', ''),
(86, 0, 17, 'علی مامد', 'امیری', 'مرد', 26, 'متأهل', '0772737310', '2023-12-08 06:47:24', 'نامعلوم', 'کابل، برچی سنتر'),
(92, 0, 17, 'عالیه', 'فخری', 'زن', 9, 'مجرد', '0701023232', '2023-12-14 06:34:17', 'نامعلوم', ''),
(93, 0, 17, 'Samim', 'Hamidi', 'مرد', 25, 'مجرد', '۰۷۷۲۳۰۳۲۰۰', '2023-12-17 06:13:41', 'O+', '');

-- --------------------------------------------------------

--
-- Table structure for table `patient_services`
--

CREATE TABLE `patient_services` (
  `ps_ID` int(11) NOT NULL,
  `pat_ID` int(11) NOT NULL,
  `ser_ID` int(11) NOT NULL,
  `req_ID` int(11) NOT NULL,
  `value` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patient_services`
--

INSERT INTO `patient_services` (`ps_ID`, `pat_ID`, `ser_ID`, `req_ID`, `value`) VALUES
(1, 86, 1, 1, 'Q3-6'),
(2, 86, 1, 2, 'توضیحات مربوط به implant'),
(3, 86, 15, 1, 'Q4-3'),
(4, 86, 15, 2, 'Testing implant description'),
(5, 86, 15, 1, 'Q3-3'),
(6, 86, 15, 2, 'Doing implant service '),
(7, 84, 11, 1, 'Q1-3,Q1-2'),
(8, 84, 11, 3, 'R.C.T'),
(9, 84, 11, 4, 'Metal-Porcelain'),
(10, 84, 11, 2, 'این دو دندان نیاز به پوش دارد'),
(11, 84, 1, 1, 'Q3-5'),
(12, 84, 1, 2, 'عصب کشی دندان پنجم پایین راست'),
(18, 92, 14, 2, 'طرح لبخند باید اصلاح شود'),
(19, 92, 8, 2, 'معاینه دهن و دندان'),
(20, 92, 5, 2, 'ارتوانسی انجام شود'),
(21, 92, 5, 4, 'هردو فک'),
(22, 92, 1, 1, 'Q2-B'),
(23, 92, 1, 2, ''),
(24, 93, 7, 3, 'Abscess Treatment'),
(25, 93, 7, 1, 'Q2-4'),
(26, 93, 7, 9, 'راست'),
(27, 93, 7, 2, ''),
(28, 93, 7, 3, 'Abscess Treatment'),
(29, 93, 7, 1, 'Q3-5,Q3-6'),
(30, 93, 7, 2, 'Confirm affected area no longer needed'),
(31, 86, 7, 3, 'Abscess Treatment'),
(32, 86, 7, 1, 'Q2-8'),
(33, 86, 7, 2, ''),
(34, 86, 7, 3, 'Abscess Treatment'),
(35, 86, 7, 1, 'Q1-4'),
(36, 86, 7, 2, 'Another tooth damaged'),
(37, 86, 3, 2, 'سفید کردن دندان'),
(38, 86, 3, 5, 'دو مرحله');

-- --------------------------------------------------------

--
-- Table structure for table `services`
--

CREATE TABLE `services` (
  `ser_ID` int(128) NOT NULL,
  `ser_name` varchar(64) NOT NULL,
  `ser_fee` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `services`
--

INSERT INTO `services` (`ser_ID`, `ser_name`, `ser_fee`) VALUES
(1, 'عصب کشی(R.C.T)', '999.99'),
(2, 'پرکاری(Filling)', '0.00'),
(3, 'سفید کردن', '0.00'),
(4, 'Scaling and Polishing', '0.00'),
(5, 'Orthodontics', '0.00'),
(7, 'Maxillofacial Surgery', '0.00'),
(8, 'Oral Examination', '0.00'),
(9, 'Denture', '0.00'),
(11, 'پوش کردن(Crown)', '0.00'),
(12, 'Flouride Therapy', '0.00'),
(13, 'Night Gaurd Prothesis', '0.00'),
(14, 'Snap-on Smile', '0.00'),
(15, 'Implant', '0.00'),
(16, 'Smile Design Correction', '0.00');

-- --------------------------------------------------------

--
-- Table structure for table `service_requirements`
--

CREATE TABLE `service_requirements` (
  `req_ID` int(11) NOT NULL,
  `req_name` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `service_requirements`
--

INSERT INTO `service_requirements` (`req_ID`, `req_name`) VALUES
(1, 'Teeth Selection'),
(2, 'Description'),
(3, 'Procedure Type'),
(4, 'Materials'),
(5, 'Bleaching Steps'),
(7, 'Gum Selection'),
(9, 'Affected Area');

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `staff_ID` int(128) NOT NULL,
  `firstname` varchar(64) NOT NULL,
  `lastname` varchar(64) NOT NULL,
  `position` varchar(32) DEFAULT NULL,
  `salary` decimal(10,3) DEFAULT NULL,
  `phone` varchar(12) NOT NULL,
  `tazkira_ID` varchar(16) DEFAULT NULL,
  `photo` mediumblob DEFAULT NULL,
  `address` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`staff_ID`, `firstname`, `lastname`, `position`, `salary`, `phone`, `tazkira_ID`, `photo`, `address`) VALUES
(17, 'امین الله', 'حبیبی', 'نرس', '6500.000', '0771020220', '1399-1232-23236', 0xffd8ffe000104a46494600010100000100010000ffdb008400090607101110101210121010100f100f0f100f100f0f0d0f0f0f1511161615111515181d2820181a251b151521312125292b2e2e2e171f3f38352d43282d322b010a0a0a0505050e05050e2b1913192b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2bffc000110800bf010803012200021101031101ffc4001c0000020203010100000000000000000000040503060001020708ffc400381000010303030303010507030500000000010002030411210512314151610622711314324281a1072443526291b11523723353c1d2f1ffc40014010100000000000000000000000000000000ffc40014110100000000000000000000000000000000ffda000c03010002110311003f00f0e58b16dad248001249b0005c93d820db185c40682493600724abd7a67486c0d2f7e6670e7a30765068fa3b6999f52500cee186f222047f946d25560dcfe7dd01ae7647ca68d7e1208a7bb87437c0f09c6e410d44d6919f9a6f04cabf2e6509831f6404fd4b3cb475174ae48ddf52d6c5f95bae9f6bd8ebf5b29a4a917ba02591d88053163f0ab7fea5ba400744d6296e1013532e5bf28b8e4091d4c977342344880999e2e849d8de6e86af90ede509f6a1b45ca0611b1adeb8455254ee76380abf2d700394cf467dc5fba0b3c72e1746441c6548e7d9012c9d63a64bcbcdf0b535413d101ec9aea76c89553c851cd7a09677dda414a5d207023b23267e1207d46d948e850130bec4a61a4befb8f949bed4cc84e349b060b753740ee35d3ce140c7a8ea6536b20d8a821d8543fda07a2feaefaba3692fcba78064bfbc8cf3dc75ff00376863c5ca221bb4dc1fc907cdeb17aafed1fd0bf53f7ca165dce3fbcd3306779fe2b079ea3f3eeb1079535a49000b938006493d95e7d3ba18a76fd494033b87b5bcfd21ff00b2efd31e9d108fad30065fc0ce447e7e53b90725026d52a2cd713d6ffdd5763d41cd05be70ac1adc3789e47005ff005554df8e103dd05c5ee24e6cacec3c249e9ca62d8838f2f37fc93f8d8802fe37e48a7b9410b3fdc2510f6a053ac4c43078295bf537b8630996b4c2586dc8c9f855e6bf081ae8a497927956a8557b40a53b77f42ac9137080678f7846285acca21c30815ea8e3b0fc2acfd777756baf84b98e03f94aa7075ae0f42808858e7bdadf2aefa641b401d82aff00a5e88b8990fc355c69e0b0413c617320b95335b8582341cb235b9225280a42d401c71a202cd8bab201a7182aa5ea0739b670e2f62ae12048f57a5dd1483b0b8f9082aad91ef735b7c9215fb4c8f6b1a3c2a97a4684be42f2303015da18ec80d8972f65caee30a50d41cb18a50d5a6853008350dda70b1761ab1079edd46f2ba51b900d5306e8e41fccd2150e3613208ff1176db79bd97a10e0aaee87421da83de47b186e3fe5d10599b00606b00c31a07e8886b70b72fde2a563500b1c395d3d88b0c5c3d8817be0beec722ca912407ea98860eeb7eabd09adc955ba8a2fdf9aeee82c14748191b1b6e0046c6cc2db8607c292308386c2ba746a70169c1008d885d5275fa22c9c06f121b857d6b72916ad4e1f345e0a077a0510644d1d87ea9a8628a81966d910c083a6b5741ab6d52b5a8220d5d594a62525353ee3e100e23bf0b1f0b87213b8e983785d4ec05a50568b5075f17b5de414d0b73841ea8d01a816fa569835a7e4a79b3dc95fa65c1c0f829e399ee41a8daa6dab1ac4447120858c52069443635b70410058a6d985883cd5b1a8aa5e1a2dd54126a62c81754ee37280b74bed3f0a3f4d01ef3ddc81afad0d61e3016bd1d5e1db81e6fc20b3c9f78a9632b365f2bb6b1074172e6952c765d3a40805636d7492777ef4cf8c26f5d56c6039173d151756d50b6a2378fc2723c20f476b6ed0a68a2c21b4aab64b1b5cd20870ba61b8041c862e9d10b2c0e5c3ea4754103c5b3d121a99c7da22fea240466a1a9338042a46b9a913331cc3ff004cdd07ab529f6d8728d863552d17d510bc3777b5d6b10ac71ea4d23da8193235d39c0204555872847578bf281b3661d532a5b58595326aeb1e533d0f5e63896dc5c77e505ac286a4e0a1bfd48785c49a931df28050ccdd24d76a006b8df807fc271573b58c26f9ecbcfbd5daa00c7341f7498b760826fd9eeaa1c658dc7ddb8917ed75e891107aaf05a1a8743236461b169cf91d42f4dd375bfa8c6b9879e47641766357648091536b22deefeeb736a80fdd40d249fca18d7d9c01384b0d49282a8a9e0a0b8c13b1dd562a5bb51b1f695883cddf54b7f6cb0f84b65950553504e0209351af321b0e07eaa1a3ac7c4e0e61b1086dab7b505f34cf51ef6804d8f54ea2d441eabcb19706e138a1d49d6b1282f8fd41a3aa575bae817b1baaf49504dee50324ddb280fafd509c93949259b7b892bb7c65c72b629d019a36af243701c437a056aa0f52f1b8dd535b4b753b299c82f337aa2303955ed47d52e79f65c04ac5213caedb45e107326a4e22c064f5419b9e7aa3c4002e9b104003370cb7164fb4cd7646d812a06d1aebec482cd4fa83ddd6e0a98cc40baae41f519f74a9659a63cbb1e1011a96adb01cdca4706ad2324de30a6960279ca1dd4e82e7a57a9639058bac7a82983b5a68bedcaf38fb3f51ed23b295b3483aa0b76a3ad122e4d82a6d654ba47973bbe3e16a52f772eba848b20c28dd37517c27196f6405d741c105b69f5e0fb5cdbc26f4f5c3b85e7a1c898ab1e3871417f9abc01c809157eb37c3522755bddcb89fcd701c80f875091a49bdeeb16a8a85f266d61d2fd5620ac4b35d4165adeb5f51048d6dd48225cd3dca3a2a52500ed814f1d285c4f1b987c2e1957df080afb28eea58e99a81357e56d9548198a76aec42d4b995574430b8a03991b14ad6352f6071e146f99c3940d806ae816a4a6acad0acbf5407d4b9b75132568232822e2f700324e2cac7a5fa5dd2004dfc941189db61c2dfd61d93b1e9568b6485dc9a4fd31c5c774084d4b569b517e05d31ada46ed26cb9d2b4f3b49b7f74027d99e780a192865fe5bab0460b7946d351b9dce020a34ac737ef0b28ec4f017a23f466b810e1748ab7493113b45da82aaf611c843ce9e56465c0e32109a3e9af9ddf74d81b2056c81ce3600a7da7e898bbb2ac745e9a23ff00899b7467018050551fa534fe158ed0c5b8b1575a7d19e45cf451d4d110320dd079dd4696f6b8340bdcd93da1d040b5c6792ad3a7e82643bdd80381d53b8f4b6b78082b30d1f4b70b15b050b4745883e6c9d9b4a929e98b930ada6b8445053e100f4f4f646440f44c21a3be11d47401b928144b43239b7b24d5740e1e0af448ac71842d6e9ad71bd9079bc9116f2a7a3a72f38577a8d058f69c5b1cf64ab47d39d0bdcd70be7050669de9c7bf36b0f29fd37a6ed826e9b53fb404c2393b2046df4ac87ee5add90d3fa52a0ff0c9f22caeba6546484e18f41e651fa3e4fe23768406a5e8a2dbba2779da7ff0bd3b5796c0794924903814141f4950de576e1ee69b58af52a38f634003e554b4b89ada975bf1655b5cec04049682b7f441e8876c8a66ca804acd19afcb45ad9b774352e9d7c716e89dc73ac0d17ba007fd21873d9122880533a50a174a5070e2004aaaac4a9ea9e8106eeb2045ae53002edc12acfe9ca06c7134002ee00936ea82d4a88168f0414df4d78da3c0010346b4052b6c826c9953b64406342e5d1b6f91750898adfd540546d6f0301733c80214cc470a2321412fd7588571bac41e35345ed5269a336eca6747ed3f082d1e5bb9de0a07b161101c8463d4c1c8270a66cf8ca15ae5b25016d9ba25d52fff007010a40fc8406b354d8dcc3fcc4041646bc6d0a58e441c5202c0bb63d0318e620823a266dd640031948448bb6b90195556e90dca85afca85cf5c325ca0062a86b6b1ad26db8615b267602f2dd76a8fdac3da73171fe55ff4dd45b514ec95bf0e1d9c390819b1ca76bd0513d4ae92c80b0e526f2838a55387a09095c172e5ef51ef402553f29717d9c8d9f92809da80dab9c089ce3d022343983d81c3b2435f55fecb878517a2f51fbd138e79082e21d95331c806c9944c6e406072da1f72e992209c85190bb0f5c928232b163de1690797b9b83f055674b9b6cae1dc9565a87581f82aa119b3efe505ae37a9dae4053c974630a0ec49953976105272a66b90648e487d4afdce678174e2672afea4fdcff8081dfa73522e6163b96f1ff14f21915168a42c7b5c3e0fc2b751c9b85d033df852432281bc2e23363640639d8424f25912d184255b3082a353ee91e4ff00314efd1f5df4dee89d86cb96f8704aaa1803c85c34ed2d766ed20841e9503ba223909769d36f635c387005306a08a196ce20a31b2a02a59f887216e39ae80e739405eb832617174135ae87960ba9e1370ba70415fd663db1bacabb47318ded78c1055b75986ec29445a602dbf84160a3ae0fb1ee9a4322ac69d06c3b7cab0538406b9cb812adf442d403d103064ab99674ba99ee3dd1460250684b75b5cb62b2c41e6fa81f69f82aae4655ab50183e02431d0b9d73d1015a73fda13588a0e8694016098c71a08a40a588616491a9206a01e76e157eae2264360ad925392838687dc4a0ae7d9dfd8ab268fb8b4299d4b85de9f116bb6a06310365ccadc828a8e35c4f1141d47c28e78ae14f003d94fb7c20af45a3ee7925172e90c2d38e1336585c85089ecef0794037a65ce66e89df8492df82ac6c094bac246bda33c14e5bc208651842c305c947bdb75b8a3b04030856cc4514e0b61a8038ae1d6e8518c615a9225dd3baff0092082b29aec721228006821377371f297c4dbdd87a1242011d4a4bb704c69a3364252920904fc2650209991ac92253316dcd410d2c3644ec5a605d5f08232c0b16d81620f21d13546d40d8fb0985edd9e3c79f09a434e322cbcea379690e6921cd37046083dd5df43d73ebb763acd9873d3ea0ee3ca02994e03b08d8a9d4645884c20b1b201dd0785d414e8d2c5b898820744857b2d74d5ecc216766102d6b0a2631620a885ee89873ca063036e2ebb7c570a2a37744583841153b14ee661730299c1005200d05280e2492139a9e0fc25b6b202a9f361d5388860253496b8f84e698fb5066c596b296cb97a01c92b4c9575b821db2b4b8b7aa06119057259b4dfa150c2edb8466db84197424cdb3afdd1318e854756dc03d90289a41bafd8a674cfe3ca5f3402f7ee89a697007640d98a5214113ae029c0419642be437c22a41843b5b8cf2826a676e0562869c1c8e7e1620f9d1751c85a439a487037046082b95882fba06aeda966d759b3b05c8e04807e21e7c271049fa2f2d865731c1cd25ae69b82304157ff4eea7f686125b691960fb7dd77f50ec82c6c370a489410a9e3720ede10352e46bcdd2e99043805761ca170530405533f3f298b4a5716484ce328371f2a72a20d5d92805a8e0a011f53c1401282683042774bc24709c84de98ff008406851cc548d0b898205f249cd90190ebf5461ea8670406d2cdb86794c2924e9d9216bb69c2614efe0a066f19bac7916b7758c370b2339b205b52c363e1434c2c45f84c2a5b9296ec3b8e701038a672363094d3bad64d217a090f1c280c45d81d51805cdbbaa3fed33d5cea306929c16d448cbc937fdb8ddd19fd4739e8801f5efad4400d251b87d506d34edcfd33fc8d3dfb9e8b1795727cac41ffd9, 'کابل، دارلامان'),
(21, 'حسین خان', 'احسانی', 'مدیر سیستم', '35000.000', '0771023322', '', NULL, 'کابل، افغانستان'),
(23, 'راحله', 'احمدی', 'نرس', '17500.000', '0771023232', '1399-2323-23232', NULL, 'کابل، افغانستان'),
(26, 'خسرو خان', 'بلخی', 'داکتر دندان', '70000.000', '0771023232', '1401-2323-23232', NULL, 'مرکز بلخ'),
(29, 'عبدالعلی', 'حیدری', 'داکتر دندان', '0.000', '0771023234', '', NULL, ''),
(30, 'میثم', 'رحمتی', 'نرس', '0.000', '0771010201', '1402-2322-23233', NULL, ''),
(31, 'ثریا', 'رحیمی', 'داکتر دندان', '0.000', '0780810232', '', NULL, 'کابل، مکروریان چهارم'),
(32, 'Wali', 'Nabizada', 'مدیر سیستم', '10000.000', '+93771023232', '1402-2323-23823', NULL, 'kabul, Afghanistan');

-- --------------------------------------------------------

--
-- Table structure for table `staff_auth`
--

CREATE TABLE `staff_auth` (
  `auth_ID` int(128) NOT NULL,
  `staff_ID` int(11) NOT NULL,
  `username` varchar(64) NOT NULL,
  `password` varchar(64) NOT NULL,
  `role` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `staff_auth`
--

INSERT INTO `staff_auth` (`auth_ID`, `staff_ID`, `username`, `password`, `role`) VALUES
(17, 17, 'amin1402', '*E0D513F4199D61413331CA06AC795ED2BF8BF83F', 'مدیر سیستم');

-- --------------------------------------------------------

--
-- Table structure for table `taxes`
--

CREATE TABLE `taxes` (
  `tax_ID` int(128) NOT NULL,
  `annual_income` double(15,2) NOT NULL,
  `tax_rate` decimal(12,2) DEFAULT NULL,
  `total_annual_tax` decimal(15,2) NOT NULL,
  `TIN` char(10) DEFAULT NULL,
  `tax_for_year` int(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `taxes`
--

INSERT INTO `taxes` (`tax_ID`, `annual_income`, `tax_rate`, `total_annual_tax`, `TIN`, `tax_for_year`) VALUES
(10, 300000.00, '10.00', '30000.00', '1023232232', 1300),
(12, 50000.00, '10.00', '5000.00', '1002232322', 1301),
(13, 100000.00, '12.00', '12000.00', '1002012323', 1302),
(14, 200000.00, '15.00', '30000.00', '2000223223', 1303),
(15, 180000.00, '18.00', '32400.00', '3000303309', 1304),
(16, 300000.00, '15.00', '45000.00', '1002012323', 1305),
(17, 700000.00, '18.50', '129500.00', '4000423232', 1306),
(20, 200000.00, '15.00', '30000.00', '1002323230', 1402);

-- --------------------------------------------------------

--
-- Table structure for table `tax_payments`
--

CREATE TABLE `tax_payments` (
  `tax_pay_ID` int(11) NOT NULL,
  `tax_ID` int(11) DEFAULT NULL,
  `paid_date` date NOT NULL,
  `paid_by` int(11) NOT NULL,
  `paid_amount` decimal(12,2) NOT NULL,
  `due_amount` decimal(12,2) NOT NULL,
  `note` mediumtext DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `docs` blob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`apt_ID`),
  ADD KEY `cli_ID_fk` (`cli_ID`),
  ADD KEY `pat_ID_fk` (`pat_ID`),
  ADD KEY `staff_apt_id_fk` (`staff_ID`),
  ADD KEY `service_apt_id_fk` (`service_ID`);

--
-- Indexes for table `clinics`
--
ALTER TABLE `clinics`
  ADD PRIMARY KEY (`cli_ID`);

--
-- Indexes for table `conditions`
--
ALTER TABLE `conditions`
  ADD PRIMARY KEY (`cond_ID`);

--
-- Indexes for table `condition_details`
--
ALTER TABLE `condition_details`
  ADD PRIMARY KEY (`cond_detail_ID`),
  ADD KEY `conditions_pat_id_fk` (`pat_ID`),
  ADD KEY `condition_detail_id_fk` (`cond_ID`);

--
-- Indexes for table `expenses`
--
ALTER TABLE `expenses`
  ADD PRIMARY KEY (`exp_ID`),
  ADD KEY `cli_ID_fk` (`cli_ID`);

--
-- Indexes for table `expense_detail`
--
ALTER TABLE `expense_detail`
  ADD PRIMARY KEY (`exp_detail_ID`),
  ADD KEY `cli_ID_fk` (`cli_ID`),
  ADD KEY `sdetail_ID_fk` (`purchased_by`),
  ADD KEY `exp_ID_fk` (`exp_ID`);

--
-- Indexes for table `fee_payments`
--
ALTER TABLE `fee_payments`
  ADD PRIMARY KEY (`payment_ID`),
  ADD KEY `appt_pf_id_fk` (`apt_ID`),
  ADD KEY `staff_pf_id_fk` (`staff_ID`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`pat_ID`),
  ADD KEY `cli_ID_fk` (`cli_ID`),
  ADD KEY `sdetail_ID_fk` (`staff_ID`);

--
-- Indexes for table `patient_services`
--
ALTER TABLE `patient_services`
  ADD PRIMARY KEY (`ps_ID`,`pat_ID`,`ser_ID`,`req_ID`),
  ADD KEY `pat_ID` (`pat_ID`),
  ADD KEY `ser_ID` (`ser_ID`),
  ADD KEY `req_ID` (`req_ID`);

--
-- Indexes for table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`ser_ID`);

--
-- Indexes for table `service_requirements`
--
ALTER TABLE `service_requirements`
  ADD PRIMARY KEY (`req_ID`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`staff_ID`);

--
-- Indexes for table `staff_auth`
--
ALTER TABLE `staff_auth`
  ADD PRIMARY KEY (`auth_ID`),
  ADD UNIQUE KEY `staff_ID` (`staff_ID`);

--
-- Indexes for table `taxes`
--
ALTER TABLE `taxes`
  ADD PRIMARY KEY (`tax_ID`);

--
-- Indexes for table `tax_payments`
--
ALTER TABLE `tax_payments`
  ADD PRIMARY KEY (`tax_pay_ID`),
  ADD KEY `taxes_pay_id_fk` (`tax_ID`),
  ADD KEY `staff_tax_pay_id_fk` (`paid_by`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `apt_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT for table `clinics`
--
ALTER TABLE `clinics`
  MODIFY `cli_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `conditions`
--
ALTER TABLE `conditions`
  MODIFY `cond_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `condition_details`
--
ALTER TABLE `condition_details`
  MODIFY `cond_detail_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=179;

--
-- AUTO_INCREMENT for table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `exp_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `expense_detail`
--
ALTER TABLE `expense_detail`
  MODIFY `exp_detail_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `fee_payments`
--
ALTER TABLE `fee_payments`
  MODIFY `payment_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `pat_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=94;

--
-- AUTO_INCREMENT for table `patient_services`
--
ALTER TABLE `patient_services`
  MODIFY `ps_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `services`
--
ALTER TABLE `services`
  MODIFY `ser_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `service_requirements`
--
ALTER TABLE `service_requirements`
  MODIFY `req_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `staff_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `staff_auth`
--
ALTER TABLE `staff_auth`
  MODIFY `auth_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `taxes`
--
ALTER TABLE `taxes`
  MODIFY `tax_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `tax_payments`
--
ALTER TABLE `tax_payments`
  MODIFY `tax_pay_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `pat_apt_id_fk` FOREIGN KEY (`pat_ID`) REFERENCES `patients` (`pat_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `service_apt_id_fk` FOREIGN KEY (`service_ID`) REFERENCES `services` (`ser_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `staff_apt_id_fk` FOREIGN KEY (`staff_ID`) REFERENCES `staff` (`staff_ID`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `condition_details`
--
ALTER TABLE `condition_details`
  ADD CONSTRAINT `condition__detail_pat_id_fk` FOREIGN KEY (`pat_ID`) REFERENCES `patients` (`pat_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `condition_detail_id_fk` FOREIGN KEY (`cond_ID`) REFERENCES `conditions` (`cond_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `expense_detail`
--
ALTER TABLE `expense_detail`
  ADD CONSTRAINT `expense_detail_id_fk` FOREIGN KEY (`exp_ID`) REFERENCES `expenses` (`exp_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `staff_expense_id_fk` FOREIGN KEY (`purchased_by`) REFERENCES `staff` (`staff_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `fee_payments`
--
ALTER TABLE `fee_payments`
  ADD CONSTRAINT `appt_pf_id_fk` FOREIGN KEY (`apt_ID`) REFERENCES `appointments` (`apt_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `staff_pf_id_fk` FOREIGN KEY (`staff_ID`) REFERENCES `staff` (`staff_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `patients`
--
ALTER TABLE `patients`
  ADD CONSTRAINT `staff_pat_id_fk` FOREIGN KEY (`staff_ID`) REFERENCES `staff` (`staff_ID`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `patient_services`
--
ALTER TABLE `patient_services`
  ADD CONSTRAINT `pat_ser_pat_id_fk` FOREIGN KEY (`pat_ID`) REFERENCES `patients` (`pat_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pat_ser_ser_id_fk` FOREIGN KEY (`ser_ID`) REFERENCES `services` (`ser_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pat_ser_ser_req_fk` FOREIGN KEY (`req_ID`) REFERENCES `service_requirements` (`req_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `staff_auth`
--
ALTER TABLE `staff_auth`
  ADD CONSTRAINT `staff_auth_id_fk` FOREIGN KEY (`staff_ID`) REFERENCES `staff` (`staff_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tax_payments`
--
ALTER TABLE `tax_payments`
  ADD CONSTRAINT `staff_tax_pay_id_fk` FOREIGN KEY (`paid_by`) REFERENCES `staff` (`staff_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `taxes_pay_id_fk` FOREIGN KEY (`tax_ID`) REFERENCES `taxes` (`tax_ID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
