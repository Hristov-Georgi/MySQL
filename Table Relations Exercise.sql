-- 01 One-To-One Relationship

CREATE TABLE `people` (
    `person_id` INT AUTO_INCREMENT UNIQUE NOT NULL,
    `first_name` VARCHAR(200) NOT NULL,
    `salary` DECIMAL(9 , 2 ) NOT NULL DEFAULT 0,
    `passport_id` INT NOT NULL UNIQUE
);

CREATE TABLE `passports` (
    `passport_id` INT PRIMARY KEY AUTO_INCREMENT UNIQUE NOT NULL,
    `passport_number` VARCHAR(20) UNIQUE NOT NULL
)  AUTO_INCREMENT=101;

INSERT INTO `passports`(`passport_number`)
VALUES
	('N34FG21B'),
    ('K65LO4R7'),
    ('ZE657QP2');

INSERT INTO `people` (`first_name`, `salary`, `passport_id`)
VALUES
('Roberto', 43300.00, 102),
('Tom', 56100.00, 103),
('Yana', 60200.00, 101);

ALTER TABLE `people`
ADD CONSTRAINT `pk_person_id`
PRIMARY KEY (`person_id`),
ADD CONSTRAINT `fk_people_passports`
FOREIGN KEY (`passport_id`)
REFERENCES `passports`(`passport_id`);

-- 02 One-To-Many Relationship

CREATE TABLE `manufacturers` (
    `manufacturer_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    `established_on` DATE
);

CREATE TABLE `models` (
    `model_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50),
    `manufacturer_id` INT NOT NULL,
    CONSTRAINT `fk_models_manufacturers` FOREIGN KEY (`manufacturer_id`)
        REFERENCES `manufacturers` (`manufacturer_id`)
)  AUTO_INCREMENT=101;

INSERT INTO `manufacturers` (`name`, `established_on`)
VALUES
('BMW', '1916-03-01'),
('Tesla', '2003-01-01'),
('Lada', '1966-05-01');

INSERT INTO `models` (`name`, `manufacturer_id`)
VALUES
('X1', 1),
('i6', 1),
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3);


-- 03 Many-To-Many Relationship


CREATE TABLE `students` (
    `student_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE `exams` (
    `exam_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50) NOT NULL
)  AUTO_INCREMENT=101;

CREATE TABLE `students_exams` (
    `student_id` INT NOT NULL,
    `exam_id` INT NOT NULL,
    CONSTRAINT `pk_students_exams` PRIMARY KEY (`student_id` , `exam_id`),
    CONSTRAINT `fk_students_id_students` FOREIGN KEY (`student_id`)
        REFERENCES `students` (`student_id`),
    CONSTRAINT `fk_exams_id_exams` FOREIGN KEY (`exam_id`)
        REFERENCES `exams` (`exam_id`)
);

INSERT INTO `students`(`name`)
VALUES
('Mila'),
('Toni'),
('Ron');

INSERT INTO `exams` (`name`)
VALUES
('Spring MVC'),
('Neo4j'),
('Oracle 11g');

INSERT INTO `students_exams` (`student_id`, `exam_id`)
VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103);


-- 04 Self-Referencing

CREATE TABLE `teachers` (
    `teacher_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `manager_id` INT
)  AUTO_INCREMENT=101;

INSERT INTO `teachers` (`name`, `manager_id`)
VALUES
('John', NULL),
('Maya', 106),
('Silvia', 106),
('Ted', 105),
('Mark', 101),
('Greta', 101);

ALTER TABLE `teachers`
ADD CONSTRAINT `fk_manager_teacher`
FOREIGN KEY (`manager_id`)
REFERENCES `teachers`(`teacher_id`);


-- 05 Online Store Database

CREATE TABLE `cities` (
    `city_id` INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE `customers` (
    `customer_id` INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `birthday` DATE,
    `city_id` INT(11) NOT NULL,
    CONSTRAINT `fk_customers_cities` FOREIGN KEY (`city_id`)
        REFERENCES `cities` (`city_id`)
);

CREATE TABLE `orders` (
    `order_id` INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `customer_id` INT(11) NOT NULL,
    CONSTRAINT `fk_roders_customers` FOREIGN KEY (`customer_id`)
        REFERENCES `customers` (`customer_id`)
);

CREATE TABLE `item_types` (
    `item_type_id` INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE `items` (
    `item_id` INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `item_type_id` INT(11) NOT NULL,
    CONSTRAINT `fk_items_item_type` FOREIGN KEY (`item_type_id`)
        REFERENCES `item_types` (`item_type_id`)
);

CREATE TABLE `order_items` (
    `order_id` INT(11) NOT NULL,
    `item_id` INT(11) NOT NULL,
    CONSTRAINT `pk_order_item` PRIMARY KEY (`order_id` , `item_id`),
    CONSTRAINT `fk_order_orders` FOREIGN KEY (`order_id`)
        REFERENCES `orders` (`order_id`),
    CONSTRAINT `fk_item_items` FOREIGN KEY (`item_id`)
        REFERENCES `items` (`item_id`)
);

-- 06 University Database


CREATE TABLE `majors` (
    `major_id` INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE `students` (
    `student_id` INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `student_number` VARCHAR(12) NOT NULL,
    `student_name` VARCHAR(50) NOT NULL,
    `major_id` INT(11) NOT NULL,
    CONSTRAINT `fk_students_majors` FOREIGN KEY (`major_id`)
        REFERENCES `majors` (`major_id`)
);

CREATE TABLE `payments` (
    `payment_id` INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `payment_date` DATE,
    `payment_amount` DECIMAL(8 , 2 ),
    `student_id` INT(11) NOT NULL,
    CONSTRAINT `fk_payments_students` FOREIGN KEY (`student_id`)
        REFERENCES `students` (`student_id`)
);

CREATE TABLE `subjects` (
    `subject_id` INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `subject_name` VARCHAR(50) NOT NULL
);

CREATE TABLE `agenda` (
    `student_id` INT(11) NOT NULL,
    `subject_id` INT(11) NOT NULL,
    CONSTRAINT `pk_student_subject_ids` PRIMARY KEY (`student_id` , `subject_id`),
    CONSTRAINT `fk_agenda_students` FOREIGN KEY (`student_id`)
        REFERENCES `students` (`student_id`),
    CONSTRAINT `fk_agenda_subjects` FOREIGN KEY (`subject_id`)
        REFERENCES `subjects` (`subject_id`)
);

-- 09 Peaks in Rila

SELECT 
    `m`.`mountain_range`, `p`.`peak_name`, `p`.`elevation`
FROM
    `mountains` AS `m`
        JOIN
    `peaks` AS `p` ON `m`.`id` = `p`.`mountain_id`
WHERE
    `m`.`mountain_range` = 'Rila'
ORDER BY `p`.`elevation` DESC;

