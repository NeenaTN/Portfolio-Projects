 drop table users;
create table users
(
user_id int primary key,
user_name varchar(30) not null,
email varchar(50));

insert into users values
(1, 'Sumit', 'sumit@gmail.com'),
(2, 'Reshma', 'reshma@gmail.com'),
(3, 'Farhana', 'farhana@gmail.com'),
(4, 'Robin', 'robin@gmail.com'),
(5, 'Robin', 'robin@gmail.com');

select * from users;

--1) Find the duplicate records in the table--

select user_id,user_name,email
from
(
		select u.*,
		row_number()over (partition by user_name order by user_id) as Row_Num
		from users u
		
)x

where x.Row_Num >1

--Query 2
drop table employee
create table employee
( emp_ID int primary key
, emp_NAME varchar(50) not null
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);

select *from employee
drop table employee

--2. Write a SQL query to fetch the second last record from  each dept
--   from the employee table.

select emp_id,emp_name,dept_name,salary from
(
        select e.*,
		row_number() over (partition by dept_name order by emp_id desc) as rn
		from employee e
)x
where x.rn=2

--3) Write a SQL query to fetch the second last record from the employee table

select emp_id,emp_name,dept_name,salary from
(
		select e.*,
		row_number() over (order by emp_id desc) as rn
		from employee e
)x
where x.rn =2

--4) Write a SQL query to display only the details of employees who either earn the 
--highest salary or the lowest salary in each department from the employee table.

--solution:write a subquery to find out max or min of salary for each department as x.
--         join X and employee table based on emp_id & salary 

select *from employee

select e.* from 

(
		select *,
		Max(salary) over (partition by dept_name ) as Max_Salary,
		Min(salary) over (partition by dept_name  ) as Min_Salary	
		from employee e ) x

inner join employee e
on e.emp_ID=x.emp_ID and (e.SALARY= x.Max_Salary or e.SALARY=x.Min_Salary)
order by e.DEPT_NAME, e.SALARY

-- OR solution by CTE

with max_min_salary as 
(
     select e.*,
	 max(salary) over (partition by dept_name) as max_salary,
	 min(salary) over (partition by dept_name) as min_salary
	 from employee e ) 

	 select e.* from employee as e
	 inner join max_min_salary as mm
	 on e.emp_id=mm.emp_id and (e.SALARY=mm.max_salary or e.SALARY=mm.min_salary)
	 order by e.DEPT_NAME,e.SALARY


create table doctors
(
id int primary key,
name varchar(50) not null,
speciality varchar(100),
hospital varchar(50),
city varchar(50),
consultation_fee int
);

insert into doctors values
(1, 'Dr. Shashank', 'Ayurveda', 'Apollo Hospital', 'Bangalore', 2500),
(2, 'Dr. Abdul', 'Homeopathy', 'Fortis Hospital', 'Bangalore', 2000),
(3, 'Dr. Shwetha', 'Homeopathy', 'KMC Hospital', 'Manipal', 1000),
(4, 'Dr. Murphy', 'Dermatology', 'KMC Hospital', 'Manipal', 1500),
(5, 'Dr. Farhana', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1700),
(6, 'Dr. Maryam', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1500);

--5) From the doctors table, fetch the details of doctors who work in
--   the same hospital but in different specialty.

-- we need to compare each records in the table to every different record of the same table
-- we use self joins here

select * from doctors;
select d1.id,d1.name,d1.speciality,d1.hospital
from doctors d1
inner join doctors d2
on d1.id <>d2.id and d1.speciality <>d2.speciality and d1.hospital=d2.hospital

--6) From the doctors table, fetch the details of doctors who work in
--   the same hospital irrespective of speciality

select *from doctors

select d1.id,d1.name,d1.speciality,d1.hospital
from doctors d1
join doctors d2
on d1.hospital=d2.hospital and d1.id<>d2.id

drop table login_details

create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

insert into login_details values
(101, 'Michael', GETDATE()),
(102, 'James', getdate()),
(103, 'Stewart', getdate()+1),
(104, 'Stewart', getdate()+1),
(105, 'Stewart', getdate()+1),
(106, 'Michael', getdate()+2),
(107, 'Michael', getdate()+2),
(108, 'Stewart', getdate()+3),
(109, 'Stewart', getdate()+3),
(110, 'James', getdate()+4),
(111, 'James', getdate()+4),
(112, 'James', getdate()+5),
(113, 'James', getdate()+6);

--7)  From the login_details table, fetch the users who logged in 
--   consecutively 3 or more times.
 
 --solution write a subquery to find out the list of repeated users.
 --         write the main query to call distinct names of repeated users from subquery.

select *from login_details

select distinct user_name from
(
			 select login_id,user_name,
			 case when user_name = lead(user_name) over (order by login_id) and user_name=  lead(user_name,2) over (order by login_id)
								   then user_name
								   else NULL 
								   END as repeated_users
			from login_details) X
			where X.repeated_users is not NULL

create table students
(
id int primary key,
student_name varchar(50) not null
);
insert into students values
(1, 'James'),
(2, 'Michael'),
(3, 'George'),
(4, 'Stewart'),
(5, 'Robin');

8)From the students table, write a SQL query to interchange the adjacent student names.

--solution - Used lead and lag functions on student names.
--           As id's are unique and sequential worked on a condition where
--           id is odd number then used lead function & when id is even then used lag function
--           to interchange the adjacent names
               
select *from students

select id ,student_name ,
case when id%2 <> 0 then lead(student_name,1,student_name) over (order by id)
     when id%2 = 0 then lag (student_name) over (order by id)
		  END as New_Students_Table
 from students

 create table weather
(
id int,
city varchar(50),
temperature int,
day date
);
insert into weather values
(1, 'London', -1, '2021-01-01'),
(2, 'London', -2, '2021-01-02'),
(3, 'London', 4, '2021-01-03'),
(4, 'London', 1, '2021-01-04'),
(5, 'London', -2, '2021-01-05'),
(6, 'London', -5, '2021-01-06'),
(7, 'London', -7, '2021-01-07'),
(8, 'London', 5, '2021-01-08');

select * from weather;
drop table weather

--9) From the weather table, fetch all the records when London had extremely 
--   cold temperature for 3 consecutive days or more.

--solution -Using lead and lag functions to analyze the consecutive records
--          Temperature less than 0 is considered to be extreme cold temperature
select *from
(
	select *,
		case when temperature<0 
		and lead(temperature) over (order by id)<0 
		and lead (temperature,2)over (order by id)<0 then 'yes'        

	    when temperature<0 
		and lag (temperature) over (order by id)<0 
		and lead (temperature)over (order by id)<0 then 'yes'
        
		when temperature<0 
		and lag (temperature) over (order by id)<0 
		and lag (temperature,2)over (order by id)<0 then 'yes'
        else Null
		end as Flag
	    from weather w
		) x

where x.flag is not NULL

drop table patient_logs
create table patient_logs
(
  account_id int,
  Date date,
  patient_id bigint
);

insert into patient_logs values (1, '2020-01-02', 100);
insert into patient_logs values (1, '2020-01-27', 200);
insert into patient_logs values (2, '2020-01-01', 300);
insert into patient_logs values (2, '2020-01-21', 400);
insert into patient_logs values (2, '2020-01-21', 300);
insert into patient_logs values (2, '2020-01-01', 500);
insert into patient_logs values (3, '2020-01-20', 400);
insert into patient_logs values (1, '2020-03-04', 500);
insert into patient_logs values (3, '2020-01-20', 450);

drop table patient_logs;

select *from patient_logs
--10. Find the top 2 accounts with the maximum number of unique
--   patients on a monthly basis

select *from patient_logs
select *
from   
      (select *,
		rank() over (partition by x.months order by Num_Patients desc, x.account_id asc) as Rn
        from
			(select p.account_id,p.months,count(distinct(p.patient_id)) Num_Patients
			from     
				(select pl.account_id,month(pl.date)as months,pl.patient_id
					from patient_logs pl)p
			group by p.account_id,p.months) x
		
		 )a
where a.Rn < 3

-- or

select top 2 account_id, count (distinct (patient_id)) , month(date) as months from patient_logs

group by month(date),account_id

order by count(distinct(patient_id)) desc , account_id asc 

