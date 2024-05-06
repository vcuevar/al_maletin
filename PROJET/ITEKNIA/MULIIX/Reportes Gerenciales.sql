-- Consulta para realizar ajustes a los reportes Gerenciales.
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizado: 03 de Septiembre del 2020.

-- Reporte detallado del Estado de Costo

select RGC_tabla_linea, RGC_tabla_titulo, RGC_BC_Cuenta_Id, BC_Cuenta_Nombre, BC_Movimiento_01, (BC_Movimiento_01*RGC_multiplica) as DAT_OK
from RPT_RG_ConfiguracionTabla 
inner join RPT_BalanzaComprobacion on RGC_BC_Cuenta_Id = BC_Cuenta_Id
where RGC_hoja = 3 and BC_Ejercicio = '2023'
Order by RGC_tabla_linea

-- Reporte detallado del Estado de Costo AZARET
select RGC_tabla_linea, RGC_tabla_titulo, RGC_BC_Cuenta_Id, BC_Cuenta_Nombre, BC_Movimiento_04, (BC_Movimiento_04*RGC_multiplica) as DAT_OK
from RPT_RG_ConfiguracionTabla 
inner join RPT_BalanzaComprobacionAzaret on RGC_BC_Cuenta_Id = BC_Cuenta_Id
where RGC_hoja = 3 and BC_Ejercicio = '2023'
Order by RGC_tabla_linea



Select (BC_Movimiento_01 + BC_Movimiento_02 + BC_Movimiento_03 + BC_Movimiento_04 + BC_Movimiento_05 + BC_Movimiento_06 + BC_Movimiento_07
+ BC_Movimiento_08 + BC_Movimiento_09 + BC_Movimiento_10 + BC_Movimiento_11+ BC_Movimiento_12) as TOTAL, *
 from RPT_BalanzaComprobacion Where BC_Ejercicio = 2023 and BC_Cuenta_Id like '%108-%' and
(BC_Movimiento_01 + BC_Movimiento_02 + BC_Movimiento_03 + BC_Movimiento_04 + BC_Movimiento_05 + BC_Movimiento_06 + BC_Movimiento_07
+ BC_Movimiento_08 + BC_Movimiento_09 + BC_Movimiento_10 + BC_Movimiento_11) > 0 
Order by BC_Cuenta_Id


BC_Cuenta_Id =  '601-100-000'

-- Balanza de Comprobación Iteknia

Select * from RPT_BalanzaComprobacion Where BC_Ejercicio = 2023 
--and BC_Cuenta_Id like '%-000-000' -- and BC_Movimiento_01+BC_Movimiento_02+BC_Movimiento_03 <> 0
Order by BC_Cuenta_Id

--Delete RPT_BalanzaComprobacion Where BC_Ejercicio = 2022 

605-000-0015 ,605-000-016 Y 605-000-017 .


SELECT * FROM RPT_BalanzaComprobacion
where BC_Ejercicio = '2022' and BC_Cuenta_Id = '150-001-000'
-- where BC_Ejercicio = '2022' and BC_Cuenta_Nombre = 'ANTICIPO CLIENTES EXTRAJNERO'
205-027-000


Select * from RPT_BalanzaComprobacion Where BC_Ejercicio = 2021 --and BC_Cuenta_Id = '104-100-000' 
Order By BC_Cuenta_id

108-002-700     MO
601-100-000     MO
108-003-709     MAQUILAS
108-003-700     GASTOS IND
108-003-709     GASTOS IND


BC_Movimiento_02 <> 0 BC_Saldo_Inicial
(null)

BC_Cuenta_Id = '601-327-000'

--update RPT_BalanzaComprobacion set BC_Movimiento_01 = 582110.94 Where BC_Ejercicio = 2020 and BC_Cuenta_Id = '108-001-300'
--update RPT_BalanzaComprobacion set BC_Saldo_Inicial=0, BC_Saldo_Final=0, BC_Movimiento_01=0, BC_Movimiento_04=0 where BC_Cuenta_Id = '108-003-716'

-- Balanza de Comprobacion Comercializadora
	Select * from RPT_BalanzaComprobacionComercializadora Where BC_Ejercicio = 2024 Order by BC_Cuenta_Id 
	
-- Update RPT_BalanzaComprobacionComercializadora Set BC_Movimiento_07 = 0 Where BC_Ejercicio = 2023

-- Balanza de Comprobación Azaret

Select * from RPT_BalanzaComprobacionAzaret Where BC_Ejercicio = 2024 and BC_Cuenta_Id like '101-%' --and BC_Cuenta_Id =  '604-000-017'-- and BC_Movimiento_01 <> 0

-- Update RPT_BalanzaComprobacionAzaret Set BC_Movimiento_07 = 0 Where BC_Ejercicio = 2023


Select * from RPT_BalanzaComprobacionComercializadora Where BC_Ejercicio = 2023 and BC_Cuenta_Id like '211-%'


--Update RPT_BalanzaComprobacionAzaret Set BC_Movimiento_07 = 0 Where BC_Ejercicio = 2023

-- Ajustes datos adicionales que se capturan Manualmente.
Select * from RPT_RG_Ajustes

-- Definicion del que catalogo de cuenta a usar.
Select * from RPT_RG_CatalogoVersionCuentas

-- Configuracion de los campos que se utilizan en los reportes

Para tener los datos que corresponden al reporte.
1.- Balanza General.
2.- Estado de Perdidas y Ganancias.
3.- Estado de Costos 
4.- Inventarios.
5.- Gastos de Fabricacion
6.- Gastos de Administración
7.- Gastos de Ventas
8.- Gastos Financieros.

15.- BASURA

select RGC_BC_Cuenta_Id, RGC_hoja, RGC_sociedad 
from RPT_RG_ConfiguracionTabla where RGC_hoja = 15 -- and RGC_sociedad = 3 
Order by RGC_tabla_linea, RGC_BC_Cuenta_Id, RGC_sociedad


33.- Formulas de Reporte de Costos.

Campo RGC_Sociedad
1	ITEKNIA 
2	COMERCIALIZADORA 
3	AZARET

-- Consulta de cuentas por Reporte

select * from RPT_RG_ConfiguracionTabla 
where RGC_hoja = 1 and RGC_sociedad = 3
--where RGC_BC_Cuenta_Id = '300-910-000' --and RGC_hoja = 2  and RGC_sociedad = 2
Order by RGC_tabla_linea

-- Ajustar Orden de una Cuenta en el Reporte
update RPT_RG_ConfiguracionTabla 
set RGC_tabla_linea = 11
where RGC_hoja = 2 and RGC_sociedad = 3 and RGC_BC_Cuenta_Id = '602-000-000'

-- Enviar a Basura una Cuenta
update RPT_RG_ConfiguracionTabla
Set RGC_hoja = 15
where RGC_BC_Cuenta_Id = '452-000-000' and RGC_hoja = 2  and RGC_sociedad = 2


-- Cambiar algun campo a la configuracion, del reporte y de la cuenta.

update RPT_RG_ConfiguracionTabla set 
        --RGC_BC_Cuenta_Id = '300-910-000'
        --, RGC_tipo_renglon = 'CUENTA'
        --, RGC_hoja = 1
        --, RGC_tabla_titulo = 'RESULTADOS'
        --, RGC_tabla_linea = 32
        --, RGC_descripcion_cuenta = 'RESULTADO DEL EJERCICIO 2023' 
        --, RGC_fecha_alta = '2023-10-04'
         RGC_multiplica = -1
        --, RGC_sociedad = 3
        --, RGC_BC_Cuenta_Id2 = '-1'
        --, RGC_hojaDescripcion  = '01 BALANCE GENERAL'
 where RGC_BC_Cuenta_Id = '300-910-000' and RGC_hoja = 1  and RGC_sociedad = 3 
        
-- Para dar alta a una nueva cuenta

605-000-015	INCAPACIDAD PAGADA POR EMPRESA      34
605-000-016	PTU (MANO DE OBRA DIRECTA)          35
605-000-017	PRIMA DE ANTIGUEDAD                 36

Octubre 07,2021
108-001-601	COMPRAS IMPORTACION

INSERT INTO [dbo].[RPT_RG_ConfiguracionTabla]
        ([RGC_BC_Cuenta_Id], [RGC_tipo_renglon], [RGC_hoja], [RGC_tabla_titulo], [RGC_tabla_linea],[RGC_descripcion_cuenta], [RGC_fecha_alta], [RGC_mostrar], [RGC_multiplica], [RGC_sociedad], [RGC_BC_Cuenta_Id2])
VALUES 
  ( '300-800-000' ,'CUENTA' , 1,'RESULTADOS', 30,'RESULTADO DEL EJERCICIO 2021', '2023-09-21', 0, 1, 3, '-1')

GO

INSERT INTO [dbo].[RPT_RG_ConfiguracionTabla]
        ([RGC_BC_Cuenta_Id], [RGC_tipo_renglon], [RGC_hoja], [RGC_tabla_titulo], [RGC_tabla_linea],[RGC_descripcion_cuenta], [RGC_fecha_alta], [RGC_mostrar], [RGC_multiplica], [RGC_sociedad], [RGC_BC_Cuenta_Id2])
VALUES 
  ( '300-900-000' ,'CUENTA' , 1,'RESULTADOS', 31,'RESULTADO DEL EJERCICIO 2022', '2023-09-21', 0, 1, 3, '-1')

GO




-- Datos
Select * from RPT_RG_Documentos

-- Tabla temporal donde se cargan las informaciones del Calculo.
Select * from RPT_RG_VariablesReporte


-- Inventarios Cargados en Reportik para el reporte Gerencial.
Select * from RPT_InventarioContable where IC_Ejercicio= '2022' and IC_Periodo = '01'
Order By IC_LOC_Nombre





