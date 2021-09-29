/* 1 Представления таблицы tourists, в котором выборочные записи будут поддерживаться в отсортированном состоянии.*/
 
DROP VIEW IF EXISTS FIO;
CREATE VIEW FIO (f, i, o, phone)
AS SELECT lastname, firstname, patronymic, phone FROM tourists
ORDER BY lastname;

------- посмотрим на созданную таблицу
SELECT * FROM FIO;

------ созданное представление/таблица появляется в списке таблиц команды SHOW TABLES
SHOW TABLES;


 
/* 2 Представления таблицы max_discount, в котором выборочные записи будут поддерживаться в отсортированном состояни, с обьединением полей и в требуемом количестве.*/
 
DROP VIEW IF EXISTS max_discount;
CREATE OR REPLACE VIEW max_discount AS
SELECT 
    (SELECT CONCAT_WS(" ", tourists.lastname, tourists.firstname, tourists.patronymic) 
    	FROM tourists WHERE id = discounts.tourist_id) AS tourist_name,
    discount, 
	tour_id
FROM discounts
WHERE discount > 0
ORDER BY discount DESC LIMIT 3;

------- посмотрим на созданную таблицу
SELECT * FROM max_discount;



