CREATE TABLE Swiggy_dummy_dataset (
    Order_ID INT PRIMARY KEY,
    City VARCHAR(100),
    Restaurant VARCHAR(100),
    Dish VARCHAR(100),
    Customer_ID INT,
    Order_Date DATE,
    Delivery_Partner_ID INT,
    Delivery_Time_Minutes INT,
    Order_Amount DECIMAL(10, 2),
    Customer_Rating DECIMAL(2, 1),
    Order_Status VARCHAR(50),
    Is_On_Time BOOLEAN
);
SELECT * FROM swiggy_dummy_dataset
--1. What is the average delivery time and average customer rating for each city?
SELECT City, 
       AVG(Delivery_Time_Minutes) AS Avg_Delivery_Time, 
       AVG(Customer_Rating) AS Avg_Rating
FROM Swiggy_dummy_dataset
GROUP BY City;

--2. Which restaurant had the highest average order amount in 2024?
SELECT Restaurant, 
       round(AVG(Order_Amount),2) AS Avg_Order_Amount
FROM Swiggy_dummy_dataset
WHERE EXTRACT(YEAR FROM Order_Date) = 2024
GROUP BY Restaurant
ORDER BY Avg_Order_Amount DESC
LIMIT 1;

--3. Find the number of orders delivered on time vs late for each delivery partner.
SELECT Delivery_Partner_ID, 
       SUM(CASE WHEN Is_On_Time THEN 1 ELSE 0 END) AS On_Time_Orders,
       SUM(CASE WHEN NOT Is_On_Time THEN 1 ELSE 0 END) AS Late_Orders
FROM Swiggy_dummy_dataset
GROUP BY Delivery_Partner_ID;

--4. Identify the top 3 most ordered dishes in terms of order count.
SELECT Dish, COUNT(*) AS Order_Count
FROM Swiggy_dummy_dataset
GROUP BY Dish
ORDER BY Order_Count DESC
LIMIT 3;
--5. Which city has the highest percentage of late deliveries?
SELECT City,
       round(100.0 * SUM(CASE WHEN NOT Is_On_Time THEN 1 ELSE 0 END) / COUNT(*),2) AS Late_Percentage
FROM Swiggy_dummy_dataset
GROUP BY City
ORDER BY Late_Percentage DESC
LIMIT 1;
--6. Show the monthly total revenue generated in 2024.
SELECT DATE_TRUNC('month', Order_Date) AS Month,
       SUM(Order_Amount) AS Total_Revenue
FROM Swiggy_dummy_dataset
WHERE EXTRACT(YEAR FROM Order_Date) = 2024
GROUP BY DATE_TRUNC('month', Order_Date)
ORDER BY Month;

--7. Which delivery partner has the lowest average delivery time?
SELECT Delivery_Partner_ID,
       round(AVG(Delivery_Time_Minutes),2) AS Avg_Delivery_Time
FROM Swiggy_dummy_dataset
GROUP BY Delivery_Partner_ID
ORDER BY Avg_Delivery_Time
LIMIT 1;

--8. Find customers who have given a rating below 2 more than once.
SELECT Customer_ID, COUNT(*) AS Low_Rating_Count
FROM Swiggy_dummy_dataset
WHERE Customer_Rating < 2
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

--9. List restaurants where the majority of their orders were not delivered on time.
SELECT Restaurant
FROM Swiggy_dummy_dataset
GROUP BY Restaurant
HAVING SUM(CASE WHEN Is_On_Time THEN 1 ELSE 0 END) < SUM(CASE WHEN NOT Is_On_Time THEN 1 ELSE 0 END);

--10. Find the top 5 customers by total spend and show their average rating.
SELECT Customer_ID,
       SUM(Order_Amount) AS Total_Spend,
       round(AVG(Customer_Rating),2) AS Avg_Rating
FROM Swiggy_dummy_dataset
GROUP BY Customer_ID
ORDER BY Total_Spend DESC
LIMIT 5;
