-- Query reporte materias primas resumen
-- Actualizado: 26-May-20; Juan Antonio Gomez me envio consulta base Materias Primas Resumen
--


-- Columns que se Requieren
--      Almacen
--      Localidad
--      Nombre de Categoria
--      Codigo Articulo
--      Descripcion del Material
--      UdM
--      Existencia
--      Costo
--      Importe
--      Clave (1 MATERIA PRIMA. 2 MAT. PROCESO.  3 PROD. TERMINADO,  4 NO CONTABLE)

-- Desarrollo de la Consulta.

SELECT  Case When LOC_LocalidadId = '49D778C5-BF1C-4683-A9B5-46DB602862C8' then '1 MAT PRIMA' 
             When LOC_LocalidadId = '0547A9FC-4919-459E-920B-15A9A09882AD' then '7 NO CONTABLE'
             When LOC_LocalidadId = '24F8921F-F6BA-47AC-8E93-C035D44F5E99' then '7 NO CONTABLE'
             When LOC_LocalidadId = '581650A9-63D6-43C0-815D-30922AD402D9' then '2 WIP MATERIAL'
             When LOC_LocalidadId = '0D6A6312-1B21-4D49-9A3A-632B89ACBA2D' then '2 WIP MATERIAL'
             When LOC_LocalidadId = '6F3F5BE4-285E-4DF7-B189-A62F0A74AA1B' then '1 MAT PRIMA'
             When LOC_LocalidadId = '61AF170D-A584-4AC9-B1AA-5540DB65E6B0' then '1 MAT PRIMA'
             When LOC_LocalidadId = '1FB5AA3F-45E3-4511-B4AE-27941334CDCC' then '1 MAT PRIMA'
             When LOC_LocalidadId = '10E76110-2A50-48E2-A212-3747C9AAEA4F' then '7 NO CONTABLE'
             When LOC_LocalidadId = 'E6FD8AA4-62FA-4B67-BCCE-D549C9E3BABF' then '5 X SUBIR OT'
             When LOC_LocalidadId = 'F4B69178-D90C-450C-BA3A-7AEAEC308180' then '5 X SUBIR OT'
             When LOC_LocalidadId = '8DCEC3E4-B9C1-4014-9643-5B777473576C' then '2 WIP MATERIAL'
             When LOC_LocalidadId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF' then '3 PROD. TERM.'
             When LOC_LocalidadId = '34EDC394-529F-4EAE-9761-E12C4D838EDE' then '7 NO CONTABLE'
             else '9 NO DEFINIDO' end AS CLAVE
        , LOC_Nombre
        , ART_CodigoArticulo
        , ART_Nombre
        , CMUM_Nombre    
        , SUM(CANTIDAD) AS CANTIDAD
        , SUM(COSTO_TOTAL) / SUM(CANTIDAD) AS UNITARIO
        , SUM(COSTO_TOTAL) AS COSTO_TOTAL
FROM (SELECT
              UPPER(ALM_CodigoAlmacen) AS ALM_CodigoAlmacen
            , LOC_LocalidadId
            , UPPER(LOC_Nombre) AS LOC_Nombre
            , UPPER(LOT_CodigoLote) AS LOT_CodigoLote 
            , ART_ArticuloId
            , UPPER(ART_CodigoArticulo) AS ART_CodigoArticulo
            , ART_Nombre AS ART_Nombre
            , CASE WHEN CMUM_UnidadMedidaId = '3A70E33B-B8D5-405D-B5AD-3A84A8A52875' THEN 'Kg' ELSE CMUM_Nombre END AS CMUM_Nombre
            , SUM(TRLOT_CantidadTraspaso) AS CANTIDAD
            , SUM((ISNULL(LOT_CostoUnitario, 0.0) + ISNULL(LOT_ValorIndirectoMaterial, 0.0)) * TRLOT_CantidadTraspaso) / SUM(TRLOT_CantidadTraspaso) AS UNITARIO
            , (SUM((ISNULL(LOT_CostoUnitario, 0.0) + ISNULL(LOT_ValorIndirectoMaterial, 0.0)) * TRLOT_CantidadTraspaso) / SUM(TRLOT_CantidadTraspaso)) * SUM(TRLOT_CantidadTraspaso) AS COSTO_TOTAL
        FROM TraspasosMovtos
        INNER JOIN TraspasosLotes ON TRAM_TraspasoMovtoId = TRLOT_TRAM_TraspasoMovtoId
        INNER JOIN LotesLocalidades ON TRLOT_LOTL_LoteLocalidadId = LOTL_LoteLocalidadId
        INNER JOIN Localidades ON LOTL_LOC_LocalidadId = LOC_LocalidadId
        INNER JOIN Almacenes ON LOC_ALM_AlmacenId = ALM_AlmacenId
        INNER JOIN Lotes ON LOTL_LOT_LoteId = LOT_LoteId
        INNER JOIN Articulos ON LOT_ART_ArticuloId = ART_ArticuloId
        INNER JOIN ArticulosFamilias ON ART_AFAM_FamiliaId = AFAM_FamiliaId
        LEFT  JOIN ArticulosCategorias ON ART_ACAT_CategoriaId = ACAT_CategoriaId
        LEFT  JOIN ArticulosFactoresConversion ON ART_ArticuloId = AFC_ART_ArticuloId AND AFC_CMUM_UnidadMedidaId = '3A70E33B-B8D5-405D-B5AD-3A84A8A52875'
        INNER JOIN ControlesMaestrosUM ON ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId
        
        WHERE TRLOT_FechaTraspaso <= '20250520 23:59:59'
        and ART_Activo = 0  -- Para sacar excepcion donde hay existencia y esta inactivo.
        --AND LOC_LocalidadId IN ('49D778C5-BF1C-4683-A9B5-46DB602862C8') --  1 ALMACEN MATERIAS PRIMAS
        --AND LOC_LocalidadId IN ('0547A9FC-4919-459E-920B-15A9A09882AD') --  1 MATERIALES CONSIGNADOS.
        --AND LOC_LocalidadId IN ('24F8921F-F6BA-47AC-8E93-C035D44F5E99') --  1 MERMA NO CONTABLE
        --AND LOC_LocalidadId IN ('581650A9-63D6-43C0-815D-30922AD402D9') --  2 ANAQUELES WIP 1
        --AND LOC_LocalidadId IN ('0D6A6312-1B21-4D49-9A3A-632B89ACBA2D') --  2 ANAQUELES WIP 2
        --AND LOC_LocalidadId IN ('6F3F5BE4-285E-4DF7-B189-A62F0A74AA1B') --  2 HULE ESPUMA
        --AND LOC_LocalidadId IN ('61AF170D-A584-4AC9-B1AA-5540DB65E6B0') --  2 LACA ALMACEN
        --AND LOC_LocalidadId IN ('1FB5AA3F-45E3-4511-B4AE-27941334CDCC') --  2 MADERAS Y TABLEROS
        --AND LOC_LocalidadId IN ('10E76110-2A50-48E2-A212-3747C9AAEA4F') --  2 METALMX
        --AND LOC_LocalidadId IN ('E6FD8AA4-62FA-4B67-BCCE-D549C9E3BABF') --  2 PISO WIP 1
        --AND LOC_LocalidadId IN ('F4B69178-D90C-450C-BA3A-7AEAEC308180') --  2 PISO WIP 2
        --AND LOC_LocalidadId IN ('8DCEC3E4-B9C1-4014-9643-5B777473576C') --  2 VALLARTA
        --AND LOC_LocalidadId IN ('62EAAF01-1020-4C75-9503-D58B07FFC6EF') --  3 ALMACEN DE PRODUCTO TERMINADO
        --AND LOC_LocalidadId IN ('34EDC394-529F-4EAE-9761-E12C4D838EDE') --  A BORRAR PRO 2 JAZMIN FUNDAS Y TAPIZADOS

        --AND ALM_AlmacenId IN ('C0138CFF-C57E-401D-BFE4-05C4188732B9')  
                                  
        GROUP BY 
                ALM_CodigoAlmacen
            , LOC_LocalidadId
            , LOC_Nombre
            , LOT_CodigoLote 
            , ART_ArticuloId
            , ART_CodigoArticulo
            , ART_Nombre
            , CMUM_Nombre
            , CMUM_UnidadMedidaId
        HAVING SUM(TRLOT_CantidadTraspaso) > 0
    ) AS TEMP
GROUP BY 
        LOC_LocalidadId
    , ART_CodigoArticulo
    , ART_Nombre
    , CMUM_Nombre
    , LOC_Nombre
ORDER BY 
      LOC_Nombre, ART_CodigoArticulo



--SELECT * FROM LOCALIDADES where LOC_Eliminado = 0 ORDER BY LOC_Nombre