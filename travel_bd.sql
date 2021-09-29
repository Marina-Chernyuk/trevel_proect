/* 1 ЧАСТЬ "Общее текстовое описание БД и решаемых ею задач."

1 Назначение базы данных

База данных «Туристическая фирма предназначена для упрощения обработки информации о клиентах, которые хотят поехать отдыхать, отелях, странах, городах и турах, о сотрудниках, которые предоставляют услуги турагентства и заключают договор. 

База данных предназначена для сотрудников фирмы, которые заносят информацию в базу, регистрируя и работая с клиентами. Также может использоваться людьми, имеющими непосредственное отношение к работе БД, такими как руководство фирмы. 

База данных используется для учета, хранения и обработки информации о клиентах, сотрудниках, турах, путевках, оформленных между клиентом (туристом) и менеджером (сотрудником).


2 База данных выполняет следующие функции: 
 
1. Хранение информации о сотрудниках 
2. Хранение информации о клиентах .       
3. Хранение информации о странах . 
4. Хранение информации о городах .       
5. Хранение информации об отелях .
6. Хранение информации об авиакомпаниях .
7. Хранение информации о турах .        
8. Формирование отчетов по вышеназванным пунктам


3 Категории пользователей 

База данных предназначена, в первую очередь, для менеджеров, осуществляющих работу с договорами и их непосредственными участниками. А также для начальства при отслеживании работы подчиненных, и при принятии управляющих решений. 

Отчеты, предусмотренные в ней - для администрации и вышестоящего руководства. 
Кроме того, данные отчетов вполне подходят для использования в официальных отчетных документах.


4 Проектирование базы данных 

Основная цель проектирования БД - это сокращение избыточности хранимых данных, а следовательно, экономия объема используемой памяти, уменьшение затрат на многократные операции обновления избыточных копий и устранение возможности возникновения противоречий из-за хранения в разных местах сведений об одном и том же объекте. 

Проектирование подразумевает выработку свойств системы на основе анализа постановки задачи.

5 Даталогическое проектирование 

Содержанием даталогического проектирования является определение модели данных. Модель данных - это набор соглашений по способам представления сущностей, связей, агрегатов, системы классификации. 

Кроме этого каждая модель данных определяет особенности выполнения основных операций над данными: 
·   добавление, 
·   удаление, 
·   модификация, 
·   выборка. 

Особое внимание при построении модели уделяют целостности и отсутствию избыточности данных. Избыточность - это многократное повторение одних и тех же данных.*/


/* 2 ЧАСТЬ: создание БД (DDL-команды)

Включает в себя:
	скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами)
	скрипты наполнения БД данными */

DROP DATABASE IF EXISTS travel;
CREATE DATABASE travel;
USE travel;

--- 1 таблица
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50), 
    email VARCHAR(120) UNIQUE,
 	address VARCHAR(250),
	phone BIGINT UNSIGNED UNIQUE, 
	
    INDEX employees_firstname_lastname_idx(firstname, lastname) -- полагаю, что в данной БД только в этой таблице нужен INDEX, т.к. не думаю, что в агенстве большая текучка кадров, но будет часто происходить поиск, группировки и обьединения таблиц
) COMMENT 'сотрудники';

--- 2 таблица
DROP TABLE IF EXISTS tourists;
CREATE TABLE tourists (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	contract_number_id BIGINT UNSIGNED NOT NULL,
	gender CHAR(1), -- думаю, что эта информация будет нужна для запросов по статистике, хотя и не обязательна
    firstname VARCHAR(50),
    lastname VARCHAR(50), 
    patronymic VARCHAR(50),
    passport VARCHAR(50),
    email VARCHAR(120) UNIQUE,
 	address VARCHAR(250),
	phone BIGINT UNSIGNED UNIQUE, 
	
    FOREIGN KEY (contract_number_id) REFERENCES contracts(id)
) COMMENT 'туристы';

--- 3 таблица
DROP TABLE IF EXISTS contracts;
CREATE TABLE contracts (
	id SERIAL, 
	deal_id BIGINT UNSIGNED NOT NULL COMMENT 'договор с туристом',
	employee_id BIGINT UNSIGNED NOT NULL COMMENT 'id сотрудника',
	tourist_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP  
) COMMENT 'договоры';

/* при создании связей пришлось добавлять внешние ключи для таблицы contracts в не её границ /*

ALTER TABLE contracts ADD CONSTRAINT fk_contracts_employee_id
FOREIGN KEY (employee_id) REFERENCES employees(id);


ALTER TABLE contracts ADD CONSTRAINT fk_contracts_tourist_id
FOREIGN KEY (tourist_id) REFERENCES tourists(id);

ALTER TABLE contracts ADD CONSTRAINT fk_contracts_deal_id
FOREIGN KEY (deal_id) REFERENCES deals(id);

--- 4 таблица
DROP TABLE IF EXISTS deals; -- договор с туристом
CREATE TABLE deals (
	id SERIAL, 
	employee_id BIGINT UNSIGNED NOT NULL,
	tourist_id BIGINT UNSIGNED NOT NULL,
    tour_id BIGINT UNSIGNED NOT NULL,      	
	cost INT(10) NOT NULL COMMENT 'стоимость', 
	
	FOREIGN KEY (employee_id) REFERENCES employees(id),
	FOREIGN KEY (tourist_id) REFERENCES tourists(id),
	FOREIGN KEY (tour_id) REFERENCES tours(id)	   
) COMMENT 'договор с туристом';

--- 5 таблица
DROP TABLE IF EXISTS tours; -- туры
CREATE TABLE tours (
	id SERIAL,
	country_id BIGINT UNSIGNED NOT NULL,
	city_id BIGINT UNSIGNED NOT NULL,
	hotel_id BIGINT UNSIGNED NOT NULL,
	airline_id BIGINT UNSIGNED NOT NULL, 
	
	FOREIGN KEY (country_id) REFERENCES countrys(id),
	FOREIGN KEY (city_id) REFERENCES citys(id),
	FOREIGN KEY (hotel_id) REFERENCES hotels(id),
	FOREIGN KEY (airline_id) REFERENCES airlines(id)	
) COMMENT 'туры';
	
--- 6 таблица
DROP TABLE IF EXISTS countrys;
CREATE TABLE countrys (
	id SERIAL,
	name VARCHAR(120) NOT NULL
	
) COMMENT 'страны';

--- 7 таблица
DROP TABLE IF EXISTS citys;
CREATE TABLE citys (
	id SERIAL,
	country_id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(120) NOT NULL	
	
	FOREIGN KEY (country_id) REFERENCES countrys(id) ---	
) COMMENT 'города';

--- 8 таблица
DROP TABLE IF EXISTS hotels;
CREATE TABLE hotels (
	id SERIAL,
	name VARCHAR(120) NOT NULL,
	category VARCHAR(120)  NOT NULL,
	line TINYINT NOT NULL	
) COMMENT 'отели';	
	
	
--- 9 таблица
DROP TABLE IF EXISTS airlines; 
CREATE TABLE airlines (
	id SERIAL,
	name VARCHAR(100) NOT NULL		
) COMMENT 'авиакомпании';	
		
--- 10 таблица
DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
id SERIAL PRIMARY KEY,
tourist_id BIGINT UNSIGNED NOT NULL,
tour_id BIGINT UNSIGNED NOT NULL,
discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
started_at DATETIME,
finished_at DATETIME,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
KEY index_of_tourist_id(tourist_id),
KEY index_of_tour_id(tour_id),

FOREIGN KEY (tourist_id) REFERENCES tourists(id),
FOREIGN KEY (tour_id) REFERENCES tours(id)
) COMMENT 'Скидки';


/* 2 часть: наполнение таблиц данными */


INSERT INTO `employees` (`id`, `firstname`, `lastname`, `email`, `address`, `phone`) VALUES 
('1', 'Matrena', 'Nikolaeva', 'bode.alexandro@yandex.ru', '553 Daugherty Circles Suite 758\nPort Eugene, IL 21763-3895', 89648186640),
('2', 'German', 'Smirnov', 'rnader@mail.ru', '1514 Feeney Squares Suite 247\nProvidenciland, KY 84062', 89026980610),
('3', 'Boris', 'Kulaev', 'ncollier@example.net', '03007 Osinski Unions Suite 298\nAlysaville, DE 67026', 89146713222),
('4', 'Carmen', 'Bogatova', 'thodkiewicz@yandex.com', '1856 Elise Road\nLake Aryanna, PA 43966', 89645331448),
('5', 'Roman', 'Tkalich', 'thodkiewicz@ya.ru', '1856 Elise Road\nLake Aryanna, FA 13566', 89027485234),
('6', 'Klava', 'Tillman', 'damon.emmerich@mail.com', '8887 Cynthia Island Apt. 544\nGraysonstad, CA 68463', 89144293256),
('7', 'Annabel', 'Tramp', 'carmela.kihn@example.org', '889 Kerluke Row\nJadestad, IL 34927', 89654885124),
('8', 'Denis', 'Borisov', 'price01@mail.org', '81404 Jerald Courts Suite 268\nHayesshire, OK 89109-2576', 89022307830),
('9', 'Ivan', 'Stankevich', 'daniel.jed@example.org', '6729 Dominic Throughway\nPort Oceane, DE 93486-9378', 89145487436),
('10', 'Matvey', 'Tsyganenko', 'hassie51@ya.ru', '9744 Hilpert Road Apt. 512\nAbbeyland, ND 91782', 89048186845);

/* пришлось отключить проверку внешних ключей*/

SET foreign_key_checks = 0;

INSERT INTO `tourists` (`id`, `contract_number_id`, `gender`, `firstname`, `lastname`, `patronymic`, `passport`, `email`, `address`, `phone`) VALUES 
('1', '6', 'm', 'Evgeniy', 'Savchenko', 'Nikolaevich', '25 15 345652', 'savchenko@yandex.ru', '664146 Russia, Tolyatti, Sverdlova, 17/4-54', 89648649640),
('2', '3', 'm', 'Maksim', 'Evdokimov', 'Mikhailovich', '26 19 345652', 'rnader@mail.ru', '664235 Russia, Petrozavodsk, Pushkina, 220-77', 89026980610),
('3', '5', 'm', 'Albert', 'Petrov', 'Borisovich', '25 13 345652', 'ncollier@example.net', '664037 Russia, Nalchik, pr.Mira, 68-185', 89146713222),
('4', '9', 'f', 'Oksana', 'Vetrova', 'Antonovna', '28 15 345652', 'pioner@yandex.com', '664193 Russia, Irkutsk, Sverdlova, 374-2', 89645331448),
('5', '2', 'm', 'Konstantin', 'Kubaev',  'Ivanovich', '25 17 345652', 'thodkiewicz@ya.ru', '664078 Russia, Chita, Baumana, 216/2-154', 89027485234),
('6', '8', 'f', 'Polina', 'Sivko', 'Romanovna', '24 15 345652', 'damon@mail.com', '664542 Russia, Abakan, Bagrationovsky proyezd, 48-32', 89144293256),
('7', '1', 'f', 'Svetlana', 'Tumanova', 'Vladimirovna', '25 15 345652', 'svet.kihn@example.org', '664251 Russia, Ufa, ul.Delegatskaya, 86-91', 89654885124),
('8', '10', 'm', 'Ruslan', 'Khazanov', 'Olegovich', '25 18 345652', 'price01@mail.org', '664001 Russia, Yaroslavl, ul.Iyerusalimskaya, 37-77', 89022307830),
('9', '4', 'm', 'Anton', 'Ivanenko', 'Alekseevich', '24 15 235147', 'ivanenko@example.org', '664048 Russia, Bryansk, ul.Garazhnaya, 307-11', 89145487436),
('10', '7', 'm', 'Matvey', 'Tsyganenko', 'Vladimirovich', '25 15 345652', 'hassie51@ya.ru', '664053 Russia, Murom, Chongarsky bulvar, 9-25', 89048186845);



INSERT INTO `contracts` (`id`, `deal_id`, `employee_id`, `tourist_id`, `created_at`, `updated_at`) VALUES 
('1', '8', '2', '5', '2005-04-01 08:32:41','2012-04-02 04:23:03'),
('2', '4', '1', '10', '2012-11-23 11:05:45','2017-06-19 19:51:05'),
('3', '6', '9', '7', '2013-04-03 12:12:55','2005-06-03 04:39:30'),
('4', '10', '3', '1', '2007-01-19 22:15:15','2015-07-09 09:11:40'),
('5', '2', '5', '3', '1994-07-20 12:23:54','1993-01-08 03:29:59'),
('6', '9', '7', '4', '1986-01-13 11:19:17','2000-05-26 14:23:01'),
('7', '5', '10', '2', '1986-01-13 11:19:17','2000-05-26 14:23:01'),
('8', '1', '6', '9', '2005-04-01 08:32:41','2012-04-02 04:23:03'),
('9', '7', '4', '6', '2014-09-17 10:57:51','2018-01-29 21:55:12'),
('10', '3', '8', '8', '1997-08-06 08:35:04','2000-02-15 22:55:05');


INSERT INTO `deals` (`id`, `employee_id`, `tourist_id`, `tour_id`, `cost`) VALUES 
('1', '8', '2', '5', '52800'),
('2', '4', '1', '10', '138400'),
('3', '6', '9', '7', '92680'),
('4', '10', '3', '1', '26900'),
('5', '2', '5', '3', '172000'),
('6', '9', '7', '4', '64500'),
('7', '5', '10', '2', '82600'),
('8', '1', '6', '9', '48000'),
('9', '7', '4', '6', '99200'),
('10', '3', '8', '8', '137500');

INSERT INTO `tours` (`id`, `country_id`, `city_id`, `hotel_id`, `airline_id`) VALUES !!!!!!!!!!
('1', '8', '2', '5', '10'),
('2', '4', '1', '10', '5'),
('3', '6', '9', '7', '7'),
('4', '10', '3', '1', '9'),
('5', '2', '5', '3', '2'),
('6', '9', '7', '4', '6'),
('7', '5', '10', '2', '4'),
('8', '1', '6', '9', '3'),
('9', '7', '4', '6', '8'),
('10', '3', '8', '8', '1');

INSERT INTO `citys` (`id`, `country_id`, `name`) VALUES !!!!!!!!
('1', '3', 'Osaka'),
('2', '7', 'Turin'),
('3', '5', 'Ibiza'),
('4', '10', 'Melbourne'),
('5', '1', 'Hanhai'),
('6', '8', 'Netanya'),
('7', '4', 'Belek'),
('8', '9', 'Varna'),
('9', '2', 'Moscow'),
('10', '6', 'Male');


INSERT INTO `countrys` (`id`, `name`) VALUES !!!!!!!!!!!!
	('1', 'China'),
	('2', 'Russia'),
	('3', 'Japan'),
	('4', 'Turkey'),
	('5', 'Spain'),
	('6', 'Maldives'),
	('7', 'Italy'),
	('8', 'Israel'),
	('9', 'Bulgaria'),
	('10', 'Australia');

INSERT INTO `hotels` (`id`, `name`, `category`, `line`) VALUES !!!!!!!!!!!!!
('1', 'Shinagawa Prince', '4*', '0'),
('2', 'Medplaya Hotel Calypso', '3*', '3'),
('3', 'AZIMUT', '5*', '1'),
('4', 'Isrotel Yam Suf', '4*', '1'),
('5', 'Orpheus Island Resort', '5*', '1'),
('6', 'Xinhua', '3*', '0'),
('7', 'Sun Island Resort & SPA', '4*', '2'),
('8', 'Hrizantema', '4*', '1'),
('9', 'Calypso', '3*', '2'),
('10', 'Adam & Eva', '5*', '1');

INSERT INTO `airlines` (`id`, `name`) VALUES !!!!!!!!!!!!
('1', 'Air Japan'),
('2', 'Air Austral'),
('3', 'Air Volga'),
('4', 'Air China'),
('5', 'Amaszonas'),
('6', 'Alitalia'),
('7', 'Ada Air'),
('8', 'Avianova (Russia)'),
('9', 'Air Berlin'),
('10', 'Air France');

INSERT INTO `discounts` (`id`, `tourist_id`, `tour_id`, `discount`, `started_at`, `finished_at`, `created_at`, `updated_at`) VALUES 
('1', '3', '10', '0', '2005-04-01 08:32:41','2012-04-05 04:23:03', '2005-04-01 08:32:41','2012-04-05 04:23:03'),
('2', '6', '4', '5', '2012-11-23 11:05:45','2017-06-19 19:51:05', '2012-11-23 11:05:45','2017-06-19 19:51:05'),
('3', '7', '5', '0', '2013-04-03 12:12:55','2005-06-03 04:39:30', '2013-04-03 12:12:55','2005-06-03 04:39:30'),
('4', '9', '2', '3', '2007-01-19 22:15:15','2015-07-09 09:11:40', '2007-01-19 22:15:15','2015-07-09 09:11:40'),
('5', '10', '1', '0', '2004-07-20 12:23:54','2009-01-08 03:29:59', '2004-07-20 12:23:54','2009-01-08 03:29:59'),
('6', '4', '7', '0', '2020-08-18 10:55:42','2021-01-21 02:51:50', '2020-08-18 10:55:42','2021-01-21 02:51:50'),
('7', '2', '9', '3', '1986-01-13 11:19:17','2000-05-26 14:23:01', '1986-01-13 11:19:17','2000-05-26 14:23:01'),
('8', '8', '3', '5', '2005-04-01 08:32:41','2012-04-02 04:23:03', '2005-04-01 08:32:41','2012-04-02 04:23:03'),
('9', '1', '6', '0', '2014-09-17 10:57:51','2018-01-29 21:55:12', '2014-09-17 10:57:51','2018-01-29 21:55:12'),
('10', '5', '8', '7', '1997-08-06 08:35:04','2000-02-15 22:55:05', '1997-08-06 08:35:04','2000-02-15 22:55:05');

/* Подключаем внешние ключи*/

SET foreign_key_checks = 1;




