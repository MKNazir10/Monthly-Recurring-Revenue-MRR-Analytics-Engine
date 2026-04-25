# 📊 Monthly Recurring Revenue (MRR) Analytics Engine

## 1. Problem Statement

Subscription businesses generate revenue through recurring plans, but raw event logs (subscriptions, upgrades, cancellations) do not directly provide monthly revenue insights.

This project builds a SQL-based analytics engine that:

- Reconstructs subscription state over time  
- Calculates Monthly Recurring Revenue (MRR)  
- Tracks revenue movements such as churn, expansion, and reactivation  

---

## 2. Dataset Description

### Base Tables

- `users` → list of users  
- `subscription_events` → raw event logs (start, upgrade, cancel, reactivate)  
- `plan_dim` → plan details with monthly price  
- `dim_month` → calendar table with monthly grain  

### Derived Tables

- `subscription_periods` → subscription intervals built using `LEAD()`  
- `monthly_mrr` → user-level MRR at month-end  
- `mrr_with_prev` → MRR with previous & historical values  

---
## 3. Data Model

![MRR Data Flow Architecture](diagram/diagram.png)
---
```text
Raw Events Layer
----------------
subscription_events

        ↓

State Reconstruction Layer
--------------------------
subscription_periods

        ↓

Time Series Layer
----------------
user_month grid (users × months)

        ↓

Metrics Layer
-------------
monthly_mrr

        ↓

Analytical Layer
----------------
mrr_with_prev

        ↓

Business Output
---------------
movement classification

```
---
## 4. Approach

This project uses a **month-end snapshot approach**:

- Convert events → subscription periods using `LEAD()`  
- Use half-open intervals `[start_date, end_date)`  
- Evaluate subscription state at **month_end**  
- Generate full timeline using `users × months`  
- Fill missing months with `0 MRR`  
- Compute movement using `LAG()` and window functions  

---

## 5. Key SQL Concepts Used

- Window functions: `LEAD()`, `LAG()`, `MAX()`  
- Partitioning (`PARTITION BY`)  
- Window frames (`ROWS BETWEEN UNBOUNDED PRECEDING`)  
- `LEFT JOIN` vs `INNER JOIN`  
- `COALESCE` for NULL handling  
- CTE-based modular query design  

---

## 6. Metrics Explained

- **New MRR** → First-time subscription  
- **Reactivation MRR** → Subscription after churn  
- **Churn MRR** → Active → inactive  
- **Expansion MRR** → Upgrade to higher plan  
- **Contraction MRR** → Downgrade to lower plan  
- **No Movement** → No change in MRR  

---

## 7. Sample Output

| user_id | month_start | MRR | previous | movement | type |
|--------|------------|----|---------|---------|------|
| 2 | 2024-03-01 | 0 | 15 | -15 | Churn |
| 2 | 2024-06-01 | 15 | 0 | +15 | Reactivation |
| 1 | 2024-03-01 | 35 | 15 | +20 | Expansion |

*(Full output available in project)*

---

## 8. How to Run

### Step 1: Create Base Tables

- users  
- subscription_events  
- plan_dim  
- dim_month  

### Step 2: Run SQL Files in Order

1. `01_subscription_periods.sql`  
2. `02_monthly_mrr.sql`  
3. `03_mrr_movements.sql`  

### Step 3: Execute Final Query

Get MRR movement classification.

---
