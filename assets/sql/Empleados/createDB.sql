-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Script para crear la BD
-- 

DROP DATABASE if EXISTS EmployeesDB;
CREATE DATABASE EmployeesDB;
USE EmployeesDB;

DELIMITER //
CREATE OR REPLACE PROCEDURE pCreateDB()
BEGIN
	CREATE OR REPLACE TABLE Departments (
		departmentId INT NOT NULL AUTO_INCREMENT,
		nameDep VARCHAR(32),
		city VARCHAR(64),
		UNIQUE (nameDep, city),
		PRIMARY KEY(departmentId)
	);
	
	CREATE OR REPLACE TABLE Employees (
		employeeId INT NOT NULL AUTO_INCREMENT ,
		departmentId INT,
		bossId INT,
		nameEmp VARCHAR(64) NOT NULL,
		startDate DATE,
		endDAte DATE,
		salary DOUBLE DEFAULT 2000,
		fee DOUBLE,
		PRIMARY KEY(employeeId),
		FOREIGN KEY (departmentId) REFERENCES Departments (departmentId) 
			ON DELETE RESTRICT,
		FOREIGN KEY (bossId) REFERENCES Employees (employeeId),
		UNIQUE(nameEmp),
		CONSTRAINT validFee CHECK (fee>=0 AND fee<=1),
		CONSTRAINT valifDates CHECK (startDate < endDate),
		CONSTRAINT validSalary CHECK (salary > 0)
	);
END;
//
DELIMITER ;

CALL pCreateDB();