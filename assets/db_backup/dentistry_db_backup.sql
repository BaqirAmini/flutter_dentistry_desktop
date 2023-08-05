-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 05, 2023 at 07:39 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

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
  `tooth_detail_ID` int(11) DEFAULT NULL,
  `ser_ID` int(128) NOT NULL,
  `installment` int(2) DEFAULT 1,
  `round` int(2) NOT NULL DEFAULT 1,
  `paid_amount` decimal(6,2) NOT NULL,
  `due_amount` decimal(6,2) NOT NULL,
  `meet_date` date DEFAULT NULL,
  `staff_ID` int(128) NOT NULL,
  `note` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

CREATE TABLE `expenses` (
  `exp_ID` int(128) NOT NULL,
  `cli_ID` int(128) NOT NULL,
  `exp_name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `expenses`
--

INSERT INTO `expenses` (`exp_ID`, `cli_ID`, `exp_name`) VALUES
(5, 0, 'تجهیزات کلینیک'),
(6, 0, 'خوراک'),
(7, 0, 'نیازمندیهای صحی');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `expense_detail`
--

INSERT INTO `expense_detail` (`exp_detail_ID`, `exp_ID`, `cli_ID`, `purchased_by`, `item_name`, `quantity`, `qty_unit`, `unit_price`, `total`, `purchase_date`, `invoice`, `note`) VALUES
(1, 7, 0, 14, 'قالب دندان 2', 3.00, 'عدد', '2500.00', '7500.00', '2023-07-27', NULL, 'کمپنی هندی'),
(4, 6, 0, 27, 'چای خشک', 2.00, 'کیلوگرام', '180.00', '360.00', '2023-07-03', NULL, 'چای سبز با کیفیت'),
(7, 5, 0, 17, 'میز کار', 1.00, 'متر', '1200.00', '1200.00', '2020-07-31', NULL, 'واحد نیز اضافه شد.'),
(13, 6, 0, 17, 'تربوز', 3.00, 'کیلوگرام', '500.00', '1500.00', '2017-07-25', NULL, '3 سیر تربوز برای مهمانها'),
(15, 5, 0, 23, 'فرش', 7.00, 'متر', '750.00', '5250.00', '2022-07-04', NULL, 'موکت متوسط با رنگ سرخ'),
(16, 6, 0, 27, 'کباب و قابلی', 7.00, 'خوراک', '150.00', '1050.00', '2023-07-29', NULL, 'غذا از رستورانت برای مهمانان');

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
  `sex` varchar(5) NOT NULL DEFAULT 'Male',
  `age` int(3) NOT NULL,
  `marital_status` varchar(16) DEFAULT NULL,
  `phone` varchar(12) DEFAULT NULL,
  `reg_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `blood_group` varchar(12) DEFAULT NULL,
  `address` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`pat_ID`, `cli_ID`, `staff_ID`, `firstname`, `lastname`, `sex`, `age`, `marital_status`, `phone`, `reg_date`, `blood_group`, `address`) VALUES
(28, 0, 17, 'حسین', 'احسانی', 'مرد', 26, 'متاهل', '0773545232', '2023-07-15 06:23:31', 'AB-', ''),
(30, 0, 17, 'علی', 'گندابی', 'مرد', 84, 'متاهل', '0771023232', '2023-07-20 17:40:47', 'O+', ''),
(38, 0, 17, 'Ali', '', 'مرد', 1, 'مجرد', '0771023266', '2023-07-21 04:26:26', 'نامشخص', ''),
(39, 0, 17, 'سحر', 'حیدری', 'زن', 22, 'مجرد', '0701023322', '2023-07-21 04:32:31', 'O-', 'کابل، پروان سه'),
(40, 0, 17, 'Hamdard', '', 'مرد', 1, 'مجرد', '0702323432', '2023-07-21 05:20:42', 'نامشخص', ''),
(41, 0, 17, 'میرویس', '', 'مرد', 10, 'مجرد', '0772323420', '2023-07-21 05:32:06', 'B-', 'کابل'),
(42, 0, 17, 'مریم', 'احمدی', 'زن', 20, 'مجرد', '0788810232', '2023-07-21 05:37:19', 'AB-', 'هرات، جبریل'),
(43, 0, 17, 'علی', '', 'مرد', 1, 'مجرد', '0788822322', '2023-07-21 13:36:55', 'نامشخص', ''),
(45, 0, 17, 'فواد', 'ناصر', 'مرد', 42, 'متاهل', '0781023232', '2023-07-21 15:03:14', 'AB+', ''),
(46, 0, 17, 'مرسل', 'افغان', 'زن', 23, 'مجرد', '0702342322', '2023-07-22 00:20:20', 'O+', 'کابل، خیر خانه');

-- --------------------------------------------------------

--
-- Table structure for table `services`
--

CREATE TABLE `services` (
  `ser_ID` int(128) NOT NULL,
  `ser_name` varchar(64) NOT NULL,
  `ser_fee` decimal(10,2) DEFAULT NULL,
  `pat_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `services`
--

INSERT INTO `services` (`ser_ID`, `ser_name`, `ser_fee`, `pat_ID`) VALUES
(1, 'پرکاری دندان', '999.99', NULL),
(2, 'پرکاری', NULL, NULL),
(3, 'سفید کردن', NULL, NULL),
(4, 'جرم گیری', NULL, NULL),
(5, 'ارتودانسی', NULL, NULL),
(6, 'جراحی ریشه', NULL, NULL),
(7, 'جراحی لثه', NULL, NULL),
(8, 'معاینه دهان', NULL, NULL),
(9, 'پروتیز', NULL, NULL),
(10, 'کشیدن', NULL, NULL),
(11, 'پوش کردن', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `service_details`
--

CREATE TABLE `service_details` (
  `ser_det_ID` int(11) NOT NULL,
  `ser_id` int(11) DEFAULT NULL,
  `service_specific_value` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `service_details`
--

INSERT INTO `service_details` (`ser_det_ID`, `ser_id`, `service_specific_value`) VALUES
(1, 2, 'کامپوزیت'),
(2, 2, 'املگم'),
(3, 2, 'سایر مواد'),
(4, 3, 'یک مرحله ی'),
(5, 3, 'دو مرحله ی'),
(6, 3, 'سه مرحله ی'),
(7, 3, 'چهار مرحله ی'),
(8, 9, 'پروتیز قسمی'),
(9, 9, 'پروتیز کامل'),
(10, 11, 'پورسلن'),
(11, 11, 'میتل'),
(12, 11, 'زرگونیم'),
(13, 11, 'گیگم'),
(14, 11, 'طلا');

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
  `photo` varchar(128) DEFAULT NULL,
  `address` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`staff_ID`, `firstname`, `lastname`, `position`, `salary`, `phone`, `tazkira_ID`, `photo`, `address`) VALUES
(14, 'فرهاد جان', 'اکبری', 'نرس', '35000.500', '0799102332', '1400-0505-13456', NULL, ''),
(17, 'امین الله خان', 'حسیب', 'نرس', '3500.500', '0771020220', '1399-1232-23232', NULL, 'کلوله پشته، نزدیک سرک میدان هوایی'),
(21, 'حسین خان', 'احسانی', 'مدیر سیستم', '35000.000', '0771023322', '', NULL, 'کابل، افغانستان'),
(23, 'راحله', 'احمدی', 'نرس', '17500.000', '0771023232', '1399-2323-23232', NULL, 'کابل، افغانستان'),
(24, 'Sediqa', 'Ahmadi', 'مدیر سیستم', '70000.000', '0744319261', '1399-1010-23232', NULL, 'Kabul, Afghanistan, Dasht  e Barchi'),
(26, 'خسرو خان', 'بلخی', 'داکتر دندان', '70000.000', '0771023232', '1401-2323-23232', NULL, 'مرکز بلخ'),
(27, 'زهر1', '', 'نرس', '5000.000', '0701023232', '', NULL, 'کابل، افغانستان');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `staff_auth`
--

INSERT INTO `staff_auth` (`auth_ID`, `staff_ID`, `username`, `password`, `role`) VALUES
(17, 17, 'amin1402', '*2FD86C7689C4B6BC9E91ED8CA245BB5BAA22842E', 'کمک مدیر');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `taxes`
--

INSERT INTO `taxes` (`tax_ID`, `annual_income`, `tax_rate`, `total_annual_tax`, `TIN`, `tax_for_year`) VALUES
(1, 150000.00, '12.50', '18750.00', '1002232322', 0),
(2, 220000.00, '10.00', '22000.00', '10232344', 1394),
(3, 80000.00, '9.50', '7600.00', '25232300', 1401),
(4, 250000.00, '20.00', '50000.00', '0023802300', 1402),
(5, 300000.00, '12.50', '37500.00', '4023233245', 1400),
(6, 290000.00, '10.50', '30450.00', '1402323219', 1304),
(7, 200000.00, '18.50', '37000.00', '1800018232', 1398),
(8, 200000.00, '15.60', '31200.00', '1234567890', 1308),
(9, 80000.00, '18.50', '14800.00', '1000123223', 1302);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tax_payments`
--

INSERT INTO `tax_payments` (`tax_pay_ID`, `tax_ID`, `paid_date`, `paid_by`, `paid_amount`, `due_amount`, `note`, `modified_at`, `docs`) VALUES
(1, 5, '2023-08-04', 21, '10000.00', '27500.00', 'مالیات کلینیک دندان درمان', NULL, NULL),
(2, 6, '2017-01-01', 14, '30000.00', '450.00', 'حل اشتباهات مالیات', NULL, NULL),
(3, 7, '2019-08-15', 23, '37000.00', '0.00', 'هیچ مالیاتی باقی نمانده', NULL, NULL),
(4, 8, '1903-08-19', 14, '31200.00', '0.00', '', NULL, NULL),
(7, 5, '2023-08-04', 23, '27500.00', '0.00', 'حساب و کتاب', '2023-08-05 04:49:10', NULL),
(9, 6, '2022-12-28', 24, '450.00', '0.00', 'در آخر پارسال تصفیه شد', '2023-08-05 05:15:51', NULL),
(10, 9, '2017-08-09', 14, '12000.00', '2800.00', 'کل مالیات تصفیه نشده', '2023-08-05 05:25:22', NULL),
(11, 9, '2023-08-01', 21, '2800.00', '0.00', 'همه مالیات تصفیه شد', '2023-08-05 05:26:19', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `teeth`
--

CREATE TABLE `teeth` (
  `teeth_ID` int(128) NOT NULL,
  `gum` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `teeth`
--

INSERT INTO `teeth` (`teeth_ID`, `gum`) VALUES
(1, 'هردو'),
(2, 'بالا'),
(3, 'پایین'),
(4, 'بالا-راست'),
(5, 'بالا-چپ'),
(6, 'پایین-راست'),
(7, 'پایین-چپ');

-- --------------------------------------------------------

--
-- Table structure for table `tooth_details`
--

CREATE TABLE `tooth_details` (
  `td_ID` int(11) NOT NULL,
  `tooth_ID` int(11) DEFAULT NULL,
  `tooth` varchar(64) DEFAULT NULL,
  `tooth_photo` mediumblob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tooth_details`
--

INSERT INTO `tooth_details` (`td_ID`, `tooth_ID`, `tooth`, `tooth_photo`) VALUES
(1, 4, '1', NULL),
(2, 4, '2', NULL),
(3, 4, '3', NULL),
(4, 4, '4', NULL),
(5, 4, '5', NULL),
(6, 4, '6', NULL),
(7, 4, '7', NULL),
(8, 4, '8', NULL),
(9, 5, '1', NULL),
(10, 5, '2', NULL),
(11, 5, '3', NULL),
(12, 5, '4', NULL),
(13, 5, '5', NULL),
(14, 5, '6', NULL),
(15, 5, '7', NULL),
(16, 5, '8', NULL),
(17, 6, '1', NULL),
(18, 6, '2', NULL),
(19, 6, '3', NULL),
(20, 6, '4', NULL),
(21, 6, '5', NULL),
(22, 6, '6', NULL),
(23, 6, '7', NULL),
(24, 6, '8', NULL),
(25, 7, '1', NULL),
(26, 7, '2', NULL),
(27, 7, '3', NULL),
(28, 7, '4', NULL),
(29, 7, '5', NULL),
(30, 7, '6', NULL),
(31, 7, '7', NULL),
(32, 7, '8', NULL),
(35, 4, 'عقل دندان', NULL),
(36, 4, 'دندان پوسیده', NULL),
(37, 4, 'شلوغ(دندان اضافی)', NULL),
(38, 1, 'عقل دندان', NULL),
(39, 1, 'دندان پوسیده', NULL),
(40, 1, 'شلوغ(دندان اضافی)', NULL),
(41, 5, 'عقل دندان', NULL),
(42, 5, 'دندان پوسیده', NULL),
(43, 5, 'شلوغ(دندان اضافی)', NULL),
(44, 6, 'عقل دندان', NULL),
(45, 6, 'دندان پوسیده', NULL),
(46, 6, 'شلوغ(دندان اضافی)', NULL),
(47, 7, 'عقل دندان', NULL),
(48, 7, 'دندان پوسیده', NULL),
(49, 7, 'شلوغ(دندان اضافی)', NULL);

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
  ADD KEY `ser_ID_fk` (`ser_ID`),
  ADD KEY `sdetail_ID_fk` (`staff_ID`),
  ADD KEY `teeth_apt_id_fk` (`tooth_detail_ID`);

--
-- Indexes for table `clinics`
--
ALTER TABLE `clinics`
  ADD PRIMARY KEY (`cli_ID`);

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
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`pat_ID`),
  ADD KEY `cli_ID_fk` (`cli_ID`),
  ADD KEY `sdetail_ID_fk` (`staff_ID`);

--
-- Indexes for table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`ser_ID`);

--
-- Indexes for table `service_details`
--
ALTER TABLE `service_details`
  ADD PRIMARY KEY (`ser_det_ID`),
  ADD KEY `ser_ser_det_id` (`ser_id`);

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
-- Indexes for table `teeth`
--
ALTER TABLE `teeth`
  ADD PRIMARY KEY (`teeth_ID`);

--
-- Indexes for table `tooth_details`
--
ALTER TABLE `tooth_details`
  ADD PRIMARY KEY (`td_ID`),
  ADD KEY `tooth_td_id` (`tooth_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `apt_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `clinics`
--
ALTER TABLE `clinics`
  MODIFY `cli_ID` int(128) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `exp_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `expense_detail`
--
ALTER TABLE `expense_detail`
  MODIFY `exp_detail_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `pat_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `services`
--
ALTER TABLE `services`
  MODIFY `ser_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `service_details`
--
ALTER TABLE `service_details`
  MODIFY `ser_det_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `staff_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `staff_auth`
--
ALTER TABLE `staff_auth`
  MODIFY `auth_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `taxes`
--
ALTER TABLE `taxes`
  MODIFY `tax_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tax_payments`
--
ALTER TABLE `tax_payments`
  MODIFY `tax_pay_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `teeth`
--
ALTER TABLE `teeth`
  MODIFY `teeth_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tooth_details`
--
ALTER TABLE `tooth_details`
  MODIFY `td_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `pat_apt_id_fk` FOREIGN KEY (`pat_ID`) REFERENCES `patients` (`pat_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ser_apt_id_fk` FOREIGN KEY (`ser_ID`) REFERENCES `services` (`ser_ID`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `staff_apt_id_fk` FOREIGN KEY (`staff_ID`) REFERENCES `staff` (`staff_ID`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `tooth_det_id_fk` FOREIGN KEY (`tooth_detail_ID`) REFERENCES `tooth_details` (`td_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `expense_detail`
--
ALTER TABLE `expense_detail`
  ADD CONSTRAINT `expense_detail_id_fk` FOREIGN KEY (`exp_ID`) REFERENCES `expenses` (`exp_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `staff_expense_id_fk` FOREIGN KEY (`purchased_by`) REFERENCES `staff` (`staff_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `patients`
--
ALTER TABLE `patients`
  ADD CONSTRAINT `staff_pat_id_fk` FOREIGN KEY (`staff_ID`) REFERENCES `staff` (`staff_ID`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `service_details`
--
ALTER TABLE `service_details`
  ADD CONSTRAINT `ser_ser_det_id` FOREIGN KEY (`ser_id`) REFERENCES `services` (`ser_ID`) ON DELETE NO ACTION ON UPDATE CASCADE;

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

--
-- Constraints for table `tooth_details`
--
ALTER TABLE `tooth_details`
  ADD CONSTRAINT `tooth_td_id` FOREIGN KEY (`tooth_ID`) REFERENCES `teeth` (`teeth_ID`) ON DELETE NO ACTION ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
