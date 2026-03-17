-- ----------------------------------- OBJECTIVE QUESTIONS -------------------------------------

-- 1. What is the distribution of account balances across different regions? (Visual answer in DOC  ) 
SELECT 
    g.geographylocation AS Region,
    COUNT(bc.customerid) AS Total_Customers,
    SUM(bc.balance) AS Total_Balance,
    AVG(bc.balance) AS Average_Balance
FROM bank_churn bc
JOIN customerinfo_sql ci ON bc.customerid = ci.customerid
JOIN geography g
ON ci.geographyid = g.geographyid
GROUP BY g.geographylocation
ORDER BY Total_Balance DESC;


-- 2.	Identify the top 5 customers with the highest Estimated Salary in the last quarter of the year. (SQL)
SELECT 
    CustomerId, Surname, EstimatedSalary, Bank_DOJ
FROM customerinfo_sql
WHERE MONTH(Bank_DOJ) IN (10, 11, 12)
ORDER BY EstimatedSalary DESC
LIMIT 5;

-- 3.	Calculate the average number of products used by customers who have a credit card;

select avg(NumofProducts) as Avg_numof_products
from bank_churn
where HasCrCard = 1;

-- Question 4. Determine the churn rate by gender for the most recent year in the dataset.

SELECT 
    g.gendercategory AS Gender,
    COUNT(bc.customerid) AS Total_Customers,
    SUM(bc.exited) AS Churned_Customers,
    (SUM(bc.exited) / COUNT(bc.customerid)) * 100 AS Churn_Rate_Percentage
FROM bank_churn bc
JOIN customerinfo_sql ci
ON bc.customerid = ci.customerid
JOIN gender g
ON ci.genderid = g.genderid
WHERE YEAR(ci.bank_doj) = (SELECT MAX(YEAR(bank_doj)) FROM customerinfo_sql)
GROUP BY g.gendercategory;

-- 5.	Compare the average credit score of customers who have exited and those who remain.

select ec.ExitCategory, avg(bc.CreditScore) as Avg_Creditscore
from bank_churn bc
join exitcustomer ec on bc.exited=ec.exitId 
group by ec.ExitCategory;

-- 6.Which gender has a higher average estimated salary, and how does it relate to the number of active accounts?

SELECT 
    g.gendercategory AS Gender,
    AVG(ci.estimatedsalary) AS Average_Salary,
    SUM(CASE WHEN bc.isactivemember = 1 THEN 1 ELSE 0 END) AS Active_Accounts,
    COUNT(ci.customerid) AS Total_Accounts,
    (SUM(CASE WHEN bc.isactivemember = 1 THEN 1 ELSE 0 END) /COUNT(ci.customerid)) * 100 AS Activity_Rate_Percentage
FROM customerinfo_sql ci
JOIN gender g ON ci.genderid = g.genderid
JOIN bank_churn bc ON ci.customerid = bc.customerid
GROUP BY g.gendercategory;

-- 7.	Segment the customers based on their credit score and identify the segment with the highest exit rate;
SELECT 
    CASE 
        WHEN creditscore < 400 THEN 'Very Poor'
        WHEN creditscore BETWEEN 400 AND 599 THEN 'Poor'
        WHEN creditscore BETWEEN 600 AND 699 THEN 'Fair'
        WHEN creditscore BETWEEN 700 AND 799 THEN 'Good'
        ELSE 'Excellent' 
    END AS Credit_Segment,
    COUNT(customerid) AS Total_Customers,
    SUM(exited) AS Churned_Customers,
    (SUM(exited) / COUNT(customerid)) * 100 AS Exit_Rate_Percentage
FROM bank_churn
GROUP BY Credit_Segment
ORDER BY Exit_Rate_Percentage DESC;

-- 8.Find out which geographic region has the highest number of active customers with a tenure greater than 5 years.

select g.GeographyLocation, count(b.CustomerId) as Active_Customers
from geography g
join customerinfo c on g.geographyid = c.geographyid
join bank_churn b on c.customerid = b.customerid
where b.tenure > 5 and b.IsActiveMember=1
group by g.geographylocation
order by active_customers desc
limit 1;

-- 9. What is the impact of having a credit card on customer churn, based on the available data?
SELECT 
    cc.category AS Credit_Card_Status,
    COUNT(bc.customerid) AS Total_Customers,
    SUM(bc.exited) AS Churned_Customers,
    CAST((SUM(bc.exited) / COUNT(bc.customerid)) * 100 AS DECIMAL(10,2)) AS Churn_Rate_Percentage
FROM bank_churn bc
JOIN credit_card cc
ON bc.hascrcard = cc.creditid
GROUP BY cc.category;

-- Question 10. For customers who have exited, what is the most common number of products they had used?

Select NumOfProducts,COUNT(*) as ExitedCount
from Bank_Churn 
where Exited = 1
group by NumOfProducts
order by ExitedCount desc;

-- Question 11. Examine the trend of customer joining over time and identify any seasonal patterns (yearly or monthly). Prepare the data through SQL and then visualize it.

SELECT 							-- Yearly Trend
    YEAR(bank_doj) AS Join_Year,
    COUNT(customerid) AS New_Customers
FROM customerinfo_sql
GROUP BY YEAR(bank_doj)
ORDER BY Join_Year;
SELECT 							-- Monthly Seasonality
    MONTH(bank_doj) AS Join_Month,
    COUNT(customerid) AS New_Customers
FROM customerinfo_sql
GROUP BY MONTH(bank_doj)
ORDER BY Join_Month;

-- 12.Analyze the relationship between the number of products and the account balance for customers who have exited.

SELECT 
    numofproducts,
    COUNT(customerid) AS Total_Exited_Customers,
    ROUND(AVG(balance),2) AS Average_Balance
FROM bank_churn
WHERE exited = 1
GROUP BY numofproducts
ORDER BY numofproducts;

-- 13.Identify any potential outliers in terms of balance among customers who have remained with the bank.

SELECT 
    MIN(balance) AS Min_Balance,
    MAX(balance) AS Max_Balance,
    AVG(balance) AS Average_Balance,
    STDDEV(balance) AS Std_Deviation
FROM bank_churn
WHERE exited = 0;

-- 14.How many different tables are given in the dataset, out of these tables which table only consists of categorical variables?(Answered in DOC file)

-- 15.	 Using SQL, write a query to find out the gender-wise average income of males and females in each geography id. 

SELECT 
    ci.geographyid,
    g.gendercategory AS Gender,
    AVG(ci.estimatedsalary) AS Average_Income,
    RANK() OVER (PARTITION BY ci.geographyid ORDER BY AVG(ci.estimatedsalary) DESC
    ) AS Income_Rank
FROM customerinfo_sql ci
JOIN gender g ON ci.genderid = g.genderid
GROUP BY ci.geographyid,g.gendercategory;

-- 16.	Using SQL, write a query to find out the average tenure of the people who have exited in each age bracket (18-30, 30-50, 50+).

Select
	case
		when age between 18 and 30 then 'Adults (18-30)'
		when age between 31 and 50 then 'Middle-aged (30-50)'
		else 'Old-aged (50+)' 
	end as Age_brackets,
	avg(b.tenure) as Avg_tenure
from customerinfo_sql c
join bank_churn b on c.customerid = b.customerid
where b.exited = 1
group by Age_brackets
order by Age_brackets;

-- 17. Is there any direct correlation between salary and the balance of the customers? And is it different for people who have exited or not?(Answered in DOC file)

SELECT 
    CASE
		WHEN bc.exited = 1 THEN 'Exited' ELSE 'Retained'
	END AS Customer_Status,
    COUNT(*) AS Sample_Size,
    ROUND(
        (AVG(bc.balance * ci.estimatedsalary) - (AVG(bc.balance) *
         AVG(ci.estimatedsalary))) / 
        (STDDEV(bc.balance) * STDDEV(ci.estimatedsalary)), 4) AS Correlation_Coefficient
FROM bank_churn bc
JOIN customerinfo_sql ci ON bc.customerid = ci.customerid
GROUP BY bc.exited;

-- 18. Is there any correlation between the salary and the Credit score of customers?

SELECT 
    ROUND(
        (AVG(bc.creditscore * ci.estimatedsalary) - (AVG(bc.creditscore) *
         AVG(ci.estimatedsalary))) / 
        (STDDEV(bc.creditscore) * STDDEV(ci.estimatedsalary)), 4) AS Salary_CreditScore_Correlation
FROM bank_churn bc
JOIN customerinfo_sql ci ON bc.customerid = ci.customerid;


-- 19.	Rank each bucket of credit score as per the number of customers who have churned the bank.

SELECT 
    CASE 
        WHEN creditscore < 500 THEN 'Very Poor'
        WHEN creditscore BETWEEN 500 AND 600 THEN 'Poor'
        WHEN creditscore BETWEEN 601 AND 700 THEN 'Fair'
        WHEN creditscore BETWEEN 701 AND 800 THEN 'Good'
        WHEN creditscore > 800 THEN 'Excellent'
    END AS Credit_Score_Bucket,
    COUNT(customerid) AS Churned_Customers,
    RANK() OVER (ORDER BY COUNT(customerid) DESC) AS Churn_Rank
FROM bank_churn
WHERE exited = 1
GROUP BY Credit_Score_Bucket;

-- 20.According to the age buckets find the number of customers who have a credit card.Also retrieve those buckets that have lesser than average number of credit cards per bucket.

with creditinfo as (
select 
	case
		when age between 18 and 30 then 'Adult (18-30)'
		when age between 31 and 50 then 'Middle-aged (31-50)'
		else 'Old-aged (50+)' end as agebrackets,
	count(c.customerid) as CrCard_holders
from customerinfo_sql c
join bank_churn b on c.customerid = b.customerid
where b.hascrcard = 1  
group by agebrackets
)
select *
from creditinfo
where CrCard_holders < (Select avg(CrCard_holders) from creditinfo);

--  21.Rank the Locations as per the number of people who have churned the bank and average balance of the customers.

SELECT 
    g.geographylocation,
    COUNT(CASE WHEN bc.exited = 1 THEN 1 END) AS Churned_Count,
    RANK() OVER (ORDER BY COUNT(CASE WHEN bc.exited = 1 THEN 1 END) DESC) AS Churn_Rank,
    ROUND(AVG(bc.balance), 2) AS Average_Balance,
    RANK() OVER (ORDER BY AVG(bc.balance) DESC) AS Balance_Rank
FROM bank_churn bc
JOIN customerinfo_sql ci ON bc.customerid = ci.customerid
JOIN geography g ON ci.geographyid = g.geographyid
GROUP BY g.geographylocation
ORDER BY g.geographylocation;

-- 23.	Without using “Join”, can we get the “ExitCategory” from ExitCustomers table to Bank_Churn table? If yes do this using SQL.

SELECT 
    bc.customerid,
    bc.creditscore,
    bc.balance,
    bc.exited,
    ec.exitcategory
FROM 
    bank_churn bc, 
    exit_customer ec
WHERE bc.exited = ec.exitid;

-- 24. Were there any missing values in the data, using which tool did you replace them and what are the ways to handle them?(Answered in DOC)

-- 25.	Write the query to get the customer IDs, their last name, and whether they are active  or not for the customers whose surname ends with “on”;

Select 
	c.CustomerId,
	c.Surname as Last_name,  
    case
		when b.isactivemember = 1 then 'active' 
		else 'inactive'
	end as active_status
from customerinfo_sql c
join bank_churn b on c.customerid = b.customerid
where c.surname like '%on'
order by c.surname;

-- 26.	Can you observe any data disrupency in the Customer’s data? As a hint it’s present in the IsActiveMember and Exited columns.
-- One more point to consider is that the data in the Exited Column is absolutely correct and accurate.

SELECT 
    COUNT(*) AS Discrepant_Records
FROM 
    bank_churn
WHERE 
    exited = 1 
    AND isactivemember = 1;

-- ----------------------------------------------------------- SUBJECTIVE QUESTIONS ------------------------------------------------------------------------------------------


-- 9.	Utilize SQL queries to segment customers based on demographics and account details.

-- 9.	Utilize SQL queries to segment customers based on demographics and account details.

-- Geographic and Activity Segmentation
SELECT 
    g.geographylocation AS Region,
    ac.activecategory AS Activity_Status,
    COUNT(ci.customerid) AS Customer_Count,
    ROUND(AVG(bc.balance), 2) AS Average_Balance
FROM customerinfo_sql ci
JOIN geography g ON ci.geographyid = g.geographyid
JOIN bank_churn bc ON ci.customerid = bc.customerid
JOIN active_customer ac ON bc.isactivemember = ac.activeid
GROUP BY g.geographylocation, ac.activecategory;

-- Age Demographics and Product Usage
SELECT 
    CASE 
        WHEN ci.age < 30 THEN 'Young Adult (Under 30)'
        WHEN ci.age BETWEEN 30 AND 50 THEN 'Adult (30-50)'
        ELSE 'Senior (50+)'
    END AS Age_Group,
    bc.numofproducts AS Products_Held,
    COUNT(*) AS Total_Customers
FROM customerinfo_sql ci
JOIN bank_churn bc ON ci.customerid = bc.customerid
GROUP BY Age_Group, bc.numofproducts
ORDER BY Age_Group, bc.numofproducts;

-- Financial Profile Segmentation (Credit Score & Balance)
SELECT 
    CASE 
        WHEN bc.creditscore >= 800 THEN 'Excellent'
        WHEN bc.creditscore >= 740 THEN 'Very Good'
        WHEN bc.creditscore >= 670 THEN 'Good'
        WHEN bc.creditscore >= 580 THEN 'Fair'
        ELSE 'Poor'
    END AS Credit_Tier,
    COUNT(*) AS Customer_Count,ROUND(AVG(bc.balance), 2) AS Avg_Balance,ROUND(AVG(ci.estimatedsalary), 2) AS Avg_Salary
FROM bank_churn bc
JOIN customerinfo_sql ci ON bc.customerid = ci.customerid
GROUP BY Credit_Tier
ORDER BY Avg_Balance DESC;


-- Q11) What is the current churn rate per year and overall as well in the bank? Can you suggest some insights to the bank about which kind of customers are more 
-- likely to churn and what different strategies can be used to decrease the churn rate?

SELECT 
    YEAR(ci.bank_doj) AS Join_Year,
    COUNT(bc.customerid) AS Total_Customers,
    SUM(bc.exited) AS Exited_Customers,
    ROUND(AVG(bc.exited) * 100, 2) AS Churn_Rate
FROM bank_churn bc
JOIN customerinfo_sql ci ON bc.customerid = ci.customerid
GROUP BY Join_Year
ORDER BY Join_Year DESC;


-- Q14) In the “Bank_Churn” table how can you modify the name of the “HasCrCard” column to “Has_creditcard”.

ALTER TABLE bank_churn 
RENAME COLUMN HasCrCard TO Has_creditcard;


























