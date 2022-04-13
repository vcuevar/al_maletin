--ESTO ES LO QUE HAY CAPTURADO EN EL PERIODO (DESDE MULIIX)
select * from RPT_InventarioContable
where IC_periodo = '01'


-- ESTO ES LO QUE OBTENGO PARA MOSTRAR EN REPORTIK
-- COMO VEMOS NO ESTAN TODAS LAS LOCALIDADES CONFIGURADAS EN LA TABLA RPT_RG_ConfiguracionTabla SOLO 2 coinciden
SELECT COALESCE([IC_Ejercicio], 0) AS IC_Ejercicio
      ,COALESCE([IC_periodo], 0) AS IC_periodo
      ,COALESCE(Localidades.LOC_Nombre, 'SIN NOMBRE') AS IC_LOC_Nombre
      ,COALESCE([IC_CLAVE], 'SIN CLAVE') AS IC_CLAVE    
      ,COALESCE([IC_MAT_PRIMA], 0) AS IC_MAT_PRIMA
      ,COALESCE([IC_WIP], 0) AS IC_WIP
      ,COALESCE([IC_PROD_TERM], 0) AS IC_PROD_TERM
	  ,COALESCE([IC_COSTO_TOTAL], 0) AS IC_COSTO_TOTAL
	  ,ct.*
	  ,COALESCE(Localidades.LOC_CodigoLocalidad, RGC_BC_Cuenta_Id) AS LOC_CodigoLocalidad
                            FROM RPT_RG_ConfiguracionTabla ct
							LEFT JOIN RPT_InventarioContable on ct.RGC_BC_Cuenta_Id = IC_CLAVE
							LEFT JOIN Localidades on LOC_LocalidadId = RGC_BC_Cuenta_Id
                    where  (IC_periodo = '01' OR IC_periodo IS NULL) and (IC_Ejercicio = '2020' OR IC_Ejercicio IS NULL) and ct.RGC_hoja = '3' and RGC_tabla_linea > 7
                    ORDER BY RGC_tabla_linea