

-- Bivariate Analysis

-- 1. Sales vs Hour of Day
SELECT
EXTRACT(HOUR FROM timestamp) AS hour_of_day,
AVG(total) AS avg_basket_size,
COUNT(*) AS number_of_transactions
FROM `bqproj-435911.Final_Project_2025.log_sales`
GROUP BY 1
ORDER BY 1;


--------------------------------------------------------


-- 2. Average Basket Size by Day of Week
SELECT
-- Extract day name (e.g., Sunday, Monday)
FORMAT_DATE('%A', timestamp) as day_name,
-- Sorting index to ensure days order correctly in graph (Sun=1, Mon=2...)
EXTRACT(DAYOFWEEK FROM timestamp) as day_index,
-- Calculate Average Basket Size
ROUND(AVG(total), 2) as avg_basket_size,
-- Optional: Count transactions to see volume vs value context
COUNT(*) as transaction_count
FROM `bqproj-435911.Final_Project_2025.log_sales`
GROUP BY 1, 2
ORDER BY day_index;

--------------------------------------------------------

-- 3. Average Basket by dwell_minuts

SELECT
dwell_minutes AS x_dwell_time,
round(AVG(total),2) AS y_purchase_amount
FROM
`bqproj-435911.Final_Project_2025.log_sales`
WHERE
(סינון לקוחות ללא אפליקציה שאין להם זמן שהייה -- )
dwell_minutes IS NOT NULL
AND dwell_minutes > 0
AND total > 0 -- סינון עסקאות אפס אם יש
group by 1
ORDER BY
dwell_minutes;


--------------------------------------------------------


-- 4. Average Basket Size by Payment Method

select
payment_method,
round(avg(total),2) as avg_total
from `bqproj-435911.Final_Project_2025.log_sales`
group by 1
order by 2 desc