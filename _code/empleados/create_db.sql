-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Script para crear la BD
-- 

DROP DATABASE if EXISTS EmployeesDB;
CREATE DATABASE EmployeesDB;
USE EmployeesDB;


CREATE OR REPLACE TABLE departments (
	department_id INT NOT NULL AUTO_INCREMENT,
	name_dep VARCHAR(32) NOT NULL,
	city VARCHAR(64),
	CONSTRAINT rn01_department_name_city UNIQUE (name_dep, city),
	PRIMARY KEY(department_id)
);

CREATE OR REPLACE TABLE employees (
	employee_id INT NOT NULL AUTO_INCREMENT ,
	department_id INT,
	boss_id INT,
	name_emp VARCHAR(64) NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE,
	salary DOUBLE NOT NULL DEFAULT 2000,
	fee DOUBLE NOT NULL,
	PRIMARY KEY(employee_id),
	FOREIGN KEY (department_id) REFERENCES departments (department_id) 
		ON DELETE RESTRICT,
	FOREIGN KEY (boss_id) REFERENCES employees (employee_id),
	CONSTRAINT ri02_employee_name UNIQUE(name_emp),
	CONSTRAINT rn02_fee_range CHECK (fee>=0 AND fee<=1),
	CONSTRAINT ck_employee_contract_dates CHECK (start_date < end_date),
	CONSTRAINT valid_salary CHECK (salary > 0)
);
