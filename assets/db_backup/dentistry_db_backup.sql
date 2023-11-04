-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 04, 2023 at 05:57 PM
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
  `service_detail_ID` int(128) DEFAULT NULL,
  `installment` int(2) DEFAULT 1,
  `round` int(2) NOT NULL DEFAULT 1,
  `paid_amount` decimal(12,2) NOT NULL,
  `due_amount` decimal(12,2) NOT NULL,
  `meet_date` date DEFAULT NULL,
  `staff_ID` int(128) DEFAULT NULL,
  `note` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`apt_ID`, `cli_ID`, `pat_ID`, `tooth_detail_ID`, `service_detail_ID`, `installment`, `round`, `paid_amount`, `due_amount`, `meet_date`, `staff_ID`, `note`) VALUES
(41, 0, 69, 5, 9, 1, 1, '5000.00', '0.00', '2023-08-23', 17, '');

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
  `cond_ID` int(128) NOT NULL,
  `name` text NOT NULL,
  `result` tinyint(1) NOT NULL DEFAULT 0,
  `severty` varchar(64) DEFAULT NULL,
  `diagnosis_date` date DEFAULT NULL,
  `pat_ID` int(128) DEFAULT NULL,
  `notes` tinytext DEFAULT NULL
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`pat_ID`, `cli_ID`, `staff_ID`, `firstname`, `lastname`, `sex`, `age`, `marital_status`, `phone`, `reg_date`, `blood_group`, `address`) VALUES
(69, 0, 17, 'مهناز', '', 'زن', 27, 'مجرد', '0781023232', '2023-10-02 07:14:26', 'نامشخص', '');

-- --------------------------------------------------------

--
-- Table structure for table `selected_teeth`
--

CREATE TABLE `selected_teeth` (
  `ST_ID` int(11) NOT NULL,
  `tooth` varchar(16) NOT NULL,
  `notes` tinytext DEFAULT NULL,
  `pat_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `services`
--

CREATE TABLE `services` (
  `ser_ID` int(128) NOT NULL,
  `ser_name` varchar(64) NOT NULL,
  `ser_fee` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
-- Indexes for table `conditions`
--
ALTER TABLE `conditions`
  ADD PRIMARY KEY (`cond_ID`),
  ADD KEY `conditions_pat_id_fk` (`pat_ID`);

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
-- Indexes for table `selected_teeth`
--
ALTER TABLE `selected_teeth`
  ADD PRIMARY KEY (`ST_ID`),
  ADD KEY `selected_teeth_pat_id_fk` (`pat_ID`);

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
  MODIFY `apt_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `clinics`
--
ALTER TABLE `clinics`
  MODIFY `cli_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `conditions`
--
ALTER TABLE `conditions`
  MODIFY `cond_ID` int(128) NOT NULL AUTO_INCREMENT;

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
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `pat_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `selected_teeth`
--
ALTER TABLE `selected_teeth`
  MODIFY `ST_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `services`
--
ALTER TABLE `services`
  MODIFY `ser_ID` int(128) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `service_details`
--
ALTER TABLE `service_details`
  MODIFY `ser_det_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

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
-- Constraints for table `conditions`
--
ALTER TABLE `conditions`
  ADD CONSTRAINT `conditions_pat_id_fk` FOREIGN KEY (`pat_ID`) REFERENCES `patients` (`pat_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

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
-- Constraints for table `selected_teeth`
--
ALTER TABLE `selected_teeth`
  ADD CONSTRAINT `selected_teeth_pat_id_fk` FOREIGN KEY (`pat_ID`) REFERENCES `patients` (`pat_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

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
