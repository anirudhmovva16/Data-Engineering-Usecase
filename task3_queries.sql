--Table Creation
CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE orders (
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    product_id VARCHAR(10),
    quantity INT,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

--1. Display all orders with customer and product names
SELECT 
    o.order_id,
    c.customer_name,
    c.city,
    p.product_name,
    o.quantity,
    p.price,
    o.status,
    (o.quantity * p.price) AS total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id;

--2. Calculate total order amount for each customer
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.quantity * p.price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name;

--3. Find the number of orders for each status
SELECT 
    status,
    COUNT(order_id) AS order_count
FROM orders
GROUP BY status;

--4. Find the product with the highest total sales amount
SELECT 
    p.product_id,
    p.product_name,
    SUM(o.quantity * p.price) AS total_sales
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sales DESC
LIMIT 1;

--5. Find customers who have not placed any orders
SELECT 
    c.customer_id,
    c.customer_name,
    c.city
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
