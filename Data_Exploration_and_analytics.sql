USE Ecomm;

-- Data Exploration and Analysis
/* 
	Retrieve the count of churned and active customers from the database
*/
SELECT ChurnStatus, COUNT(*) AS Customer_Count FROM customer_churn
GROUP BY ChurnStatus;
/* 
    ChurnedStatus  Customer_Count
    -----------------------------
	Churned	       948
	Active	       4680
*/
/*
	➢ To Display the average tenure and total cashback amount of customers who churned.
*/
SELECT ROUND(AVG(Tenure), 2) AS Avg_Tenure, SUM(CashbackAmount) AS Total_Cashback
FROM customer_churn
WHERE ChurnStatus = 'Churned';
/*
	Avg_Tenure  Total_Cashback
	--------------------------
	3.18	    152030
*/

/*
	➢ Determine the percentage of churned customers who complained.
*/
SELECT ROUND(
		(COUNT(CASE WHEN ChurnStatus = 'Churned' AND ComplaintReceived = 'Yes' THEN 1 END) * 100.0) / 
        COUNT(CASE WHEN ChurnStatus = 'Churned' THEN 1 END), 2) 
AS Churned_Complaint_Percentage FROM customer_churn;
/*
	Churned_Complaint_Percentage
    ----------------------------
    53.59
*/

/*
	➢ To find the gender distribution of customers who complained
*/
SELECT Gender, COUNT(*) AS Complaint_Count FROM customer_churn
WHERE ComplaintReceived = 'Yes'
GROUP BY Gender;
/* 
	Gender  Complaint_Count
	-----------------------
	Female	690
	Male	914
*/

/*
	To identify the city tier with the highest number of churned customers whose
	preferred order category is Laptop & Accessory.
*/
SELECT CityTier, COUNT(*) AS Churned_Customers FROM customer_churn
WHERE ChurnStatus = 'Churned' AND PreferredOrderCat = 'Laptop & Accessory'
GROUP BY CityTier
ORDER BY Churned_Customers DESC
LIMIT 1;
/*
	CityTier  Churned_Customers
    ---------------------------
    3	      150
*/

/*
	Identify the most preferred payment mode among active customers.
*/
SELECT PreferredPaymentMode, COUNT(*) AS Usage_Count FROM customer_churn
WHERE ChurnStatus = 'Active'
GROUP BY PreferredPaymentMode
ORDER BY Usage_Count DESC
LIMIT 1;
/* 
PreferredPaymentMode   Usage_Count
----------------------------------
Debit Card	           1956
*/

/*
	Calculate the total order amount hike from last year for customers who are single
	and prefer mobile phones for ordering.
*/
SELECT SUM(OrderAmountHikeFromlastYear) AS Total_Order_Hike FROM customer_churn
WHERE MaritalStatus = 'Single' AND PreferredOrderCat = 'Mobile Phone';
/*
	Total_Order_Hike
    ----------------
    12177
*/

/*
	Find the average number of devices registered among customers who used UPI as
	their preferred payment mode.
*/
SELECT ROUND(AVG(NumberOfDeviceRegistered), 2) AS Avg_Devices_Registered
FROM customer_churn
WHERE PreferredPaymentMode = 'UPI';
/*
	Avg_Devices_Registered
    ----------------------
    3.72
*/

/*
	To determine the city tier with the highest number of customer
*/
SELECT CityTier, COUNT(*) AS Customer_Count FROM customer_churn
GROUP BY CityTier
ORDER BY Customer_Count DESC
LIMIT 1;
/*
	CityTier  Customer_Count
    1	      3666
*/

/*
	Identify the gender that utilized the highest number of coupons.
*/
SELECT Gender, SUM(CouponUsed) AS Total_Coupons_Used FROM customer_churn
GROUP BY Gender
ORDER BY Total_Coupons_Used DESC LIMIT 1;
/*
	Gender   Total_Coupons_Used
    ---------------------------
    Male	 5629
*/

/* 
	List the number of customers and the maximum hours spent on the app in each	preferred order category.
*/
SELECT PreferredOrderCat, COUNT(*) AS Customer_Count, 
MAX(HoursSpentOnApp) AS Max_Hours_Spent FROM customer_churn
GROUP BY PreferredOrderCat;
/*
	+--------------------+----------------+-----------------+
	| PreferredOrderCat  | Customer_Count | Max_Hours_Spent |
	+--------------------+----------------+-----------------+
	| Laptop & Accessory |           2050 |               5 |
	| Mobile Phone       |           2078 |               5 |
	| Others             |            264 |               4 |
	| Fashion            |            826 |               5 |
	| Grocery            |            410 |               4 |
	+--------------------+----------------+-----------------+
	5 rows in set (0.01 sec)
*/

/*
	Calculate the total order count for customers who prefer using credit cards and
	have the maximum satisfaction score.
*/
SELECT SUM(OrderCount) AS Total_Order_Count FROM customer_churn
WHERE PreferredPaymentMode = 'Credit Card'
AND SatisfactionScore = (SELECT MAX(SatisfactionScore) FROM customer_churn);
/* 
	Total_Order_Count
    -----------------
    1122
*/

/*
	How many customers are there who spent only one hour on the app and days since their last order was more than 5?
*/
SELECT COUNT(*) AS Customer_Count FROM customer_churn
WHERE HoursSpentOnApp = 1 AND DaySinceLastOrder > 5;
/*
	+----------------+
	| Customer_Count |
	+----------------+
	|              8 |
	+----------------+
	1 row in set (0.01 sec)
*/

/*
	What is the average satisfaction score of customers who have complained?
*/
SELECT ROUND(AVG(SatisfactionScore), 2) AS Avg_Satisfaction_Score
FROM customer_churn
WHERE ComplaintReceived = 'Yes';
/*
	+------------------------+
	| Avg_Satisfaction_Score |
	+------------------------+
	|                   3.00 |
	+------------------------+
	1 row in set (0.01 sec)
*/

/* 
	List the preferred order category among customers who used more than 5 coupons.
*/
SELECT PreferredOrderCat, COUNT(*) AS Customer_Count
FROM customer_churn WHERE CouponUsed > 5
GROUP BY PreferredOrderCat
ORDER BY Customer_Count DESC;
/* 
	+--------------------+----------------+
	| PreferredOrderCat  | Customer_Count |
	+--------------------+----------------+
	| Laptop & Accessory |             99 |
	| Fashion            |             89 |
	| Mobile Phone       |             45 |
	| Grocery            |             42 |
	| Others             |             28 |
	+--------------------+----------------+
	5 rows in set (0.01 sec)
*/

/* 
	 List the top 3 preferred order categories with the highest average cashback amount.
*/
SELECT PreferredOrderCat, ROUND(AVG(CashbackAmount), 2) AS Avg_Cashback
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY Avg_Cashback DESC LIMIT 3;
/* 
	+-------------------+--------------+
	| PreferredOrderCat | Avg_Cashback |
	+-------------------+--------------+
	| Others            |       304.45 |
	| Grocery           |       266.24 |
	| Fashion           |       210.40 |
	+-------------------+--------------+
	3 rows in set (0.01 sec)
*/

/* 
	Find the preferred payment modes of customers whose average tenure is 10
	months and have placed more than 500 orders
*/
-- Checking the high_order_customers
SELECT COUNT(*) AS High_Order_Customers
FROM customer_churn
WHERE OrderCount > 500; -- 0 Customers

-- Checking the total number of OrderCount 
SELECT OrderCount, COUNT(*) AS Customer_Count
FROM customer_churn
GROUP BY OrderCount
ORDER BY OrderCount DESC
LIMIT 50;
/*
	+------------+----------------+
	| OrderCount | Customer_Count |
	+------------+----------------+
	|         16 |             23 |
	|         15 |             33 |
	|         14 |             36 |
	|         13 |             30 |
	|         12 |             54 |
	|         11 |             51 |
	|         10 |             36 |
	|          9 |             62 |
	|          8 |            172 |
	|          7 |            206 |
	|          6 |            137 |
	|          5 |            181 |
	|          4 |            204 |
	|          3 |            371 |
	|          2 |           2282 |
	|          1 |           1750 |
	+------------+----------------+
	16 rows in set (0.00 sec)
    
As the highest value is 16, lower the threshold to > 10 or > 5
*/

-- Checking the customers who has ordered above 10
SELECT COUNT(*) AS Customers_With_Orders
FROM customer_churn
WHERE OrderCount > 10; -- Customers_with_Orders is 227

-- Checking the customers who are near to 10 month
SELECT COUNT(*) AS Customers_Near_10_Months
FROM customer_churn
WHERE Tenure BETWEEN 9 AND 11; -- 654 Customers_near_10_month tenure
 
-- Final Query to check 
SELECT PreferredPaymentMode, COUNT(*) AS Customer_Count, ROUND(AVG(Tenure), 2) AS Avg_Tenure
FROM customer_churn
WHERE OrderCount > 10 
AND Tenure BETWEEN 9 AND 11 
GROUP BY PreferredPaymentMode
ORDER BY Customer_Count DESC;

/* 
	Categorize customers based on their distance from the warehouse to home such
	as 'Very Close Distance' for distances <=5km, 'Close Distance' for <=10km,
	'Moderate Distance' for <=15km, and 'Far Distance' for >15km. Then, display the
	churn status breakdown for each distance category
*/
-- Categorizing the Customers based on distance
SELECT 
    MIN(WarehouseToHome) AS Min_Distance,
    MAX(WarehouseToHome) AS Max_Distance,
    COUNT(*) AS Total_Customers
FROM customer_churn; -- If the MAX(WarehouseToHome) < 15
/*
	+--------------+--------------+-----------------+
	| Min_Distance | Max_Distance | Total_Customers |
	+--------------+--------------+-----------------+
	|            5 |           36 |            5628 |
	+--------------+--------------+-----------------+
*/

 -- Customers based on their distance from the warehouse and analyze their churn status.
 SELECT CASE 
        WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10 THEN 'Close Distance'
        WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
        ELSE 'Far Distance'
    END AS Distance_Category, ChurnStatus,
    COUNT(*) AS Customer_Count FROM customer_churn
GROUP BY Distance_Category, ChurnStatus
ORDER BY Distance_Category, ChurnStatus DESC;
/* 
	+---------------------+-------------+----------------+
	| Distance_Category   | ChurnStatus | Customer_Count |
	+---------------------+-------------+----------------+
	| Close Distance      | Churned     |            265 |
	| Close Distance      | Active      |           1696 |
	| Far Distance        | Churned     |            498 |
	| Far Distance        | Active      |           1871 |
	| Moderate Distance   | Churned     |            184 |
	| Moderate Distance   | Active      |           1106 |
	| Very Close Distance | Churned     |              1 |
	| Very Close Distance | Active      |              7 |
	+---------------------+-------------+----------------+
*/

/* 
	List the customer’s order details who are married, live in City Tier-1, and their
	order counts are more than the average number of orders placed by all
	customers.
    
		➢ a) Create a ‘customer_returns’ table in the ‘ecomm’ database and insert the
		following data:
		ReturnID CustomerID ReturnDate RefundAmount
		1001 50022 2023-01-01 2130
		1002 50316 2023-01-23 2000
		1003 51099 2023-02-14 2290
		1004 52321 2023-03-08 2510
		1005 52928 2023-03-20 3000
		1006 53749 2023-04-17 1740
		1007 54206 2023-04-21 3250
		1008 54838 2023-04-30 1990
        
		b) Display the return details along with the customer details of those who have
		churned and have made complaints
*/

/* 
	List the customer’s order details who are married, live in City Tier-1, and their
	order counts are more than the average number of orders placed by all
	customers.
*/
-- Avergae OrderCount
SELECT ROUND(AVG(OrderCount), 2) AS Avg_OrderCount
FROM customer_churn; -- Avg_OrderCount is 2.96

/*
	Listing the customer with the given conditions
		* Married
        * Avg_OrderCount> 2.96 (OrderCount is likely an integer, Hence, Rounded off has OrderCount >= 3)
        * CityTier = 1
*/
SELECT CustomerID, MaritalStatus, CityTier, OrderCount, PreferredOrderCat, PreferredPaymentMode
FROM customer_churn WHERE MaritalStatus = 'Married'
AND CityTier = 1 AND OrderCount > 3  
ORDER BY OrderCount DESC;
/* 
	CustomerID | MaritalStatus | CityTier | OrderCount | PreferredOrderCat  | PreferredPaymentMode |
	+------------+---------------+----------+------------+--------------------+----------------------+
	|      53605 | Married       |        1 |         16 | Grocery            | Credit Card          |
	|      53628 | Married       |        1 |         16 | Grocery            | Credit Card          |
	|      54206 | Married       |        1 |         16 | Others             | Cash on Delivery     |
	|      54287 | Married       |        1 |         16 | Fashion            | Credit Card          |
	|      54586 | Married       |        1 |         16 | Grocery            | Debit Card           |
	|      55075 | Married       |        1 |         16 | Grocery            | Credit Card          |
	|      55098 | Married       |        1 |         16 | Grocery            | Credit Card          |
	|      50813 | Married       |        1 |         15 | Grocery            | Credit Card          |
	|      51391 | Married       |        1 |         15 | Others             | Cash on Delivery     |
	|      51472 | Married       |        1 |         15 | Fashion            | Credit Card          |
	|      51771 | Married       |        1 |         15 | Grocery            | Debit Card           |
	|      52283 | Married       |        1 |         15 | Grocery            | Credit Card          |
	|      53275 | Married       |        1 |         15 | Others             | Debit Card           |
	|      53344 | Married       |        1 |         15 | Grocery            | Debit Card           |
	|      53613 | Married       |        1 |         15 | Others             | Debit Card           |
	|      53847 | Married       |        1 |         15 | Fashion            | Debit Card           |
	|      53994 | Married       |        1 |         15 | Fashion            | Debit Card           |
	|      54745 | Married       |        1 |         15 | Others             | Debit Card           |
	|      54814 | Married       |        1 |         15 | Grocery            | Debit Card           |
	|      55083 | Married       |        1 |         15 | Others             | Debit Card           |
	|      55239 | Married       |        1 |         15 | Grocery            | Debit Card           |
	|      55317 | Married       |        1 |         15 | Fashion            | Debit Card           |
	|      55464 | Married       |        1 |         15 | Fashion            | Debit Card           |
	|      50460 | Married       |        1 |         14 | Others             | Debit Card           |
	|      50529 | Married       |        1 |         14 | Grocery            | Debit Card           |
	|      50798 | Married       |        1 |         14 | Others             | Debit Card           |
	|      51032 | Married       |        1 |         14 | Fashion            | Debit Card           |
	|      51097 | Married       |        1 |         14 | Fashion            | Debit Card           |
	|      51179 | Married       |        1 |         14 | Fashion            | Debit Card           |
	|      51930 | Married       |        1 |         14 | Others             | Debit Card           |
	|      51999 | Married       |        1 |         14 | Grocery            | Debit Card           |
	|      52268 | Married       |        1 |         14 | Others             | Debit Card           |
	|      52424 | Married       |        1 |         14 | Grocery            | Debit Card           |
	|      52502 | Married       |        1 |         14 | Fashion            | Debit Card           |
	|      52567 | Married       |        1 |         14 | Fashion            | Debit Card           |
	|      52649 | Married       |        1 |         14 | Fashion            | Debit Card           |
	|      53784 | Married       |        1 |         14 | Fashion            | Debit Card           |
	|      54223 | Married       |        1 |         14 | Others             | Credit Card          |
	|      54487 | Married       |        1 |         14 | Others             | Credit Card          |
	|      54960 | Married       |        1 |         14 | Grocery            | Credit Card          |
	|      55254 | Married       |        1 |         14 | Fashion            | Debit Card           |
	|      50969 | Married       |        1 |         13 | Fashion            | Debit Card           |
	|      51408 | Married       |        1 |         13 | Others             | Credit Card          |
	|      51672 | Married       |        1 |         13 | Others             | Credit Card          |
	|      52145 | Married       |        1 |         13 | Grocery            | Credit Card          |
	|      52439 | Married       |        1 |         13 | Fashion            | Debit Card           |
	|      53077 | Married       |        1 |         13 | Mobile Phone       | Debit Card           |
	|      54022 | Married       |        1 |         13 | Others             | Debit Card           |
	|      54225 | Married       |        1 |         13 | Fashion            | Cash on Delivery     |
	|      54547 | Married       |        1 |         13 | Mobile Phone       | Debit Card           |
	|      55492 | Married       |        1 |         13 | Others             | Debit Card           |
	|      50262 | Married       |        1 |         12 | Mobile Phone       | Debit Card           |
	|      51014 | Married       |        1 |         12 | Grocery            | Credit Card          |
	|      51207 | Married       |        1 |         12 | Others             | Debit Card           |
	|      51410 | Married       |        1 |         12 | Fashion            | Cash on Delivery     |
	|      51732 | Married       |        1 |         12 | Mobile Phone       | Debit Card           |
	|      52484 | Married       |        1 |         12 | Grocery            | Credit Card          |
	|      52677 | Married       |        1 |         12 | Others             | Debit Card           |
	|      53669 | Married       |        1 |         12 | Laptop & Accessory | Credit Card          |
	|      54039 | Married       |        1 |         12 | Grocery            | Debit Card           |
	|      54351 | Married       |        1 |         12 | Others             | Debit Card           |
	|      54355 | Married       |        1 |         12 | Grocery            | Credit Card          |
	|      54392 | Married       |        1 |         12 | Others             | Cash on Delivery     |
	|      54475 | Married       |        1 |         12 | Grocery            | Credit Card          |
	|      54572 | Married       |        1 |         12 | Others             | Debit Card           |
	|      54946 | Married       |        1 |         12 | Fashion            | Cash on Delivery     |
	|      55139 | Married       |        1 |         12 | Laptop & Accessory | Credit Card          |
	|      55509 | Married       |        1 |         12 | Grocery            | Debit Card           |
	|      50689 | Married       |        1 |         11 | Grocery            | Debit Card           |
	|      50854 | Married       |        1 |         11 | Laptop & Accessory | Credit Card          |
	|      51224 | Married       |        1 |         11 | Grocery            | Debit Card           |
	|      51536 | Married       |        1 |         11 | Others             | Debit Card           |
	|      51540 | Married       |        1 |         11 | Grocery            | Credit Card          |
	|      51577 | Married       |        1 |         11 | Others             | Cash on Delivery     |
	|      51660 | Married       |        1 |         11 | Grocery            | Credit Card          |
	|      51757 | Married       |        1 |         11 | Others             | Debit Card           |
	|      52084 | Married       |        1 |         11 | Grocery            | Debit Card           |
	|      52131 | Married       |        1 |         11 | Fashion            | Cash on Delivery     |
	|      52159 | Married       |        1 |         11 | Grocery            | Debit Card           |
	|      52324 | Married       |        1 |         11 | Laptop & Accessory | Credit Card          |
	|      52694 | Married       |        1 |         11 | Grocery            | Debit Card           |
	|      53420 | Married       |        1 |         11 | Fashion            | Credit Card          |
	|      54249 | Married       |        1 |         11 | Laptop & Accessory | Debit Card           |
	|      54430 | Married       |        1 |         11 | Mobile Phone       | Debit Card           |
	|      54559 | Married       |        1 |         11 | Laptop & Accessory | Credit Card          |
	|      54890 | Married       |        1 |         11 | Fashion            | Credit Card          |
	|      50605 | Married       |        1 |         10 | Fashion            | Credit Card          |
	|      51434 | Married       |        1 |         10 | Laptop & Accessory | Debit Card           |
	|      51615 | Married       |        1 |         10 | Mobile Phone       | Debit Card           |
	|      51744 | Married       |        1 |         10 | Laptop & Accessory | Credit Card          |
	|      52075 | Married       |        1 |         10 | Fashion            | Credit Card          |
	|      53002 | Married       |        1 |         10 | Fashion            | Debit Card           |
	|      54100 | Married       |        1 |         10 | Laptop & Accessory | Cash on Delivery     |
	|      54135 | Married       |        1 |         10 | Mobile Phone       | Cash on Delivery     |
	|      54347 | Married       |        1 |         10 | Others             | Credit Card          |
	|      54472 | Married       |        1 |         10 | Fashion            | Debit Card           |
	|      54495 | Married       |        1 |         10 | Laptop & Accessory | UPI                  |
	|      55116 | Married       |        1 |         10 | Others             | Credit Card          |
	|      55570 | Married       |        1 |         10 | Laptop & Accessory | Cash on Delivery     |
	|      55605 | Married       |        1 |         10 | Mobile Phone       | Cash on Delivery     |
	|      50187 | Married       |        1 |          9 | Fashion            | Debit Card           |
	|      51285 | Married       |        1 |          9 | Laptop & Accessory | Cash on Delivery     |
	|      51320 | Married       |        1 |          9 | Mobile Phone       | Cash on Delivery     |
	|      51439 | Married       |        1 |          9 | Fashion            | Credit Card          |
	|      51532 | Married       |        1 |          9 | Others             | Credit Card          |
	|      51617 | Married       |        1 |          9 | Fashion            | Debit Card           |
	|      51657 | Married       |        1 |          9 | Fashion            | Debit Card           |
	|      51680 | Married       |        1 |          9 | Laptop & Accessory | UPI                  |
	|      52301 | Married       |        1 |          9 | Others             | Credit Card          |
	|      52755 | Married       |        1 |          9 | Laptop & Accessory | Cash on Delivery     |
	|      52790 | Married       |        1 |          9 | Mobile Phone       | Cash on Delivery     |
	|      53565 | Married       |        1 |          9 | Laptop & Accessory | Debit Card           |
	|      53903 | Married       |        1 |          9 | Mobile Phone       | Debit Card           |
	|      54080 | Married       |        1 |          9 | Laptop & Accessory | Debit Card           |
	|      54116 | Married       |        1 |          9 | Laptop & Accessory | Credit Card          |
	|      54176 | Married       |        1 |          9 | Fashion            | Debit Card           |
	|      54486 | Married       |        1 |          9 | Fashion            | Debit Card           |
	|      54664 | Married       |        1 |          9 | Mobile Phone       | Debit Card           |
	|      54851 | Married       |        1 |          9 | Laptop & Accessory | Credit Card          |
	|      55035 | Married       |        1 |          9 | Laptop & Accessory | Debit Card           |
	|      55373 | Married       |        1 |          9 | Mobile Phone       | Debit Card           |
	|      55550 | Married       |        1 |          9 | Laptop & Accessory | Debit Card           |
	|      55586 | Married       |        1 |          9 | Laptop & Accessory | Credit Card          |
	|      50750 | Married       |        1 |          8 | Laptop & Accessory | Debit Card           |
	|      51088 | Married       |        1 |          8 | Mobile Phone       | Debit Card           |
	|      51265 | Married       |        1 |          8 | Laptop & Accessory | Debit Card           |
	|      51301 | Married       |        1 |          8 | Laptop & Accessory | Credit Card          |
	|      51361 | Married       |        1 |          8 | Fashion            | Debit Card           |
	|      51659 | Married       |        1 |          8 | Fashion            | Debit Card           |
	|      51671 | Married       |        1 |          8 | Fashion            | Debit Card           |
	|      51849 | Married       |        1 |          8 | Mobile Phone       | Debit Card           |
	|      52036 | Married       |        1 |          8 | Laptop & Accessory | Credit Card          |
	|      52220 | Married       |        1 |          8 | Laptop & Accessory | Debit Card           |
	|      52558 | Married       |        1 |          8 | Mobile Phone       | Debit Card           |
	|      52735 | Married       |        1 |          8 | Laptop & Accessory | Debit Card           |
	|      52771 | Married       |        1 |          8 | Laptop & Accessory | Credit Card          |
	|      52947 | Married       |        1 |          8 | Mobile Phone       | Credit Card          |
	|      53327 | Married       |        1 |          8 | Mobile Phone       | Debit Card           |
	|      53573 | Married       |        1 |          8 | Fashion            | Cash on Delivery     |
	|      53623 | Married       |        1 |          8 | Mobile Phone       | Cash on Delivery     |
	|      53790 | Married       |        1 |          8 | Fashion            | Cash on Delivery     |
	|      53805 | Married       |        1 |          8 | Mobile Phone       | UPI                  |
	|      53822 | Married       |        1 |          8 | Laptop & Accessory | Cash on Delivery     |
	|      53837 | Married       |        1 |          8 | Laptop & Accessory | Debit Card           |
	|      53839 | Married       |        1 |          8 | Laptop & Accessory | Credit Card          |
	|      53854 | Married       |        1 |          8 | Mobile Phone       | Credit Card          |
	|      53870 | Married       |        1 |          8 | Laptop & Accessory | Debit Card           |
	|      53973 | Married       |        1 |          8 | Mobile Phone       | Debit Card           |
	|      53995 | Married       |        1 |          8 | Laptop & Accessory | Debit Card           |
	|      54025 | Married       |        1 |          8 | Mobile Phone       | Debit Card           |
	|      54052 | Married       |        1 |          8 | Mobile Phone       | UPI                  |
	|      54063 | Married       |        1 |          8 | Laptop & Accessory | Credit Card          |
	|      54109 | Married       |        1 |          8 | Laptop & Accessory | Debit Card           |
	|      54170 | Married       |        1 |          8 | Laptop & Accessory | Credit Card          |
	|      54221 | Married       |        1 |          8 | Laptop & Accessory | Credit Card          |
	|      54308 | Married       |        1 |          8 | Grocery            | Debit Card           |
	|      54417 | Married       |        1 |          8 | Mobile Phone       | Credit Card          |
	|      54427 | Married       |        1 |          8 | Laptop & Accessory | Credit Card          |
	|      54478 | Married       |        1 |          8 | Laptop & Accessory | Credit Card          |
	|      54596 | Married       |        1 |          8 | Fashion            | Credit Card          |
	|      54667 | Married       |        1 |          8 | Fashion            | UPI                  |
	|      54765 | Married       |        1 |          8 | Laptop & Accessory | Debit Card           |
	|      54797 | Married       |        1 |          8 | Mobile Phone       | Debit Card           |
	|      54819 | Married       |        1 |          8 | Mobile Phone       | Debit Card           |
	|      54860 | Married       |        1 |          8 | Grocery            | Debit Card           |
	|      54927 | Married       |        1 |          8 | Others             | Credit Card          |
	|      55043 | Married       |        1 |          8 | Fashion            | Cash on Delivery     |
	|      55052 | Married       |        1 |          8 | Mobile Phone       | Debit Card           |
	|      55093 | Married       |        1 |          8 | Mobile Phone       | Cash on Delivery     |
	|      55105 | Married       |        1 |          8 | Laptop & Accessory | Debit Card           |
	|      55140 | Married       |        1 |          8 | Laptop & Accessory | Credit Card          |
	|      55260 | Married       |        1 |          8 | Fashion            | Cash on Delivery     |
	|      55275 | Married       |        1 |          8 | Mobile Phone       | UPI                  |
	|      55292 | Married       |        1 |          8 | Laptop & Accessory | Cash on Delivery     |
	|      55307 | Married       |        1 |          8 | Laptop & Accessory | Debit Card           |
	|      55309 | Married       |        1 |          8 | Laptop & Accessory | Credit Card          |
	|      55324 | Married       |        1 |          8 | Mobile Phone       | Credit Card          |
	|      55340 | Married       |        1 |          8 | Laptop & Accessory | Debit Card           |
	|      55443 | Married       |        1 |          8 | Mobile Phone       | Debit Card           |
	|      55465 | Married       |        1 |          8 | Laptop & Accessory | Debit Card           |
	|      55495 | Married       |        1 |          8 | Mobile Phone       | Debit Card           |
	|      55522 | Married       |        1 |          8 | Mobile Phone       | UPI                  |
	|      55533 | Married       |        1 |          8 | Laptop & Accessory | Credit Card          |
	|      55579 | Married       |        1 |          8 | Laptop & Accessory | Debit Card           |
	|      50132 | Married       |        1 |          7 | Mobile Phone       | Credit Card          |
	|      50512 | Married       |        1 |          7 | Mobile Phone       | Debit Card           |
	|      50758 | Married       |        1 |          7 | Fashion            | Cash on Delivery     |
	|      50808 | Married       |        1 |          7 | Mobile Phone       | Cash on Delivery     |
	|      50975 | Married       |        1 |          7 | Fashion            | Cash on Delivery     |
	|      50990 | Married       |        1 |          7 | Mobile Phone       | UPI                  |
	|      51007 | Married       |        1 |          7 | Laptop & Accessory | Cash on Delivery     |
	|      51022 | Married       |        1 |          7 | Laptop & Accessory | Debit Card           |
	|      51024 | Married       |        1 |          7 | Laptop & Accessory | Credit Card          |
	|      51039 | Married       |        1 |          7 | Mobile Phone       | Credit Card          |
	|      51055 | Married       |        1 |          7 | Laptop & Accessory | Debit Card           |
	|      51158 | Married       |        1 |          7 | Mobile Phone       | Debit Card           |
	|      51180 | Married       |        1 |          7 | Laptop & Accessory | Debit Card           |
	|      51210 | Married       |        1 |          7 | Mobile Phone       | Debit Card           |
	|      51237 | Married       |        1 |          7 | Mobile Phone       | UPI                  |
	|      51248 | Married       |        1 |          7 | Laptop & Accessory | Credit Card          |
	|      51294 | Married       |        1 |          7 | Laptop & Accessory | Debit Card           |
	|      51355 | Married       |        1 |          7 | Laptop & Accessory | Credit Card          |
	|      51406 | Married       |        1 |          7 | Laptop & Accessory | Credit Card          |
	|      51493 | Married       |        1 |          7 | Grocery            | Debit Card           |
	|      51602 | Married       |        1 |          7 | Mobile Phone       | Credit Card          |
	|      51612 | Married       |        1 |          7 | Laptop & Accessory | Credit Card          |
	|      51663 | Married       |        1 |          7 | Laptop & Accessory | Credit Card          |
	|      51852 | Married       |        1 |          7 | Fashion            | UPI                  |
	|      51950 | Married       |        1 |          7 | Laptop & Accessory | Debit Card           |
	|      51982 | Married       |        1 |          7 | Mobile Phone       | Debit Card           |
	|      52004 | Married       |        1 |          7 | Mobile Phone       | Debit Card           |
	|      52045 | Married       |        1 |          7 | Grocery            | Debit Card           |
	|      52112 | Married       |        1 |          7 | Others             | Credit Card          |
	|      52228 | Married       |        1 |          7 | Fashion            | Cash on Delivery     |
	|      52237 | Married       |        1 |          7 | Mobile Phone       | Debit Card           |
	|      52278 | Married       |        1 |          7 | Mobile Phone       | Cash on Delivery     |
	|      52290 | Married       |        1 |          7 | Laptop & Accessory | Debit Card           |
	|      52325 | Married       |        1 |          7 | Laptop & Accessory | Credit Card          |
	|      52445 | Married       |        1 |          7 | Fashion            | Cash on Delivery     |
	|      52460 | Married       |        1 |          7 | Mobile Phone       | UPI                  |
	|      52477 | Married       |        1 |          7 | Laptop & Accessory | Cash on Delivery     |
	|      52492 | Married       |        1 |          7 | Laptop & Accessory | Debit Card           |
	|      52494 | Married       |        1 |          7 | Laptop & Accessory | Credit Card          |
	|      52509 | Married       |        1 |          7 | Mobile Phone       | Credit Card          |
	|      52525 | Married       |        1 |          7 | Laptop & Accessory | Debit Card           |
	|      52628 | Married       |        1 |          7 | Mobile Phone       | Debit Card           |
	|      52650 | Married       |        1 |          7 | Laptop & Accessory | Debit Card           |
	|      52680 | Married       |        1 |          7 | Mobile Phone       | Debit Card           |
	|      52707 | Married       |        1 |          7 | Mobile Phone       | UPI                  |
	|      52718 | Married       |        1 |          7 | Laptop & Accessory | Credit Card          |
	|      52764 | Married       |        1 |          7 | Laptop & Accessory | Debit Card           |
	|      52864 | Married       |        1 |          7 | Laptop & Accessory | Credit Card          |
	|      53044 | Married       |        1 |          7 | Laptop & Accessory | Credit Card          |
	|      53159 | Married       |        1 |          7 | Laptop & Accessory | Cash on Delivery     |
	|      53537 | Married       |        1 |          7 | Fashion            | Debit Card           |
	|      53746 | Married       |        1 |          7 | Grocery            | Credit Card          |
	|      53821 | Married       |        1 |          7 | Laptop & Accessory | Debit Card           |
	|      53876 | Married       |        1 |          7 | Grocery            | Debit Card           |
	|      53905 | Married       |        1 |          7 | Fashion            | Debit Card           |
	|      54021 | Married       |        1 |          7 | Others             | Credit Card          |
	|      54059 | Married       |        1 |          7 | Laptop & Accessory | UPI                  |
	|      54123 | Married       |        1 |          7 | Fashion            | Debit Card           |
	|      54334 | Married       |        1 |          7 | Laptop & Accessory | Credit Card          |
	|      54514 | Married       |        1 |          7 | Laptop & Accessory | Credit Card          |
	|      54629 | Married       |        1 |          7 | Laptop & Accessory | Cash on Delivery     |
	|      54761 | Married       |        1 |          7 | Laptop & Accessory | Debit Card           |
	|      54853 | Married       |        1 |          7 | Laptop & Accessory | Credit Card          |
	|      54906 | Married       |        1 |          7 | Laptop & Accessory | Credit Card          |
	|      55007 | Married       |        1 |          7 | Fashion            | Debit Card           |
	|      55050 | Married       |        1 |          7 | Mobile Phone       | Debit Card           |
	|      55102 | Married       |        1 |          7 | Laptop & Accessory | Cash on Delivery     |
	|      55146 | Married       |        1 |          7 | Laptop & Accessory | Credit Card          |
	|      55216 | Married       |        1 |          7 | Grocery            | Credit Card          |
	|      55291 | Married       |        1 |          7 | Laptop & Accessory | Debit Card           |
	|      55346 | Married       |        1 |          7 | Grocery            | Debit Card           |
	|      55375 | Married       |        1 |          7 | Fashion            | Debit Card           |
	|      55491 | Married       |        1 |          7 | Others             | Credit Card          |
	|      55529 | Married       |        1 |          7 | Laptop & Accessory | UPI                  |
	|      55593 | Married       |        1 |          7 | Fashion            | Debit Card           |
	|      50049 | Married       |        1 |          6 | Laptop & Accessory | Credit Card          |
	|      50152 | Married       |        1 |          6 | Fashion            | Debit Card           |
	|      50229 | Married       |        1 |          6 | Laptop & Accessory | Credit Card          |
	|      50344 | Married       |        1 |          6 | Laptop & Accessory | Cash on Delivery     |
	|      50722 | Married       |        1 |          6 | Fashion            | Debit Card           |
	|      50931 | Married       |        1 |          6 | Grocery            | Credit Card          |
	|      51006 | Married       |        1 |          6 | Laptop & Accessory | Debit Card           |
	|      51061 | Married       |        1 |          6 | Grocery            | Debit Card           |
	|      51090 | Married       |        1 |          6 | Fashion            | Debit Card           |
	|      51206 | Married       |        1 |          6 | Others             | Credit Card          |
	|      51244 | Married       |        1 |          6 | Laptop & Accessory | UPI                  |
	|      51519 | Married       |        1 |          6 | Laptop & Accessory | Credit Card          |
	|      51622 | Married       |        1 |          6 | Fashion            | Debit Card           |
	|      51699 | Married       |        1 |          6 | Laptop & Accessory | Credit Card          |
	|      51814 | Married       |        1 |          6 | Laptop & Accessory | Cash on Delivery     |
	|      51946 | Married       |        1 |          6 | Laptop & Accessory | Debit Card           |
	|      52038 | Married       |        1 |          6 | Laptop & Accessory | Credit Card          |
	|      52091 | Married       |        1 |          6 | Laptop & Accessory | Credit Card          |
	|      52192 | Married       |        1 |          6 | Fashion            | Debit Card           |
	|      52235 | Married       |        1 |          6 | Mobile Phone       | Debit Card           |
	|      52287 | Married       |        1 |          6 | Laptop & Accessory | Cash on Delivery     |
	|      52331 | Married       |        1 |          6 | Laptop & Accessory | Credit Card          |
	|      52401 | Married       |        1 |          6 | Grocery            | Credit Card          |
	|      52476 | Married       |        1 |          6 | Laptop & Accessory | Debit Card           |
	|      52531 | Married       |        1 |          6 | Grocery            | Debit Card           |
	|      52560 | Married       |        1 |          6 | Fashion            | Debit Card           |
	|      52676 | Married       |        1 |          6 | Others             | Credit Card          |
	|      52714 | Married       |        1 |          6 | Laptop & Accessory | UPI                  |
	|      53123 | Married       |        1 |          6 | Mobile Phone       | Debit Card           |
	|      53437 | Married       |        1 |          6 | Others             | Debit Card           |
	|      53611 | Married       |        1 |          6 | Laptop & Accessory | Credit Card          |
	|      53786 | Married       |        1 |          6 | Laptop & Accessory | Debit Card           |
	|      53931 | Married       |        1 |          6 | Laptop & Accessory | Debit Card           |
	|      53969 | Married       |        1 |          6 | Fashion            | Debit Card           |
	|      54189 | Married       |        1 |          6 | Fashion            | Credit Card          |
	|      54290 | Married       |        1 |          6 | Laptop & Accessory | Credit Card          |
	|      54408 | Married       |        1 |          6 | Laptop & Accessory | Debit Card           |
	|      54593 | Married       |        1 |          6 | Mobile Phone       | Debit Card           |
	|      54612 | Married       |        1 |          6 | Fashion            | Credit Card          |
	|      54842 | Married       |        1 |          6 | Fashion            | Cash on Delivery     |
	|      54907 | Married       |        1 |          6 | Others             | Debit Card           |
	|      54957 | Married       |        1 |          6 | Mobile Phone       | Cash on Delivery     |
	|      55047 | Married       |        1 |          6 | Mobile Phone       | Credit Card          |
	|      55081 | Married       |        1 |          6 | Laptop & Accessory | Credit Card          |
	|      55127 | Married       |        1 |          6 | Fashion            | Credit Card          |
	|      55185 | Married       |        1 |          6 | Grocery            | Credit Card          |
	|      55256 | Married       |        1 |          6 | Laptop & Accessory | Debit Card           |
	|      55401 | Married       |        1 |          6 | Laptop & Accessory | Debit Card           |
	|      55439 | Married       |        1 |          6 | Fashion            | Debit Card           |
	|      50308 | Married       |        1 |          5 | Mobile Phone       | Debit Card           |
	|      50622 | Married       |        1 |          5 | Others             | Debit Card           |
	|      50796 | Married       |        1 |          5 | Laptop & Accessory | Credit Card          |
	|      50971 | Married       |        1 |          5 | Laptop & Accessory | Debit Card           |
	|      51116 | Married       |        1 |          5 | Laptop & Accessory | Debit Card           |
	|      51154 | Married       |        1 |          5 | Fashion            | Debit Card           |
	|      51297 | Married       |        1 |          5 | Fashion            | Credit Card          |
	|      51374 | Married       |        1 |          5 | Fashion            | Credit Card          |
	|      51475 | Married       |        1 |          5 | Laptop & Accessory | Credit Card          |
	|      51593 | Married       |        1 |          5 | Laptop & Accessory | Debit Card           |
	|      51778 | Married       |        1 |          5 | Mobile Phone       | Debit Card           |
	|      51797 | Married       |        1 |          5 | Fashion            | Credit Card          |
	|      51981 | Married       |        1 |          5 | Fashion            | Debit Card           |
	|      52092 | Married       |        1 |          5 | Others             | Debit Card           |
	|      52142 | Married       |        1 |          5 | Mobile Phone       | Cash on Delivery     |
	|      52232 | Married       |        1 |          5 | Mobile Phone       | Credit Card          |
	|      52266 | Married       |        1 |          5 | Laptop & Accessory | Credit Card          |
	|      52312 | Married       |        1 |          5 | Fashion            | Credit Card          |
	|      52370 | Married       |        1 |          5 | Grocery            | Credit Card          |
	|      52441 | Married       |        1 |          5 | Laptop & Accessory | Debit Card           |
	|      52586 | Married       |        1 |          5 | Laptop & Accessory | Debit Card           |
	|      52624 | Married       |        1 |          5 | Fashion            | Debit Card           |
	|      52767 | Married       |        1 |          5 | Fashion            | Credit Card          |
	|      52934 | Married       |        1 |          5 | Laptop & Accessory | Cash on Delivery     |
	|      53182 | Married       |        1 |          5 | Laptop & Accessory | Credit Card          |
	|      53200 | Married       |        1 |          5 | Laptop & Accessory | Debit Card           |
	|      53268 | Married       |        1 |          5 | Mobile Phone       | Debit Card           |
	|      53542 | Married       |        1 |          5 | Others             | Cash on Delivery     |
	|      53549 | Married       |        1 |          5 | Others             | Credit Card          |
	|      53731 | Married       |        1 |          5 | Fashion            | Credit Card          |
	|      53875 | Married       |        1 |          5 | Grocery            | Credit Card          |
	|      53899 | Married       |        1 |          5 | Laptop & Accessory | Credit Card          |
	|      54013 | Married       |        1 |          5 | Fashion            | Debit Card           |
	|      54042 | Married       |        1 |          5 | Grocery            | Credit Card          |
	|      54068 | Married       |        1 |          5 | Others             | Debit Card           |
	|      54134 | Married       |        1 |          5 | Others             | Debit Card           |
	|      54173 | Married       |        1 |          5 | Mobile Phone       | Debit Card           |
	|      54186 | Married       |        1 |          5 | Others             | UPI                  |
	|      54283 | Married       |        1 |          5 | Mobile Phone       | Debit Card           |
	|      54286 | Married       |        1 |          5 | Mobile Phone       | UPI                  |
	|      54404 | Married       |        1 |          5 | Laptop & Accessory | Cash on Delivery     |
	|      54633 | Married       |        1 |          5 | Laptop & Accessory | Debit Card           |
	|      54652 | Married       |        1 |          5 | Laptop & Accessory | Credit Card          |
	|      54670 | Married       |        1 |          5 | Laptop & Accessory | Debit Card           |
	|      54719 | Married       |        1 |          5 | Laptop & Accessory | Debit Card           |
	|      54738 | Married       |        1 |          5 | Mobile Phone       | Debit Card           |
	|      54825 | Married       |        1 |          5 | Laptop & Accessory | Debit Card           |
	|      55012 | Married       |        1 |          5 | Others             | Cash on Delivery     |
	|      55019 | Married       |        1 |          5 | Others             | Credit Card          |
	|      55044 | Married       |        1 |          5 | Mobile Phone       | Credit Card          |
	|      55201 | Married       |        1 |          5 | Fashion            | Credit Card          |
	|      55345 | Married       |        1 |          5 | Grocery            | Credit Card          |
	|      55369 | Married       |        1 |          5 | Laptop & Accessory | Credit Card          |
	|      55483 | Married       |        1 |          5 | Fashion            | Debit Card           |
	|      55512 | Married       |        1 |          5 | Grocery            | Credit Card          |
	|      55538 | Married       |        1 |          5 | Others             | Debit Card           |
	|      55604 | Married       |        1 |          5 | Others             | Debit Card           |
	|      50119 | Married       |        1 |          4 | Laptop & Accessory | Cash on Delivery     |
	|      50367 | Married       |        1 |          4 | Laptop & Accessory | Credit Card          |
	|      50385 | Married       |        1 |          4 | Laptop & Accessory | Debit Card           |
	|      50453 | Married       |        1 |          4 | Mobile Phone       | Debit Card           |
	|      50727 | Married       |        1 |          4 | Others             | Cash on Delivery     |
	|      50734 | Married       |        1 |          4 | Others             | Credit Card          |
	|      51060 | Married       |        1 |          4 | Grocery            | Credit Card          |
	|      51084 | Married       |        1 |          4 | Laptop & Accessory | Credit Card          |
	|      51198 | Married       |        1 |          4 | Fashion            | Debit Card           |
	|      51227 | Married       |        1 |          4 | Grocery            | Credit Card          |
	|      51253 | Married       |        1 |          4 | Others             | Debit Card           |
	|      51281 | Married       |        1 |          4 | Fashion            | Credit Card          |
	|      51319 | Married       |        1 |          4 | Others             | Debit Card           |
	|      51358 | Married       |        1 |          4 | Mobile Phone       | Debit Card           |
	|      51371 | Married       |        1 |          4 | Others             | UPI                  |
	|      51468 | Married       |        1 |          4 | Mobile Phone       | Debit Card           |
	|      51471 | Married       |        1 |          4 | Mobile Phone       | UPI                  |
	|      51559 | Married       |        1 |          4 | Fashion            | Debit Card           |
	|      51589 | Married       |        1 |          4 | Laptop & Accessory | Cash on Delivery     |
	|      51818 | Married       |        1 |          4 | Laptop & Accessory | Debit Card           |
	|      51837 | Married       |        1 |          4 | Laptop & Accessory | Credit Card          |
	|      51855 | Married       |        1 |          4 | Laptop & Accessory | Debit Card           |
	|      51904 | Married       |        1 |          4 | Laptop & Accessory | Debit Card           |
	|      51923 | Married       |        1 |          4 | Mobile Phone       | Debit Card           |
	|      51993 | Married       |        1 |          4 | Fashion            | Cash on Delivery     |
	|      52010 | Married       |        1 |          4 | Laptop & Accessory | Debit Card           |
	|      52197 | Married       |        1 |          4 | Others             | Cash on Delivery     |
	|      52204 | Married       |        1 |          4 | Others             | Credit Card          |
	|      52229 | Married       |        1 |          4 | Mobile Phone       | Credit Card          |
	|      52530 | Married       |        1 |          4 | Grocery            | Credit Card          |
	|      52554 | Married       |        1 |          4 | Laptop & Accessory | Credit Card          |
	|      52668 | Married       |        1 |          4 | Fashion            | Debit Card           |
	|      52697 | Married       |        1 |          4 | Grocery            | Credit Card          |
	|      52723 | Married       |        1 |          4 | Others             | Debit Card           |
	|      52751 | Married       |        1 |          4 | Fashion            | Credit Card          |
	|      52789 | Married       |        1 |          4 | Others             | Debit Card           |
	|      52948 | Married       |        1 |          4 | Others             | Credit Card          |
	|      52995 | Married       |        1 |          4 | Fashion            | Credit Card          |
	|      53081 | Married       |        1 |          4 | Grocery            | Debit Card           |
	|      53415 | Married       |        1 |          4 | Laptop & Accessory | Credit Card          |
	|      53679 | Married       |        1 |          4 | Laptop & Accessory | Debit Card           |
	|      53780 | Married       |        1 |          4 | Laptop & Accessory | Credit Card          |
	|      53851 | Married       |        1 |          4 | Laptop & Accessory | UPI                  |
	|      53989 | Married       |        1 |          4 | Laptop & Accessory | Credit Card          |
	|      54009 | Married       |        1 |          4 | Mobile Phone       | Credit Card          |
	|      54011 | Married       |        1 |          4 | Mobile Phone       | Cash on Delivery     |
	|      54037 | Married       |        1 |          4 | Laptop & Accessory | Debit Card           |
	|      54044 | Married       |        1 |          4 | Mobile Phone       | Cash on Delivery     |
	|      54164 | Married       |        1 |          4 | Mobile Phone       | Debit Card           |
	|      54241 | Married       |        1 |          4 | Laptop & Accessory | Debit Card           |
	|      54364 | Married       |        1 |          4 | Laptop & Accessory | Credit Card          |
	|      54418 | Married       |        1 |          4 | Others             | Credit Card          |
	|      54445 | Married       |        1 |          4 | Laptop & Accessory | Credit Card          |
	|      54465 | Married       |        1 |          4 | Fashion            | Credit Card          |
	|      54551 | Married       |        1 |          4 | Grocery            | Debit Card           |
	|      54555 | Married       |        1 |          4 | Laptop & Accessory | Credit Card          |
	|      54560 | Married       |        1 |          4 | Mobile Phone       | Debit Card           |
	|      54684 | Married       |        1 |          4 | Mobile Phone       | Credit Card          |
	|      54743 | Married       |        1 |          4 | Laptop & Accessory | Credit Card          |
	|      54753 | Married       |        1 |          4 | Grocery            | UPI                  |
	|      54801 | Married       |        1 |          4 | Mobile Phone       | Debit Card           |
	|      54885 | Married       |        1 |          4 | Laptop & Accessory | Credit Card          |
	|      55016 | Married       |        1 |          4 | Laptop & Accessory | Debit Card           |
	|      55029 | Married       |        1 |          4 | Mobile Phone       | Credit Card          |
	|      55149 | Married       |        1 |          4 | Laptop & Accessory | Debit Card           |
	|      55250 | Married       |        1 |          4 | Laptop & Accessory | Credit Card          |
	|      55321 | Married       |        1 |          4 | Laptop & Accessory | UPI                  |
	|      55459 | Married       |        1 |          4 | Laptop & Accessory | Credit Card          |
	|      55479 | Married       |        1 |          4 | Mobile Phone       | Credit Card          |
	|      55481 | Married       |        1 |          4 | Mobile Phone       | Cash on Delivery     |
	|      55507 | Married       |        1 |          4 | Laptop & Accessory | Debit Card           |
	|      55514 | Married       |        1 |          4 | Mobile Phone       | Cash on Delivery     |
	+------------+---------------+----------+------------+--------------------+----------------------+
*/
 
 /* 
	Create a ‘customer_returns’ table in the ‘ecomm’ database and insert the following data:
	ReturnID CustomerID ReturnDate RefundAmount
	1001 50022 2023-01-01 2130
	1002 50316 2023-01-23 2000
	1003 51099 2023-02-14 2290
	1004 52321 2023-03-08 2510
	1005 52928 2023-03-20 3000
	1006 53749 2023-04-17 1740
	1007 54206 2023-04-21 3250
	1008 54838 2023-04-30 1990
*/
CREATE TABLE ecomm.customer_returns
(ReturnID INT PRIMARY KEY,
CustomerID INT,
ReturnDate DATE,
RefundAmount DECIMAL(10,2) ); -- Table Created

INSERT INTO ecomm.customer_returns (ReturnID, CustomerID, ReturnDate, RefundAmount) VALUES 
(1001, 50022, '2023-01-01', 2130),
(1002, 50316, '2023-01-23', 2000),
(1003, 51099, '2023-02-14', 2290),
(1004, 52321, '2023-03-08', 2510),
(1005, 52928, '2023-03-20', 3000),
(1006, 53749, '2023-04-17', 1740),
(1007, 54206, '2023-04-21', 3250),
(1008, 54838, '2023-04-30', 1990); -- inserted

SELECT * FROM ecomm.customer_returns;
/*
	+----------+------------+------------+--------------+
	| ReturnID | CustomerID | ReturnDate | RefundAmount |
	+----------+------------+------------+--------------+
	|     1001 |      50022 | 2023-01-01 |      2130.00 |
	|     1002 |      50316 | 2023-01-23 |      2000.00 |
	|     1003 |      51099 | 2023-02-14 |      2290.00 |
	|     1004 |      52321 | 2023-03-08 |      2510.00 |
	|     1005 |      52928 | 2023-03-20 |      3000.00 |
	|     1006 |      53749 | 2023-04-17 |      1740.00 |
	|     1007 |      54206 | 2023-04-21 |      3250.00 |
	|     1008 |      54838 | 2023-04-30 |      1990.00 |
	+----------+------------+------------+--------------+
	8 rows in set (0.00 sec)
*/

-- To Ensure the Table has created in Database
SHOW TABLES IN ecomm;
/* 
	+-----------------------+
	| Tables_in_ecomm       |
	+-----------------------+
	| customer_churn        |
	| customer_churn_backup |
	| customer_returns      |
	+-----------------------+
	3 rows in set (0.02 sec)
*/
/*
	b) Display the return details along with the customer details of those who have churned and have made complaints
*/

-- Joining the tables and filtering the churned customers who have complaints
SELECT 
    cr.ReturnID, cr.CustomerID, cr.ReturnDate, cr.RefundAmount,
    cc.MaritalStatus, cc.CityTier, cc.OrderCount, cc.PreferredOrderCat, 
    cc.PreferredPaymentMode, cc.ChurnStatus, cc.ComplaintReceived
FROM ecomm.customer_returns cr
JOIN ecomm.customer_churn cc ON cr.CustomerID = cc.CustomerID
WHERE cc.ChurnStatus = 'Churned'
AND cc.ComplaintReceived = 'Yes';
/* 
	+----------+------------+------------+--------------+---------------+----------+------------+--------------------+----------------------+-------------+-------------------+
	| ReturnID | CustomerID | ReturnDate | RefundAmount | MaritalStatus | CityTier | OrderCount | PreferredOrderCat  | PreferredPaymentMode | ChurnStatus | ComplaintReceived |
	+----------+------------+------------+--------------+---------------+----------+------------+--------------------+----------------------+-------------+-------------------+
	|     1002 |      50316 | 2023-01-23 |      2000.00 | Married       |        2 |          1 | Fashion            | UPI                  | Churned     | Yes               |
	|     1004 |      52321 | 2023-03-08 |      2510.00 | Single        |        3 |          2 | Grocery            | E wallet             | Churned     | Yes               |
	|     1006 |      53749 | 2023-04-17 |      1740.00 | Single        |        3 |         11 | Laptop & Accessory | Credit Card          | Churned     | Yes               |
	+----------+------------+------------+--------------+---------------+----------+------------+--------------------+----------------------+-------------+-------------------+
	3 rows in set (0.00 sec)
*/





