# Monthly-Recurring-Revenue-MRR-Analytics-Engine

1. Project Title

Monthly Recurring Revenue (MRR) Analytics Engine

2. Problem Statement

Subscription businesses generate revenue through recurring plans, but raw event logs (subscriptions, upgrades, cancellations) do not directly provide monthly revenue insights.

This project builds a SQL-based analytics engine that:

Reconstructs subscription state over time
Calculates monthly recurring revenue (MRR)
Tracks revenue movements such as churn, expansion, and reactivation

3. Dataset Description
Base Tables
users → list of users
subscription_events → raw event logs (start, upgrade, cancel, reactivate)
plan_dim → plan details with monthly price
dim_month → calendar table with monthly grain
Derived Tables
subscription_periods → continuous subscription intervals built using LEAD()
monthly_mrr → user-level MRR at month-end
mrr_with_prev → MRR with previous and historical values for movement calculation

4. Data Model
subscription_events
        ↓
subscription_periods
        ↓
user_month grid (users × months)
        ↓
monthly_mrr
        ↓
mrr_with_prev
        ↓
movement classification

6. Approach

This project uses a month-end snapshot approach:

Convert events → subscription periods using LEAD()
Use half-open intervals [start_date, end_date)
Evaluate subscription state at month_end
Generate full timeline using users × months
Fill missing months with 0 MRR
Compute movement using LAG() and window functions

6. Key SQL Concepts Used
Window functions: LEAD(), LAG(), MAX()
Partitioning (PARTITION BY)
Window frames (ROWS BETWEEN UNBOUNDED PRECEDING)
LEFT JOIN vs INNER JOIN
COALESCE for handling NULL values
CTE-based modular query design

8. Metrics Explained
New MRR → First-time subscription
Reactivation MRR → Subscription after churn
Churn MRR → Active → inactive
Expansion MRR → Upgrade to higher plan
Contraction MRR → Downgrade to lower plan
No Movement → No change in MRR

10. Sample Output
user_id	month_start	MRR	previous	movement	type
2	      2024-03-01	0	  15	      -15	      Churn
2	      2024-06-01	15	0	        +15	      Reactivation
1	      2024-03-01	35	15	      +20	      Expansion

(Full output available in project)

9. How to Run
Create base tables:
users
subscription_events
plan_dim
dim_month
Run SQL files in order:
build subscription_periods
build monthly_mrr
build mrr_movements
Execute final query to get MRR movement classification
