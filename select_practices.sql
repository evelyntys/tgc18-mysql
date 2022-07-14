1- Find all the offices and display only their city, phone and country
select city, phone, country from offices

2 - Find all rows in the orders table that mentions FedEx in the comments.
SELECT * FROM orders where comments like "%fedex%"

3 - Show the contact first name and contact last name of all customers in descending order by the customer's name
select customerName, contactFirstName, contactLastName from customers order by customerName desc

4 - Find all sales rep who are in office code 1, 2 or 3 and their first name or last name contains the substring 'son'
select * from employees where (officeCode = 1 or officeCode =2 or officeCode =3)
and (firstName like "%son%" or lastName like "%son%")

5 - Display all the orders bought by the customer with the customer number 124, along with the customer name, the contact's first name and contact's last name.
select customerName, contactFirstName, contactlastName FROM orders
 JOIN customers
    ON customers.customerNumber = orders.customerNumber where orders.customerNumber = 124


6 - Show the name of the product, together with the order details,  for each order line from the order details table
select * FROM orderdetails
 JOIN products
    ON products.productCode = orderdetails.productCode