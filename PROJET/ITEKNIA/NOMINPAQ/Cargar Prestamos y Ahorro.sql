-- Nombre: Cargar Prestamos a Muliix.
-- Objetivo: Tener la Informacion de los prestamos para llenar tablas de control de Gestion de Recursos Humanos.
-- Sistema: Nomimpaq (SQL)
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Miercoles 14 de Diciembre del 2022; Origen.

-- Parámetros 
Declare @Anual as Integer
Declare @Semana as Integer
Declare @IdPeriodo as Integer

Set @Anual = 2022
Set @Semana = 46
Set @IdPeriodo = 0

-- Determina el Id del la Semana.
Set @IdPeriodo = (Select idperiodo from NOM10002 Where numeroperiodo = @Semana and ejercicio = @Anual)

-- Gestion de Prestamos.

Select  NOM10001.CodigoEmpleado AS PRE_EMP_EmpleadoId
        , 'I' AS PRE_TipoReg
        , 'PREST' AS PRE_Categoria
        , Cast(@Anual as varchar(4)) + '-'+ Cast(@Semana as varchar(2)) AS PRE_NominaId 
        , Cast(NOM10007.timestamp as date) AS PRE_FechaDoc
        , 'Cargo Prestamo (999) en Periodo No. ' + Cast(@Semana as Varchar(3)) AS PRE_Describe
        , Cast((Case When NOM10007.IdConcepto = 148 then (NOM10007.importetotal) else 0 end) as Decimal(16,2)) AS PRE_Debe
        , 0 AS PRE_Haber
        , Cast(getdate() as date) AS PRE_FechaModif 
        , '777' AS PRE_UsuaModif
from NOM10007
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10007.IdEmpleado
Where idperiodo = @IdPeriodo and NOM10007.IdConcepto = 148 and NOM10007.importetotal > 0

Union all

Select  NOM10001.CodigoEmpleado AS PRE_EMP_EmpleadoId
        , 'I' AS PRE_TipoReg
        , 'PREST' AS PRE_Categoria
        , Cast(@Anual as varchar(4)) + '-'+ Cast(@Semana as varchar(2)) AS PRE_NominaId 
        , Cast(NOM10007.timestamp as date) AS PRE_FechaDoc
        , 'Intereses sobre Prestamo (999) en Periodo No. ' + Cast(@Semana as Varchar(3)) AS PRE_Describe
        , Cast((Case When NOM10007.IdConcepto = 148 then (NOM10007.importetotal*0.10) else 0 end) as Decimal(16,2)) AS PRE_Debe
        , 0 AS PRE_Haber
        , Cast(getdate() as date) AS PRE_FechaModif 
        , '777' AS PRE_UsuaModif
from NOM10007
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10007.IdEmpleado
Where idperiodo = @IdPeriodo and NOM10007.IdConcepto = 148 and NOM10007.importetotal > 0

Union All

Select  NOM10001.CodigoEmpleado AS PRE_EMP_EmpleadoId
        , 'I' AS PRE_TipoReg
        , 'PREST' AS PRE_Categoria
        , Cast(@Anual as varchar(4)) + '-'+ Cast(@Semana as varchar(2)) AS PRE_NominaId 
        , Cast(NOM10007.timestamp as date) AS PRE_FechaDoc
        , 'Abono a Prestamo (164) en Periodo No. ' + Cast(@Semana as Varchar(3)) AS PRE_Describe
        , 0 AS PRE_Debe
        , Cast((Case When NOM10007.IdConcepto = 109 then (NOM10007.importetotal) else 0 end) as Decimal(16,2)) AS PRE_Debe
        , Cast(getdate() as date) AS PRE_FechaModif 
        , '777' AS PRE_UsuaModif
from NOM10007
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10007.IdEmpleado
Where idperiodo = @IdPeriodo and NOM10007.IdConcepto = 109 and NOM10007.importetotal > 0

Union all

Select  NOM10001.CodigoEmpleado AS PRE_EMP_EmpleadoId
        , 'I' AS PRE_TipoReg
        , 'PREST' AS PRE_Categoria
        , Cast(@Anual as varchar(4)) + '-'+ Cast(@Semana as varchar(2)) AS PRE_NominaId 
        , Cast(NOM10007.timestamp as date) AS PRE_FechaDoc
        , 'Pago de Intereses (73) en Periodo No. ' + Cast(@Semana as Varchar(3)) AS PRE_Describe
        , 0 AS PRE_Debe
        , Cast((Case When NOM10007.IdConcepto = 56 then (NOM10007.importetotal) else 0 end) as Decimal(16,2)) AS PRE_Haber
        , Cast(getdate() as date) AS PRE_FechaModif 
        , '777' AS PRE_UsuaModif
from NOM10007
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10007.IdEmpleado
Where idperiodo = @IdPeriodo and NOM10007.IdConcepto = 56 and NOM10007.importetotal > 0

Order By NOMBRE, PRE_FechaDoc, PRE_Describe


-- Cargar Caja de Ahorro

Select  NOM10001.CodigoEmpleado AS PRE_EMP_EmpleadoId
        , 'I' AS PRE_TipoReg
        , 'AHORR' AS PRE_Categoria
        , Cast(@Anual as varchar(4)) + '-'+ Cast(@Semana as varchar(2)) AS PRE_NominaId 
        , Cast(NOM10007.timestamp as date) AS PRE_FechaDoc
        , 'Caja de Ahorro Iteknia (67) en Periodo No. ' + Cast(@Semana as Varchar(3)) AS PRE_Describe
        , Cast((Case When NOM10007.IdConcepto = 51 then (NOM10007.importetotal) else 0 end) as Decimal(16,2)) AS PRE_Debe
        , 0 AS PRE_Haber
        , Cast(getdate() as date) AS PRE_FechaModif 
        , '777' AS PRE_UsuaModif
from NOM10007
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10007.IdEmpleado
Where idperiodo = @IdPeriodo and NOM10007.IdConcepto = 51 and NOM10007.importetotal > 0

Union All

Select  NOM10001.CodigoEmpleado AS PRE_EMP_EmpleadoId
        , 'I' AS PRE_TipoReg
        , 'AHORR' AS PRE_Categoria
        , Cast(@Anual as varchar(4)) + '-'+ Cast(@Semana as varchar(2)) AS PRE_NominaId 
        , Cast(NOM10007.timestamp as date) AS PRE_FechaDoc
        , 'Aportacion del Patron C.A.Iteknia en Periodo No. ' + Cast(@Semana as Varchar(3)) AS PRE_Describe
        , Cast((Case When NOM10007.IdConcepto = 51 then (NOM10007.importetotal) else 0 end) as Decimal(16,2)) AS PRE_Debe
        , 0 AS PRE_Haber
        , Cast(getdate() as date) AS PRE_FechaModif 
        , '777' AS PRE_UsuaModif
from NOM10007
Inner Join NOM10001 on NOM10001.IdEmpleado = NOM10007.IdEmpleado
Where idperiodo = @IdPeriodo and NOM10007.IdConcepto = 51 and NOM10007.importetotal > 0
