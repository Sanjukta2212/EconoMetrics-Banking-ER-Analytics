-----------------------------------------------------------------------Customer Relationship Management------------------------------------------------------------------------------------------------------
-- • The customer entity can help in understanding customer demographics and personalizing banking services.
-- • Relationships such as SERVES between customer and branch can help in tracking which branch serves which customers, useful for targeted marketing and localized service improvements.
-- Find customer demographics for a targeted marketing campaign.
SELECT 
  ROUND(AVG(a.bank_balance),2) AS avg_bank_balance,
  c.occupation,
  s."employment_rate(%)" AS "state's_emp_rate",
  s."literacy_rate(%)" AS "state's_literacy_rate",
  s.branches_per_100000_residents,
  s.state,
  CASE
        WHEN s."children_0_to_18(%)" = GREATEST(s."children_0_to_18(%)", s."adults_19_to_25(%)", s."adults_26_to_34(%)", s."adults_35_to_54(%)", s."adults_55_to_64(%)", s."65+(%)")
            THEN 'Children 0-18'
        WHEN s."adults_19_to_25(%)" = GREATEST(s."children_0_to_18(%)", s."adults_19_to_25(%)", s."adults_26_to_34(%)", s."adults_35_to_54(%)", s."adults_55_to_64(%)", s."65+(%)")
            THEN 'Adults 19-25'
        WHEN s."adults_26_to_34(%)" = GREATEST(s."children_0_to_18(%)", s."adults_19_to_25(%)", s."adults_26_to_34(%)", s."adults_35_to_54(%)", s."adults_55_to_64(%)", s."65+(%)")
            THEN 'Adults 26-34'
        WHEN s."adults_35_to_54(%)" = GREATEST(s."children_0_to_18(%)", s."adults_19_to_25(%)", s."adults_26_to_34(%)", s."adults_35_to_54(%)", s."adults_55_to_64(%)", s."65+(%)")
            THEN 'Adults 35-54'
        WHEN s."adults_55_to_64(%)" = GREATEST(s."children_0_to_18(%)", s."adults_19_to_25(%)", s."adults_26_to_34(%)", s."adults_35_to_54(%)", s."65+(%)")
            THEN 'Adults 55-64'
        ELSE '65+'
    END AS max_age_group 
FROM account a
INNER JOIN customer c ON a.customer_id = c.customer_id
INNER JOIN branch b ON c.branch_id = b.branch_id
INNER JOIN statewise s ON b.state = s.state
GROUP BY c.occupation, s."employment_rate(%)", s."literacy_rate(%)", s.branches_per_100000_residents, s."children_0_to_18(%)",
    s."adults_19_to_25(%)",
    s."adults_26_to_34(%)",
    s."adults_35_to_54(%)",
    s."adults_55_to_64(%)",
    s."65+(%)",s.state
ORDER BY avg_bank_balance DESC
LIMIT 10;

-------------------------------------------------------------------------------Risk Assessment and Management---------------------------------------------------------------------------------------------
-- •By analyzing the data in loan and loan_type entities, the bank can assess the risk profile of its loan portfolio and make informed decisions to mitigate risks.
-- Analyze risk by finding the average loan amount for each type of loan.
SELECT 
    c.customer_id, 
    c.first_name || ' ' || c.last_name as full_name, 
    a.account_id, 
    l.loan_id, 
    (lt.base_amount - l.amount_paid) as due_amount,
    lt.loan_type
FROM 
    customer c
JOIN 
    account a ON c.customer_id = a.customer_id
JOIN 
    loan l ON a.account_id = l.account_id
JOIN 
    loan_type lt ON l.loan_type_id = lt.loan_type_id
WHERE 
    EXTRACT(YEAR FROM AGE(c.date_of_birth)) > 65
    AND l.due_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '10 years'
    AND (lt.base_amount - l.amount_paid) > (a.bank_balance / 2)
ORDER BY 
    due_amount DESC
LIMIT 10; 

-----------------------------------------------------------------------Transaction Tracking and Fraud Detection------------------------------------------------------------------------------------------------------
-- 
-- • The transaction entity is linked to account, which can help in monitoring transaction patterns and detecting anomalies that may indicate fraudulent activities.
-- • The ACH Network handled 31.5 billion transactions in the year 2023. The estimated population of the United States was 332 million people.
-- • Detect potential fraudulent transactions by identifying high-frequency transactions for any account.
SELECT 
    t.account_id, 
    COUNT(*) as transaction_count,
    SUM(t.transaction_amount) as total_amount,
    a.acc_start_date,
--     date_part('day', age(CURRENT_DATE, a.acc_start_date)) + 1 as days_account_open, -- Calculating the age in days
    COUNT(*) / (date_part('day', age(CURRENT_DATE, a.acc_start_date)) + 1) as avg_transactions_per_day
FROM 
    transaction t
JOIN 
    account a ON t.account_id = a.account_id
GROUP BY 
    t.account_id, a.acc_start_date
HAVING 
    COUNT(*) / (date_part('day', age(CURRENT_DATE, a.acc_start_date)) + 1) > 0.26
ORDER BY avg_transactions_per_day DESC;


---------------------------------------------------------------------------Account Management--------------------------------------------------------------------------------------------------
-- •Entities like account and card are crucial for managing customer accounts, tracking balances, and card details.
-- •The relationship ASSOCIATES_WITH between account and card can help in understanding how many cards are linked to a particular account, which is vital for managing credit/debit card services.
-- List all accounts with their linked cards and current balance.
SELECT a.account_id, a.bank_balance, c.card_number
FROM account a
LEFT JOIN card c ON a.card_id = c.card_id;

----------------------------------------------------------------------------Loan Management------------------------------------------------------------------------------------------------
-- •The loan and loan_type entities along with their attributes can be used to manage different types of loans, their disbursements, and repayments.
-- •It also helps in analyzing the types of loans that are popular and the performance of loan products.
-- Get details of all loans that are past the due date.
SELECT loan_id, account_id, due_date, amount_paid
FROM loan
WHERE due_date < CURRENT_DATE AND amount_paid < loan_amount;

-----------------------------------------------------------------------------Branch Performance------------------------------------------------------------------------------------------------
-- •The branch entity, along with its relationship with customer and account, can help in analyzing the performance of branches in different locations.
-- Calculate the total bank balance for each branch.
SELECT b.branch_id, b.name, SUM(a.bank_balance) as total_balance
FROM customer c
JOIN branch b ON b.branch_id = c.branch_id
JOIN account a ON a.customer_id = a.customer_id
GROUP BY b.branch_id, b.name
ORDER BY total_balance

-- INDEXING CAN BE USED
-----------------------------------------------------------------------------Strategic Planning and Analysis----------------------------------------------------------------------------------------------
-- •The statewise entity seems to contain demographic and economic data, which could be used for strategic planning, such as where to open new branches or which services to focus on in certain regions.
-- Determine which state has the highest literacy rate and the number of branches.
SELECT state, "literacy_rate(%)", bank_branches_in_2023
FROM statewise
ORDER BY "literacy_rate(%)" DESC
LIMIT 10;

------------------------------------------------------------------------------Compliance and Reporting----------------------------------------------------------------------------------------------
-- •The structured nature of this ER diagram ensures that all necessary data for regulatory compliance is captured and can be reported on as needed.
-- Generate a report of all accounts with transactions exceeding a certain limit for audit purposes.
SELECT a.account_id, t.transaction_amount, t.date
FROM account a
JOIN transaction t ON a.account_id = t.account_id
WHERE t.transaction_amount > (SELECT MAX(transaction_amount) * 0.80 FROM transaction);

--------------------------------------------------------------------------------Marketing and Sales---------------------------------------------------------------------------------------------
-- •The diagram allows for segmentation analysis (using customer demographics), product penetration analysis (using account, loan, and card data), and sales performance analysis by region (using data from branch and statewise entities).
-- Find the number of customers by branch and their average account balance for sales analysis.
SELECT b.branch_id, b.name, COUNT(c.customer_id) as customer_count, ROUND(AVG(a.bank_balance),2) as average_balance
FROM branch b
JOIN customer c ON b.branch_id = c.branch_id
JOIN account a ON c.customer_id = a.customer_id
GROUP BY b.branch_id, b.name;


























