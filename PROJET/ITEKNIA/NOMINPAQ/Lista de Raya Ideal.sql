-- Nombre: Calculo de la Lista de Raya Neto.
-- Objetivo: Tener la de lo comprometido Neto a pagar al empleado.
-- Sistema: Nomimpaq (SQL)
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 13 de Octubre del 2022; Origen.

-- Parámetros 
Declare @Anual as Integer
Declare @Semana as Integer
Declare @IdPeriodo as Integer
Declare @NumEmpl as varchar(30)
Declare @IdEmpleado as Integer
Declare @Percepciones as decimal(16,2) 

Set @Anual = 2022
Set @Semana = 41
Set @IdPeriodo = 0
Set @Percepciones = 0

--Set @NumEmpl = '034' --GUILLERMO 
Set @NumEmpl = '283' --GABRIEL
--Set @NumEmpl = '994'  --YOLANDA
Set @IdEmpleado = 0
--Set @FechaIS = CONVERT (DATE, '2022/09/26', 102)

-- Determina el Id del la Semana.
Set @IdPeriodo = (Select idperiodo from NOM10002 Where numeroperiodo = @Semana and ejercicio = @Anual)

-- Para un solo Empleado. determina el Id del Empleado.
Set @IdEmpleado = (Select idempleado from NOM10001 Where CodigoEmpleado = @NumEmpl)

-- Lista de Raya sin Incidencias del Periodo Seleccionado. Calculado en funcion a los sueldos diario e Integrado.
Select  @Anual AS AÑO
        , @Semana AS PERIODO
        , NOM10001.CodigoEmpleado AS CODIGO
        , NOM10001.Nombre + '  ' + NOM10001.ApellidoPaterno + '  ' + NOM10001.ApellidoMaterno AS NOMBRE
        , Cast(NOM10001.SueldoDiario as Decimal(16,2)) AS SUEL_DIA
        , Cast(NOM10001.SueldoIntegrado as Decimal(16,2))AS SUEL_INT
        
        , Cast(NOM10001.SueldoDiario * 5 as Decimal(16,2)) AS SUELDO
        , Cast(NOM10001.SueldoDiario * 2 as Decimal(16,2)) AS SEPTIMO
        , Cast(NOM10001.SueldoIntegrado * .1 * 7 as Decimal(16,2))AS PUNTUALIDAD
        , Cast(NOM10001.SueldoIntegrado * .1 * 7 as Decimal(16,2))AS ASISTENCIA
        
        , Cast((NOM10001.SueldoDiario * 7) + (NOM10001.SueldoIntegrado * .2 * 7) as Decimal(16,2)) AS PERCEPCION
        , Cast(SUM(Case When NOM10007.IdConcepto = 93 then NOM10007.ImporteTotal else 0 end) as Decimal(16,2)) AS D_ISR_$        
        
        , Cast((NOM10001.SueldoDiario * 7) + (NOM10001.SueldoIntegrado * .2 * 7)
        - (SUM(Case When NOM10007.IdConcepto = 93 then NOM10007.ImporteTotal else 0 end)) as Decimal(16,2)) AS NETO_SEMANAL
        
        , Cast(((((NOM10001.SueldoDiario * 7) + (NOM10001.SueldoIntegrado * .2 * 7) -
         (SUM(Case When NOM10007.IdConcepto = 93 then NOM10007.ImporteTotal else 0 end))
         )/7) * 30.4) as Decimal(16,2)) AS NETO_MENSUAL
     
from NOM10007
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10007.IdEmpleado
Where idperiodo = @IdPeriodo
--and NOM10007.idEmpleado = @IdEmpleado
Group by NOM10001.CodigoEmpleado, NOM10001.Nombre, NOM10001.ApellidoPaterno, NOM10001.ApellidoMaterno
, NOM10001.SueldoDiario, NOM10001.SueldoIntegrado 
 Order By NOMBRE

/*

-- Lista de Raya Calculando los componentes creo que me sale muy diferente. Actualizada. Calculando mediante la tabla de Impuestos.

Select NOM10001.CodigoEmpleado AS CODIGO
        , NOM10001.Nombre + '  ' + NOM10001.ApellidoPaterno + '  ' + NOM10001.ApellidoMaterno AS NOMBRE
        
        , NOM10001.FechaBaja AS BAJA
        
        , Cast(NOM10001.SueldoDiario as Decimal(16,2)) AS SUELDO_D
        , Cast(NOM10001.SueldoIntegrado as Decimal(16,2))AS SUELDO_DI
        
        , Cast(NOM10001.SueldoDiario*5 as Decimal(16,2)) AS SUELDO
        , Cast(NOM10001.SueldoDiario*2 as Decimal(16,2)) AS SEPTIMO
        , Cast(NOM10001.SueldoIntegrado*.1*7 as Decimal(16,2)) AS PUNTUALIDAD
        , Cast(NOM10001.SueldoIntegrado*.1*7 as Decimal(16,2)) AS ASISTENCIA
        
        , Cast((NOM10001.SueldoDiario*7) + (NOM10001.SueldoIntegrado*7*.2) as Decimal(16,2)) AS PERCEPCION
        
        , Cast(Case When ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoIntegrado*7*.2)) > =    0.01 and ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) < =   148.40  then ((((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) -     0.01)*0.0192)+     0.00 
           When ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoIntegrado*7*.2)) > =  148.41 and ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) < =  1259.72  then ((((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) -   148.41)*0.0640)+     2.87  
           When ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoIntegrado*7*.2)) > = 1259.73 and ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) < =  2213.89  then ((((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) -  1259.73)*0.1088)+    73.99 
           When ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoIntegrado*7*.2)) > = 2213.90 and ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) < =  2573.55  then ((((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) -  2213.90)*0.1600)+   177.80 
           When ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoIntegrado*7*.2)) > = 2573.56 and ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) < =  3081.26  then ((((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) -  2573.56)*0.1792)+   235.34   
           When ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoIntegrado*7*.2)) > = 3081.27 and ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) < =  6214.46  then ((((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) -  3081.27)*0.2136)+   326.34   
           When ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoIntegrado*7*.2)) > = 6214.47 and ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) < =  9794.82  then ((((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) -  6214.47)*0.2352)+   995.54 
           When ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoIntegrado*7*.2)) > = 9794.83 and ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) < = 18699.94  then ((((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) -  9794.83)*0.3000)+  1837.64 
           When ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoIntegrado*7*.2)) > = 18699.95 and ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) < = 24933.30 then ((((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) - 18699.95)*0.3200)+  4509.19 
           When ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoIntegrado*7*.2)) > = 24933.31 and ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) < = 74799.83 then ((((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) - 24933.31)*0.3400)+  6503.84 
           When ((NOM10001.SueldoDiario*7) + (NOM10001.SueldoIntegrado*7*.2)) > = 74799.84  then ((((NOM10001.SueldoDiario*7) + (NOM10001.SueldoDiario*1.0452*7*.2)) - 74799.84)*0.3500)+ 23458.47 end as decimal(16,2)) AS ISR 
        
From NOM10007
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10007.IdEmpleado
Where idperiodo = @IdPeriodo
-- and NOM10007.idEmpleado = @IdEmpleado
--Group by NOM10001.CodigoEmpleado, NOM10001.Nombre, NOM10001.ApellidoPaterno, NOM10001.ApellidoMaterno
--, NOM10001.SueldoDiario, NOM10001.SueldoIntegrado 
 Order By NOMBRE

 
 
 -- Tabla de Vacaciones
 -- Select * from NOM10051
 
 -- Tabla de Dias Ausentes
 -- Select * from NOM10057
 
 
-- Select * from nom10026

*/