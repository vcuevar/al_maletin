-- EXCEPCIONES DE OREDENES DE PRODUCCION, FUNDA, CASCO y HABILITADO. 
-- Actualizado: Viernes 10 de Agosto del 2018. (Integracion del APG-ST)

	-- Ordenes que fueron cerradas en el Periodo.
		Select '005 ? ORDENES CERRADAS ' AS REPORTE, COUNT(CIERRE.ItemCode) as Cerrados
		from (Select OWOR.DocEntry, OWOR.ItemCode, OWOR.CloseDate
		from OWOR
		-- Formato fecha aaaa/dd/mm
		Where OWOR.CloseDate between ('2020/30/03') and ('2020/03/05')) CIERRE

	-- ORDENES QUE NO SE COMPLETO EL PROCESO Y NO QUEDARON REGISTRADAS
		Select '011 ? SIN REGISTRO' as REPORTE, OWOR.DocEntry, OWOR.CmpltQty, [@CP_LOGOF].U_DocEntry, 
		OITM.ItemName, OITM.U_VS, OWOR.Type, OWOR.Status
		from OWOR
		inner join OITM on OWOR.ItemCode=OITM.ItemCode
		left join [@CP_LOGOF] on OWOR.DocEntry=[@CP_LOGOF].U_DocEntry 
		and ([@CP_LOGOF].U_CT=20 or [@CP_LOGOF].U_CT=175)
		where OWOR.CmpltQty > 0 and OITM.QryGroup29='N' 
		and OITM.QryGroup30='N' and OITM.QryGroup31='N' 
		and [@CP_LOGOF].U_DocEntry is null
		and OITM.ItemName not like '%CINTIL%' 
		and OWOR.Type='S' and OITM.U_TipoMat='PT'
		and OWOR.Status = 'R'
		--and OWOR.DocEntry > 8597  and  OWOR.DocEntry <> 20295 
		order by OWOR.DocEntry
		
	-- ORDENES REGRESAR A CONSUMO POR NOTIFICACION 	
		Select '021 ! CONSUMO MANUAL' AS REPORTE,OWOR.Status, WOR1.DocEntry, 
		WOR1.ItemCode, A1.ItemName, A1.InvntryUom, 0 AS WIP, 
		WOR1.PlannedQty as Necesidad, WOR1.wareHouse
		from WOR1 inner join OITM A1 on WOR1.ItemCode=A1.ItemCode 
		inner join OWOR on WOR1.DocEntry=OWOR.DocEntry 
		where  OWOR.Status = 'R' and A1.U_TipoMat <> 'CG' and WOR1.IssueType = 'M' and
		WOR1.IssuedQty = 0 and OWOR.CmpltQty=0  and A1.ItmsGrpCod <> 113 and A1.QryGroup30='N'
		and OWOR.OriginNum <> 1175

		--Update WOR1 set IssueType='B'
		--from WOR1 inner join OITM A1 on WOR1.ItemCode=A1.ItemCode 
		--inner join OWOR on WOR1.DocEntry=OWOR.DocEntry 
		--where  OWOR.Status = 'R' and A1.U_TipoMat <> 'CG' and WOR1.IssueType = 'M' and
		--WOR1.IssuedQty = 0 and OWOR.CmpltQty=0  and A1.ItmsGrpCod <> 113 and A1.QryGroup30='N'
		--and OWOR.OriginNum <> 1175
	
	-- ORDENES DEJAR EN MANUAL LOS HABILITADO 	
		/* DEJAR QUE SE CONSUMA POR B, Y GENERAR AJUSTES ANTICIPADOS DE HABILITADO.
		Select '037 ! CONS. NOT. HABIL->MANUAL' AS REPORTE,OWOR.Status, WOR1.DocEntry, 
		WOR1.ItemCode, A1.ItemName, A1.InvntryUom, 0 AS WIP, 
		WOR1.PlannedQty as Necesidad, WOR1.wareHouse
		from WOR1 inner join OITM A1 on WOR1.ItemCode=A1.ItemCode 
		inner join OWOR on WOR1.DocEntry=OWOR.DocEntry 
		where  OWOR.Status = 'R' and A1.U_TipoMat <> 'CG' and WOR1.IssueType = 'M' and
		WOR1.IssuedQty = 0 and OWOR.CmpltQty=0  and A1.ItmsGrpCod <> 113 and A1.QryGroup30='Y'
		
		Update WOR1 set IssueType='B'
		from WOR1 inner join OITM A1 on WOR1.ItemCode=A1.ItemCode 
		inner join OWOR on WOR1.DocEntry=OWOR.DocEntry 
		where  OWOR.Status = 'R' and A1.U_TipoMat <> 'CG' and WOR1.IssueType = 'M' and
		WOR1.IssuedQty = 0 and OWOR.CmpltQty=0  and A1.ItmsGrpCod <> 113 and A1.QryGroup30='Y'
		*/
	-- ORDENES QUE NO SE A CARGADO PIEL Y YA FUERON ENTREGADAS A PISO
		Select '052 ? NO SE CARGO PIEL' AS REPORTE, OWOR.DocEntry as NumOrde, OWOR.Status, OWOR.ItemCode as Produto,A3.ItemName, OWOR.Warehouse as ALM_PRO,
		WOR1.ItemCode as Material, A1.itemname, WOR1.wareHouse as ALM_MAT, WOR1.PlannedQty, WOR1.IssuedQty,
		OWOR.U_Entrega_Piel
		from WOR1
		inner join OWOR on OWOR.DocEntry=WOR1.DocEntry
		inner join OITM A1 on A1.ItemCode = WOR1.ItemCode 
		inner join OITM A3 on A3.ItemCode = OWOR.ItemCode
		where OWOR.Status<>'C' and OWOR.Status<>'L' and  A1.ItmsGrpCod = '113'
		and OWOR.U_Entrega_Piel is not null and WOR1.IssuedQty = 0
		  
	-- VER-150615 ORDENES QUE SE CARGO PIEL Y ESTAN EN ESTATUS DE NO PROCESO
		Select '061 ? CON PIEL STATUS NO PROCESO' AS REPORTES, OWOR.DocEntry as NumOrde, OWOR.Status, A1.ItemName, OWOR.U_Grupo, OWOR.U_Starus,OWOR.U_Entrega_Piel,
		OWOR.ItemCode as Produto, OWOR.Warehouse as ALM_PRO,
		WOR1.ItemCode as Material, oitm.ItemName,WOR1.wareHouse as ALM_MAT, WOR1.BaseQty, WOR1.IssuedQty
		from OWOR
		inner join WOR1 on OWOR.DocEntry=WOR1.DocEntry
		inner join OITM on OITM.ItemCode = WOR1.ItemCode 
		inner join OITM A1 on OWOR.ItemCode=A1.ItemCode
		where OWOR.Status='R' and OITM.ItmsGrpCod = '113' and WOR1.IssuedQty>0 and OWOR.U_Entrega_Piel is null
		order by U_Grupo, NumOrde

	-- ORDENES EN PROCESO Y CON STATUS DIFERENTE A 06 PROCESO.
		Select '074 ? OP EN WIP DIF A 06 PROCESO' AS REPORTES, OP, NO_SERIE, Pedido, CODIGO, Descripcion, Cantidad,VSInd, VS, Funda, U_Starus 
		from Vw_BackOrderExcel 
		where CodFunda between 109 and 175 
		and U_Starus <> '06'
	
	-- Ordenes de Produccion con cantidad mayor de 50 pzas
	--Quite porque planeacion determino que tenia que hacer con el numero que necesite.
		--Select '080 ? OP MAYOR 50' AS REPORTE, OWOR.Status as Estado, OWOR.DocNum as NuOrden, OWOR.U_NoSerie as Serial,
		--owor.OriginNum as Pedido, OWOR.U_Status as Proceso, OWOR.ItemCode as Codigo,
		--OITM.ItemName as Descripcion,OWOR.PlannedQty, OITM.U_VS as Valor, OWOR.DueDate as F_Termino,
		--OWOR.CardCode as CodeClie, OCRD.cardname as Cliente
		--from owor inner join OITM on OITM.ItemCode = OWOR.ItemCode
		--inner join OCRD  on ocrd.cardcode = OWOR.CardCode 
		--where OWOR.PlannedQty >50 and oitm.QryGroup29 <> 'Y' and OWOR.Status <>'C'
		--and OWOR.Status <>'L' and oitm.QryGroup30 <> 'Y' and OITM.ItemName not like '%COJIN%'
		--order by Estado, Descripcion
	
	-- Ordenes de Produccion con Material PIEL cargado almacen Diferente al de AMP-ST
		Select '091 ! PIEL DIF. AMP-ST' AS REPORTE, OWOR.Status, WOR1.DocEntry, WOR1.ItemCode, OITM.ItemName, WOR1.wareHouse
		from WOR1
		inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		inner join OITM on WOR1.ItemCode = OITM.ItemCode
		where OWOR.Status <> 'C' and OWOR.Status <> 'L' and OITM.ItmsGrpCod= '113' and 
		WOR1.wareHouse <> 'AMP-ST'
		
		--Update WOR1 set wareHouse = 'AMP-ST'
		--from WOR1
		--inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		--inner join OITM on WOR1.ItemCode = OITM.ItemCode
		--where OWOR.Status <> 'C' and OWOR.Status <> 'L' and OITM.ItmsGrpCod= '113' and 
		--WOR1.wareHouse <> 'AMP-ST'
		
	-- Ordenes de Produccion Fundas con Material Diferentes a Piel que consumen material de AMP-ST 
	-- excepto las ordenes de Herrajes.
		Select '107 ? OP CONSUME AMP-ST' AS REPORTE, OWOR.Status, WOR1.DocEntry, WOR1.ItemCode, OITM.ItemName, WOR1.wareHouse
		from WOR1
		inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		inner join OITM on WOR1.ItemCode = OITM.ItemCode
		where OWOR.Status <> 'C' and OWOR.Status <> 'L' and OITM.ItmsGrpCod <> '113' 
		and WOR1.wareHouse = 'AMP-ST' AND OWOR.ItemCode <> '17814' and 
		OWOR.ItemCode <> '17620' and OWOR.ItemCode <> '17621'

		
		--Update WOR1 set wareHouse = 'APG-ST'
		--from WOR1
		--inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		--inner join OITM on WOR1.ItemCode = OITM.ItemCode
		--where OWOR.Status <> 'C' and OWOR.Status <> 'L' and OITM.ItmsGrpCod <> '113' 
		--and WOR1.wareHouse = 'AMP-ST' AND OWOR.ItemCode <> '17814' and 
		--OWOR.ItemCode <> '17620' and OWOR.ItemCode <> '17621'
		

	-- Ordenes de Produccion Fundas con Material Diferentes a Piel que consumen material de AMP-CC
		Select '116 ! OP CONSUME AMP-CC' AS REPORTE, OWOR.Status, WOR1.DocEntry, OWOR.ItemCode, WOR1.ItemCode, OITM.ItemName, WOR1.wareHouse
		from WOR1
		inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		inner join OITM on WOR1.ItemCode = OITM.ItemCode
		where OWOR.Status <> 'C' and OWOR.Status <> 'L' and OITM.ItmsGrpCod <> '113' 
		and WOR1.wareHouse = 'AMP-CC'

		--Update WOR1 set wareHouse = 'APG-ST'
		--from WOR1
		--inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		--inner join OITM on WOR1.ItemCode = OITM.ItemCode
		--where OWOR.Status <> 'C' and OWOR.Status <> 'L' and OITM.ItmsGrpCod <> '113' 
		--and WOR1.wareHouse = 'AMP-CC'
		
	-- Ordenes de Produccion Fundas con Material Diferentes a Piel que consumen <> de APP-ST
	-- 9 AGOSTO 18 CAMBIE A APG-ST EN LUGAR DEL APP-ST
	-- Sub-Ensambles de Herrajes consumen de AMP-ST
		Select '132 ! OP CONSUME <> APG-ST' AS REPORTE, OWOR.Status, WOR1.DocEntry, OWOR.ItemCode,
		A3.ItemName, WOR1.ItemCode, A1.ItemName, WOR1.wareHouse
		from WOR1
		inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		inner join OITM A1 on WOR1.ItemCode = A1.ItemCode
		inner join OITM A3 on OWOR.ItemCode = A3.ItemCode
		where (A3.U_TipoMat = 'PT' or A3.U_TipoMat = 'SP') and OWOR.Status <> 'C' and OWOR.Status <> 'L' and
		 A1.ItmsGrpCod <> '113' and WOR1.wareHouse <> 'APG-ST' and  
		 OWOR.ItemCode <> '17814' and OWOR.ItemCode <> '17620' and 
		 OWOR.ItemCode <> '17621'

		Update WOR1 set wareHouse = 'APG-ST'
		from WOR1
		inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		inner join OITM A1 on WOR1.ItemCode = A1.ItemCode
		inner join OITM A3 on OWOR.ItemCode = A3.ItemCode
		where (A3.U_TipoMat = 'PT' or A3.U_TipoMat = 'SP') and OWOR.Status <> 'C' and OWOR.Status <> 'L' and 
		A1.ItmsGrpCod <> '113' and WOR1.wareHouse <> 'APG-ST' and  
		OWOR.ItemCode <> '17814' and OWOR.ItemCode <> '17620' and 
		OWOR.ItemCode <> '17621'
		
	-- Ordenes de Produccion Casco que consumen diferente a APT-PA 
	-- 9 AGOSTO 18 CAMBIE A APG-ST
		Select '151 ! OP CONSUME APG-ST' AS REPORTE, OWOR.Status, WOR1.DocEntry, 
		A3.ItemName, WOR1.ItemCode, OITM.ItemName, WOR1.wareHouse, WOR1.ItemCode,
		A3.QryGroup29, A3.QryGroup30, A3.QryGroup31
		from WOR1
		inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		inner join OITM on WOR1.ItemCode = OITM.ItemCode 
		inner join OITM A3 on OWOR.ItemCode = A3.ItemCode 
		where OWOR.Status <> 'C' and OWOR.Status <> 'L' 
		and WOR1.wareHouse <> 'APG-ST'
		and (A3.QryGroup29 = 'Y' or A3.QryGroup30 = 'Y' or A3.QryGroup31 = 'Y')
		
		Update WOR1 set WOR1.warehouse = 'APG-ST'
		from WOR1
		inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
		inner join OITM on WOR1.ItemCode = OITM.ItemCode 
		inner join OITM A3 on OWOR.ItemCode = A3.ItemCode 
		where OWOR.Status <> 'C' and OWOR.Status <> 'L' and WOR1.wareHouse <> 'APG-ST'
		and (A3.QryGroup29 = 'Y' or A3.QryGroup30 = 'Y' or A3.QryGroup31 = 'Y')

	-- Corregir donde sea cero de los tres campos
		--Update OWOR set U_OF = null
		--where OWOR.Status<>'C' and OWOR.Status<>'L' and  OWOR.U_OF=0
		
		--Update OWOR set U_OT = null
		--where OWOR.Status<>'C' and OWOR.Status<>'L' and  OWOR.U_OT=0
		
		--Update OWOR set U_Grupo = null
		--where OWOR.Status<>'C' and OWOR.Status<>'L' and  OWOR.U_Grupo=0



	-- Ordenes de Produccion Fundas con Material Diferentes a Piel que consumen material de AMP-CC
		Select '154 ! OP ENTREGA CINTILLO <> APG-ST' AS REPORTE, OWOR.Status, OWOR.DocEntry, 
		OWOR.ItemCode, OITM.ItemName, OWOR.Warehouse
		from OWOR
		inner join OITM on OWOR.ItemCode = OITM.ItemCode
		where OWOR.Status <> 'C' and OWOR.Status <> 'L' and OWOR.Warehouse <> 'APG-ST' 
		and OITM.ItemName LIKE  '%CINTILLO%'

		Update OWOR Set wareHouse = 'APG-ST'
		from OWOR
		inner join OITM on OWOR.ItemCode = OITM.ItemCode
		where OWOR.Status <> 'C' and OWOR.Status <> 'L' and OWOR.Warehouse <> 'APG-ST' 
		and OITM.ItemName LIKE  '%CINTILLO%'




-- Fin del Archivo de Excepciones de Ordenes de Fabricación.