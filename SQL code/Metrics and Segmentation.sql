
-- Metrics & Segmentation
-- 2.1 Mapping Customers (Logic based on logic description)
WITH SalesStats AS (
SELECT
customer_id,
COUNT(DISTINCT sale_id) AS purchase_count,
MIN(timestamp) AS first_purchase,
MAX(timestamp) AS last_purchase,
חישוב הטווח בימים בין הקניה הראשונה לאחרונה --
TIMESTAMP_DIFF(MAX(timestamp), MIN(timestamp), DAY) AS total_days_span
FROM
`bqproj-435911.Final_Project_2025.log_sales`
GROUP BY
customer_id
),
GeoStats AS (
SELECT DISTINCT device_id
FROM `bqproj-435911.Final_Project_2025.geolocation`
WHERE role IN ('repeat_customer','one_time_customer','not_paying','no_phone')
)
SELECT
COALESCE(s.customer_id, g.device_id) AS client_id,
CASE
-- לקוח ששילם אך ללא אפליקציה . 1
WHEN s.customer_id IS NULL AND g.device_id IS NULL THEN 'no_phone'
-- מבקר שלא שילם . 2
WHEN g.device_id IS NOT NULL AND s.customer_id IS NULL THEN 'not_paying'
 -- לקוח חוזר "אמיתי" לפחות 2 קניות + ממוצע של עד 14 יום בין קניות . 3
-- (הנוסחה: סהכ ימים חלקי מספר קניות פחות 1 נותן את המרווח הממוצע)
WHEN s.purchase_count > 1
AND SAFE_DIVIDE(s.total_days_span, (s.purchase_count - 1)) <= 14 THEN 'repeat_customer'
-- כל השאר: קנו פעם אחת, או שקנו לעיתים רחוקות מעל 14 יום בממוצע . 4
ELSE 'one_time_customer'
END AS customer_segment,

עמודות עזר לבדיקה -- (Debug)
s.purchase_count,
ROUND(SAFE_DIVIDE(s.total_days_span, (s.purchase_count - 1)), 1) AS avg_days_between_visits
FROM
SalesStats s
FULL OUTER JOIN
GeoStats g
ON
s.customer_id = g.device_id


----------------------------------------------------------------------

-- ליותר מידע עבור לקוחות אחרי הסיגמנטציה
WITH SalesStats AS (
SELECT    
,customer_id       
,COUNT(DISTINCT sale_id) AS purchase_count       
,sum(total) total_sum       
,MIN(timestamp) AS first_purchase       
,MAX(timestamp) AS last_purchase       
חישוב הטווח בימים בין הקניה הראשונה לאחרונה    
TIMESTAMP_DIFF(MAX(timestamp), MIN(timestamp), DAY) AS total_days_span FROM    
`bqproj-435911.Final_Project_2025.log_sales`       
GROUP BY customer_id),

GeoStats AS (
SELECT DISTINCT device_id    
`FROM `bqproj-435911.Final_Project_2025.geolocation 
WHERE role IN ('repeat_customer','one_time_customer','not_paying','no_phone')customer_table as
SELECT
,COALESCE(s.customer_id, g.device_id) AS client_id    
CASE    
-- לקוח ששילם אך ללא אפליקציה .1       
WHEN s.customer_id IS NULL AND g.device_id IS NULL THEN 'no_phone'

--מבקר שלא שילם .2        
WHEN g.device_id IS NOT NULL AND s.customer_id IS NULL THEN 'not_paying'

--.3  לקוח חוזר 'אמיתי' = לפחות 2 קניות+ ממוצע של עד 14 ימים בין הקניות  
-- הנוסחה: סה"כ ימים חלקי (מספר קניות פחות 1) נותן את המרווח הממוצע  
WHEN s.purchase_count > 1       
 AND SAFE_DIVIDE(s.total_days_span, (s.purchase_count - 1)) <= 14 THEN 'repeat_customer'