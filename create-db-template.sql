-- Active: 1720067806790@@127.0.0.1@3306
create Database COMPANY;

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Budget DECIMAL(10, 2) CHECK (Budget > 0)
);
/*Assignment  table*/
CREATE TABLE Assignments (
    AssignmentID INT PRIMARY KEY,
    EmployeeID INT NOT NULL,
    ProjectID INT,
    Role VARCHAR(50) NOT NULL,
    AssignmentDate DATE NOT NULL
);
/*initial data*/
INSERT INTO
    Projects (
        ProjectID,
        ProjectName,
        StartDate,
        EndDate,
        Budget
    )
VALUES (
        1,
        'Project Alpha',
        '2023-01-01',
        '2023-12-31',
        100000.00
    ),
    (
        2,
        'Project Beta',
        '2023-02-01',
        '2023-11-30',
        200000.00
    );

INSERT INTO
    Assignments (
        AssignmentID,
        EmployeeID,
        ProjectID,
        Role,
        AssignmentDate
    )
VALUES (
        1,
        101,
        1,
        'Developer',
        '2023-01-10'
    ),
    (
        2,
        102,
        1,
        'Manager',
        '2023-01-15'
    ),
    (
        3,
        103,
        2,
        'Tester',
        '2023-02-01'
    );

ALTER TABLE Assignments
ADD CONSTRAINT FK_Project FOREIGN KEY (ProjectID) REFERENCES Projects (ProjectID);

UPDATE Assignments
SET
    ProjectID = 1
WHERE
    AssignmentID = 1
    AND ProjectID IS NULL;

UPDATE Assignments SET ProjectID = 2 WHERE AssignmentID = 3;

select * from projects;

select * from assignments;

SELECT * FROM Assignments WHERE AssignmentID IS NULL;
-- Check for duplicate AssignmentID values
SELECT AssignmentID, COUNT(*)
FROM Assignments
GROUP BY
    AssignmentID
HAVING
    COUNT(*) > 1;

SELECT * FROM Projects WHERE Budget <= 0;

CREATE Table Employees (
    EmployeeID INT Primary Key,
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    DepartmentID INT NOT NULL,
    HireDate DATE NOT NULL,
    Position VARCHAR(20) NOT NULL,
    Salary INT NOT NULL
);

CREATE TABLE Departments (
    DepartmentID INT Primary Key,
    DepartmentName VARCHAR(20) NOT NULL,
    Location VARCHAR(50) NOT NULL
);

CREATE TABLE Customers (
    CustomerID INT Primary Key,
    CustomerName VARCHAR(20) NOT NULL,
    ContactNumber Int NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Address VARCHAR(50) NOT NULL
);

CREATE TABLE Orders (
    OrderID INT Primary Key,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount INT NOT NULL
);

CREATE TABLE Products (
    ProductID INT Primary Key,
    ProductName VARCHAR(20) NOT NULL,
    Category VARCHAR(20) NOT NULL,
    Price INT NOT NULL,
    StockQuantity INT NOT NULL
);

CREATE TABLE OrderDetails (
    OrderDetailID INT Primary Key,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice INT NOT NULL
);

INSERT INTO departments VALUES (1, 'IT', 'California');

INSERT INTO departments VALUES (2, 'HR', 'Sydney');

INSERT INTO
    Employees
VALUES (
        101,
        'Ahmed',
        'Emad',
        1,
        '2022-11-3',
        'Manager',
        30000
    );

INSERT INTO
    Employees
VALUES (
        102,
        'Mohamed',
        'Ashraf',
        1,
        '2022-9-3',
        'Developer',
        15000
    );

INSERT INTO
    Projects
VALUES (
        3,
        'AAlmia',
        '2023-8-1',
        '2024-6-1',
        50000.00
    );

INSERT INTO Assignments VALUES ( 4, 104, 2, 'Analyser', '2024-5-12' );

INSERT INTO
    Customers
VALUES (
        1001,
        'Omar',
        0987654321,
        'Omar@gmail.com',
        '123 Main St'
    );

INSERT INTO
    Customers
VALUES (
        1002,
        'Manar',
        0989464253,
        'Manar@gmail.com',
        '456 Elm St'
    );

INSERT INTO Orders VALUES (201, 1001, '2024-6-1', 1605);

INSERT INTO Orders VALUES (202, 1002, '2024-7-1', 720);

INSERT INTO Products VALUES ( 301, 'Laptop', 'Electronics', 25000, 20 );

INSERT INTO Products VALUES ( 302, 'Mouse', 'Electronics', 525, 100 );

INSERT INTO OrderDetails VALUES (1, 201, 301, 1, 25000);

INSERT INTO OrderDetails VALUES (2, 202, 302, 1, 525);

SELECT * from Assignments;

--Question 1
Select
    Upper(FirstName) As first_name,
    LOWER(LastName) As Last_Name,
    LENGTH(Position) As Len_Position,
    DepartmentName
FROM employees
    INNER JOIN departments Using (DepartmentID);

--Question 2
SELECT
    DepartmentName,
    ROUND(SUM(Salary), -3) AS Total_Salary_Expenditure,
    COUNT(EmployeeID) AS Num_of_Employees
FROM employees
    JOIN departments USING (DepartmentID)
GROUP BY
    DepartmentName
ORDER BY Total_Salary_Expenditure DESC;

--Question 3
select
    upper(projects.projectname) as projectname,
    concat(
        employees.firstname,
        employees.lastname
    ) as employeename,
    assignments.role as Role
from
    employees
    join assignments on employees.EmployeeID = assignments.EmployeeID
    join projects on projects.ProjectID = assignments.ProjectID;

--Question 4
select
    lower(customers.customername) as customername,
    count(orders.orderid) as TotalOrders,
    sum(orders.totalamount) as TotalSpent
from customers
    join orders on orders.customerid = customers.customerid
group by
    customers.customername;

--Question 5

SELECT
    LEFT(ProductName, 10) AS TruncatedProductName,
    LEFT(ProductName, 2) AS Category,
    SUM(OrderDetails.Quantity) AS TotalQuantityOrdered
FROM Products
    JOIN OrderDetails USING (ProductID)
GROUP BY
    ProductName;

--Question 6
DELIMITER / /

CREATE PROCEDURE GetHighSalaryEmployees()
BEGIN
    SELECT 
        CONCAT(FirstName, ' ', LastName) AS EmployeeName,
        Salary,
        DepartmentName
    FROM 
        Employees
    JOIN 
        Departments USING (DepartmentID)
    WHERE 
        Salary > (
            SELECT AVG(Salary) 
            FROM Employees 
            WHERE DepartmentID = Employees.DepartmentID
        );
END //

DELIMITER;

CALL GetHighSalaryEmployees ();

--Form

DELIMITER $$

CREATE PROCEDURE AvgSal_PerDe()
BEGIN
  DROP TEMPORARY TABLE IF EXISTS temp1;
  CREATE TEMPORARY TABLE temp1(
    DepartmentID INT,
    AvgSal DECIMAL(10, 2)
  );
  
  INSERT INTO temp1 (DepartmentID, AvgSal)
  SELECT DepartmentID, AVG(Salary) AS AvgSal
  FROM employees
  GROUP BY DepartmentID;
END;
$$

DELIMITER;

CALL AvgSal_PerDe ();

SELECT e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName) AS Name, d.DepartmentName
FROM employees e
    INNER JOIN departments d ON d.DepartmentID = e.DepartmentID
WHERE
    e.Salary > (
        SELECT AvgSal
        FROM temp1 t
        WHERE
            t.DepartmentID = d.DepartmentID
    );

SELECT *, (
        SELECT AVG(Salary)
        FROM employees
    ) AS AVGSal
FROM employees;

DELIMITER / /

CREATE FUNCTION CheckSal(eSalary INT)
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
  DECLARE avgSal DECIMAL(10, 2);
  SELECT AVG(Salary) INTO avgSal FROM employees;
  
  RETURN IF(eSalary > avgSal, 'Higher Than', 'Lower Than');
END;

/ /

DELIMITER;

SELECT *, CheckSal (Salary) As check_Salary FROM employees;

DELETE FROM departments WHERE DepartmentName = 'IT';

SELECT * FROM employees WHERE DepartmentID IS NULL;

select employees.firstname, departments.departmentname
from employees
    join departments on departments.departmentid = employees.departmentid
where
    departments.departmentname = 'it';