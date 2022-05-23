--*************************************************************************--
-- Title: Assignment06
-- Author: Gunale Usha
-- Desc: This file demonstrates how to use Views
-- Change Log: When,Who,What
-- 05/21/2022,UGunale,Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_UGunale')
	 Begin 
	  Alter Database [Assignment06DB_UGunale] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_UGunale;
	 End
	Create Database Assignment06DB_UGunale;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_UGunale;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [mOney] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, UnitsInStock
From Northwind.dbo.Products
UNIOn
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, UnitsInStock + 10 -- Using this is to create a made up value
From Northwind.dbo.Products
UNIOn
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, UnitsInStock + 20 -- Using this is to create a made up value
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
--Select * From Categories;
--go
--Select * From Products;
--go
--Select * From Employees;
--go
--Select * From Inventories;
--go

/********************************* Questions and Answers *********************************/
print 
'NOTES------------------------------------------------------------------------------------ 
 1) You can use any name you like for you views, but be descriptive and consistent
 2) You can use your working code from assignment 5 for much of this assignment
 3) You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'

-- Question 1 (5% pts): How can you create BACIC views to show data from each table in the database.
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!
/*
go
Create view vCategories
 As
	Select 
		 categoryID
		,CategoryName 
	From Categories;
go
Select * from vCategories;
go
Create View vProducts;
 As
    Select 
		 ProductID
		,ProductName
	    ,CategoryID
	    ,UnitPrice
    From Products
go
Select * from vProducts;
go
Select * from Inventories;
go
Create View vInventories
 As 
	Select
		InventoryID
		,InventoryDate
		,EmployeeID
		,ProductID
		,Count
	From inventories ;
go
Select * from vInventories;
go
Select * from Employees;
go
Create view vEmployees
 As 
  Select
	   EmployeeID
	  ,EmployeeFirstName
	  ,EmployeeLastName
	  ,ManagerID
  From Employees
go
Select * from vEmployees */

-- With SchemaBinding to protect the views from being orphaned!
go
Create view vCategories
 With SchemaBinding
  As
	Select 
		 categoryID
		,CategoryName 
	From dbo.Categories;
go
Create View vProducts
 With SchemaBinding
  As
    Select 
		 ProductID
		,ProductName
	    ,CategoryID
	    ,UnitPrice
    From dbo.Products;
go
Create View vInventories
 With SchemaBinding
  As 
	Select
		InventoryID
		,InventoryDate
		,EmployeeID
		,ProductID
		,Count
	From dbo.Inventories;
go
Create view vEmployees
 With SchemaBinding
  As 
   Select
	   EmployeeID
	  ,EmployeeFirstName
	  ,EmployeeLastName
	  ,ManagerID
  From dbo.Employees
go
-- Question 2 (5% pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view?
 Deny Select on Categories to public
 Grant Select on vcategories to public
 go
 Deny Select on Products to public
 Grant Select on vProducts to public
 go
 Deny Select on Inventories  to public
 Grant Select on vInventories to public
 go
 Deny Select on Employees to public
 Grant Select on vEmployees to public
 go



-- Question 3 (10% pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product!
/*
go
Select * from vCategories;
Select * from vProducts;
go
Select CategoryName,ProductName,UnitPrice
  From vCategories
   inner join vProducts 
  on vCategories.CategoryID=vProducts.CategoryID;
  go
 -- Order the result by the Category and Product!
 Select CategoryName,ProductName,UnitPrice
  From vCategories
   inner join vProducts 
   on vCategories.CategoryID=vProducts.CategoryID
  order by CategoryName,ProductName;

 -- Adding alias to join Query
 go
 Select CategoryName,ProductName,UnitPrice
  From vCategories as C
   inner join vProducts as P
   on C.CategoryID=P.CategoryID
  order by CategoryName,ProductName; 
  
  --- Create the view for the above Sql 
 go
 Create view vProductsByCategories
  AS
	 Select top 1000000
		  CategoryName
		 ,ProductName
		 ,UnitPrice
	  From vCategories as C
	   inner join vProducts as P
	   on C.CategoryID=P.CategoryID
	  order by CategoryName,ProductName;
go */
  --- Create the view with schemabinding
go
 Create view vProductsByCategories
  with SchemaBinding
  AS
	 Select top 1000000
		  CategoryName
		 ,ProductName
		 ,UnitPrice
	  From dbo.vCategories as C
	   inner join dbo.vProducts as P
	   on C.CategoryID=P.CategoryID
	  order by CategoryName,ProductName;
go

--Select * from vProductsByCategories

-- Here is an example of some rows selected from the view:
-- CategoryName ProductName       UnitPrice
-- Beverages    Chai              18.00
-- Beverages    Chang             19.00
-- Beverages    Chartreuse verte  18.00


-- Question 4 (10% pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!
/*
go
Select * from vProducts;
Select *from vInventories;
go
 Select 
   ProductName
   ,InventoryDate
   ,Count
  From vProducts
   Inner join vInventories
  on vProducts.ProductID=vInventories.ProductID;
-- Order the results by the Product, Date, and Count!
go
 Select 
   ProductName
   ,InventoryDate
   ,Count
  From vProducts
   Inner join vInventories
  on vProducts.ProductID=vInventories.ProductID
  order by ProductName,InventoryDate,Count;
  -- Adding Aliases
 go
 Select 
   ProductName
   ,InventoryDate
   ,Count
  From vProducts as P
   Inner join vInventories as I
  on P.ProductID=I.ProductID
  order by ProductName,InventoryDate,Count; 

  -- Create the View for the above Sql Statement
go
Create view vInventoriesByProductsByDates
As
  Select top 1000000
	   ProductName
	   ,InventoryDate
	   ,Count
  From vProducts
   Inner join VInventories
  on vProducts.ProductID=vInventories.ProductID
  order by ProductName,InventoryDate,Count;
go */
 ---Create the view with Schemabinding 
 go
Create view vInventoriesByProductsByDates
 with SchemaBinding
	As
	  Select top 1000000
		   ProductName
		   ,InventoryDate
		   ,Count
	  From dbo.vProducts
	   Inner join dbo.VInventories
	  on dbo.vProducts.ProductID=dbo.vInventories.ProductID
	  order by ProductName,InventoryDate,Count;
go

 -- Select * from vInventoriesByProductsByDates;

-- Here is an example of some rows selected from the view:
-- ProductName	  InventoryDate	Count
-- Alice Mutton	  2017-01-01	  0
-- Alice Mutton	  2017-02-01	  10
-- Alice Mutton	  2017-03-01	  20
-- Aniseed Syrup	2017-01-01	  13
-- Aniseed Syrup	2017-02-01	  23
-- Aniseed Syrup	2017-03-01	  33


-- Question 5 (10% pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!
/*
go
Select * from vInventories;
Select * from vEmployees;
go
 Select 
    InventoryDate
   ,EmployeeFirstName+' '+EmployeeLastName as EmployeeName
   From vInventories
    inner join vEmployees
   on Inventories.EmployeeID=Employees.EmployeeID

-- Order the results by the Date and return only one row per date!
go
 Select 
    InventoryDate
   ,EmployeeFirstName+' '+EmployeeLastName as EmployeeName
   From vInventories
    inner join vEmployees
   on vInventories.EmployeeID=vEmployees.EmployeeID
   group by InventoryDate,EmployeeFirstName+' '+EmployeeLastName
   order by InventoryDate,EmployeeName;
 -- Adding Aliases
 go
 Select 
    InventoryDate
   ,EmployeeFirstName+' '+EmployeeLastName as EmployeeName
   From vInventories as I
    inner join vEmployees as E
   on I.EmployeeID=E.EmployeeID
   group by InventoryDate,EmployeeFirstName+' '+EmployeeLastName
   order by InventoryDate,EmployeeName;

   -- Create the View for the above the Sql query Statement

go
create view vInventoriesByEmployeesByDates
 As
  Select top 1000000
    InventoryDate
   ,EmployeeFirstName+' '+EmployeeLastName as EmployeeName
   From vInventories as I
    inner join vEmployees as E
   on I.EmployeeID=E.EmployeeID
   group by InventoryDate,EmployeeFirstName+' '+EmployeeLastName
   order by InventoryDate,EmployeeName;
go */
--create the view with SchemaBinding 
go
create view vInventoriesByEmployeesByDates
 with SchemaBinding
	 As
	  Select Distinct top 1000000 
	    InventoryDate
	   ,EmployeeFirstName+' '+EmployeeLastName as EmployeeName
	   From dbo.vInventories as I
		inner join dbo.vEmployees as E
	   on I.EmployeeID=E.EmployeeID
	   order by InventoryDate,EmployeeName;
go

--select * from vInventoriesByEmployeesByDates;
-- Here is are the rows selected from the view:

-- InventoryDate	EmployeeName
-- 2017-01-01	    Steven Buchanan
-- 2017-02-01	    Robert King
-- 2017-03-01	    Anne Dodsworth

-- Question 6 (10% pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!
/* go
Select * from vCategories;
Select  * from vProducts;
Select * from vInventories;
go
Select 
  CategoryName
 ,ProductName
 ,InventoryDate
 ,Count
 from vCategories
  inner join vProducts
 on vCategories.CategoryID=vProducts.CategoryID
  inner join vInventories
 on vProducts.ProductID=vInventories.ProductID
 -- Order the results by the Category, Product, Date, and Count!
go
Select 
  CategoryName
 ,ProductName
 ,InventoryDate
 ,Count
 from vCategories
  inner join vProducts
 on vCategories.CategoryID=vProducts.CategoryID
  inner join vInventories
 on vProducts.ProductID=vInventories.ProductID
 order by CategoryName,ProductName,InventoryDate,Count;

 -- Adding Aliases
 go
Select 
  CategoryName
 ,ProductName
 ,InventoryDate
 ,Count
 from vCategories as C
  inner join vProducts as P
 on C.CategoryID=P.CategoryID
  inner join vInventories as I
 on P.ProductID=I.ProductID
 order by CategoryName,ProductName,InventoryDate,Count; 

 -- Create the view for the above the sql Statement
go
Create view vInventoriesByProductsByCategories
As
 Select top 1000000
   CategoryName
  ,ProductName
  ,InventoryDate
  ,Count
 from vCategories as C
  inner join vProducts as P
 on C.CategoryID=P.CategoryID
  inner join vInventories as I
 on P.ProductID=I.ProductID
 order by CategoryName,ProductName,InventoryDate,Count;
go */
-- To Protect the view using SchemaBinding
go
Create view vInventoriesByProductsByCategories
 with SchemaBinding
	As
	 Select top 1000000
	   CategoryName
	  ,ProductName
	  ,InventoryDate
	  ,Count
	 from dbo.vCategories as C
	  inner join dbo.vProducts as P
	 on C.CategoryID=P.CategoryID
	  inner join dbo.vInventories as I
	 on P.ProductID=I.ProductID
	 order by CategoryName,ProductName,InventoryDate,Count;
go

--Select * from vInventoriesByProductsByCategories;

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count
-- CategoryName	ProductName	InventoryDate	Count
-- Beverages	  Chai	      2017-01-01	  39
-- Beverages	  Chai	      2017-02-01	  49
-- Beverages	  Chai	      2017-03-01	  59
-- Beverages	  Chang	      2017-01-01	  17
-- Beverages	  Chang	      2017-02-01	  27
-- Beverages	  Chang	      2017-03-01	  37


-- Question 7 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!
/*
go
Select * from vCategories;
Select * from vProducts;
Select * from vInventories;
Select * from vEmployees;
-- Create the first Sql join Statement
go
Select 
   CategoryName
  ,ProductName
 From vCategories
  inner join vProducts
 on vCategories.CategoryID=vProducts.CategoryID;
 --- Add the Second Sql join statement
go
Select 
   CategoryName
  ,ProductName
  ,InventoryDate
  ,Count
 From vCategories
  inner join vProducts
 on vCategories.CategoryID=vProducts.CategoryID
  inner join vInventories
 on vProducts.ProductID=vInventories.ProductID;

 -- Add the third Sql join statement
go
Select 
   CategoryName
  ,ProductName
  ,InventoryDate
  ,EmployeeFirstName+' '+EmployeeLastName as EmployeeName
  ,Count
 From vCategories
  inner join vProducts
 on vCategories.CategoryID=vProducts.CategoryID
  inner join vInventories
 on vProducts.ProductID=vInventories.ProductID
  inner join vEmployees
 on vInventories.EmployeeID=vEmployees.EmployeeID;
 -- Order the results by the Inventory Date, Category, Product and Employee!
 go
Select 
   CategoryName
  ,ProductName
  ,InventoryDate
  ,Count
  ,EmployeeFirstName+' '+EmployeeLastName as EmployeeName
 From vCategories
  inner join vProducts
 on vCategories.CategoryID=vProducts.CategoryID
  inner join vInventories
 on vProducts.ProductID=vInventories.ProductID
  inner join vEmployees
 on vInventories.EmployeeID=vEmployees.EmployeeID
 order by InventoryDate,CategoryName,ProductName,EmployeeName
--- Adding Aliases

 go
Select 
   CategoryName
  ,ProductName
  ,InventoryDate
  ,Count
  ,EmployeeFirstName+' '+EmployeeLastName as EmployeeName
 From vCategories as C
  inner join vProducts as P
 on C.CategoryID=P.CategoryID
  inner join vInventories as I
 on P.ProductID=I.ProductID
  inner join vEmployees as E
 on I.EmployeeID=E.EmployeeID
 order by InventoryDate,CategoryName,ProductName,EmployeeName; 

-- Create the View for the above Sql statement
go
Create view vInventoriesByProductsByEmployees
As
 Select top 1000000
   CategoryName
  ,ProductName
  ,InventoryDate
  ,Count
  ,EmployeeFirstName+' '+EmployeeLastName as EmployeeName
 From vCategories
  inner join vProducts
 on vCategories.CategoryID=vProducts.CategoryID
  inner join vInventories
 on vProducts.ProductID=vInventories.ProductID
  inner join vEmployees
 on vInventories.EmployeeID=vEmployees.EmployeeID
 order by InventoryDate,CategoryName,ProductName,EmployeeName;
go */
-- Create the viw with SchemaBinding
go
Create view vInventoriesByProductsByEmployees
 with SchemaBinding
	As
	 Select top 1000000
	   CategoryName
	  ,ProductName
	  ,InventoryDate
	  ,Count
	  ,EmployeeFirstName+' '+EmployeeLastName as EmployeeName
	 From dbo.vCategories
	  inner join dbo.vProducts
	 on dbo.vCategories.CategoryID=dbo.vProducts.CategoryID
	  inner join dbo.vInventories
	 on dbo.vProducts.ProductID=dbo.vInventories.ProductID
	  inner join dbo.vEmployees
	 on dbo.vInventories.EmployeeID=dbo.vEmployees.EmployeeID
	 order by InventoryDate,CategoryName,ProductName,EmployeeName;
go

--Select * from vInventoriesByProductsByEmployees;
--go
-- Here is an example of some rows selected from the view:
-- CategoryName	ProductName	        InventoryDate	Count	EmployeeName
-- Beverages	  Chai	              2017-01-01	  39	  Steven Buchanan
-- Beverages	  Chang	              2017-01-01	  17	  Steven Buchanan
-- Beverages	  Chartreuse verte	  2017-01-01	  69	  Steven Buchanan
-- Beverages	  Côte de Blaye	      2017-01-01	  17	  Steven Buchanan
-- Beverages	  Guaraná Fantástica	2017-01-01	  20	  Steven Buchanan
-- Beverages	  Ipoh Coffee	        2017-01-01	  17	  Steven Buchanan
-- Beverages	  Lakkalikööri	      2017-01-01	  57	  Steven Buchanan

-- Question 8 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? 
/*
go
Select * from vCategories;
Select * from vProducts;
Select * from vInventories;
Select * from vEmployees;
go 
Select 
   CategoryName
  ,ProductName
   From vCategories
  inner join vProducts
 on vCategories.CategoryID=vProducts.CategoryID;
 -- Add the second join statement
go 
Select 
   CategoryName
  ,ProductName
  ,InventoryDate
  ,Count
 From vCategories
  inner join vProducts
 on vCategories.CategoryID=vProducts.CategoryID
  inner join vInventories
 on vProducts.ProductID=vInventories.ProductID;

 --add the third Sql join statement with Employee table
go 
Select 
   CategoryName
  ,ProductName
  ,InventoryDate
  ,Count
  ,EmployeeFirstName+' '+EmployeeLastName as EmployeeName
From vCategories
  inner join vProducts
 on vCategories.CategoryID=Products.CategoryID
  inner join vInventories
 on vProducts.ProductID=vInventories.ProductID
   inner join vEmployees
 on vInventories.EmployeeID=vEmployees.EmployeeID;

 -- add the condition for the Products 'Chai' and 'Chang'? 
go 
Select 
   CategoryName
  ,ProductName
  ,InventoryDate
  ,Count
  ,EmployeeFirstName+' '+EmployeeLastName as EmployeeName
 From vCategories as C
  inner join vProducts as P
 on C.CategoryID=P.CategoryID
  inner join vInventories as I
 on P.ProductID=I.ProductID
   inner join vEmployees as E
 on I.EmployeeID=E.EmployeeID
 where I.ProductID=(Select P.ProductID where ProductName in('Chai','Chang'))

 --- order by the results and adding aliases
 go 
Select 
   CategoryName
  ,ProductName
  ,InventoryDate
  ,Count
  ,EmployeeFirstName+' '+EmployeeLastName as EmployeeName
 From vCategories as C
  inner join vProducts as P
 on C.CategoryID=P.CategoryID
  inner join vInventories as I
 on P.ProductID=I.ProductID
   inner join vEmployees as E
 on I.EmployeeID=E.EmployeeID
 where I.ProductID=(Select P.ProductID where ProductName in('Chai','Chang'))
  order by InventoryDate,ProductName;
 
-- Create the view for the above Sql statement
go 
Create view vInventoriesForChaiAndChangByEmployees
AS
 Select top 1000000
   CategoryName
  ,ProductName
  ,InventoryDate
  ,Count
  ,EmployeeFirstName+' '+EmployeeLastName as EmployeeName
 From vCategories as C
  inner join vProducts as P
 on C.CategoryID=P.CategoryID
  inner join vInventories as I
 on P.ProductID=I.ProductID
   inner join vEmployees as E
 on I.EmployeeID=E.EmployeeID
 where I.ProductID=(Select P.ProductID where ProductName in('Chai','Chang'))
 order by InventoryDate,ProductName;
go */
--Use the SchemaBinding to Protect the view
go 
Create view vInventoriesForChaiAndChangByEmployees
 with SchemaBinding
	AS
	 Select top 1000000
	   CategoryName
	  ,ProductName
	  ,InventoryDate
	  ,Count
	  ,EmployeeFirstName+' '+EmployeeLastName as EmployeeName
	 From dbo.vCategories as C
	  inner join dbo.vProducts as P
	 on C.CategoryID=P.CategoryID
	  inner join dbo.vInventories as I
	 on P.ProductID=I.ProductID
	   inner join dbo.vEmployees as E
	 on I.EmployeeID=E.EmployeeID
	 where I.ProductID=(Select P.ProductID where ProductName in('Chai','Chang'))
	 order by InventoryDate,ProductName;
go

--Select * from vInventoriesForChaiAndChangByEmployees;

-- Here are the rows selected from the view:

-- CategoryName	ProductName	InventoryDate	Count	EmployeeName
-- Beverages	  Chai	      2017-01-01	  39	  Steven Buchanan
-- Beverages	  Chang	      2017-01-01	  17	  Steven Buchanan
-- Beverages	  Chai	      2017-02-01	  49	  Robert King
-- Beverages	  Chang	      2017-02-01	  27	  Robert King
-- Beverages	  Chai	      2017-03-01	  59	  Anne Dodsworth
-- Beverages	  Chang	      2017-03-01	  37	  Anne Dodsworth


-- Question 9 (10% pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!
/*
go
Select * from vEmployees;
go
Select 
	  M.EmployeeFirstName+' '+M.EmployeeLastName as Manager
	 ,E.EmployeeFirstName+' '+E.EmployeeLastName as Employee
  From vEmployees as E
   inner join vEmployees as M
  on E.ManagerID=M.EmployeeID;
-- Order the results by the Manager's name!
go
Select 
	  M.EmployeeFirstName+' '+M.EmployeeLastName as Manager
	 ,E.EmployeeFirstName+' '+E.EmployeeLastName as Employee
  From vEmployees as E
   inner join vEmployees as M
  on E.ManagerID=M.EmployeeID
  order by Manager,Employee; 
-- Create the view for the above Sql Statement
go
Create view vEmployeesByManager
As
 Select top 1000000
	  M.EmployeeFirstName+' '+M.EmployeeLastName as Manager
	 ,E.EmployeeFirstName+' '+E.EmployeeLastName as Employee
  From vEmployees as E
   inner join vEmployees as M
  on E.ManagerID=M.EmployeeID
  order by Manager,Employee;
go */
go
Create view vEmployeesByManager
 with SchemaBinding
	As
	 Select top 1000000
		  M.EmployeeFirstName+' '+M.EmployeeLastName as Manager
		 ,E.EmployeeFirstName+' '+E.EmployeeLastName as Employee
	  From dbo.vEmployees as E
	   inner join dbo.vEmployees as M
	  on E.ManagerID=M.EmployeeID
	  order by Manager,Employee;
	go

--Select * from vEmployeesByManager;
-- Here are teh rows selected from the view:
-- Manager	        Employee
-- Andrew Fuller	  Andrew Fuller
-- Andrew Fuller	  Janet Leverling
-- Andrew Fuller	  Laura Callahan
-- Andrew Fuller	  Margaret Peacock
-- Andrew Fuller	  Nancy Davolio
-- Andrew Fuller	  Steven Buchanan
-- Steven Buchanan	Anne Dodsworth
-- Steven Buchanan	Michael Suyama
-- Steven Buchanan	Robert King


-- Question 10 (20% pts): How can you create one view to show all the data from all four 
-- BASIC Views? Also show the Employee's Manager Name and order the data by 
-- Category, Product, InventoryID, and Employee.
/*
go 
Select * from vCategories;
Select * from vProducts;
Select * from vInventories;
Select * from vEmployees;
go
 Select 
     vCategories.categoryID
    ,vCategories.CategoryName
	,vProducts.ProductID
	,vProducts.ProductName
	,vProducts.UnitPrice
 From vCategories 
  inner join vProducts 
 on vCategories.categoryID=vProducts.CategoryID;
 -- Add the Second Sql join statement for the VInventories
go
 Select 
     vCategories.categoryID
    ,vCategories.CategoryName
	,vProducts.ProductID
	,vProducts.ProductName
	,vProducts.UnitPrice
	,vInventories.InventoryID
	,vInventories.InventoryDate
	,vInventories.Count
 From vCategories 
  inner join vProducts 
 on vCategories.categoryID=vProducts.CategoryID
  inner join vInventories
 on vProducts.ProductID=vInventories.ProductID;

--add the third Sql join statement for the Employee table
go
 Select 
     vCategories.categoryID
    ,vCategories.CategoryName
	,vProducts.ProductID
	,vProducts.ProductName
	,vProducts.UnitPrice
	,vInventories.InventoryID
	,vInventories.InventoryDate
	,vInventories.Count
	,vEmployees.EmployeeID
	,vEmployees.EmployeeFirstName+ ' '+vEmployees.EmployeeLastName as EmployeeName
 From vCategories 
  inner join vProducts 
 on vCategories.categoryID=vProducts.CategoryID
  inner join vInventories
 on vProducts.ProductID=vInventories.ProductID
  inner join vEmployees
 on vInventories.EmployeeID=vEmployees.EmployeeID;
--order the data by Category, Product, InventoryID, and Employee
go
 Select 
     vCategories.categoryID
    ,vCategories.CategoryName
	,vProducts.ProductID
	,vProducts.ProductName
	,vProducts.UnitPrice
	,vInventories.InventoryID
	,vInventories.InventoryDate
	,vInventories.Count
	,vEmployees.EmployeeID
	,vEmployees.EmployeeFirstName+ ' '+vEmployees.EmployeeLastName as EmployeeName
 From vCategories 
  inner join vProducts 
 on vCategories.categoryID=vProducts.CategoryID
  inner join vInventories
 on vProducts.ProductID=vInventories.ProductID
  inner join vEmployees
 on vInventories.EmployeeID=vEmployees.EmployeeID
 order by vCategories.CategoryName,vProducts.ProductID,vInventories.InventoryID,EmployeeName;

 -- Also show the Employee's Manager Name 
 go
 Select 
     vCategories.categoryID
    ,vCategories.CategoryName
	,vProducts.ProductID
	,vProducts.ProductName
	,vProducts.UnitPrice
	,vInventories.InventoryID
	,vInventories.InventoryDate
	,vInventories.Count
	,E.EmployeeID
	,E.EmployeeFirstName+ ' '+E.EmployeeLastName as EmployeeName
	,M.EmployeeFirstName+ ' '+M.EmployeeLastName as ManagerName
 From vCategories 
  inner join vProducts 
 on vCategories.categoryID=vProducts.CategoryID
  inner join vInventories
 on vProducts.ProductID=vInventories.ProductID
  inner join vEmployees as E
 on vInventories.EmployeeID=E.EmployeeID
  inner join vEmployees as M
 on E.ManagerID=M.EmployeeID
 order by vCategories.CategoryName,vProducts.ProductID,vInventories.InventoryID,EmployeeName; 
-- Create the view for the above Sql statement
 go
 Create view vInventoriesByProductsByCategoriesByEmployees
  As
   Select top 1000000
     vCategories.categoryID
    ,vCategories.CategoryName
	,vProducts.ProductID
	,vProducts.ProductName
	,vProducts.UnitPrice
	,vInventories.InventoryID
	,vInventories.InventoryDate
	,vInventories.Count
	,E.EmployeeID
	,E.EmployeeFirstName+ ' '+E.EmployeeLastName as EmployeeName
	,M.EmployeeFirstName+ ' '+M.EmployeeLastName as ManagerName
 From vCategories 
  inner join vProducts 
 on vCategories.categoryID=vProducts.CategoryID
  inner join vInventories
 on vProducts.ProductID=vInventories.ProductID
  inner join vEmployees as E
 on vInventories.EmployeeID=E.EmployeeID
  inner join vEmployees as M
 on E.ManagerID=M.EmployeeID
 order by vCategories.CategoryName,vProducts.ProductID,vInventories.InventoryID,EmployeeName;
 go */
 -- Use the SchemaBinding to protect the view
 go
 Create view vInventoriesByProductsByCategoriesByEmployees
  with SchemaBinding
	  As
	   Select top 1000000
		 C.categoryID
		,C.CategoryName
		,P.ProductID
		,P.ProductName
		,P.UnitPrice
		,I.InventoryID
		,I.InventoryDate
		,I.Count
		,E.EmployeeID
		,E.EmployeeFirstName+ ' '+E.EmployeeLastName as EmployeeName
		,M.EmployeeFirstName+ ' '+M.EmployeeLastName as ManagerName
	 From dbo.vCategories as C
	  inner join dbo.vProducts as P
	 on C.categoryID=P.CategoryID
	  inner join dbo.vInventories as I
	 on P.ProductID=I.ProductID
	  inner join dbo.vEmployees as E
	 on I.EmployeeID=E.EmployeeID
	  inner join dbo.vEmployees as M
	 on E.ManagerID=M.EmployeeID
	 order by C.CategoryName,P.ProductID,I.InventoryID,EmployeeName;
 go
--Select * from vInventoriesByProductsByCategoriesByEmployees

-- Here is an example of some rows selected from the view:
-- CategoryID	  CategoryName	ProductID	ProductName	        UnitPrice	InventoryID	InventoryDate	Count	EmployeeID	Employee
-- 1	          Beverages	    1	        Chai	              18.00	    1	          2017-01-01	  39	  5	          Steven Buchanan
-- 1	          Beverages	    1	        Chai	              18.00	    78	          2017-02-01	  49	  7	          Robert King
-- 1	          Beverages	    1	        Chai	              18.00	    155	          2017-03-01	  59	  9	          Anne Dodsworth
-- 1	          Beverages	    2	        Chang	              19.00	    2	          2017-01-01	  17	  5	          Steven Buchanan
-- 1	          Beverages	    2	        Chang	              19.00	    79	          2017-02-01	  27	  7	          Robert King
-- 1	          Beverages	    2	        Chang	              19.00	    156	          2017-03-01	  37	  9	          Anne Dodsworth
-- 1	          Beverages	    24	      Guaraná Fantástica	  4.50	    24	          2017-01-01	  20	  5	          Steven Buchanan
-- 1	          Beverages	    24	      Guaraná Fantástica	  4.50	    101	          2017-02-01	  30	  7	          Robert King
-- 1	          Beverages	    24	      Guaraná Fantástica	  4.50	    178	          2017-03-01	  40	  9	          Anne Dodsworth
-- 1	          Beverages	    34	      Sasquatch Ale	          14.00	    34	          2017-01-01	  111	  5	          Steven Buchanan
-- 1	          Beverages	    34	      Sasquatch Ale	          14.00	    111	          2017-02-01	  121	  7	          Robert King
-- 1	          Beverages	    34	      Sasquatch Ale	          14.00	    188	          2017-03-01	  131	  9	          Anne Dodsworth


-- Test your Views (NOTE: You must change the names to match yours as needed!)
Print 'Note: You will get an error until the views are created!'
Select * From [dbo].[vCategories]
Select * From [dbo].[vProducts]
Select * From [dbo].[vInventories]
Select * From [dbo].[vEmployees]

Select * From [dbo].[vProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByDates]
Select * From [dbo].[vInventoriesByEmployeesByDates]
Select * From [dbo].[vInventoriesByProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByEmployees]
Select * From [dbo].[vInventoriesForChaiAndChangByEmployees]
Select * From [dbo].[vEmployeesByManager]
Select * From [dbo].[vInventoriesByProductsByCategoriesByEmployees]

/***************************************************************************************/