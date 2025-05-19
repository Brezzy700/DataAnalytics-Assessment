# DataAnalytics-Assessment

## 🔍 Solution Explanations by Question

### ✅ Question 1: Identifying Cross-Selling Opportunities

**Goal:**  
Detect customers who own both a savings and an investment product, and rank them based on the total value of deposits.

**Strategy:**
- Merged data from `users_customuser`, `savings_savingsaccount`, and `plans_plan` via the `owner_id` field.
- Filtered transactions where `transaction_status = 'success'` to ensure only completed savings deposits were included.
- Selected investment-related plans using `plan_type_id = 2` and checked that they were funded with `status_id = 1`.
- Counted distinct savings and investment plans per customer.
- Aggregated deposit values (from both savings and investment plans), converting from Kobo to Naira using division by 100.
- Ensured customers qualified for both product types using a `HAVING` clause.
- Results were sorted in descending order of total deposits to highlight high-value customers.

---

### ✅ Question 2: Customer Segmentation by Transaction Frequency

**Goal:**  
Classify users into frequency bands (High, Medium, Low) based on their monthly transaction averages.

**Strategy:**
- Counted total savings transactions for each user from the `savings_savingsaccount` table.
- Computed transaction span in months using the earliest and latest transaction dates.
- Derived average monthly transaction frequency.
- Applied a `CASE` expression to assign frequency categories based on thresholds:
  - High (≥10/month), Medium (3–9/month), Low (≤2/month)
- Aggregated results by frequency category to count users and calculate average transaction volume.

---

### ✅ Question 3: Flagging Dormant Accounts

**Goal:**  
Identify active plans (savings or investment) that haven’t received any deposits in over a year (365+ days).

**Strategy:**
- Queried latest `transaction_date` per savings account.
- Identified active plans from `plans_plan` based on boolean flags: `is_regular_savings = 1` or `is_a_fund = 1`.
- Used `DATEDIFF` to calculate inactivity in days since the last transaction.
- Filtered out accounts with more than 365 days of inactivity.
- Presented output showing plan type, user ID, date of last deposit, and the number of inactive days.

---

### ✅ Question 4: Estimating Customer Lifetime Value (CLV)

**Goal:**  
Estimate a customer’s CLV based on their account duration and transaction behavior.

**Strategy:**
- Calculated how long each customer has had their account (`tenure_months`) using `TIMESTAMPDIFF`.
- Counted all valid transactions (`confirmed_amount > 0`) from savings accounts.
- Estimated average profit per transaction as 0.1% of the average transaction value.
- Used a formula to estimate CLV:
  \[
  CLV = \left(\frac{\text{total\_transactions}}{\text{tenure\_months}} \right) \times 12 \times \text{avg\_profit\_per\_transaction}
  \]
- Protected against division by zero using `GREATEST` and `COALESCE`.
- Sorted results in descending order to prioritize the most valuable customers.

---

## 🚧 Encountered Issues and Solutions

1. **Incorrect Status Filtering in Transactions**  
   Initially assumed savings transaction statuses included `'funded'`, but found the correct value to be `'success'`.  
   Resolved by querying `DISTINCT transaction_status` values from the database.

2. **Mismatch in Data Type for plan_type and status**  
   Originally filtered by `'investment'` and `'funded'` as string values.  
   Realized these columns used numeric foreign keys. Corrected the logic by first inspecting available values via `SELECT DISTINCT`.

3. **Empty Results Due to Filtering**  
   Some queries returned NULL or no rows due to mis
