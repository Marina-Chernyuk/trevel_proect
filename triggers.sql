/* Если вдруг удаляется запись из таблицы со странами, то все города, принадлежащие этой стране, удаляются из таблицы с городами.*/
 
 
CREATE DEFINER=`root`@`localhost` TRIGGER delete_cities
BEFORE DELETE ON countrys
FOR EACH ROW BEGIN
  DELETE FROM citys WHERE country_id = OLD.id;
END



/* Триггер проверяющий дату рождения туриста */

CREATE DEFINER=`root`@`localhost` TRIGGER check_tourist_age_before_update
BEFORE UPDATE 
ON tourists FOR EACH ROW
BEGIN 
	IF NEW.birthday >= CURRENT_DATE() THEN
   	SIGNAL SQLSTATE '45000'
   	SET MESSAGE_TEXT = 'Cancel the update. The date of birth must be in the past.';
   END IF;
END


