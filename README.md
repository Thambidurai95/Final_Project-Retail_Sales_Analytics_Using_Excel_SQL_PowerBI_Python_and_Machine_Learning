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

    Created filter option and highlighted the products with the very high price of above 10000/- and low price below 200/- using conditional formatting

**10) Prepare Final CSVs**

    * Prepared the final cleaned datasets in CSV file format to import in SQL
    * Dataset attached here in the name of Overall Dataset for reference

# Phase 2: SQL – Database Management and Querying

**1) Create Tables Based on ERD**

![Final Project - ER Diagram Snapshot](https://github.com/user-attachments/assets/7b096837-82c4-4417-80ad-5a5353a01cb3)

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

# Phase 3: Python and ML Tasks

**1) Load Data from SQL**

Installed and imported the required libraries in Python

    * pymysql.connect(host='127.0.0.1',user='root',passwd='password2924')
    * pd.read_sql_query("select * from final_project.customers",myconnection)
    * pd.read_sql_query("select * from final_project.orders",myconnection)
    * pd.read_sql_query("select * from final_project.order_items",myconnection)

**2) Basic EDA (Exploratory Data Analysis)**

Summarized the datatsets through df.describe(), df.info(), df.value_counts()

 **Customers**

    * print(customers_df.describe())
    * print(customers_df.info())
    * print(customers_df.value_counts())
     
 **Orders**
 
    * print(orders_df.describe())
    * print(orders_df.info())
    * print(orders_df.value_counts())
 
 **Order Items**
    
    * print(order_items_df.describe())
    * print(order_items_df.info())
    * print(order_items_df.value_counts())

 **Bar Chart**

    *  order_items_df.groupby(["category_name"]).agg(total_revenue = ("total_price","sum")).sort_values("total_revenue",ascending = [True]).reset_index()
    *  category_revenue.plot(kind="bar",x="category_name",y="total_revenue",color="black")

 ![image](https://github.com/user-attachments/assets/53e1a49b-ffab-4fda-bf9b-f35d62d36b0a)

 **Pie Chart**

    * orders_df.groupby(["order_status"]).agg(Total = ("order_status","count")).sort_values("Total",ascending =[False]).reset_index()
    * order_status_count.plot(kind="pie",x="order_status",y="Total",color="black")

![image](https://github.com/user-attachments/assets/f53377e4-99c6-4aa3-bf4f-2d20f65daffc)

**Line Chart**

    * pd.merge(customers_df,orders_df,on="customer_id")
    * customer_orders.groupby(["state"]).agg(total_orders = ("order_id","count")).reset_index()
    * plt.plot(state_orders["state"],state_orders["total_orders"])
      plt.xlabel("state")
      plt.ylabel("total_orders")
      plt.title("Total Orders Per State")
      plt.show()

![image](https://github.com/user-attachments/assets/5c84faad-bd08-4cd2-a9bf-9496307f886c)

**3) Calculate RFM Features for Customers**

Recency, Frequency and Monetary calculated for each customer by merging the datasets

    * pd.merge(orders_df,order_items_df,on='order_id')
    * pd.merge(merged_orders,customers_df,on='customer_id')
    * merged_dataset['order_date'].max() + pd.Timedelta(days=1)
    * merged_dataset.groupby('customer_id').agg({
      'order_date':lambda x: (freezed_date- x.max()).days, 
      'order_id':'nunique', 
      'total_price':'sum' 
      }).reset_index()
    * rfm.columns = ['customer_id','recency','frequency','monetary']

**4) Customer Segmentation using KMeans (Basic Clustering)**

**Normalized RFM using MinMaxScaler**

    * MinMaxScaler().fit_transform(rfm[['recency','frequency','monetary']])
    
**Applied KMeans to segment customers into 4 groups**

    * KMeans(n_clusters=4,random_state=40)
    * kmeans = KMeans(n_clusters=4,random_state=40)
    * rfm['segment'] = kmeans.fit_predict(rfm_normalized)
    * print(rfm['segment'].value_counts()

**Scatter Plot**

![image](https://github.com/user-attachments/assets/7ab6fbb3-86c7-4fdd-abb5-e33c3d892b51)

**5) Export Segmentation Results to SQL**

    * create_engine('mysql+pymysql://root:password2924@127.0.0.1/final_project')
    * rfm.to_sql('customer_segments',engine,if_exists='replace',index=False)

**Customer Segments Table - Type of Segments in MySQL**

    * alter table customer_segments add column type_of_segments varchar(50);
    * update customer_segments
          set type_of_segments = case
              when segment = 0 then 'at_risk'                            
              when segment = 1 then 'loyal'                            
              when segment = 2 then 'new' 
              when segment = 3 then 'need_attention'                          
              else type_of_segments
          end
      where segment in (3,2,1,0);

**Sample customer segments data from the dataset**

![image](https://github.com/user-attachments/assets/d1a3a914-71a0-4311-8ef1-c90d2c72dbec)

# Phase 4: Power BI – Visualization & Dashboarding

**Home Page**

![image](https://github.com/user-attachments/assets/ac99b452-dcc2-4372-ae2a-3fe14db5d700)

**1) Connect Power BI to SQL**

    Connected the Power BI with MySQL database and imported the datasets.

**2) Create Relationships Between Tables**

![image](https://github.com/user-attachments/assets/52f4e639-86b8-44cf-9fab-9c1ecb5c99b6)

**3) Sales Overview Report**

 **Sales Over Time**
 
![image](https://github.com/user-attachments/assets/968241c6-1922-4d45-9b6a-9ae3e06eb0c2)

 **Monthly Sales Trend**
 
![image](https://github.com/user-attachments/assets/d0e9f82e-40d1-40e9-9d72-4731255697ff)

 **Total Orders Placed**
 
![image](https://github.com/user-attachments/assets/8b86b0e1-2871-42b4-85a0-7082ed345e8e)

**4) Top Products by Sales**

![image](https://github.com/user-attachments/assets/b56df44b-4529-4ce5-b772-e711a710902d)

**5) Customer Purchase Analysis**

![image](https://github.com/user-attachments/assets/6072d9bb-0a54-4544-802c-f9cb55cf862b)

**6) Sales by Store Map**

![image](https://github.com/user-attachments/assets/bfc4fd29-f190-4beb-8e08-a50636984224)

**7) Low Stock Alert Dashboard**

![image](https://github.com/user-attachments/assets/8fd9437b-2e4d-4c3f-90a9-c2c8c56cd65d)

**8) Interactive Filters and Slicers**

![image](https://github.com/user-attachments/assets/27a88da7-cb32-41dd-b4c7-6e883e74d316)

**9) Staff Performance Report**

![image](https://github.com/user-attachments/assets/25f9db24-4096-4948-b238-6c2d523f3382)

**10) Consolidated Dashboard Page**

![image](https://github.com/user-attachments/assets/0ab2ba82-f2b2-4a2b-9c36-f480dbbb3658)

**11) Import customer_segments Table**

    * Imported the segmentation table from MySQL to Power BI
    * Dataset attached here in the name of Overall Dataset for reference

**12) Visualize Customer Segments**

![image](https://github.com/user-attachments/assets/4c9b7cc4-a184-4165-b86b-a27d73c05a83)

**13) Segment-Level Revenue Breakdown**

![image](https://github.com/user-attachments/assets/68843d3e-c3f5-415b-ac3c-2e93e78be3c5)

**14) Use Segments as Report Filters**

    Interactive slicers are created to filter across dashboards for the customer_segments

**15) Segment Heatmap**

![image](https://github.com/user-attachments/assets/c5c49c30-6445-407e-b096-786e96f48af0)

