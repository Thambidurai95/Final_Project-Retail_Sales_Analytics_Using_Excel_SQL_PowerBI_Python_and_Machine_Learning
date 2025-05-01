create database final_project;
use final_project;

select * from brands;
select * from categories;
select * from customers;
select * from order_items;
select * from orders;
select * from products;
select * from staffs;
select * from stocks;
select * from stores;

# Customers
desc customers;
alter table customers add constraint unique_customer_id unique (customer_id);
alter table customers add primary key (customer_id);
alter table customers modify column first_name varchar(50);
alter table customers modify column last_name varchar(50);
alter table customers modify column phone varchar(50);
alter table customers modify column email varchar(50);
alter table customers modify column street varchar(50);
alter table customers modify column city varchar(50);
alter table customers modify column state varchar(50);
alter table customers modify column zip_code varchar(50);

# Orders
desc orders;
alter table orders add constraint unique_order_id unique (order_id);
alter table orders add primary key (order_id);
alter table orders add foreign key (customer_id) references customers (customer_id);
alter table orders modify column order_status varchar(50);
alter table orders modify column order_date varchar(50);
alter table orders modify column required_date varchar(50);
alter table orders modify column shipped_date varchar(50);
alter table orders modify column store_id int;
alter table orders modify column staff_id int;
alter table orders add foreign key (staff_id) references staffs (staff_id);
alter table orders add foreign key (store_id) references stores (store_id);

# Order_items
desc order_items;
alter table order_items add foreign key (order_id) references orders (order_id);
alter table order_items add foreign key (product_id) references products (product_id);
alter table order_items add foreign key (category_id) references categories (category_id);
alter table order_items modify column product_name varchar(100);
alter table order_items modify column category_name varchar(50);

# products
desc products;
alter table products add constraint unique_product_id unique (product_id);
alter table products modify column product_name varchar(50);
alter table products add primary key (product_id);
alter table products add foreign key (brand_id) references brands (brand_id);
alter table products add foreign key (category_id) references categories (category_id);

# brands
desc brands;
alter table brands add constraint unique_brand_id unique (brand_id);
alter table brands modify column brand_name varchar(50);
alter table brands add primary key (brand_id);

# categories
desc categories;
alter table categories add constraint unique_category_id unique (category_id);
alter table categories modify column category_name varchar(50);
alter table categories add primary key (category_id);

# stores
desc stores;
alter table stores add constraint unique_store_id unique (store_id);
alter table stores add primary key (store_id);
alter table stores modify column store_name varchar(50);
alter table stores modify column phone varchar(50);
alter table stores modify column email varchar(50);
alter table stores modify column street varchar(50);
alter table stores modify column city varchar(50);
alter table stores modify column state varchar(50);
alter table stores modify column zip_code varchar(50);

# stocks
desc stocks;
alter table stocks add foreign key (store_id) references stores (store_id);
alter table stocks add foreign key (product_id) references products (product_id);

# staffs
desc staffs;
alter table staffs add constraint unique_staff_id unique (staff_id);
alter table staffs add primary key (staff_id);
alter table staffs modify column first_name varchar(50);
alter table staffs modify column last_name varchar(50);
alter table staffs modify column phone varchar(50);
alter table staffs modify column email varchar(50);
alter table staffs modify column active varchar(50);
alter table staffs modify column manager_id varchar(50);
alter table staffs add foreign key (store_id) references stores (store_id);

# Order_status update

select * from orders;
alter table orders rename column order_status to order_info;
alter table orders add column order_status varchar(50);

SET SQL_SAFE_UPDATES = 0;

update orders
set order_status = case
					when order_info = 4 then 'Delivered'
                    when order_info = 3 then 'Shipped'
                    when order_info = 2 then 'Processing'
                    when order_info = 1 then 'Pending'
					else order_status
				end
		where order_info in (4,3,2,1);
alter table orders drop column order_info;

# 3 - Inner join for Order Details

select orders.order_id,customer_id,order_items.item_id,order_items.product_id,products.product_name,order_items.category_name,
order_items.quantity,order_items.list_price,order_items.discount,order_items.total_price,orders.order_status from orders 
inner join order_items on orders.order_id=order_items.order_id
inner join products on order_items.product_id=products.product_id;

# 4 - Total Sales by Store

select stores.store_id,store_name,round(sum(total_price),2) as Total_sales from stores
inner join orders on stores.store_id=orders.store_id
inner join order_items on orders.order_id=order_items.order_id
group by store_id,store_name;

# 5 - Top 5 Selling Products

select product_id,product_name,sum(quantity) as Total_quantities_sold from order_items
group by product_id,product_name
order by Total_quantities_sold desc
limit 5;

# 6 - Customer Purchase Summary

select customers.customer_id,first_name,last_name,count(distinct orders.order_id) as Total_orders,sum(item_id) as Total_items,
round(sum(total_price),2) as Total_revenue from customers 
inner join orders on customers.customer_id=orders.customer_id 
inner join order_items on orders.order_id=order_items.order_id
group by customer_id,first_name,last_name;

# 7 - Segment Customers by Total Spend

select
	customers.customer_id,first_name,last_name,
    round(sum(total_price),2) as Total_spent,
    case
		when sum(total_price) >=10000 then 'High'
        when sum(total_price) >=1000 then 'Medium'
        else 'Low'
	end as Customer_segment
from customers inner join orders on customers.customer_id=orders.customer_id
inner join order_items on orders.order_id=order_items.order_id
group by customer_id,first_name,last_name;

# 8 - Staff Performance Analysis

select staffs.staff_id,first_name,last_name,count(orders.order_id) as Total_handled_orders,
round(sum(total_price),2) as Total_revenue_generated from staffs
inner join orders on staffs.staff_id=orders.staff_id
inner join order_items on orders.order_id=order_items.order_id
group by staff_id,first_name,last_name;

# 9 - Stock Alert Query

select products.product_id,product_name,sum(quantity) as Total_stocks from stores
inner join stocks on stores.store_id=stocks.store_id
inner join products on stocks.product_id=products.product_id
group by product_id,product_name
having sum(quantity) < 10;

# 10 - Final Segmentation Table

select * from customer_segments;

alter table customer_segments add column type_of_segments varchar(50);

update customer_segments
set type_of_segments = case
							when segment = 0 then 'at_risk'
                            when segment = 1 then 'loyal'
                            when segment = 2 then 'new'
                            when segment = 3 then 'need_attention'
                            else type_of_segments
						end
					where segment in (3,2,1,0);
		


