CREATE DATABASE Restaurant

USE Restaurant

CREATE TABLE Meals
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(20),
	Price MONEY,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id)
)

CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(50)
)

CREATE TABLE Ingredients
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(50)
)

CREATE TABLE MealsIngredients
(
	MealId INT FOREIGN KEY REFERENCES Meals(Id),
	IngredientId INT FOREIGN KEY REFERENCES Ingredients(Id)
)

-- Insert data into Categories table
INSERT INTO Categories (Name)
VALUES ('Appetizers'), ('Main Dishes'), ('Desserts');

-- Insert data into Meals table
INSERT INTO Meals (Name, Price, CategoryId)
VALUES ('Caesar Salad', 8.99, 1),
       ('Spaghetti Carbonara', 12.99, 2),
       ('New York Strip Steak', 24.99, 2),
       ('Cheesecake', 6.99, 3);

-- Insert data into Ingredients table
INSERT INTO Ingredients (Name)
VALUES ('Lettuce'), ('Croutons'), ('Parmesan Cheese'),
       ('Spaghetti'), ('Bacon'), ('Eggs'), ('Steak'),
       ('Cream'), ('Cheese'), ('Graham Cracker Crumbs');

-- Insert data into MealsIngredients table
INSERT INTO MealsIngredients (MealId, IngredientId)
VALUES (1, 1), (1, 2), (1, 3),    -- Caesar Salad ingredients
       (2, 4), (2, 5), (2, 6),    -- Spaghetti Carbonara ingredients
       (3, 7),                    -- New York Strip Steak ingredients
       (4, 8), (4, 9), (4, 10);   -- Cheesecake ingredients

-- Bütün yeməkləri yanında ingredient sayı ilə birlikdə select edən query
SELECT *, (SELECT COUNT(*) FROM MealsIngredients WHERE Meals.Id=MealId) AS IngredientCount FROM Meals

-- Bütün category-ləri yanında o kateqoriyadaki ən bahalı və ən ucuz yemək qiyməti ilə select edən query
SELECT * FROM Categories LEFT JOIN (SELECT CategoryId, MIN(Price) AS Min, MAX(Price) AS Max FROM Meals
GROUP BY CategoryId) AS MealPrices ON MealPrices.CategoryId=Categories.Id

-- Bütün yemekləri select edib yanında category adını da göstərən query
SELECT Meals.*, MealCategories.Name AS CategoryName FROM  Meals 
LEFT JOIN (SELECT Id, Name FROM Categories) AS MealCategories ON MealCategories.Id = Meals.CategoryId

-- Hec bir yeməyi olmayan katqoriyaları select edən query
SELECT * FROM Categories LEFT JOIN Meals ON Categories.Id=Meals.CategoryId WHERE Meals.Id IS NULL

