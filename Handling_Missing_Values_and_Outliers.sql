USE ecomm;
CREATE TABLE customer_churn_backup AS SELECT * FROM customer_churn; -- back_up table
Show tables; -- To show the tables present in the database
DESC customer_churn; -- To see all the columns and its datatypes

-- To check the row count in the table
SELECT COUNT(*) AS Total_Rows FROM customer_churn; -- 5630 rows in the table

/* 
	Impute mean for the following columns, and round off to the nearest integer if
	required: 
		WarehouseToHome, 
        HourSpendOnApp, 
        OrderAmountHikeFromlastYear,
		DaySinceLastOrder.
*/
 
-- To check the null value in the each columns

SELECT COUNT(*) AS Missing_WarehouseToHome 
FROM customer_churn 
WHERE WarehouseToHome IS NULL; -- 251 Missing values on the warehouse

SELECT COUNT(*) AS Missing_HourSpendOnApp 
FROM customer_churn 
WHERE HourSpendOnApp IS NULL;-- 255 missing values on HpurSpendOnApp

SELECT COUNT(*) AS Missing_OrderAmountHike 
FROM customer_churn 
WHERE OrderAmountHikeFromlastYear IS NULL; -- 265 missing values on OrderAmountHike

SELECT COUNT(*) AS Missing_DaySinceLastOrder 
FROM customer_churn 
WHERE DaySinceLastOrder IS NULL; -- 307 missing values on DaySinceLastOrder

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'customer_churn';


SELECT 
    (SUM(CASE WHEN WarehouseToHome IS NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN HourSpendOnApp IS NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN OrderAmountHikeFromlastYear IS NULL THEN 1 ELSE 0 END) +
     SUM(CASE WHEN DaySinceLastOrder IS NULL THEN 1 ELSE 0 END)) 
    AS Total_Null_Values
FROM customer_churn;  -- Total number of values missing on 4 columns 1078

-- Update the missing values 
UPDATE customer_churn
JOIN (
    SELECT 
        ROUND(AVG(WarehouseToHome)) AS avg_WarehouseToHome,
        ROUND(AVG(HourSpendOnApp)) AS avg_HourSpendOnApp,
        ROUND(AVG(OrderAmountHikeFromlastYear)) AS avg_OrderAmountHike,
        ROUND(AVG(DaySinceLastOrder)) AS avg_DaySinceLastOrder
    FROM customer_churn
) AS avg_values
SET 
customer_churn.WarehouseToHome = IFNULL(customer_churn.WarehouseToHome, avg_values.avg_WarehouseToHome),
customer_churn.HourSpendOnApp = IFNULL(customer_churn.HourSpendOnApp, avg_values.avg_HourSpendOnApp),
customer_churn.OrderAmountHikeFromlastYear = IFNULL(customer_churn.OrderAmountHikeFromlastYear, avg_values.avg_OrderAmountHike),
customer_churn.DaySinceLastOrder = IFNULL(customer_churn.DaySinceLastOrder, avg_values.avg_DaySinceLastOrder);

-- To verify
SELECT COUNT(*) AS Remaining_Null_Values
FROM customer_churn
WHERE WarehouseToHome IS NULL 
OR HourSpendOnApp IS NULL 
OR OrderAmountHikeFromlastYear IS NULL 
OR DaySinceLastOrder IS NULL; -- Remaining_Null_Values - 0

/* 
	Impute mode for the following columns: Tenure, CouponUsed, OrderCount.
*/

-- To find the most frequent value on each column 
-- Tenure
SELECT Tenure FROM customer_churn 
GROUP BY Tenure 
ORDER BY COUNT(*) DESC 
LIMIT 1; -- the most common (mode) value is 1
 
-- OrderCount
SELECT OrderCount FROM customer_churn 
GROUP BY OrderCount 
ORDER BY COUNT(*) DESC 
LIMIT 1; -- the most common (mode) value is 2

-- CouponUsed
SELECT CouponUsed FROM customer_churn 
GROUP BY CouponUsed 
ORDER BY COUNT(*) DESC 
LIMIT 1; -- the most common (mode) value is 1

-- An UPDATE query to replace NULL values with the mode
UPDATE customer_churn e1
JOIN (SELECT 
        (SELECT Tenure FROM customer_churn GROUP BY Tenure ORDER BY COUNT(*) DESC LIMIT 1) AS mode_Tenure,
        (SELECT CouponUsed FROM customer_churn GROUP BY CouponUsed ORDER BY COUNT(*) DESC LIMIT 1) AS mode_CouponUsed,
        (SELECT OrderCount FROM customer_churn GROUP BY OrderCount ORDER BY COUNT(*) DESC LIMIT 1) AS mode_OrderCount) 
AS mode_values SET 
e1.Tenure = IFNULL(e1.Tenure, mode_values.mode_Tenure),
e1.CouponUsed = IFNULL(e1.CouponUsed, mode_values.mode_CouponUsed),
e1.OrderCount = IFNULL(e1.OrderCount, mode_values.mode_OrderCount);

-- To verify
SELECT 
    SUM(CASE WHEN Tenure IS NULL THEN 1 ELSE 0 END) AS Null_Tenure,
    SUM(CASE WHEN CouponUsed IS NULL THEN 1 ELSE 0 END) AS Null_CouponUsed,
    SUM(CASE WHEN OrderCount IS NULL THEN 1 ELSE 0 END) AS Null_OrderCount
FROM customer_churn; 
/* 
	Null_Tenure is 0 
    Null_CouponUsed is 0
    Null_OrderCount is 0
*/

/*
	 Handle outliers in the 'WarehouseToHome' column by deleting rows where the values are greater than 100.
 */
 -- To Chek how many Outliers are present 
SELECT COUNT(*) AS Outliers
FROM customer_churn
WHERE WarehouseToHome > 100; -- 2 Outliers are present

SELECT * FROM customer_churn
WHERE WarehouseToHome > 100
LIMIT 10; -- Previewing the data before deleting

-- Deleting the Outliers
DELETE FROM customer_churn
WHERE WarehouseToHome > 100; -- Deleted

-- Verifying the deletion
SELECT COUNT(*) AS Remaining_Outliers FROM customer_churn
WHERE WarehouseToHome > 100; -- Remaining_Outliers is 0










