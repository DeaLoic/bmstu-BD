-- Разработать 4 функции
-- 1. Скалярную
-- 2. Подставляемую табличную
-- 3. Многооператорную табличную
-- 4. Рекурсивную функцию или функцию с рекурсивным ОТВ

-- Скалярная функция
-- Получает средний возраст студентов
drop function if exists avg_students_age_func();
create function avg_students_age_func() 
returns numeric 
as $$ 
    select avg(age)
    from students;
$$ language sql;

select avg_students_age_func();

-- Подставляемая табличная
-- получает преподавателей, у которых возраст больше заданного
drop function if exists get_professors;
create function get_professors(int) 
returns setof professors
as $$
    select *
    from professors
    where age > $1;
$$ language sql;

select * from get_professors(30);

-- Многооператорная табличная
-- получает профессоров с возрастом больше заданного
drop table if exists proffs;
create table proffs (
	name varchar(20),
	id int,
	age int
);

drop function if exists get_professors_multy;
create function get_professors_multy(int)
returns table
(
    name varchar(20),
    id int,
    age int
)
language sql
as $$
    insert into proffs
	select name, IdProfessor, age
    from professors
    where age > $1;
   
   	select *
    from proffs;
$$;

select *
from get_professors_multy(30);

-- Рекурсивную функцию или функцию с рекурсивным ОТВ(обобщенное табличное выражение)
-- вывести студентов в заданном интервале

drop function if exists get_students_in_interval;
create function get_students_in_interval(cur_id int, end_id int)
returns table
(
    pid int,
    pn varchar(40)
)
language plpgsql
as $$
begin
    return query select IdStudent, SName
    from students
    where IdStudent = cur_id;
    if cur_id < end_id then
        return query select *
            from get_students_in_interval(cur_id + 1, end_id);
    end if;
end;
$$;

select * from get_students_in_interval(2857, 3000);
