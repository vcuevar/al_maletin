-- Carga del nuevo catalogo de cuentas para los gastos de fabricacion.
-- Para reportik Reportes Gerenciales.
-- Elaboro: Ing. Vicente Cueva Ramirez.
-- Solicito: Lorena Talavera.
-- Actualizado: Martes 19 de Enero del 2021; Origen.

-- Consulta para ver las cuentas actuales.

select * 
from RPT_RG_ConfiguracionTabla 
where RGC_hoja = 5 
Order by RGC_tabla_linea

-- Actulizar Datos del Registro

Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'MANO DE OBRA 1', RGC_tabla_linea = 1.0 Where RGC_BC_Cuenta_Id = '108-002-700'












-- Insertar Registros Nuevos

USE [ItekniaDB]
GO

INSERT INTO [dbo].[RPT_RG_ConfiguracionTabla]
           ([RGC_BC_Cuenta_Id]
           ,[RGC_tipo_renglon]
           ,[RGC_hoja]
           ,[RGC_tabla_titulo]
           ,[RGC_tabla_linea]
           ,[RGC_descripcion_cuenta]
           ,[RGC_fecha_alta]
           ,[RGC_mostrar]
           ,[RGC_multiplica])
     VALUES
			('605-000-000', 'CUENTA', 5, 'MANO DE OBRA', 36.0, 'MANO DE OBRA DIRECTA', '2021-01-19', '0', 1)
			,('604-000-001', 'CUENTA', 5, 'GASTOS INDIRECTOS', 37.0, 'MTTO Y REFACCIONES', '2021-01-19', '0', 1)
			,('604-000-002', 'CUENTA', 5, 'GASTOS INDIRECTOS', 38.0,	'RENTA', '2021-01-19', '0', 1)
			,('604-000-003', 'CUENTA', 5, 'GASTOS INDIRECTOS', 39.0,	'LUZ', '2021-01-19', '0', 1)
			,('604-000-004', 'CUENTA', 5, 'GASTOS INDIRECTOS', 40.0,	'AGUA PURIFICADA', '2021-01-19', '0', 1)
			,('604-000-005', 'CUENTA', 5, 'GASTOS INDIRECTOS', 41.0,	'DEPRECIACION MOBILIARIO Y EQUIPO DE OFICINA', '2021-01-19', '0', 1)
			,('604-000-006', 'CUENTA', 5, 'GASTOS INDIRECTOS', 42.0,	'DEPRECIACION MAQUINARIA Y EQUIPO INDUSTRIAL', '2021-01-19', '0', 1)
			,('604-000-007', 'CUENTA', 5, 'GASTOS INDIRECTOS', 43.0,	'DEPRECIACION OTROS ACTIVOS', '2021-01-19', '0', 1)
			,('604-000-008', 'CUENTA', 5, 'GASTOS INDIRECTOS', 44.0,	'AGUA POTABLE', '2021-01-19', '0', 1)
			,('604-000-009', 'CUENTA', 5, 'GASTOS INDIRECTOS', 45.0,	'MAQUILA', '2021-01-19', '0', 1)
			,('604-000-010', 'CUENTA', 5, 'GASTOS INDIRECTOS', 46.0,	'MATERIALES COMPLEMENTARIOS', '2021-01-19', '0', 1)
			,('604-000-011', 'CUENTA', 5, 'GASTOS INDIRECTOS', 47.0,	'TRABAJOS COMPLEMENTARIOS', '2021-01-19', '0', 1)
			,('604-000-012', 'CUENTA', 5, 'GASTOS INDIRECTOS', 48.0,	'FLETES', '2021-01-19', '0', 1)
			,('604-000-013', 'CUENTA', 5, 'GASTOS INDIRECTOS', 49.0,	'MANIOBRAS Y SEGUROS', '2021-01-19', '0', 1)
			,('604-000-014', 'CUENTA', 5, 'GASTOS INDIRECTOS', 50.0,	'PAQUETERIA Y MENSAJERIA', '2021-01-19', '0', 1)
			,('604-000-015', 'CUENTA', 5, 'GASTOS INDIRECTOS', 51.0,	'UNIFORMES Y EQUIPO DE SEGURIDAD', '2021-01-19', '0', 1)
	
	GO

/*  Contenido de la tabla
			(<RGC_BC_Cuenta_Id, nvarchar(50),>
           ,<RGC_tipo_renglon, nvarchar(50),>
           ,<RGC_hoja, int,>
           ,<RGC_tabla_titulo, nvarchar(50),>
           ,<RGC_tabla_linea, decimal(18,1),>
           ,<RGC_descripcion_cuenta, nvarchar(max),>
           ,<RGC_valor_default, nvarchar(max),>
           ,<RGC_fecha_alta, date,>
           ,<RGC_mostrar, nvarchar(10),>
           ,<RGC_estilo, nvarchar(max),>
           ,<RGC_multiplica, decimal(18,2),>)
*/


select * 
from RPT_RG_ConfiguracionTabla 
where RGC_hoja = 3
Order by RGC_tabla_linea



Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'MANO DE OBRA 1', RGC_tabla_linea =60 Where RGC_BC_Cuenta_Id = '108-002-700' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =61 Where RGC_BC_Cuenta_Id = '108-001-800' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =62 Where RGC_BC_Cuenta_Id = '108-003-701' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =63 Where RGC_BC_Cuenta_Id = '108-003-702' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =64 Where RGC_BC_Cuenta_Id = '108-003-703' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =65 Where RGC_BC_Cuenta_Id = '108-003-704' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =66 Where RGC_BC_Cuenta_Id = '108-003-705' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =67 Where RGC_BC_Cuenta_Id = '108-003-706' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =68 Where RGC_BC_Cuenta_Id = '108-003-707' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =69 Where RGC_BC_Cuenta_Id = '108-003-708' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =70 Where RGC_BC_Cuenta_Id = '108-003-709' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =71 Where RGC_BC_Cuenta_Id = '108-003-710' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =72 Where RGC_BC_Cuenta_Id = '108-003-711' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =73 Where RGC_BC_Cuenta_Id = '108-003-712' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =74 Where RGC_BC_Cuenta_Id = '108-003-713' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =75 Where RGC_BC_Cuenta_Id = '108-003-714' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =76 Where RGC_BC_Cuenta_Id = '108-003-715' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =77 Where RGC_BC_Cuenta_Id = '108-003-716' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =78 Where RGC_BC_Cuenta_Id = '108-003-717' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =79 Where RGC_BC_Cuenta_Id = '108-003-718' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =80 Where RGC_BC_Cuenta_Id = '108-003-719' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =81 Where RGC_BC_Cuenta_Id = '108-003-720' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =82 Where RGC_BC_Cuenta_Id = '108-003-721' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =83 Where RGC_BC_Cuenta_Id = '108-003-722' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =84 Where RGC_BC_Cuenta_Id = '108-003-723' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =85 Where RGC_BC_Cuenta_Id = '108-003-724' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =86 Where RGC_BC_Cuenta_Id = '108-003-725' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =87 Where RGC_BC_Cuenta_Id = '108-003-726' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =88 Where RGC_BC_Cuenta_Id = '108-003-727' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =89 Where RGC_BC_Cuenta_Id = '108-003-728' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =90 Where RGC_BC_Cuenta_Id = '108-003-729' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =91 Where RGC_BC_Cuenta_Id = '108-003-730' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =92 Where RGC_BC_Cuenta_Id = '108-003-731' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =93 Where RGC_BC_Cuenta_Id = '108-003-734' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_titulo = 'GASTOS INDIRECTOS 1', RGC_tabla_linea =94 Where RGC_BC_Cuenta_Id = '108-003-735' and RGC_hoja = 5

Update RPT_RG_ConfiguracionTabla set RGC_tabla_linea =1 Where RGC_BC_Cuenta_Id = '605-000-000' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_linea =2 Where RGC_BC_Cuenta_Id = '604-000-001' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_linea =3 Where RGC_BC_Cuenta_Id = '604-000-002' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_linea =4 Where RGC_BC_Cuenta_Id = '604-000-003' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_linea =5 Where RGC_BC_Cuenta_Id = '604-000-004' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_linea =6 Where RGC_BC_Cuenta_Id = '604-000-005' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_linea =7 Where RGC_BC_Cuenta_Id = '604-000-006' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_linea =8 Where RGC_BC_Cuenta_Id = '604-000-007' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_linea =9 Where RGC_BC_Cuenta_Id = '604-000-008' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_linea =10 Where RGC_BC_Cuenta_Id = '604-000-009' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_linea =11 Where RGC_BC_Cuenta_Id = '604-000-010' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_linea =12 Where RGC_BC_Cuenta_Id = '604-000-011' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_linea =13 Where RGC_BC_Cuenta_Id = '604-000-012' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_linea =14 Where RGC_BC_Cuenta_Id = '604-000-013' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_linea =15 Where RGC_BC_Cuenta_Id = '604-000-014' and RGC_hoja = 5
Update RPT_RG_ConfiguracionTabla set RGC_tabla_linea =16 Where RGC_BC_Cuenta_Id = '604-000-015' and RGC_hoja = 5


-- Cargar nuevas cuentas a Reporte de Costos de Fabricacion.

USE [ItekniaDB]
GO

INSERT INTO [dbo].[RPT_RG_ConfiguracionTabla]
           ([RGC_BC_Cuenta_Id]
           ,[RGC_tipo_renglon]
           ,[RGC_hoja]
           ,[RGC_tabla_titulo]
           ,[RGC_tabla_linea]
           ,[RGC_descripcion_cuenta]
           ,[RGC_fecha_alta]
           ,[RGC_mostrar]
           ,[RGC_multiplica])
     VALUES
         ('605-000-000', 'CUENTA', 3, 'MO', 3.3, 'MANO DE OBRA', '2021-01-20', '0', 1)
	,('604-000-009', 'CUENTA', 3, 'MAQUILAS', 4.1, 'MAQUILA', '2021-01-20', '0', 1)
	,('604-000-000', 'CUENTA', 3, 'GASTOS IND', 6.2, 'GASTOS IND', '2021-01-20', '0', 1)
	,('604-000-009', 'CUENTA', 3, 'GASTOS IND', 6.3, 'MAQUILA', '2021-01-20', '0', -1)
GO



