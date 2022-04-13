/* EXCEPCIONES DE OREDENES DE PRODUCCION, FUNDA, CASCO y HABILITADO. */

	-- Ordenes que fueron cerradas en el Periodo.
		Select '004 ? ORDENES CERRADAS ' AS REPORTE, COUNT(CIERRE.ItemCode) as Cerrados
		from (Select OWOR.DocEntry, OWOR.ItemCode, OWOR.CloseDate
		from OWOR
		Where OWOR.CloseDate between ('2018/30/07') and ('2018/02/09')) CIERRE

	/* ORDENES QUE NO SE COMPLETO EL PROCESO Y NO QUEDARON REGISTRADAS
	Las Ordenes que se encuentran en el Where son ordenes que no se reportaron del 2014. */
	
		select '012 ? SIN REGISTRO' as REPORTE, OWOR.DocEntry, OWOR.CmpltQty, [@CP_LOGOF].U_DocEntry, OITM.ItemName, OITM.U_VS, OWOR.Type
		from OWOR
		inner join OITM on OWOR.ItemCode=OITM.ItemCode
		left join [@CP_LOGOF] on OWOR.DocEntry=[@CP_LOGOF].U_DocEntry and ([@CP_LOGOF].U_CT=20 or [@CP_LOGOF].U_CT=175)
		where OWOR.CmpltQty>0 and OITM.QryGroup29='N' and OITM.QryGroup30='N' and OITM.QryGroup31='N' and [@CP_LOGOF].U_DocEntry is null
		and OWOR.DocEntry > 8597  and  OWOR.DocEntry <> 20295 and  OWOR.DocEntry <> 10711
		and OWOR.DocEntry <> 21944 and OWOR.DocEntry <> 22079 and OWOR.DocEntry <> 40638
		and OWOR.DocEntry <> 56873 and OWOR.DocEntry <> 63824 
		and OITM.ItemName not like '%CINTIL%' and OWOR.Type='S' and OITM.U_TipoMat='PT'
		order by OWOR.DocEntry
		
	-- ORDENES REGRESAR A CONSUMO POR NOTIFICACION 	
		Select '024 ! CONSUMO MANUAL' AS REPORTE,OWOR.Status, WOR1.DocEntry, 
		WOR1.ItemCode, A1.ItemName, A1.InvntryUom, 0 AS WIP, 
		WOR1.PlannedQty as Necesidad, WOR1.wareHouse
		from WOR1 inner join OITM A1 on WOR1.ItemCode=A1.ItemCode 
		inner join OWOR on WOR1.DocEntry=OWOR.DocEntry 
		where  OWOR.Status = 'R' and A1.U_TipoMat <> 'CG' and WOR1.IssueType = 'M' and
		WOR1.IssuedQty = 0 and OWOR.CmpltQty=0  and A1.ItmsGrpCod <> 113
		
		--PARA REGRESAR A NOTIFICACION
		Update WOR1 set IssueType='B', wor1.wareHouse = 'APP-ST' 
		from WOR1 inner join OITM A1 on WOR1.ItemCode=A1.ItemCode 
		inner join OWOR on WOR1.DocEntry=OWOR.DocEntry 
		where  OWOR.Status = 'R' and A1.U_TipoMat <> 'CG' and WOR1.IssueType = 'M' and
		WOR1.IssuedQty = 0 and OWOR.CmpltQty=0  and A1.ItmsGrpCod <> 113

	/* ORDENES QUE NO SE A CARGADO PIEL Y YA FUERON ENTREGADAS A PISO */
		Select '040 ? NO SE CARGO PIEL' AS REPORTE, OWOR.DocEntry as NumOrde, OWOR.Status, OWOR.ItemCode as Produto,A3.ItemName, OWOR.Warehouse as ALM_PRO,
		WOR1.ItemCode as Material, A1.itemname, WOR1.wareHouse as ALM_MAT, WOR1.PlannedQty, WOR1.IssuedQty,
		OWOR.U_Entrega_Piel
		from WOR1
		inner join OWOR on OWOR.DocEntry=WOR1.DocEntry
		inner join OITM A1 on A1.ItemCode = WOR1.ItemCode 
		inner join OITM A3 on A3.ItemCode = OWOR.ItemCode
		where OWOR.Status<>'C' and OWOR.Status<>'L' and  A1.ItmsGrpCod = '113'
		and OWOR.U_Entrega_Piel is not null and WOR1.IssuedQty = 0
		 
	/*	VER-150615 ORDENES QUE SE CARGO PIEL Y ESTAN EN ESTATUS DE NO PROCESO */
		select '051 ? CON PIEL STATUS NO PROCESO' AS REPORTES, OWOR.DocEntry as NumOrde, OWOR.Status, A1.ItemName, OWOR.U_Grupo, OWOR.U_Status,OWOR.U_Entrega_Piel,
		OWOR.ItemCode as Produto, OWOR.Warehouse as ALM_PRO,
		WOR1.ItemCode as Material, oitm.ItemName,WOR1.wareHouse as ALM_MAT, WOR1.BaseQty, WOR1.IssuedQty
		from OWOR
		inner join WOR1 on OWOR.DocEntry=WOR1.DocEntry
		inner join OITM on OITM.ItemCode = WOR1.ItemCode 
		inner join OITM A1 on OWOR.ItemCode=A1.ItemCode
		where OWOR.Status='R' and OITM.ItmsGrpCod = '113' and WOR1.IssuedQty>0 and OWOR.U_Entrega_Piel is null
		order by U_Grupo, NumOrde

	-- ORDENES EN PROCESO Y CON STATUS DIFERENTE A 06 PROCESO.
		Select '061 ? OP EN WIP DIF A 06 PROCESO' AS REPORTES, OP, NO_SERIE, Pedido, CODIGO, Descripcion, Cantidad,VSInd, VS, Funda, U_Status 
		from Vw_BackOrderExcel 
		where CodFunda between 109 and 175 
		and U_Status <> '06'
	
	/*	Ordenes de Produccion con cantidad mayor de 50 pzas */
		Select '068 ? OP MAYOR 50' AS REPORTE, OWOR.Status as Estado, OWOR.DocNum as NuOrden, OWOR.U_NoSerie as Serial,
		owor.OriginNum as Pedido, OWOR.U_Status as Proceso, OWOR.ItemCode as Codigo,
		OITM.ItemName as Descripcion,OWOR.PlannedQty, OITM.U_VS as Valor, OWOR.DueDate as F_Termino,
		OWOR.CardCode as CodeClie, OCRD.cardname as Cliente
		from owor inner join OITM on OITM.ItemCode = OWOR.ItemCode
		inner join OCRD  on ocrd.cardcode = OWOR.CardCode 
		where OWOR.PlannedQty >50 and oitm.QryGroup29 <> 'Y' and OWOR.Status <>'C'
		and OWOR.Status <>'L' and oitm.QryGroup30 <> 'Y' and OITM.ItemName not like '%COJIN%'
		order by Estado, Descripcion
	
	/* Ordenes que se generaron y ya no cuentan con respaldo de un pedido */
		--Select OWOR.DocEntry, OWOR.ItemCode, A3.ItemName, OWOR.OriginNum, ORDR.DocNum
		--from OWOR
		--inner join OITM A3 on OWOR.ItemCode=A3.ItemCode
		--left join ORDR on ORDR.DocNum=OWOR.OriginNum and ORDR.DocStatus='O'
		--where (OWOR.Status='P' or OWOR.Status='R') and A3.U_TipoMat='PT' and ORDR.DocNum is null

	/*	Ordenes de Produccion con Material Piel cargado almacen Diferente al de AMP-ST  */
		Select '086 ? PIEL DIF. AMP-ST' AS REPORTE, OWOR.Status, WOR1.DocEntry, WOR1.ItemCode, OITM.ItemName, WOR1.wareHouse
		from WOR1
		inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		inner join OITM on WOR1.ItemCode = OITM.ItemCode
		where OWOR.Status <> 'C' and OWOR.Status <> 'L' and OITM.ItmsGrpCod= '113' and WOR1.wareHouse <> 'AMP-ST'
		
--	Ordenes de Produccion Fundas con Material Diferentes a Piel que consumen material de AMP-ST 
-- excepto las ordenes de Herrajes.
		Select '094 ? OP CONSUME AMP-ST' AS REPORTE, OWOR.Status, WOR1.DocEntry, WOR1.ItemCode, OITM.ItemName, WOR1.wareHouse
		from WOR1
		inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		inner join OITM on WOR1.ItemCode = OITM.ItemCode
		where OWOR.Status <> 'C' and OWOR.Status <> 'L' and OITM.ItmsGrpCod <> '113' 
		and WOR1.wareHouse = 'AMP-ST' AND OWOR.ItemCode <> '17814' and 
		OWOR.ItemCode <> '17620' and OWOR.ItemCode <> '17621'

	/*	Ordenes de Produccion Fundas con Material Diferentes a Piel que consumen material de AMP-CC  */
		Select '103 ! OP CONSUME AMP-CC' AS REPORTE, OWOR.Status, WOR1.DocEntry, OWOR.ItemCode, WOR1.ItemCode, OITM.ItemName, WOR1.wareHouse
		from WOR1
		inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		inner join OITM on WOR1.ItemCode = OITM.ItemCode
		where OWOR.Status <> 'C' and OWOR.Status <> 'L' and OITM.ItmsGrpCod <> '113' and WOR1.wareHouse = 'AMP-CC'

		/*  Para Cambiar a APP-ST use esta consulta. (9 AGO 18, CAMBIE A APG-ST)*/
		--Update WOR1 set wareHouse = 'APG-ST'
		--from WOR1
		--inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		--inner join OITM A1 on WOR1.ItemCode = A1.ItemCode
		--inner join OITM A3 on OWOR.ItemCode = A3.ItemCode
		--where OWOR.Status <> 'C' and OWOR.Status <> 'L' and OITM.ItmsGrpCod <> '113' and WOR1.wareHouse = 'AMP-CC'
		
	/*	Ordenes de Produccion Fundas con Material Diferentes a Piel que consumen material de AMP-CC  */
	-- 9 AGOSTO 18 CAMBIE A APG-ST EN LUGAR DEL APP-ST
		Select '119 ! OP CONSUME <> APG-ST' AS REPORTE, OWOR.Status, WOR1.DocEntry, OWOR.ItemCode,
		A3.ItemName, WOR1.ItemCode, A1.ItemName, WOR1.wareHouse
		from WOR1
		inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		inner join OITM A1 on WOR1.ItemCode = A1.ItemCode
		inner join OITM A3 on OWOR.ItemCode = A3.ItemCode
		where A3.U_TipoMat = 'PT' and OWOR.Status <> 'C' and OWOR.Status <> 'L' and A1.ItmsGrpCod <> '113' and WOR1.wareHouse <> 'APG-ST'

		/*  Para Cambiar a APG-ST use esta consulta.*/
		Update WOR1 set wareHouse = 'APG-ST'
		from WOR1
		inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		inner join OITM A1 on WOR1.ItemCode = A1.ItemCode
		inner join OITM A3 on OWOR.ItemCode = A3.ItemCode
		where A3.U_TipoMat = 'PT' and OWOR.Status <> 'C' and OWOR.Status <> 'L' and A1.ItmsGrpCod <> '113' and WOR1.wareHouse <> 'APG-ST'
		

	/*	Ordenes de Produccion Casco que consumen diferente a APT-PA  */
	-- 9 AGOSTO 18 CAMBIE A APG-ST
		Select '138 ! OP CONSUME APG-ST' AS REPORTE, OWOR.Status, WOR1.DocEntry, A3.ItemName, 
		WOR1.ItemCode, OITM.ItemName, WOR1.wareHouse, WOR1.ItemCode, A3.QryGroup29,
		A3.QryGroup30, A3.QryGroup31
		from WOR1
		inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		inner join OITM on WOR1.ItemCode = OITM.ItemCode 
		inner join OITM A3 on OWOR.ItemCode = A3.ItemCode 
		where OWOR.Status <> 'C' and OWOR.Status <> 'L' and WOR1.wareHouse <> 'APG-ST'
		and (A3.QryGroup29 = 'Y' or A3.QryGroup30 = 'Y' or A3.QryGroup31 = 'Y')
		
		/*  Para Cambiar a APP-ST use esta consulta.*/
		Update WOR1 set wareHouse = 'APG-ST'
		from WOR1
		inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		inner join OITM on WOR1.ItemCode = OITM.ItemCode 
		inner join OITM A3 on OWOR.ItemCode = A3.ItemCode 
		where OWOR.Status <> 'C' and OWOR.Status <> 'L' and WOR1.wareHouse <> 'APG-ST'
		and (A3.QryGroup29 = 'Y' or A3.QryGroup30 = 'Y' or A3.QryGroup31 = 'Y')

-- Materiales que les falta cargar materias Primas, de no aplicar antes de cierre de mes se debe descontar del inventario de WIP
		--SELECT  T0.UpdateDate as Fecha, T0.[DocNum] as OP,T0.[ItemCode] as Code_PT, A3.ItemName as Producto,
		--wor1.ItemCode as Code_MP,A1.ItemName as Material,
		--WOR1.PlannedQty as Cantidad, A1.AvgPrice as Estandar, WOR1.PlannedQty*A1.AvgPrice as Importe
		--FROM OWOR T0
		--inner join WOR1 on WOR1.DocEntry = T0.DocEntry
		--inner join OITM A1 on WOR1.ItemCode=A1.ItemCode
		--inner join OITM A3 on T0.ItemCode=A3.ItemCode
		--WHERE (T0.[PlannedQty]  <=  T0.[CmpltQty] and  T0.[status] <> 'L') and
		--WOR1.IssueType = 'M' and WOR1.PlannedQty > WOR1.IssuedQty  and A1.ItmsGrpCod <> 113
		--Order by  T0.UpdateDate ,T0.DocNum, a1.ItemName

-- Ordenes que se modifico la Secuencia de hule a Cero y hay que regresar a Null
		--Select OWOR.DocEntry as NumOrde, OWOR.Status, OWOR.ItemCode as Produto,A3.ItemName, 
		--OWOR.U_OF as SECUENCIA, OWOR.U_OT as OT, OWOR.U_Grupo as PRG_CORTE
		--from OWOR
		--inner join OITM A3 on A3.ItemCode = OWOR.ItemCode
		--where OWOR.Status<>'C' and OWOR.Status<>'L' and  OWOR.U_Grupo=0
			 
		--Corregir donde sea cero de los tres campos
		Update OWOR set U_OF = null
		where OWOR.Status<>'C' and OWOR.Status<>'L' and  OWOR.U_OF=0
		
		Update OWOR set U_OT = null
		where OWOR.Status<>'C' and OWOR.Status<>'L' and  OWOR.U_OT=0
		
		Update OWOR set U_Grupo = null
		where OWOR.Status<>'C' and OWOR.Status<>'L' and  OWOR.U_Grupo=0


-- Ordenes de Produccion Casco que entregan a APT-PA cambiar a APP-ST En forma Provisional hasta que se corrija
-- el problema de traslados y buen control de Carpinteria.
-- Se quedan en APT-PA porque ya metieron control de envios de casco.

		--Select '191 ? OP ENTREGA CASCO APT-PA' AS REPORTE, OWOR.Status, OWOR.DocEntry, OWOR.ItemCode, A3.ItemName, OWOR.wareHouse
		--from OWOR
		--inner join OITM A3 on OWOR.ItemCode = A3.ItemCode
		--where OWOR.Status <> 'C' and OWOR.Status <> 'L' and 
		--A3.QryGroup29 = 'Y' and OWOR.wareHouse <> 'APT-PA'
		
		/*
		update OWOR set Warehouse = 'APT-PA'
		from OWOR
		inner join OITM A3 on OWOR.ItemCode = A3.ItemCode
		where OWOR.Status <> 'C' and OWOR.Status <> 'L' and 
		A3.QryGroup29 = 'Y' and OWOR.wareHouse <> 'APT-PA'
		*/
		

		--Select '195 ? OP ENTREGA HABILITADO APT-PA' AS REPORTE, OWOR.Status, OWOR.DocEntry, OWOR.ItemCode, A3.ItemName, OWOR.wareHouse
		--from OWOR
		--inner join OITM A3 on OWOR.ItemCode = A3.ItemCode
		--where OWOR.Status <> 'C' and OWOR.Status <> 'L' and 
		--A3.QryGroup30 = 'Y' and OWOR.wareHouse <> 'APT-PA'
		
		/*
		update OWOR set Warehouse = 'APT-PA'
		from OWOR
		inner join OITM A3 on OWOR.ItemCode = A3.ItemCode
		where OWOR.Status <> 'C' and OWOR.Status <> 'L' and 
		A3.QryGroup30 = 'Y' and OWOR.wareHouse <> 'APT-PA'
		*/
		

		--Select '210 ? OP ENTREGA COMPLEM. APT-PA' AS REPORTE, OWOR.Status, OWOR.DocEntry, OWOR.ItemCode, A3.ItemName, OWOR.wareHouse
		--from OWOR
		--inner join OITM A3 on OWOR.ItemCode = A3.ItemCode
		--where OWOR.Status <> 'C' and OWOR.Status <> 'L' and 
		--A3.QryGroup31 = 'Y' and OWOR.wareHouse <> 'APT-PA'
		
		/*
		update OWOR set Warehouse = 'APT-PA'
		from OWOR
		inner join OITM A3 on OWOR.ItemCode = A3.ItemCode
		where OWOR.Status <> 'C' and OWOR.Status <> 'L' and 
		A3.QryGroup31 = 'Y' and OWOR.wareHouse <> 'APT-PA'
		*/


-- Cambio de Almacen a Ordenes Reportadas APG-ST
		--select '229 ! CAMBIO AL VIRTUAL' AS REPORTE, V3.Status as Estatus, V3.DocEntry as OP, V3.PlannedQty as Cant,V4.U_VS, V3.ItemCode as Codigo, V4.ItemName as Mueble, 
		--V1.ItemCode as Material, v2.ItemName as Nombre_Material, V1.BaseQty as Cant_Mat, V1.wareHouse as Almacen
		--from WOR1 V1
		--inner join OITM V2 on V1.ItemCode=V2.ItemCode
		--inner join OWOR V3 on V1.DocEntry=V3.DocEntry
		--inner join OITM V4 on V3.ItemCode=V4.ItemCode
		--where V3.[PlannedQty] = V3.[CmpltQty] and V3.Status = 'R' and V1.IssuedQty= 0
		--and (V1.wareHouse = 'APP-ST' or V1.wareHouse = 'APT-PA') 
		--order by V3.DocEntry
	
	-- Cambio de Almacen al de APG-ST. 
		--update WOR1 set wareHouse = 'APG-ST'
		--from WOR1 V1
		--inner join OITM V2 on V1.ItemCode=V2.ItemCode
		--inner join OWOR V3 on V1.DocEntry=V3.DocEntry
		--inner join OITM V4 on V3.ItemCode=V4.ItemCode
		--where V3.[PlannedQty] = V3.[CmpltQty] and V3.Status = 'R' and V1.IssuedQty= 0
		--and (V1.wareHouse = 'APP-ST' or V1.wareHouse = 'APT-PA') 

		Select * from WOR1 
		inner join OITM A1 on WOR1.ItemCode=A1.ItemCode  
		inner join OWOR on WOR1.DocEntry=OWOR.DocEntry
		where  OWOR.Status = 'R' and A1.U_TipoMat <> 'CG' and WOR1.IssueType = 'M' and WOR1.IssuedQty = 0 And OWOR.CmpltQty = 0 And A1.ItmsGrpCod <> 113 
	
		--Update WOR1 set IssueType='B', wor1.wareHouse = 'APG-ST' from WOR1 inner join OITM A1 on WOR1.ItemCode=A1.ItemCode inner join OWOR on WOR1.DocEntry=OWOR.DocEntry where  OWOR.Status = 'R' and A1.U_TipoMat <> 'CG' and WOR1.IssueType = 'M' and WOR1.IssuedQty = 0 And OWOR.CmpltQty = 0 And A1.ItmsGrpCod <> 113 


-- Fin del Archivo de Excepciones de Ordenes de Fabricación.