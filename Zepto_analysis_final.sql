drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category varchar(120),
name varchar(150) not null,
mrp numeric (8,2),
discountPercent numeric(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outofstock boolean,
quantity integer
);

--data exploration--

--count of rows--
select count(*)from zepto

--sample data--
select * from zepto
limit 10;

--count of column--
select count(*) 
from INFORMATION_SCHEMA.COLUMNS
where table_name='zepto';

--name of column--
select column_name
from INFORMATION_SCHEMA.COLUMNS
where table_name='zepto'
ORDER BY ORDINAL_POSITION;

alter table zepto
drop column sku_id;

--null values--
select * from zepto
WHERE name IS NULL
or
category is null
or
mrp is null
or
discountpercent is null
or
availablequantity is null
or
discountedsellingprice is null
or
weightingms is null
or
outofstock is null
or
quantity is null;

--Different product category

Select distinct category
from zepto
group by category;

--product out_of_stock vs product in stock--

Select outofstock, count(outofstock)
from zepto
group by outofstock;

--product names present multiple times--
SELECT name, Count(sku_id)
from zepto
group by name
having count(sku_id)>1
order by Count(sku_id) DESC;

---data cleaning--
Select * 
from zepto
Where mrp=0 or discountedsellingprice=0;

Delete from zepto
where mrp=0;

--convert paisa to rupees--
Update zepto
Set mrp=mrp/100.0,
discountedsellingprice=discountedsellingprice/100.0;

Select mrp,discountedsellingprice from zepto;

--q1) Top 10 best-value products based on the discounted percentage--

Select distinct name,mrp,discountpercent
From zepto
Order by discountpercent desc
limit 10;

--q2) What are the products with high mrp but out of stock--

SELECT DISTINCT name, mrp, outofstock
from zepto
where outofstock=true and mrp>300
order by mrp desc;

--q3) Estimate revenue for each category--
Select category,
sum(discountedsellingprice * availablequantity) AS revenue
from zepto
group by category
order by revenue;

--q4) Products where mrp is greater than 500 and discount is less than 10%--

select distinct name,mrp, discountPercent
from zepto
where mrp>500 and discountPercent<10
order by mrp desc;

--q5) Top 5 categories offering the highest average discount--
select category,
round(avg(discountpercent),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;

--q6) Grouping the products into categories like low, medium, bulk--
Select distinct name, weightInGms,
Case when weightInGms < 1000 Then 'low'
    when weightInGms < 5000 then 'Medium'
	else 'bulk'
	end as weight_category
from zepto;

