-- Из таблиц базы данных, созданной в первой лабораторной работе, 
-- извлечьданныев XML (MSSQL) или JSON(Oracle, Postgres). Для выгрузки 
-- в XML проверить все режимы конструкции FOR XML

select to_json(students) from students; 
select to_json(professors) from professors;
select to_json(subjects) from subjects;
select to_json(StudentGroups) from StudentGroups; 