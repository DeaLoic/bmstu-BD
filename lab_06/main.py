import psycopg2
conn = psycopg2.connect(
    dbname='bmstu_git',
    user='postgres',
    password='postgres',
    host='localhost'
)
cursor = conn.cursor()

# 1. Выполнить скалярный запрос
def f1():
    request = 'select sname, surname, login from students where IdStudent = 15'
    cursor.execute(request)
    result = cursor.fetchall()[0]
    print('Name: ' + result[0] + ', surname: ' + result[1] + ', login: ' + result[2])


# 2.Выполнить запрос с несколькими соединениями (JOIN)
# сопоставить subjectinfo студентам
def f2():
    request = '''
                select subjectinfos.idsubjectinfo, sname, surname
                from students join 
                (
                    subjectinfos join subjectinfosstudentgroups on subjectinfos.idsubjectinfo = subjectinfosstudentgroups.idsubjectinfo
                ) on students.idstudentgroup = subjectinfosstudentgroups.idstudentgroup
                where IdStudent = 15'''
    cursor.execute(request)
    for result in cursor.fetchall():
        print('idsubjectinfo: ' + str(result[0]) + ', sname: ' + result[1] + ', surname: ' + result[2])

# 3. Выполнить запрос с ОТВ(CTE) и оконными функциями
def f3():
    request = '''
            select IdStudentGroup, count(*)
            from (
                select IdStudentGroup, avg(age) over (partition by IdStudentGroup) > age as isHigher
                from (
                    select IdStudentGroup, idstudent, age
                    from students
                    where idstudentgroup < 100000
                ) as cur
            ) as qwe
            where isHigher = True
            group by IdStudentGroup
    '''
    cursor.execute(request)
    for row in cursor:
        print('IdStudentGroup: ' + str(row[0]) + ', Higher than avg: ' + str(row[1]))

# 4. Выполнить запрос к метаданным;
def f4():
    request = '''
    SELECT count(*)
	FROM information_schema.routines
	WHERE routine_type
      IN('FUNCTION', 'PROCEDURE');
    '''
    cursor.execute(request)
    print(cursor.fetchall()[0][0])
    
# 5. Вызвать скалярную функцию
def f5():
    request = 'select * from avg_students_age_func()'
    cursor.execute(request)
    result = cursor.fetchall()[0][0]
    print('Avg student age: ', result)

# 6. Вызвать многооператорную или табличную функцию
def f6():
    request = 'select * from get_professors_multy(50)'
    cursor.execute(request)
    for row in cursor:
        print('Id: ' + str(row[1]) + ', name: ' + str(row[0]) + ', age: ' + str(row[2]))

# 7. Вызвать хранимую процедуру
#Вызвать хранимую процедуру (написанную в третьей лабораторной работе)
def f7():
    request = "call getFuncCount();"
    cursor.execute(request)
    print(conn.notices[-1])

# 8. Вызвать системную функцию или процедуру
def f8():
    request = 'select version()'
    cursor.execute(request)
    print(cursor.fetchall()[0][0])

# 9. Создать таблицу в базеданных, соответствующую тематике БД
def f9():
    request = '''
    drop table if exists administration;
    create table if not exists administration (
        IdAdministration int primary key,
        AdministratorType int
    );
    '''
    cursor.execute(request)
    conn.commit()

# Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY.
def f10(id=101, typeA=2):
    request = f'''
    insert into administration(IdAdministration, AdministratorType)
    values({id}, {typeA})
    '''
    cursor.execute(request)
    conn.commit()

menu = '''0 - Выход
1. Скалярный запрос
2. Запрос с несколькими соединениями
3. Запрос с ОТВ(CTE) и оконными функциями
4. Запрос к метаданным
5. Скалярная функция
6. Многооператорная функция
7. Хранимая процедура
8. Системная функция
9. Создать таблицу
10. Вставить в таблицу
'''
print(menu)
choice = 1

while choice != 0:
    choice = int(input('Выбор: '))
    if choice == 1:
        f1()
    elif choice == 2:
        f2()
    elif choice == 3:
        f3()
    elif choice == 4:
        f4()
    elif choice == 5:
        f5()
    elif choice == 6:
        f6()
    elif choice == 7:
        f7()
    elif choice == 8:
        f8()
    elif choice == 9:
        f9()
    elif choice == 10:
        f10()


cursor.close()
conn.close()