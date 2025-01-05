USE master;

CREATE DATABASE SchoolSystemDB;

USE SchoolSystemDB;

CREATE TABLE Classes (
    ClassID INT PRIMARY KEY IDENTITY(1,1),
    ClassName NVARCHAR(50) NOT NULL
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    StudentNumber INT NOT NULL UNIQUE,
    ClassID INT NOT NULL,
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID)
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(100) NOT NULL,
    Budget DECIMAL(18, 2) NOT NULL -- DECIMAL f�r h�g precision
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName NVARCHAR(100) NOT NULL,
    Position NVARCHAR(50) NOT NULL,
    EmployeeNumber INT NOT NULL UNIQUE,
    StartDate DATE NOT NULL, -- Startdatum f�r att ber�kna anst�llningstid
    MonthlySalary FLOAT NOT NULL, -- M�nadsl�n f�r l�neber�kningar
    DepartmentID INT NOT NULL, -- Kopplar personal till avdelning
    ClassID INT,  -- Detta �r f�r att koppla en l�rare till en klass
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    CourseName NVARCHAR(100) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1 -- Flagga f�r att markera om kursen �r aktiv
);

CREATE TABLE Grades (
    GradeID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EmployeeID INT NOT NULL,
    ClassID INT NOT NULL,  -- Kopplar betyg till en klass
    Grade NVARCHAR(2) NOT NULL,
    GradeDate DATE NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID)
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,  -- H�r lagras l�senordet
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100),
    UserType NVARCHAR(20) NOT NULL,  -- Admin eller vanlig anv�ndare
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Testdata f�r Classes
INSERT INTO Classes (ClassName) VALUES 
('Matematik A'),
('Svenska B'),
('Engelska C'),
('Programmering 101');

-- Testdata f�r Students
INSERT INTO Students (FirstName, LastName, StudentNumber, ClassID) VALUES 
('Anna', 'Andersson', 1001, 1),
('Bj�rn', 'Berg', 1002, 2),
('Clara', 'Carlsson', 1003, 1),
('David', 'Dahl', 1004, 3),
('Eva', 'Eriksson', 1005, 4);

-- Testdata f�r Departments
INSERT INTO Departments (DepartmentName, Budget) VALUES 
('Administration', 200000.00),
('IT-avdelning', 500000.00),
('Undervisning', 300000.00);

-- Testdata f�r Employees
INSERT INTO Employees (EmployeeName, Position, EmployeeNumber, StartDate, MonthlySalary, DepartmentID, ClassID) VALUES 
('Lars Lind', 'L�rare', 2001, '2015-08-01', 28000, 3, 1),
('Maria Melin', 'L�rare', 2002, '2018-01-15', 29000, 3, 2),
('Oskar Olsson', 'L�rare', 2003, '2020-09-01', 27000, 3, 3),
('Petra Persson', 'Rektor', 2004, '2010-06-01', 35000, 1, NULL),
('Karin Karlsson', 'IT-support', 2005, '2017-11-01', 25000, 2, NULL);

-- Testdata f�r Courses
INSERT INTO Courses (CourseName, IsActive) VALUES 
('Matematik Grundkurs', 1),
('Svenska Spr�kvetenskap', 1),
('Engelska Litteratur', 1),
('Webbutveckling', 1),
('Databasteknik', 0);

-- Testdata f�r Grades
INSERT INTO Grades (StudentID, CourseID, EmployeeID, ClassID, Grade, GradeDate) VALUES 
(1, 1, 1, 1, 'A', '2024-01-15'),
(2, 2, 2, 2, 'B', '2024-01-18'),
(3, 3, 3, 1, 'A-', '2024-01-20'),
(4, 4, 1, 3, 'C', '2024-01-22'),
(5, 1, 2, 4, 'B-', '2024-01-25');

-- Testdata f�r Users
INSERT INTO Users (Username, Password, FullName, Email, UserType, CreatedDate) VALUES 
('admin', 'hashedpassword1', 'Admin User', 'admin@schoolab.com', 'Admin', '2024-01-01'),
('teacher1', 'hashedpassword2', 'Lars Lind', 'lars.lind@schoolab.com', 'Teacher', '2024-01-02'),
('teacher2', 'hashedpassword3', 'Maria Melin', 'maria.melin@schoolab.com', 'Teacher', '2024-01-02'),
('student1', 'hashedpassword4', 'Anna Andersson', 'anna.andersson@schoolab.com', 'Student', '2024-01-02'),
('student2', 'hashedpassword5', 'Bj�rn Berg', 'bjorn.berg@schoolab.com', 'Student', '2024-01-02');


-- �versikt �ver personal
SELECT 
    EmployeeName AS Name, 
    Position AS Role, 
    DATEDIFF(YEAR, StartDate, GETDATE()) AS YearsOnSchool
FROM Employees;

-- L�gga till ny personal
INSERT INTO Employees (EmployeeName, Position, EmployeeNumber, StartDate, MonthlySalary, DepartmentID)
VALUES ('Anna Svensson', 'L�rare', 1002, '2018-08-15', 35000, 1); -- Exempeldata

-- L�gg till en ny elev
INSERT INTO Students (FirstName, LastName, StudentNumber, ClassID)
VALUES ('John', 'Doe', 12345, 1);

-- L�gg till ett nytt betyg
INSERT INTO Grades (StudentID, CourseID, EmployeeID, ClassID, Grade, GradeDate)
VALUES (
    1, -- StudentID
    2, -- CourseID
    3, -- EmployeeID (l�rare)
    1, -- ClassID
    'A', -- Grade
    GETDATE() -- GradeDate
);

-- Kolla l�n f�r respektive avdelning
SELECT 
    d.DepartmentName, 
    SUM(e.MonthlySalary) AS TotalMonthlySalaries
FROM Departments d
JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;

-- Medell�n f�r avdelningar
SELECT 
    d.DepartmentName, 
    AVG(e.MonthlySalary) AS AverageSalary
FROM Departments d
JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;


-- Skapa en Stored Procedure som tar emot ett StudentID och returnerar elevens information.
CREATE PROCEDURE GetStudentInfo
    @StudentID INT
AS
BEGIN
    SELECT 
        s.StudentID, 
        CONCAT(s.FirstName, ' ', s.LastName) AS FullName, 
        c.ClassName, 
        g.Grade, 
        cr.CourseName, 
        g.GradeDate
    FROM Students s
    LEFT JOIN Grades g ON s.StudentID = g.StudentID
    LEFT JOIN Courses cr ON g.CourseID = cr.CourseID
    LEFT JOIN Classes c ON s.ClassID = c.ClassID
    WHERE s.StudentID = @StudentID;
END;

-- Anv�ndning
EXEC GetStudentInfo @StudentID = 1;


-- Transaktion f�r att s�tta betyg
BEGIN TRANSACTION;

BEGIN TRY
    -- Testdata f�r transaktion
    DECLARE @StudentID INT = 1;
    DECLARE @CourseID INT = 2;
    DECLARE @Grade NVARCHAR(2) = 'B';
    DECLARE @GradeDate DATE = GETDATE();
    DECLARE @EmployeeID INT = 3;

    -- Kontrollera om studenten existerar
    IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        THROW 50000, 'Studenten finns inte.', 1;

    -- Kontrollera om kursen existerar
    IF NOT EXISTS (SELECT 1 FROM Courses WHERE CourseID = @CourseID)
        THROW 50000, 'Kursen finns inte.', 1;

    -- L�gg till betyg
    INSERT INTO Grades (StudentID, CourseID, EmployeeID, ClassID, Grade, GradeDate)
    VALUES (
        @StudentID, 
        @CourseID, 
        @EmployeeID, 
        (SELECT ClassID FROM Students WHERE StudentID = @StudentID), 
        @Grade, 
        @GradeDate
    );

    COMMIT TRANSACTION;
    PRINT 'Betyg satt framg�ngsrikt.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Ett fel intr�ffade: ' + ERROR_MESSAGE();
END CATCH;
