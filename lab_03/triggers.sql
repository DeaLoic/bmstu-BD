--  2 DML триггера
-- 1) after
-- 2) instead of 

-- after
-- при смене группы добавляет запись в draft
drop table if exists transfers;
create table if not exists transfers
(
	id serial not null,
	studentId int,
	lastGroupId int,
	newGroupId int
);

create or replace function groupChange()
returns trigger
language plpgsql
as $$
begin 
	if old.IdStudentGroup <> new.IdStudentGroup then
		insert into transfers(studentId, lastGroupId, newGroupId)
		values (new.IdStudent, old.IdStudentGroup, new.IdStudentGroup);
	end if;
	return new;
end;
$$;

drop trigger if exists transfersAction on students;
create trigger transfersAction
after update on students
for each row
execute function groupChange();

update students 
set idstudentgroup = 1
where IdStudent = 1;
select * from transfers;

-- instead of
-- вместо удаления ставит возраст на 99
drop table if exists professorsCopy cascade;
select *
into temp professorsCopy
from professors;

drop view if exists professors_view;
create view professors_view as
select *
from professorsCopy;

create or replace function updateProfessors()
returns trigger 
language plpgsql
as 	$$
begin
	update professors
	set age = 99
	where IdProfessor = old.IdProfessor ;
	return old;
end;
$$;

drop trigger if exists deleteProfessor on professors_view;
create trigger deleteProfessor
	instead of delete on professors_view
	for each row 
	execute procedure updateProfessors();

delete
from professors_view
where IdProfessor = 39896;

select *
from professors_view
where IdProfessor = 39896;