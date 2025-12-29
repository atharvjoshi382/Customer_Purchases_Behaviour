create database project;
use project;
show databases;
show tables ;

select count(*)from shopping;
  ALTER TABLE shopping ADD COLUMN age_group VARCHAR(100);
SELECT count(* ) as total_records FROM shopping;
select * from shopping limit 20;
#---1. what is the total number of customers in each group ?
select age_group , count(id) as Total_Customers from shopping 
group by age_group order by Total_customers desc;

#---2. what is total amount of purchase done by male vs female
select gender , sum(purchase_amount) as Purchase_Amount
from shopping group by gender;

#--3. What are the Product category preference by gender?
select gender, product_category, count(*) as Purchase_Count
from shopping group by product_category , gender order by gender, Purchase_Count Desc;
#OR this method will give the Rank 
SELECT gender,product_category,purchase_count
FROM (
    SELECT gender,product_category,COUNT(*) AS purchase_count,
        RANK() OVER (
            PARTITION BY gender
            ORDER BY COUNT(*) DESC
        ) AS rnk
    FROM shopping
    GROUP BY gender, product_category
) t
WHERE rnk = 1;

#--- 4. what is the average purchase amount by age_group ?
select age_group, avg(purchase_amount) as Total_Revenue 
from shopping group by age_group order by Total_Revenue desc; 

#---5. what are the top product that got highest satisfaction rate
select product_category, avg(satisfaction_score) as Avg_Satisfaction 
from shopping group by product_category order by Avg_Satisfaction Desc;

#---6. what is the avg purchase amount by loyalty_status
select loyalty_status, avg(purchase_amount) as Avg_Purcahse_Amount
from shopping group by loyalty_status order by Avg_Purcahse_Amount desc ;

#---7. do loyal customer purcahse more 
select loyalty_status , purchase_frequency,count(*) as Total_Customer from shopping 
group by loyalty_status,purchase_frequency order by Total_Customer desc ; 
#or to get the percentage answer
select loyalty_status , sum(case when purchase_frequency = "frequent" then 1 else 0 end)*100/count(*) as frequent_customer_percentage 
from shopping group by loyalty_status;
#Loyalty status does not meaningfully increase purchase frequency.

#---8. what are the top 5 category by revenue region wise 
select product_category, region, sum(purchase_amount ) as Total_Revenue 
from shopping group by product_category, region order by Total_Revenue desc limit 5;

#---9. Which region should marketing focus on based on avg purchase amount and purchase frequency?
select region,purchase_frequency, avg (purchase_amount) as Avg_spend
from shopping group by region, purchase_frequency order by Avg_spend desc;

#---10. Are highly educated customers more brand-loyal?
select education, loyalty_status ,count(*) as loyalty_count ,
count(*)*100/ sum(count(*)) over( partition by education) as Loyalty_percentage
from shopping group by education, loyalty_status order by Loyalty_percentage desc;

#---11. Does education indirectly affect purchase amount via income?**
select education, count(*) as customers, avg(income) as Avg_income, avg(purchase_amount) as Avg_purchase, 
sum(purchase_amount) as total_purchase from shopping group by education order by Avg_income desc;

#---12. How does age influence purchase frequency and spending?*******
select age,age_group, avg(case when purchase_frequency="frequent" then 3
  when purchase_frequency = "occasional" then 2
  when purchase_frequency= "rare" then 1
  end) as Avg_purchase_frequency_score
  , avg(purchase_amount) as Avg_Spending 
  from shopping group by age, age_group order by Avg_purchase_frequency_score,Avg_Spending desc ;

#---13. are loyal customers more responsive to promotions.
SELECT 
    loyalty_status,
    COUNT(*) AS Total_Customers,
    SUM(promotion_usage = 1) AS Promotion_Users,
    SUM(promotion_usage = 1) * 100.0 
        / COUNT(*) AS promotion_Response_Rate
FROM shopping
GROUP BY loyalty_status;
#as diff is negligible in silver and regular No, loyal customers are not significantly more responsive to promotions. Promotion usage appears independent of loyalty status.


