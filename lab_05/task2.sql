-- Выполнить загрузку и сохранение XML или JSON файла в таблицу. 
-- Созданная таблица после всех манипуляций должна соответствовать таблице базы данных, 
-- созданной в первой лабораторной работе.

-- сохраняем в файл 
copy (select row_to_json(students) from students) to 'F:\mare\from_win_8\Desktop\bmstu\sem_5\bmstu-BD\lab_05\students.json';
-- создаем временную таблицу
create temp table students_import(doc json);
copy students_import from 'F:\mare\from_win_8\Desktop\bmstu\sem_5\bmstu-BD\lab_05\students.json';

-- json_populate_record
-- Расширяет объект в from_json до строки, столбцы которой соответствуют типу записи, заданному базой.
select *
from students_import, json_populate_record(null::students, doc) as student;

drop table students_import;