import pandas as pd
df= pd.read_excel('customer_data.csv.xlsx')
print(df.head())#print the columns of the data 
print(df.info())
print(df.describe())# print the summary of the data only thye numeric value
print(df.describe(include='all'))# print the summary of the data with the text values also 
print(df.isnull().sum()) #show the null values in the column  
# If we found the null value and we have to reomve it then like take an example that review rating have null value and we have to put median value in it then coding would be df['review rating']=df.groupby('category')['reviw rating'].transform(lamba x: x.fillna(x.median())) then chech the any null value remained
print(df.columns ==df.columns.str.lower())#it will do the column in lower case
print(df.columns ==df.columns.str.replace(' ','_'))#it will replace the blank with _

print(df.columns)
#create the age bucket
labels =['Young Adult','Adult','Middle-Aged','Senior']
df['age_group'] = pd.qcut(df['age'],q=4,labels=labels) 
print(df[['age','age_group']].head(20))
print(df.head(25))
#to remov the column df = df.drop('promo_code_used',axis=1)










import mysql.connector
from mysql.connector import Error




# Step 2: Database connection
try:
    mydb = mysql.connector.connect(
        host="localhost",
        user="root",
        password="root@123",
        database="project"
    )
    mycursor = mydb.cursor()
    
    # Step 3: Create table (if not exists)
    create_table = """
    CREATE TABLE IF NOT EXISTS shopping (
        id INT,
        age INT,
        gender VARCHAR(100),
        income INT,
        education VARCHAR(100),
        region VARCHAR(100),
        loyalty_status VARCHAR(100),
        purchase_frequency VARCHAR(100),
        purchase_amount INT,
        product_category VARCHAR(100),
        promotion_usage INT,
        satisfaction_score INT
        
    )
    """

    
    mycursor.execute(create_table)


    
    print("Table ready!")
    
    mycursor.execute("SHOW COLUMNS FROM shopping LIKE 'age_group'")
    if not mycursor.fetchone():
        mycursor.execute("ALTER TABLE shopping ADD COLUMN age_group VARCHAR(100)")
        print("Added age_group column")
    
    # FIX 2: Select EXACT columns in EXACT order
    columns = ['id', 'age', 'gender', 'income', 'education', 'region', 
               'loyalty_status', 'purchase_frequency', 'purchase_amount', 
               'product_category', 'promotion_usage', 'satisfaction_score', 'age_group']
    data_to_insert = [tuple(row[columns]) for _, row in df.iterrows()]
    # Step 4: Insert data (batch insert for efficiency)
    insert_query = """
    INSERT INTO shopping (id, age, gender, income, education, region, loyalty_status, 
                         purchase_frequency, purchase_amount, product_category, 
                         promotion_usage, satisfaction_score, age_group)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    
    # Prepare data in chunks for large datasets
    data_to_insert = [tuple(row) for _, row in df.iterrows()]
    
    mycursor.executemany(insert_query, data_to_insert)
    mydb.commit()
    
    print(f"Successfully inserted {mycursor.rowcount} rows!")
    
except Error as e:
    print(f"Error: {e}")
    
finally:
    if mydb.is_connected():
        mydb.close()
        mycursor.close()
        print("Database connection closed.")










    
