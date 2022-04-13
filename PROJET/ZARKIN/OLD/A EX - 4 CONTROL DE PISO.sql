-- Deben ser iguales los numeros de OP y de Datos Usuario Controlde Piso.
-- Validar Ordenes para funcionamiento a Control de Piso, Ordenes Iguales 

		Select 'CTRL ! PISO = OP' AS REPORTE, OWOR.DocEntry,OWOR.U_OP, OWOR.ItemCode
		from OWOR
		Where DocEntry <> U_OP
		
		update OWOR Set OWOR.U_OP = OWOR.DocEntry Where DocEntry <> U_OP
	
/* Alerta de Lineas Duplicadas en SAP */

	Select '004 ? LINEAS DUPLICADAS' AS REPORTE, U_DocEntry AS OP, U_CT AS ESTACION, R.Name, COUNT(U_DocEntry) As Cantidad, O.PlannedQty
	From [@CP_OF] P
	Inner join OWOR O on P.U_DocEntry= O.DocNum
	Inner join [@PL_RUTAS] R on P.U_CT = R.Code
	Where O.Status='R'
	Group By U_DocEntry, U_CT, R.Name, O.PlannedQty
	Having COUNT(U_DocEntry) > O.PlannedQty

/* SACAR LINEAS DUPLICADAS EN EL CONTROL DE PISO */

	Select '014 ? LINEA DUPLICADA CP' AS REPORTE, U_DocEntry, Veces, U_CT
	From (
	select U_DocEntry, U_CT,COUNT(U_DocEntry) As Veces from [@CP_OF]
	Group By U_DocEntry, U_CT) DUB
	where veces> 1

-- Consulta para Buscar aplicaciones de Entradas Dobles.	

	Select '022 ? ENTRADAS DUPLICADAS' as REPORTE, DUDA.Duplicado, DUDA.BaseRef, OWOR.ItemCode, A3.ItemName, DUDA.Recibo1, RB.DocDate
	from (
	Select IGN1.BaseRef, COUNT(IGN1.BaseRef) as Duplicado,(Select Top 1 REC.DocEntry from IGN1 REC where REC.BaseRef=IGN1.BaseRef
	order by REC.BaseRef) as Recibo1
	from IGN1
	inner join OITM A3 on IGN1.ItemCode=A3.ItemCode
	where A3.U_TipoMat='PT'
	group by IGN1.BaseRef
	) DUDA
	inner join OWOR on DUDA.BaseRef= OWOR.DocEntry
	inner join OITM A3 on OWOR.ItemCode=A3.ItemCode
	inner join OIGN RB on DUDA.Recibo1=RB.DocEntry
	where DUDA.Duplicado>1 and DUDA.BaseRef<> 41568 and DUDA.BaseRef<> 40530 and DUDA.BaseRef<> 4347 and DUDA.BaseRef<> 4348
	and DUDA.BaseRef<> 9806 and DUDA.BaseRef<> 10658 and DUDA.BaseRef<> 10592 and DUDA.BaseRef<> 10574 and DUDA.BaseRef<> 19994
	and DUDA.BaseRef<> 25210 and DUDA.BaseRef<> 26658 and DUDA.BaseRef<> 31435 and DUDA.BaseRef<> 30956 and DUDA.BaseRef<> 34059
	and DUDA.BaseRef<> 28739 and DUDA.BaseRef<> 39408 and DUDA.BaseRef<> 40415 and DUDA.BaseRef<> 38439 and DUDA.BaseRef<> 40528
	and DUDA.BaseRef<> 41827 and DUDA.BaseRef<> 42337 and DUDA.BaseRef<> 42926 and DUDA.BaseRef<> 41165 and DUDA.BaseRef<> 42683
	and DUDA.BaseRef<> 44429 and DUDA.BaseRef<> 50519 and DUDA.BaseRef<> 53258 and DUDA.BaseRef<> 52915 and DUDA.BaseRef<> 53167
	and DUDA.BaseRef<> 55909 and DUDA.BaseRef<> 55838 and DUDA.BaseRef<> 57012 and DUDA.BaseRef<> 57938 and DUDA.BaseRef<> 62315
	and DUDA.BaseRef<> 62316 and DUDA.BaseRef<> 62330 and DUDA.BaseRef<> 61460 and DUDA.BaseRef<> 58333 and DUDA.BaseRef<> 59359
	and DUDA.BaseRef<> 69125 and DUDA.BaseRef<> 71856 and DUDA.BaseRef<> 8030 and DUDA.BaseRef<> 9840  and DUDA.BaseRef<> 9855
	and DUDA.BaseRef<> 30739
	and A3.ItemCode not like '%-42-%' and A3.ItemCode not like '17362%' and A3.ItemCode not like '%-44-%'and A3.ItemCode not like '%-43-%'
	order by RB.DocDate,A3.ItemName




-- Fin del reporte de Excepciones de Control de Piso.