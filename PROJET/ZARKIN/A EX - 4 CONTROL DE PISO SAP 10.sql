-- Concentrado de EXCEPCIONES DE CONTROL DE PISO.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 01 de Agosto del 2019; Inicio.
-- Actualizado: Jueves 01 de Agosto del 2019; Integrar Excepcion de Usuarios Supervisor.
-- Actualizado: Viernes 23 de Julio del 2021; SAP-10

-- En todas las estaciones debe existir un usuario activo, con correo en caso de,
-- y que su posicion sea SUPERVISOR
-- ya que se requiere para que se les envie notificaciones de reprocesos y otros.
-- Excepto la 100. y solo debe haber un supervisor.

Select SUPER.REPORTE, SUPER.NOMBRE
From (
Select	'SUP. 100 OP PLANEACION.' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%100%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 106 PREPARADO PIEL' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%106%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 109 ANAQUEL CORTE ' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%109%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 112 CORTE DE PIEL ' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%112%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 115 INSP. DE CORTE' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%115%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 118 PEGADO COSTURA' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%118%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 121 ANAQUEL COSTUR' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%121%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 124 COSTURA RECTA ' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%124%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 127 ARMADO COSTURA' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%127%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 130 PESPUNTE O DOB' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%130%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 133 TERMINADO COST' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%133%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 136 INSPECCION COS' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%136%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 139 SERIES INCOMP ' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%139%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 145 ACOJINADO     ' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%145%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 148 FUNDAS TERMINA' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%148%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 151 KITING        ' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%151%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 154 ENFUNDADO TAPI' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%154%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 157 TAPIZ         ' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%157%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 160 ARMADO TAPIZ  ' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%160%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 172 EMPAQUE       ' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%172%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 175 INSP. FINAL   ' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%175%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 200 OP PLANEACION.' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%200%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 206 HAB. HULE CNC.' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%206%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 209 ARMADO DE HULE' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%209%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 212 PEGADO DE HULE' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%212%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 218 PEGADO DE HULE' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%218%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 221 ENTREGA HULE. ' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%221%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 400 OP PLANEACION.' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%400%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 403 RECIBE HABIL. ' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%403%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 406 ARMADO CASCO. ' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%406%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 409 TAPADO CASCO. ' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%409%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 415 PEGADO HULE.  ' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%415%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  Union all
Select	'SUP. 418 SUB-CASCO.    ' as REPORTE, Isnull((Select top(1) Cast(OHEM.U_EmpGiro as VarChar(6)) + '  ' + OHEM.firstName + '  ' + OHEM.lastName from OHEM where OHEM.U_CP_CT like '%418%' and OHEM.position = 4 and OHEM.status = 1),'NO_ASIGNADO') as NOMBRE  
) SUPER
Where SUPER.NOMBRE Like '%NO_ASIGNADO%'   
	   	 
-- Alerta de Lineas Duplicadas en Control de Piso.
	Select '005 LINEAS DUPLICADAS' AS REPORTE_005
		, U_DocEntry AS OP
		, U_CT AS ESTACION
		, R.Name
		, COUNT(U_DocEntry) As Cantidad
		, O.PlannedQty
	From [@CP_OF] P
	Inner join OWOR O on P.U_DocEntry= O.DocNum
	Inner join [@PL_RUTAS] R on P.U_CT = R.Code
	Where O.Status='R'
	Group By U_DocEntry, U_CT, R.Name, O.PlannedQty
	Having COUNT(U_DocEntry) > O.PlannedQty

-- SACAR LINEAS DUPLICADAS EN EL CONTROL DE PISO
	Select '010 LINEA DUPLICADA CP' AS REPORTE_010
		, U_DocEntry
		, Veces
		, U_CT
	From (
	select U_DocEntry, U_CT,COUNT(U_DocEntry) As Veces from [@CP_OF]
	Group By U_DocEntry, U_CT) DUB
	where veces> 1

-- Consulta para Buscar aplicaciones de Entradas Dobles.	

	Select '022 ? ENTRADAS DUPLICADAS' as REPORTE, DUDA.Duplicado, DUDA.BaseRef, OWOR.ItemCode, A3.ItemName, DUDA.Recibo1, RB.DocDate
	from (
	Select IGN1.BaseRef, COUNT(IGN1.BaseRef) as Duplicado,(Select Top 1 REC.DocEntry from IGN1 REC where REC.BaseRef=IGN1.BaseRef
	order by REC.BaseRef) as Recibo1
	from IGN1
	inner join OITM A3 on IGN1.ItemCode=A3.ItemCode
	where A3.U_TipoMat='PT'-- and BaseRef = 21210
	group by IGN1.BaseRef
	) DUDA
	inner join OWOR on DUDA.BaseRef= OWOR.DocEntry
	inner join OITM A3 on OWOR.ItemCode=A3.ItemCode
	inner join OIGN RB on DUDA.Recibo1=RB.DocEntry
	where DUDA.Duplicado > 1  and Cast(RB.DocDate as DATE) >  CONVERT (DATE, '2023/10/10', 102)
	and DUDA.BaseRef <> 40923 
	and DUDA.BaseRef <> 42119 -- Reporto Andrea 240206
	and DUDA.BaseRef <> 40084 and DUDA.BaseRef <> 42445 -- Duplicadas de Marzo 2024
	and DUDA.BaseRef <> 45343 and DUDA.BaseRef <> 45342 and DUDA.BaseRef <> 56503
	order by RB.DocDate,A3.ItemName



--< EOF > EXCEPCIONES DE CONTROL DE PISO.