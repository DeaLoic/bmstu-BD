drop table if exists json_test;
create temp table if not exists json_test
(
	id serial primary key,
	student varchar(40),
	groupStruct json
);

insert into json_test (student, groupStruct) 
values ('IVAN IVANOV', '{"name" : "IU7-55B", "students" : 23, "enroll" : 1}');
insert into json_test (student, groupStruct) 
values ('PETYA PETROV', '{"name" : "IU7-52B", "students" : 42, "enroll" : 2}');
insert into json_test (student, groupStruct) 
values ('LESYA PETROVA', '{"name" : "IU7-53B", "students" : 21, "enroll" : 3}');
insert into json_test (student, groupStruct) 
values ('ANDREY ANDREYEV', '{"name" : "IU7-54B", "students" : 32, "enroll" : 4}');

select * from json_test;