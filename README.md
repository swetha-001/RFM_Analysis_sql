# RFM Analysis of Sales Data in SQL
In this project, a sales dataset of a company that sells scale models was explored, and customer segmentation analysis was conducted using SQL and Tableau. The analysis provided insights into various aspects of the sales data, such as sales by product line, sales by year, sales by deal size, the best month for sales per year, and product line sales in the best month. Additionally, RFM (Recency, Frequency, Monetary) analysis was applied to segment customers based on their past purchase behavior.

# Resources Needed
The project required the following resources:

a. Data: A sales dataset from kaggle was utilized, with the file provided in the project repository.

b. Tableau: Tableau Public was installed to facilitate visualization and dashboard creation.

c. SQL: MS SQL Server 2019 was used to analyze the dataset.

The CSV file was downloaded from a GitHub repository and imported into SQL Server using the database engine's import task. The imported data was inspected to understand its structure and contents. Distinct searches were performed on various data points, including order number, ordered price, sales order date, and status.

# Analysis

1. Sales by Product Line -
The sales data was grouped by product line, and aggregate functions were computed to determine the product that generated the highest revenue.

2. Sales by Year -
The sales data was analyzed by year to identify the year with the highest sales. The investigation also aimed to determine if lower sales in a specific year were due to the company operating for only a partial year.

3. Sales by Deal Size -
The sales data was examined based on different deal sizes to identify the deal size that generated the most revenue.

4. Best Month for Sales per Year -
The best sales month for each year was determined by comparing the revenue generated in different months. This analysis provided insights into the most successful month for sales.

5. What Product Line Sells Most in Best Month -
By considering the best sales month, the product line with the highest sales was identified. Furthermore, an analysis of the best-selling product line across different years was conducted.

# RFM Explanation
RFM (Recency, Frequency, Monetary) analysis was conducted, to segment customers based on past purchase behavior into categories such as lost, potential churners, new, active loyal and best customers.

## Top performing segments
* RFM values were calculated for each customer based on their recency, frequency, and monetary value to identify the best customer. 
* Customers were then grouped into four buckets based on their RFM values, and categorized.
* `Potential churners`, `best customers` and `active loyal customers` were identified as top 3 revenue driving segments.
* `22.83%` of customers are at the risk of churn.

## Recommendations


## What Product Codes Sell Together
* Subqueries and String aggregation(using XML path) were employed to determine which products were frequently sold together. 
* The product codes of orders with multiple items were analyzed to identify patterns of products sold together.

# [Tableau Visualization](https://public.tableau.com/app/profile/swetha.mandela/viz/RFMAnalysisDashboard1_17451688894100/RFMAnalysisDashboard1)
* Multiple worksheets were created to depict different aspects of the data, including sales distribution, deal size distribution, sales by year, revenue by country, and sales by product line. 
* An Interactive dashboard was developed by combining these worksheets and customizing their appearance to support data-driven decision-making and stakeholder reporting.
   
![rfm_analysis_dashboard1](https://github.com/user-attachments/assets/0ed73d79-cbe1-4d28-b0b2-d1ec4cedf16b)
![rfm_analysis_dashboard2](https://github.com/user-attachments/assets/77991036-102b-493f-83c4-baa0b0a0eb42)


