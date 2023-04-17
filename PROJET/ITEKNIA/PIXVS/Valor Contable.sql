UPDATE Articulos
SET ART_UltimoCostoPromedio = 90, 
    ART_UltimoCostoUltimo = 90
WHERE ART_CMM_TipoCostoId = '0FA4FF4C-538C-4FDF-B77C-F0F034B67440' AND ART_CodigoArticulo IN ( '9192')

UPDATE Articulos
SET ART_UltimoCostoPromedio = CASE WHEN ART_UltimoCostoPromedio IS NULL OR ART_UltimoCostoPromedio = 0 THEN ART_CostoMaterialEstandar ELSE ART_UltimoCostoPromedio END, 
    ART_UltimoCostoUltimo = CASE WHEN ART_UltimoCostoPromedio IS NULL OR ART_UltimoCostoPromedio = 0 THEN ART_CostoMaterialEstandar ELSE ART_UltimoCostoUltimo END 
WHERE ART_CMM_TipoCostoId = '0FA4FF4C-538C-4FDF-B77C-F0F034B67440' AND ART_CodigoArticulo IN ( '0959',  '9192')




SELECT *
FROM Articulos
WHERE ART_CodigoArticulo IN ( '0959',  '9192')


UPDATE TransferenciasMovtos
SET TRAM_ValorContableArticuloActual = ART_UltimoCostoPromedio
--SELECT ART_CodigoArticulo--TRAM_ValorContableArticuloActual, ART_UltimoCostoPromedio, *
FROM TransferenciasMovtos
INNER JOIN Articulos ON TRAM_ART_ArticuloId = ART_ArticuloId
INNER JOIN (
			SELECT 
				TRAM_ART_ArticuloId AS ARTICULO_ID, ROW_NUMBER() OVER(PARTITION BY TRAM_ART_ArticuloId ORDER BY TRAM_FechaTransferencia DESC) FILA, TRAM_FechaTransferencia, TRAM_TransferenciaMovtoId ID
			FROM TransferenciasMovtos 
			WHERE TRAM_ART_ArticuloId IN (
'08418B13-A616-4FE0-BE43-2A34A4727B79',
'FF4D1ACF-AD73-4906-BA98-1FE763A03A4A' )
		   ) AS TEMP ON TRAM_TransferenciaMovtoId = ID
WHERE FILA = 1 AND ART_CMM_TipoCostoId = '0FA4FF4C-538C-4FDF-B77C-F0F034B67440' AND ART_Activo = 1 AND ART_Borrado = 0
