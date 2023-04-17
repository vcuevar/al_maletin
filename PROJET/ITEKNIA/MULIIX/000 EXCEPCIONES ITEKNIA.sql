-- Reporte de Excepciones
-- ITEKNIA EQUIPAMIENTO, S.A. de C.V.
-- Desarrollo: Ing. Vicente Cueva Ramírez
-- Actualizado: 07 de Enero del 2022; Origen.

--Validar Usuario Vigentes y con Empleado NO ACTIVO, Actividad Dar de Baja Como Usuario.
select '001 DAR BAJA USUARIO' AS REPORTE
        , EMP_CodigoEmpleado AS CODIGO
        , EMP_Nombre + '  ' + EMP_PrimerApellido + '  ' + EMP_SegundoApellido AS NOMBRE
        , Case When EMP_Activo = 1 then 'ACTIVO' else 'DAR DE BAJA' end AS ACTIVO
        , USU_Contrasenia AS CONTRASEÑA
        , PER_CodigoPermiso AS COD_PERMISO	
        , PER_TipoPermiso AS TIPO_PERMISO
from Usuarios
Inner Join Empleados on EMP_EmpleadoId = USU_EMP_EmpleadoId
Inner Join Permisos on PER_PermisoId = USU_PER_PermisoId
where USU_Activo = 1 and EMP_Activo = 0


--Validar Usuario Inactivo sin fecha de Baja. (VEN EN MULIIX CREO FUERON BORRADOS PARA PONER FECHA BAJA IGUAL A FECHA ALTA)
select '002 SIN FECHA BAJA' AS REPORTE
        , EMP_EmpleadoId AS ID
        , EMP_CodigoEmpleado AS CODIGO
        , EMP_Nombre + '  ' + EMP_PrimerApellido + '  ' + EMP_SegundoApellido AS NOMBRE
        , Case When EMP_Activo = 1 then 'ACTIVO' else 'DAR DE BAJA' end AS ACTIVO
        , Cast(EMP_FechaIngreso as date) AS FECH_ING
        , Cast(EMP_FechaEgreso as date) AS FECH_BAJA
        --, USU_Contrasenia AS CONTRASEÑA
        --, PER_CodigoPermiso AS COD_PERMISO	
        --, PER_TipoPermiso AS TIPO_PERMISO
        -- , *
from Empleados
--Inner Join Empleados on EMP_EmpleadoId = USU_EMP_EmpleadoId
--Inner Join Permisos on PER_PermisoId = USU_PER_PermisoId
--where EMP_CodigoEmpleado = '759' 
Where EMP_Activo = 0 and EMP_FechaEgreso is null

/*
--230322 Se cargo fecha a estos dos registros que se generaron duplicados.
Update Empleados Set EMP_FechaEgreso = Cast('2023-03-21' as date) Where EMP_EmpleadoId = '79EA582B-A861-4252-8908-44C971636B61'
Update Empleados Set EMP_FechaEgreso = Cast('2023-01-30' as date) Where EMP_EmpleadoId = 'C2DE42C9-9863-4B93-9A03-3B45F4BF6F79'

-- 221019 Se les cargo fecha de Egreso a todos estos empleados que no la tenian.
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '6e0cbb2c-cf69-4cf2-884d-6ba654ce8d9d'
Update Empleados Set EMP_FechaEgreso = Cast('2022-05-10' as date) Where EMP_EmpleadoId = 'd118e0ab-33cb-45e3-9bf2-b8f1333e56c3'
Update Empleados Set EMP_FechaEgreso = Cast('2022-08-22' as date) Where EMP_EmpleadoId = 'd3d607f5-dc0c-4a0a-840c-755eb17d2b6d'
Update Empleados Set EMP_FechaEgreso = Cast('2022-02-09' as date) Where EMP_EmpleadoId = '36adf12a-f8ef-4196-b002-8d006e200ade'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '0d792ef8-e1de-4245-a942-dd0d623dd972'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = 'c6e6d580-852e-4668-a715-3f423933b23e'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '7fd96ca6-6ce5-4101-9073-bd2ffbd5fa0c'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '1cd4d330-2ee7-4b6e-9eed-c67764077852'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '9b90fd4a-fdc4-4fd1-b157-28e7df3fd1df'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = 'ad1db857-4348-4692-8228-290983a845bc'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = 'cce91459-4d98-46ef-bb5c-d3a71b04fc41'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '3354345e-e15a-451d-8d2f-baf9087aecac'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '9562b651-4f85-4f4f-93c9-28a72eaf0019'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '2c9d06ce-1a2b-4446-a79f-72783ec5ee5e'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = 'a05a207f-8b89-4a32-babb-e9fd3665fb34'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '3aa253e8-259c-45c6-967f-d1e03fa3f7b6'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '4233e84c-0a43-4a5c-9742-92be75d44be8'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '00101790-1ce3-4066-92d8-8f45701704fe'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = 'd863378a-f019-452b-85b5-2070cfec1572'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = 'b1e42740-ef90-4851-b862-1d5b19e36324'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '5b88da2c-fa99-4877-8e2e-e0e260be868d'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '0413545b-1612-496c-a39f-34835fcff446'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = 'dfececf7-7634-4bc2-9658-07b48c7ce122'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '8b7ce5ca-74e4-4199-9870-f58781c01f5b'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '072bb403-2576-4f38-926f-a9c0c5e1b185'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '7101e652-ce68-4088-b46b-d4cf7a7a6f76'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '845a2fc2-b4be-447f-8fd3-97a0b45a043c'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = 'cf979380-8219-487f-92d1-a368b8713901'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '6d2bcecd-d1ba-4c9c-b54e-660e5b10d8bc'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = 'b2a99724-2951-4c4c-a82d-f1d13744ec95'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = 'e9672ec1-da73-4925-abc1-685474172a64'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = '47ec7de6-e49a-44a7-b0bc-c7eabdd92ad6'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = 'f8fee4c6-192f-4134-b946-febb11433472'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = 'f00d2205-7848-4fb1-96a1-c80ee1e13844'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = 'f918a27e-1fc4-4e6b-865f-33f1d7aed685'

Excepcion del 9 de Marzo del 2023. Solicite informacion a Jaq/Este.
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = 'C2DE42C9-9863-4B93-9A03-3B45F4BF6F79'

select * from empleados where EMP_CodigoEmpleado = '002'
select * from empleados where EMP_EmpleadoId = '3A2D4A67-BB29-493B-BFB1-3A1A03310372' --Este es el 0001 y el 002 es el 75
select * from usuarios where USU_EMP_EmpleadoId = '8EDFC690-978A-4112-B61C-1999CD0C71F5'
select * from usuarios where USU_Nombre = '002'
update Usuarios set USU_EMP_EmpleadoId = '8EDFC690-978A-4112-B61C-1999CD0C71F5' where USU_Nombre = '002'

*/

-- Determinar Materiales que no tienen tiempo de Entrega y se concideran para M&M

Select	ART_CodigoArticulo as CODIGO
        , ART_Nombre as NOMBRE
        , Convert(Decimal(28,2), ART_NoDiasAbastecimiento) AS DIA_ABS  
        , Convert(Decimal(28,2), ART_CantMinimaOrden) AS MINIMO
        , Convert(Decimal(28,2), ART_CantMaximaOrden) AS MAXIMO
from Articulos
Where ART_Activo = 1 and ART_CantMaximaOrden > 0.01 and ART_NoDiasAbastecimiento = 0

--and (ART_NoDiasAbastecimiento = 0 or ART_NoDiasAbastecimiento is null)
--and (ART_CantMaximaOrden > 0 or ART_CantMaximaOrden is not null)



-- Para Bateria de Excepciones de MULIIX
-- Validar y ver que funcion tienen estas dos 

--Los Articulos en factor de conversion no deben ser cero, en caso que se de dejar en 1 

select * from Articulos

select * from ArticulosFactoresConversion
where AFC_FactorConversion IS NULL


--update ArticulosFactoresConversion set AFC_FactorConversion = 1 Where AFC_FactorConversion = 0

Select * from OrdenesCompraDetalle where OCD_AFC_FactorConversion = 0


-- Validar que todos los Eliminados tengan estatus de Cerradas por usuario.
select * from OrdenesVenta 
Where OV_Eliminado = 1 and 
OV_CMM_EstadoOVId <> '2209C8BF-8259-4D8C-A0E9-389F52B33B46'


-- Para corregir asignar este cambio.
--update OrdenesVenta set OV_CMM_EstadoOVId = '2209C8BF-8259-4D8C-A0E9-389F52B33B46' Where OV_Eliminado = 1 and  OV_CMM_EstadoOVId <> '2209C8BF-8259-4D8C-A0E9-389F52B33B46'


-- Validar que NO haya Dolar a 1

Select*
From OrdenesVenta where OV_MON_MonedaId ='1EA50C6D-AD92-4DE6-A562-F155D0D516D3'and OV_MONP_Paridad = 1
and OV_CodigoOV >'OV00887'
Order By OV_CodigoOV




--identificar estatus de bultos y sus tablas iteknia
-- Para hacer la validacion de las existencias contra los bultos
--PARA SABER QUE EL BULTO ESTA RECIBIDO bultos

Select *
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
WHERE BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0



--PARA SABER QUE EL BULTO ESTA RECIBIDO estatus bultos complemento
Select *
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoPadreId
Where BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0  and BUL_CMM_TipoBultoId = 'A00E0707-1CC9-4F59-8BA6-CD1DC4D82DD4'



--PARA SABER QUE EL BULTO ESTA RECIBIDO Y SE CONSIDERE EXISTENTE EN ALMACEN NO TIENE QUE ESTAR PRE-EMBARCADO 
Select *
From Bu
WHERE BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0 AND ISNULL(PREBD_Embarcado, 0) = 0



--PARA SABER SI ESTA PREEMBARCADO

Select *
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
Select *
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


