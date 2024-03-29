-- 01 Find Book Titles

SELECT 
    `title`
FROM
    `book_library`.`books`
WHERE
    LEFT(`title`, 3) = 'The'
ORDER BY `id`;

-- 02 Replace Titles

SELECT 
    REPLACE(`title`, 'The', '***')
FROM
    `books`
WHERE
    SUBSTRING(`title`, 1, 3) = 'The'
ORDER BY `id`;

-- 03 Sum Cost of All Books

SELECT round(sum(`cost`), 2)  FROM `books`;

-- 04 Days Lived

SELECT 
    CONCAT_WS(' ', `first_name`, `last_name`) AS 'Full Name',
    TIMESTAMPDIFF(DAY, `born`, `died`) AS 'Days Lived'
FROM
    `authors`;
    
-- 05 Harry Potter Books
    
SELECT 
    `title`
FROM
    `books`
WHERE
    `title` LIKE '%Harry Potter%'
ORDER BY `id`;

# Built-in functions exercises

-- 01 Find Names of All Employees by First Name

SELECT 
	`first_name`, `last_name`
FROM 
	`employees`
WHERE 
	lower(SUBSTRING(`first_name`, 1, 2) = 'Sa')	
ORDER BY `employee_id`;

-- 02 Find Names of All Employees by Last Name

SELECT 
	`first_name`, `last_name`
FROM 
	`employees`
WHERE 
	lower(LEFT(`first_name`, 2) = 'Sa')	
ORDER BY `employee_id`;

-- 03 Find First Names of All Employees

SELECT 
	`first_name`, `last_name` 
FROM 
	`employees`
WHERE 
	lower(`last_name` LIKE '%ei%')
ORDER BY
	`employee_id`;
    
SELECT 
    `first_name`
FROM
    `employees`
WHERE
    `department_id` IN (3 , 10)
        AND YEAR(`hire_date`) BETWEEN 1995 AND 2005
ORDER BY `employee_id`;

-- -- 04 Find All Employees Except Engineers
    
SELECT 
	`first_name`, `last_name` 
FROM 
	`employees`
WHERE 
	NOT `job_title` LIKE '%engineer%'
ORDER BY
	`employee_id`;
    
-- 05 Find Towns with Name Length
    
SELECT 
    `name`
FROM
    `towns`
WHERE
    CHAR_LENGTH(`name`) IN (5 , 6)
ORDER BY `name`;

-- 06 Find Towns Starting With

SELECT 
    `town_id`, `name`
FROM
    `towns`
WHERE
    LOWER(LEFT(`name`, 1) IN ('M', 'K', 'B', 'E'))
ORDER BY `name`;

-- 07 Find Towns Not Starting With

SELECT 
    `town_id`, `name`
FROM
    `towns`
WHERE
    LOWER(LEFT(`name`, 1) NOT IN ('R' , 'B', 'D'))
ORDER BY `name`;

-- 08 Create View Employees Hired After 2000 Year

CREATE VIEW `v_employees_hired_after_2000` AS
    SELECT 
        `first_name`, `last_name`
    FROM
        `employees`
    WHERE
        YEAR(`hire_date`) > 2000;

SELECT * FROM `v_employees_hired_after_2000`;

-- 09 Length of Last Name

SELECT 
    `first_name`, `last_name`
FROM
    `employees`
WHERE
    CHAR_LENGTH(`last_name`) = 5;

-- 10 Countries Holding 'A' 3 or More Times

SELECT `country_name`, `iso_code` FROM `countries`
WHERE lower(`country_name` LIKE '%A%A%A%')
ORDER BY `iso_code`;

-- 11 Mix of Peak and River Names

SELECT 
    peak.`peak_name`,
    river.`river_name`,
    LOWER(CONCAT(peak.`peak_name`,
                    SUBSTRING(river.`river_name`, 2))) AS 'mix'
FROM
    `peaks` AS peak,
    `rivers` AS river
WHERE
    RIGHT(peak.`peak_name`, 1) = LEFT(river.`river_name`, 1)
ORDER BY `mix`;

-- 12 Games from 2011 and 2012 Year

SELECT `name`, date_format(`start`, '%Y-%m-%d') AS 'start' FROM `games`
WHERE YEAR(`start`) IN (2011, 2012)
ORDER BY `start`, `name`
LIMIT 50;

-- 13 User Email Providers

SELECT 
    `user_name`,
    SUBSTRING(`email`,
        POSITION('@' IN `email`) + 1) AS 'email provider'
FROM
    `users`
ORDER BY `email provider`, `user_name`;

-- OR  

SELECT 
    `user_name`,
    SUBSTRING(`email`,
        LOCATE('@', `email`) + 1) AS 'email provider'
FROM
    `users`
ORDER BY `email provider`, `user_name`;

-- 14 Get Users with IP Address Like Pattern

SELECT 
    `user_name`, `ip_address`
FROM
    `users`
WHERE
    `ip_address` LIKE '___.1%.%.___'
ORDER BY `user_name`;

-- 15 Show All Games with Duration and Part of the Day

SELECT   # diablo database
    `name` AS 'game',
    (CASE
        WHEN hour(`start`) BETWEEN 0 AND 11 THEN 'Morning'
        WHEN hour(`start`) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN hour(`start`) BETWEEN 18 AND 23 THEN 'Evening'
    END) AS 'Part of the Day',
    (CASE
        WHEN `duration` <= 3 THEN 'Extra Short'
        WHEN `duration` BETWEEN 4 AND 6 THEN 'Short'
        WHEN `duration` BETWEEN 7 AND 10 THEN 'Long'
        ELSE 'Extra Long'
    END) AS 'Duration'
FROM
    `games`;
    
-- 16 Orders Table

SELECT 
    `product_name`,
    `order_date`,
    DATE_ADD(`order_date`, INTERVAL 3 DAY) AS 'pay_due',
    DATE_ADD(`order_date`, INTERVAL 1 MONTH) AS 'delivery_date'
FROM
    `orders`.`orders`;

