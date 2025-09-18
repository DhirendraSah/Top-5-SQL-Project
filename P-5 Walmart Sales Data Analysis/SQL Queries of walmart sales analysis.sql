/*Created Database walmartsalesdb

 create database walmartsalesdb;
 */

 --Now creating table
 drop table if exists sales
 CREATE TABLE sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct DECIMAL(6,4) NOT NULL,           
    total DECIMAL(12,4) NOT NULL,
    date TIMESTAMP NOT NULL,                
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct DECIMAL(11,9),        
    gross_income DECIMAL(12,4),
    rating DECIMAL(3,1)                     
);

select * from sales;
/*	Feature Engineering: 
	This will help use generate some new columns from existing ones. */

/*	Q.1 Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening. 
This will help answer the question on which part of the day most sales are made. */

SELECT *,
    CASE 
        WHEN time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sales;

ALTER TABLE sales 
ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = CASE 
    WHEN time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
    WHEN time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
    ELSE 'Evening'
END;

select * from sales;

/*	Add a new column named day_name that contains the extracted days of the week
	on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). 
	This will help answer the question on which week of the day each branch is busiest. */

ALTER TABLE sales 
ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = TO_CHAR(date, 'Day'); 

/*	Add a new column named month_name that contains the extracted months of the year 
	on which the given transaction took place (Jan, Feb, Mar). 
	Help determine which month of the year has the most sales and profit. */

alter table sales
add column month_name varchar(20);

update sales
set month_name= to_char(date,'mon');

select * from sales;
----------------------------------------
-----------Generic Question-------------
----------------------------------------
--How many unique cities does the data have?

select distinct city
from sales;

--In which city is each branch?

SELECT DISTINCT branch, city
FROM sales
ORDER BY branch;

----------------------------------------------
---------Product---------------
-----------------------------------------------
--How many unique product lines does the data have?
select distinct product_line
from sales;

--What is the most common payment method?
select payment, count(*) from sales
group by 1
order by 2 desc;
	
--What is the most selling product line?
select * from sales;

select product_line, count(*) from sales
group by 1
order by 2 desc;

--What is the total revenue by month?
select month_name,sum(total) from sales
group by 1;

--What month had the largest COGS?
select month_name,sum(cogs)
from sales
group by 1
order by 2 desc
limit 1;

--What product line had the largest revenue?
select product_line,sum(total) as total_revenue
from sales
group by 1;

--What is the city with the largest revenue?
select city,sum(total) as total_revenue
from sales
group by 1;

--What product line had the largest VAT?
select product_line, sum(tax_pct) as avg_Tax
from sales
group by 1
order by 2 desc;

--Fetch each product line and add a column to those product line 
--showing "Good", "Bad". Good if its greater than average sales
SELECT
  product_line,
  total_sales,
  AVG(total_sales) OVER () AS avg_total_sales,
  CASE
    WHEN total_sales > AVG(total_sales) OVER () THEN 'Good'
    ELSE 'Bad'
  END AS performance
FROM (
  SELECT product_line, SUM(total) AS total_sales
  FROM sales
  GROUP BY product_line
) t
ORDER BY total_sales DESC;


--Which branch sold more products than average product sold?
select * from sales;
select branch,sum(quantity) as total_sold 
from sales
group by 1
having sum(quantity) > (select avg(quantity) from sales)

--What is the most common product line by gender?
select gender,product_line, count(product_line)
from sales
group by 1,2
order by 3 limit 1

--What is the average rating of each product line?
select product_line, avg(rating)
from sales
group by 1;




