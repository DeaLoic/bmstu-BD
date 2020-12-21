/*
4. Выполнить следующие действия:
1. Извлечь XML/JSON фрагмент из XML/JSON документа
2. Извлечь значения конкретных узлов или атрибутов XML/JSON
документа
3. Выполнить проверку существования узла или атрибута
4. Изменить XML/JSON документ
5. Разделить XML/JSON документ на несколько строк по узлам
*/

-- копируем во временную
drop table if exists pl_import;
create temp table pl_import(doc jsonb);
copy pl_import from 'F:\mare\from_win_8\Desktop\bmstu\sem_5\bmstu-BD\lab_05\students.json';

----- TASK 1 -----
-- Извлечь XML/JSON фрагмент из XML/JSON документа
-- создаем основную
drop table if exists task1;
create temp table if not exists task1
(
	student jsonb
);

-- извлекаем фрагменты
insert into task1 (student)
select  doc
from pl_import
where cast(doc::jsonb->>'idstudent' as int) = 15;

select * from task1;
------------------

----- TASK 2 -----
-- Извлечь значения конкретных узлов или атрибутов   XML/JSON документа
-- создаем основную
drop table if exists task2;
create temp table if not exists task2
(
	id int not null,
	sname text, 
	age int
);
-- извлекаем
insert into task2 (id, sname, age)
select  cast(doc::jsonb->>'idstudent' as int), doc::jsonb->>'sname', cast(doc::jsonb->>'age' as int) 
from pl_import;

select * from task2;
------------------

----- TASK 3 -----
-- Выполнить проверку существования узла или атрибута
SELECT doc::jsonb ? 'sname' as result
from pl_import
where cast(doc::jsonb->>'idstudent' as int) = 15;

SELECT doc::jsonb ? 'qweasd' as result
from pl_import
where cast(doc::jsonb->>'idstudent' as int) = 15;
------------------

----- TASK 4 -----
-- Изменить XML/JSON документ
select doc->>'sname'
from pl_import
where cast(doc->>'idstudent' as int) = 15;

update pl_import
set doc = jsonb_set(doc, '{sname}', '"New Name"')
where cast(doc->>'idstudent' as int) = 15;

update pl_import
set doc = jsonb_set(doc, '{sname}', '"Тина"')
where cast(doc->>'idstudent' as int) = 15;
------------------

----- TASK 5 -----
-- Разделить XML/JSON документ на несколько строк по узлам
drop table if exists task4_1;
drop table if exists task4_2;
create temp table if not exists task4_1
(
	doc jsonb
);
create temp table if not exists task4_2
(
	doc jsonb
);
insert into task4_1(doc)
select doc - 'sname' - 'age'
from pl_import;

select * from task4_1;

insert into task4_2(doc)
select doc - 'idStudent' - 'IdStudentGroup' - 'Login'
from pl_import;

select * from task4_2;