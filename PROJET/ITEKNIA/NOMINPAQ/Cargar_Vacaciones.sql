-- Nombre: Cargar Vacaciones por Periodo.
-- Objetivo: Preparar Informacion para subir a Tabla de Conrol de Vacaciones.
-- Sistema: Nomimpaq (SQL)
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Lunes 24 de Octubre del 2022; Origen.

-- Parámetros 
Declare @Anual as Integer
Declare @Semana as Integer
Declare @IdPeriodo as Integer
Declare @NumEmpl as varchar(30)
Declare @IdEmpleado as Integer

--Declare @FechaIS as varchar(30)
--Declare @NumDias as Integer

Set @Anual = 2022
Set @Semana = 50
Set @IdPeriodo = 0
Set @IdEmpleado = 0
Set @NumEmpl = '211' --GABRIEL

-- Determina el Id del la Semana.
Set @IdPeriodo = (Select idperiodo from NOM10002 Where numeroperiodo = @Semana and ejercicio = @Anual and idtipoperiodo = 2)

-- Para un solo Empleado. determina el Id del Empleado.
Set @IdEmpleado = (Select idempleado from NOM10001 Where CodigoEmpleado = @NumEmpl)

-- Datos para cargar a tabla de RPT_Vacaciones. VACACIONES TOMADAS.
Select  NOM10001.CodigoEmpleado AS VAC_EMP_EmpleadoId
        , 'I' AS VAC_TipoReg
        , Cast(@Anual as varchar(4)) + '-'+ Cast(@Semana as varchar(2)) AS VAC_NominaId
        , Cast(NOM10007.timestamp as date) AS VAC_FechaDoc 
        , 'Vacaciones disfrutadas en Periodo ' + Cast(@Semana-1 as Varchar(3)) AS VAC_Describe
        , 0 AS VAC_Derecho
        , Cast((Case When NOM10007.IdConcepto = 20 then NOM10007.Valor else 0 end) as Decimal(16,2)) AS VAC_Tomadas
        , Cast(getdate() as date) AS VAC_FechaModif 
        , '777' AS VAC_UsuaModif
        , NOM10001.Nombre + '  ' + NOM10001.ApellidoPaterno + '  ' + NOM10001.ApellidoMaterno AS NOMBRE
from NOM10007
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10007.IdEmpleado
Where idperiodo = @IdPeriodo and NOM10007.IdConcepto = 20
-- Order By NOMBRE

Union all
 
-- Datos para cargar a tabla de RPT_Vacaciones. INCREMENTO DE VACACIONES.
Select  NOM10001.CodigoEmpleado AS VAC_EMP_EmpleadoId
        , 'I' AS VAC_TipoReg
        , Cast(@Anual as varchar(4)) + '-'+ Cast(@Semana as varchar(2)) AS VAC_NominaId 
        , Case When  Cast(NOM10001.fechareingreso as date) > Cast('2000-01-01' as date) then
          Cast((Cast(Year(NOM10007.timestamp) as varchar(4))+ '-'+Cast(Month(NOM10001.fechareingreso) as varchar(2))+'-'+Cast(Day(NOM10001.fechareingreso) as varchar(2))) as date) 
          Else
          Cast((Cast(Year(NOM10007.timestamp) as varchar(4))+ '-'+Cast(Month(NOM10001.fechaalta) as varchar(2))+'-'+Cast(Day(NOM10001.fechaalta) as varchar(2))) as date)
          End AS VAC_FechaDoc        
        , 'Asigna días de Vacaciones por ' + Cast(DATEDIFF(year,
         (Case When  Cast(NOM10001.fechareingreso as date) > Cast('2000-01-01' as date) then
          Cast(NOM10001.fechareingreso as date) 
          Else
          Cast(NOM10001.fechaalta as date)
          End),  NOM10007.timestamp) as varchar(3)) + ' Años Cumplidos' AS VAC_Describe
        , Cast((Case When NOM10007.IdConcepto = 21 then (NOM10007.Valor)/.25 else 0 end) as Decimal(16,2)) AS VAC_Derecho
        , 0 AS VAC_Tomadas
        , Cast(getdate() as date) AS VAC_FechaModif 
        , '777' AS VAC_UsuaModif
        , NOM10001.Nombre + '  ' + NOM10001.ApellidoPaterno + '  ' + NOM10001.ApellidoMaterno AS NOMBRE
from NOM10007
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10007.IdEmpleado
Where idperiodo = @IdPeriodo and NOM10007.IdConcepto = 21 and NOM10007.Valor > 0
Order By NOMBRE