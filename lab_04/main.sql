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
create or replace procedure