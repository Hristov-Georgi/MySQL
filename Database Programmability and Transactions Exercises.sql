-- 01 Employees with Salary Above 35000

DELIMITER $$

CREATE PROCEDURE `usp_get_employees_salary_above_35000`()
BEGIN
	SELECT `first_name`,
			`last_name`
	FROM `employees` AS e
	WHERE e.`salary` > 35000
    ORDER BY e.`first_name`, e.`last_name`, e.`employee_id`;
END $$

-- 02 Employees with Salary Above Number

CREATE PROCEDURE `usp_get_employees_salary_above`(`number` DECIMAL(20,4))
BEGIN 
	SELECT `first_name`,
			`last_name`
	FROM `employees`
    WHERE `salary` >= `number`
    ORDER BY `first_name`, `last_name`, `employee_id`;
END $$



-- 03 Town Names Starting With

CREATE PROCEDURE `usp_get_towns_starting_with`(`string` VARCHAR(20))
BEGIN 
	SELECT `name`
    FROM `towns`
    WHERE LEFT(`name`, length(`string`)) = `string`
    ORDER BY `name`;
END $$

-- 04 Employees from Town

CREATE PROCEDURE `usp_get_employees_from_town`(`town_name` VARCHAR(100))
BEGIN
	SELECT e.`first_name`,
			e.`last_name`
	FROM `employees` AS e
    JOIN `addresses` AS ad ON e.`address_id` = ad.`address_id`
    JOIN `towns` AS t ON ad.`town_id` = t.`town_id`
    WHERE t.`name` = `town_name`
    ORDER BY e.`first_name`, e.`last_name`, e.`employee_id`;
END $$

-- 05 Salary Level Function


CREATE FUNCTION `ufn_get_salary_level`(`salary` DECIMAL(20,4))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN 
	DECLARE `salary_level` VARCHAR(10);
    IF(`salary` < 30000) THEN SET `salary_level` = 'Low';
    ELSEIF(`salary` <= 50000) THEN SET `salary_level` = 'Average';
    ELSE SET `salary_level` = 'High';
    END IF;
    RETURN `salary_level`;
END $$

-- 06 Employees by Salary Level

CREATE PROCEDURE `usp_get_employees_by_salary_level`(`salary_level` VARCHAR(10))
BEGIN 
	IF(`salary_level` = 'low') 
		THEN (SELECT `first_name`,
					`last_name`
				FROM `employees` AS e
				WHERE e.`salary` < 30000)
                ORDER BY `first_name` DESC, `last_name` DESC; 
	ELSEIF(`salary_level` = 'Average') 
		THEN (SELECT `first_name`,
					`last_name`
				FROM `employees` AS e
				WHERE e.`salary` >= 30000 AND `salary` <= 50000)
                ORDER BY `first_name` DESC, `last_name` DESC; 
	ELSEIF (`salary_level` = 'High') THEN (SELECT `first_name`,
					`last_name`
				FROM `employees` AS e
				WHERE e.`salary` > 50000)
                ORDER BY `first_name` DESC, `last_name` DESC; 
	END IF;

END $$

-- OR 

CREATE PROCEDURE `usp_get_employees_by_salary_level`(`salary_level` VARCHAR(10))
BEGIN 
	SELECT `first_name`,
			`last_name`
	FROM `employees` AS e
	WHERE e.`salary` < 30000 AND `salary_level` = 'Low'
			OR e.`salary` >= 30000 AND `salary` <= 50000 AND `salary_level` = 'Average'
            OR e.`salary` > 50000 AND `salary_level` = 'High'
	ORDER BY `first_name` DESC, `last_name` DESC;
	
END $$

-- 07 Define Function

CREATE FUNCTION `ufn_is_word_comprised`(`set_of_letters` varchar(50), `word` varchar(50))
RETURNS BIT
DETERMINISTIC
BEGIN
	RETURN `word` REGEXP(concat('^[', `set_of_letters`, ']+$'));
END $$

-- 08 Find Full Name

CREATE PROCEDURE `usp_get_holders_full_name`()
BEGIN 
	SELECT concat_ws(' ', `first_name`, `last_name`) AS 'full_name'
    FROM `account_holders` AS ah
    ORDER BY `full_name`, ah.`id`;
END $$

-- 09 People with Balance Higher Than

CREATE PROCEDURE `usp_get_holders_with_balance_higher_than`(`amount` DECIMAL)
BEGIN
	SELECT `first_name`, `last_name`
    FROM `account_holders` AS ah
		JOIN `accounts` AS a ON a.`account_holder_id` = ah.`id`
	GROUP BY ah.`id`
    HAVING SUM(`balance`) > `amount`
    ORDER BY ah.`id` ASC;
END $$

-- 10 Future Value Function

CREATE FUNCTION `ufn_calculate_future_value`(`initial_sum` DECIMAL(20,4), `early_interest_rate` DOUBLE, `years` INT)
RETURNS DECIMAL(20,4)
DETERMINISTIC
BEGIN 
	RETURN (`initial_sum` * (power(1 + `early_interest_rate`, `years`)));
END $$

-- 11 Calculating Interest

CREATE PROCEDURE usp_calculate_future_value_for_account(account_id INT, interest_rate DECIMAL(20,4))
BEGIN
	SELECT  
		a.`id`, 
        ah.`first_name`, 
        ah.`last_name`, 
        a.`balance` AS 'current_balance',
        `ufn_calculate_future_value`(a.`balance`, `interest_rate`, 5) AS 'balance_in_5_years'
    FROM `account_holders` AS ah
		JOIN `accounts` AS a ON a.`account_holder_id` = ah.`id`
	WHERE a.`id` = `account_id`;
END $$

-- OR

CREATE PROCEDURE `usp_calculate_future_value_for_account`(`account_id` INT, `interest_rate` DECIMAL(20,4))
BEGIN
	DECLARE `balance_in_5_years` DECIMAL(20,4);
    SET `balance_in_5_years` = (SELECT (acc.`balance` * (power(1 + `interest_rate`, 5)))
								FROM `accounts` AS acc
								WHERE acc.`id` = `account_id`);
	SELECT  
		a.`id`, 
        ah.`first_name`, 
        ah.`last_name`, 
        a.`balance` AS 'current_balance',
        `balance_in_5_years`
    FROM `account_holders` AS ah
		JOIN `accounts` AS a ON a.`account_holder_id` = ah.`id`
	WHERE a.`id` = `account_id`;
END $$

-- 12 Deposit money

CREATE PROCEDURE `usp_deposit_money`(`account_id` INT, `money_amount` DECIMAL(20,4))
BEGIN 
	START TRANSACTION;
	IF (`money_amount` <= 0)
    THEN
    ROLLBACK;
    ELSE 
		UPDATE `accounts` AS a
		SET a.`balance` = a.`balance` + `money_amount` 
        WHERE a.`id` = `account_id`;
        COMMIT;
    END IF;
END $$

-- 13 Withdraw money

CREATE PROCEDURE `usp_withdraw_money`(`account_id` INT, `money_amount` DECIMAL(20,4))
BEGIN
	START TRANSACTION;
		IF (`money_amount` <= 0 OR (SELECT `balance` FROM `accounts` WHERE `id` = `account_id`) < `money_amount`)
		THEN ROLLBACK;
        ELSE 
			UPDATE `accounts` AS a
            SET a.`balance` = a.`balance` - `money_amount`
            WHERE a.`id` = `account_id`;
            COMMIT;
		END IF;
END $$

-- 14 Money Transfer

CREATE PROCEDURE `usp_transfer_money`(`from_account_id` INT, `to_account_id` INT, `amount` DECIMAL(20,4))
BEGIN 
	IF (`amount` > 0 AND `from_account_id` > 0 AND `to_account_id` > 0 AND `to_account_id` <> `from_account_id`)
    THEN 
    START TRANSACTION;
		IF (NOT EXISTS( SELECT `id` FROM `accounts` WHERE `id` = from_account_id OR `id` = to_account_id))
        THEN ROLLBACK;
        ELSEIF ((SELECT `balance` FROM `accounts` WHERE `id` = `from_account_id`) < `amount`)
		THEN ROLLBACK;
        ELSE  
			UPDATE `accounts` SET `balance` = `balance` - `amount` WHERE `id` = `from_account_id`;
            UPDATE `accounts` SET `balance` = `balance` + `amount` WHERE `id` = `to_account_id`;
            COMMIT;
				
        END IF;
	END IF;
END $$


-- 15 Log Accounts Trigger


CREATE TABLE `logs`(
`log_id` INT PRIMARY KEY AUTO_INCREMENT, 
`account_id` INT, 
`old_sum` DECIMAL(20,4), 
`new_sum` DECIMAL(20,4)
); $$

CREATE TRIGGER `tr_account_balance_change`
AFTER UPDATE
ON `accounts`
FOR EACH ROW 
BEGIN
	INSERT INTO `logs`(`account_id`, `old_sum`, `new_sum`)
    VALUES
    (OLD.`id`, OLD.`balance`, NEW.`balance`);
END; $$

-- 16 Emails Trigger

CREATE TABLE `notification_emails`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`recipient` INT, 
`subject` VARCHAR(300), 
`body` VARCHAR(1000)
); $$


CREATE TRIGGER `tr_notification_emails_from_logs`
AFTER INSERT
ON `logs`
FOR EACH ROW
BEGIN
	INSERT INTO `notification_emails`(`recipient`, `subject`, `body`)
    VALUES
    (NEW.`account_id`, 
    CONCAT('Balance change for account: ', NEW.`account_id`),
    CONCAT('On ', DATE_FORMAT(NOW(), '%b %d %Y at %r'),
    ' your balance was changed from ',
    ROUND(NEW.`old_sum`, 0), ' to ', ROUND(NEW.`new_sum`, 0), '.')
    );
END; $$


