-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 05, 2023 at 01:45 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.0.25

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
  `service_detail_ID` int(128) DEFAULT NULL,
  `installment` int(2) DEFAULT 1,
  `round` int(2) NOT NULL DEFAULT 1,
  `paid_amount` decimal(12,2) NOT NULL,
  `due_amount` decimal(12,2) NOT NULL,
  `meet_date` date DEFAULT NULL,
  `staff_ID` int(128) DEFAULT NULL,
  `note` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`apt_ID`, `cli_ID`, `pat_ID`, `tooth_detail_ID`, `service_detail_ID`, `installment`, `round`, `paid_amount`, `due_amount`, `meet_date`, `staff_ID`, `note`) VALUES
(19, 0, 55, 64, 5, 1, 1, '1000.00', '0.00', '2023-08-17', 17, 'با ماده اصلی سفید کننده'),
(28, 0, 55, 3, 2, 3, 1, '1000.00', '2000.00', '2023-08-21', 17, ''),
(29, 0, 55, 59, 15, 2, 1, '2000.00', '3000.00', '2023-08-30', 17, 'برای رفع عیوب نیاز به جراحی دارد'),
(32, 0, 55, 60, 4, 1, 1, '5000.00', '0.00', '2023-08-13', 17, ''),
(33, 0, 54, 58, 7, 1, 1, '1000.00', '0.00', '2023-08-25', 17, 'هردو لثه سفید گردید'),
(34, 0, 54, 59, 17, 1, 1, '500.00', '0.00', '2023-08-23', 17, 'فقط لثه ی بالا جرم گیری شد'),
(35, 0, 54, 60, 18, 2, 1, '1200.00', '1800.00', '2023-08-22', 17, 'فقط فک پایین انجام شد'),
(36, 0, 54, 58, 19, 3, 1, '3000.00', '7000.00', '2021-07-06', 17, 'هردو لثه نیاز به جراحی دارد'),
(37, 0, 54, 62, 18, 1, 1, '3000.00', '0.00', '2023-09-18', 21, 'Testing');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `expense_detail`
--

INSERT INTO `expense_detail` (`exp_detail_ID`, `exp_ID`, `cli_ID`, `purchased_by`, `item_name`, `quantity`, `qty_unit`, `unit_price`, `total`, `purchase_date`, `invoice`, `note`) VALUES
(1, 7, 0, 14, 'قالب دندان 2', 3.00, 'عدد', '2500.00', '7500.00', '2023-08-26', NULL, 'کمپنی هندی'),
(4, 6, 0, 27, 'چای خشک', 2.00, 'کیلوگرام', '180.00', '360.00', '2023-07-02', NULL, 'چای سبز با کیفیت'),
(7, 5, 0, 17, 'میز کار', 1.00, 'متر', '1200.00', '1200.00', '2020-07-31', NULL, 'واحد نیز اضافه شد.'),
(13, 6, 0, 17, 'تربوز', 3.00, 'کیلوگرام', '500.00', '1500.00', '2017-07-25', NULL, '3 سیر تربوز برای مهمانها'),
(15, 5, 0, 23, 'فرش', 7.00, 'متر', '750.00', '5250.00', '2022-07-04', NULL, 'موکت متوسط با رنگ سرخ'),
(16, 6, 0, 27, 'کباب و قابلی', 7.00, 'خوراک', '150.00', '1050.00', '2023-07-28', NULL, 'غذا از رستورانت برای مهمانان'),
(17, 5, 0, 21, 'موبل', 3.00, 'عدد', '1150.00', '3450.00', '2023-06-21', NULL, 'سه تا کوچ برای اتاق انتظار');

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
(54, 0, 17, 'زحل', 'رحیمی', 'زن', 20, 'مجرد', '0771023232', '2023-08-18 13:05:42', 'AB-', 'کابل، کارته پروان'),
(55, 0, 17, 'زهره', 'حکیمی', 'زن', 24, 'متاهل', '0790123234', '2023-09-04 13:08:55', 'O+', ''),
(57, 0, 23, 'Maisam', NULL, 'Male', 25, 'متاهل', '0701023232', '2023-07-12 06:37:46', NULL, NULL),
(58, 0, 21, 'Sabir', 'Ahmadi', 'Male', 30, 'مجرد', '0702323232', '2023-05-16 06:37:46', NULL, NULL),
(59, 0, 23, 'Maisam', NULL, 'Male', 25, 'متاهل', '0701023232', '2023-07-12 06:37:46', NULL, NULL),
(60, 0, 21, 'Sabir', 'Ahmadi', 'Male', 30, 'مجرد', '0702323232', '2023-05-16 06:37:46', NULL, NULL),
(61, 0, 14, 'مریم', NULL, 'Femal', 22, 'مجرد', '0788080130', '2023-04-26 06:47:06', 'O+', NULL),
(62, 0, 24, 'مژگان', 'حیدری', 'Femal', 35, 'متاهل', '0781010210', '2023-04-04 06:47:06', NULL, NULL),
(63, 0, 23, 'Marry', 'Scaff', 'Femal', 28, 'متاهل', '0744050607', '2023-04-09 06:51:06', NULL, NULL),
(64, 0, 24, 'Fatima', 'Hossaini', 'Femal', 40, 'متاهل', '0790525230', '2023-03-23 11:30:53', 'AB+', 'کابل، افغانستان'),
(65, 0, 26, 'Fahima', 'Rezwani', 'Female', 29, 'مجرد', '0799101012', '2023-01-17 11:36:13', NULL, 'کابل، حوزه ششم');

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
(1, 'عصب کشی', '999.99'),
(2, 'پرکاری', NULL),
(3, 'سفید کردن', '0.00'),
(4, 'جرم گیری', NULL),
(5, 'ارتودانسی', NULL),
(6, 'جراحی ریشه', '0.00'),
(7, 'جراحی لثه', NULL),
(8, 'معاینه دهان', NULL),
(9, 'پروتیز', '0.00'),
(10, 'کشیدن دندان', '500.00'),
(11, 'پوش کردن', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `service_details`
--

CREATE TABLE `service_details` (
  `ser_det_ID` int(11) NOT NULL,
  `ser_id` int(11) DEFAULT NULL,
  `service_specific_value` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(14, 11, 'طلا'),
(15, 8, 'value not required'),
(16, 3, 'value not required'),
(17, 4, 'value not required'),
(18, 5, 'value not required'),
(19, 7, 'value not required');

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
(14, 'فرهاد جان', 'اکبری', 'نرس', '35000.500', '0799102332', '1400-0505-13456', NULL, ''),
(17, 'امین الله', 'حبیبی', 'نرس', '6500.000', '0771020220', '1399-1232-23236', 0xffd8ffe000104a46494600010100000100010000ffdb008400090607121212150f1012101515151515151510151515151515151515161615151515181d2820181a251d151521312125292b2e2e2e171f3338332d37282d2e2b010a0a0a0e0d0e1710101a2d251d252d2b2d2d2d2d2b2d2d2b2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2b2d2d2d2d2b2d2d2d2d2d2d2d2d2d2d2dffc0001108011300b703012200021101031101ffc4001c0000010501010100000000000000000000020103040506000708ffc4004110000201020305050505050607000000000102000311040521061231415122617181911332a1b1c123425272d1071492e1f01624346282f14363a2b2c2c3d2ffc4001801010101010100000000000000000000000001020304ffc400221101010002020202030101000000000000000102110321123141511332716122ffda000c03010002110311003f00bf558e2ac5558e289a648ab1c0b14086040e0b3ad0c08a0400022da1da2da037bb38ac72d12d01a2b0488f1104880c1580563e4412b023958db2c9056032c08acb197492cac6996043758cba49acb197595105d2477a727ba466a2c0af749d243a4e81ad510d44e511c02457010c0880430202810ad100840404b45b45022c01b44b43b4eb406c882447488244068882447488044064880c23c44061018658db2c7c88db081199634cb2532c69965111d630eb2632c65d61109d2747dd6740d2810c088a2181229443110084040502109c22da075a75a2da7180968c633149494d4aacaaa38926d339b5bb5e30c3d9d11bf50e9bdf713bcf53dd304b88c5631f79ea3542baee900803b9794ce5969ac71dbd0e8ed652a8d6a60eefe26ecdfc2f10ed861c36e38a887a9171ea26772ba34dfb07b0e070b581f2e7fef26a6152a1f6389a62ff0071c1366fcbcc1ee9c7f2651d7f1e2d2e1f36a4f6eda8de365b9b5fd64e33235f29010a821d74237b8dfbcf5e5799d5da1ab876281985bee93aaffa4e84786b378f2efdb378fe9e9a4402263f24dbba6e7d9e20aa93eed502caddc45cee99afa755585d4833acbb7303080c23c636d08619636c248611a61023b2c65c492cb1b612888cb3a3ccb3a05f08622010848a210844108421614411600bbd84c0ed66d43bbfee9863ba6f66aa3afe153d7bfae92e76db3a387a564237d810badadd48ef9e4549dc36fb5ec4fbdc45f9ded31965f0de38b67432e5555a9ef023b40dc8d7a81d35d7bf84a9cbaa8c3d72a185893b8c48171c40bf0bf2b1e3dd0f0d9ab2b02cc002459ae4a5fae9a8bf3f59678bcb68d704385463d401e7bc080c273feba7f12736a66b28a94cb6faea376cac0899fc4ed25643bb51775c7222cb52dc091c9bbc4915321c4d017a355d906bba0ef0f2bdc7c65066f9ad56ec5500db4ed004e9fe6d64d0bba9b63be2faab751c9bbfb8fa48d8dc7d2c5a59ec95d7830d03a8e5c78ff5df320c471008f0e11378f7e935e113caa51c33dcee8bf5b7d44b7c8b69f138760a0dd78056d40f0fd250fb627de27e778540dd878cdcdb15edfb3d9e8c4a5ca32b0e3cd4f7820cb7331bb1cdbac05c5adc8df8f5ef9b43371834c236c23cc2366030c236c23ec236c250c309d0984e81762108221891442108221084288a6708de28f61adf84fca07897ed073135b14da9dd4161afc04a7cb71e691ed39b735b6f0f0b739d9b9bd476bdee6f7efe16f29d92e54f5dbb2272bad76ed3df4b07c5507d3d8b9bfde4ecfaa9bcb3c0213d9a7ed87e6d6c3a01c26a728d85500336a7e135b81d9e45d02ce372b7d3b4c64f6c161b2cc43f64116e7743a7876a27f61998dd998f5bcf59c3e58178084d84ee8d55dcfa79051d85b860791d0c898ed8d2ab7027b01c2dafa4afc5616fa5a67767cb5d5f878ae3b66d95778899ea6b662186a27bb66b805ddb58709e49b4d8214aadf919d38f3df55cb9309adc5a6ce66dfbbb2b02774e8ca6c7d0cf55c2d60ea1c7022e2780d0c45b4e5f29ed7b21537b0948defd99df179f25b308db08e340334c9a611a68f346da50cb09d15a240b910c40109601884208842404240da0aed4f0d55d3de08c47a49e2378aa619194f02a47c207ce18962c6c3999ebfb03922ad25361722f3c9952f5150737b0f5b4f7bd9db51a6a0f2138727c47a38beda4c361ac0093a9d1132b996d851a03b47faf095143f6978766dd1bd7ebca623a3d2774407a733184da3571756922b67800b931e513c2ad2b5112056a604ca66dfb40a7489041623a19549fb4aa2e78192cdb5e9a6cdc00a4cf1cdb670c7ce7a462368a9d54b136de1a19e63b5639f43184ff00a4e4fd598a475b4f72d85ff054afd0fa5cda786b71b89ef3b2543d9e16929e3b80fa8bcf54792ad9a018e18065434d1b68eb46cc06984e8af3a516821415842146b08401084887044aad613844a8b7047510af0ac5e0c51ab5ea061bf45835316b824b31bdba58784d565b8ec454a295eb56aa77c16dd5b2285048b92a2fca43c0e5e2963d37c6f1f68e0dff000d980066bf65b2147c31c2bdc9c3d5a948a5cfbbbe5e913d6e8e87ce71cb2eba7a30c66d92c4ed22282529d5a96e2c6ad5b03e1bdaca5ad9cb54bb141bb7e36dfb74237ef3d46b6cdb2121685275fe13e7a6b1bfece16d5e8d141f84283e64916f84cccba5b877bdb0184ceab61ca94a62a87d1506f06274d0017b9f0124e6fb5789de14aae09a8ef0d3da1a8a4db891745b81dd37bb3793d318d0c8abbb85420d80b0af5ac774742b4f5b7fcd124fed83062a61d58f1a5516a5fa2d88a9e5bac4f9475f30bbf8af20ad9a0bd851a4cc7aa86bf93dcfc645a398a31b32d253d168a0f881f49bfc3ecb2af69529b11a86e6472d44838cc81431618460dd577483e7797ca693f1db597f6c4fb8de5a11f0b4826abe21ff007760a0dedbf7d74ff293acd3d1c808bf61a9df80d0faf499d6c25a955c4736662adcf741b0b1efb5fce5c6c33962ab0b8026bad0245f7c293cb8cf72c0d40005e8009e219469551bfce3e73d6f038abda758f3e51a406018142a5c470ca86cc6cc718c0680db4e9cd3a516421831b10c428c4210042100c45822109060b3bcb1d31c95d7546255bb9b74907ce6c72ec3d32c2a9df47dd00d4a6cc8580e0180367b72de06d2b76a5b7155f4b075b8f3e31dc063c000774f3de9ecc64ad1b70ff1188f4a07ff005cabccefba7edf107b8b220f5a680fa191f179dd240417171aeef391b03fde3ed5cf617b5bbf880d4ccdcbe9b984f75a3d9ac0a52a2894810a2e4937bbb31bb39275249e6637b5ca594b0d427688b5ee00d45a7659b4742a82f4dd4eee845c7c3ba46ceb3ca68858b0b496f49276caecb9509b946b540809dc5ecba85bdf76cc378017b000dad697ad46a9e15e879d024fc2a899fcb5d2a6f6230e1557b21a90e4d6bb683c8f9cb6a38f523e924ab71fa3398e5ceea55ebe84588a54d69920f11bc4b117ea2c7be6036b0a2536440028015547002d6007a4d966f9880a6c679b67d5598aa9d49258fc87d66f0eeb9f24d457e5a3b4bdc419b6cbf1bc3598aa6bb9f21dfd65b603156b4ef8bcd9fd3d2f2cc45c4b30664b23c54d452a97136c0cc6cc330240dbc59cd3a51600c311b5860c28c42100184203822c006109040cef042b532874d34330386c53ef143ef292a7c4687e53d1f14749e5d983fb2c5d4bf02c1bf8b8fc6f39f263d3af1e765d18af5daad52858845237d8f7f213d032cc552f65646b80b6e9ca6768e434ab37b45620b8f461a5ed1ac5e438dc39fb329554ff00a0f9dae279e77e9e9eed60ab3d5c2d56f66c40b91dc4778e722e619b55ad60ee6c3ee8d079f59a6c66498972c0e1b53afbeba780244cf3658ebff09bcf49de7fae796197a68f61b351469d45636dedd23a69a1fa473199c957f694daea78af3f112a30597567ec5355d74d4936d65ebecb252506a3962c6c48d00eb613965adf6d4f290c6618a3a5cf1faccf62aba972cc785801e12cb3ac52bd4229e8aa2c0780d26718eb3a71e3d38e79767aad72c6fc072125616a480248c31d67571bdb6791d7b5a6d70556e279e656d6b4d96595b4134cafaf04c0468a4c285a74433a04f061a98da9860c29c10818d830c190108578022de0358a3a4f2edb35b54f683f2b787107d7e73d3f14749e79b44b7a9ba78136b45f44f67f65b177200e1cbc79cde9662a0acf1ecb31a70f5774f01f2bf1feba4f59c9731a6ea35b82279329aaf5e396d9cda5c5900ef269ccfd66329e24bddb734e9ddd67b2e3128bad8d88328ab60a8adf755469d046dbf2bf6c86554989d06e8e66556d466e6f604d8680777233579be329d342011dfe13cd332c50a8ecfcb94613776e7c9975a46ab5ac3bcf1318124b61ed4f7cf1247909184f4e2f3d189230a3591c499831acd32bec08e13499755b4cfe084b9c21b4acb5187a9711fbcaec254d24e5685293122133a04f06188d29860c29d10846c1840c81c062c6c18b780de2784c0ed027daafe61f39bcae74991ce695dd7f308f827b62b3ca06e7c743032dce2ad023b46dddacd0e6d83beb33389c25ba784f3e3659aaf4678d97717e76adc8d7adb436818eda463a03cb91bfca6696a1b59ae7e91aa989d7873e3d7c65f089e7747f198ca9509b93a8d644c3e1eec1790378a9a9d258d0a5bab73c4cb6ea3326e9bcc07d99ee2254097d56816461d44a22083633585e9392762593705c641593f07c6747368b032d68caac0996b465656b8479648f29b0ed2c2954812ef3a006890ab206188ca98ea9914e0842360c20603822de0031fc3d06736504fca045ad28f19852581b1b0d66f172308bbcfab5af6e4267b3559cf933d4d3a71e1bbb65f1346e0ca2c56104d55749598ba13cf1ebd4b196ab968e1f1901f2cb4d456a320d7a64cdedcfc22a2860873924d3b9b4922943a54a4b498e82286922d5ca95f88d7acb9a74f48f61b0f33e5a6ae32b3987d952e7755ec4f0b8d2262322af87d6aa1b70df1a89e819460ef517d7d26aeae0d597758023a19df8f2b676f3726325e9e418332da899b0c66c7516d506e1eee1e929717b3b5a96b6df1d471f49da571d21d332652690069245278162ad1232952742ae55a3aa646531d53229f06388093602fdd1dc065cf535e0bd4fd26a72dcad29f2d7a9e302bf2cc889edd5d0725fd65fd1c3aa0b28023b14c9b50b8de1e530f9f618ab91cb88f09b57241bc839be056b25c71e47bfa198cf1dc6f0cb55e715d643acba4bac7e11949561632a2aa91a19e7d3d32aa6b8902b09678a595d58ca18dd8e524874a8932c70581264a130f464ec3e1ac65861701612e72eca378dc8b2f5ebe1131b532ca4264181b03508e3a0f0e665a859219401babcb8f77741559e9c66a69e5caeeec4a90c528aa238b2a2a331d9fa55752a01fc434332f8ed98ab4ee53b43e33d0a0b24bb4d3cab506c41047233a7a1e3f27a557df51e2343eb165da6994c323390aa0927909aacaf220b66a9da3d390fd64acab2c4a2b61a9e6dccff002966b26d641d2a60728f831a062832347818578cde7168438e2467046a3cd7aff38e7b580cc2510f13429d51661a8f26133f986ce1e2841eee0668eb203faf3f58c92c38107c743ea3f499b8cad63959e981c6648e3de561df695a727d67a4d4ae79a37910630d5d79ab7f0ce7789d2735fa6270f975b4025be07286e4be67497dfbc74a6fe807ccc5159cf255ff00a8fd04b38e25e5a1c2658ababd8dbd24c35afa2683f17ff239f8c8e141d58963dfc3c8708edef37248e76da4361a088b16d380950e2c311b10af01c062c00d38bc0569d1b679d0a94ad0f7a44352d156a40961a10790fdb4e15a04ddf885a4757877841b18db18a4c06802cd1b2d09a040178d111e300880d110488e18844a11447808dac312058914c481d788cd10980e6017b4e7391f8c8f51b49d4da01d6addab7403e33a57d6a97a8e3f2fca240b2a588151038febac26ad612ab015b72abd1e4c37d3ff0021f2f5925daf6812a9d4324a48948de4c580f2438d868bbd00c980c67130498024c4bce260de02c1339ea002e4803a93612bebe77865f7ab53f237f946e413a0ca67daac18e3587f0bfe91fc367b86a9a256a64f4bd8fa193ca1a590840c695c1d4104751ac206507109897825a0298db19ccd1a7680957846c346b1156c0f84612b5e00536bd5a9e23fed9d1bc137dad4f2f94e811334c4ee15ac2fd83723aaf06f87ca5bd1ac186f03a1d666d7142ae1d2a75166e97e771256cc622f4da9df5a6777cb8afc34f281a5a3524b4794b86a9acb0a75204e0f0d5a44578e6fc0905a0ef48fed6fc2338fc68a49bc78f003a982dd25b37fb407b9e76f0e320e558b3514b13ce4c2d167d92ee6e186c05226ecbbc7ab12df386b86a638220f05108b46ea560a0b136005c9809530d4cf1443e2a243ad93619bdea34bc7744cd62b6e01aeb4a928dc2dba5cf13f96e40eeb9d35e72b733daac5d9dec68203f67be9667d7ddb1e26d7371a6933e4ba6b68e42949b7f0ef5299fc3bc5a99ee2a64c5cc775853ad652dee37dc63f86fc9b86878f2e93cc936e3183efa1f141f4b47f15b706b5334abd14d783a71561c0eeb5efde2fa8bcce5bf707a99680cf335b319fd2ab4d697b4bb816b1bef7c788efd795ccbd679bc6ee03778cbd480f5247a952547622a0b112350abada3389ad6bc8184c5ddc8eebfac03c766e30e2b566e00a003a926d3a64b6aeb97ac28f2f7cf79b103eb3a4169b31509c3d504dc06b8f3009933659c8c45400e85069e07f9ce9d28d3e18eb27a99d3a03d4cc5ac674e8074784a6daa63b8bf987c8c59d2e3ee39f2fe94f6cf1fb1ff51fa4b231674b9fed578ff58099bdb9aacb873ba48b9b1f503ea674e9cefa748f2da9c6d171e8054651c15881a93603c674e99f843694c1bde3153f49d3a482c766dc8c45220dbed298f5700fc09f59e91b298877c382ec5886a82e75365a8ea05fc009d3a6a7b5f8593c8954c59d368aac71e329b2d73ed5b5e43e73a740858a1fdf1bb97f5893a74335ffd9, 'کابل، دارلامان'),
(21, 'حسین خان', 'احسانی', 'مدیر سیستم', '35000.000', '0771023322', '', NULL, 'کابل، افغانستان'),
(23, 'راحله', 'احمدی', 'نرس', '17500.000', '0771023232', '1399-2323-23232', NULL, 'کابل، افغانستان'),
(24, 'Sediqa', 'Ahmadi', 'مدیر سیستم', '70000.000', '0744319261', '1399-1010-23232', NULL, 'Kabul, Afghanistan, Dasht  e Barchi'),
(26, 'خسرو خان', 'بلخی', 'داکتر دندان', '70000.000', '0771023232', '1401-2323-23232', NULL, 'مرکز بلخ'),
(27, 'زهرا', 'زهرایی', 'نرس', '5000.000', '0701023232', '', NULL, 'کابل، افغانستان');

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
(17, 17, 'amin1402', '*E0D513F4199D61413331CA06AC795ED2BF8BF83F', 'کمک مدیر'),
(22, 14, 'farhad123', '*CBA65288A8EDE802D7CED9C77A2DF9CB190D6EFD', 'کمک مدیر');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(49, 7, 'شلوغ(دندان اضافی)', NULL),
(50, 1, '1', NULL),
(51, 1, '2', NULL),
(52, 1, '3', NULL),
(53, 1, '4', NULL),
(54, 1, '5', NULL),
(55, 1, '6', NULL),
(56, 1, '7', NULL),
(57, 1, '8', NULL),
(58, 1, 'tooth not required', NULL),
(59, 2, 'tooth not required', NULL),
(60, 3, 'tooth not required', NULL),
(61, 4, 'tooth not required', NULL),
(62, 5, 'tooth not required', NULL),
(63, 6, 'tooth not required', NULL),
(64, 7, 'tooth not required', NULL);

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
  ADD KEY `ser_ID_fk` (`service_detail_ID`),
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
  MODIFY `apt_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `clinics`
--
ALTER TABLE `clinics`
  MODIFY `cli_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `exp_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `expense_detail`
--
ALTER TABLE `expense_detail`
  MODIFY `exp_detail_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `pat_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT for table `services`
--
ALTER TABLE `services`
  MODIFY `ser_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `service_details`
--
ALTER TABLE `service_details`
  MODIFY `ser_det_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `staff_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `staff_auth`
--
ALTER TABLE `staff_auth`
  MODIFY `auth_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

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
  MODIFY `td_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `pat_apt_id_fk` FOREIGN KEY (`pat_ID`) REFERENCES `patients` (`pat_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `service_detail_id_fk` FOREIGN KEY (`service_detail_ID`) REFERENCES `service_details` (`ser_det_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `staff_apt_id_fk` FOREIGN KEY (`staff_ID`) REFERENCES `staff` (`staff_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `tooth_det_id_fk` FOREIGN KEY (`tooth_detail_ID`) REFERENCES `tooth_details` (`td_ID`) ON DELETE SET NULL ON UPDATE CASCADE;

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
