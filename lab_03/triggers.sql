--  2 DML триггера
-- 1) after
-- 2) instead of 

-- after
-- при смене группы добавляет запись в draft
drop table if exists transfers;
create temp table if not exists transfers
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

select *
from studentgroups;
update students 
set idstudentgroup = 6685633
where IdStudent = 65224;
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

create or replace procedure alertq()
language plpgsql
as
$$
begin
	raise notice 'ols dont delete O:(';
end
$$;

CREATE OR REPLACE FUNCTION abort_delete()
  RETURNS event_trigger
 LANGUAGE plpgsql
  AS $$
BEGIN
  RAISE EXCEPTION 'pls dont delete this, b-b-baka... :(';
END;
$$;

DROP EVENT TRIGGER IF EXISTS abort_delete;
CREATE EVENT TRIGGER abort_delete ON ddl_command_start 
	when tag in ('DROP TABLE', 'DROP SCHEMA')
   EXECUTE PROCEDURE abort_delete();
 DROP TABLE ADMINISTRATION;