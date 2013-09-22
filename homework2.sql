-- Weon Yuan
-- CMPT 308, Fall 2013, Alan Labouseur
-- Query Homework 2

-- Get the cities of agents booking an order for customer c002.
select city
from agents
where aid in (
	select aid
	from orders
	where cid in (
		select cid
		from orders
		where cid = 'c002'
	)
);

-- Get the pids of products ordered through any agent who makes at least
-- one order for a customer in Kyoto.
select distinct pid
from orders
where aid in (
	select aid
	from agents
	where cid in (
		select cid
		from customers
		where city = 'Kyoto'
	)
);

-- Find the cids and names of customers who never placed an order through
-- agent a03.
select cid, name
from customers
where cid not in (
	select cid
	from orders
	where aid in (
		select aid
		from orders
		where aid = 'a03'
	)
);

-- Get the cids and names of customers who ordered both product p01 and
-- p07.
-- FIX
select cid, name
from customers
where cid in (
	select cid
	from orders
	where (pid = 'p01'
	  or pid = 'p07')
	  and orders.cid = customers.cid
);

-- Get the pids of products ordered by any customers who ever placed an
-- order through agent a03.
-- FIX
select pid
from products
where pid in (
	select pid
	from orders
	where cid in (
		select cid
		from orders
		where aid in (
			select aid
			from orders
			where aid = 'a03'
		)
	)
);

-- Get the names and discounts of all customers who place orders
-- through agents in Dallas or Duluth.
select name, discount
from customers
where cid in (
	select cid
	from orders
	where aid in (
		select aid
		from agents
		where city = 'Dallas'
		   or city = 'Duluth'
	)
);

-- Find all customers who have the same discount as that of any
-- customers in Dallas or Kyoto.
-- FIX

-- Get the IDs of customers who did not place any orders through
-- agent a03.
select cid
from customers c
where cid not in (
	select cid
	from orders o
	where aid = 'a03'
	  and c.cid = o.cid
);