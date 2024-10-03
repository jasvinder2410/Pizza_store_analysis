create database pizza;

use pizza;

-- https://github.com/Ayushi0214/pizza-sales---SQL/blob/main/Questions.txt (questions link)

-- 1. Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS Total_orders
FROM
    order_details;

-- 2. Calculate the total revenue generated from pizza sales.
SELECT 
    SUM(price * quantity) AS Total_revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;

-- 3. Identify the highest-priced pizza.
SELECT 
    name, price
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY price DESC
LIMIT 1;

-- 4. Identify the most common pizza size ordered.
SELECT 
    size, Count(order_id) AS Order_Count
FROM
    pizzas
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY size
ORDER BY Order_Count DESC;

-- 5. List the top 5 most ordered pizza types along with their quantities.
SELECT 
    name, SUM(quantity) AS Total_orders
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY name
ORDER BY Total_orders DESC
LIMIT 5;

-- 6. Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    category, SUM(quantity) AS Total_Quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY category
ORDER BY Total_Quantity DESC;

-- 7. Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(time) Hour_of_day,
    AVG(o.order_id) Avg_Customers_Served,
    AVG(quantity) Avg_Pizzas_Dispatched
FROM
    orders o
        JOIN
    order_details ON o.order_id = order_details.order_id
GROUP BY Hour_of_day
ORDER BY Hour_of_day;

-- 8. Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, SUM(quantity) Distribution
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY category
ORDER BY Distribution DESC;

-- 9. Group the orders by date and calculate the average number of pizzas ordered per day.
with Orders as(
SELECT 
    date, SUM(quantity) Quantity_Sold
FROM
    orders
        JOIN
    order_details ON orders.order_id = order_details.order_id
GROUP BY date)
SELECT 
    ROUND(AVG(Quantity_Sold)) Avg_Pizzas_Ordered_Per_Day
FROM
    Orders;
    
-- 10. Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    Name, COUNT(order_id) Total_Orders
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY Name
ORDER BY Total_Orders DESC
LIMIT 3;

-- 11. Calculate the percentage contribution of each pizza type to total revenue.
with Revenue as
(SELECT 
    Name, SUM(price * quantity) Revenue_Generated
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY Name)
SELECT 
    Name,
    ROUND(Revenue_Generated / (SELECT 
                    SUM(Revenue_Generated)
                FROM
                    Revenue) * 100) AS Contribution_In_Revenue
FROM
    Revenue
ORDER BY Contribution_In_Revenue DESC;

-- 12. Analyze the cumulative revenue generated over time.
SELECT Order_Date, ROUND(Revenue), ROUND(SUM(Revenue) OVER(ORDER BY Order_Date)) AS cumulative_REvenue FROM
(SELECT 
    Date AS Order_Date, SUM(price * quantity) Revenue
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
        JOIN
    orders ON order_details.order_id = orders.order_id
GROUP BY Date) AS Revenue;

-- 13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
WITH Revenue_status AS (
    SELECT 
        Category, 
        name, 
        SUM(price * quantity) AS Revenue, 
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY SUM(price * quantity) DESC) AS Position
    FROM 
        pizza_types 
    JOIN 
        pizzas 
        ON pizza_types.pizza_type_id = pizzas.pizza_type_id 
    JOIN 
        order_details 
        ON pizzas.pizza_id = order_details.pizza_id 
    GROUP BY 
        Category, name
)
SELECT 
    Category, 
    Name, 
    Revenue 
FROM 
    Revenue_status 
WHERE 
    Position <= 3;

-- 13. How may varities in each categories
SELECT 
    Category, COUNT(pizza_id) Varities
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY category; 

-- 14. Quantities sold of each category 
SELECT 
    category, SUM(Quantity) Quantity_Sold
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY category
ORDER BY Quantity_Sold DESC;