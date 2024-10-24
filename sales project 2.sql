CREATE DATABASE Sales_Analysis;
USE Sales_Analysis;

DESCRIBE sales; -- CHECK THE DATATYPES OF ALL TABLES

-- DATE AND TIME IS NOT IN THE RIGHT DATATYPE

-- ALTER COLUMN DATE

SELECT 
    *
FROM
    sales;
    
ALTER TABLE sales 
ADD column new_date date;

UPDATE sales 
SET 
    new_date = STR_TO_DATE(date, '%d-%m-%Y');

alter table sales
drop column date;

alter table sales
rename column new_date to Date;

-- ALTER COLUMN TIME

alter table sales
modify column time TIME;

-- CHECK THE DATA TYPES

DESCRIBE sales;

-- CHECK FOR MISSING VALUES

SELECT 
    COUNT(*) AS TOTAL_ROWS,
    COUNT(*) - COUNT(Invoice_ID) AS MISSING_INVOICE,
    COUNT(*) - COUNT(BRANCH) AS MISSING_BRANCH,
    COUNT(*) - COUNT(City) AS MISSING_CITY,
    COUNT(*) - COUNT(Customer_type) AS MISSING_CUST_TYPE,
    COUNT(*) - COUNT(GENDER) AS MISSING_GENDER,
    COUNT(*) - COUNT(Product_line) AS MISSING_PRODUCT,
    COUNT(*) - COUNT(Unit_price) AS MISSING_UNIT_PRICE,
    COUNT(*) - COUNT(Quantity) AS MISSING_QUANTITY,
    COUNT(*) - COUNT(VAT) AS MISSING_VAT,
    COUNT(*) - COUNT(Total) AS MISSING_TOTAL,
    COUNT(*) - COUNT(time) AS MISSING_TIME,
    COUNT(*) - COUNT(Payment) AS MISSING_PAYMENT,
    COUNT(*) - COUNT(cogs) AS MISSING_COGS,
    COUNT(*) - COUNT(gross_margin_pct) AS MISSING_MARGIN,
    COUNT(*) - COUNT(gross_income) AS MISSING_INCOME,
    COUNT(*) - COUNT(Rating) AS MISSING_RATING,
    COUNT(*) - COUNT(Date) AS MISSING_DATE
FROM
    Sales;					-- NO MISSING VALUES IN THE TABLE

-- Feature Engineering --

-- 1. Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening.

SELECT 
    MAX(TIME), MIN(TIME)
FROM
    SALES;					-- IDENTIFY THE OPENING AND CLOSING TIME

SELECT 
    time,
    CASE
        WHEN TIME BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN TIME BETWEEN '12:00:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS Time_of_Day
FROM
    Sales;

ALTER TABLE SALES 
ADD COLUMN Time_of_Day VARCHAR(20);

UPDATE SALES 
SET 
    Time_of_Day = (CASE
        WHEN TIME BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN TIME BETWEEN '12:00:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);
    
SELECT * FROM SALES;

-- 2. Add a new column named day_name that contains the extracted days of the week.

SELECT 
    DATE, DAYNAME(DATE) AS Day_Name
FROM
    SALES;


ALTER TABLE SALES
ADD COLUMN Day_Name VARCHAR(10);

UPDATE SALES 
SET 
    Day_Name = DAYNAME(DATE);

-- 3. Add a new column named month_name that contains the extracted months of the year

SELECT 
    DATE, MONTHNAME(DATE)
FROM
    SALES;
    
ALTER TABLE SALES
ADD COLUMN Month_Name VARCHAR(10);

UPDATE SALES 
SET 
    Month_Name = MONTHNAME(DATE);
    
SELECT * FROM SALES;

-- BUSINESS QUESTIONS

-- GENERIC QUESTIONS

-- 1. How many distinct cities are present in the dataset?

SELECT DISTINCT CITY 
FROM SALES;

-- 2.In which city is each branch situated?

SELECT DISTINCT BRANCH,CITY
FROM SALES;

-- PRODUCT ANALYSIS

-- 1. How many distinct product lines are there in the dataset?

SELECT DISTINCT product_line
FROM sales;

-- 2. What is the most common payment method?

SELECT 
    payment, COUNT(payment) AS Count
FROM
    sales
GROUP BY payment
ORDER BY count DESC;

-- 3. What is the most selling product line?

SELECT 
    product_line, COUNT(product_line) AS count
FROM
    sales
GROUP BY product_line
ORDER BY count DESC
LIMIT 1;

-- 4. What is the total revenue by month?

SELECT 
    month_name, ROUND(SUM(total), 2) AS Total_Revenue
FROM
    sales
GROUP BY month_name
ORDER BY total_revenue desc;

-- 5. Which month recorded the highest Cost of Goods Sold (COGS)?

SELECT 
    month_name, ROUND(SUM(cogs), 2) AS Total_Goods_sold
FROM
    sales
GROUP BY month_name
ORDER BY total_goods_sold DESC
LIMIT 1;

-- 6. Which product line generated the highest revenue?

SELECT 
    product_line, ROUND(SUM(total), 2) AS total_revenue
FROM
    sales
GROUP BY product_line
ORDER BY total_revenue DESC
LIMIT 1;

-- 7. Which city has the highest revenue?

SELECT 
    city, ROUND(SUM(total), 2) AS total_revenue
FROM
    sales
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 1;

-- 8. Which product line incurred the highest VAT?

SELECT 
    product_line, ROUND(SUM(vat), 2) AS highest_vat
FROM
    sales
GROUP BY product_line
ORDER BY highest_vat DESC
LIMIT 1;

-- 9. Retrieve each product line and add a column product_category, indicating 'Good' or 'Bad,' based on whether its sales are above the average.

SELECT 
    product_line,
    CASE
        WHEN total > (SELECT AVG(total) FROM sales) THEN 'Good'
        WHEN total < (SELECT AVG(total) FROM sales) THEN 'Bad'
    END AS product_category
FROM
    sales;
    
alter table sales
add column product_category varchar(10);

SET @avg_total = (SELECT AVG(total) FROM sales);

UPDATE sales 
SET 
    product_category = (CASE
        WHEN total >= @avg_total THEN 'Good'
        ELSE 'Bad'
    END);

-- 10. What is the most common product line by gender?

SELECT 
        gender, 
        product_line, 
        COUNT(product_line) AS total_number,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY COUNT(product_line) DESC) AS rn
    FROM sales
    GROUP BY gender, product_line;

SELECT gender, product_line, total_number
FROM (
    SELECT 
        gender, 
        product_line, 
        COUNT(product_line) AS total_number,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY COUNT(product_line) DESC) AS rn
    FROM sales
    GROUP BY gender, product_line
) AS ranked_products
WHERE rn = 1;

-- 11. What is the average rating of each product line?

SELECT 
    product_line, ROUND(AVG(rating), 1) AS avg_rating
FROM
    sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- Sales Analysis

-- 1.Number of sales made in each time of the day per weekday

SELECT 
    day_name, time_of_day, COUNT(invoice_id) AS no_of_sales
FROM
    sales
GROUP BY day_name , time_of_day
ORDER BY day_name , time_of_day;

-- 2. Identify the customer type that generates the highest revenue.

SELECT 
    customer_type, ROUND(SUM(total), 2) AS total_revenue
FROM
    sales
GROUP BY customer_type
ORDER BY total_revenue DESC
LIMIT 1;

-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?

select city,round(sum(vat),2) as total_vat
from sales 
group by city
order by total_vat desc;

-- 4. Which customer type pays the most in VAT?   

select customer_type,round(sum(vat),2) as total_vat
from sales 
group by customer_type
order by total_vat desc;     

-- 5. Retrieve all transactions where the rating is higher than 8.5.

select * from sales
where rating > 8.5;                       

-- 6. Retrieve all transactions where the rating is Lower than 5.0

select * from sales
where rating < 5.0;

-- 7. Calculate the total sales, average quantity sold, and total VAT collected for each city.

SELECT 
    city,
    ROUND(SUM(total), 2) AS total_sales,
    ROUND(AVG(quantity), 2) AS avg_qty_pr_transaction,
    ROUND(SUM(vat), 2) AS total_vat
FROM
    sales
GROUP BY city;

-- 8. Determine the total quantity of products sold on each day of the week.

SELECT 
    day_name, SUM(quantity) AS total_quantity
FROM
    sales
GROUP BY day_name
ORDER BY total_quantity DESC;

-- 9. Find all sales transactions where the quantity sold is greater than the average quantity sold.

SELECT 
    invoice_id,date, quantity
FROM
    sales
WHERE
    quantity > (SELECT 
					AVG(quantity)
				FROM
					sales);

-- 10. List all transactions that occurred on weekends.

select * from sales
where day_name = 'sunday' or day_name='saturday';

-- 11. Find the product lines that have total sales greater than the average total sales across all product lines

SELECT 
    product_line, ROUND(SUM(total),2) AS total_sales
FROM
    sales
GROUP BY product_line
HAVING SUM(total) > (SELECT 
        AVG(total_sales)
    FROM
        (SELECT 
            SUM(total) AS total_sales
        FROM
            sales
        GROUP BY product_line) AS avg_sales);
        
-- 12. Retrieve the branch where the total sales are higher than the average total sales across all branches.

SELECT 
    branch, ROUND(SUM(total), 2) AS total_sales
FROM
    sales
GROUP BY branch
HAVING SUM(total) > (SELECT 
        AVG(total_sales)
    FROM
        (SELECT 
            SUM(TOTAL) AS total_sales
        FROM
            sales
        GROUP BY branch) AS avg_sales);
        
-- 13. For each branch, rank the product lines based on total sales.

select branch,product_line,sum(total),
row_number() over (partition by branch order by sum(total) desc) as branch_rank 
from sales 
group by branch,product_line
order by branch,branch_rank;

-- 14. top 2 selling product in each branch?

with rankedproduct as
(select branch,product_line,sum(total) as total_sales,
row_number() over (partition by branch order by sum(total) desc) as branch_rank 
from sales 
group by branch,product_line
order by branch,branch_rank)
select branch,product_line,round(total_sales,2) as total_sales,branch_rank
from rankedproduct
where branch_rank = 1 or branch_rank = 2
order by branch;

-- 15. Calculate the running total of sales for each branch over time.

SELECT branch, date,time_of_day, total,
       SUM(total) OVER (PARTITION BY branch ORDER BY date, invoice_id) AS running_total
FROM sales
ORDER BY branch, date, invoice_id;

-- 16. Find the total sales for each hour of the day.

SELECT 
    HOUR(time) AS hours, ROUND(SUM(total), 2) AS total_sales
FROM
    sales
GROUP BY hours
ORDER BY hours;

-- 17. Classify product lines as "High Sales" or "Low Sales" based on whether their total sales are above or below the average sales.

select product_line,sum(total) as total_sales,
	case
		when sum(total) > (select avg(total) from sales) then 'high sales'
		else 'Low sales'
	end as sales_Status
from sales 
group by product_line;

-- OR

WITH ProductSales AS (
    SELECT product_line, SUM(total) AS total_sales
    FROM sales
    GROUP BY product_line
),
AverageSales AS (
    SELECT AVG(total_sales) AS avg_sales
    FROM ProductSales
)
SELECT ps.product_line, ps.total_sales,
       CASE 
           WHEN ps.total_sales >= (SELECT avg_sales FROM AverageSales) THEN 'High Sales'
           ELSE 'Low Sales'
       END AS sales_classification
FROM ProductSales ps;

-- 18. Find the gender that has the highest average quantity sold for each product line.

with gender_avg as
(
select product_line,gender,round(avg(quantity),1) as avg_quantity,
row_number() over (partition by product_line order by avg(quantity) desc) as ranks
from sales
group by product_line,gender
order by product_line,gender
)
select * from gender_avg
where ranks = 1;



-- 19. For each product line, find the day of the week that had the highest total sales.

with day_rank as
(
select product_line,dayname(date) as day_name,round(sum(total),2) as total_sales,
row_number() over (partition by product_line order by sum(total) desc) as ranks
from sales
group by product_line,dayname(date)
)
select * from day_rank
where ranks = 1;

