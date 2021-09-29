-- HW4: --
SELECT
a.orderNumber,
b.priceEach,
b.quantityOrdered,
c.productName,
c.productLine,
d.city,
d.country,
a.orderDate
FROM orders a
INNER JOIN orderdetails b ON b.orderNumber = a.orderNumber
INNER JOIN products c ON c.productCode = b.productCode
INNER JOIN customers d ON d.customerNumber = a.customerNumber;

-- Exercises during lecture: --
-- exercise 1:
SELECT
a.ordernumber,
a.orderdate,
a.requireddate,
a.shippeddate,
a.status,
a.comments,
a.customernumber,
b.productcode,
b.quantityordered,
b.priceeach,
b.orderlinenumber
FROM orders a
LEFT JOIN orderdetails b on b.ordernumber = a.ordernumber;

-- exercise 2: 
SELECT
a.ordernumber,
a.status,
b.quantityordered * b.priceeach AS order_total
FROM orders a
LEFT JOIN orderdetails b on b.ordernumber = a.ordernumber;

-- exercise 3:
SELECT
a.orderdate,
c.lastName,
c.firstName
FROM orders a
LEFT JOIN customers b on b.customerNumber = a.customerNumber
LEFT JOIN employees c on c.employeeNumber = b.salesRepEmployeeNumber;
