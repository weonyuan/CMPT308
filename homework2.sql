-- Query Homework 2
-- Weon Yuan
-- CMPT 308, Fall 2013, Alan Labouseur

-- 1. Get the cities of agents booking an order for customer c002.
-- Output: Tokyo, Duluth
select city
from agents a
where a.aid in (
	select aid
	from orders o
	where cid = 'c002'
);


-- 2. Get the pids of products ordered through any agent who makes at least
-- one order for a customer in Kyoto.
-- Output: p01, p07
select distinct pid
from orders o
where o.aid in (
	select a.aid
	from agents a
	where c.cid in (
		select c.cid
		from customers c
		where city = 'Kyoto'
	)
)
order by pid;


-- 3. Find the cids and names of customers who never placed an order through
-- agent a03.
-- Output: c004, c005 and their respective names
select cid, name
from customers c
where c.cid not in (
	select cid
	from orders o
	where aid in (
		select aid
		from orders
		where aid = 'a03'
	)
)
order by cid;


-- 4. Get the cids and names of customers who ordered both product p01 and
-- p07.
-- Output: c001, c006 and their respective names
select cid, name
from customers c
where c.cid in (
	select distinct o1.cid
	from orders o1
	where o1.pid = 'p01' and o1.cid in (
		select distinct o2.cid
		from orders o2
		where o2.pid = 'p07'
	)
)
order by cid;


-- 5. Get the pids of products ordered by any customers who ever placed an
-- order through agent a03.
-- Output: p03, p04, p05, p07
select distinct pid
from products p
where p.pid in (
	select o.pid
	from orders o
	where aid = 'a03'
)
order by pid;


-- 6. Get the names and discounts of all customers who place orders
-- through agents in Dallas or Duluth.
-- Output: ACME, ACME, Basics, Tiptop and their respective
-- discount rates.
select name, discount
from customers c
where c.cid in (
	select o.cid
	from orders o
	where o.aid in (
		select a.aid
		from agents a
		where a.city = 'Dallas'
		   or a.city = 'Duluth'
	)
)
order by name;

-- 7. Find all customers who have the same discount as that of any
-- customers in Dallas or Kyoto.
-- Output: Nothing; just as impossible as dividing by 0 infinity times
select *
from customers
where discount in (
	select discount
	from customers c1
	where c1.city = 'Dallas' and c1.discount in (
		select c2.discount
		from customers c2
		where c2.city = 'Kyoto'
	)
);