-- Consulta para Reporte 114 Saldos de Cuentas Contables.
-- Elaborado: Ing. Vicente Cueva Ramírez.
-- Actualizado: Lunes 12 de Abril del 2021; Origen

-- Parametros Fecha Inicial y Final
Declare @FechaIS date
Declare @FechaFS date

Set @FechaIS = CONVERT(DATE, '2024-12-31', 102)
Set @FechaFS = CONVERT(DATE, '2025-01-31', 102)

-- Desarrollo de la Consulta

/*
-- Catalodo de Cuentas Contables
Select FormatCode AS CUENTA
	, AcctName AS NOMBRE
	, AcctCode AS ID
from OACT Where FormatCode = '501300000'

501200000	COSTO DE RECLASIFICACION MATERIA PRIMA		_SYS00000000350
501300000	CONSUMO AREAS ESTAFF						_SYS00000000351
501500000	REVALORIZAR STANDAR INTERNO					_SYS00000000367

*/


Select	Cast(JDT1.DueDate as Date) AS FECHA
		, JDT1.Account AS CUENTA
		, JDT1.TransId AS NUM_TRANS
		, JDT1.Ref1 AS DOCUMENTO
		, JDT1.LineMemo AS INFORMACION
		, JDT1.Debit AS DEBITO
		, JDT1.Credit AS CREDITO
		, Isnull((Select OIGE.DocTotal from OIGE Where JDT1.TransId = OIGE.TransId),0 ) AS CARGO
		, Isnull((Select OIGN.DocTotal from OIGN Where JDT1.TransId = OIGN.TransId),0 ) AS ABONO
		, OUSR.USER_CODE AS AUTOR
from JDT1
inner join OUSR on OUSR.USERID = JDT1.UserSign
Where Cast (JDT1.DueDate as Date) Between @FechaIS and @FechaFS 
and JDT1.Account = '_SYS00000000351'
Order By Cast(JDT1.DueDate as Date), JDT1.TransId



