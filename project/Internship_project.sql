CREATE DATABASE project_db;
use project_db;

select * from customers;
select * from employees;
select * from offices;
select * from orderdetails;
select * from orders;
select * from payments;
select * from productlines;
select * from products;


# 1. **Which customers have placed the highest total order value?**

SELECT 
    c.customerName,
    SUM(od.quantityOrdered * od.priceEach) AS totalOrderValue
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerName
ORDER BY totalOrderValue DESC;

#  2. **Which product lines generate the most revenue?**

SELECT 
    pl.productLine,
    SUM(od.quantityOrdered * od.priceEach) AS totalRevenue
FROM productlines pl
JOIN products p ON pl.productLine = p.productLine
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY pl.productLine
ORDER BY totalRevenue DESC;


# 3. **Which sales representatives (employees) are responsible for the highest sales?**


SELECT 
    e.employeeNumber,
    e.firstName,
    e.lastName,
    SUM(p.amount) AS totalSales
FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY e.employeeNumber, e.firstName, e.lastName
ORDER BY totalSales DESC;


#  4. **Which products have never been ordered?**

SELECT 
    p.productCode,
    p.productName
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
WHERE od.productCode IS NULL;


#   5. **What is the total revenue generated per office location?**

SELECT 
    o.city,
    o.country,
    SUM(p.amount) AS totalRevenue
FROM offices o
JOIN employees e ON o.officeCode = e.officeCode
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY o.city, o.country
ORDER BY totalRevenue DESC;


#  6. **What is the monthly trend of total orders and revenue?**

SELECT 
    DATE_FORMAT(o.orderDate, '%Y-%m') AS month,
    COUNT(DISTINCT o.orderNumber) AS totalOrders,
    SUM(od.quantityOrdered * od.priceEach) AS totalRevenue
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY month
ORDER BY month;


#  7.  **Who are the top 5 customers by total number of orders and total payment amount?**

SELECT 
    c.customerName,
    COUNT(DISTINCT o.orderNumber) AS totalOrders,
    SUM(p.amount) AS totalPayments
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
LEFT JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY c.customerName
ORDER BY totalPayments DESC, totalOrders DESC
LIMIT 5;


#  8. **List all orders that have not been shipped yet.**

SELECT 
    orderNumber,
    orderDate,
    status
FROM orders
WHERE status NOT IN ('Shipped', 'Cancelled');


#   9.  **Which customers ordered the most distinct products?**

SELECT 
    c.customerName,
    COUNT(DISTINCT od.productCode) AS distinctProductsOrdered
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerName
ORDER BY distinctProductsOrdered DESC;


#  10.  **Which employees work in offices that are located in a specific country (e.g., USA)?**

SELECT 
    e.employeeNumber,
    e.firstName,
    e.lastName,
    o.city,
    o.country
FROM employees e
JOIN offices o ON e.officeCode = o.officeCode
WHERE o.country = 'USA';


#  11.  **What is the average unit price for each product line across all orders?**

SELECT 
    pl.productLine,
    AVG(od.priceEach) AS avgUnitPrice
FROM productlines pl
JOIN products p ON pl.productLine = p.productLine
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY pl.productLine
ORDER BY avgUnitPrice DESC;


#  12.  **Which orders include more than 3 different products?**

SELECT 
    o.orderNumber,
    COUNT(DISTINCT od.productCode) AS productCount
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY o.orderNumber
HAVING productCount > 3;


#  13. **What is the average time between order date and payment date for each customer?**

SELECT 
    c.customerName,
    AVG(DATEDIFF(p.paymentDate, o.orderDate)) AS avgDaysBetweenOrderAndPayment
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY c.customerName;


# 14. **Which customers have made payments but have no orders (possible data inconsistency)?**

SELECT 
    c.customerName
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
WHERE o.orderNumber IS NULL;


# 15. **List all employees and count how many customers they manage.**

SELECT 
    e.employeeNumber,
    e.firstName,
    e.lastName,
    COUNT(c.customerNumber) AS customerCount
FROM employees e
LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY e.employeeNumber, e.firstName, e.lastName
ORDER BY customerCount DESC;




