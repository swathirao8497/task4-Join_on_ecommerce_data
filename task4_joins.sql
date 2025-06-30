-- Drop existing tables if needed
DROP TABLE IF EXISTS OrderItems, Orders, Products, Categories, Customers;

-- Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

-- Categories
CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50)
);

-- Products
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    category INT,
    price DECIMAL(10,2),
    FOREIGN KEY (category) REFERENCES Categories(category_id)
);

-- Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- OrderItems
CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
-- Insert Customers
INSERT INTO Customers VALUES
(1, 'Alice', 'alice@email.com'),
(2, 'Bob', 'bob@email.com'),
(3, 'Charlie', 'charlie@email.com');

-- Insert Categories
INSERT INTO Categories VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Clothing');

-- Insert Products
INSERT INTO Products VALUES
(1, 'Laptop', 1, 1000.00),
(2, 'Headphones', 1, 100.00),
(3, 'Novel', 2, 20.00),
(4, 'T-Shirt', 3, 15.00);

-- Insert Orders
INSERT INTO Orders VALUES
(1, 1, '2024-01-10', 1120.00),
(2, 2, '2024-02-15', 40.00),
(3, 1, '2024-03-05', 30.00);

-- Insert OrderItems
INSERT INTO OrderItems VALUES
(1, 1, 1, 1, 1000.00),
(2, 1, 2, 1, 100.00),
(3, 1, 3, 1, 20.00),
(4, 2, 3, 2, 20.00),
(5, 3, 4, 2, 15.00);
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE YEAR(o.order_date) = 2024
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;
-- INNER JOIN: Orders with product details
SELECT 
    o.order_id,
    c.name AS customer_name,
    p.name AS product_name,
    oi.quantity,
    oi.price
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
INNER JOIN OrderItems oi ON o.order_id = oi.order_id
INNER JOIN Products p ON oi.product_id = p.product_id;

-- LEFT JOIN: Customers with or without orders
SELECT 
    c.customer_id,
    c.name,
    o.order_id
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id;

-- RIGHT JOIN: Products never sold
SELECT 
    p.product_id,
    p.name,
    oi.order_item_id
FROM Products p
RIGHT JOIN OrderItems oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;
-- Customers who spent more than average
SELECT 
    customer_id,
    name
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
-- Revenue and average price per product
SELECT 
    p.product_id,
    p.name,
    SUM(oi.quantity * oi.price) AS total_revenue,
    AVG(oi.price) AS avg_price
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name;
CREATE VIEW MonthlyCategoryRevenue AS
SELECT 
    cat.category_name,
    DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
    SUM(oi.quantity * oi.price) AS revenue
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
JOIN Categories cat ON p.category = cat.category_id
GROUP BY cat.category_name, DATE_FORMAT(o.order_date, '%Y-%m');
CREATE INDEX idx_orders_customer_id ON Orders(customer_id);
CREATE INDEX idx_orderitems_order_id ON OrderItems(order_id);
CREATE INDEX idx_orderitems_product_id ON OrderItems(product_id);
CREATE INDEX idx_products_category ON Products(category);
CREATE INDEX idx_orders_order_date ON Orders(order_date);
