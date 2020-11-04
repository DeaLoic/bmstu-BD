/* 1. SELECT С ПРЕДИКАТОМ */
-- Subject info с номерами больше 4
SELECT * FROM SUBJECTINFOS
WHERE ACADEMICSEM > 4
ORDER BY ACADEMICSEM;

/* 2. SELECT С ПРЕДИКАТОМ BETWEEN*/
-- Subject info с номерами больше 2, 3, 4
SELECT * FROM SUBJECTINFOS
WHERE ACADEMICSEM BETWEEN 2 AND 4
ORDER BY ACADEMICSEM;

/* 3. SELECT С ПРЕДИКАТОМ LIKE*/
-- Студентов с отчеством Иванович или Ивановна
SELECT * FROM STUDENTS
WHERE SURNAME LIKE '%Иван%'
ORDER BY SNAME;

/* 4. SELECT С ПРЕДИКАТОМ IN с вложенным подзапросом.*/
-- Студентки, учащиеся на ООП сейчас(6 семестр)
SELECT * FROM STUDENTS
WHERE IDSTUDENTGROUP IN (
	SELECT IDSTUDENTGROUP
	FROM SUBJECTINFOSSTUDENTGROUPS
	WHERE IDSUBJECTINFO IN (
		SELECT IDSUBJECTINFO
		FROM SUBJECTINFOS
		WHERE IDSUBJECT = 0
		AND academicsem = 6))
AND SURNAME LIKE '%вна%'
ORDER BY SNAME;

/* 5. SELECT С ПРЕДИКАТОМ EXISTS с вложенным подзапросом.*/
-- Получить профессоров, не ведущих ни один предмет (пусто дожно быть)
SELECT * FROM PROFESSORS AS PR
WHERE EXISTS (
	SELECT * FROM PROFESSORSSUBJECTS
	WHERE IDPROFESSOR = PR.IDPROFESSOR
);

/* 6. SELECT С предикатом сравнения с квантором..*/
-- Преподаватели, которые старше любого из студентов ////////
SELECT * FROM PROFESSORS
WHERE age > ANY (
	select age from Students
);

/* 7. Инструкция SELECT, использующая агрегатные функции в выражениях
столбцов. */
-- Преподаватели и кол-во предметов, которые они ведут
SELECT idprofessor as id, count(idsubject)
from PROFESSORSSUBJECTS
group by idprofessor;

/* 8. Инструкция SELECT, использующая скалярные подзапросы в выражениях
столбцов. */
--- группы и максимальны и минимальный возраст студентов в них, а так же их кол-во
select idstudentgroup, 
(
	select max(age)
	from students
	where students.idstudentgroup = studentgroups.idstudentgroup
) as maxAge,
(
	select min(age)
	from students
	where students.idstudentgroup = studentgroups.idstudentgroup
) as minAge,
(
	select count(age)
	from students
	where students.idstudentgroup = studentgroups.idstudentgroup
) as cntOfStudents
from studentgroups;

/* 9. Инструкция SELECT, использующая простое выражение CASE. */
-- Преподаватели и классификация их по возрастам
select idprofessor,
	case age
		WHEN (select max(age) from professors) then 'oldest'
		WHEN (select min(age) from professors) then 'yongest'
		else 'medium'
	end as ageClass,
	age
from professors;

/* 10. Инструкция SELECT, использующая поисковое выражение CASE. */
-- Преподаватели и классификация их по возрастам
select idprofessor,
	case
		WHEN (age > 55) then 'old'
		WHEN (age < 25) then 'yong'
		else 'medium'
	end as ageClass,
	age
from professors;

/* 11. Создание новой временной локальной таблицы из результирующего набора
данных инструкции SELECT. */
select students.idstudentgroup
into tmp
from students;

drop table tmp;

/* 12. Инструкция SELECT, использующая вложенные коррелированные
подзапросы в качестве производных таблиц в предложении FROM. */
--  сопоставить subjectinfo студентам
select subjectinfos.idsubjectinfo, sname, surname
from students join 
(
	subjectinfos join subjectinfosstudentgroups on subjectinfos.idsubjectinfo = subjectinfosstudentgroups.idsubjectinfo
) on students.idstudentgroup = subjectinfosstudentgroups.idstudentgroup;

/* 13. Инструкция SELECT, использующая вложенные подзапросы с уровнем
вложенности 3. */
-- студенты, учащиеся на предметах, чьи преподаватели старше 55
select idstudent
from students
where idstudentgroup in
(
	select idstudentgroup
	from subjectinfosstudentgroups join subjectinfos on subjectinfosstudentgroups.idsubjectinfo =
	subjectinfos.idsubjectinfo
	where subjectinfos.idsubject in
	(
		select idsubject
		from professorssubjects
		where idprofessor in
		(
			select idprofessor
			from professors
			where age > 55
		)
	)
);

/* 14. Инструкция SELECT, консолидирующая данные с помощью предложения
GROUP BY, но без предложения HAVING */
-- преподаватели и кол-во предметов, которые они ведут
select idprofessor, count(idsubject)
from professorssubjects
group by idprofessor;

/* 15. Инструкция SELECT, консолидирующая данные с помощью предложения
GROUP BY и предложения HAVING. */
-- преподаватели ведущие больше 2х предметов
select idprofessor
from professorssubjects
group by idprofessor
having count(idsubject) > 2;

/* 16. Однострочная инструкция INSERT, выполняющая вставку в таблицу одной
строки значений. */
insert into students (idstudent, idstudentgroup, login, sname, surname, age)
values (1, null, 'PKhetagurov', 'Pashok', 'Khetagurov', 20);

/* 20.  Простая инструкция DELETE. */
delete from students
where idstudent = 1;

/* 17. Многострочная инструкция INSERT, выполняющая вставку в таблицу
результирующего набора данных вложенного подзапроса. */
insert into students (idstudent, idstudentgroup, login, sname, surname, age)
select (
    select max(students.idstudent) + 1
    from students
), max(studentgroups.idstudentgroup), 'IVAVA', 'Ivana', 'Ivavich', 22
from studentgroups
where studentgroups.enrollacademicsem = 6;

/* 21. Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE. */
delete from students
where idstudent = 
(
	select max(idstudent)
	from students
) and sname = 'Ivana';

/* 18. Простая инструкция UPDATE. */
update students
set age = 20
where idstudent = 
(
	select max(idstudent)
	from students
);

/* 19.  Инструкция UPDATE со скалярным подзапросом в предложении SET. */
update students
set age = 
(
    select avg(age)
    from students
)
where idstudent = 
(
	select max(idstudent)
	from students
);

/* 22. Инструкция SELECT, использующая простое обобщенное табличное выражение */
-- средний возраст студентов старше двадцати в группах, в которых такие есть
with tmpStudents (id, idgroup, age)
as 
(
	select students.idstudent, students.idstudentgroup, students.age
	from students
	where age > 20
)
select idgroup, avg(age)
from tmpStudents
group by idgroup;

/* 23. Инструкция SELECT, использующая рекурсивное обобщенное табличное
выражение. */
-- всех студентов из группы студента с id 8659
with recursive selectStudents(idstudentgroup, idstudents, name) as
(
	select students.idstudentgroup, students.idstudent, studentgroups.name
	from students join studentgroups on students.idstudentgroup = studentgroups.idstudentgroup
	where students.idstudent = 8659
	
	union
	select students.idstudentgroup, students.idstudent, selectStudents.name
	from students INNER join selectStudents on students.idstudentgroup = selectStudents.idstudentgroup
)
select *
from selectStudents;


/* 24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER() */
-- студенты, их возраст, максимальный минимальный средний возраст по группе и кол-во
-- студентов в группе
select students.sname, age,
		min(students.age) over (partition by idstudentgroup),
		max(students.age) over (partition by idstudentgroup),
		avg(students.age) over (partition by idstudentgroup),
		count(*) over (partition by idstudentgroup)
from students;

/* 25. Оконные фнкции для устранения дублей */
-- получить уникальные возраста студентов
select *
from
(
	select age, row_number() over (partition by age) as id
	from students
) as ages
where id = 1;

