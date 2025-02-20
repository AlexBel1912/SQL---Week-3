SHOW DATABASES;

Use AdventureWorksDW;

SELECT * FROM dimproduct; 

-- 1. Scrivi una query per verificare che il campo ProductKey nella tabella DimProduct sia una chiave primaria. 
-- Quali considerazioni/ragionamenti è necessario che tu faccia?

SHOW INDEX FROM AdventureWorksDW.dimproduct WHERE Key_name = 'PRIMARY';

SELECT COUNT(ProductKey) FROM dimproduct;
SELECT DISTINCT COUNT(ProductKey) FROM dimproduct;

DESCRIBE dimproduct;

SELECT ProductKey, COUNT(*) AS univocita
FROM dimproduct
GROUP BY ProductKey
HAVING COUNT(*) > 0;

-- 2.Scrivi una query per verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber sia una PK.

SELECT * FROM information_schema.KEY_COLUMN_USAGE
	WHERE TABLE_NAME = 'factresellersales' AND CONSTRAINT_SCHEMA = 'AdventureWorksDW'
	AND COLUMN_NAME IN ('SalesOrderNumber', 'SalesOrderLineNumber') AND CONSTRAINT_NAME = 'Primary';

-- SELECT * FROM information_schema.TABLE_CONSTRAINTS;
-- SELECT * FROM information_schema.KEY_COLUMN_USAGE;

-- 3.Conta il numero transazioni (SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020.
-- SELECT SalesOrderLineNumber, OrderDate FROM factresellersales WHERE OrderDate = '2020-01-02';

SELECT COUNT(SalesOrderLineNumber) AS NumeroTransazioni, OrderDate
	FROM factresellersales
    WHERE OrderDate >= '2020-01-01'
    GROUP BY OrderDate;
      
    
-- 4. Calcola il fatturato totale (FactResellerSales.SalesAmount), la quantità totale venduta (FactResellerSales.OrderQuantity) e il prezzo medio di vendita (FactResellerSales.UnitPrice) per prodotto (DimProduct) a partire dal 1 Gennaio 2020. 
-- Il result set deve esporre pertanto il nome del prodotto, il fatturato totale, la quantità totale venduta e il prezzo medio di vendita. I campi in output devono essere parlanti!

SELECT dimproduct.EnglishProductName AS NomeProdotto, SUM(factresellersales.SalesAmount) AS FatturatoTotale, SUM(factresellersales.OrderQuantity) AS QuantitaTotaleVenduta, AVG(factresellersales.UnitPrice) AS PrezzoMedioDiVendita
	FROM dimproduct
    JOIN factresellersales ON factresellersales.ProductKey = dimproduct.ProductKey
    WHERE OrderDate >= '2020-01-01'
		GROUP BY dimproduct.EnglishProductName;
        
-- 2.1 Calcola il fatturato totale (FactResellerSales.SalesAmount) e la quantità totale venduta (FactResellerSales.OrderQuantity) per Categoria prodotto (DimProductCategory). Il result set deve esporre pertanto il nome della categoria prodotto, il fatturato totale e la quantità totale venduta. I campi in output devono essere parlanti!
   SELECT dimproductcategory.EnglishProductCategoryName AS NomeProdotto, SUM(factresellersales.SalesAmount) AS FatturatoTotale, SUM(factresellersales.OrderQuantity) AS QuantitaTotaleVenduta
	FROM factresellersales JOIN dimproduct ON factresellersales.ProductKey = dimproduct.ProductKey
		JOIN dimproductsubcategory ON dimproduct.ProductSubcategoryKey = dimproductsubcategory.ProductSubcategoryKey
			JOIN dimproductcategory ON dimproductsubcategory.ProductCategoryKey = dimproductcategory.ProductCategoryKey
            GROUP BY dimproductcategory.ProductCategoryKey;
	
-- SELECT distinct(EnglishProductCategoryName) FROM dimproductcategory;

-- 2.2 Calcola il fatturato totale per area città (DimGeography.City) realizzato a partire dal 1 Gennaio 2020. 
-- Il result set deve esporre lʼelenco delle città con fatturato realizzato superiore a 60K.

SELECT dimgeography.City AS City, SUM(factresellersales.SalesAmount) AS FatturatoTotale FROM dimgeography
	JOIN dimreseller ON dimreseller.GeographyKey = dimgeography.GeographyKey
		JOIN factresellersales ON factresellersales.ResellerKey = dimreseller.ResellerKey
			WHERE factresellersales.OrderDate >= '2020-01-01'
				GROUP BY City 
					HAVING FatturatoTotale > 60000;