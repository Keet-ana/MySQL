USE ecomm;
-- Column Renaming
/*
	➢ Rename the column "PreferedOrderCat" to "PreferredOrderCat".
*/

-- Renaming the Column "PreferdOrderCat" to "PreferredOrderCat"
-- To check the max size used  to determine the data size.
SELECT MAX(CHAR_LENGTH(PreferedOrderCat)) AS Max_Length
FROM customer_churn; -- Size is 18

ALTER TABLE customer_churn 
CHANGE COLUMN PreferedOrderCat PreferredOrderCat VARCHAR(25); -- Altered the name

-- To verify the rename
SHOW COLUMNS FROM customer_churn; -- PreferredOrderCat	varchar(25)

/*
	➢ Rename the column "HourSpendOnApp" to "HoursSpentOnApp".
*/
-- To check the max size used  to determine the data size.
SELECT MAX(CHAR_LENGTH(HourSpendOnApp)) AS Max_Length
FROM customer_churn; -- Max_length is 1

-- Alter command
ALTER TABLE customer_churn 
CHANGE COLUMN HourSpendOnApp HoursSpentOnApp INT;

-- To verify the rename
SHOW COLUMNS FROM customer_churn; -- HoursSpentOnApp	int

-- Creating new columns
/*
	➢ Create a new column named ‘ComplaintReceived’ with values "Yes" if the
	corresponding value in the ‘Complain’ is 1, and "No" otherwise.
*/

-- Adding 'ComplaintRecevied' Column
ALTER TABLE customer_churn 
ADD COLUMN ComplaintReceived VARCHAR(3); -- Column created

-- Updating as per the condition
UPDATE customer_churn 
SET ComplaintReceived = 
    CASE 
        WHEN Complain = 1 THEN 'Yes' 
        ELSE 'No' 
    END; -- Updated 

-- To verify the change
SELECT Complain, ComplaintReceived, COUNT(*) 
FROM customer_churn
GROUP BY Complain, ComplaintReceived;
/* 
	0	No	4024
	1	Yes	1604
*/

/*
	➢ Create a new column named 'ChurnStatus'. Set its value to “Churned” if the
	corresponding value in the 'Churn' column is 1, else assign “Active”.
*/
-- Adding Column 'ChurnStatus'
ALTER TABLE customer_churn 
ADD COLUMN ChurnStatus VARCHAR(10); -- Column Created

-- Updating as per the Column Condition
UPDATE customer_churn 
SET ChurnStatus = 
    CASE 
        WHEN Churn = 1 THEN 'Churned' 
        ELSE 'Active' 
    END; -- Updated the conditions
    
-- To verfiy the changes
SELECT Churn, ChurnStatus, COUNT(*) AS Count FROM customer_churn
GROUP BY Churn, ChurnStatus; -- While verifying ChurnStatus shows the null
/*
	1  948
	0  4680
*/
-- To check if the ChurnStatus as null_count
SELECT COUNT(*) AS Null_Count 
FROM customer_churn 
WHERE ChurnStatus IS NULL; -- Null_Count is 5628

-- Updating the query again as 
UPDATE customer_churn 
SET ChurnStatus = 
    CASE 
        WHEN Churn = 1 THEN 'Churned' 
        ELSE 'Active' 
    END
WHERE ChurnStatus IS NULL; -- Updated

-- To verfiy the changes
SELECT Churn, ChurnStatus, COUNT(*) AS Count FROM customer_churn
GROUP BY Churn, ChurnStatus; -- Now the ChurnStatus has fixed
/*
	1	Churned	948
	0	Active	4680
*/

-- Ensure ChurnStatus and ComplainRecevied column has been added
Desc Customer_churn;
/*	
	ComplaintReceived	varchar(3)	YES			
	ChurnStatus	varchar(10)	YES			
*/

-- Column Dropping
/* 
	➢ Drop the columns "Churn" and "Complain" from the table.	
*/
-- Dropping Both Columns
ALTER TABLE customer_churn  
DROP COLUMN Churn,  
DROP COLUMN Complain;

-- To Verify the Changes
DESC customer_churn;
/* 
	CustomerID	int
	Tenure	int
	PreferredLoginDevice	varchar(20)
	CityTier	int
	WarehouseToHome	int
	PreferredPaymentMode	varchar(20)
	Gender	enum('Male','Female')
	HoursSpentOnApp	int
	NumberOfDeviceRegistered	int
	PreferredOrderCat	varchar(25)
	SatisfactionScore	int
	MaritalStatus	varchar(10)
	NumberOfAddress	int
	OrderAmountHikeFromlastYear	int
	CouponUsed	int
	OrderCount	int
	DaySinceLastOrder	int
	CashbackAmount	int
	ComplaintReceived	varchar(3)
	ChurnStatus	varchar(10)
*/


