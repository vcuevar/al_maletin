/* COMPILACION DE REPORTES DE EXCEPCIONES
Obj: Mantener al dia algunos de los elementos claves para Planeacion y control 
de la produccion  */
	
	-- Si es nulo y no da resultados es Urgente se capture el tipo de cambio para Mañana.	

	Select Case When 
	(Select	SUM(DATEPART(DW, CAST(T0.RateDate as DATE)) - DATEPART(DW, GETDATE()))
	from ORTT T0
	Where T0.Currency = 'USD' and
	CAST(T0.RateDate as DATE) > DATEADD(day,-1,CAST(GETDATE() as DATE)) and
	CAST(T0.RateDate as DATE) < DATEADD(day,7,CAST(GETDATE() as DATE))) < 2 Then
	'FALTA TIPO DE CAMBIO PARA PASADO MAÑANA' ELSE '' END
	

	--Select * from ORTT

-- Alarma para Tipo de Cambio, correr a las 5:00 PM si es que no hay tres tipos de cambio hoy mas dos.
-- Avidar a Marcos, Pablo, Areli, Martin, Vicente, Mary, Mara
-- Si es nulo y no da resultados es Urgente se capture el tipo de cambio para Mañana.
	Select CAST(ORTT.RateDate as DATE) as Fecha, ORTT.Currency, ORTT.Rate, CAST(GETDATE() as DATE) as HOY
	from ORTT
	Where CAST(ORTT.RateDate as DATE)= DATEADD(day,1,CAST(GETDATE() as DATE)) 


	
	-- Si es nulo y no da resultados es Recomendable que se capture el tipo de cambio para pasado Mañana.
	Select CAST(ORTT.RateDate as DATE) as Fecha, ORTT.Currency, ORTT.Rate, CAST(GETDATE() as DATE) as HOY
	from ORTT
	Where CAST(ORTT.RateDate as DATE)= DATEADD(day,2,CAST(GETDATE() as DATE)) 
	
-- Para cambiar el fondo del SAP a Lerma
	select WallPaper, * from OUSR 
	where WallPaper is null 


	--Select USER_CODE, U_NAME 
	--From OUSR
	
	/*
	update OUSR set WallPaper = '\\Server-sapbo\b1_shr\logo-zarkin-Lerma.bmp'
	where WallPaper is null 
	*/

	/*
	update OUSR set WallPaper = '\\Server-sapbo\b1_shr\Screen_Salotto_SAP.bmp'
	where WallPaper is null 
	*/
	
-- Asigna comprador a Materiales. Activar esta consula segun el grupo asignar a los dos compradores
-- KE Karina y NM Nahun los que son PT y sub ensambles y casco a PL

	SELECT '034 ! COMPRADOR PL A CASCOS' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Comprador
	from OITM 
	Where U_TipoMat = 'CA' and U_Comprador <> 'PL'

	UPDATE OITM set U_Comprador='PL'
	Where U_TipoMat = 'CA' and U_Comprador <> 'PL'

	SELECT '041 ! COMPRADOR PL A HABIL' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Comprador
	from OITM 
	Where QryGroup30 = 'Y' and U_Comprador <> 'PL'

	UPDATE OITM set U_Comprador='PL'
	Where QryGroup30 = 'Y' and U_Comprador <> 'PL'	

	SELECT '048 ! COMPRADOR PL A COMPL' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Comprador
	from OITM 
	Where QryGroup31 = 'Y' and U_Comprador <> 'PL'

	UPDATE OITM set U_Comprador='PL'
	Where QryGroup31 = 'Y' and U_Comprador <> 'PL'			

	SELECT '055 ! COMPRADOR PL A SUBPR' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Comprador
	from OITM 
	Where QryGroup32 = 'Y' and U_Comprador <> 'PL'

	UPDATE OITM set U_Comprador='PL'
	Where QryGroup32 = 'Y' and U_Comprador <> 'PL'	

	-- Asignar como comprador a Karian Escalona. este no procede ya que asignaron mas compradores
	--SELECT OITM.ItemCode, OITM.ItemName, OITM.U_Comprador
	--from OITM 
	--Where U_TipoMat = 'MP' and U_Comprador <> 'KE' and U_Linea = '01'
	--and QryGroup32 = 'N' and QryGroup31 = 'N' and QryGroup30 = 'N' and QryGroup29 = 'N' 

	/*
	UPDATE OITM set U_Comprador='KE'
	Where U_TipoMat = 'MP' and U_Comprador <> 'KE' and U_Linea = '01'
	and QryGroup32 = 'N' and QryGroup31 = 'N' and QryGroup30 = 'N' and QryGroup29 = 'N' 
	*/
	
	SELECT '! SIN COMPRADOR ASIGNADO' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Comprador
	from OITM 
	Where U_TipoMat = 'MP' and U_Comprador is null
		
	UPDATE OITM set U_Comprador='KE'
	Where U_TipoMat = 'MP' and U_Comprador is null
	
	
  
	/* Articulo Casco o complemento, sin marcar casilla de Articulo de Venta, al no activarlo no se puede capturar
	en pedido para generar la Orden de Produccion. */
		select 'CASILLA VENTAS SIN ACT.' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.InvntItem,
		OITM.SellItem, OITM.PrchseItem
		from OITM 
		where U_GrupoPlanea = 2 and SellItem = 'N'

		/*
		update OITM set SellItem = 'Y'
		where U_TipoMat = 'CA' and SellItem = 'N'
		*/
		
	/*Validar casillas de Inventario, Ventas, Compras. PT deben esta llenas las tres, es caso de Piezas 
	sueltas en caso, en caso de compuestos solo ventas */
		select 'CASILLAS VENTA COMPRAS A PT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.InvntItem,
		OITM.SellItem, OITM.PrchseItem
		from OITM 
		where U_GrupoPlanea = 12 and InvntItem = 'Y' and PrchseItem='N'
		
		/*
		update OITM set PrchseItem='Y'
		where U_GrupoPlanea = 12 and InvntItem = 'Y' and PrchseItem='N'
		*/
		
		
	-- Quitar casillas de Inventarios y de Compras.
	
		--Select OITM.ItemCode, OITM.ItemName, OITM.InvntItem, OITM.SellItem, OITM.PrchseItem,
		--OITT.TreeType
		--from OITM
		--inner join OITT on OITM.ItemCode = OITT.Code
		--inner join ITT1 on OITT.Code = ITT1.Father
		--Where OITT.TreeType <> 'P' and OITM.InvntItem = 'Y'
		--Order By OITM.ItemName
				
		-- update OITM set InvntItem='N', PrchseItem='N' where OITM.ItemCode = '3624-07-P0301'		
		
				

--ORDENES DE PRODUCCION GENERADAS NIVEL LISTA DE MATERIALES.

	/* Lista de Materiales de Ordenes con Almacen 01 o no definido el Almacen No Piel
	PLANIFICADAS set Warehouse='APP-ST' */
		select 'OP P. ALMACEN 01' AS REPORTE, OWOR.DocEntry as NumOrde, OWOR.Status, OWOR.ItemCode as Produto, OWOR.Warehouse as ALM_PRO,
		WOR1.ItemCode as Material, WOR1.wareHouse as ALM_MAT 
		from OWOR
		inner join WOR1 on OWOR.DocEntry=WOR1.DocEntry
		inner join OITM on OITM.ItemCode = WOR1.ItemCode 
		where OWOR.Status='P' and WOR1.wareHouse = '01' and OITM.ItmsGrpCod <> '113'

		/*
		update WOR1 set wareHouse='APP-ST'
		from OWOR
		inner join WOR1 on OWOR.DocEntry=WOR1.DocEntry
		inner join OITM on OITM.ItemCode = WOR1.ItemCode 
		where OWOR.Status='P' and WOR1.wareHouse = '01' and OITM.ItmsGrpCod <> '113'
		*/

/*	Lista de Materiales con Almacen 01 LIBERADAS set Warehouse='APP-ST' */
		select 'OP P. ALMACEN 01' AS REPORTE, OWOR.DocEntry as NumOrde, OWOR.Status, OWOR.ItemCode as Produto, OWOR.Warehouse as ALM_PRO,
		WOR1.ItemCode as Material, WOR1.wareHouse as ALM_MAT 
		from OWOR
		inner join WOR1 on OWOR.DocEntry=WOR1.DocEntry
		inner join OITM on OITM.ItemCode = WOR1.ItemCode 
		where OWOR.Status='R' and WOR1.wareHouse = '01' and OITM.ItmsGrpCod <> '113'
		
		/*
		update WOR1 set wareHouse='APP-ST'
		from OWOR
		inner join WOR1 on OWOR.DocEntry=WOR1.DocEntry
		inner join OITM on OITM.ItemCode = WOR1.ItemCode 
		where OWOR.Status='R' and WOR1.wareHouse = '01' and OITM.ItmsGrpCod <> '113'
		*/


/*	Lista de Materiales de Ordenes con Almacen AMP-CC o no definido el Almacen
	PLANIFICADAS set Warehouse='APP-ST'  */
		select 'OP P. ALMACEN AMP-CC' AS REPORTE, OWOR.DocEntry as NumOrde, OWOR.Status, OWOR.ItemCode as Produto, OWOR.Warehouse as ALM_PRO,
		WOR1.ItemCode as Material, WOR1.wareHouse as ALM_MAT 
		from OWOR
		inner join WOR1 on OWOR.DocEntry=WOR1.DocEntry
		inner join OITM on OITM.ItemCode = WOR1.ItemCode 
		where OWOR.Status='P' and WOR1.wareHouse = 'AMP-CC' and OITM.ItmsGrpCod <> '113'
		
		/*
		update WOR1 set wareHouse='APP-ST'
		from OWOR
		inner join WOR1 on OWOR.DocEntry=WOR1.DocEntry
		inner join OITM on OITM.ItemCode = WOR1.ItemCode 
		where OWOR.Status='P' and WOR1.wareHouse = 'AMP-CC' and OITM.ItmsGrpCod <> '113'
		*/

	
/*  SUB-ENSAMBLES CASCO Y COMPLEMENTOS: Quitar Sub - Ensambles no se generen Ordenes de Casco en Automatico queda pendiente definir,
con diseño para que no le pongan a las estructuras maestras. ERA PARA GUADALAJARA, 07 de Julio activo la no
Generacion de Ordenes Automaticas de Casco, ya que genera mucha informacion basura. Se retoma ordenes con cantidades en lugar de una por una.
*/ 
		Select 'QUITAR SUB-ENSAMBLE LDM' AS REPORTE, ITT1.Code, oitm.ItemName, ITT1.Father, ITT1.U_SubEns 
		from ITT1
		inner join oitm on ITT1.Code = oitm.ItemCode  
		where ITT1.U_SubEns='S'

	/*
		update ITT1 set U_SubEns = 'N' 
		from ITT1
		where ITT1.U_SubEns='S'
	*/

/* Valuar que no haya listas maestras con Sub-Ensambles */
		select 'QUITAR SUB-ENSAMBLE CP' AS REPORTE, * from [@TC_LISMAT]
		where [@TC_LISMAT].U_SubEns='S'
		
		/*
		update [@TC_LISMAT] set U_SubEns='N'
		where [@TC_LISMAT].U_SubEns='S'
		*/


/*ORDENES DE PRODUCCION GENERADAS NIVEL CABECERA. */
/*  Orden Generada como tipo diferente a STANDAR, Cambiar a STANDAR  */
		select 'OP DIF STANDAR' AS REPORTE, OWOR.DocEntry as NumOrde, OWOR.Status, OWOR.ItemCode as Produto,
		OITM.ItemName, OWOR.Warehouse as ALM_PRO, OWOR.Type
		from OWOR
		inner join OITM on OITM.ItemCode = OWOR.ItemCode
		where OWOR.Status='R' and OWOR.Type <> 'S'
		
/*	Ordenes Complementos Liberadas en Proceso con Almacen equivocado set owor.Warehouse= 'APT-ST' */
		select '210 ? OP DIF ALM. NO APT-ST' AS REPORTE, owor.DocNum as Orden,owor.ItemCode, oitm.ItemName, owor.Warehouse
		from owor 
		inner join OITM on OITM.ItemCode = OWOR.ItemCode 
		where owor.CmpltQty < owor.PlannedQty and owor.Warehouse <> 'APT-ST' and OITM.U_TipoMat='PT' 
		and OWOR.Status = 'R'
		
		/*
		update OWOR set wareHouse='APT-ST'
		from owor 
		inner join OITM on OITM.ItemCode = OWOR.ItemCode 
		where owor.CmpltQty < owor.PlannedQty and owor.Warehouse <> 'APT-ST' and OITM.U_TipoMat='PT' 
		and OWOR.Status = 'R'
		*/

	/* Complementos que se tienen como Sub_Ensambles (Lista de Materiales del Articulo)
	y cuando Planeacion requiera de Orden de Complementos utilizar alguna de casco ya Generada. */
		select 'COMPLEM. SUB' AS REPORTE, ITT1.Code, OITM.ItemName, ITT1.U_SubEns, OITM.QryGroup30
		from ITT1
		inner join OITM on ITT1.Code=OITM.ItemCode
		where ITT1.U_SubEns='S' and OITM.QryGroup30='Y'

		/*
		update ITT1 set U_SubEns='N'
		from ITT1
		inner join OITM on ITT1.Code=OITM.ItemCode
		where ITT1.U_SubEns='S' and OITM.QryGroup30='Y'
		*/

	/* Complementos que se tienen como Sub_Ensambles (Lista de Materiales MAESTRO)
	y cuando Planeacion requiera de Orden de Complementos utilizar alguna de casco ya Generada. */
		select 'COMPLEM. COMO SUB' AS REPORTE, V1.U_NumArt, V1.U_NomArt, V1.U_SubEns, OITM.QryGroup30 
		from [@TC_LISMAT] V1
		inner join OITM on V1.U_NumArt=OITM.ItemCode
		where v1.U_SubEns='S' and OITM.QryGroup30='Y'

		/*
		update [@TC_LISMAT] set U_SubEns='N'
		from [@TC_LISMAT] V1
		inner join OITM on V1.U_NumArt=OITM.ItemCode
		where v1.U_SubEns='S' and OITM.QryGroup30='Y'
		*/

-- Fin de Reporte de Excepciones Fusion