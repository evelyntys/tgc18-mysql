-- display all columns from all rows 
select * from employees; * refers to all columns

-- select <column names> from <table names>
SELECT firstName, lastName, email FROM employees;

-- select column and rename them
SELECT firstName AS 'first name', lastName as 'last name', email FROM employees;

-- use where to filter the rows
-- usually must quotes around when it is not a number e.g. country = 'USA'
SELECT * FROM employees where officeCode = 1

SELECT city, addressLine1, addressLine2, country FROM offices WHERE country = 'USA';

-- use LIKE with wildcard to match partial strings; no case sensitivity

-- %sales% will match as long as the world 'sales' appear anywhere in jobTitle
SELECT * FROM employees where jobTitle LIKE '%sales%'

-- %sales will match where the job title ends with 'sales'
SELECT * FROM employees where jobTitle LIKE '%sales'

-- sales will match as long as the job title begins with 'sales'
SELECT * FROM employees WHERE jobTitle LIKE 'sales%'

-- find all the products which name begins with 1969
SELECT * FROM products where productName LIKE '1969%';

-- find all the products which name contains the string 'davidson'
SELECT * FROM products where productName LIKE '%davidson%';

-- filter for multiple conditions using logical operators
-- find all sales rep from office code 1
SELECT * FROM employees where officeCode =1 AND jobTitle LIKE 'Sales Rep';

-- find all employees from office code 1 or office code 2
SELECT * FROM employees where officeCode =1 OR  officeCode = 2

-- show all sales rep from office code 1 or office code 2 
select * from employees where jobTitle LIKE 'sales rep' and (officeCode = 1 or officeCode = 2);
-- or has lower priority than an

-- show all customers from USA in the state NV who has credit > 5000 or all customers from any country with credit limit > 1000
SELECT * FROM customers where (country = 'USA' and state='NV' and creditLimit > 5000)
or (creditLimit > 10000);

-- join will not affect original table, returns a temporary table
SELECT * FROM employees JOIN offices ON employees.officeCode = offices.officeCode;

SELECT firstName, lastName, city, addressLine1, addressLine2 FROM employees 
JOIN offices ON employees.officeCode = offices.officeCode
where country = 'USA'
-- filtering will occur on the new temporary table

-- show the customerName along with the firstName, lastName amd email of their sales rep only for customers that have a sales rep
SELECT customerName, firstName, lastName, email FROM customers 
JOIN employees ON customers.salesRepEmployeeNumber = employees.employeeNumber;
-- inner join by default

-- show all customers with their sales rep info, regardless of whether the customers have a slaes rep or not
SELECT customerName, firstName, lastName, email
FROM customers
LEFT JOIN employees
    ON customers.salesRepEmployeeNumber = employees.employeeNumber;

for LEFT hand side table, each row is guaranteed to be in the results

-- show for all employees regardless of whether they have customers
-- customers with no sales rep will not show up
SELECT customerName, firstName, lastName, email
FROM customers
RIGHT JOIN employees
    ON customers.salesRepEmployeeNumber = employees.employeeNumber;


-- full outer join = left join + right join (NOT SUPPORT BY MYSQL)

-- if want office code, then put the table name in front e.g. employees.officeCode
select firstName, lastName, officeCode, city FROM employees join offices on employees.officeCode = offices.officeCode

-- select happens after joining tables
-- where also happens after joining tables

-- for each customer in the USA, show the name of the sales rep and their office number 
select customerName, customers.country as "customer's country", firstName, lastName, customers.phone as "customer's phone", offices.phone as "office phone" from customers join employees 
on customers.salesRepEmployeeNumber = employees.employeeNumber
join offices on employees.officeCode = offices.officeCode
where customers.country = 'usa'

-- date manipulation
-- if want to compare dates, have to store as date/datetime/timestamp, NOT VARCHAR

-- tell you current date on server
SELECT curdate();

-- tell you current date and time
SELECT NOW();

-- timestamp; number of seconds since 01/01/1990

-- show all payments made after 30th june 2003;
SELECT * FROM payments where paymentDate > "2003-06-30";

-- show all payments between 2003-01-01 and 2003-06-30
SELECT * from payments where paymentDate >= '2003-01-01' and paymentDate <= '2004-06-30';

select * from payments where paymentDate between '2003-01-01' AND '2003-06-30'

-- month year and day functions 
-- display the years where a payment is made 
select checkNumber, year(paymentDate), month(paymentDate), day(paymentDate) from payments

-- show all payments made in the year 2003:
select checkNumber from payments where year(paymentDate) = 2003;

-- display the month, year, and day for each payment made
select checkNumber, year(paymentDate), month(paymentDate), day(paymentDate) from payments


SUBQUERY
-- show the product code of the product that has been ordered the most times
SELECT productCode
FROM 
    (SELECT productName,
         orderdetails.productCode,
         count(*) AS "times_ordered"
    FROM orderdetails
    JOIN products
        ON products.productCode = orderdetails.productCode
    GROUP BY  productName, orderdetails.productCode
    ORDER BY  "times_ordered" DESC limit 1) AS sub;
 
 -- when the select only returns one value, it will be treated as a primitive
SELECT *
FROM customers
WHERE creditLimit > 
    (SELECT avg(creditLimit)
    FROM customers)

-- when the select returns a singular column of rows, then it is an array
-- selecting products that have not been sold
-- IN AND NOT IN -> similar to mongodb's $in query
SELECT *
FROM products
WHERE productCode NOT IN 
    (SELECT distinct(productCode)
    FROM orderdetails)

-- for each sales rep, how much money did they make for the company? 

-- show all sales rep who made more than 10% of the payment amount 
select employeeNumber, firstName, lastName sum(amount) from employees join customers
on employees.employeeNumber = customers.salesRepEmployeeNumber
join payments on customers.customerNumber = payments.customerNumber
group by employees.employeeNumber 
having sum(amount) > (select sum(amount) * 0.1 from payments)