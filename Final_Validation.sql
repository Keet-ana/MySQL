USE ECOMM;

-- Checking Data Intergrity just to ensure no missing values or incorrect data
SELECT 
    COUNT(*) AS Null_Counts
FROM ecomm.customer_churn
WHERE ChurnStatus IS NULL 
   OR ComplaintReceived IS NULL 
   OR PreferredPaymentMode IS NULL;
/* 
	+-------------+
	| Null_Counts |
	+-------------+
	|           0 |
	+-------------+
	1 row in set (0.01 sec)
*/

-- To verify the table relationships, just to ensure the proper join works
SELECT cr.CustomerID FROM ecomm.customer_returns cr
LEFT JOIN ecomm.customer_churn cc ON cr.CustomerID = cc.CustomerID
WHERE cc.CustomerID IS NULL; -- Its Empty
/* 
	If the query returns no results, it means:
	 *All customers in customer_returns exist in customer_churn
	 *No missing or orphaned records between the two tables
	Thus, it confirms data consistency between Customer_returns and customer_churns!
*/ 

-- Checking the Key Metrics just to ensure the correct aggregation
SELECT SUM(OrderCount) AS Total_Orders
FROM ecomm.customer_churn; -- Total_Orders is 16672

-- Checking the total refund amount 
SELECT SUM(RefundAmount) AS Total_Refunds
FROM ecomm.customer_returns; -- Total_Refunds is 18910.00

-- Checking the Unique Identifers just to ensure there is no Duplicates
-- Customer_Churn table
SELECT CustomerID, COUNT(*) FROM ecomm.customer_churn
GROUP BY CustomerID HAVING COUNT(*) > 1; -- It is Empty Which means each customerID is Unique which helps to maintain the data Integrity.

-- Checking for Customer_returns
SELECT ReturnID, COUNT(*) FROM ecomm.customer_returns
GROUP BY ReturnID HAVING COUNT(*) > 1; -- It is Empty Which means each customerID is Unique which helps to maintain the data Integrity

-- Checking the performance Optimization just to ensure queries run efficientyly
SHOW INDEXES FROM ecomm.customer_churn;
/*
	+----------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
	| Table          | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
	+----------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
	| customer_churn |          0 | PRIMARY  |            1 | CustomerID  | A         |        5521 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
	+----------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
	1 row in set (0.04 sec)
*/

SHOW INDEXES FROM ecomm.customer_returns;
/*
	+------------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
	| Table            | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
	+------------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
	| customer_returns |          0 | PRIMARY  |            1 | ReturnID    | A         |           8 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
	+------------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
	1 row in set (0.00 sec)
*/

/*
	Index checks confirms that:
		* CustomerID in customer_churn is a PRIMARY KEY which ensure unique customer records.
		* ReturnID in customer_returns is a PRIMARY KEY which ensures unique return records.
		* Both tables are indexed properly with BTREE indexes which fast lookups and efficient queries.
*/

/*
	Adding Index to the CustomerID in Customer_returns table to optimize the query performance while using Join and 
    just to increase the lookup performance when filtering by CustomerId
*/

ALTER TABLE ecomm.customer_returns 
ADD INDEX idx_customer_id (CustomerID); -- Altered

-- Checking the unmatched customers (Customers without returns)
SELECT cc.CustomerID FROM ecomm.customer_churn cc
LEFT JOIN ecomm.customer_returns cr ON cc.CustomerID = cr.CustomerID
WHERE cr.CustomerID IS NULL; -- It returns 5620 rows in set (0.02 sec) which is normal

-- Verifying that every returns belongs to the existing customer
SELECT cr.CustomerID FROM ecomm.customer_returns cr
LEFT JOIN ecomm.customer_churn cc ON cr.CustomerID = cc.CustomerID
WHERE cc.CustomerID IS NULL; -- This is empty which is a good sign to go to go.

-- Checking if Any Return Date is Before 2023 (Possible Data Entry Error)
SELECT * FROM ecomm.customer_returns
WHERE ReturnDate < '2023-01-01'; -- Great! This is also empty.

-- Checking if Any Customers Have Negative Days Since Their Last Order
SELECT * FROM ecomm.customer_churn
WHERE DaySinceLastOrder < 0; -- This is also empty. Because there should no negative values

-- Checking if any churned customers have 0 orders
SELECT * FROM ecomm.customer_churn
WHERE ChurnStatus = 'Churned' AND OrderCount = 0; -- This looks empty which means there is no logical inconsistency because every customer should have placed one order.

-- Optimizing the table Storage just to improve the fragmented space to get optimized to improve performance.
OPTIMIZE TABLE ecomm.customer_churn;
OPTIMIZE TABLE ecomm.customer_returns;

/*
	Final Summary :
		* Data Consistency Checks: Ensure all customers in returns exist in churn.
		* Date Accuracy Checks: Verify no incorrect dates.
		* Logical Checks: Ensured churned customers have orders.
        * Performance Optimization - Optimize table storage.
*/






