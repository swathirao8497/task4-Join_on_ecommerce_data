Ecommerce SQL Database Project
==============================

This project demonstrates practical SQL techniques using an Ecommerce Database.
It includes database schema creation, data population, analytical queries,
view creation, and query optimization with indexes.

-----------------------------------------------------------
Project Overview
-----------------------------------------------------------

Database Features:
- Customers placing orders
- Orders containing multiple products
- Products categorized by type
- Order details (itemized products, quantities, prices)

SQL Concepts Demonstrated:
- SELECT, WHERE, ORDER BY, GROUP BY
- INNER JOIN, LEFT JOIN, RIGHT JOIN (simulated in SQLite)
- Subqueries (with IN, HAVING)
- Aggregate functions: SUM, AVG
- Views for reporting
- Index creation for performance optimization

-----------------------------------------------------------
Database Schema
-----------------------------------------------------------

Tables:
1. Customers      – Customer personal data
2. Categories     – Product category information
3. Products       – List of products and their details
4. Orders         – Order summaries (by customer/date)
5. OrderItems     – Line items for each order

Relationships:
- Each Order belongs to a Customer
- Each OrderItem belongs to an Order and a Product
- Each Product belongs to a Category

-----------------------------------------------------------
Setup Instructions
-----------------------------------------------------------

1. Open a SQL-compatible environment (SQLite, MySQL, PostgreSQL).
2. Run the table creation and data insert scripts provided.
3. Use the example queries to perform analysis and reporting.

Example Table Creation and Insertion:
-------------------------------------

DROP TABLE IF EXISTS OrderItems, Orders, Products, Categories, Customers;

CREATE TABLE Customers (...);
CREATE TABLE Categories (...);
CREATE TABLE Products (...);
CREATE TABLE Orders (...);
CREATE TABLE OrderItems (...);

INSERT INTO Customers VALUES (...);
INSERT INTO Products VALUES (...);

-----------------------------------------------------------
Query Examples
-----------------------------------------------------------

a. SELECT, WHERE, ORDER BY, GROUP BY
------------------------------------
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE substr(o.order_date, 1, 4) = '2024'
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

b. JOINs
--------
INNER JOIN – Orders and Product Details
SELECT o.order_id, c.name, p.name, oi.quantity, oi.price
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id;

LEFT JOIN – Customers with or without Orders
SELECT c.customer_id, c.name, o.order_id
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id;

c. Subqueries
-------------
Customers spending more than average
SELECT customer_id, name
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    GROUP BY customer_id
    HAVING SUM(total_amount) > (
        SELECT AVG(total_amount)
        FROM Orders
    )
);

d. Aggregations
---------------
Product revenue and average price
SELECT 
    p.product_id,
    p.name,
    SUM(oi.quantity * oi.price) AS total_revenue,
    AVG(oi.price) AS avg_price
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name;

e. Views
--------
CREATE VIEW MonthlyCategoryRevenue AS
SELECT 
    cat.category_name,
    substr(o.order_date, 1, 7) AS order_month,
    SUM(oi.quantity * oi.price) AS revenue
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
JOIN Categories cat ON p.category = cat.category_id
GROUP BY cat.category_name, substr(o.order_date, 1, 7);

-- Example usage:
SELECT * FROM MonthlyCategoryRevenue WHERE order_month = '2024-01';

f. Indexes
----------
CREATE INDEX idx_orders_customer_id ON Orders(customer_id);
CREATE INDEX idx_orderitems_order_id ON OrderItems(order_id);
CREATE INDEX idx_orderitems_product_id ON OrderItems(product_id);
CREATE INDEX idx_products_category ON Products(category);
CREATE INDEX idx_orders_order_date ON Orders(order_date);

-----------------------------------------------------------
Example Output Preview
-----------------------------------------------------------

Customer Orders & Spending:
---------------------------
customer_id | name    | total_orders | total_spent
------------|---------|--------------|-------------
1           | Alice   | 2            | 1150.00
2           | Bob     | 1            | 40.00
3           | Charlie | 0            | NULL

INNER JOIN – Order Details:
---------------------------
order_id | customer_name | product_name | quantity | price
---------|----------------|--------------|----------|--------
1        | Alice          | Laptop       | 1        | 1000.00
1        | Alice          | Headphones   | 1        | 100.00
1        | Alice          | Novel        | 1        | 20.00
2        | Bob            | Novel        | 2        | 20.00
3        | Alice          | T-Shirt      | 2        | 15.00

-----------------------------------------------------------
Requirements
-----------------------------------------------------------

- SQLite / MySQL / PostgreSQL
- SQL Client: DBeaver, SQLite Browser, MySQL Workbench, etc.
- Optional: Python with sqlite3 + pandas (for automation)

-----------------------------------------------------------
Files Included
-----------------------------------------------------------

- schema.sql       : Table creation script
- data.sql         : Sample data insertions
- queries.sql      : Analysis queries
- views.sql        : View definitions
- indexes.sql      : Index creation script
- README.txt       : This documentation

-----------------------------------------------------------
License
-----------------------------------------------------------

This project is open-source and released under the MIT License.

-----------------------------------------------------------
Contact
-----------------------------------------------------------

Author: Your Name  
Email : your.email@example.com
