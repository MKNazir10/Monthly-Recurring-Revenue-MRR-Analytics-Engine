-- USERS
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    user_id INT PRIMARY KEY
);

INSERT INTO users (user_id) VALUES
(1), (2), (3);


-- PLAN DIMENSION
DROP TABLE IF EXISTS plan_dim;
CREATE TABLE plan_dim (
    plan_id TEXT PRIMARY KEY,
    monthly_price INT
);

INSERT INTO plan_dim (plan_id, monthly_price) VALUES
('basic', 15),
('premium', 35);


-- SUBSCRIPTION EVENTS
DROP TABLE IF EXISTS subscription_events;
CREATE TABLE subscription_events (
    event_id SERIAL PRIMARY KEY,
    user_id INT,
    event_type TEXT,
    new_plan_id TEXT,
    effective_date DATE
);

INSERT INTO subscription_events (user_id, event_type, new_plan_id, effective_date) VALUES

-- USER 1: start → upgrade → cancel
(1, 'subscription_started', 'basic', '2024-01-05'),
(1, 'plan_changed', 'premium', '2024-03-10'),
(1, 'cancelled', NULL, '2024-05-01'),

-- USER 2: start → cancel → reactivate
(2, 'subscription_started', 'basic', '2024-01-10'),
(2, 'cancelled', NULL, '2024-03-20'),
(2, 'subscription_reactivated', 'basic', '2024-06-01'),

-- USER 3: start → cancel → reactivate
(3, 'subscription_started', 'basic', '2024-02-01'),
(3, 'cancelled', NULL, '2024-04-15'),
(3, 'subscription_reactivated', 'basic', '2024-06-15');


-- DIM MONTH (2024)
DROP TABLE IF EXISTS dim_month;
CREATE TABLE dim_month (
    month_start DATE
);

INSERT INTO dim_month (month_start) VALUES
('2024-01-01'),
('2024-02-01'),
('2024-03-01'),
('2024-04-01'),
('2024-05-01'),
('2024-06-01'),
('2024-07-01'),
('2024-08-01'),
('2024-09-01'),
('2024-10-01'),
('2024-11-01'),
('2024-12-01');
