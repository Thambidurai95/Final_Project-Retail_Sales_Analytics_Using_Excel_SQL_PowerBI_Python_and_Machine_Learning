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

    Dropdown created for order status with options delivered, shipped, processing, packed

**6) Customer Purchase Summary**

    Total price calculates through the below-mentioned formula from the available data
             * Total_price = (list_price * quantity) / discount

**7) Segment Customers by Total Spend**

    Product names merged to order_items dataset using VLOOKUP formula

**8) Staff Performance Analysis**

    Pivot table created to summarize the total sales by each category

**9) Stock Alert Query**

    Created filter option and highlighted the products with very high price of above 10000/- using conditional formatting

**10) Create Final Segmentation Table**

    * Prepared the final cleaned datasets in CSV file format to import in SQL
    * Dataset attached here in the name of Overall Dataset for reference

