USE Ecomm;
-- Dealing with Inconsistencies

/*
	Replace occurrences of “Phone” in the 'PreferredLoginDevice' column and
	“Mobile” in the 'PreferedOrderCat' column with “Mobile Phone” to ensure
	uniformity.
*/
-- Checking data before update
-- Checking occurance of Phone
SELECT PreferredLoginDevice, COUNT(*) AS Count FROM customer_churn
WHERE PreferredLoginDevice LIKE '%Phone%'
GROUP BY PreferredLoginDevice; 

/* 
	PreferredLoginDevice  Count
    ---------------------------
	Mobile Phone	      2765
	Phone	              1231
*/

-- Checking Occurance of Mobile on PreferedOrderCat
SELECT PreferedOrderCat, COUNT(*) AS Count FROM customer_churn
WHERE PreferedOrderCat LIKE '%Mobile%'
GROUP BY PreferedOrderCat;
/*
	PreferedOrderCat   Count
    ------------------------
    Mobile	           808
	Mobile Phone	   1270
 */

-- Replacing 'Phone' into 'Mobile Phone'
UPDATE customer_churn
SET PreferredLoginDevice = 'Mobile Phone'
WHERE PreferredLoginDevice = 'Phone';

-- Replacing 'Mobile' into 'Mobile Phone'
UPDATE customer_churn
SET PreferedOrderCat = 'Mobile Phone'
WHERE PreferedOrderCat = 'Mobile';

-- To verify the update
SELECT PreferredLoginDevice, COUNT(*) AS Count
FROM customer_churn
GROUP BY PreferredLoginDevice;
/*
	Mobile Phone	3996
	Computer	1632
*/
SELECT PreferedOrderCat, COUNT(*) AS Count
FROM customer_churn
GROUP BY PreferedOrderCat;
/*
	Laptop & Accessory	2050
	Mobile Phone	2078
	Others	264
	Fashion	826
	Grocery	410
*/

/*
	Standardize payment mode values: Replace "COD" with "Cash on Delivery" and
    "CC" with "Credit Card" in the PreferredPaymentMode column.
*/
-- Checking data before update
SELECT PreferredPaymentMode, COUNT(*) AS Count FROM customer_churn
WHERE PreferredPaymentMode IN ('COD', 'CC')
GROUP BY PreferredPaymentMode;
/*
	CC	273
	COD	365
*/

-- Updating the values
-- Updating Values 'Cash on Delivery' as 'COD'
UPDATE customer_churn
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE PreferredPaymentMode = 'COD'; -- Updated

-- Updating Values 'CC' as Credit card
UPDATE customer_churn
SET PreferredPaymentMode = 'Credit Card'
WHERE PreferredPaymentMode = 'CC'; -- Updated

-- Verifying the updation
SELECT PreferredPaymentMode, COUNT(*) AS Count FROM customer_churn
GROUP BY PreferredPaymentMode;
/* 
	Debit Card	        2312
	UPI	                414
	Credit Card	        1774
	Cash on Delivery	514
	E wallet	        614
*/

