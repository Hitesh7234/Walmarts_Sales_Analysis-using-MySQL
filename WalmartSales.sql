CREATE DATABASE IF NOT EXISTS walmart_data;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
 --  Time of Day
 
 Select 
	time,
    (Case 
		When time between '00:00:00' and '12:00:00' then 'Morning'
        When time between '12:00:00' and '16:00:00' then 'Afternoon'
        Else 'Evening'
    END
    ) as Time_of_Date
from sales;

Alter Table sales add column time_of_day varchar(20);

Update sales
Set time_of_day = (
	Case 
		When time between '00:00:00' and '12:00:00' then 'Morning'
		When time between '12:00:00' and '16:00:00' then 'Afternoon'
		Else 'Evening'
    END
);

-- day name --

Select date,dayname(date) from sales;

Alter table sales add column day_name varchar(10);

Update sales set day_name = dayname(date);

-- Month Name --
Select date,monthname(date) from sales;

Alter table sales add column Month_Name varchar(10);
Update Sales Set Month_Name = monthname(date);



-- How Many Unique Cities Have Data?

Select 
	distinct(city)
from sales;

Select 
	Distinct(branch)
from sales;

Select 
	distinct City,Branch
from sales;

-- How many unique product line have?
Select 
	count(distinct(product_line))
from sales;

-- what is most common payment method?

Select 
	payment,
	Count(payment) as counted
from sales group by payment
order by counted desc limit 1;
 
 -- what is the most selling product line?
 
Select 
	product_line,
	Count(product_line) as Selled
from sales group by product_line
order by Selled desc limit 1;

-- what is total revenue by month?

Select
	Month_Name as Month,
	Sum(total) as Total_Revenue
from sales group by Month
order by Total_Revenue desc;


-- what month has largest cogs?

Select
	Month_Name as Month,
	Sum(cogs) as COGS
from sales group by Month
order by COGS desc;

-- what product line has largest revenue?

Select
	product_line as products,
	Sum(total) as Total_Revenue
from sales group by products
order by Total_Revenue desc;

-- what city has largest revenue?

Select
	city as city,
	Sum(total) as Total_Revenue
from sales group by city
order by Total_Revenue desc;

-- What Product line have largest VAT?

Select
	product_line as products,
	avg(tax_pct) as VAT
from sales group by products
order by VAT desc;

-- Which branch sold more products than average product sold?

Select 	
	branch,
    Sum(quantity) as qty
from sales
group by branch
having qty > (Select avg(quantity) from sales);

-- What is the most common product line by gender?

Select
	gender,
    product_line,
    count(gender) as cnt
from sales
group by gender,product_line
order by cnt desc;

-- What is Average Rating of each Product_line

Select
	product_line,
    round(avg(rating),1) as rating
from sales
group by product_line
order by rating desc;

-- Number of sales made in each time of the day per weekday

Select 
	time_of_day,
    count(*) as total_sale
from sales
group by time_of_day
order by total_sale desc;

-- Which of the customer types brings the most revenue

Select 
	customer_type,
    sum(total) as revenue
from sales
group by customer_type
order by revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)

Select
	city,
	avg(tax_pct) as vat
from sales
group by city
order by vat desc;

-- Which customer type pays the most in VAT

Select
	customer_type,
	avg(tax_pct) as vat
from sales
group by customer_type
order by vat desc;

-- How many unique customer types does the data have?

Select 
	distinct customer_type
from sales;

-- How many unique payment methods does the data have?

Select 
	distinct payment
from sales;

-- What is the most common customer type?

Select
	customer_type,
	count(customer_type) as ct
from sales
group by customer_type
order by ct desc;

-- What is the gender of most of the customers?

Select 
	gender,
    customer_type,
    count(gender)
from sales
group by gender,customer_type
order by count(gender) desc;

-- What is the gender distribution per branch?

Select 
	gender,
    branch,
    count(gender)
from sales
group by gender,branch
order by count(gender) desc;

-- Which time of the day do customers give most ratings?

Select 
	time_of_day,
    count(rating) as ratings
from sales
group by time_of_day
order by ratings desc;

-- Which time of the day do customers give most ratings per branch?

Select 
	time_of_day,
    branch,
    count(rating) as ratings
from sales
group by time_of_day,branch
order by ratings desc;

-- Which day fo the week has the best avg ratings?

Select 
	day_name,
    avg(rating) as ratings
from sales
group by day_name
order by ratings desc;

-- Which day of the week has the best average ratings per branch?

Select 
	day_name,
    branch,
    avg(rating) as ratings
from sales
group by day_name,branch
order by ratings desc;
