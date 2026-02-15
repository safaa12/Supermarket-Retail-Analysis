
/*
Univariate analysis
1. Sales Total Histogram:
*/

SELECT
יצירת קבוצות -- (Bins) של 50 ש"ח כדי ליצור היסטוגרמה
FLOOR(total / 50) * 50 AS bin_start,
FLOOR(total / 50) * 50 + 49 AS bin_end,
COUNT(*) AS frequency
FROM
`bqproj-435911.Final_Project_2025.log_sales`
WHERE
total IS NOT NULL
GROUP BY
1, 2
ORDER BY
1;

------------------------------------------------------------------------------------

/*
	2. Payment Method Distribution: שאילתה לניתוח התפלגות אמצעי תשלום
('מטרה: הבנת העדפות התשלום של הלקוחות מזומן, אשראי, אפליקציה וכו )
*/
SELECT
payment_method,
ספירת כמות העסקאות לכל אמצעי תשלום --
COUNT(sale_id) AS transaction_count,
(חישוב סך ההכנסות לכל אמצעי תשלום אופציונלי, לבדיקת נפח כספי -- )
ROUND(SUM(total), 2) AS total_revenue,
חישוב האחוז היחסי מתוך סך כל העסקאות --
ROUND(
COUNT(sale_id) * 100.0 / SUM(COUNT(sale_id)) OVER(),2) AS percentage_of_transactions
FROM
`bqproj-435911.Final_Project_2025.log_sales`
GROUP BY
payment_method
ORDER BY
transaction_count DESC;

-------------------------------------------------------------------------------------

/*
3. Number of transactions per Hour:
לזיהוי שעות שיא ושעות שפל מבחינת עומס לקוחות–
*/
SELECT
EXTRACT(HOUR FROM timestamp) AS hour_of_day,
ROUND(AVG(total),2) AS avg_basket_size,
COUNT(*) AS number_of_transactions
FROM `bqproj-435911.Final_Project_2025.log_sales`
GROUP BY 1
ORDER BY 1;

--4. App users vs. No App users:
SELECT
CASE WHEN customer_id IS NULL THEN 'No App' ELSE 'Has App' END AS customer_type,
COUNT(*) AS total_transactions,
ROUND(AVG(total), 2) AS avg_basket_size -- ?האם משתמשי אפליקציה קונים יותר
FROM
`bqproj-435911.Final_Project_2025.log_sales`
GROUP BY
1;

-------------------------------------------------------------------------------------

-- 5. Accuracy classification:

SELECT
יצירת קבוצות -- (Bins) של רמת הדיוק
CASE
WHEN accuracy_m <= 10 THEN '0-10 Meters (Excellent)'
WHEN accuracy_m > 10 AND accuracy_m <= 20 THEN '10-20 Meters (Good)'
WHEN accuracy_m > 20 AND accuracy_m <= 30 THEN '20-30 Meters (Fair)'
ELSE 'Over 30 Meters (Outlier)' -- אלו החריגים שצריך לשים לב אליהם
END AS accuracy_range,
ספירת כמות השידורים בכל קבוצה --
COUNT(device_id) AS signal_count
FROM `bqproj-435911.Final_Project_2025.geolocation`
GROUP BY
accuracy_range
ORDER BY
signal_count DESC
