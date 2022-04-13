--Rutas de Trabajo, Validar y cambiar las Genericas.

-- Articulos de Cascos.
	--ARTICULOS:
	Select '005 ! RUTA LDM CASCO' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.QryGroup29='Y' and OITM.U_Ruta <> '400,403,406,409,415,418'
	
	
	Update OITM set U_Ruta = '400,403,406,409,415,418'
	Where OITM.QryGroup29='Y' and OITM.U_Ruta <> '400,403,406,409,415,418'

	--ORDENESDE CASCO
	Select '010 ! RUTA OP CASCO' AS REPORTE, OWOR.DocEntry, OWOR.ItemCode, OITM.ItemName, OWOR.U_Ruta
	from OWOR
	inner join OITM on OWOR.ItemCode=OITM.ItemCode
	Where OITM.QryGroup29='Y' and OWOR.U_Ruta <> '400,403,406,409,415,418' and OWOR.Status <>'C' and OWOR.Status <>'L'

	
	Update OWOR set U_Ruta = '400,403,406,409,415,418'
	from OWOR
	inner join OITM on OWOR.ItemCode=OITM.ItemCode
	Where OITM.QryGroup29='Y' and OWOR.U_Ruta <> '400,403,406,409,415,418' and OWOR.Status <>'C' and OWOR.Status <>'L'

	
-- Articulos de Habilitados para Carpinteria.
	--ARTICULOS:
	Select '020 RUTA LDM HABILITADO' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.QryGroup30='Y' and OITM.U_Ruta <> '300,303,306,309,315'
	
	Update OITM set U_Ruta = '300,303,306,309,315'
	Where OITM.QryGroup30='Y' and OITM.U_Ruta <> '300,303,306,309,315'
	
	--ORDENES:
	Select '015 RUTA OP HABILITADO' AS REPORTE, OWOR.DocEntry, OWOR.ItemCode, OITM.ItemName, OWOR.U_Ruta
	from OWOR
	inner join OITM on OWOR.ItemCode=OITM.ItemCode
	Where OITM.QryGroup30='Y' and OWOR.U_Ruta <> '300,303,306,309,315' and OWOR.Status<>'C' and OWOR.Status<>'L'

	Update OWOR set U_Ruta = '300,303,306,309,315'
	from OWOR
	inner join OITM on OWOR.ItemCode=OITM.ItemCode
	Where OITM.QryGroup30='Y' and OWOR.U_Ruta <> '300,303,306,309,315' and OWOR.Status<>'C' and OWOR.Status<>'L'






/*

NO CORRER HASTA QUE SE DEFINA COMO SE MANEJAN LAS ESTACIONES DE TELA



/* Excepciones para Nuevas Estaciones de Trabajo y Nuevos Almacenes */


-- Articulos de Patas y Bastidores.
	--ARTICULOS:
	
	Select '055 ! RUTA LDM PATAS' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.QryGroup31='Y' and OITM.U_Ruta is null
	
	Update OITM set U_Ruta = '400,403,406,415,418'
	Where OITM.QryGroup31='Y' and OITM.U_Ruta is null
	
	Select '062 ! RUTA LDM PATAS' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.QryGroup31='Y' and OITM.U_Ruta<> '400,403,406,415,418'
		
	Update OITM set U_Ruta = '400,403,406,415,418'
	Where OITM.QryGroup31='Y' and OITM.U_Ruta<> '400,403,406,415,418'
	
	--ORDENES
	Select '070 ! RUTA OP PATAS' AS REPORTE, OWOR.DocEntry, OWOR.ItemCode, OITM.ItemName, OWOR.U_Ruta
	from OWOR
	inner join OITM on OWOR.ItemCode=OITM.ItemCode
	Where OITM.QryGroup31='Y' and OWOR.U_Ruta is null and OWOR.Status<>'C' and OWOR.Status<>'L'
	
	Update OWOR set U_Ruta = '400,403,406,415,418'
	from OWOR
	inner join OITM on OWOR.ItemCode=OITM.ItemCode
	Where OITM.QryGroup31='Y' and OWOR.U_Ruta is null and OWOR.Status<>'C' and OWOR.Status<>'L'
		
	Select '080 ! RUTA OP PATAS' AS REPORTE, OWOR.DocEntry, OWOR.ItemCode, OITM.ItemName, OWOR.U_Ruta
	from OWOR
	inner join OITM on OWOR.ItemCode=OITM.ItemCode
	Where OITM.QryGroup31='Y' and OWOR.U_Ruta<> '400,403,406,415,418'and OWOR.Status<>'C' and OWOR.Status<>'L'

	Update OWOR set U_Ruta = '400,403,406,415,418'
	from OWOR
	inner join OITM on OWOR.ItemCode=OITM.ItemCode
	Where OITM.QryGroup31='Y' and OWOR.U_Ruta<> '400,403,406,415,418'and OWOR.Status<>'C' and OWOR.Status<>'L'

-- Articulos de Salas.
	--ARTICULOS:
	Select '078 RUTA LDM MUEBLES' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.U_TipoMat='PT' and OITM.U_Ruta<> '100,106,109,112,115,118,121,124,127,130,133,136,139,145,148,151,154,157,160,172,175'
	and OITM.ItemCode not like '3721%' and OITM.ItemCode not like '3720-30%' and OITM.ItemCode not like '3612%' 

	/*
	Update OITM set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,139,145,148,151,154,157,160,172,175'
	Where OITM.U_TipoMat='PT' and OITM.U_Ruta<> '100,106,109,112,115,118,121,124,127,130,133,136,145,148,151,154,157,160,172,175'
	and OITM.ItemCode not like '3721%' and OITM.ItemCode not like '3720-30%' and OITM.ItemCode not like '3612%' 
	*/
	
	--ORDENES:
	Select '090 RUTA OP MUEBLES' AS REPORTEE, OWOR.DocEntry, OWOR.ItemCode, OITM.ItemName, OWOR.U_Ruta
	from OWOR
	inner join OITM on OWOR.ItemCode=OITM.ItemCode
	Where OITM.U_TipoMat='PT' and OWOR.Status<>'C' and OWOR.Status<>'L' and OWOR.U_Ruta<> '100,106,109,112,115,118,121,124,127,130,133,136,139,145,148,151,154,157,160,172,175'
	and OITM.ItemCode not like '3721%' and OITM.ItemCode not like '3720-30%'  and OITM.ItemCode not like '3612%' 


	/*
	Update OWOR set U_Ruta = '100,106,109,112,115,118,121,124,127,130,133,136,139,145,148,151,154,157,160,172,175'
	from OWOR
	inner join OITM on OWOR.ItemCode=OITM.ItemCode
	Where OITM.U_TipoMat='PT' and OWOR.Status<>'C' and OWOR.Status<>'L' and OWOR.U_Ruta<> '100,106,109,112,115,118,121,124,127,130,133,136,145,148,151,154,157,160,172,175'
	*/

-- Articulos de Especiales.
	--ARTICULOS:
--	Select OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
--	from OITM
--	Where OITM.ItemCode like '3720-30%'
 
--Update OITM set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136' Where OITM.ItemCode='17362'
--Update OITM set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136' Where OITM.ItemCode='3581-42-P0230'
--Update OITM set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136' Where OITM.ItemCode='3581-42-P0301'
--Update OITM set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136' Where OITM.ItemCode='3715-42-P0201'
--Update OITM set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136' Where OITM.ItemCode='3715-42-P0230'

--Update OITM set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,172,175' Where OITM.ItemCode='3715-45-P0230'
--Update OITM set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,172,175' Where OITM.ItemCode='3715-46-P0230'
--Update OITM set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,172,175' Where OITM.ItemCode='3715-47-P0230'
--Update OITM set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,172,175' Where OITM.ItemCode='3510-43-P0230'
--Update OITM set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,172,175' Where OITM.ItemCode='3581-43-P0230'
--Update OITM set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,172,175' Where OITM.ItemCode='3581-44-P0230'
--Update OITM set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,172,175' Where OITM.ItemCode='3715-43-P0230'

--Update OITM set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,145,148,151,154,157,160,172,175' Where OITM.ItemCode='3699-52-P0301'
--Update OITM set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,145,148,151,154,157,160,172,175' Where OITM.ItemCode='3699-52-P0306'
--Update OITM set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,145,148,151,154,157,160,172,175' Where OITM.ItemCode='3699-53-P0301'
--Update OITM set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,145,148,151,154,157,160,172,175' Where OITM.ItemCode='3699-53-P0306'

	-- MESAS PUNZZO
	Select '130 RUTA LDM PUNZO' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.ItemCode like '3720-30-M%' and U_Ruta <>'100,151,160,172,175'
	
	--Update OITM set U_Ruta='100,151,160,172,175' Where OITM.ItemCode like '3720-30-M%'

-- MESAS TAVOLA
	Select '137 RUTA LDM TAVOLA' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.ItemCode like '3721-%' and U_Ruta <>'100,151,160,172,175'
	
	--Update OITM set U_Ruta='100,151,160,172,175' Where OITM.ItemCode like '3721-%'


-- MESAS BRAZZ
	Select '145 RUTA LDM BRAZZ' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.ItemCode like '3612-%' and U_Ruta <> '100,160,172,175' 
	
	--Update OITM set U_Ruta='100,160,172,175' Where OITM.ItemCode like '3612-%'

	--ORDENES:
	--Select OWOR.DocEntry, OWOR.ItemCode, OWOR.U_Ruta
	--from OWOR
	--Where OWOR.ItemCode like '3720-'
	
--Update OWOR set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136' where OWOR.ItemCode='17362'
--Update OWOR set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136' where OWOR.ItemCode='3581-42-P0230'
--Update OWOR set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136' where OWOR.ItemCode='3581-42-P0301'
--Update OWOR set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136' where OWOR.ItemCode='3715-42-P0201'
--Update OWOR set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136' where OWOR.ItemCode='3715-42-P0230'

--Update OWOR set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,172,175' where OWOR.ItemCode='3715-45-P0230'
--Update OWOR set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,172,175' where OWOR.ItemCode='3715-46-P0230'
--Update OWOR set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,172,175' where OWOR.ItemCode='3715-47-P0230'
--Update OWOR set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,172,175' where OWOR.ItemCode='3510-43-P0230'
--Update OWOR set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,172,175' where OWOR.ItemCode='3581-43-P0230'
--Update OWOR set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,172,175' where OWOR.ItemCode='3581-44-P0230'
--Update OWOR set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,172,175' where OWOR.ItemCode='3715-43-P0230'

--Update OWOR set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,145,148,151,154,157,160,172,175' where OWOR.ItemCode='3699-52-P0301'
--Update OWOR set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,145,148,151,154,157,160,172,175' where OWOR.ItemCode='3699-52-P0306'
--Update OWOR set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,145,148,151,154,157,160,172,175' where OWOR.ItemCode='3699-53-P0301'
--Update OWOR set U_Ruta='100,106,109,112,115,118,121,124,127,130,133,136,145,148,151,154,157,160,172,175' where OWOR.ItemCode='3699-53-P0306'

	-- PARA MESA PUNZZO
	Select '176 RUTA OP PUNZZO' AS REPORTE, OWOR.DocEntry, OWOR.ItemCode, OWOR.U_Ruta
	from OWOR
	Where OWOR.ItemCode like '3720-30%' and OWOR.Status<>'C' and OWOR.Status<>'L' and
	OWOR.U_Ruta <> '100,151,160,172,175'

	--Update OWOR set U_Ruta='100,151,160,172,175' Where OWOR.ItemCode like '3720-30%' and OWOR.Status<>'C' and OWOR.Status<>'L'

	-- PARA MESA TAVOLA
	Select '184 RUTA OP TAVOLA' AS REPORTE, OWOR.DocEntry, OWOR.ItemCode, OWOR.U_Ruta
	from OWOR
	Where OWOR.ItemCode like '3721-%' and OWOR.Status<>'C' and OWOR.Status<>'L' and
	OWOR.U_Ruta <> '100,151,160,172,175'
	
	--Update OWOR set U_Ruta='100,151,160,172,175' Where OWOR.ItemCode like '3721-%' and OWOR.Status<>'C' and OWOR.Status<>'L'


-- MESAS BRAZZ
	Select '193 RUTA OP BRAZZ' AS REPORTE, OWOR.DocEntry, OWOR.ItemCode, OWOR.U_Ruta
	from OWOR
	Where OWOR.ItemCode like '3612-%' and OWOR.Status<>'C' and OWOR.Status<>'L'
	and OWOR.U_Ruta <> '100,160,172,175'
	
	--Update OWOR set U_Ruta='100,160,172,175' Where OWOR.ItemCode like '3612-%' and OWOR.Status<>'C' and OWOR.Status<>'L'
	
-- Fin Reporte de Excepciones Estaciones
*/
