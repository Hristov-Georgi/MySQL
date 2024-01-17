-- 01 Count Employees by Town

DELIMITER $$

CREATE FUNCTION  `ufn_count_employees_by_town`(`town_name` VARCHAR(100))
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN
    (SELECT COUNT(`employee_id`) FROM `employees` AS e
    JOIN `addresses` as a ON e.`address_id` = a.`address_id`
    JOIN `towns` AS t ON t.`town_id` = a.`town_id`
    WHERE t.`name` = `town_name`
    );


END $$


-- 02 Employees Promotion

CREATE PROCEDURE `usp_raise_salaries`(`department_name` VARCHAR(100))
BEGIN
	UPDATE  `employees` as e
    JOIN `departments` as d ON d.`department_id` = e.`department_id`
    SET e.`salary` = e.`salary` * 1.05
    WHERE d.`name` = `department_name`;

END $$

-- 03 Employees Promotion by ID

CREATE PROCEDURE `usp_raise_salary_by_id`(`id` INT)
BEGIN
	IF(SELECT `employee_id`  
		FROM `employees` 
		WHERE `employee_id` = `id`) 
    THEN
		UPDATE `employees` AS e
		SET `salary` = `salary`*1.05
		WHERE e.`employee_id` = `id`;
    END IF;

END $$

DELIMITER ;

-- 04 Triggered

CREATE TABLE `deleted_employees`(
`employee_id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(50) NOT NULL,
`last_name` VARCHAR(50) NOT NULL,
`middle_name` VARCHAR(50) NOT NULL,
`job_title` VARCHAR(50) NOT NULL,
`department_id` INT DEFAULT NULL,
`salary` DECIMAL(19,4) NOT NULL
);

DELIMITER $$

CREATE TRIGGER `tr_deleted_employees`
AFTER DELETE 
ON `employees`
FOR EACH ROW
BEGIN
	INSERT INTO `deleted_employees`(`first_name`,`last_name`,
									`middle_name`,`job_title`,`department_id`,`salary`)
		VALUES 
        (OLD.`first_name`, OLD.`last_name`, OLD.`middle_name`,
        OLD.`job_title`, OLD.`department_id`, OLD.`salary` );
END;

$$

DELIMITER ;







                                









