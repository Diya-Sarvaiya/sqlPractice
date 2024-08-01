--1.
select product_id from Products
where low_fats='Y' and recyclable='Y'

--2. 
select name from Customer
where referee_id != 2 or referee_id is null

select name from Customer
where COALESCE(referee_id,0) != 2

--3. 
select name,population,area from World
where population >= 25000000 or area>=3000000

--4. 
select distinct author_id as id from Views
where author_id = viewer_id
order by author_id

--5.
select tweet_id from Tweets
where len(content) >15

-- joins

--6. 
select unique_id,name
from Employees
left join EmployeeUNI
on Employees.id = EmployeeUNI.id

--7. 
select Product.product_name,year,price from sales
inner join Product
on sales.product_id = Product.product_id

--8.
select Visits.customer_id,count(Visits.customer_id) as count_no_trans from Visits
left join Transactions
on Visits.visit_id = Transactions.visit_id
where Transactions.transaction_id is null
group by Visits.customer_id
order by count_no_trans

--9.
select w2.id from Weather w1
full outer join weather w2
on datediff(day,w1.recordDate,w2.recordDate) =1
where w1.temperature < w2.temperature

--10.
select a1.machine_id,
round(sum(a2.timestamp-a1.timestamp)/count(a1.process_id),3) as processing_time from Activity a1
inner join Activity a2
on a1.machine_id = a2.machine_id and a1.process_id = a2.process_id and a1.activity_type = 'start'
where a1.activity_type='start' and a2.activity_type='end'
group by a1.machine_id

--11.
select name,bonus from employee
left join Bonus
on employee.empId = Bonus.empId
where coalesce(bonus,0) < 1000

--12. 
select std.student_id,std.student_name,sub.subject_name,count(exm.student_id) as attended_exams
from Students std
cross join Subjects sub
left outer join Examinations exm
on std.student_id = exm.student_id and sub.subject_name = exm.subject_name
group by std.student_id,std.student_name,sub.subject_name
order by student_id

--13. 
select e1.name from Employee e1
left join Employee e2
on e1.id = e2.managerId
group by e1.name
having count(e2.managerId)>=5

-------

--14.
select s.user_id,
round(avg(case when action='confirmed' then 1.0 else 0.0 end),2) as confirmation_rate 
from Signups s
left join Confirmations c 
on s.user_id = c.user_id
group by s.user_id

--15.
select * from Cinema 
where id %2 !=0 and description!='boring'
order by rating desc

--16.
select p.product_id,
coalesce(round(sum(u.units*p.price)/(sum(units)*1.0),2),0) as average_price from Prices p
left join UnitsSold u
on p.product_id = u.product_id and u.purchase_date between p.start_date and p.end_date
group by p.product_id

--17.
select p.project_id,
coalesce(Round(sum(e.experience_years)/(count(p.employee_id)*1.0),2),0) as average_years 
from Project p
left join Employee e
on p.employee_id = e.employee_id
group by p.project_id

--18.
select r.contest_id,
round(((count(u.user_id)*1.0/(select count(user_id) from Users))*100),2) as percentage 
from Register r
left join Users u
on u.user_id = r.user_id
group by r.contest_id
order by percentage desc,contest_id asc

--19.
select query_name,
round((sum(rating*1.0/position)/(count(query_name)*1.0)),2) as quality,
round((avg(case when rating <3 then 1.0 else 0.0 end)*100),2) as poor_query_percentage 
from Queries
group by query_name
having query_name is not null

select query_name,
round((avg(rating*1.0/position)),2) as quality,
round((avg(case when rating <3 then 1.0 else 0.0 end)*100),2) as poor_query_percentage 
from Queries
group by query_name
having query_name is not null

--20.
select 
    format(trans_date,'yyyy-MM') as month,
    country,
    count(id) as trans_count,
    count(case when state='approved' then id end) as approved_count ,
    coalesce(sum(amount),0) as trans_total_amount,
    coalesce((sum(case when state='approved' then amount end)),0) as approved_total_amount 
from Transactions
group by format(trans_date,'yyyy-MM'),country
order by month


--21.
SELECT 
    round((avg(CASE 
        WHEN first_start_date = last_end_date THEN 1.0
        else 0.0 
    END)*100),2) AS immediate_percentage 
FROM 
    (SELECT 
        customer_id,
        MIN(delivery_id) AS first_order_id,
        MIN(order_date) AS first_start_date,
        MIN(customer_pref_delivery_date) AS last_end_date
    FROM 
        Delivery
    GROUP BY 
        customer_id) as abc


--22. Game Play Analysis IV
select 
    round((count(a1.player_id)*1.0/(select count(distinct a3.player_id) from Activity a3)),2) as fraction
from 
    (select player_id, min(event_date) as day1,
    dateadd(day,1,min(event_date)) as next_day  
    from Activity a 
    group by player_id) a1
inner join Activity a2
on a1.player_id = a2.player_id and a2.event_date=a1.next_day


--23. Number of Unique Subjects Taught by Each Teacher 
select teacher_id,count(distinct subject_id) cnt from Teacher
group by teacher_id


--24. User Activity for the Past 30 Days I
select 
    activity_date as day,
    count(distinct user_id) as active_users
from Activity
where datediff(day,activity_date,'2019-07-27')<30 and activity_date<='2019-07-27'
group by activity_date


--25. Product Sales Analysis III
With cte as (Select product_id, Min(year) as min_year
from Sales
group by product_id)

Select product_id,
year as first_year,
quantity,
price
from Sales
where exists(
    Select true
    from cte
    where cte.min_year = sales.year and cte.product_id = sales.product_id
)

--26. Classes More Than 5 Students
select class
from Courses
group by class
having count(distinct student) >=5

--27. Find Followers Count
select
    user_id,
    count(follower_id) as followers_count
from Followers
group by user_id
order by user_id

--28. Biggest Single Number
with cte as (
    select 
        num
    from MyNumbers  
    group by num
    having count(num)=1 )

select max(num) as num from cte

--29. Customers Who Bought All Products
select customer_id from Customer
group by customer_id
having count(distinct product_key) = (select count(product_key) from Product)

--30. The Number of Employees Which Report to Each Employee
with cte as (
    select
        reports_to,
        count(employee_id) as reports_count,
        round(avg(age),0) as average_age
    from Employees
    where reports_to is not null
    group by reports_to
   
)
select e.employee_id,e.name,cte.reports_count,cte.average_age from Employees e
inner join cte
on e.employee_id = cte.reports_to
order by employee_id

--31. Primary Department for Each Employee
with cte as (
    select 
    employee_id,
    (case 
    when count(department_id) = 1 then max(department_id)
    else min(case when primary_flag='Y' then department_id end)
    end) as department_id 
    from Employee
    group by employee_id
)

select * from cte
where department_id is not null

--32. Triangle Judgement
select x,y,z,
(case 
    when x+y>z and x+z>y and y+z>x then 'Yes'
    else 'No' 
end) as triangle
from Triangle


--33. Consecutive Numbers
with cte as (
    select id,num,id-row_number() over(partition by num order by id asc) rr from Logs
)

select distinct num as ConsecutiveNums
from cte
group by num,rr
having count(*) >=3

--34. Product Price at a Given Date !!1
With cte as(
SELECT 
    product_id, 
    MAX(change_date) AS change_date
from 
    Products
where 
    change_date <= '2019-08-16'
group by 
    product_id
)
,cte2 as(Select distinct product_id from Products)

Select 
cte2.product_id, 
Coalesce(p.new_price, 10) as price

from cte2 
left join cte
on cte2.product_id = cte.product_id

left join Products p
on cte.change_date = p.change_date
and cte.product_id = p.product_id

--35. Last Person to Fit in the Bus
with cte as (
    select
        person_name,
        turn,
        SUM(weight) OVER (ORDER BY turn) as total_weight 
    from Queue
)
select
    top 1 person_name
from cte
where total_weight<=1000
order by total_weight desc

--36. Count Salary Categories
SELECT 
    'Low Salary' AS category,
    COUNT(account_id) AS accounts_count
FROM Accounts
WHERE income < 20000

UNION ALL

SELECT 
    'Average Salary' AS category,
    COUNT(account_id) AS accounts_count
FROM Accounts
WHERE income BETWEEN 20000 AND 50000

UNION ALL

SELECT 
    'High Salary' AS category,
    COUNT(account_id) AS accounts_count
FROM Accounts
WHERE income > 50000;

--37. Employees Whose Manager Left the Company
with cte as (
    select employee_id,manager_id from Employees
    where manager_id is not null
    and salary<30000
)
select cte.employee_id
from cte
left join Employees e
on cte.manager_id = e.employee_id
where e.employee_id is null
order by cte.employee_id

--38. Exchange Seats
select 
    (case
    when id=(select max(id) from seat) and id%2=1 then id
    when id % 2=0 then id-1
    else id+1 end)
    as id,
    student
from Seat
order by id 


--39. Movie rating
with cte1 as (
    select user_id,count(movie_id) as counts from Movierating 
    group by user_id
), cte2 as(
    select movie_id,avg(rating*1.0) as avg_rating from MovieRating 
    where created_at between '2020-02-01' and '2020-02-29'
    group by movie_id
)
select results from
(
    select top 1 name as results from cte1
    left join Users
    on cte1.user_id = Users.user_id
    where counts = (select max(counts) from cte1)
    order by name asc
) as m1

union all

select results from (
    select top 1 title as results from cte2
    left join Movies
    on cte2.movie_id = Movies.movie_id
    where avg_rating = (select max(avg_rating) from cte2)
    order by title asc
) as m2

--40. Restaurant Growth

WITH cte AS (
    SELECT 
        visited_on,
        SUM(amount) AS total_amount
    FROM 
        Customer
    GROUP BY 
        visited_on
), cte2 as (
    SELECT 
    visited_on,
    ROUND(sum(total_amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS amount,
    ROUND(AVG(total_amount*1.0) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS              average_amount
FROM cte
)
select c1.visited_on,c1.amount,c1.average_amount from cte2 c1
inner join cte2 c2
on c1.visited_on = dateadd(day,6,c2.visited_on)

--41. Friend Requests II: Who Has the Most Friends

with cte1 as (
    select requester_id,count(requester_id) as req from RequestAccepted 
    group by requester_id
),
cte2 as (
    select accepter_id ,count(accepter_id ) as acc from RequestAccepted 
    group by accepter_id 
)

 
    select top 1
        coalesce(cte1.requester_id,cte2.accepter_id) as id,
        coalesce(req,0)+coalesce(acc,0) as num
    from cte1
    full outer join cte2
    on cte1.requester_id = cte2.accepter_id
    order by num desc

--42. Investments in 2016

select round(sum(tiv_2016),2) as tiv_2016 from Insurance i
where exists (
    select 1 from Insurance
    where tiv_2015 = i.tiv_2015
    group by tiv_2015
    having count(*)>1
)and exists (
    select 1 from Insurance
    where lat = i.lat and lon = i.lon
    group by lat,lon
    having count(*)=1
);

--43. Department Top Three Salaries

with cte2 as (
    select departmentId,salary from Employee
    group by departmentID,salary
),cte3 as (
    select 
        departmentId,
        salary,
        row_number() over(partition by departmentId order by salary desc) rr 
    from cte2
)

select d.name as Department,e.name as Employee,e.salary as Salary
from Employee e
inner join cte3
on e.departmentId = cte3.departmentId
inner join Department d
on e.departmentID = d.id
and e.salary = cte3.salary
where rr<=3
order by e.salary desc

--44. Fix Names in a Table
select 
    user_id,
    (upper(substring(name,1,1))+lower(substring(name,2,len(name)))) as name
from Users
order by user_id

--45. select * from Patients
where conditions like '% DIAB1%' or conditions like 'DIAB1%'



--46. Delete Duplicate Emails
with cte as (
    select id,email,row_number() over(partition by email order by id) as rr from Person
)
delete from cte
where rr>1

--47.  Second Highest Salary

with cte as (
    select salary,
    row_number() over(order by salary desc) as rr
    from Employee
    group by salary
)
select 
(case 
    when count(*)<2 then null 
    else (select salary from cte where rr=2)
end)
 as SecondHighestSalary  from cte


 --48. Group Sold Products By The Date
 select 
    sell_date,
    COUNT(DISTINCT product) as num_sold,
    string_agg(product,',') as products
from (
    SELECT DISTINCT sell_date, product
    FROM Activities
) AS cte
group by sell_date

--49. List the Products Ordered in a Period
with cte as (
    select product_id,sum(unit) as unit
    from Orders
    where order_date between '2020-02-01' and '2020-02-29'
    group by product_id
)

select product_name,unit from cte 
inner join Products
on cte.product_id = Products.product_id
where unit>=100


--50. Find Users With Valid E-Mails
select 
    user_id,
    name,
    mail
from users
where mail like '[a-zA-Z]%@leetcode.com' AND LEFT(mail, LEN(mail) - 13) NOT LIKE '%[^0-9a-zA-Z_.-]%'