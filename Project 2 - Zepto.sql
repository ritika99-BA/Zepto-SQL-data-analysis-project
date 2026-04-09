CREATE DATABASE zepto_sql_project,

USE zepto_sql_project;
DROP TABLE IF EXISTS zepto;
CREATE TABLE zepto (
             sku_id INT auto_increment PRIMARY KEY,
             category varchar(120),
             name varchar(150) NOT NULL,
             mrp DECIMAL(8,2),
             discountpercent DECIMAL(5,2),
             availableQuantity INT,
             discountedSellingPrice DECIMAL(8,2),
             weightInGms INT,
             outOfStock boolean,
             quantity INT
		);
        
	-- Sample data
        USE zepto_sql_project;
        SELECT * 
        FROM zepto;
        
-- DATA CLEANING 
	-- 1.(Null Values)

SELECT * 
FROM zepto 
WHERE 
     category IS NULL
     OR
     name IS NULL
     OR
     mrp IS NULL
     OR
     discountpercent IS NULL
     OR
     availableQuantity IS NULL
     OR
     discountedSellingPrice IS NULL
     OR
     weightInGms IS NULL
     OR
     outOfStock IS NULL
     OR
     quantity IS NULL;
     
     SELECT COUNT(*) FROM zepto;
     
-- 2.(Checking if the price is zero)
      SELECT * 
      FROM zepto 
      WHERE 
           mrp = 0 
           OR 
           discountedSellingPrice = 0;
           
	SET SQL_SAFE_UPDATES = 0;
    
    DELETE FROM zepto 
    WHERE mrp = 0;
       
    
-- 3. Converting paise to rupees
     UPDATE zepto
     SET mrp = mrp/100.0,
     discountedSellingPrice = discountedSellingPrice/100.0;
     
     SELECT * 
     FROM zepto;
	
     
-- DATA EXPLORATION 
	-- 1.(PRODUCT CATEGORIES)
     
     SELECT DISTINCT(category)
     FROM zepto;

	-- 2. Products In stock Vs Out of Stock (Note: 1 = TRUE = product is out of stock ;0 = FALSE = product is in stock)
	
    SELECT outOfStock,
           count(sku_id)
	FROM zepto
    GROUP BY outOfStock;
    
    -- 3. Products names present multiple times
    SELECT name, count(sku_id) AS 'No. od SKUs'
    FROM zepto
    GROUP BY name
    HAVING count(sku_id)>1
    ORDER BY count(sku_id) DESC;
    
-- BUSINESS PROBLEMS:
	-- Q1. Find the top 10 best-value products based on the discount percentage.
		SELECT name,
               mrp,
               discountpercent
        FROM zepto
        ORDER BY discountpercent DESC
        LIMIT 10;
        
	-- Q2. What are the products with High MRP but are Out of Stock?
		SELECT distinct(name),
               mrp,
               outOfStock
        FROM zepto
        WHERE mrp > 300 AND outOfStock = 1
        order by mrp DESC;
        
    -- Q3. Calculate estimated revenue for each category.
			SELECT category,
				   SUM(discountedSellingPrice*availableQuantity) AS totalrevenue
			FROM zepto
			GROUP BY category
            ORDER BY totalrevenue;
    
    -- Q4. Find all the products where MRP is greater than Rs. 500 and discount is less than 10%.
			SELECT DISTINCT(name),
				   mrp,
                   discountpercent
			FROM zepto
            WHERE mrp>500 AND discountpercent <10
            ORDER BY mrp DESC, discountpercent DESC;
    -- Q5. Identify the top 5 categories offering the highest average discount price. 
			SELECT DISTINCT(category),
				   avg(discountpercent) AS avg_discount
			FROM zepto
            GROUP BY category
            ORDER BY avg_discount DESC
            LIMIT 5;
            
    -- Q6. Find the price per gram for products above 100g and sort by best value. 
			SELECT DISTINCT(name),
				   weightInGms,
                   discountedSellingPrice,
                   ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
            FROM zepto
            WHERE weightInGms >= 100
            ORDER BY price_per_gram ;
            
    -- Q7. Group the products into categories like low,medium,bulk.
			SELECT DISTINCT(name),
				   weightInGms,
		           CASE 
					 WHEN weightInGms < 1000 THEN 'low'
					 WHEN weightInGms < 5000 THEN 'medium'
					 ELSE 'bulk'
				
					END AS weight_category
			FROM zepto;
    -- Q8. What is the Total Inventory Weight Per Category. 
			SELECT category,
				   SUM(weightInGms*availablequantity) AS totalweight
			FROM zepto 
            GROUP BY category
            ORDER BY totalweight;
             