-- Plantilla de Personal
-- ID: 230508-1
--TAREA: Llevar control de Usuarios conforme a los ingresos en Recursos Humanos.
-- SOLICITO: Brenda Trejo por David Zarkin.

-- Consulta de Todos los Usuarios

Select OHST.name AS Estatus, OHEM.empID as Control_Piso
	, OHEM.U_EmpGiro as Nomina
	, OHEM.firstName+' '+OHEM.lastName as Nombre
	, OHEM.U_CP_CT as Actividad
	, OHEM.jobTitle as Area
	, OHEM.dept as Num_Depto
	, OUDP.Name as Depto
	, OHTY.name as Modulo_SIZ 
from OHEM 
INNER JOIN OUDP ON OHEM.dept=OUDP.Code 
INNER JOIN OUBR ON OHEM.branch=OUBR.Code 
LEFT JOIN HEM6 ON OHEM.empID = HEM6.empID 
LEFT JOIN OHTY ON HEM6.roleID = OHTY.typeID 
LEFT JOIN OHST ON OHEM.status = OHST.statusID 
where OHEM.Status = 1 And  OHEM.U_CP_CT like '%136%' 
order by OUBR.Name, OHEM.jobTitle, ohem.firstname
 



-- Usuarios de SAP

select userSign2, * from OUSR
order by ousr.userSign2

select USERID, INTERNAL_K, USER_CODE, U_NAME, E_Mail, DISCOUNT, WallPaper
from OUSR
where U_NAME like '%DEY%'
order by USER_CODE


-- Usuarios Reporteria.

select * from SIRS
where clv=234

update SIRS set clv=948, nom='SALVADOR FUENTES MALDONADO'
where clv=234



sELECT * FROM OHEM
oRDER by U_EmpGiro




Select OHEM.U_EmpGiro AS NOMINA
	, OHEM.firstName+' '+OHEM.lastName AS NOMBRE
	, OHEM.jobTitle as Area
from OHEM 
where OHEM.Status = 1 
order by ohem.firstname
 