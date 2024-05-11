create database Amazon_Database;
use Amazon_Database;

create table Amazon_Sales (
Invoice_Id varchar(30) not null,
Branch varchar(5) not null,
City varchar(30) not null,
Customer_type varchar(30) not null,
Gender varchar(10) not null,
Product_Line varchar(100) not null,
Unit_Price decimal(10,2) not null,
Quantity int not null,
VAT float not null,
Total decimal(10,2) not null,
Date date not null,
Time time not null,
Payment varchar(50) not null,
COGS decimal(10,2) not null,
Gross_Margin_Percentage float not null,
Gross_Income decimal(10,2) not null,
Rating float not null
);

select * from Amazon_Database.Amazon_Sales;

alter table Amazon_Sales
add column Time_Of_Day varchar(50);

update Amazon_Sales
set Time_Of_Day = case
	when hour(Amazon_Sales.Time) >= 5 and hour(Amazon_Sales.Time) <= 12 then 'Morning'
    when hour(Amazon_Sales.Time) >= 12 and hour(Amazon_Sales.Time) <= 17 then 'Afternoon'
    when hour(Amazon_Sales.Time) >= 17 and hour(Amazon_Sales.Time) <= 21 then 'Evening'
    else 'Night'
end;

alter table Amazon_Sales
add column Day_Name varchar(50);

update Amazon_Sales
set Day_Name = date_format(Amazon_Sales.Date, '%a');

alter table Amazon_Sales
add column Month_Name varchar(50);

update Amazon_Sales
set Month_Name = date_format(Amazon_Sales.Date, '%b');

-- 1. What is the count of distinct cities in the dataset?
select count(distinct city) distinct_cities from Amazon_Sales;

-- 2. For each branch, what is the corresponding city?
select distinct branch,city from amazon_sales;

-- 3. What is the count of distinct product lines in the dataset?
select count(distinct product_line) distinct_product_lines from amazon_sales;

-- 4. Which payment method occurs most frequently?
select payment,count(*) payment_count from amazon_sales
group by payment
order by payment_count desc;

-- 5. Which product line has the highest sales?
select product_line,sum(quantity) total_sales from amazon_sales
group by product_line
order by total_sales desc;

-- 6. How much revenue is generated each month?
select month_name,sum(total) monthly_revenue from amazon_sales
group by month_name;

-- 7. In which month did the cost of goods sold reach it's peak?
select month_name,sum(cogs) total_cost_of_goods_sold from amazon_sales
group by month_name
order by total_cost_of_goods_sold desc;

-- 8. Which product line generated the highest revenue?
select product_line,sum(total) revenue_generated from amazon_sales
group by product_line
order by revenue_generated desc;

-- 9. In which city was the highest revenue recorded?
select city,sum(total) revenue_generated from amazon_sales
group by city
order by revenue_generated desc;

-- 10. Which product line incurred the highest value added tax?
select product_line,sum(vat) total_VAT from amazon_sales
group by product_line
order by total_VAT desc;

-- 11. For each product line, add a column indidcating "good" if it's sales are above average, otherwise "bad".
select product_line,avg(total) total_sales_average,if (avg(total)>(select avg(total) from amazon_sales),'good','bad') as nature_of_sale from amazon_sales
group by product_line;

-- 12. Identify the branch that exceeded average number of products sold?
select branch,sum(quantity) total_quantity_average from amazon_sales
group by branch
having sum(quantity)>(select avg(quantity) from amazon_sales);

-- 13. Which product line is most frequently associated with each gender?
select product_line,gender,count(gender) gender_count from amazon_sales
group by product_line,gender
order by gender_count desc;

-- 14. Calculate the average rating for each product line.
select product_line,avg(rating) average_rating from amazon_sales
group by product_line;

-- 15. Count the sales occurrences for each time of day on every weekday.
select day_name,time_of_day,count(*) sales_occurences from amazon_sales
where day_name not in ('saturday','sunday')
group by day_name,time_of_day
order by day_name,time_of_day desc;

-- 16. Identify the customer type contributing the highest revenue.
select customer_type,sum(total) revenue from amazon_sales
group by customer_type
order by revenue desc;

-- 17. Determine the city with the highest vat percentage.
select city,(sum(vat)/sum(total))*100 vat_percentage from amazon_sales
group by city
order by vat_percentage desc;

-- 18. Identify the customer type with the highest vat payments.
select customer_type,sum(vat) total_vat from amazon_sales
group by customer_type
order by total_vat desc;

-- 19. What is the count of distinct customer types in the dataset?
select count(distinct customer_type) distinct_customer_types from amazon_sales;

-- 20. What is the count of distinct payment methods in the dataset?
select count(distinct payment) distinct_payment_methods from amazon_sales;

-- 21. Which customer type occurs most frequently?
select customer_type,count(*) frequency from amazon_sales
group by customer_type
order by frequency desc;

-- 22. Identify the customer type with the highest purcahse frequency.
select customer_type,count(*) purchase_frequency from amazon_sales
group by customer_type;

-- 23. Determine the predominant gender among customers.
select gender,count(*) gender_count from amazon_sales
group by gender
order by gender_count desc;

-- 24. Examine the distribution of genders within each branch.
select branch,gender,count(gender) gender_count from amazon_sales
group by branch,gender
order by branch,gender_count;

-- 25. Identify the time of day when customers provide the most ratings.
select time_of_day,count(rating) rating_count from amazon_sales
group by time_of_day
order by rating_count desc;

-- 26. Determine the time of day with the highest customer ratings for each branch.
select branch,time_of_day,count(rating) rating_count from amazon_sales
group by branch,time_of_day
order by rating_count desc;

-- 27. Identify the day of the week with the highest average ratings.
select day_name,avg(rating) average_rating from amazon_sales
group by day_name
order by average_rating desc;

-- 28. Determine the day of the week with the highest average ratings for each branch.
select branch,day_name,avg(rating) average_rating from amazon_sales
group by branch,day_name
order by branch,average_rating desc;

-- PRODUCT ANALYSIS
-- 1.Food and beverages generated the highest revenue and incurred the highest VAT. 
-- 2.Electronic accessories had recorded the highest sales.
-- 3.Food and beverages, Electronic accessories and fashion accessories have a "bad" sales status.
-- 4.Health and Beauty generated the lowest revenue, recorded the lowest sales and also incurred the lowest VAT.

-- SALES ANALYSIS
-- 1.January had generated the highest revenue, followed by March and Feb respectively.
-- 2.Naypyitaw had generated the highest revenue among the three cities (Naypyitaw,Yangon and Mandalay).
-- 3.Ewallet was the most frequently used payment method exceeding the frequencies of cash and credit cards.
-- 4.Branch A had the highest quantity of products sold, closely beating out Branch B and C.

-- CUSTOMER ANALYSIS
-- 1.Among the two customer types viz. Member and Normal, Member customer type contributed more in terms of revenue and had the highest purchasing frequency.
-- 2.Females have contributed more to the revenue than males.
-- 3.The most preferred product line for females was Fashion Accessories and that of males was Health and Beauty.