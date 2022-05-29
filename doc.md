


**Name**: Usha Gunale  

**Date**: May 07, 2022  

**Course**: IT FDN 130 A Spring 22 

**Assignment 01**: Processing Data 

 

# <span style="color:red">Processing Data</span>

**Introduction**: In this module, I discuss the following use Professor Randal Root’s material: 

- Four basic SQL statements used to *create*, *read*, *update* and *delete* data. 
- What is a transaction?
- How the `Identity`, `@@Identity`, and `Ident_Current()` work in SQL Server and 

## 1.	Explain what the four basic SQL statements are used to create, read, update and delete data 

Four basic *SQL* statements used to modify database records are *create*, *read*, *update* and *delete*

### <span style="font-variant=small-caps;color:#7b2251">Create</span>

- It is used to create a new table in an existing database. 
- It is also used to create another database object such as a *stored procedure*, *function*, *etc*.

**Example**: Create table Employee (`EmpId int primary key not null`, `Name varchar(100) not null`)

### <span style="font-variant=small-caps;color:#7b2251">Read/Select</span>

It is used to select records from the table, with or without a condition.

**Example**: Select `EmpId`, `Name` from an Employee 

### <span style="font-variant=small-caps;color:#7b2251">Update</span>

It is used to update existing values in a table based on some condition.

**Example**: Update Employee `set Name='Bob Smith` where `EmpId=1`

### <span style="font-variant=small-caps;color:#7b2251">Delete</span>

- It is used to delete the existing record from a table.
- The deletion can be either conditional or unconditional.

**Example**: Delete from the Employee table `EmpId=1`.

## 2. Explain what a *transcation* is and give an example

- It is a single unit of work. 
- A successful transaction indicates that all of the data modifications made are committed and become a permanent part of the database. 
- If a transaction encounters errors and must be canceled or rolled back, then all of the data modifications are erased.

### Steps in a transaction processing

1. *Begin transaction*: This marks the beginning of a transaction
2. *Commit transaction*: This marks the successful end of a transaction. It signals the database to save the work *database commands*.
3. *Rollback transaction*: This transaction hasn't been successful and signals the database to roll back to the state it was in prior to the transaction.

**Example**: Trying to insert the employee records which is the table has the primary key.


```sql
BEGIN try
    BEGIN TRAN
    INSERT INTO employee
                (empid,
                 NAME)
    VALUES      (4,
                 ‘john smith’)
    COMMIT TRAN
END try
BEGIN catch
    ROLLBACK TRAN
    PRINT Error_message()
END catch 
```

In this example transaction will be rollback because of the error -  *primary key violation issue*. 

## 3. Explain how the `Identity`, `@@Identity`, and `Ident_Current()` work in SQL Server.

### `Identity`

If a column is marked as an identity column, then the values for the column are automatically generated when you insert a new row into the table. 

**Example**

Create the table statement that marks `DemoId` as an identity column with `seed = 1` and `Identity Increment = 1`. Seed and Increment values are optional and the default value is `1`.


```sql
CREATE TABLE demo
  (
     demoid INT IDENTITY(1, 1) PRIMARY KEY,
     NAME   NVARCHAR(20)
  ) 
```
Adding a record to the Demo table
```sql
Insert into Demo(Name)values('ABC')
```
See the ID of the new record

```sql
Select @@IDENTITY
```
Works, but not as good

```sql
Insert into Demo(Name)values('ABCD')
Go
Select * from Demo
Select @@IDENTITY
```
Will not work

```sql
Insert into Demo (DemoID,Name) values(3,‘ABC’)
```

If you define a column as an Identity column, you don’t have to explicitly supply a value for that column when you insert a new row. The value is automatically calculated and provided by the SQL server. So, to insert a row into the Demo table, just provide the value for the Name column.


### `@@IDENTITY` 

Returns the last identity value that is created in the same session and across any scope. In the above identity, the value will be 2.

### `IDENT_CURRENT('Table Name - Demo')`

Returns the last identity value that is created for a specific table across any session and any scope – The identity value will be 2.

## Summary

This article learns about the four basic SQL statements used to *create*, *read*, *update* and *delete* data, what is a transaction and how the `Identity`, `@@Identity`, and `Ident_Current()` work in SQL Server.









