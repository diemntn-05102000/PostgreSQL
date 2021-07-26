explain verbose select * from customers c where customerid in (select customerid from orders where orderdate < '2004-01-27');--260.81..1061.34

create index idx_orders_orderdate on orders using btree(orderdate);

explain verbose select * from customers c where customerid in (select customerid from orders where orderdate < '2004-01-27');--54.53..810.06
--7 loai san pham ban chay nhat trong 12/2004
with tmp as(
select c.category, c.categoryname, sum(quantity) as sum  from categories c, products p, orderlines o 
where c.category = p.category and p.prod_id = o.prod_id and orderdate between '2004-12-01' and '2004-12-31'--dung duoc index
--date_part('year',orderdate) = 2004 and date_part('month',orderdate) = 12 => ko dung index duoc
group by (c.category) 
)
select category, categoryname from tmp where sum = (select max(sum) from tmp); -- sum >= all(select sum from tmp)
--7, motto yoi
with tmp as(
select p.category, sum(quantity) as sum  from products p, orderlines o 
where p.prod_id = o.prod_id and orderdate between '2004-12-01' and '2004-12-31'
group by (p.category) 
)
select c.category, c.categoryname from tmp, categories c where c.category = tmp.category and sum = (select max(sum) from tmp); -- sum >= all(select sum from tmp)
--7
select c.category, c.categoryname from categories c, products p, orderlines o 
where c.category = p.category and p.prod_id = o.prod_id and orderdate between '2004-12-01' and '2004-12-31'--dung duoc index
group by (c.category) 
having sum(quantity) >= ALL( select sum(quantity) from products p, orderlines o 
where p.prod_id = o.prod_id and orderdate between '2004-12-01' and '2004-12-31'
group by (p.category) )
--8 532.56..854.32
explain verbose 
select p.* from products p ,inventory i
where p.prod_id = i.prod_id and quan_in_stock = (select  max(quan_in_stock) from products p , inventory i
where p.prod_id = i.prod_id )
--1
create index idx_orders_totalamount on orders using btree(total);

explain verbose 
SELECT c.*
FROM customers c, orders o
WHERE c.customerid = o.customerid
    AND (o.totalamount > 400
    AND c.phone LIKE '%546%'); 
--4
select cu.* ,count(cu.customerid) as count  from customers cu, orders o
where cu.customerid = o.customerid 
group by cu.customerid
having count(cu.customerid) > 5

select cu.customerid , sum(totalamount) as sum  from customers cu, orders o
where cu.customerid = o.customerid 
group by cu.customerid
having sum(totalamount) > 1000;

set enable_seqscan = off --bat dung index
--5
select prod_id from orders o, orderlines ol
where o.orderid = ol.orderid and o.orderdate = ol.orderdate;
--6 
select p.prod_id ,title, actor, price,sum( quantity)
from products p left join orderlines o using (prod_id)
where orderdate between '2004-07-01'  and '2004-12-01' 
group by (prod_id)
having sum( quantity) = 0;
--2
create index idx_orders_tax on orders using btree(tax);

explain 
select o.orderid, cu.lastname, cu.firstname, cu.address1,cu.address2, cu.city, cu.state  from customers cu, orders o
where cu.customerid = o.customerid and tax < netamount*0.1;
--9
/*with male as(
select category , count(category) as Male from products where prod_id in
(select prod_id from orderlines where orderid in 
(select orderid from orders where customerid in (select customerid from customers where gender = 'M')))
group by (category)
),female as(
select category , count(category) as Female from products where prod_id in
(select prod_id from orderlines where orderid in 
(select orderid from orders where customerid in (select customerid from customers where gender = 'F')))
group by (category)
)
select f.category, f.Female as Female, m.Male as Male from female f,male m where m.category = f.category 
order by (f.Female + m.Male) desc
*/
select pr.category, cu.gender, count(o.orderlineid) tong_so
from products pr, orderlines o, customers cu, orders ord
where pr.prod_id = o.prod_id and cu.customerid = ord.customerid and ord.orderid = o.orderid
group by (pr.category, cu.gender)
order by pr.category, gender

SELECT c.categoryname, COUNT(cus.gender) AS total_male
FROM categories c, products p, customers cus, orderlines ol, orders o
WHERE c.category = p.category
    AND ol.prod_id = p.prod_id
    AND ol.orderid = o.orderid
    AND o.customerid = cus.customerid
GROUP BY c.categoryname, cus.gender
HAVING cus.gender = 'M'
ORDER BY total_male DESC
	