-- 4 хранимые процедуры
-- 1) хранимую процедуру без параметров или с параметрами
-- 2) рекурсивную хранимую процедуру или хранимую процедуру с рекурсивным ОТВ
-- 3) хранимую процедуру с курсором
-- 4) хранимую процедуру доступа к метаданным

-- хранимую процедуру без параметров или с параметрами
-- добавляет в репозиторий студентов из группы
drop procedure if exists AddStudentsRepos;
drop table if exists StudentsRepositories_copy;

select *
into temp StudentsRepositories_copy
from StudentsRepositories;

create or replace procedure AddStudentsRepos(idRepos int, idGroup int)
language plpgsql
as $$
begin
	insert into StudentsRepositories_copy
    select IdStudent, idRepos
    from students
    where idstudentgroup = idGroup;
end;
$$;

/*
select * from StudentsRepositories;

select idstudentgroup, count(*)
from students
group by idstudentgroup
having count(*) > 1;

*/

call AddStudentsRepos(24951, 6013934);

select * 
from StudentsRepositories_copy where IdRepository = 24951;

-- рекурсивную хранимую процедуру или хранимую процедуру с рекурсивным ОТВ
-- обновляет возраст у студентов в промежутке id
drop procedure if exists changeAge;
drop table if exists studentsCopy;

select *
into temp studentsCopy
from students;

create or replace procedure changeAge(curId int, lastId int, needAge int) 
language plpgsql
as $$
begin
	if curId <= lastId then
		update studentsCopy
		set age = (age + 1)
		where IdStudent = curId and age = needAge;
		call changeAge(curId + 1, lastId, needAge);
	end if;
end;
$$;

call changeAge(500, 900, 26);

select students.age as age_1, studentsCopy.age as age_2
from students join studentsCopy on students.IdStudent = studentsCopy.IdStudent
where students.IdStudent between 500 and 900 and students.age = 26;


-- хранимую процедуру с курсором
-- если возраст меньше заданного, ставит требуемый в заданном интервале
drop procedure if exists changeAgeSmall;
drop table if exists studentsCopy;

select *
into temp studentsCopy
from students;

create or replace procedure changeAgeSmall(newAge int, startid int, endid int, targetAge int) 
language plpgsql
as $$
declare 
	myCursor cursor
	for select *
	from students
	where IdStudent between startid and endid and age < targetAge;
	line record;
begin
	open myCursor;
	loop 
		fetch myCursor into line;
		exit when not found;
		update studentsCopy
		set age = newAge
		where studentsCopy.IdStudent = line.IdStudent;
	end loop;
	close myCursor;
end;
$$;

call changeAgeSmall(15, 1, 1000, 20);

select students.age as age_1, studentsCopy.age as age_2
from students join studentsCopy on students.IdStudent = studentsCopy.IdStudent
where students.IdStudent between 1 and 1000 and students.age < 20;

-- хранимую процедуру доступа к метаданным
-- выводит кол-во всех функций и процедур пользователя
drop procedure if exists getFuncCount();
create or replace procedure getFuncCount()
    language plpgsql
as
$$
declare
	funcsCount int;
begin
    SELECT count(*)
	into funcsCount
	FROM information_schema.routines
	WHERE routine_type
      IN('FUNCTION', 'PROCEDURE');
		
	raise notice 'Count functions and procedures: %', funcsCount;
end
$$;
select *
from information_schema.routines
WHERE routine_type
      is null;
call getFuncCount();