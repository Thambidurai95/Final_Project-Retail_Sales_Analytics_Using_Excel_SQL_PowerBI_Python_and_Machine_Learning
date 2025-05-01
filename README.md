# Final Project - Retail Sales Analytics Using Excel SQL PowerBI Python and Machine Learning

# Phase 1: Excel – Data Cleaning & Preparation

**1) Standardize Column Headers**

    snake_case header format

**2) Remove Duplicates**

    No duplicate records found

**3) Handle Missing Values**

    NULL values replaced by NA

**4) Data Type Conversion**

    * Converted dates to standard excel date format
    * Numerical fields are converted to number formats
    * Text fields are converted to text formats

**5) Data Validation**

    Dropdown created for order status with options delivered, shipped, processing, packed

**6) Create New Derived Columns**

    Total price calculates through the below-mentioned formula from the available data
             * Total_price = (list_price * quantity) / discount

**7) Merge Lookup Data**

    Product names merged to order_items dataset using VLOOKUP formula

**8) Create Basic Pivot Table**

    Pivot table created to summarize the total sales by each category

**9) Sort and Filter for Outliers**

    Created filter option and highlighted the products with very high price of above 10000/- using conditional formatting

**10) Prepare Final CSVs**

    * Prepared the final cleaned datasets in CSV file format to import in SQL
    * Dataset attached here in the name of Overall Dataset for reference

# Phase 2: SQL – Database Management and Querying

**1) Create Tables Based on ERD**

![Final Project - ER Diagram Snapshot](https://github.com/user-attachments/assets/472ef639-53fb-41f1-b2d4-93601cd634fc)

**2) Import CSVs into SQL**

![image](https://github.com/user-attachments/assets/d877a4fd-c06c-46e9-86e1-f57f456e7312)

**3) Inner Join for Order Details**

    select orders.order_id,customer_id,order_items.item_id,order_items.product_id,products.product_name,order_items.category_name,
    order_items.quantity,order_items.list_price,order_items.discount,order_items.total_price,orders.order_status from orders 
    inner join order_items on orders.order_id=order_items.order_id
    inner join products on order_items.product_id=products.product_id;

**4) Total Sales by Store**

    select stores.store_id,store_name,round(sum(total_price),2) as Total_sales from stores
    inner join orders on stores.store_id=orders.store_id
    inner join order_items on orders.order_id=order_items.order_id
    group by store_id,store_name;

**5) Top 5 Selling Products**

    select product_id,product_name,sum(quantity) as Total_quantities_sold from order_items
    group by product_id,product_name
    order by Total_quantities_sold desc
    limit 5;

**6) Customer Purchase Summary**

    select customers.customer_id,first_name,last_name,count(distinct orders.order_id) as Total_orders,sum(item_id) as Total_items,
    round(sum(total_price),2) as Total_revenue from customers 
    inner join orders on customers.customer_id=orders.customer_id 
    inner join order_items on orders.order_id=order_items.order_id
    group by customer_id,first_name,last_name;

**7) Segment Customers by Total Spend**

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

**8) Staff Performance Analysis**

    select staffs.staff_id,first_name,last_name,count(orders.order_id) as Total_handled_orders,
    round(sum(total_price),2) as Total_revenue_generated from staffs
    inner join orders on staffs.staff_id=orders.staff_id
    inner join order_items on orders.order_id=order_items.order_id
    group by staff_id,first_name,last_name;

**9) Stock Alert Query**

    select products.product_id,product_name,sum(quantity) as Total_stocks from stores
    inner join stocks on stores.store_id=stocks.store_id
    inner join products on stocks.product_id=products.product_id
    group by product_id,product_name
    having sum(quantity) < 10;

**10) Create Final Segmentation Table**

    * Customer segments table was exported directly from Python ML to MySQL
    * Dataset attached here in the name of Overall Dataset for reference

