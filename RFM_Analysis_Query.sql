select top 10 * from Project..sales_data_sample;

--Unique values 

SELECT DISTINCT status FROM Project..sales_data_sample;
SELECT DISTINCT year_id FROM Project..sales_data_sample;
SELECT DISTINCT productline FROM Project..sales_data_sample;
SELECT DISTINCT country FROM Project..sales_data_sample;
SELECT DISTINCT dealsize FROM Project..sales_data_sample;
SELECT DISTINCT territory FROM Project..sales_data_sample;

SELECT DISTINCT month_id FROM Project..sales_data_sample
WHERE year_id=2003;

--Analysis

--grouping sales by productline

SELECT productline,SUM(sales) AS Revenue
FROM Project..sales_data_sample
GROUP BY productline
ORDER BY Revenue DESC;

--grouping sales by year_id

SELECT year_id,SUM(sales) AS Revenue
FROM Project..sales_data_sample
GROUP BY year_id
ORDER BY Revenue DESC;

--grouping sales by deal size

SELECT dealsize,SUM(sales) AS Revenue 
FROM Project..sales_data_sample
GROUP BY dealsize
ORDER BY Revenue DESC;

--What was the best month for sales in a specific year? How much was earned that month? 

SELECT month_id,SUM(sales) AS Revenue,COUNT(ordernumber) AS Frequency
FROM Project..sales_data_sample
WHERE year_id=2005
GROUP BY month_id
ORDER BY Revenue DESC; 

--What product best sold in a specific month of a year? 

SELECT month_id,productline,SUM(sales) AS Revenue,COUNT(ordernumber) AS Frequency
FROM Project..sales_data_sample
WHERE year_id=2003 AND month_id = 11
GROUP BY month_id,productline
ORDER BY Revenue DESC;

-- Top Segments  

DROP TABLE IF EXISTS rfm;
WITH rfm AS
(
	SELECT 
		customername, 
		SUM(sales) MonetaryValue,
		AVG(sales) AvgMonetaryValue,
		COUNT(ordernumber) Frequency,
		MAX(orderdate) last_order_date,
		(SELECT MAX(orderdate) FROM Project..sales_data_sample) max_order_date,
		DATEDIFF(DD, MAX(orderdate),(SELECT MAX(orderdate) FROM Project..sales_data_sample)) Recency
	FROM Project..sales_data_sample
	GROUP BY customername 
),
rfm_calc AS
(
	SELECT 
		r.*,
	    NTILE(4) OVER (ORDER BY Recency DESC) rfm_recency,
	    NTILE(4) OVER (ORDER BY Frequency) rfm_frequency,
		NTILE(4) OVER (ORDER BY MonetaryValue) rfm_monetary
	FROM rfm r
)
    SELECT 
		c.*, rfm_recency+rfm_frequency+rfm_monetary AS rfm_cell,
		CAST(rfm_recency AS VARCHAR)+CAST(rfm_frequency AS VARCHAR)+CAST(rfm_monetary AS VARCHAR) rfm_cell_string
	INTO rfm
	FROM rfm_calc c;

WITH segments AS (
SELECT customername, rfm_recency, rfm_frequency, rfm_monetary,rfm_cell_string,MonetaryValue,
	CASE 
		WHEN rfm_cell_string in (111, 112, 121, 122, 123, 132, 211, 212, 114, 141, 221) THEN 'lost customers'
		WHEN rfm_cell_string in (133, 134, 143, 144, 222, 223, 233, 232, 243) THEN 'potential churners' 
		WHEN rfm_cell_string in (311, 411, 331, 312, 412) THEN 'new customers'
		WHEN rfm_cell_string in (244, 323, 322, 333, 321, 422, 332, 432, 423) THEN 'active loyal customers' 
		WHEN rfm_cell_string in (334, 343, 344, 433, 434, 443, 444) THEN 'best customers' 
	END rfm_segment
FROM rfm 
),
revenue_cont as(
SELECT s.rfm_segment,COUNT(r.CUSTOMERNAME) AS cust_count,SUM(r.MonetaryValue) AS Revenue_contribution
FROM segments s join rfm r 
ON s.CUSTOMERNAME = r.CUSTOMERNAME
GROUP BY s.rfm_segment
--ORDER BY Revenue_contribution DESC
)
SELECT rfm_segment,CAST(ROUND(cust_count*100.0/(select sum(cust_count) from revenue_cont),2) AS DECIMAL(10,2)) as cust_percentage
FROM revenue_cont
GROUP BY rfm_segment,cust_count
ORDER BY cust_percentage DESC;


--What products are most often sold together?

SELECT 
	DISTINCT ordernumber, 
	STUFF((SELECT ',' + productcode
		   FROM Project..sales_data_sample p
           WHERE ordernumber in
			(
			 SELECT ordernumber
			 FROM (
				SELECT ordernumber, COUNT(*) AS rn
				FROM Project..sales_data_sample
				WHERE [status] = 'shipped'
				GROUP BY ordernumber
				) m
			WHERE rn = 3
			)
		   AND p.ordernumber = s.ordernumber
	       FOR XML PATH('')),1,1,'') ProductCodes
FROM Project..sales_data_sample s
ORDER BY 2 DESC