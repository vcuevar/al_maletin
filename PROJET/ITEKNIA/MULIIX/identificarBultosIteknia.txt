--identificar estatus de bultos y sus tablas iteknia

--PARA SABER QUE EL BULTO ESTA RECIBIDO bultos
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
WHERE BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0

--PARA SABER QUE EL BULTO ESTA RECIBIDO estatus bultos complemento
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoPadreId
Where BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0  and BUL_CMM_TipoBultoId = 'A00E0707-1CC9-4F59-8BA6-CD1DC4D82DD4'

--PARA SABER QUE EL BULTO ESTA RECIBIDO Y SE CONSIDERE EXISTENTE EN ALMACEN NO TIENE QUE ESTAR PRE-EMBARCADO 
WHERE BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0 AND ISNULL(PREBD_Embarcado, 0) = 0

--PARA SABER SI ESTA PREEMBARCADO
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoPadreId
LEFT JOIN PreembarqueBultoDetalle ON BULD_BultoDetalleId = PREBD_BULD_BultoDetalleId AND PREBD_Eliminado = 0
WHERE ISNULL(PREBD_Embarcado, 0) = 1

--PARA SABER SI ESTA EMBARCADO
select * from PreembarqueBulto
INNER JOIN PreembarqueBultoDetalle ON PREBD_PREB_PreembarqueBultoId = PREB_PreembarqueBultoId AND PREBD_Eliminado = 0
INNER JOIN BultosDetalle ON BULD_BultoDetalleId = PREBD_BULD_BultoDetalleId
INNER JOIN Bultos ON BUL_BultoId = BULD_BUL_BultoId
WHERE ISNULL(PREBD_Embarcado, 0) = 1


--para saber en que embarque se genero esta el reporte embaruqes bultos
FROM EmbarquesBultos
INNER JOIN EmbarquesBultosDetalle ON  EMBB_EmbarqueBultoId = EMBBD_EMBB_EmbarqueBultoId AND EMBBD_Eliminado = 0
INNER JOIN TraspasosMovtos ON EMBBD_EmbarqueBultoDetalleId = TRAM_ReferenciaMovtoId
LEFT JOIN Articulos ON ART_ArticuloId = TRAM_ART_ArticuloId
INNER JOIN PreembarqueBultoDetalle ON EMBBD_PREBD_PreembarqueBultoDetalleId = PREBD_PreembarqueBultoDetalleId
INNER JOIN PreembarqueBulto ON PREBD_PREB_PreembarqueBultoId = PREB_PreembarqueBultoId AND PREBD_Eliminado = 0
INNER JOIN BultosDetalle ON BULD_BultoDetalleId = PREBD_BULD_BultoDetalleId
INNER JOIN Bultos ON BUL_BultoId = BULD_BUL_BultoId
WHERE TRAM_CMM_TipoTransferenciaId = 'FB9DD40D-14AB-4AD4-AB2E-AD887C80FDE3'
AND EMBB_Eliminado = 0
            AND EMBB_FechaCreacion between '20220901 00:00:00' and '20220921 23:59:59'
            order by EMBB_CodigoEmbarqueBulto, ART_CodigoArticulo



