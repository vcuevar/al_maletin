

/*
Select * from OUDP
Code	Name	Remarks	UserSign
-2	General	Departamento general	1
1	ALMACEN	ALMACEN DE MATERIAS PRIMAS	1
2	CARPINTERIA	AREA DE CARPINTERIA	1
3	COJINERIA	PRODUCCION COJINERIA	1
4	COMPRAS	DEPARTAMENTO DE ABASTECIMIENTO	1
5	CALIDAD	CONTROL DE LA CALIDAD	1
6	PLANEACION	CONTROL Y PLANEACION	1
7	CORTE	CORTE DE PIEL	1
8	COSTURA	AREA DE COSTURA	1
9	DISEÑO	DISEÑO Y PROTOTIPOS	1
10	FINANZAS	AREA DE FINANZAS Y FISCAL	1
11	LOGISTICA	ALMACEN DE TERMINADO Y EMBARQUES	1
12	MANTAS	CORTE DE TELAS Y MANTAS	1
13	OPERACIONES	AREA DE MANUFACTURA	1
14	SERVICIOS	SERVICIOS A CLIENTES	1
15	SISTEMAS	SISTEMAS Y COMPUTO	1
16	VENTAS	VENTAS Y ADMINISTRACION DE LA VENTA	1
17	DIRECCION	DIRECCION GENERAL	1
18	TAPICERIA	AREA DE TAPICERIA	1
19	TERMINADO	AREA DE TERMINADO	1
20	PERSONAL	RECURSOS HUMANOS	4
21  ALMACEN DE PARTES
*/

select Label, Dept, Name,  SIZ_AlmacenesTransferencias.Code,
SolicitudMateriales, TrasladoDeptos, Remarks
from SIZ_AlmacenesTransferencias 
inner join OUDP on OUDP.Code = Dept
where SIZ_AlmacenesTransferencias.Dept = '10' 
--SIZ_AlmacenesTransferencias.Code = 'AMG-ST' --and TrasladoDeptos like '%O%'
order by TrasladoDeptos, Label

Select Dept, Name, Label, SolicitudMateriales, TrasladoDeptos
from SIZ_AlmacenesTransferencias 
inner join OUDP on OUDP.Code = Dept
Where Dept = 15 --and Code = 'APT-TR'
--Label like '%APG-ST%' and TrasladoDeptos like '%D%'
Order by Dept




-- Update SIZ_AlmacenesTransferencias set TrasladoDeptos = 'OD' Where Code = 'APT-TR' and Dept = '15' 


-- Update SIZ_AlmacenesTransferencias set SolicitudMateriales = 'D' Where Code = 'APG-ST' and Dept = '7' 
 --Update SIZ_AlmacenesTransferencias set Label = 'APG-ST - WIP VIRTUAL'  Where Dept = 15 and Code = 'APG-ST'
-- Update SIZ_AlmacenesTransferencias set Label = 'PARA MUESTRARIO DE PIEL'  Where Dept = 7 and Code = 'APT-TR'

--Update SIZ_AlmacenesTransferencias set TrasladoDeptos = ' ' Where Dept = 7 and Code = 'APT-TR'

-- Delete SIZ_AlmacenesTransferencias Where Code = 'APG-PA' and Dept = '1'

-- ****************** INSERTAR NUEVO ALMACEN  ***************************

BEGIN      
	INSERT INTO SIZ_AlmacenesTransferencias (Code, Dept, Label, SolicitudMateriales, TrasladoDeptos)
    VALUES ('ATG-FX','15','ATG-FX - PT RESGUARDO GDL.',' ','O')
      
	--PRINT 'Ingresado: CODIGO ' + cast(@CODI as varchar(10))  + '  ' + cast(@NAME as varchar (50))
END

GO




Select * from SIZ_AlmacenesTransferencias 
where SIZ_AlmacenesTransferencias.Code = 'APT-TR' and TrasladoDeptos = 'O'

--update SIZ_AlmacenesTransferencias set SolicitudMateriales = '', TrasladoDeptos = 'D' 
--where SIZ_AlmacenesTransferencias.Dept = '20' and SIZ_AlmacenesTransferencias.Code = 'APT-TR'



Select * from SIZ_AlmacenesTransferencias where Dept = 9 and Code = 'AMP-CC'

Delete SIZ_AlmacenesTransferencias where Dept = 9 and Code = 'AMP-CC' 



 -- Reporte de Personas que pueden mover de un almacen.
 
 Select	U_EmpGiro AS NOMINA
	, OHEM.firstName AS NOMBRE
	, OHEM.lastName AS APELLIDO 
	, OHEM.jobTitle AS FUNCION
	, OHPS.name AS POSICION
	, OHEM.dept AS AREA
	, OUDP.Name AS NOM_AREA
	, OUDP.Remarks AS DES_AREA
	, OHST.name AS ESTATUS
	, email AS E_MAIL
 from OHEM
  inner join OUDP on OUDP.Code = OHEM.dept
  inner join OHPS on OHPS.posID = OHEM.position
  inner join OHST on OHST.statusID = OHEM.status
  Where OHEM.status = 1 and OHEM.dept = 18
  Order by OUDP.Name, OHEM.jobTitle, OHEM.firstName, OHEM.lastName
  
