--Retail Sales Analysis

--IN SQL Project Database
--Create Table

create table Retail_Sales
(
	transactions_id	int primary key,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(6),
	age	int,
	category varchar(20),	
	quantiy	int,
	price_per_unit float,	
	cogs float,
	total_sale float
);

--To see the data
select * from Retail_Sales order by transactions_id ;

--Column quantity is Mistake so Rename it
alter table Retail_Sales
Rename column quantiy to quantity;

--To check null values
select * from Retail_Sales
where transactions_id is null
		or 
		sale_date is null
		or 
		sale_time is null
		or 
		customer_id is null
		or 
		gender is null
		or 
		age is null
		or
		category is null
		or 
		quantity is null
		or 
		price_per_unit is null
		or 
		cogs is null
		or 
		total_sale is null; 

--In age column there were null value and 
--handle with the mode from age itself
UPDATE Retail_Sales
SET age = (
    SELECT age
    FROM Retail_Sales
    WHERE age IS NOT NULL
    GROUP BY age
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
WHERE age IS NULL;

--Now handle null values in quantity table
--For small amount of null values we can delete is good.
delete from Retail_Sales
where quantity is null;

--To find Duplicate values
select count(transactions_id) from Retail_Sales
group by transactions_id
having count(transactions_id)>1;

--Data Exploration

--Count of Total sales
select count(*) as Total_sales from Retail_Sales;
--OR
select count(transactions_id) as Total_sales from Retail_Sales;

--Total Customers we have
select count(distinct customer_id) as Total_Customers from Retail_Sales;

--Total Category of Sale we have
select distinct category from Retail_Sales;

/*NOW OUR DATA IS CLEAN AND WE CAN APPLY BUSINESS LOGIC*/

--Q.1 Find all data of sales made on '2022-11-05':
select * from Retail_Sales
where sale_date = '2022-11-05';

/*  Q.2 Find all data where category is 'Clothing' and
	'quantity' sold equal or more than 4 in month nov 2022;  */
select * from Retail_Sales
where category = 'Clothing' and 
	  quantity >=4 and 
	  sale_date between '2022-11-01' and '2022-11-30';

/* Q.3 To Find Total Sale, Total Orders on each Category */
select category,sum(total_sale) as Total_sales,
	count(*) as Total_Order
from Retail_Sales
group by category;

/* Q.4 To find Average age of customer who purchase item from 'Beauty' category: */
select Round(avg(age),2) as Avg_Age
from Retail_Sales
where category = 'Beauty';

--or Agv age from all category
select  category, avg(age) as Avg_Age
from Retail_Sales
group by category;

/* Q.5 To find total no. of transaction made by each gender in each category */
SELECT 
	category,
    gender,
    COUNT(transactions_id) AS total_transactions
FROM Retail_Sales
GROUP BY category, gender
order by category,gender;

/* Q.6 To find the Avg sale on each month and Best month in each year */
select 
	year,
	month,
	total_sale
from
(
select 
	extract(YEAR from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as total_sale,
	rank() over(partition by extract(YEAR from sale_date) order by avg(total_sale) desc) as rank
from Retail_Sales
group by 1,2
) as t2
where rank =1;

/* Q.7 To Find Top 5 Customer based on total_sale */
select customer_id, sum(total_sale) as Total_sale
from Retail_Sales
group by 1
order by Total_sale desc limit 5;

/* Q.7 To Find the number of unique customer who purchase item from each category */
select category, count(distinct(customer_id)) as Total_Customer
from retail_Sales
group by 1;

/* Q.8  how many order are placed in each shift morning <=12, Afternoon>12 and <=17, Evening>17 */
select *, 
	case
		when extract(hour from sale_time)<=12 then 'Morning Shift'
		when extract(hour from sale_time)>12 and extract(hour from sale_time)<=17 then 'Afternoon Shift'
		when extract(hour from sale_time)>17 then 'Evening Shift'
	end as Shift
from Retail_Sales
group by 1;



