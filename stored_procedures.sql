
/* 1) Создаем процедуру "фильтр" без параметров. Она выбирает все записи из таблицы countrys, где в столбце name в конце значений стоит «ia».*/

DROP PROCEDURE IF EXISTS filter;
DELIMITER //
CREATE PROCEDURE filter()
BEGIN
SELECT * FROM countrys WHERE name LIKE '%ia';
END//

DELIMITER;

--- Выполним сохраненную процедуру
CALL filter();





/* 2) Выведем в процедуре ФИО туриста и процент скидки, которая не равна 0 отсортировав записи */

DROP PROCEDURE IF EXISTS discount_filter;
DELIMITER //
CREATE PROCEDURE discount_filter()
BEGIN
SELECT 
	(SELECT CONCAT_WS(" ", tourists.lastname, tourists.firstname, tourists.patronymic)
		FROM tourists WHERE id = discounts.tourist_id) AS tourist_name,
	discount,
    started_at
	FROM discounts WHERE discount > 0
    ORDER BY discount DESC;
END//

--- Выполним сохраненную процедуру
CALL discount_filter();

