-- Создать, развернуть и протестировать 6 объектов SQL CLR
-- 1) Определяемую пользователем скалярную функцию CLR
create or replace function get_student_by_id(id int) 
returns varchar
language plpython3u
as $$
students = plpy.execute("select * from students")
for student in students:
    if student['IdStudent'] == id:
        return student['sname']
return 'None'
$$;

select * from get_student_by_id(15);