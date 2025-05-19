-- Assessment_Q4.sql

-- Estimate customer Lifetime Value (CLV) based on tenure and transaction behavior
-- Formula:
-- CLV = (total_transactions / tenure_months) * 12 * average_profit_per_transaction
-- where avg_profit_per_transaction = 0.001 * average transaction amount

SELECT 
    u.id AS customer_id,
    u.name,

    -- Account tenure in months since sign-up
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) AS tenure_months,

    -- Total number of successful deposit transactions
    COUNT(s.id) AS total_transactions,

    -- CLV = (txns / tenure) * 12 * (0.1% of avg transaction value)
    ROUND(
        (COUNT(s.id) / 
        GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()), 1)) * 
        12 * 
        (0.001 * COALESCE(SUM(s.confirmed_amount), 0) / GREATEST(COUNT(s.id), 1)),
        2
    ) AS estimated_clv

FROM 
    users_customuser u

LEFT JOIN 
    savings_savingsaccount s 
    ON u.id = s.owner_id AND s.confirmed_amount > 0

GROUP BY 
    u.id, u.name, u.date_joined

-- Exclude users with 0-month tenure
HAVING 
    tenure_months > 0

ORDER BY 
    estimated_clv DESC;
