-- count: how many rows there are in employees table
select count(*) from employees;
select count(employeeeNumber) from employees -> counting primary key but not necessary, same results from count *

-- sum: allows you to sum up the value of a column across all the rows 
select sum(quantityOrdered) from orderdetails

-- select happens after joining -> happens on the joined table 
select sum(quantityOrdered) from orderdetails where productCode = 'S18_1749';

-- have to do inside parenthesis since is reducing function to one value
select sum(quantityOrdered * priceEach) as 'total worth ordered' from orderdetails where productCode = 'S18_1749';

-- count how many customers there are with Sales Rep

-- select count(*) from customers join employees on customers.salesRepEmployeeNumber = employees.employeeNumber

-- find the total amount paid by customers in the month of june 2003;
select sum(amount) from payments where paymentDate between '2003-06-01' AND '2003-06-30';
select sum(amount) from payments where month(paymentDate) =6 AND year(paymentDate) = 2003;

GROUP BY
-- have to select the category you group by
-- whatever you select must be an aggregate function except the category you choose
-- because group by is to generate a summary of the group 

-- count how many customers there are per country
SELECT country, count(*)
FROM customers
GROUP BY  country

-- show the average credit limit and the number of customers per country 
SELECT country, avg(creditLimit) as "average_credit_limit", count(*) as "customer_count"
FROM customers
GROUP BY  country

-- where happens BEFORE GROUP BY => table will filter first and group by will work on the filtered results
-- join happens BEFORE WHERE 
-- join > where > group by > select > order by > limit

-- have to group by also if you want to select something that is not an aggregate
SELECT country,
         firstName,
         lastName,
         email,
         avg(creditLimit),
         count(*)
FROM customers
JOIN employees
    ON customers.salesRepEmployeeNumber = employees.employeeNumber
WHERE salesRepEmployeeNumber = 1504
GROUP BY  country, firstName, lastName, email
ORDER BY avg(creditLimit) DESC
LIMIT 3 

-- only gives the top 3

select country, count(*) from customers group by country
having count(*) > 5
-- having is on the group
-- only groups where they meet the criteria will show in the results
-- having will filter the groups