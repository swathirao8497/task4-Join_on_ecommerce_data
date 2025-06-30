# 🛒 Ecommerce SQL Database Analysis

This project demonstrates SQL capabilities using an Ecommerce database. It includes data modeling, data input, analysis queries, view creation, and performance optimization with indexes.

## 📂 Contents

- `schema.sql` – SQL code to create tables
- `data.sql` – Sample data inserts
- `queries.sql` – SQL queries for analysis
- `views.sql` – Views for business reporting
- `indexes.sql` – Index creation for performance
- `README.md` – Project documentation

---

## 🧾 Tables Overview

| Table        | Description                      |
|--------------|----------------------------------|
| `Customers`  | Customer info                    |
| `Categories` | Product category types           |
| `Products`   | Product details                  |
| `Orders`     | Order summary per customer       |
| `OrderItems` | Order item-level breakdown       |

---

## ⚙️ Setup Instructions

### 1. Create the Schema

Run the following SQL commands (or use `schema.sql`):

```sql
-- schema.sql
CREATE TABLE Customers (...);
CREATE TABLE Categories (...);
CREATE TABLE Products (...);
CREATE TABLE Orders (...);
CREATE TABLE OrderItems (...);
-- data.sql
INSERT INTO Customers VALUES (...);
INSERT INTO Categories VALUES (...);
...
###3. Run Analysis Queries
Use the following queries (or copy from queries.sql):

Total spending per customer

INNER, LEFT, RIGHT JOINs

Subqueries for customer filtering

Aggregations using SUM/AVG
