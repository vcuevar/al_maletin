-- Con el codigo del Articulo determinar el ID del Articulo buscar que no este en Factores y si no esta dar de alta 






select * from articulos
where ART_CodigoArticulo = '3863.3-8'

'3863.3-8'

select * from ArticulosFactoresConversion
where AFC_ART_ArticuloId =  'C2B4D07D-CBFB-46FE-86E2-35723E07F76A'

where AFC_ART_ArticuloId =  '10C9F221-1039-414B-862E-882B2E4BBAC6'


AFC_FactorConversionId = '70723AED-7F6A-4D9F-BD31-A74584B19A6A'

Select * from ArticulosUMPresentaciones
C2B4D07D-CBFB-46FE-86E2-35723E07F76A


select ART_CMUM_UMInventarioId, ART_CMUM_UMInventarioId, ART_CMUM_UMConversionOCId, ART_CMUM_UMConversionOVId from Articulos
where ART_CodigoArticulo = '0057.1-3'


C381CFE3-4D1E-4127-9A10-FF7422A52EAE	C2B4D07D-CBFB-46FE-86E2-35723E07F76A	70723AED-7F6A-4D9F-BD31-A74584B19A6A	1.0000000000	2020-05-19 09:58:57	true	2020-05-19 09:58:57	(null)
C381CFE3-4D1E-4127-9A10-FF7422A52EAE	C2B4D07D-CBFB-46FE-86E2-35723E07F76A	70723AED-7F6A-4D9F-BD31-A74584B19A6A	1.0000000000	2020-05-19 09:58:57	true	2020-05-19 09:58:57	(null)

Select  AFC_FactorConversionId,
        AFC_ART_ArticuloId,
        AFC_CMUM_UnidadMedidaId,
        AFC_FactorConversion,
        AFC_FechaUltimaModificacion,
        AFC_FechaCreacion,
        AFC_EMP_ModificadoPorId
From ArticulosFactoresConversion
where AFC_ART_ArticuloId =  'C2B4D07D-CBFB-46FE-86E2-35723E07F76A' 
