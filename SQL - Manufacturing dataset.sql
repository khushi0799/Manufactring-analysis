CREATE DATABASE Manufacturing_db;
USE Manufacturing_db;

CREATE TABLE Manufacturing_data (
    `Doc Date` DATE,
    `Buyer Name` VARCHAR(100),
    `Customer Name` VARCHAR(100),
    `Department Name` VARCHAR(100),
    `Designer Name` VARCHAR(100),
    `Emp Name` VARCHAR(100),
    `Machine Code` VARCHAR(50),
    `Manufactured qty` INT,
    `Rejected Qty` INT,
    `Processed Qty` INT,
    `Wastage Qty` INT,
    `Repeat` INT
);
SELECT * FROM Manufacturing_data;

-- 1. Total_Manufactured_Qty
SELECT SUM(`Manufactured qty`) AS Total_Manufactured_Qty
FROM manufacturing_data;

-- 2.Total_Rejected_Qty
SELECT SUM(`Rejected Qty`) AS Total_Rejected_Qty
FROM manufacturing_data;

-- 3.Total_Processed_Qty
SELECT SUM(`Processed Qty`) AS Total_Processed_Qty
FROM manufacturing_data;

-- 4.Total_Wastage_Qty
SELECT SUM(`Wastage Qty`) AS Total_Wastage_Qty
FROM manufacturing_data;

-- 5.Employee Wise Rejected Qty
SELECT (`Emp Name`), SUM(`Rejected Qty`) AS Total_Rejected_Qty
FROM manufacturing_data
GROUP BY (`Emp Name`)
ORDER BY Total_Rejected_Qty DESC;

-- 6.Machine Wise Rejected Qty
SELECT (`Machine Code`), SUM(`Rejected Qty`) AS Total_Rejected_Qty
FROM manufacturing_data
GROUP BY (`Machine Code`)
ORDER BY Total_Rejected_Qty DESC;

-- 7.Rejection_Percentage
SELECT SUM(`Manufactured qty`) AS Total_Manufactured,
SUM(`Rejected Qty`) AS Total_Rejected,
(SUM(`Rejected Qty`) * 100.0 / SUM(`Manufactured qty`)) AS Rejection_Percentage
FROM manufacturing_data;
	
-- 8.Department Wise Manufacture Vs Rejected
SELECT (`Department Name`),
SUM(`Manufactured qty`) AS Total_Manufactured,
SUM(`Rejected Qty`) AS Total_Rejected,
(SUM(`Rejected Qty`) * 100.0 / SUM(`Manufactured qty`)) AS Rejection_Percentage
FROM manufacturing_data
GROUP BY (`Department Name`)
ORDER BY Rejection_Percentage DESC;

-- 9.Top performing employees based on least rejection percentage.
SELECT 
(`Emp Name`),
SUM(`Manufactured qty`) AS Total_Manufactured,
SUM(`Rejected Qty`) AS Total_Rejected,
(SUM(`Rejected Qty`) * 100.0 / NULLIF(SUM(`Manufactured qty`),0)) AS Rejection_Percentage,
RANK() OVER (ORDER BY (SUM(`Rejected Qty`) * 1.0 / NULLIF(SUM(`Manufactured qty`),0)) ASC) AS Performance_Rank
FROM manufacturing_data
GROUP BY (`Emp Name`)
ORDER BY Performance_Rank;

-- 10.Count total orders and repeat orders.
SELECT 
COUNT(*) AS Total_Orders,
COUNT(CASE WHEN `Repeat` > 0 THEN 1 END) AS Repeat_Orders,
(COUNT(CASE WHEN `Repeat` > 0 THEN 1 END) * 100.0 / COUNT(*)) AS Repeat_Order_Percentage
FROM manufacturing_data;

-- 11.ERROR HANDLING 
DELIMITER $$

CREATE PROCEDURE Error_Handling()
BEGIN
    -- Error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'An error occurred while executing the procedure.' AS ErrorMessage;
    END;

    -- Example query
    SELECT 
        `Department Name`,
        SUM(`Manufactured qty`) AS Total_Manufactured,
        SUM(`Rejected Qty`) AS Total_Rejected,
        (SUM(`Rejected Qty`) * 100.0 / NULLIF(SUM(`Manufactured qty`),0)) AS Rejection_Percentage
    FROM manufacturing_data
    GROUP BY `Department Name`;
END$$

DELIMITER ;

CALL Error_Handling();