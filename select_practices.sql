1- Find all the offices and display only their city, phone and country
select city, phone, country from offices

2 - Find all rows in the orders table that mentions FedEx in the comments.
SELECT * FROM orders where comments like "%fedex%"

3 - Show the contact first name and contact last name of all customers in descending order by the customers name
select customerName, contactFirstName, contactLastName from customers order by customerName desc
-- default is asc if you never put desc

4 - Find all sales rep who are in office code 1, 2 or 3 and their first name or last name contains the substring 'son'
select * from employees where (officeCode = 1 or officeCode =2 or officeCode =3)
and (firstName like "%son%" or lastName like "%son%") and (jobTitle= "Sales Rep")

5 - Display all the orders bought by the customer with the customer number 124, along with the customer name, the contact's first name and contact's last name.
select customerName, contactFirstName, contactlastName FROM orders
 JOIN customers
    ON customers.customerNumber = orders.customerNumber where orders.customerNumber = 124

-- select * from orders join customers ON orders.customerNumber = customers.customerNumber 
join orderdetails on orders.orderNumber = orderdetails.orderNumber where customers.customerNumber = 124;


6 - Show the name of the product, together with the order details,  for each order line from the order details table
select * FROM orderdetails
 JOIN products
    ON products.productCode = orderdetails.productCode

select productName, orderNumber, orderdetails.productCode, quantityOrdered, orderLineNumber from
products join orderdetails on products.productCode = orderdetails.productCode

-- if want all the details from both tables
select products.*, orderdetails.* from products join orderdetails on products.productCode = orderdetails.productCode


7 - Display sum of all the payments made by each company from the USA. 
SELECT sum(amount)
FROM payments
JOIN customers
ON payments.customerNumber = customers.customerNumber WHERE country = 'USA'
group by customerName

-- accounts for if the 2 customers have the same name 
-- grouping by customer number ensures no issues when there are two customers with the same name
SELECT customerNumber, sum(amount) FROM payments JOIN customers 
ON payments.customerNumber = customers.customerNumber
group by customerNumber

8 - Show how many employees are there for each state in the USA		
SELECT country, state, count(*) AS "EMPLOYEE_COUNT"
FROM employees
JOIN offices ON 
employees.officeCode = offices.officeCode WHERE (country = 'USA')
group by country, state

SELECT state, count(*)
FROM employees
JOIN offices ON 
employees.officeCode = offices.officeCode WHERE (country = 'USA')
group by state

9 - From the payments table, display the average amount spent by each customer. Display the name of the customer as well.
SELECT customerName,
         avg(amount)
FROM payments
JOIN customers on
customers.customerNumber = payments.customerNumber
GROUP BY payments.customerNumber, customerName

10 - From the payments table, display the average amount spent by each customer but only if the customer has spent a minimum of 10,000 dollars.
SELECT customerName, avg(amount), sum(amount)
FROM payments
JOIN customers 
WHERE payments.customerNumber = customers.customerNumber
group by customerName, payments.customerNumber
having sum(amount) >= 10000

11  - For each product, display how many times it was ordered, and display the results with the most orders first and only show the top ten.
SELECT productName,
         orderdetails.productCode,
         count(*) as "times_ordered"
FROM orderdetails
JOIN products
ON products.productCode = orderdetails.productCode
GROUP BY  productName, orderdetails.productCode
ORDER BY  "times_ordered" DESC limit 10

12 - Display all orders made between Jan 2003 and Dec 2003
-- SELECT *
-- FROM orders
-- WHERE orderDate
--     BETWEEN (year(orderDate)=2003
--         AND month(orderDate)=1)
--         AND (year(orderDate)=2003
--         AND month(orderDate)=12)
SELECT * FROM orders where year(orderDate) = 2003

13 - Display all the number of orders made, per month, between Jan 2003 and Dec 2003
SELECT month(orderDate),
         count(*)
FROM orders
WHERE year(orderDate) = 2003
GROUP BY  month(orderDate)