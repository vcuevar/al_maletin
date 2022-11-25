-- EXCEPCIONES DE RUTAS DE FABRICACION. 
-- OBJETIVO: Mantener al dia las rutas de fabricacion. En forma global por Modelo.
-- Desarrollo: Ing. Vicente Cueva Ramírez.
-- Actualizado: Lunes 26 de Julio del 2021; SAP-10
-- NOTA: Utilizar cambio automatico por ser campo de Usuario.

-- Determinar con Diseño como pueden ser los grupos de las rutas,
-- para establecer las excepciones.

--Rutas de Trabajo, Validar y cambiar las Genericas.

-- Fundas General
--100,106,109,112,115,118,121,124,127,130,133,136,139,145,148,151,154,157,160,172,175


-- Ruta Patas y Bastidores 
---400,403,406,415,418

/*=====================================================================================================================
|              Articulos de Cascos.                                                                                   |
=======================================================================================================================
ARTICULOS: */
	Select '005 RUTA LDM CASCO' AS REPO_005
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_Ruta AS RUTA_LDM
	from OITM
	Where OITM.QryGroup29='Y' and OITM.U_Ruta <> '400,403,406,409,415,418'
	/*
	Update OITM set U_Ruta = '400,403,406,409,415,418'
	Where OITM.QryGroup29='Y' and OITM.U_Ruta <> '400,403,406,409,415,418'
	*/

-- ORDENES DE PRODUCCION:
	Select '006 RUTA OP CASCO' AS REPO_006
		, OWOR.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OWOR.U_Ruta AS RUTA_OP
	From OWOR
	Inner Join OITM on OWOR.ItemCode = OITM.ItemCode
	Where OITM.QryGroup29='Y' and OWOR.U_Ruta <> '400,403,406,409,415,418'
	/*	
	Update OWOR set U_Ruta = '400,403,406,409,415,418'
	From OWOR
	Inner Join OITM on OWOR.ItemCode = OITM.ItemCode
	Where OITM.QryGroup29='Y' and OWOR.U_Ruta <> '400,403,406,409,415,418'
	*/
-- Ruta Patas y Bastidores 
---400,403,406,415,418

/*=====================================================================================================================
|              Articulos de Patas y Bastidores de Madera.                                                             |
=======================================================================================================================
ARTICULOS: */
	Select '007 RUTA LDM PATAS' AS REPO_007
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_Ruta AS RUTA_LDM
	from OITM
	Where OITM.QryGroup31='Y' and OITM.U_Ruta <> '400,406,415,418' and OITM.U_GrupoPlanea = '14'
	/*
	Update OITM set U_Ruta = '400,406,415,418'
	Where OITM.QryGroup31='Y' and OITM.U_Ruta <> '400,406,415,418' and OITM.U_GrupoPlanea = '14'
	*/

-- ORDENES DE PRODUCCION:
	Select '008 RUTA OP PATAS' AS REPO_008
		, OWOR.DocEntry AS OP
		, OWOR.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OWOR.U_Ruta AS RUTA_OP
	From OWOR
	Inner Join OITM on OWOR.ItemCode = OITM.ItemCode
	Where OITM.QryGroup31='Y' and OWOR.U_Ruta <> '400,406,415,418' and OITM.U_GrupoPlanea = '14'
	and OWOR.Status<>'C' and OWOR.Status<>'L'
	/*
	Update OWOR set U_Ruta = '400,406,415,418'
	From OWOR
	Inner Join OITM on OWOR.ItemCode = OITM.ItemCode
	Where OITM.QryGroup31='Y' and OWOR.U_Ruta <> '400,406,415,418' and OITM.U_GrupoPlanea = '14'
	and OWOR.Status<>'C' and OWOR.Status<>'L'
	*/

/*=====================================================================================================================
|              Articulos de Habilitados para Carpinteria.                                                             |
=======================================================================================================================
ARTICULOS: */
	Select '010 RUTA LDM HABILITADO' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.QryGroup30='Y' and OITM.U_Ruta <> '300,303,306,309,315'
	
	--Update OITM set U_Ruta = '300,303,306,309,315'
	--Where OITM.QryGroup30='Y' and OITM.U_Ruta <> '300,303,306,309,315'
	
-- Articulos de Con Grupo Activado y sin RUTA.
	Select '020 ARTICULO SIN RUTA' AS REPORTE_20, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.U_Ruta is null and (OITM.QryGroup29='Y' or OITM.QryGroup30='Y' or OITM.QryGroup31='Y'
	or OITM.QryGroup32='Y')
	Order By OITM.ItemName
	
	--Update OITM set U_Ruta = '100,106,172,175'
	--Where OITM.U_Ruta is null and (OITM.QryGroup29='Y' or OITM.QryGroup30='Y' or OITM.QryGroup31='Y'
	--or OITM.QryGroup32='Y')

-- Articulos de Producto Terminados Salas, sin RUTA.
	Select '025 SIN RUTA MUEBLES' AS REPORTE_25, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.U_TipoMat='PT' and OITM.U_Ruta is null
	Order By OITM.ItemName
	
	--Update OITM set U_Ruta = '100,106,109,112,115,118,121,124,127,130,133,136,139,145,148,151,154,157,160,172,175'
	--Where OITM.U_TipoMat='PT' and OITM.U_Ruta is null

-- Ruta sin 106	

	Select '030 RUTA SIN 106' AS REPORTE_30, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.U_TipoMat='PT' and OITM.U_Ruta NOT LIKE '%106%'
	--and OITM.ItemCode like '3831%' -- 3831
	Order By OITM.ItemCode
	
	-- PT Update OITM set U_Ruta = '100,106,109,112,115,118,121,124,127,130,133,136,139,145,148,151,154,157,160,172,175'
	-- COJINES Update OITM set U_Ruta = '100,106,109,112,115,118,121,124,127,130,133,136,139,145,148,151,172,175'
	-- MADERAS Update OITM set U_Ruta = '100,106,151,154,157,160,172,175'
	-- Where OITM.U_TipoMat='PT' and OITM.U_Ruta NOT LIKE '%106%'
	-- and OITM.ItemCode like '3831%'

/*=================================================================================================
|              Rutas con Estaciones No Autorizadas. 103, 142, 163, 166, 169, 312, 412	          |
===================================================================================================
Rutas con Estaciones No Autorizadas 103 Activar Orden	*/

	Select '035 CON 103' AS REPORTE_35, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%103%'
	Order By OITM.ItemCode

-- Rutas con Estaciones No Autorizadas 142 Activar Orden	
	Select '037 CON 142' AS REPORTE_37, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%142%'
	Order By OITM.ItemCode

	-- Rutas con Estaciones No Autorizadas 163 Activar Orden	
	Select '039 CON 163' AS REPORTE_39, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%163%'
	Order By OITM.ItemCode

	-- Rutas con Estaciones No Autorizadas 166 Activar Orden	
	Select '041 CON 166' AS REPORTE_41, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%166%'
	Order By OITM.ItemCode

	-- Rutas con Estaciones No Autorizadas 169 Activar Orden	
	Select '043 CON 169' AS REPORTE_43, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%169%'
	Order By OITM.ItemCode
	
	--Update OITM set U_Ruta = '100,106,109,112,115,151,157,160,172,175'
	--Where  OITM.U_Ruta LIKE '%169%'

	-- Rutas con Estaciones No Autorizadas 312 Activar Orden	
	Select '045 CON 312' AS REPORTE_45, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%312%'
	Order By OITM.ItemCode

	-- Rutas con Estaciones No Autorizadas 412 Activar Orden	
	Select '047 CON 412' AS REPORTE_47, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%412%'
	Order By OITM.ItemCode


/* ================================================================================================
|          Rutas de SUB-ENSAMBLES Hule Espuma. 200,206,209,212,218,221 	                          |
===================================================================================================
	200 Ordenes en Planeacion		PLANEACION
	206 Habilitado de Hule CNC		OPERARIO
	209 Armado de Hule				OPERARIO
	212 Pegado de Hule				OPERARIO
	218 Empaque de Hule				OPERARIO
	221 Entrega de Hule Almacen		ALMACENISTA
*/

-- Articulos Sub-Ensambles de Hule Espuma.
	--ARTICULOS:
	Select '050 RUTA LDM H.E.' AS REPO_050, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.QryGroup32='Y'  and OITM.U_GrupoPlanea = '6'
	and OITM.U_Ruta <> '200,206,209,212,218,221'
		
	/*
	Update OITM set U_Ruta = '200,206,209,212,218,221'
	Where OITM.QryGroup32='Y'  and OITM.U_GrupoPlanea = '6'
	and OITM.U_Ruta <> '200,206,209,212,218,221'
	*/

	Select '051 RUTA OP H.E.' AS REPO_051
		, OWOR.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OWOR.U_Ruta AS RUTA_OP
	From OWOR
	Inner Join OITM on OWOR.ItemCode = OITM.ItemCode
	Where OITM.QryGroup32='Y'  and OITM.U_GrupoPlanea = '6'
	and OWOR.U_Ruta <> '200,206,209,212,218,221' and OWOR.Status<>'C' and OWOR.Status<>'L'
	/*
	Update OWOR set U_Ruta = '200,206,209,212,218,221'
	From OWOR
	Inner Join OITM on OWOR.ItemCode = OITM.ItemCode
	Where OITM.QryGroup32='Y'  and OITM.U_GrupoPlanea = '6'
	and OWOR.U_Ruta <> '200,206,209,212,218,221' and OWOR.Status<>'C' and OWOR.Status<>'L'
	*/

-- Articulos CINTILLOS RUTA FIJA ES 100,106,109,112,115,118,121,124,127,130,133,136.
	--ARTICULOS:
	
	Select '071 ! ART. RUTA CINTILLOS' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.ItemName Like '%CINTI%' AND OITM.U_TipoMat <> 'MP'
	AND OITM.U_Ruta <> '100,106,109,112,115,118,121,124,127,130,133,136'

	/*
	Update OITM set U_Ruta = '100,106,109,112,115,118,121,124,127,130,133,136'
	Where OITM.ItemName Like '%CINTI%' AND OITM.U_TipoMat <> 'MP'
	AND OITM.U_Ruta <> '100,106,109,112,115,118,121,124,127,130,133,136'
	*/

	--ORDENES
	Select '075 ! OP RUTA CINTILLOS' AS REPORTE, OWOR.DocEntry, OWOR.ItemCode, OITM.ItemName, OWOR.U_Ruta
	from OWOR
	inner join OITM on OWOR.ItemCode=OITM.ItemCode
	Where OITM.ItemName Like '%CINTI%' AND OITM.U_TipoMat <> 'MP'
	AND OITM.U_Ruta <> '100,106,109,112,115,118,121,124,127,130,133,136'
	AND OWOR.Status<>'C' AND OWOR.Status<>'L'

	/*
	Update OWOR set U_Ruta = '100,106,109,112,115,118,121,124,127,130,133,136'
	from OWOR
	inner join OITM on OWOR.ItemCode=OITM.ItemCode
	Where OITM.ItemName Like '%CINTI%' AND OITM.U_TipoMat <> 'MP'
	AND OITM.U_Ruta <> '100,106,109,112,115,118,121,124,127,130,133,136'
	AND OWOR.Status<>'C' AND OWOR.Status<>'L'
	*/


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
--< EOF > EXCEPCIONES DE RUTAS DE FABRICACION.

