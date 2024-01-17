-- 01 Employee Address

SELECT 
    e.`employee_id`,
    e.`job_title`,
    a.`address_id`,
    a.`address_text`
FROM
    `employees` AS e
        JOIN
    `addresses` AS a ON e.`address_id` = a.`address_id`
ORDER BY e.`address_id`
LIMIT 5;

-- 02 Addresses with Towns

SELECT 
    `employees`.`first_name`,
    `employees`.`last_name`,
    `towns`.`name` AS 'town',
    `addresses`.`address_text`
FROM
    `employees`
        JOIN
    `addresses` ON `employees`.`address_id` = `addresses`.`address_id`
        JOIN
    `towns` ON `addresses`.`town_id` = `towns`.`town_id`
ORDER BY `employees`.`first_name` , `employees`.`last_name`
LIMIT 5;

-- 03 Sales Employee

SELECT 
    e.`employee_id`,
    e.`first_name`,
    e.`last_name`,
    d.`name` AS 'department_name'
FROM
    `employees` AS e
        JOIN
    `departments` AS d ON e.`department_id` = d.`department_id`
WHERE
    d.`name` = 'Sales'
ORDER BY e.`employee_id` DESC;

-- 04 Employee Departments

SELECT e.`employee_id`,
		e.`first_name`,
        e.`salary`,
        d.`name` AS 'department_name'
FROM `employees` AS e
JOIN `departments` AS d ON e.`department_id` = d.`department_id`
WHERE e.`salary` > 15000
ORDER BY e.`department_id` DESC
LIMIT 5;

-- 05 Employees Without Project

SELECT 
    `e`.`employee_id`, `e`.`first_name`
FROM
    `employees` AS `e`
WHERE
    `e`.`employee_id` NOT IN (SELECT 
            `employee_id`
        FROM
            `employees_projects`)
ORDER BY `e`.`employee_id` DESC
LIMIT 3;

-- 06 Employees Hired After

SELECT 
    `first_name`,
    `last_name`,
    `hire_date`,
    `name` AS 'dept_name'
FROM
    `employees` AS `e`
        JOIN
    `departments` AS `d` ON e.`department_id` = d.`department_id`
WHERE
    e.`hire_date` > '1999-01-01'
        AND d.`name` IN ('Finance' , 'Sales')
ORDER BY e.`hire_date`;

-- 07 Employees with Project

SELECT 
    e.`employee_id`, 
    e.`first_name`, 
    p.`name` AS 'project_name'
FROM
    `employees` AS e
        JOIN
    `employees_projects` AS ep ON e.`employee_id` = ep.`employee_id`
        JOIN
    `projects` AS p ON ep.`project_id` = p.`project_id`
WHERE
    DATE(p.`start_date`) > '2002-08-13'
        AND p.`end_date` IS NULL
ORDER BY e.`first_name` , p.`name`
LIMIT 5;

-- 08 Employee 24


SELECT 
	e.`employee_id`, 
    e.`first_name`, 
    IF(YEAR(p.`start_date`) >= 2005, NULL, p.`name`) AS 'project_name'
FROM
    `employees` AS e
		JOIN 
			`employees_projects` AS ep ON e.`employee_id` = ep.`employee_id`
		JOIN 
			`projects` AS p ON p.`project_id` = ep.`project_id`
WHERE 
	e.`employee_id` = 24
ORDER BY p.`name`;

-- 09 Employee Manager

SELECT e.`employee_id`,
		e.`first_name`,
		e.`manager_id`,
		m.`first_name` AS 'manager_name'
FROM `employees` AS e
JOIN `employees` AS m ON m.`employee_id` = e.`manager_id`
WHERE e.`manager_id` IN (3, 7)
ORDER BY e.`first_name` ASC; 

-- 10 Employee Summary

SELECT e.`employee_id`,
		concat(e.`first_name`, ' ', e.`last_name`) AS'employee_name',
		concat(m.`first_name`, ' ', m.`last_name`) AS 'manager_name',
		d.`name` AS 'department_name'
FROM `employees` as e
JOIN `employees` AS m ON e.`manager_id` = m.`employee_id`
JOIN `departments` AS d ON d.`department_id` = e.`department_id`
WHERE e.`manager_id` IS NOT NULL
ORDER BY e.`employee_id`
LIMIT 5; 

-- 11 Min Average Salary

SELECT AVG(`salary`) AS 'min_average_salary'
FROM `employees`
GROUP BY `department_id`
ORDER BY `min_average_salary`
LIMIT 1;

-- 12 Highest Peaks in Bulgaria

SELECT 
    mc.`country_code`,
    m.`mountain_range`,
    p.`peak_name`,
    p.`elevation`
FROM
    `mountains_countries` AS mc
        JOIN
    `mountains` AS m ON mc.`mountain_id` = m.`id`
        JOIN
    `peaks` AS p ON p.`mountain_id` = mc.`mountain_id`
WHERE
    p.`elevation` > 2835
        AND mc.`country_code` = 'BG'
ORDER BY p.elevation DESC;

-- 13 Count Mountain Ranges

SELECT 
    c.`country_code`,
    COUNT(mc.`mountain_id`) AS 'mountain_range'
FROM
    `countries` AS c
        JOIN
    `mountains_countries` AS mc ON mc.`country_code` = c.`country_code`
GROUP BY c.`country_code`
HAVING c.`country_code` IN ('US' , 'BG', 'RU')
ORDER BY `mountain_range` DESC;

-- 14 Countries with Rivers

SELECT c.`country_name`,
		r.`river_name`
FROM
	`countries` AS c
		LEFT JOIN 
	`countries_rivers` AS cr ON c.`country_code` = cr.`country_code`
		LEFT JOIN
	`rivers` AS r ON r.`id` = cr.`river_id`
		JOIN
	`continents` AS con ON con.`continent_code` = c.`continent_code`
WHERE con.`continent_name` = 'Africa'
ORDER BY c.`country_name` ASC
LIMIT 5;

-- 15 Continents and Currencies

SELECT 
    c.`continent_code`,
    c.`currency_code`,
    COUNT(*) AS 'currency_usage'
FROM
    `countries` AS c
GROUP BY c.`continent_code` , c.`currency_code`
HAVING currency_usage > 1
    AND currency_usage = (SELECT 
        COUNT(*) AS 'most_used_currency'
    FROM
        `countries` AS c2
    WHERE
        c2.`continent_code` = c.`continent_code`
    GROUP BY c2.`currency_code`
    ORDER BY most_used_currency DESC
    LIMIT 1)
ORDER BY c.`continent_code` , c.`currency_code`;

-- 16 Countries Without Any Mountains

SELECT COUNT(c.`country_code`)
FROM `countries` AS c
LEFT JOIN `mountains_countries` AS mc ON c.`country_code` = mc.`country_code`
WHERE mc.`mountain_id` IS NULL;

-- 17 Highest Peak and Longest River by Country

SELECT c.`country_name`,
		MAX(p.`elevation`) AS 'highest_peak_elevation',
        MAX(r.`length`) AS 'highest_peak_elevation'
FROM `countries` AS c
		LEFT JOIN
	`mountains_countries` AS mc ON mc.`country_code` = c.`country_code` 
		LEFT JOIN 
	`peaks` AS p ON p.`mountain_id` = mc.`mountain_id`
		LEFT JOIN
	`countries_rivers` AS cr ON cr.`country_code` = c.`country_code`
		LEFT JOIN
	`rivers` AS r ON r.`id` = cr.`river_id`
GROUP BY c.`country_name`
ORDER BY highest_peak_elevation DESC, highest_peak_elevation DESC, c.`country_name` ASC
LIMIT 5;


    
