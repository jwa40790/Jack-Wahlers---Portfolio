

CREATE DATABASE WR_Sales;
USE WR_Sales;

CREATE TABLE new_table (
  Year INT NOT NULL,
  Month INT NULL,
  Supplier VARCHAR(100) NULL,
  Item_Code INT NULL,
  Item_Description VARCHAR(200) NULL,
  Item_Type VARCHAR(100) NULL,
  Retail_Sales INT NULL,
  Retail_Transfer INT NULL,
  Warehouse_Sales INT NULL,
  PRIMARY KEY (Year, Month, Item_Code)
);

-- loading csv file from files into Sales table
LOAD DATA LOCAL INFILE '/Users/jackwahlers/Downloads/Warehouse_and_Retail_Sales.csv'
INTO TABLE Sales
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(Year, Month, Supplier, Item_Code, Item_Description, Item_Type, Retail_Sales, Retail_Transfer, Warehouse_Sales);

-- making sure table is loaded
SELECT * FROM Sales
WHERE Month = 2;

-- Items that have no retail or warehouse sales
SELECT Item_Code, Item_Description FROM SALES 
WHERE Retail_Sales AND Warehouse_Sales = 0;

-- selects 25 top selling items for the year 2019
SELECT Item_Code, Item_Description, Item_Type, Retail_Sales FROM Sales
WHERE Year = 2019
ORDER BY Retail_Sales DESC
LIMIT 25;

-- percent of total sales that are retail
SELECT SUM(Retail_Sales) * 100 / SUM(Warehouse_Sales + Retail_Sales) AS Pecent_Retail_Sales
FROM Sales;

-- yearly running total
SELECT Year, Month, 
	SUM(Retail_Sales) AS Monthly_Sales,
	SUM(SUM(Retail_Sales)) OVER (PARTITION BY Year ORDER BY Month ASC) AS Running_Total
FROM Sales
GROUP BY Year, Month
ORDER BY Year, Month;

-- ranks each item based on highest total sales
SELECT Item_Code, Item_Description, Total_Sales,
    DENSE_RANK() OVER (ORDER BY Total_Sales DESC) AS `Rank`
FROM (
    SELECT Year, Item_Code, Item_Description, 
        SUM(Retail_Sales) AS Total_Sales
    FROM Sales
    GROUP BY Year, Item_Code, Item_Description
) AS ItemSales
ORDER BY `Rank`;
