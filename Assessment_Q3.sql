-- Assessment_Q3.sql

-- Identify active savings or investment accounts that have had no inflow in the last 365 days

WITH latest_transactions AS (
    -- Get latest transaction date per savings account
    SELECT 
        s.plan_id,
        s.owner_id,
        MAX(s.transaction_date) AS last_transaction_date
    FROM 
        savings_savingsaccount s
    WHERE 
        s.confirmed_amount > 0
    GROUP BY 
        s.plan_id, s.owner_id
),

active_plans AS (
    -- Filter for active savings and investment plans
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS plan_type
    FROM 
        plans_plan p
    WHERE 
        p.is_regular_savings = 1 OR p.is_a_fund = 1
)

-- Final result: join plans with last transaction info and filter by inactivity
SELECT 
    ap.plan_id,
    ap.owner_id,
    ap.plan_type,
    lt.last_transaction_date,
    DATEDIFF(CURRENT_DATE, lt.last_transaction_date) AS inactivity_days
FROM 
    active_plans ap
JOIN 
    latest_transactions lt ON ap.plan_id = lt.plan_id
WHERE 
    DATEDIFF(CURRENT_DATE, lt.last_transaction_date) > 365
ORDER BY 
    inactivity_days DESC;
