
----------- PROBLEM STATMENT - ANSWER QUERY's -----------

-- The Sum of the Total Revenue :
SELECT 
	ROUND(SUM(total_price), 2) AS TotalRevenue
FROM [AyoubPortfolio].[dbo].[pizza_sales];

-- The Average of the Total Revenue :
SELECT 
	ROUND(SUM(total_price) / COUNT(DISTINCT order_id), 2) AS AverageOrderValue
FROM [AyoubPortfolio].[dbo].[pizza_sales];

-- The Total of the Pizza Sold :
SELECT 
	SUM(quantity) AS TotalPizzaSold
FROM [AyoubPortfolio].[dbo].[pizza_sales];

-- The Sum of the Total Orders :
SELECT 
	COUNT(DISTINCT order_id) AS TotalOrders
FROM [AyoubPortfolio].[dbo].[pizza_sales];

-- The Average Pizzas Per Order :
SELECT 
	CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL (10,2)) AS AveragePizzaOrder
FROM [AyoubPortfolio].[dbo].[pizza_sales];

-- The Daily Total Orders From Monday to Sunday Ascending  (for trend chart):
SELECT 
    DATENAME(DW, order_date) as OrderDay, 
    COUNT(DISTINCT order_id) AS TotalOrders
FROM [AyoubPortfolio].[dbo].[pizza_sales]
GROUP BY DATENAME(DW, order_date)
ORDER BY CASE 
            WHEN DATENAME(DW, order_date) = 'Monday' THEN 1
            WHEN DATENAME(DW, order_date) = 'Tuesday' THEN 2
            WHEN DATENAME(DW, order_date) = 'Wednesday' THEN 3
            WHEN DATENAME(DW, order_date) = 'Thursday' THEN 4
            WHEN DATENAME(DW, order_date) = 'Friday' THEN 5
            WHEN DATENAME(DW, order_date) = 'Saturday' THEN 6
            ELSE 7 -- Sunday
        END;

-- Hourly Orders From 9AM to 11PM :
SELECT 
	DATEPART(HOUR, order_time) AS OrderHours,COUNT(DISTINCT order_id) AS TotalOrders
FROM [AyoubPortfolio].[dbo].[pizza_sales]
GROUP BY DATEPART(HOUR, order_time)
ORDER BY DATEPART(HOUR, order_time);

-- Percentage of Sales By Pizza Category + Month Filter :

SELECT 
    pizza_category AS PizzaCategory,
    ROUND(SUM(total_price), 0) AS TotalSales,
    ROUND(SUM(total_price) * 100.0 / (SELECT SUM(total_price) FROM [AyoubPortfolio].[dbo].[pizza_sales] WHERE MONTH(order_date) = 1), 2) AS TotalSalesPrct
FROM [AyoubPortfolio].[dbo].[pizza_sales]
WHERE MONTH(order_date) = 1 -- Change '1' to select another month 1 to 12 = January to December 
GROUP BY pizza_category;

-- Pecentage of Sales By Pizza Size + Month Filter :

SELECT 
    pizza_size AS PizzaSize,
    ROUND(SUM(total_price), 0) AS TotalSales,
    ROUND(SUM(total_price) * 100.0 / (SELECT SUM(total_price) FROM [AyoubPortfolio].[dbo].[pizza_sales] WHERE DATEPART(quarter, order_date) = 2), 2) AS TotalSalesPrct
FROM [AyoubPortfolio].[dbo].[pizza_sales]
WHERE DATEPART(quarter, order_date) = 3
GROUP BY pizza_size
ORDER BY TotalSalesPrct DESC;

-- Total Pizzas Sold By Pizza Category :
SELECT 
	pizza_category AS PizzaCategory, SUM(quantity) AS TotalPizzasSold
FROM [AyoubPortfolio].[dbo].[pizza_sales]
GROUP BY pizza_category
ORDER BY TotalPizzasSold DESC;

-- Top 5 Best Sellers By Total Pizzas Sold :
SELECT TOP 5
	pizza_name AS PizzaName, SUM(quantity) AS TotalPizzasSold
FROM [AyoubPortfolio].[dbo].[pizza_sales]
GROUP BY pizza_name
ORDER BY TotalPizzasSold DESC;

-- Top 5 Worst Sellers By Total Pizzas Sold + Month Filter :
SELECT TOP 5
	pizza_name AS PizzaName, SUM(quantity) AS TotalPizzasSold
FROM [AyoubPortfolio].[dbo].[pizza_sales]
WHERE MONTH(order_date) = 1
GROUP BY pizza_name
ORDER BY TotalPizzasSold ASC;

