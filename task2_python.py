import pandas as pd

#Read the CSV files
customers_df = pd.read_csv('customers.csv') 
products_df = pd.read_csv('products.csv') 
orders_df = pd.read_csv('orders.csv')

#Remove duplicate customer records
customers_clean = customers_df.drop_duplicates()

#Find orders with customer IDs that do not exist in the customers file 
valid_customer_ids = set(customers_clean['customer_id']) 
orphan_orders = orders_df[~orders_df['customer_id'].isin(valid_customer_ids)] 
print("Orders with non-existent customer IDs (Orphan orders):") 
print(orphan_orders)

#Join orders with customer and product details 
valid_orders = orders_df[orders_df['customer_id'].isin(valid_customer_ids)].copy()  
merged_df = valid_orders.merge(customers_clean, on='customer_id', how='inner')   
final_df = merged_df.merge(products_df, on='product_id', how='inner')

#Calculate total_amount = quantity * price  
final_df['total_amount'] = final_df['quantity'] * final_df['price']

#Select and reorder columns for final output expected format
output_columns = ['order_id','customer_name','city','product_name','quantity','price','status','total_amount']  
final_orders = final_df[output_columns]

#Save the valid order details into final_orders.csv 
final_orders.to_csv('final_orders.csv', index=False) 
print("\nFinal processed orders saved to final_orders.csv successfully.") 
print(final_orders)