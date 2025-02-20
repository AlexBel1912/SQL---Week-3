SHOW DATABASES;
USE adventureworksdw;
SHOW TABLES;

-- 1.Implementa una vista denominata Product al fine di creare unʼanagrafica (dimensione) prodotto completa. 
-- La vista, se interrogata o utilizzata come sorgente dati, deve esporre il nome prodotto, il nome della sottocategoria associata e il nome della categoria associata.

CREATE VIEW Product 	
	AS ( 
    SELECT 
		p.EnglishProductName AS NomeProdotto, 
        r.EnglishProductSubcategoryName AS NomeSottocategoria,
        z.EnglishProductCategoryName AS NomeCategoria
			FROM dimproduct AS p
            JOIN dimproductsubcategory AS r ON p.ProductSubcategoryKey = r.ProductSubcategoryKey
				JOIN dimproductcategory AS z ON z.ProductCategoryKey = r.ProductCategoryKey);
                
                SELECT * FROM Product;
                
-- 2.Implementa una vista denominata Reseller al fine di creare unʼanagrafica (dimensione) reseller completa. 
-- La vista, se interrogata o utilizzata come sorgente dati, deve esporre il nome del reseller, il nome della città e il nome della regione.

CREATE VIEW Reseller 
	AS ( 
    SELECT 
		dimreseller.ResellerName AS NomeReseller,
        dimgeography.City AS Citta,
        dimgeography.EnglishCountryRegionName AS NomeRegione
			FROM dimreseller JOIN dimgeography ON dimreseller.GeographyKey = dimgeography.GeographyKey);
            
            SELECT * FROM dimsalesterritory;
            
-- 3. Crea una vista denominata Sales che deve restituire:
		-- la data dellʼordine, 
        -- il codice documento, 
        -- la riga di corpo del documento, 
        -- la quantità venduta, 
        -- lʼimporto totale e 
        -- il profitto.
CREATE VIEW Sales AS (
	SELECT
		factresellersales.OrderDate AS DataOrdine,
        factresellersales.SalesOrderNumber AS CodiceDocumento,
        factresellersales.SalesOrderLineNumber AS RigaDocumento,
        factresellersales.OrderQuantity AS QuantitaVenduta,
        factresellersales.SalesAmount AS ImportoTotale,
        (factresellersales.SalesAmount - factresellersales.TotalProductCost) AS Profitto
        FROM factresellersales
			UNION ALL
            SELECT
        factinternetsales.OrderDate AS DataOrdine,
        factinternetsales.SalesOrderNumber AS CodiceDocumento,
        factinternetsales.SalesOrderLineNumber AS RigaDocumento,
        factinternetsales.OrderQuantity AS QuantitaVenduta,
        factinternetsales.SalesAmount AS ImportoTotale,
        (factinternetsales.SalesAmount - factinternetsales.TotalProductCost) AS Profitto
			FROM factinternetsales
        );
        SELECT * FROM Sales;
        
        -- 4. Crea un report in Excel che consenta ad un utente di analizzare quantità venduta, importo totale e profitti per prodotto/categoria prodotto e reseller/regione. 
        
    