-- Question 1
-- List all data for all customers.
select *
from customers;

-- Question 2
-- List the name and city of agents named Smith.
select name, city
from agents
where name = 'Smith';

-- Question 3
-- List pid, name, and quantity of products costing
-- more than US$1.25.
select pid, name, quantity
from products
where priceUSD > 1.25;

-- Question 4
-- List the ordno and aid of all orders.
select ordno, aid
from orders;

-- Question 5
-- List the names and cities of customers not in Dallas.
select name, city
from customers
where city != 'Dallas';

-- Question 6
-- List the names of agents in New York or Newark.
select name
from agents
where city = 'New York' or city = 'Newark';

-- Question 7
-- List all data for products not in New York or Newark
-- that cost US$1 or less.
select *
from products
where (city != 'New York' and city != 'Newark') and priceUSD <= 1;

-- Question 8
-- List all data for orders in January or March.
select *
from orders
where mon = 'jan' or mon = 'mar';

-- Question 9
-- List all data for orders in February less than US$100.
select *
from orders
where mon = 'feb' and dollars < 100;

-- Question 10
-- List all orders from the customer whose cid is c005.
select *
from orders
where cid = 'c005';