-- Concentrado de EXCEPCIONES DE CONTROL DE PISO.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 01 de Agosto del 2019; Inicio.
-- Actualizado: Jueves 01 de Agosto del 2019; Integrar Excepcion de Usuarios Supervisor.
-- Actualizado: Viernes 23 de Julio del 2021; SAP-10

-- En todas las estaciones debe existir un usuario activo, con correo en caso de,
-- no contar con correo, poner el manuel.spindola y que su posicion sea SUPERVISOR
-- ya que se requiere para que se les envie notificaciones de reprocesos y otros.
-- Excepto la 100. y solo debe haber un supervisor.

--DEBE HABER 20 RENGLONES DE SUPERVISORES --
/*
Select	'SUP. 106 PREPARADO PIEL' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%106%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 109 ANAQUEL CORTE ' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%109%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 112 CORTE DE PIEL ' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%112%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 115 INSP. DE CORTE' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%115%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 118 PEGADO COSTURA' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%118%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 121 ANAQUEL COSTUR' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%121%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 124 COSTURA RECTA ' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%124%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 127 ARMADO COSTURA' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%127%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 130 PESPUNTE O DOB' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%130%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 133 TERMINADO COST' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%133%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 136 INSPECCION COS' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%136%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 139 SERIES INCOMP ' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%139%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 142 LLENADO COJIN ' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%142%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 145 ACOJINADO     ' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%145%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 148 FUNDAS TERMINA' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%148%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 151 KITING        ' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%151%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 154 ENFUNDADO TAPI' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%154%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 157 TAPIZ         ' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%157%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 160 ARMADO TAPIZ  ' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%160%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 172 EMPAQUE       ' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%172%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 175 INSP. FINAL   ' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%175%' and OHEM.position = 4 and OHEM.status = 1 Union all

Select	'SUP. 403 REC. HABILIT. ' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%403%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 406 ARMADO        ' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%406%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 415 PEGADO HULE   ' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%415%' and OHEM.position = 4 and OHEM.status = 1 Union all

Select	'SUP. 303 INICIAR ORDEN ' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%303%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 306 HABILITADO    ' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%306%' and OHEM.position = 4 and OHEM.status = 1 Union all
Select	'SUP. 309 CORTE CARTONES' as REPORTE, OHEM.U_EmpGiro as N_NOM, OHEM.firstName + '  ' + OHEM.lastName as NOMBRE, (Select OHPS.name from OHPS Where OHPS.posID = OHEM.position) as POSICION, OHEM.status from OHEM where OHEM.U_CP_CT like '%309%' and OHEM.position = 4 and OHEM.status = 1 
*/
	
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
	where DUDA.Duplicado > 1 and DUDA.BaseRef<> 1563 and DUDA.BaseRef <> 6732 and DUDA.BaseRef <> 8847 and DUDA.BaseRef <> 24104
	and DUDA.BaseRef <> 21210 and DUDA.BaseRef <> 25406
	order by RB.DocDate,A3.ItemName



--< EOF > EXCEPCIONES DE CONTROL DE PISO.