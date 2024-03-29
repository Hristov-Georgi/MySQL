-- 01 Records' Count

SELECT COUNT(`id`) AS 'count'
FROM `wizzard_deposits`;

-- 02 Longest Magic Wand

SELECT MAX(`magic_wand_size`) AS 'longest_magic_wand'
FROM `wizzard_deposits`;

-- 03 Longest Magic Wand Per Deposit Groups

SELECT `deposit_group`, MAX(`magic_wand_size`) AS 'longest_magic_wand'
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `longest_magic_wand`, `deposit_group`;

-- 04 Smallest Deposit Group Per Magic Wand Size

SELECT `deposit_group`
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY AVG(`magic_wand_size`) ASC
LIMIT 1;

-- 05 Deposits Sum

SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum'
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `total_sum` ASC;

-- 06 Deposits Sum for Ollivander Family

SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum'
FROM `wizzard_deposits`
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
ORDER BY `deposit_group`;

-- 07 Deposits Filter

SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum'
FROM `wizzard_deposits`
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
HAVING `total_sum` < 150000
ORDER BY `total_sum` DESC;

-- 08 Deposit Charge

SELECT `deposit_group`, `magic_wand_creator`, MIN(`deposit_charge`) AS 'min_deposit_charge'
FROM `wizzard_deposits`
GROUP BY `deposit_group`, `magic_wand_creator`
ORDER BY `magic_wand_creator`, `deposit_group`;

-- 09 Age Groups

SELECT 
    (CASE
        WHEN `age` BETWEEN 0 AND 10 THEN '[0-10]'
        WHEN `age` BETWEEN 11 AND 20 THEN '[11-20]'
        WHEN `age` BETWEEN 21 AND 30 THEN '[21-30]'
        WHEN `age` BETWEEN 31 AND 40 THEN '[31-40]'
        WHEN `age` BETWEEN 41 AND 50 THEN '[41-50]'
        WHEN `age` BETWEEN 51 AND 60 THEN '[51-60]'
        WHEN `age` > 60 THEN '[61+]'
    END) AS 'age_group',
    COUNT(`id`) AS 'wizzard_count'
FROM
    `wizzard_deposits`
GROUP BY `age_group`
ORDER BY `age_group`;

-- 10 First Letter

SELECT LEFT(`first_name`, 1) AS 'first letter'
FROM `wizzard_deposits`
WHERE `deposit_group` = 'Troll Chest'
GROUP BY `first letter`
ORDER BY `first letter`; 

-- 11 Average Interest 

SELECT `deposit_group`, `is_deposit_expired`, AVG(`deposit_interest`) AS 'average_interest'
FROM `wizzard_deposits`
WHERE `deposit_start_date` > '1985-01-01'
GROUP BY `is_deposit_expired`, `deposit_group`
ORDER BY `deposit_group` DESC, `is_deposit_expired` ASC;

# GRINGOTTS database
-- ----------------------------------------------
# SOFTUNI database

-- 12 Employees Minimum Salaries

SELECT `department_id`, min(`salary`) AS 'minimum_salary'
FROM `employees`
WHERE `hire_date` > '2000-01-01'
GROUP BY `department_id`
HAVING `department_id` IN (2, 5, 7)
ORDER BY `department_id`;

-- 13 Employees Average Salaries

CREATE TABLE `new_table` AS 
SELECT * FROM `employees`
WHERE `salary` > 30000;

DELETE FROM `new_table`
WHERE `manager_id` = '42';

UPDATE `new_table`
SET `salary` = `salary` + 5000
WHERE `department_id` = 1;

SELECT `department_id`, AVG(`salary`) AS 'avg_salary'
FROM `new_table`
GROUP BY `department_id`
ORDER BY `department_id` ASC;

-- 14 Employees Maximum Salaries

SELECT `department_id`, MAX(`salary`) AS 'max_salary'
FROM `employees`
GROUP BY `department_id`
HAVING `max_salary` NOT BETWEEN 30000 AND 70000
ORDER BY `department_id` ASC;

-- 15 Employees Count Salaries

SELECT COUNT(`employee_id`) - COUNT(`manager_id`)
FROM `employees`;

# OR 

SELECT COUNT(*)
FROM `employees`
WHERE `manager_id` IS NULL;

-- 16 3rd Highest Salary

SELECT 
	`department_id`, 
	(SELECT DISTINCT
   `salary`
	FROM `employees` AS `e2`
    WHERE `e2`.`department_id` = `e1`.`department_id`
    ORDER BY `salary` DESC
    LIMIT 2,1
    ) AS 'third_highest_salary'
FROM `employees` AS `e1`
GROUP BY `department_id`
HAVING `third_highest_salary` IS NOT NULL
ORDER BY `department_id` ASC;

-- 17 Salary Challenge

SELECT 
    `e1`.`first_name`, `e1`.`last_name`, `e1`.`department_id`
FROM
    `employees` AS `e1`
        JOIN
    (SELECT 
        `e2`.`department_id`, AVG(`e2`.`salary`) AS `salary`
    FROM
        `employees` AS `e2`
    GROUP BY `e2`.`department_id`) AS `department_avg` ON e1.`department_id` = `department_avg`.`department_id`
WHERE
    `e1`.`salary` > `department_avg`.`salary`
ORDER BY `e1`.`department_id` , `e1`.`employee_id`
LIMIT 10;

-- 18 Departments Total Salaries

SELECT `department_id`, SUM(`salary`)
FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id`;

