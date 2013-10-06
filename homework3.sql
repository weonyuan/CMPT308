-- Query Homework 3
-- Weon Yuan
-- CMPT 308, Fall 2013, Alan Labouseur

-- 1. Get the cities of agents booking an order for customer c002.
-- Use subqueries.
-- Output: Tokyo, Duluth
select city
from agents a
where a.aid in (
	select aid
	from orders o
	where cid = 'c002'
);


-- 2. Get the cities of agents booking an order for customer c002.
-- Use joins.
-- Output: Tokyo, Duluth
select city
from agents a, orders o
where o.aid = a.aid
 and o.cid = 'c002'
group by city;


-- 3. Get the pids of products ordered through any agent who makes at least
-- one order for a customer in Kyoto. Use subqueries.
-- Output: p01, p07
select distinct pid
from orders o
where o.aid in (
	select a.aid
	from agents a
	where cid in (
		select c.cid
		from customers c
		where city = 'Kyoto'
	)
)
order by pid;


-- 4. Get the pids of products ordered through any agent who makes at least
-- one order for a customer in Kyoto. Use joins.
-- Output: p01, p07
select distinct pid
from orders o, agents a, customers c
where o.aid = a.aid
  and o.cid = c.cid
  and c.city = 'Kyoto'
group by pid;


-- 5. Get the names of customers who have never placed an order.
-- Use a subquery.
-- Output: Weyland-Yutani
select name
from customers c
where c.cid not in (
	select o.cid
	from orders o
);

-- 6. Get the names of customers who have never placed an order.
-- Use an outer join.
-- Output: Weyland-Yutani
select c.name
from customers c left outer join orders o on c.cid = o.cid
where o.cid is null
order by c.name;


-- 7. Get the names of customers who placed at least one order through
-- an agent in their city, along with those agent(s) names.
-- Output: Tiptop, Otasi
select c.name, a.name
from customers c, agents a, orders o
where c.city = a.city
  and c.cid = o.cid
  and a.aid = o.aid
group by c.name, a.name;


-- 8. Get the names of customers and agents in the same city, along
-- with the name of the city, regardless of whether or not the customer
-- has ever placed an order with that agent.
-- Output: ACME and Otasi (Duluth), Allied and Smith (Dallas),
--         Basics and Smith (Dallas), Tiptop and Otasi (Duluth)
select c.name, a.name
from customers c, agents a, orders o
where c.city = a.city
group by c.name, a.name;


-- 9. Get the name and city of customers who live in the city where
-- the least number of products are made.
-- Output: Tiptop (Duluth), ACME (Duluth)
select c.name, c.city
from customers c
where c.city in (
	select p.city
	from products p
	group by p.city
	order by count(*) asc
	limit 1
);


-- 10. Get the name and city of customers who live in a city where
-- the most number of products are made.
-- Output: Basics (Dallas), Allied (Dallas)
select c.name, c.city
from customers c
where c.city in (
	select p.city
	from products p
	group by p.city
	order by count(*) desc
	limit 1
);


-- 11. Get the name and city of customers who live in any city where
-- the most number of products are made.
-- Output: Basics (Dallas), Allied (Dallas)
select c.name, c.city
from customers c
where c.city in (
	select p1.city
	from products p1
	group by p1.city
	having count(*) = (
		select count(*)
		from products p2
		group by p2.city
		order by count(*) desc
		limit 1
	)
);


-- 12. List the products whose priceUSD is above the average priceUSD.
-- Output: Folder, Clip
select name, avg(priceUSD)
from products
group by name
having priceUSD > (select avg(priceUSD)
			from products);


-- 13. Show the customer name, pid ordered, and the dollars for all
-- customer orders, sorted by dollars from high to low.
-- Output: p01: ACME (Kyoto), ACME (Duluth), Tiptop, ACME (Kyoto);
-- 	   p02: Tiptop; p03: Basics, Basics, Tiptop; p04: Tiptop;
-- 	   p05: Allied, Tiptop; p06: Tiptop; p07: Tiptop, ACME (Kyoto)
select c.name, o.pid, o.dollars
from customers c inner join orders o on c.cid = o.cid
order by o.pid asc, o.dollars desc;


-- 14. Show all customer names (in order) and their total ordered, and
-- nothing more. Use coalesce to avoid showing NULLs.
-- Output: ACME (Duluth and Kyoto), Allied, Basics, Tiptop
--         Weyland-Yutani and their total ordered quantity.
select c.name, coalesce(sum(o.qty), 0)
from customers c left outer join orders o on c.cid = o.cid
group by c.name
order by c.name asc;


-- 15. Show the names of all customers who bought products from agents
-- based in New York along with the names of the products they ordered,
-- and the names of the agents who sold it to them.
-- Output: Tiptop, Comb, Smith; ACME (Kyoto), Comb, Smith;
--         Tiptop, Pencil, Gray;
select c.name, p.name, a.name
from orders o inner join customers c on o.cid = c.cid
	      inner join products p on o.pid = p.pid
	      inner join agents a on o.aid = a.aid
where a.city = 'New York';


-- 16. Write a query to check the accuracy of the dollars column in the
-- Orders table. This means calculating Orders.dollars from other data
-- in other tables and then comparing those values to the values in
-- Orders.dollars.
-- Output: All orders in the Orders table should appear.
select *
from orders o inner join customers c on o.cid = c.cid
	      inner join products p on o.pid = p.pid
where o.dollars = (o.qty * p.priceUSD) * (1 - (c.discount / 100))
order by o.ordno asc;


-- 17. Create an error in the dollars column of the Orders table so
-- that you can verify your accuracy checking query.
-- Output: Ordno 1011 should disappear when you execute this update
-- and run the query on Question 16. Original value (o.dollars) was 450.
update orders
set dollars = 600
where ordno = 1011;