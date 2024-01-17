# Lab Table relations

-- 01  Mountains and Peaks

CREATE TABLE `mountains` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE `peaks`(
`id` INT PRIMARY KEY AUTO_INCREMENT, 
`name` VARCHAR(50) NOT NULL,
`mountain_id` INT NOT NULL,
CONSTRAINT `fk_peaks_mountains`
FOREIGN KEY (`mountain_id`)
REFERENCES `mountains`(`id`)
);

-- 02 Trip Organization

SELECT 
    `campers`.`id` AS 'driver_id',
    `vehicles`.`vehicle_type`,
    CONCAT(`campers`.`first_name`,
            ' ',
            `campers`.`last_name`) AS 'driver_name'
FROM
    `campers`
        JOIN
    `vehicles` ON `campers`.`id` = `vehicles`.`driver_id`;
    
-- 03 SoftUni Hiking

SELECT 
    `r`.`starting_point` AS 'route_starting_point',
    `r`.`end_point` AS 'route_ending_point',
    `r`.`leader_id`,
    CONCAT(`c`.`first_name`, ' ', `c`.`last_name`) AS 'leader_name'
FROM
    `routes` AS `r`
        JOIN
    `campers` AS `c` ON `r`.`leader_id` = `c`.`id`;
        

-- 04 Delete Mountains

DROP TABLE `mountains`, `peaks`;

CREATE TABLE `mountains`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(60) NOT NULL
);

CREATE TABLE `peaks`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(60) NOT NULL,
`mountain_id` INT, 
CONSTRAINT `fk_peaks_mountains`
FOREIGN KEY (`mountain_id`)
REFERENCES `mountains`(`id`)
ON DELETE CASCADE
);

-- 05 Project Management DB

CREATE SCHEMA `project_management`;
USE `project_management`;

CREATE TABLE `clients`(
`id` INT(11) PRIMARY KEY AUTO_INCREMENT,
`client_name` VARCHAR(100)
);

CREATE TABLE `projects`(
`id` INT(11) PRIMARY KEY AUTO_INCREMENT,
`client_id` INT(11)  NOT NULL,
`project_lead_id` INT(11),
CONSTRAINT `fk_projects_clients`
FOREIGN KEY (`client_id`)
REFERENCES `clients`(`id`)
);


CREATE TABLE `employees`(
`id` INT(11) PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(30) NOT NULL,
`last_name` VARCHAR(30) NOT NULL,
`project_id` INT(11) NOT NULL,
CONSTRAINT `fk_employees_projects`
FOREIGN KEY (`project_id`)
REFERENCES `projects`(`id`)
);

ALTER TABLE `projects`
ADD CONSTRAINT `fk_projects_employees`
FOREIGN KEY (`project_lead_id`)
REFERENCES `employees`(`id`);





