-- Consulta para Reporte 114 Saldos de Cuentas Contables.
-- Elaborado: Ing. Vicente Cueva Ramírez.
-- Actualizado: Lunes 12 de Abril del 2021; Origen

-- Parametros Fecha Inicial y Final
Declare @FechaIS date
Declare @FechaFS date

Set @FechaIS = CONVERT(DATE, '2021-03-01', 102)
Set @FechaFS = CONVERT(DATE, '2021-04-12', 102)


--Declare @FechaIS varchar (30)
--Declare @FechaFS varchar (30)

--Set @FechaIS = '2021-04-01'
--Set @FechaFS = '2021-04-12'

-- Desarrollo de la Consulta

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
and JDT1.Account = '_SYS00000000344'
Order By Cast(JDT1.DueDate as Date), JDT1.TransId

Go







