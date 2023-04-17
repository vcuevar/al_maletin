-- Concentrado de Excepciones del Area de Sistemas,
-- Aquellas que afectan el funcionamiento de SIZ.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 01 de Agosto del 2019; Inicio.
-- Actualizado: Jueves 01 de Agosto del 2019; Integrar Excepcion de Usuarios Supervisor.
-- Actualizado: Viernes 23 de Julio del 2021; SAP-10

-- En todas las estaciones debe existir un usuario activo, con correo en caso de,
-- no contar con correo, poner el vicente.cueva y que su posicion sea SUPERVISOR
-- ya que se requiere para que se les envie notificaciones de reprocesos y otros.
-- Excepto la 100. y solo debe haber un supervisor.

--DEBE HABER 20 RENGLONES DE SUPERVISORES --

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



