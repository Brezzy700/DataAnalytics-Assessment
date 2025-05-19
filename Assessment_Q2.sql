-- Assessment_Q2.sql

-- Analyze customer transaction frequency and classify them as:
-- - High Frequency (≥10 transactions/month)
-- - Medium Frequency (3–9 transactions/month)
-- - Low Frequency (≤2 transactions/month)

WITH customer_activity AS (
    -- Calculate transaction span and total transactions per user
    SELECT
        s.owner_id,
        COUNT(*) AS total_transactions,
        GREATEST(
            TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)), 1
        ) AS active_months
    FROM 
        savings_savingsaccount s
    GROUP BY 
        s.owner_id
),

classified_customers AS (
    -- Compute average transactions per month and classify frequency
    SELECT
        ca.owner_id,
        ca.total_transactions,
        ca.active_months,
        ROUND(ca.total_transactions / ca.active_months, 2) AS avg_txn_per_month,
        CASE 
            WHEN ca.total_transactions / ca.active_months >= 10 THEN 'High Frequency'
            WHEN ca.total_transactions / ca.active_months BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM 
        customer_activity ca
)

-- Final aggregation: group customers by category
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
FROM 
    classified_customers
GROUP BY 
    frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
