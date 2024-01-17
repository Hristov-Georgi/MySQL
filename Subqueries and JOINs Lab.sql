# Lab: Subqueries and JOINs

-- 01 Managers

SELECT 
    e.`employee_id`,
    CONCAT(e.`first_name`, ' ', e.`last_name`) AS 'full_name',
    d.`department_id`,
    d.`name` AS 'department_name'
FROM
    `employees` AS e
        JOIN
    `departments` AS d ON e.`employee_id` = d.`manager_id`
ORDER BY e.`employee_id`
LIMIT 5;


-- 02 Towns Addresses

SELECT `towns`.`town_id`, `towns`.`name`, `addresses`.`address_text`
FROM `towns`
JOIN `addresses` ON `addresses`.`town_id` = `towns`.`town_id`
WHERE `towns`.`name` IN ('San Francisco', 'Sofia', 'Carnation')
ORDER BY `towns`.`town_id`, `addresses`.`address_id`;

-- 03 Employees Without Managers

SELECT `employee_id`, `first_name`, `last_name`, `department_id`, `salary`
FROM `employees`
WHERE `manager_id` IS NULL OR `manager_id` <= 0;

-- 04 Higher Salary

SELECT COUNT(`employee_id`)
FROM `employees`
WHERE `salary` > (SELECT AVG(`salary`) FROM `employees`);
