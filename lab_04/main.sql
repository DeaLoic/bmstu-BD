-- Создать, развернуть и протестировать 6 объектов SQL CLR
-- 1) Определяемую пользователем скалярную функцию CLR
create or replace function get_student_by_id(id int) 
returns varchar
language plpython3u
as $$
students = plpy.execute("select * from students")
for student in students:
    if student['idstudent'] == id:
        return student['sname']
return 'None'
$$;

select * from get_student_by_id(1);

-- 2) Aggregate function
create or replace function my_sum(prev numeric[2], next numeric)
returns numeric[2] 
as $$
	return [prev[0] + 1, prev[1] + next]
$$ language plpython3u;

create or replace function my_avg_final(num numeric[2])
returns numeric
as $$
	return 0 if num[0] == 0 else num[1] / num[0]
$$ language plpython3u;

create or replace aggregate my_avg(numeric) (
	sfunc = my_sum,
	stype = numeric[],
	finalfunc = my_avg_final,
	initcond = '{0, 0}'
);

select my_avg(age)
from students
union
select my_avg(age)
from professors;

-- 3) Table function
create or replace function get_subject_info_from_sem(sem int)
returns table (
	idsubjectinfo int,
	idsubject int,
	academicsem int
	)
	language plpython3u
	as $$
	sinfos = plpy.execute("select * from subjectinfos")
	result_table = []
	for sinfo in sinfos:
		if sinfo['academicsem'] == sem:
			result_table.append(sinfo)
	return result_table
	$$;
select * from get_subject_info_from_sem(1);

-- 4) procedure
create or replace procedure addAdministrator(id int, typeA int)
language plpython3u
as $$
request = plpy.prepare("insert into administration(IdAdministration, AdministratorType) values($1, $2);", ["int", "int"])
plpy.execute(request, [id, typeA])
$$;

call addAdministrator(100, 1);

select * from administration
where id = 100;

-- 5) Trigger CLR
drop table if exists transfers;
create temp table if not exists transfers
(
	id serial not null,
	studentId int,
	lastGroupId int,
	newGroupId int
);

create or replace function groupChangeCLR()
returns trigger
language plpgsql
as $$
begin 
	as $$
	new = TD['new']
	old = TD['old']
	id = new['IdAdministration']
	oldGroup = old["idstudentgroup"]
	newGroup = new["idstudentgroup"]
	if oldGroup != newGroup:
		request = plpy.prepare("insert into transfers(studentId, lastGroupId, newGroupId) values($1, $2, $3);", ["int", "int", "int"])
		rv = plpy.execute(request, [id, oldGroup, newGroup])
	return None
$$ language plpython3u;
end;
$$;

drop trigger if exists transfersActionCLR on students;
create trigger transfersActionCLR
after update on students
for each row
execute function groupChange();

select *
from studentgroups;
update students 
set idstudentgroup = 6685633
where IdStudent = 65224;
select * from transfers;

-- 6) Определяемый пользователем тип данных CLR
drop function if exists get_characteristics();
drop type if exists characteristics;

create type characteristics as (
    studentAge int,
    studentRepositoriesCount int,
);

create or replace function get_characteristics(id int)
returns characteristics
language plpython3u
as $$
request = plpy.prepare('''
select age, cnt
from (
	(
	select age, idstudent
	from students
	where id = $1
	) as qwe join 
	(
	select idstudent, count(*) as cnt
	from students
	where id = $1
	group by idstudent
	) as ewq on qwe.idstudent = ewq.idstudent
)
''', ["int"])
cur_characteristic = plpy.execute(request, [id])
return (cur_characteristic[0]['age'], cur_characteristic[0]['cnt'])
$$;

select * from get_characteristics(1);