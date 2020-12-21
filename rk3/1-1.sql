CREATE TABLE IF NOT EXISTS INOUT (
	EmployerId INTEGER NOT NULL,
	DateEvent 	DATE NOT NULL,
	WeekDay varchar(20) NOT NULL,
	TimeEvent Time NOT NULL,
	TypeEvent int not null
);

CREATE TABLE IF NOT EXISTS Employes (
	EmployerId INTEGER NOT NULL,
	FIO varchar(30),
	WeekDay varchar(20) NOT NULL,
	Birthday DATE NOT NULL,
    Department varchar(30)
);

create function if not exists GetAge(Date)
returns int
as $$
    return (DATE_PART('year', current_Date::date - $1));
$$;

-- 1-1
create function qwe()
returns bigint
language sql
as $$
    select count(*)
    from (
        select *
        from Employes
        where EmployerId in (
            select EmployerId
            from (
                select EmployerId, count(*) as counts
                from INOUT
                where TypeEvent = 2
                group by EmployerId
            ) as q
            where counts > 2
        )
    ) as e
    where (DATE_PART('year', current_Date::date- birthday::date)) BetWeen 14 and 40
$$;

select * from qwe();

-- 2-1
drop function qwe2(date);
create function qwe2(date)
returns table
(
    minutes double precision,
    counts int
)
language sql
as $$
    select timelate, count(*)
    from (
        select inout.EmployerId, DATE_PART('minute', min(inout.TimeEvent)::time - '08:00'::time) as timelate
        from inout
        where DateEvent = $1 and TypeEvent = 1
        group by inout.EmployerId
        having min(inout.TimeEvent) > '08:00'
    ) as res
	group by timelate;
$$;

select * from qwe2();

--3-1

drop function qwe3();
create function maxLate(table)
returns int
language sql
as $$
    select max(m)
    from (
        select $1.d, min($1.m) as m
        from $1
        group by $1.d
    )
$$

create function qwe3()
returns int
language sql
as $$
    select min(age)
    from (
        select DATE_PART('year', current_Date::date- birthday::date) as age
        from Employes
        where id in (
                select inout.EmployerId, *
                from inout
                where TypeEvent = 1 and inout.TimeEvent > '08:00'
                group by inout.EmployerId
            )
    )
$$;

select * from qwe3();