----------- Create Tables ----------------------------
CREATE TABLE `salesdata` (
  `InvoiceID` text,
  `Branch` text,
  `City` text,
  `CustomerType` varchar(30) DEFAULT NULL,
  `Gender` text,
  `ProductLine` text,
  `UnitPrice` double DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `Tax` double DEFAULT NULL,
  `Total` double DEFAULT NULL,
  `Date` text,
  `Time` text,
  `Payment` text,
  `cogs` double DEFAULT NULL,
  `GrossMarginPercentage` double DEFAULT NULL,
  `GrossIncome` double DEFAULT NULL,
  `Rating` double DEFAULT NULL,
  `Time_of_Day` varchar(20) DEFAULT NULL,
  `DayName` varchar(10) DEFAULT NULL,
  `Month_Name` varchar(10) DEFAULT NULL,
  `Product_Category` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT * FROM walmart.salesdata;
-------------------------------------- CREATING AND DISPLAYING DATABASES AND TABLES ----------

-- MySQL DROP DATABASE
DROP database walmart;

-- MySQL CREATE DATABASE
create database walmart;

-- MySQL DROP TABLE 
DROP table walmart.salesdata;

-- MySQL CREATE TABLE 
create table walmart.salesdata;

-------------------------------------------- QUERYING DATA --------------------------------------
-- MySQL SELECT
/*
Script to select entire data from a database
*/
SELECT  *
From walmart.salesdata;

-- MySQL WHERE CLAUSE
/****** Script for filtering records  ******/
SELECT Branch, City, Quantity, Total, Payment
from walmart.salesdata;
Where Gender = 'Female';

-- MySQL AND, OR and NOT Operators
SELECT  *
From walmart.salesdata
Where Gender = 'Female' AND Payment = 'Cash';

SELECT Branch, City, Quantity, Total, Payment
from walmart.salesdata
Where Gender = 'Female' AND Payment = 'Cash';


-- MySQL OR
SELECT  *
From walmart.salesdata
Where Gender = 'Female' OR Payment = 'Cash';


-- MySQL WHERE NOT
SELECT  *
From walmart.salesdata
Where NOT Gender = 'Female';

-- MySQL Combining AND, OR and NOT, LIMIT (specify the number of records to return)
SELECT  *
From walmart.salesdata
Where Gender = 'Female' AND (City = 'Yangon' OR Branch = 'A')
ORDER BY ProductLine desc
LIMIT 10;

-- NULL Value and IS NOT NULL Values
SELECT  *
From walmart.salesdata
Where Gender IS NOT NULL;

SELECT  Branch, City, Quantity, Total, Payment
From walmart.salesdata
Where Branch IS NULL;

-- UPDATE SET AND DELETE
-- Modify the existing records in a table                
UPDATE walmart.salesdata
SET City = 'Kumasi', Gender = 'Male'    -- Here I am selecting tn attribute Quantity
WHERE Quantity = 7 AND Branch = 'A'     -- and Branch to specify the row
									    -- and set City and Gender

-- SELECT UPDATED TABLE 
SELECT *
From walmart.salesdata;

-- DELETE 
DELETE FROM walmart.salesdata
WHERE InvoiceID = 750-67-8428

----------------------- FEATURE ENGINEERING -------------------------------------
-- (MySQL CASE Statement)

-- 1. Time_of_day
SELECT 	Time,
CASE 
	WHEN `Time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN `Time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
	ELSE "Evening" 
END AS Time_of_Day
FROM walmart.salesdata;

-- Modify Table by adding column 'Time_of_Day'
ALTER TABLE walmart.salesdata 
ADD COLUMN Time_of_Day VARCHAR(20);

-- Update Table with the added Column 'Time_of_Day'
UPDATE walmart.salesdata
SET Time_of_Day = (
	CASE 
		WHEN `Time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN `Time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening" 
	END
);

-- -- 2. Day_Name
SELECT Date,
DAYNAME(Date) AS Day_Name
FROM walmart.salesdata;

-- Modify Table by adding column 'Day_Name'
ALTER TABLE walmart.salesdata 
ADD COLUMN Day_Name VARCHAR(10);

-- Update Table with the added Column 'Day_Name
UPDATE walmart.salesdata
SET Day_Name = DAYNAME(Date);


-- 3. Month_name
SELECT Date,
MONTHNAME(Date) AS Month_Name
FROM walmart.salesdata;

-- Modify Table by adding column 'Month_Name
ALTER TABLE walmart.salesdata
ADD COLUMN Month_Name VARCHAR(10);

-- Update Table with the added Column 'MonthName
UPDATE walmart.salesdata
SET Month_Name = MONTHNAME(Date);

-- Update Tables and Columns
SELECT  *
From walmart.salesdata;

--- Alter column names in a table
ALTER TABLE walmart.salesdata 
RENAME COLUMN day_name TO DayName;

ALTER TABLE walmart.salesdata 
CHANGE COLUMN `Customer type` `CustomerType` VARCHAR(30);


---------------------- EXPLORATORY DATA ANALYSIS (EDA) -----------------------------
-- Generic Questions:
-- 1.How many distinct cities are present in the dataset?
SELECT DISTINCT City 
FROM walmart.salesdata;

-- 2.In which city is each branch situated?
SELECT DISTINCT Branch, City, Gender, CustomerType
FROM walmart.salesdata;


-------------------------------------------------------------------------------
------------------------------ Product Analysis -------------------------------
-------------------------------------------------------------------------------
-- 1.How many distinct product lines are there in the dataset?
SELECT COUNT(DISTINCT ProductLine) 
FROM walmart.salesdata;

-- 2.What is the most common payment method?
SELECT Payment, COUNT(Payment) AS Common_Payment_Method 
FROM walmart.salesdata 
GROUP BY Payment
ORDER BY Common_Payment_Method 
DESC LIMIT 1;

-- 3.What is the most selling product line?
SELECT ProductLine, count(ProductLine) AS Most_Selling_Product
FROM walmart.salesdata
GROUP BY ProductLine
ORDER BY Most_Selling_Product 
DESC LIMIT 1;

-- 4.What is the total revenue by month?
SELECT Month_Name, SUM(Total) AS Total_Revenue
FROM walmart.salesdata
GROUP BY Month_Name 
ORDER BY Total_Revenue 
DESC;

-- 5.Which month recorded the highest Cost of Goods Sold (COGS)?
SELECT Month_Name, SUM(cogs) AS Total_Cogs
FROM walmart.salesdata
GROUP BY Month_Name 
ORDER BY Total_Cogs 
DESC;

-- 6.Which product line generated the highest revenue?
SELECT ProductLine, SUM(Total) AS Total_Revenue
FROM walmart.salesdata
GROUP BY ProductLine
ORDER BY Total_Revenue
DESC LIMIT 1;

-- 7.Which city has the highest revenue?
SELECT city, SUM(Total) AS Total_Revenue
FROM walmart.salesdata 
GROUP BY City 
ORDER BY Total_Revenue 
DESC LIMIT 1;

-- 8.Which product line incurred the highest VAT?
SELECT ProductLine, SUM(Tax) as VAT 
FROM walmart.salesdata 
GROUP BY ProductLine
ORDER BY VAT 
DESC LIMIT 1;

-- 8A.Which product line incurred the lowest VAT?
SELECT ProductLine, SUM(Tax) as VAT 
FROM walmart.salesdata 
GROUP BY ProductLine
ORDER BY VAT 
ASC LIMIT 1;

-- 8B. What is the most expensive product
SELECT ProductLine, MAX(UnitPrice) AS Most_Expensive
FROM walmart.salesdata
GROUP BY ProductLine;
ORDER BY UnitPrice
DESC LIMIT 1;





-- 9.Retrieve each product line and add a column product_category,
-- indicating 'Good' or 'Bad,'based on whether its sales are above the average.

ALTER TABLE walmart.salesdata
ADD COLUMN Product_Category VARCHAR(20);

UPDATE walmart.salesdata
SET Product_Category= 
(CASE 
	    WHEN Total >= (SELECT AVG(Total) FROM walmart.salesdata) THEN "Good"
    ELSE "Bad"
END)
FROM walmart.salesdata;

--------------- correction----------------
SELECT 
	AVG(Quantity) AS Avg_qnty
FROM walmart.salesdata;

SELECT
	ProductLine,
	CASE
		WHEN AVG(Quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM walmart.salesdata
GROUP BY ProductLine;




-- 10.Which branch sold more products than average product sold?
SELECT Branch, SUM(Quantity) AS Quantity
FROM walmart.salesdata 
GROUP BY Branch HAVING SUM(Quantity) > AVG(Quantity) 
ORDER BY Quantity 
DESC LIMIT 1;

-- 11.What is the most common product line by gender?
SELECT Gender, ProductLine, COUNT(Gender) Total_Count
FROM walmart.salesdata 
GROUP BY Gender, ProductLine 
ORDER BY Total_Count 
DESC;

-- 12.What is the average rating of each product line?
SELECT ProductLine, ROUND(AVG(Rating),2) Average_Rating
FROM walmart.salesdata 
GROUP BY ProductLine 
ORDER BY Average_Rating 
DESC;


-------------------------------------------------------------------------------
------------------------------ Sales Analysis ---------------------------------
-------------------------------------------------------------------------------
-- 1.Number of sales made in each time of the day per weekday
SELECT DayName, Time_of_Day, COUNT(InvoiceID) AS Total_Sales
FROM walmart.salesdata 
GROUP BY DayName, Time_of_Day 
HAVING DayName NOT IN ('Sunday','Saturday');

SELECT DayName, Time_of_Day, COUNT(*) AS Total_Sales
FROM walmart.salesdata
WHERE DayName NOT IN ('Saturday','Sunday') 
GROUP BY DayName, Time_of_Day;

-- 2.Identify the customer type that generates the highest revenue.
SELECT CustomerType, SUM(Total) AS Total_Sales
FROM walmart.salesdata 
GROUP BY CustomerType 
ORDER BY Total_Sales 
DESC LIMIT 1;

-- 3.Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT City, SUM(Tax) AS Total_VAT
FROM walmart.salesdata 
GROUP BY City 
ORDER BY Total_VAT 
DESC LIMIT 1;

-- 4.Which customer type pays the most in VAT?
SELECT CustomerType, SUM(Tax) AS Total_VAT
FROM walmart.salesdata 
GROUP BY CustomerType 
ORDER BY Total_VAT 
DESC LIMIT 1;

-----------------------------------------------------------------------------
---------------------------- Customer Anlaysis-------------------------------
-----------------------------------------------------------------------------

-- 1.How many unique customer types does the data have?
SELECT COUNT(DISTINCT CustomerType) 
FROM walmart.salesdata;

-- 2.How many unique payment methods does the data have?
SELECT COUNT(DISTINCT Payment) 
FROM walmart.salesdata;

-- 3.Which is the most common customer type?
SELECT CustomerType, COUNT(CustomerType) AS Common_Customer
FROM walmart.salesdata 
GROUP BY CustomerType 
ORDER BY Common_Customer 
DESC LIMIT 1;

-- 4.Which customer type buys the most based on total sales?
SELECT CustomerType, SUM(Total) AS Total_Sales
FROM walmart.salesdata 
GROUP BY CustomerType 
ORDER BY Total_Sales 
LIMIT 1;


-- 4a.Which customer type buys the most?
SELECT CustomerType, COUNT(*) AS Most_Buyer
FROM walmart.salesdata 
GROUP BY CustomerType 
ORDER BY Most_Buyer 
DESC LIMIT 1;

-- 5.What is the gender of most of the customers?
SELECT Gender, COUNT(*) AS All_Genders 
FROM walmart.salesdata 
GROUP BY Gender 
ORDER BY All_Genders 
DESC LIMIT 1;

-- 6.What is the gender distribution per branch?
SELECT Branch, Gender, COUNT(Gender) AS Gender_Distribution
FROM walmart.salesdata 
GROUP BY Branch, Gender 
ORDER BY Branch;

-- 7.Which time of the day do customers give most ratings?
SELECT Time_of_Day, avg(Rating) AS Average_Rating
FROM walmart.salesdata 
GROUP BY Time_of_Day 
ORDER BY Average_Rating 
DESC LIMIT 1;

-- 8.Which time of the day do customers give most ratings per branch?
SELECT Branch, Time_of_Day, AVG(Rating) AS Average_Rating
FROM walmart.salesdata 
GROUP BY Branch, Time_of_Day 
ORDER BY Average_Rating 
DESC;


-- 9.Which day of the week has the best avg ratings?
SELECT DayName, AVG(Rating) AS Average_Rating
FROM walmart.salesdata 
GROUP BY DayName 
ORDER BY Average_Rating 
DESC LIMIT 1;

-- 10.Which day of the week has the best average ratings per branch?
SELECT  Branch, DayName, AVG(Rating) AS Average_Rating
FROM walmart.salesdata 
GROUP BY DayName, Branch 
ORDER BY Average_Rating 
DESC;


