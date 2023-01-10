-- Nombre: Incidencias de los Empleados en Nomimpaq.
-- Objetivo: Tener la Informacion para llenar tablas de control de Gestion de Recursos Humanos.
-- Sistema: Nomimpaq (SQL)
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
Set @Semana = 45
Set @IdPeriodo = 0
Set @NumDias = 1

--Set @NumEmpl = '034' --GUILLERMO 
Set @NumEmpl = '211' --GABRIEL
--Set @NumEmpl = '994'  --YOLANDA
Set @IdEmpleado = 0
Set @FechaIS = CONVERT (DATE, '2022/09/26', 102)

-- Determina el Id del la Semana.
Set @IdPeriodo = (Select idperiodo from NOM10002 Where numeroperiodo = @Semana and ejercicio = @Anual)

-- Para un solo Empleado. determina el Id del Empleado.
Set @IdEmpleado = (Select idempleado from NOM10001 Where CodigoEmpleado = @NumEmpl)

--Select FORMAT(25000,'C','En-Us')

-- Historia Nominas ya Registradas o Autorizadas.
Select  @Anual AS AÑO
        , @Semana AS PERIODO
        , NOM10001.CodigoEmpleado AS CODIGO
        , NOM10001.Nombre + '  ' + NOM10001.ApellidoPaterno + '  ' + NOM10001.ApellidoMaterno AS NOMBRE
        , Cast(NOM10001.SueldoDiario as Decimal(16,2)) AS SUELDO_D
        , Cast(NOM10001.SueldoIntegrado as Decimal(16,2))AS SUELDO_DI
        
        , Cast(SUM(Case When NOM10007.IdConcepto = 3 then NOM10007.Valor else 0 end) as Decimal(16,2)) AS SUELDO
        , Cast(SUM(Case When NOM10007.IdConcepto = 4 then NOM10007.Valor else 0 end) as Decimal(16,2))AS SEPTIMO
        , Cast(SUM(Case When NOM10007.IdConcepto = 20 then NOM10007.Valor else 0 end) as Decimal(16,2)) AS VACACIONES    
                  
        , Cast((SUM(Case When NOM10007.IdConcepto = 3 then NOM10007.Valor else 0 end) +
               SUM(Case When NOM10007.IdConcepto = 4 then NOM10007.Valor else 0 end) +
               SUM(Case When NOM10007.IdConcepto = 20 then NOM10007.Valor else 0 end)) as Decimal(16,2)) AS DIAS  
        
        
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
 
 
 /*
 
 Select *
 from NOM10007
Where idperiodo = @IdPeriodo
and NOM10007.idEmpleado = @IdEmpleado
 
 */
 
 
 /*
 Tabla de Vacaciones
 Select * from NOM10051
 
 Tabla de Dias Ausentes
 Select * from NOM10057
 
 
 Select * from nom10026

 
 Select fechaalta, fechareingreso, fechabaja, * from NOM10001 Where Cast(fechareingreso as date) <> Cast('1899-12-30 00:00:00' as date)
 codigoempleado = 211
 ID = 125
 FIng = fechaalta = 2015-06-23 00:00:00
        fechareingreso = 2017-10-11 00:00:00
        
        
        */