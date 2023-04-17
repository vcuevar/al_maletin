

-- Para Bateria de Excepciones de MULIIX


--Los Articulos en factor de conversion no deben ser cero, en caso que se de dejar en 1 

select * from Articulos

select * from ArticulosFactoresConversion
where AFC_FactorConversion IS NULL


--update ArticulosFactoresConversion set AFC_FactorConversion = 1 Where AFC_FactorConversion = 0

Select * from OrdenesCompraDetalle where OCD_AFC_FactorConversion = 0
