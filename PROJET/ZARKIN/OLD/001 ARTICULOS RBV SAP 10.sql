

	/* Actualiza Cuentas contables para Poliza de Compras. */
	
	Update OITM set U_VerReporte = '500100001' Where OITM.ItmsGrpCod = 100 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100001')
	Update OITM set U_VerReporte = '500100002' Where OITM.ItmsGrpCod = 114 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100002')
	Update OITM set U_VerReporte = '500100003' Where OITM.ItmsGrpCod = 113 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100003')
	Update OITM set U_VerReporte = '500100004' Where OITM.ItmsGrpCod = 109 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100004')
	Update OITM set U_VerReporte = '500100005' Where OITM.ItmsGrpCod = 138 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100005')
	Update OITM set U_VerReporte = '500100006' Where OITM.ItmsGrpCod = 116 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100006')
	Update OITM set U_VerReporte = '500100007' Where OITM.ItmsGrpCod = 107 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100007')
	Update OITM set U_VerReporte = '500100008' Where OITM.ItmsGrpCod = 105 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100008')
	Update OITM set U_VerReporte = '500100009' Where OITM.ItmsGrpCod = 110 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100009')
	Update OITM set U_VerReporte = '500100010' Where OITM.ItmsGrpCod = 111 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100010')
	Update OITM set U_VerReporte = '500100012' Where OITM.ItmsGrpCod = 139 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100012')
	Update OITM set U_VerReporte = '500100013' Where OITM.ItmsGrpCod = 140 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100013')
	Update OITM set U_VerReporte = '500100014' Where OITM.ItmsGrpCod = 141 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100014')
	Update OITM set U_VerReporte = '500100016' Where OITM.ItmsGrpCod = 142 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100016')
	Update OITM set U_VerReporte = '500100018' Where OITM.ItmsGrpCod = 108 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100018')
	Update OITM set U_VerReporte = '500100020' Where OITM.ItmsGrpCod = 106 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100020')
	Update OITM set U_VerReporte = '500100022' Where OITM.ItmsGrpCod = 112 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100022')
	Update OITM set U_VerReporte = '500100023' Where OITM.ItmsGrpCod = 143 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100023')
	Update OITM set U_VerReporte = '500100030' Where OITM.ItmsGrpCod = 115 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100030')
	Update OITM set U_VerReporte = '500200004' Where OITM.ItmsGrpCod = 121 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500200004')	
	Update OITM set U_VerReporte = '500100030' Where OITM.ItmsGrpCod = 132 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100030')
	
		

-- Clave de Productos y Servicios para Salas Kit de Ventas.
	Select '525 ! SALAS C. PROD. SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.U_TipoMat = 'PT' and OITM.InvntItem = 'N' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 56101532
	where OITM.U_TipoMat = 'PT' and OITM.InvntItem = 'N' and (OITM.U_ClaveProdServ is null)

-- Clave de Unidad de medida para Salas Kit de Ventas.
	Select '530 ! SALAS C. UM. SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.U_TipoMat = 'PT' and OITM.InvntItem = 'N' and (OITM.U_ClaveUnidad is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = '10'
	where OITM.U_TipoMat = 'PT' and OITM.InvntItem = 'N' and (OITM.U_ClaveUnidad is null)

-- Clave de Productos y Servicios para Muebles y Articulos que son Inventariables.
-- Se realiza en funcion a los Grupos de Articulos.
-- Select OITB.ItmsGrpCod, OITB.ItmsGrpNam from OITB Order by OITB.ItmsGrpNam

	Select '535 ! ART. REFACCIONES CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 134 and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 56101907
	where OITM.ItmsGrpCod = 134 and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 56101907
	where OITM.ItmsGrpCod = 134 and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 56101907)

	Select '540 ! ART. MUEBLES CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where (OITM.ItmsGrpCod = 145 or OITM.ItmsGrpCod = 117 or OITM.ItmsGrpCod = 121 or OITM.ItmsGrpCod = 123
	or OITM.ItmsGrpCod = 124 or OITM.ItmsGrpCod = 125 or OITM.ItmsGrpCod = 126 or OITM.ItmsGrpCod = 127
	or OITM.ItmsGrpCod = 128) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 56101500
	where (OITM.ItmsGrpCod = 145 or OITM.ItmsGrpCod = 117 or OITM.ItmsGrpCod = 121 or OITM.ItmsGrpCod = 123
	or OITM.ItmsGrpCod = 124 or OITM.ItmsGrpCod = 125 or OITM.ItmsGrpCod = 126 or OITM.ItmsGrpCod = 127
	or OITM.ItmsGrpCod = 128) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 56101500
	where (OITM.ItmsGrpCod = 145 or OITM.ItmsGrpCod = 117 or OITM.ItmsGrpCod = 121 or OITM.ItmsGrpCod = 123
	or OITM.ItmsGrpCod = 124 or OITM.ItmsGrpCod = 125 or OITM.ItmsGrpCod = 126 or OITM.ItmsGrpCod = 127
	or OITM.ItmsGrpCod = 128) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 56101500)

	Select '545 ! ART. SERVICIOS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 135 
	and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 81141800
	where OITM.ItmsGrpCod = 135 
	and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 81141800
	where OITM.ItmsGrpCod = 135 
	and (OITM.U_ClaveProdServ <> 81141800)
	
	Select '550 ! ART. COMPLEMENTOS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where (OITM.ItmsGrpCod = 118 or OITM.ItmsGrpCod = 119 or OITM.ItmsGrpCod = 120 or OITM.ItmsGrpCod = 122
	or OITM.ItmsGrpCod = 129) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 56101900
	where (OITM.ItmsGrpCod = 118 or OITM.ItmsGrpCod = 119 or OITM.ItmsGrpCod = 120 or OITM.ItmsGrpCod = 122
	or OITM.ItmsGrpCod = 129) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 56101900
	where (OITM.ItmsGrpCod = 118 or OITM.ItmsGrpCod = 119 or OITM.ItmsGrpCod = 120 or OITM.ItmsGrpCod = 122
	or OITM.ItmsGrpCod = 129) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 56101900)
	
	Select '555 ! ART. HULE ESPUMA CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 109
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 13111300
	where OITM.ItmsGrpCod = 109
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 13111300
	where OITM.ItmsGrpCod = 109
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 13111300)

	Select '560 ! ART. BANDA Y RESORTE CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 116
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 31151900
	where OITM.ItmsGrpCod = 116
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 31151900
	where OITM.ItmsGrpCod = 116
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 31151900)

	Select '565 ! ART. CARTON CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 106
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 31261500
	where OITM.ItmsGrpCod = 106
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 31261500
	where OITM.ItmsGrpCod = 106
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 31261500)

	Select '570 ! ART. LACAS-ESMALTES CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 110
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 31211700
	where OITM.ItmsGrpCod = 110
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 31211700
	where OITM.ItmsGrpCod = 110
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 31211700)

	Select '575 ! ART. CIERRES CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 111
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 53141500
	where OITM.ItmsGrpCod = 111
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 53141500
	where OITM.ItmsGrpCod = 111
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 53141500)

	Select '580 ! ART. CINTAS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 143
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 31201500
	where OITM.ItmsGrpCod = 143
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 31201500
	where OITM.ItmsGrpCod = 143
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 31201500)

	Select '585 ! ART. GUATAS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 138
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 11162400
	where OITM.ItmsGrpCod = 138
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 11162400
	where OITM.ItmsGrpCod = 138
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 11162400)

	Select '590 ! ART. CUEROS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 113
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 11162300
	where OITM.ItmsGrpCod = 113
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 11162300
	where OITM.ItmsGrpCod = 113
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 11162300)

	Select '595 ! ART. PLUMONES CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 112
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 52121507
	where OITM.ItmsGrpCod = 112
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 52121507
	where OITM.ItmsGrpCod = 112
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 52121507)

	Select '600 ! ART. HILOS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 142
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 11151700
	where OITM.ItmsGrpCod = 142
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 11151700
	where OITM.ItmsGrpCod = 142
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 11151700)

	Select '605 ! ART. MADERAS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where (OITM.ItmsGrpCod = 100 OR  OITM.ItmsGrpCod = 101) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 30103600
	where (OITM.ItmsGrpCod = 100 OR  OITM.ItmsGrpCod = 101) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 30103600
	where (OITM.ItmsGrpCod = 100 OR  OITM.ItmsGrpCod = 101) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 30103600)

	Select '610 ! ART. TORNILLOS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 141
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 31161500
	where OITM.ItmsGrpCod = 141
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 31161500
	where OITM.ItmsGrpCod = 141
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 31161500)

	Select '615 ! ART. GRAPAS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 107
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 31162400
	where OITM.ItmsGrpCod = 107
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 31162400
	where OITM.ItmsGrpCod = 107
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 31162400)

	Select '620 ! ART. POLIETILENO CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 105
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 13111200
	where OITM.ItmsGrpCod = 105
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 13111200
	where OITM.ItmsGrpCod = 105
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 13111200)

	Select '625 ! ART. POLIPACK CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 140
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 31181700
	where OITM.ItmsGrpCod = 140
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 31181700
	where OITM.ItmsGrpCod = 140
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 31181700)

	Select '630 ! ART. TELAS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 114
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 11161800
	where OITM.ItmsGrpCod = 114
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 11161800
	where OITM.ItmsGrpCod = 114
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 11161800)

	Select '635 ! ART. DE LIMPIEZA CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 130
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 47121900
	where OITM.ItmsGrpCod = 130
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 47121900
	where OITM.ItmsGrpCod = 130
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 47121900)

	Select '640 ! ART. ISUMOS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where (OITM.ItmsGrpCod = 115 OR OITM.ItmsGrpCod = 132) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 14101500
	where (OITM.ItmsGrpCod = 115 OR OITM.ItmsGrpCod = 132)
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 14101500
	where (OITM.ItmsGrpCod = 115 OR OITM.ItmsGrpCod = 132)
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 14101500)

	Select '645 ! ART. PAPELERIA CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 133
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 44121600
	where OITM.ItmsGrpCod = 133
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 44121600
	where OITM.ItmsGrpCod = 133
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 44121600)

	Select '650 ! ART. HERRAMIENTA CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 131
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 27112100
	where OITM.ItmsGrpCod = 131
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 27112100
	where OITM.ItmsGrpCod = 131
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 27112100)

	Select '655 ! ART. GASTOS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 136
	and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 78121600
	where OITM.ItmsGrpCod = 136
	and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 78121600
	where OITM.ItmsGrpCod = 136
	and (OITM.U_ClaveProdServ <> 78121600)
	
	Select '660 ! ART. MAQUILAS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 139
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 72152300
	where OITM.ItmsGrpCod = 139
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 72152300
	where OITM.ItmsGrpCod = 139
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 72152300)

	Select '665 ! ART. GASTOS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where (OITM.ItmsGrpCod = 102 OR OITM.ItmsGrpCod = 103 OR OITM.ItmsGrpCod = 104)
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 76122405
	where (OITM.ItmsGrpCod = 102 OR OITM.ItmsGrpCod = 103 OR OITM.ItmsGrpCod = 104)
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 76122405
	where (OITM.ItmsGrpCod = 102 OR OITM.ItmsGrpCod = 103 OR OITM.ItmsGrpCod = 104)
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 76122405)

	Select '670 ! ART. HERRAJES CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 108
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 72154024
	where OITM.ItmsGrpCod = 108
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 72154024
	where OITM.ItmsGrpCod = 108
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 72154024)

-- Articulos sin Clave de Productos del SAT
	Select '675 ? ART. SIN CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.U_ClaveProdServ is null
	Order by OITM.ItemName

--Las Unidades del las materias primas correran en funcion a la unidad de inventario.
-- Clave de Unidad y Servicios para Salas Kit de Ventas.
	Select '680 ! PT. SIN UM. PZA SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'PZA'  AND OITM.U_TipoMat = 'PT' AND ((OITM.U_ClaveUnidad <> '10' AND OITM.U_ClaveUnidad <> 'H87') OR OITM.U_ClaveUnidad IS NULL )
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'H87' where OITM.InvntryUom = 'PZA'  AND OITM.U_TipoMat = 'PT' AND ((OITM.U_ClaveUnidad <> '10' AND OITM.U_ClaveUnidad <> 'H87') OR OITM.U_ClaveUnidad IS NULL )
	
	Select '685 ! ART. SIN UM. PZA SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'PZA'  AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'H87' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'H87' where OITM.InvntryUom = 'PZA'  AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'H87' OR OITM.U_ClaveUnidad IS NULL)

	Select '690 ! ART. SIN UM. MT2 SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'MT2'  AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'MTK' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'MTK' WHERE OITM.InvntryUom = 'MT2'  AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'MTK' OR OITM.U_ClaveUnidad IS NULL)
	
	Select '695 ! ART. SIN UM. JGO SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'JGO' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> '10' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = '10' WHERE OITM.InvntryUom = 'JGO'  AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> '10' OR OITM.U_ClaveUnidad IS NULL)
	
	Select '700 ! ART. SIN UM. DC2 SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'DC2' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'DMK' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'DMK' WHERE OITM.InvntryUom = 'DC2' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'DMK' OR OITM.U_ClaveUnidad IS NULL)
	
	Select '705 ! ART. SIN UM. MTS SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'MTS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'LM' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'LM' WHERE OITM.InvntryUom = 'MTS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'LM' OR OITM.U_ClaveUnidad IS NULL)

	Select '710 ! ART. SIN UM. LTS SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'LTS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'LTR' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'LTR' WHERE OITM.InvntryUom = 'LTS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'LTR' OR OITM.U_ClaveUnidad IS NULL)

	Select '715 ! ART. SIN UM. ML SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'ML' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'MLT' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'MLT' WHERE OITM.InvntryUom = 'ML' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'MLT' OR OITM.U_ClaveUnidad IS NULL)

	Select '720 ! ART. SIN UM. KGS SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'KGS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'KGM' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'KGM' WHERE OITM.InvntryUom = 'KGS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'KGM' OR OITM.U_ClaveUnidad IS NULL)

	Select '725 ! ART. SIN UM. CUBETA SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'CUBETA' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XBJ' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'XBJ' WHERE OITM.InvntryUom = 'CUBETA' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XBJ' OR OITM.U_ClaveUnidad IS NULL)

	Select '730 ! ART. SIN UM. ROLLO SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'ROLLO' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XRO' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'XRO' WHERE OITM.InvntryUom = 'ROLLO' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XRO' OR OITM.U_ClaveUnidad IS NULL)

	Select '735 ! ART. SIN UM. ROLLO SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'ROLLO' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XRO' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'XRO' WHERE OITM.InvntryUom = 'ROLLO' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XRO' OR OITM.U_ClaveUnidad IS NULL)

	Select '740 ! ART. SIN UM. FT2 SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'FT2' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'FTK' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'FTK' WHERE OITM.InvntryUom = 'FT2' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'FTK' OR OITM.U_ClaveUnidad IS NULL)

	Select '745 ! ART. SIN UM. FT3 SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'FT3' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'BFT' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'BFT' WHERE OITM.InvntryUom = 'FT3' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'BFT' OR OITM.U_ClaveUnidad IS NULL)

	Select '750 ! ART. SIN UM. MIN SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'MIN' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'MIN' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'MIN' WHERE OITM.InvntryUom = 'MIN' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'MIN' OR OITM.U_ClaveUnidad IS NULL)

	Select '755 ! ART. SIN UM. CAJA SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'CAJA' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XBX' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'XBX' WHERE OITM.InvntryUom = 'CAJA' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XBX' OR OITM.U_ClaveUnidad IS NULL)

	Select '760 ! ART. SIN UM. PAQ SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'PAQ' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XPK' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'XPK' WHERE OITM.InvntryUom = 'PAQ' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XPK' OR OITM.U_ClaveUnidad IS NULL)

	Select '765 ! ART. SIN UM. YDS SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'YDS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'YRD' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'YRD' WHERE OITM.InvntryUom = 'YDS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'YRD' OR OITM.U_ClaveUnidad IS NULL)

	Select '770 ! ART. SIN UM. PAR SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'PAR' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'PR' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'PR' WHERE OITM.InvntryUom = 'PAR' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'PR' OR OITM.U_ClaveUnidad IS NULL)

	Select '775 ! ART. SIN UM. PESOS SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'PESOS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'M4' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'M4' WHERE OITM.InvntryUom = 'PESOS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'M4' OR OITM.U_ClaveUnidad IS NULL)

	Select '780 ? ART. SIN UM. SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.U_ClaveUnidad IS NULL
	Order by OITM.ItemName
	
	-- Ordenes que se movieron a Planificadas y no se Borro de Control de Piso.
	-- Se borra historial para nuevamente ser capturadas.

	Select '790 ? BASURA EN PISO' AS REPORTE
		, CP.Code, CP.U_DocEntry, OP.ItemCode, A3.ItemName, OP.Status 
	from [@CP_OF] CP 
	inner join OWOR OP on CP.U_DocEntry= OP.DocEntry 
	inner join OITM A3 on OP.ItemCode = A3.ItemCode 
	where OP.Status = 'P' 

