-- Nombre: Incidencias de los Empleados en Nomimpaq.
-- Objetivo: Tener la Informacion para llenar tablas de control de Gestion de Recursos Humanos.
-- Siistema: Nomimpaq (SQL)
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 06 de Octubre del 2022; Origen.

-- Parámetros 
Declare @Anual as Integer
Declare @Semana as Integer
Declare @IdPeriodo as Integer
Declare @NumEmpl as varchar(30)
Declare @IdEmpleado as Integer
Declare @FechaIS as varchar(30)
Declare @NumDias as Integer

Set @Anual = 2022
Set @Semana = 40
Set @IdPeriodo = 0

Set @NumDias = 1

--Set @NumEmpl = '034' --GUILLERMO 
Set @NumEmpl = '283' --GABRIEL
--Set @NumEmpl = '994'  --YOLANDA
Set @IdEmpleado = 0
Set @FechaIS = CONVERT (DATE, '2022/09/26', 102)

-- Determina el Id del la Semana.
Set @IdPeriodo = (Select idperiodo from NOM10002 Where numeroperiodo = @Semana and ejercicio = @Anual)

-- Para un solo Empleado. determina el Id del Empleado.
Set @IdEmpleado = (Select idempleado from NOM10001 Where CodigoEmpleado = @NumEmpl)


-- Historia Nominas ya Registradas.
Select  @Anual AS AÑO
        , @Semana AS PERIODO
        , NOM10001.CodigoEmpleado AS CODIGO
        , NOM10001.Nombre + '  ' + NOM10001.ApellidoPaterno + '  ' + NOM10001.ApellidoMaterno AS NOMBRE
        , Cast(NOM10001.SueldoDiario as Decimal(16,2)) AS SUELDO_D
        , Cast(NOM10001.SueldoIntegrado as Decimal(16,2))AS SUELDO_DI
        
        , Cast(SUM(Case When NOM10007.IdConcepto = 3 then NOM10007.Valor else 0 end) as Decimal(16,2)) AS SUELDO
        , Cast(SUM(Case When NOM10007.IdConcepto = 4 then NOM10007.Valor else 0 end) as Decimal(16,2))AS SEPTIMO
        , Cast(SUM(Case When NOM10007.IdConcepto = 20 then NOM10007.Valor else 0 end) as Decimal(16,2)) AS VACACIONES              
        
        , Cast(SUM(Case When NOM10007.IdConcepto = 3 then NOM10007.ImporteTotal else 0 end) as Decimal(16,2)) AS SUELDO_$
        , Cast(SUM(Case When NOM10007.IdConcepto = 4 then NOM10007.ImporteTotal else 0 end) as Decimal(16,2)) AS SEPTIMO_$
        , Cast(SUM(Case When NOM10007.IdConcepto = 20 then NOM10007.ImporteTotal else 0 end) as Decimal(16,2)) AS VACACIONE_$
        , Cast(SUM(Case When NOM10007.IdConcepto = 132 then NOM10007.ImporteTotal else 0 end) as Decimal(16,2)) AS PUNTUAL_$              
        , Cast(SUM(Case When NOM10007.IdConcepto = 133 then NOM10007.ImporteTotal else 0 end) as Decimal(16,2)) AS ASISTE_$              
        
        , Cast(SUM(Case When NOM10007.IdConcepto = 21 then NOM10007.ImporteTotal else 0 end) as Decimal(16,2)) AS PRIM_VAC_$              
        , Cast(SUM(Case When NOM10007.IdConcepto = 43 then NOM10007.ImporteTotal else 0 end) as Decimal(16,2)) AS PREST_INFO_$
        , Cast(SUM(Case When NOM10007.IdConcepto = 51 then NOM10007.ImporteTotal else 0 end) as Decimal(16,2)) AS PREST_AHORR_$
        
        , Cast(SUM(Case When NOM10007.IdConcepto = 37 then NOM10007.ImporteTotal else 0 end) as Decimal(16,2)) AS D_IMMS_$
        , Cast(SUM(Case When NOM10007.IdConcepto = 93 then NOM10007.ImporteTotal else 0 end) as Decimal(16,2)) AS D_ISR_$        
from NOM10007
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10007.IdEmpleado
Where idperiodo = @IdPeriodo
-- and NOM10007.idEmpleado = @IdEmpleado
Group by NOM10001.CodigoEmpleado, NOM10001.Nombre, NOM10001.ApellidoPaterno, NOM10001.ApellidoMaterno
, NOM10001.SueldoDiario, NOM10001.SueldoIntegrado 
 Order By NOMBRE

-- Nomina Actual aun no timbrada.
Select @Anual AS AÑO
        , @Semana + 1 AS PERIODO 
        , NOM10001.CodigoEmpleado AS CODIGO
        , NOM10001.Nombre + '  ' + NOM10001.ApellidoPaterno + '  ' + NOM10001.ApellidoMaterno AS NOMBRE
        , Cast(NOM10001.SueldoDiario as Decimal(16,2)) AS SUELDO_D
        , Cast(NOM10001.SueldoIntegrado as Decimal(16,2))AS SUELDO_DI
        
        , Cast(SUM(Case When NOM10008.IdConcepto = 3 then NOM10008.Valor else 0 end) as Decimal(16,2)) AS SUELDO
        , Cast(SUM(Case When NOM10008.IdConcepto = 4 then NOM10008.Valor else 0 end) as Decimal(16,2))AS SEPTIMO
        , Cast(SUM(Case When NOM10008.IdConcepto = 20 then NOM10008.Valor else 0 end) as Decimal(16,2)) AS VACACIONES              
        
        , Cast(SUM(Case When NOM10008.IdConcepto = 3 then NOM10008.ImporteTotal else 0 end) as Decimal(16,2)) AS SUELDO_$
        , Cast(SUM(Case When NOM10008.IdConcepto = 4 then NOM10008.ImporteTotal else 0 end) as Decimal(16,2)) AS SEPTIMO_$
        , Cast(SUM(Case When NOM10008.IdConcepto = 20 then NOM10008.ImporteTotal else 0 end) as Decimal(16,2)) AS VACACIONE_$
        , Cast(SUM(Case When NOM10008.IdConcepto = 132 then NOM10008.ImporteTotal else 0 end) as Decimal(16,2)) AS PUNTUAL_$              
        , Cast(SUM(Case When NOM10008.IdConcepto = 133 then NOM10008.ImporteTotal else 0 end) as Decimal(16,2)) AS ASISTE_$              
        
        , Cast(SUM(Case When NOM10008.IdConcepto = 21 then NOM10008.ImporteTotal else 0 end) as Decimal(16,2)) AS PRIM_VAC_$              
        , Cast(SUM(Case When NOM10008.IdConcepto = 43 then NOM10008.ImporteTotal else 0 end) as Decimal(16,2)) AS PREST_INFO_$
        , Cast(SUM(Case When NOM10008.IdConcepto = 51 then NOM10008.ImporteTotal else 0 end) as Decimal(16,2)) AS PREST_AHORR_$
        
        , Cast(SUM(Case When NOM10008.IdConcepto = 37 then NOM10008.ImporteTotal else 0 end) as Decimal(16,2)) AS D_IMMS_$
        , Cast(SUM(Case When NOM10008.IdConcepto = 93 then NOM10008.ImporteTotal else 0 end) as Decimal(16,2)) AS D_ISR_$        
from NOM10008
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10008.IdEmpleado 
Where idperiodo = @IdPeriodo+1
--and NOM10008.idEmpleado = @IdEmpleado
Group by NOM10001.CodigoEmpleado, NOM10001.Nombre, NOM10001.ApellidoPaterno, NOM10001.ApellidoMaterno
, NOM10001.SueldoDiario, NOM10001.SueldoIntegrado 
 Order By NOMBRE




Select * from NOM10001 Where Nombre like '%CAROLI%'

Select  Format(((EMP_SueldoBase/30.4)*7), 'C', 'En-Us') + '  MXP Semanal' AS BASE_SEM, 
        Format(EMP_SueldoBase, 'C', 'En-Us') + '  MXP Mensual' AS BASE_MES 
from Empleados 

Where EMP_CodigoEmpleado = '1012'




Select EMP_EmpleadoId AS ID
      , EMP_CodigoEmpleado AS CODIGO
	, EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS NOMBRE
        , (Case When EMP_CMM_SexoId = '0BFD0EF6-5B78-4909-9CD2-6368288ECF41' then
	'FEMENINO' Else 'MASCULINO' End) AS SEXO
	, Cast(EMP_FechaIngreso as date) AS F_INGRESO 
	, DATEDIFF(year, EMP_FechaIngreso, GETDATE()) AS SERVICIO
	, Case 
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) < 1 then 0
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) = 1 then 6
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) = 2 then 8
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) = 3 then 10
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) = 4 then 12
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) > 4 and DATEDIFF(year, EMP_FechaIngreso, GETDATE()) < 10 then 14
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) > 9 and DATEDIFF(year, EMP_FechaIngreso, GETDATE()) < 15 then 16
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) > 14 and DATEDIFF(year, EMP_FechaIngreso, GETDATE()) < 20 then 18
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) > 19 and DATEDIFF(year, EMP_FechaIngreso, GETDATE()) < 25 then 20
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) > 24 and DATEDIFF(year, EMP_FechaIngreso, GETDATE()) < 30 then 22
	When DATEDIFF(year, EMP_FechaIngreso, GETDATE()) > 29 then 24
	End as VACACIONES	
from Empleados 
Where EMP_FechaEgreso is null and EMP_Activo = 1
and EMP_CodigoEmpleado = '211'
Order by NOMBRE





 /*
*/

-- Preparar Kardex de Modificaciones de Salario.
/*
Select  --@Anual AS AÑO
        --, @Semana AS PERIODO 
        Distinct NOM10001.CodigoEmpleado AS CODIGO
        , NOM10001.Nombre + '  ' + NOM10001.ApellidoPaterno + '  ' + NOM10001.ApellidoMaterno AS NOMBRE
        , Cast(NOM10001.SueldoDiario as Decimal(16,2)) AS SUELDO_D
        , Cast(NOM10001.SueldoIntegrado as Decimal(16,2)) AS SUELDO_DI
        --,(Case When NOM10007.IdConcepto = 3 then NOM10007.Valor else 0 end) AS SUELDO
        --, Case When NOM10007.Valor = 0 then  1 else NOM10007.Valor end 
        
        --, Cast((Case When NOM10007.IdConcepto = 3 then (NOM10007.ImporteTotal / 
        --  Case When NOM10007.Valor = 0 then  1 else NOM10007.Valor end) else 0 end) as Decimal(16,2)) AS SUELDO_$
        
        , Cast((SUM(Case When NOM10007.IdConcepto = 20 or NOM10007.IdConcepto = 4 or NOM10007.IdConcepto = 3 then NOM10007.ImporteTotal else 0 end)) /
         (SUM(Case When NOM10007.IdConcepto = 20 or NOM10007.IdConcepto = 4 or NOM10007.IdConcepto = 3 then NOM10007.Valor else 0 end)) as Decimal(16,2)) AS DIARIO_CALC
        
        
        --, (Case When NOM10007.IdConcepto = 4 then NOM10007.Valor else 0 end) AS SEPTIMO
        --, (Case When NOM10007.IdConcepto = 4 then (NOM10007.Valor * NOM10001.SueldoDiario) else 0 end) AS SEPTIMO_$
        --, (Case When NOM10007.IdConcepto = 20 then NOM10007.Valor else 0 end) AS VACACIONES
        --, (Case When NOM10007.IdConcepto = 20 then (NOM10007.Valor * NOM10001.SueldoDiario) else 0 end) AS VACACIONE_$
from NOM10007
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10007.IdEmpleado 
Where IdConcepto = 3 
and NOM10007.idEmpleado = @IdEmpleado
Group by NOM10001.CodigoEmpleado, NOM10001.Nombre, NOM10001.ApellidoPaterno, NOM10001.ApellidoMaterno
, NOM10001.SueldoDiario, NOM10001.SueldoIntegrado 
--Group by NOM10001.CodigoEmpleado, NOM10001.Nombre, NOM10001.ApellidoPaterno, NOM10001.ApellidoMaterno
--, NOM10001.SueldoDiario, NOM10001.SueldoIntegrado 
 Order By NOMBRE
*/

--Select * from NOM10019 Where idempleado = 536



/*
SELECT * FROM NOM10000          -- Datos de la Empresa

SELECT idempleado, codigoempleado, nombre, apellidopaterno, apellidomaterno, sueldodiario, sueldointegrado, fechaalta 
FROM NOM10001        
where codigoempleado = '994'

--idempleado = 536

SELECT * FROM NOM10002          -- Periodos Key idperiodo
WHERE ejercicio = 2022 and numeroperiodo = 39

SELECT * FROM NOM10003          -- Departamentos  Key iddepartamento
where iddepartamento = 12

SELECT * FROM NOM10004          -- Conceptos  Key idconcepto

SELECT idempleado, N5.idconcepto, tipoconcepto, descripcion, formulaimportetotal 
FROM NOM10005 N5
inner join NOM10004 N4 on N5.idconcepto = N4.idconcepto
where idempleado = 536



Select * from NOM10007
 where idperiodo=370 and idempleado = 536
 
 Periodo 39 = id 370
 

Select NOM10001.codigoempleado
        , NOM10001.nombre
        , NOM10001.apellidopaterno
        , NOM10001.apellidomaterno
        , NOM10001.fechaalta 
        , NOM10034.cidperiodo 
        , NOM10034.sueldodiario
        , NOM10034.sueldointegrado
        , NOM10034.cdiastrabajados
        , NOM10034.cdiaspagados
        , NOM10034.cdiascotizados
        , NOM10034.cdiasvacaciones
From NOM10001
Inner Join NOM10034 on NOM10001.idempleado = NOM10034.idempleado        
Where cidperiodo = 371  --codigoempleado = '994'


idempleado, 
 
Inner Join NOM10001 on NOM10001.ideempleado = NOM100034.idempleado and NOMI10034.cidperiodo = 370 
 
 
Select * from NOM10008

Where idempleado = 536 and cidperiodo = 370

where codigoempleado = '994'

*/
