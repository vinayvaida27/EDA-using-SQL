-- Create database
CREATE DATABASE walmartSales;


-- Create table
CREATE TABLE sales(
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(10) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct NUMERIC(6,4) NOT NULL,
    total NUMERIC(12, 4) NOT NULL,
    date TIMESTAMP NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs NUMERIC(10,2) NOT NULL,
    gross_margin_pct NUMERIC(11,9),
    gross_income NUMERIC(12, 4),
    rating NUMERIC(2, 1)
);


-- Add the time_of_day column
ALTER TABLE sales 
ADD COLUMN time_of_day VARCHAR(20);


UPDATE sales
SET time_of_day = (
	CASE
	WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
    END
);


-- Add day_name column
ALTER TABLE sales 
ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = to_char(date,'Day')


-- Add month_name column
ALTER TABLE sales 
ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = to_char(date,'Month');

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT Count(DISTINCT product_line)
FROM sales;


-- Which is the most common payment method?
SELECT payment_method, count(payment_method) as cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;


-- Which is the most selling product line?
SELECT SUM(quantity) as qty, product_line
FROM sales
GROUP BY product_line
ORDER BY qty DESC;


-- What is the total revenue by month?
SELECT month_name AS month, SUM(total) AS total_revenue
FROM sales
GROUP BY month_name 
ORDER BY total_revenue;


-- Which month had the largest COGS?
SELECT month_name AS month, SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs desc;


-- Which product line had the largest revenue?
SELECT product_line, SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- City with the largest revenue?
SELECT city, SUM(total) AS total_revenue
FROM sales
GROUP BY city 
ORDER BY total_revenue;


-- Which product line had the largest VAT?
SELECT product_line, AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;


-- Fetch each product line and its average quantity. Add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales
SELECT product_line, AVG(quantity)
	CASE
	WHEN AVG(quantity) > (SELECT AVG(quantity) FROM sales) THEN 'Good'
    ELSE 'Bad'
    END AS remark
FROM sales
GROUP BY product_line;


-- Which branch sold more products than average product sold?
SELECT branch, SUM(quantity)
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


-- Which is the most common product line by gender?
SELECT product_line, gender, COUNT(gender) AS total_cnt
FROM sales
GROUP BY product_line, gender
ORDER BY total_cnt DESC;

-- What is the average rating of each product line?
SELECT product_line, ROUND(AVG(rating), 2) as avg_rating,
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment
FROM sales;


-- Which is the most common customer type?
SELECT customer_type, count(*) as cnt
FROM sales
GROUP BY customer_type
ORDER BY cnt DESC;

-- Which customer type buys the most?
SELECT customer_type, COUNT(*)
FROM sales
GROUP BY customer_type;


-- What is the gender of most of the customers?
SELECT gender, COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution for branch C?
SELECT gender, COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;

-- Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings for branch A?
SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which day of the week has the best avg ratings?
SELECT day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings for branch C?
SELECT day_name, AVG(rating) AS avg_rating
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY avg_rating DESC;

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day on Sunday?
SELECT time_of_day, COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

-- Which city has the largest tax/VAT percent?
SELECT city, ROUND(AVG(tax_pct),2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT customer_type, AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
