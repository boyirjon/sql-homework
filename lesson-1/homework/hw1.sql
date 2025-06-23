Definitions:
1.Data
  Data refers to raw facts and figures without context — such as numbers, text, or images — that can be processed or analyzed to extract useful information.

2.Database
  A database is an organized collection of structured information or data, typically stored electronically in a computer system. It allows efficient storage, retrieval, and manipulation of data.

3.Relational Database
  A relational database is a type of database that stores data in tables (called relations), where each table consists of rows and columns. Relationships can be established between tables using foreign keys.

4.Table
 A table is a database object that stores data in rows and columns. Each row represents a record, and each column represents a field or attribute of the data.


  
Five Key Features of SQL Server:
1.Data Security
  Offers encryption, authentication, and authorization to ensure data protection.

2.Scalability and Performance
  Supports large-scale applications and provides performance optimization tools like indexing, query tuning, and in-memory processing.

3.High Availability
  Includes features like Always On availability groups, failover clustering, and database mirroring.

4.Backup and Recovery
  Provides robust backup and restore capabilities to protect against data loss.

5.Business Intelligence (BI) Tools
  Includes tools like SQL Server Reporting Services (SSRS), Integration Services (SSIS), and Analysis Services (SSAS) for data analysis and reporting.


Authentication Modes in SQL Server:
1.Windows Authentication
  Uses the Windows user account of the person logged into the system. It’s integrated and more secure, relying on Windows to verify credentials.

2.SQL Server Authentication
  Uses a username and password defined within SQL Server itself. It's useful when Windows Authentication is not available (e.g., cross-platform or external applications).


CREATE DATABASE SchoolDB

USE SchoolDB

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT
)

 Differences between SQL Server, SSMS, and SQL

| Term                                | Description                                                                                                                                                                                                   |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| SQL Server                          | A Database Management System (DBMS) developed by Microsoft that stores and manages databases. It handles data storage, retrieval, security, backups, and more.                                                |
| SSMS (SQL Server Management Studio) | A graphical user interface (GUI) tool used to interact with SQL Server. It allows you to write and run SQL queries, manage databases, create tables, users, backups, etc.                                     |
| SQL (Structured Query Language)     | A language used to communicate with relational databases. You use SQL to create, read, update, and delete data (CRUD). SQL works with many database systems, including SQL Server, MySQL, Oracle, PostgreSQL. |
