/* 1) Скрипт, возвращающий список клиентов (фамилия, имя, отчество) в алфавитном порядке */

 SELECT lastname, firstname, patronymic 
 FROM tourists 
 ORDER BY lastname;
 
/* 2) Скрипт, возвращающий список сотрудников (только имя) без повторений в алфавитном порядке */

SELECT DISTINCT firstname 
 FROM employees 
 ORDER BY firstname;
 
/* 3) Подсчитаем средний возраст туристов*/

--Создадим столбец birthday и заполним его командой обновления (т.к. уже в заполненной таблице нельзя заполнить один добавленный столбец отдельно)

ALTER TABLE tourists ADD COLUMN birthday DATE;
	
UPDATE tourists
SET   birthday = ('1999-01-06')
WHERE lastname = 'Savchenko';
UPDATE tourists
SET   birthday = ('1970-12-25')
WHERE lastname = 'Evdokimov'; 
UPDATE tourists
SET   birthday = ('2020-01-31')
WHERE lastname = 'Petrov'; 
UPDATE tourists
SET   birthday = ('1989-03-15')
WHERE lastname = 'Vetrova'; 
UPDATE tourists
SET   birthday = ('2017-05-12')
WHERE lastname = 'Kubaev'; 
UPDATE tourists
SET   birthday = ('2000-10-07')
WHERE lastname = 'Sivko'; 
UPDATE tourists
SET   birthday = ('1961-09-18')
WHERE lastname = 'Tumanova'; 
UPDATE tourists
SET   birthday = ('2002-04-01')
WHERE lastname = 'Khazanov'; 
UPDATE tourists
SET   birthday = ('2009-07-30')
WHERE lastname = 'Ivanenko'; 
UPDATE tourists
SET   birthday = ('1984-11-17')
WHERE lastname = 'Tsyganenko';   	

--Создадим столбец age, где вычислим возраст всех пользователей
ALTER TABLE tourists ADD age INT NOT NULL;

-- Делаем вычисления с помощью функции TIMESTAMPDIFF. В скобках указаны единица измерения, день рождения, сегодняшняя дата
UPDATE tourists SET age = TIMESTAMPDIFF(YEAR, birthday, NOW());
-- и ещё вариант
SELECT firstname, FLOOR((TO_DAYS(NOW()) - TO_DAYS(birthday)) / 365.25) AS age FROM tourists;

-- Посмотрим, что получилось
SELECT * FROM tourists;
  
-- Теперь вычислим средний возраст всех пользователей и выведем результат
SELECT AVG(age) FROM tourists; 


/* 4) Скрипт, соединяющий две таблицы и выводящий требуемые поля */

SELECT tourist_id, lastname AS lastname_employee FROM contracts
	INNER JOIN employees ON contracts.employee_id = employees.id ;
	
--- Можно поменять таблицы местами

SELECT tourist_id, lastname AS lastname_employee FROM employees
	INNER JOIN contracts ON contracts.employee_id = employees.id ;
	
/* 5) Выведем id туриста и процент скидки, которая не равна 0 из таблицы "Скидки" */

SELECT tourist_id, discount FROM discounts WHERE discount > 0;


/* 6) Запрос, выводящий несколько полей из нескольких таблиц, связанных посредством LEFT JOIN */

SELECT tours.id, countrys.name, citys.name, hotels.name
	FROM tours
	LEFT JOIN countrys ON country_id = countrys.id
    LEFT JOIN citys ON city_id = citys.id
    LEFT JOIN hotels ON hotel_id = hotels.id;
    
    
/* 7) Запрос на вывод сотрудника и туриста, с которым этот сотрудник заключал контракт*/

SELECT deals.id, employees.lastname AS employee, tourists.lastname AS tourist FROM deals
	INNER JOIN employees ON deals.employee_id = employees.id 
    INNER JOIN tourists ON tourists.id = deals.tourist_id;
   

/* 8) Запрос выводит стоимость тура и Ф.И.О. заданного туриста */

SELECT deals.id, cost, lastname, firstname, patronymic
	FROM deals
	LEFT JOIN tourists ON tourist_id = tourists.id
                  WHERE tourists.id = 9;



/* 9) Вывод фамилий сотрудника и туриста, которого этот сотрудник оформлял посредством вложенных запросов */
 
 SELECT deals.id,	
	(SELECT lastname FROM employees WHERE employee_id = employees.id) AS employee_name,
    (SELECT lastname FROM tourists WHERE tourist_id = tourists.id) AS tourist_name
    FROM deals
		WHERE deals.id = 9;
		
/* 10) Вывод всех полей таблицы с максимальной скидкой */
SELECT * FROM discounts ORDER BY discount DESC LIMIT 5;		
 
