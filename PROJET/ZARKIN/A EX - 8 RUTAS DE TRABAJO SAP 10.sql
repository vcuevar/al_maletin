-- EXCEPCIONES DE RUTAS DE FABRICACION. 
-- OBJETIVO: Mantener al dia las rutas de fabricacion. En forma global por Modelo.
-- Desarrollo: Ing. Vicente Cueva Ramírez.
-- Actualizado: Lunes 26 de Julio del 2021; SAP-10
-- NOTA: Utilizar cambio automatico por ser campo de Usuario.

-- Determinar con Diseño como pueden ser los grupos de las rutas,
-- para establecer las excepciones. Por mas intentos que hice no se ponen de modo, asi que yo vere como estandarizo.
-- Actualizado: viernes 05 de septiembre del 2025; Estandarizar y automatizar.

/*=====================================================================================================================
|              Articulos sin Ruta.    Definir Ruta:                                                                   |
=======================================================================================================================
*/
	Select '001 SIN RUTA' AS REPO_001
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_TipoMat AS TM
		, OITM.U_Ruta AS RUTA
		, OITM.U_GrupoPlanea AS PLANEA
	from OITM
	Where OITM.U_TipoMat <> 'MP' and OITM.U_TipoMat <> 'GF' 
	and ISNULL(OITM.U_Ruta, 'SIN/RUTA') = 'SIN/RUTA'
	
		/*
	Update OITM set U_Ruta = '400,403,406,409,415,418'
	Where OITM.U_TipoMat = 'CA' and OITM.U_Ruta <> '400,403,406,409,415,418'
	*/

/*=====================================================================================================================
|              Articulos de Cascos.    Ruta: '400,403,406,409,415,418'                                                |
=======================================================================================================================
*/
	Select '005 RUTA CASCO' AS REPO_005
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_TipoMat AS TM
		, OITM.U_Ruta AS RUTA
		, OITM.U_GrupoPlanea AS PLANEA
	from OITM
	Where OITM.U_TipoMat = 'CA' and OITM.U_Ruta <> '400,403,406,409,415,418'
	
		/*
	Update OITM set U_Ruta = '400,403,406,409,415,418'
	Where OITM.U_TipoMat = 'CA' and OITM.U_Ruta <> '400,403,406,409,415,418'
	*/

/*=====================================================================================================================
|              Articulos de Patas y Bastidores de Madera.   Ruta: '400,406,415,418'                                   |
=======================================================================================================================
*/
	Select '007 RUTA PATAS' AS REPO_007
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_TipoMat AS TM
		, OITM.U_Ruta AS RUTA
		, OITM.U_GrupoPlanea AS PLANEA
	from OITM
	Where OITM.U_TipoMat = 'SP' and OITM.U_Ruta <> '400,406,415,418' and (OITM.U_GrupoPlanea = '14' OR OITM.U_GrupoPlanea = '28')

	/*

	Update OITM set U_Ruta = '400,406,415,418'
	Where OITM.U_TipoMat = 'SP' and OITM.U_Ruta <> '400,406,415,418' and (OITM.U_GrupoPlanea = '14' OR OITM.U_GrupoPlanea = '28')
	
	*/

/*=====================================================================================================================
|              Articulos de Subensambles Generales.   Ruta Minima: '100,106,109,148,172,175'                          |
=======================================================================================================================
*/
	Select '009 RUTA SB' AS REPO_009
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_TipoMat AS TM
		, OITM.U_Ruta AS RUTA
		, OITM.U_GrupoPlanea AS PLANEA
	from OITM
	Where OITM.U_TipoMat = 'SP' and OITM.U_Ruta <> '100,106,109,148,172,175' 
	and OITM.U_GrupoPlanea <> '14' and OITM.U_GrupoPlanea <> '28'

	/*

	Update OITM set U_Ruta = '100,106,109,148,172,175' 
	Where OITM.U_TipoMat = 'SP' and OITM.U_Ruta <> '100,106,109,148,172,175' 
	and OITM.U_GrupoPlanea <> '14' and OITM.U_GrupoPlanea <> '28'

	*/

/*=====================================================================================================================
|              Articulos de Refacciones en Generales.   Ruta Minima: '100,106,109,148,172,175'                        |
=======================================================================================================================
*/
	Select '011 RUTA RF' AS REPO_011
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_TipoMat AS TM
		, OITM.U_Ruta AS RUTA
		, OITM.U_GrupoPlanea AS PLANEA
	from OITM
	Where OITM.U_TipoMat = 'RF' and OITM.U_Ruta <> '100,106,109,148,172,175' 
	and Len(OITM.ItemCode) < 6
	
	/*

	Update OITM set U_Ruta = '100,106,109,148,172,175' 
	Where OITM.U_TipoMat = 'RF' and OITM.U_Ruta <> '100,106,109,148,172,175' 
	and Len(OITM.ItemCode) < 6


	*/

	Select '012 RUTA REFURNISH' AS REPO_012
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_TipoMat AS TM
		, OITM.U_Ruta AS RUTA
		, OITM.U_GrupoPlanea AS PLANEA
	from OITM
	Where OITM.U_TipoMat = 'RF' and OITM.U_Ruta <> '100,106,109,112,115,118,121,124,127,130,133,136,148,169,172,175'
	and Len(OITM.ItemCode) > 5
	

/*

	Update OITM set U_Ruta = '100,106,109,112,115,118,121,124,127,130,133,136,148,169,172,175'
	Where OITM.U_TipoMat = 'RF' and OITM.U_Ruta <> '100,106,109,112,115,118,121,124,127,130,133,136,148,169,172,175'
	and Len(OITM.ItemCode) > 5
	
	*/	

/*=====================================================================================================================
|              Articulos de Habilitado (Obsoleto por desaparecer).   Ruta: '300,303,306,309,315'                      |
=======================================================================================================================
*/
	Select '013 RUTA HB' AS REPO_013
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_TipoMat AS TM
		, OITM.U_Ruta AS RUTA
		, OITM.U_GrupoPlanea AS PLANEA
	from OITM
	Where OITM.U_TipoMat = 'HB' and OITM.U_Ruta <> '300,303,306,309,315' 
	
	/*

	Update OITM set U_Ruta = '300,303,306,309,315' 
	Where OITM.U_TipoMat = 'HB' and OITM.U_Ruta <> '300,303,306,309,315' 

	*/

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
	Select '015 RUTA LDM H.E.' AS REPO_050, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.QryGroup32='Y'  and OITM.U_GrupoPlanea = '6'
	and OITM.U_Ruta <> '200,206,209,212,218,221'
		
	/*
	Update OITM set U_Ruta = '200,206,209,212,218,221'
	Where OITM.QryGroup32='Y'  and OITM.U_GrupoPlanea = '6'
	and OITM.U_Ruta <> '200,206,209,212,218,221'
	*/
	
/*=====================================================================================================================
|                      Articulos Producto Terminado.   Ruta:  VARIOS
=======================================================================================================================
*/
--Ruta para CINTILLOS -> '100,106,109,112,115,118,121,124,127,130,133,136,148,172,175' 

	Select '017 RUTA CINTILLOS' AS REPO_015
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_TipoMat AS TM
		--, OITM.U_Ruta AS RUTA
		, OITM.U_GrupoPlanea AS PLANEA
		, OITM.U_Linea AS LINEA
		, OITM.ItmsGrpCod AS GRUPO
	from OITM
	Where OITM.U_TipoMat = 'PT' and OITM.ItmsGrpCod = 133
	and OITM.U_Ruta <> '100,106,109,112,115,118,121,124,127,130,133,136,148,172,175' 
		
	/*

	Update OITM set U_Ruta = '100,106,109,112,115,118,121,124,127,130,133,136,148,172,175' 
	Where OITM.U_TipoMat = 'PT' and OITM.ItmsGrpCod = 133
	and OITM.U_Ruta <> '100,106,109,112,115,118,121,124,127,130,133,136,148,172,175' 

	*/

--Ruta para PT Copjines-> RUTA: 100,106,109,112,115,118,121,124,127,130,133,136,139,145,146,148,151,169,172,175

	Select '019 RUTA COJINES' AS REPO_019
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_TipoMat AS TM
		--, OITM.U_Ruta AS RUTA
		, OITM.U_GrupoPlanea AS PLANEA
		, OITM.U_Linea AS LINEA
		, OITM.ItmsGrpCod AS GRUPO
	from OITM
	Where OITM.U_TipoMat = 'PT' and OITM.ItmsGrpCod = 118
	and OITM.U_Ruta <> '100,106,109,112,115,118,121,124,127,130,133,136,139,145,146,148,169,172,175'
	
	/*

	Update OITM set U_Ruta = '100,106,109,112,115,118,121,124,127,130,133,136,139,145,146,148,169,172,175'
	Where OITM.U_TipoMat = 'PT' and OITM.ItmsGrpCod = 118
	and OITM.U_Ruta <> '100,106,109,112,115,118,121,124,127,130,133,136,139,145,146,148,169,172,175'
	
	*/


--Ruta para PT MESAS (GRUPO 122) -> RUTA: 100,106,109,148,151,154,157,160,169,172,175
	Select '020 RUTA MESAS' AS REPO_020
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_TipoMat AS TM
		--, OITM.U_Ruta AS RUTA
		, OITM.U_GrupoPlanea AS PLANEA
		, OITM.U_Linea AS LINEA
		, OITM.ItmsGrpCod AS GRUPO
	from OITM
	Where OITM.U_TipoMat = 'PT' and OITM.ItmsGrpCod = 122
	and OITM.U_Ruta <> '100,106,109,148,151,154,157,160,169,172,175'
	
	/*

	Update OITM set U_Ruta = '100,106,109,148,151,154,157,160,169,172,175'
	Where OITM.U_TipoMat = 'PT' and OITM.ItmsGrpCod = 122
	and OITM.U_Ruta <> '100,106,109,148,151,154,157,160,169,172,175'

	*/

--Ruta para PT General-> 100,106,109,112,115,118,121,124,127,130,133,136,139,145,146,148,151,154,157,160,169,172,175
						 
	Select '021 RUTA PT' AS REPO_021
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_TipoMat AS TM
		--, OITM.U_Ruta AS RUTA
		, OITM.U_GrupoPlanea AS PLANEA
		, OITM.U_Linea AS LINEA
		, OITM.ItmsGrpCod AS GRUPO
	from OITM
	Where OITM.U_TipoMat = 'PT' and OITM.ItmsGrpCod <> 133 and OITM.ItmsGrpCod <> 118 and OITM.ItmsGrpCod <> 122
	and OITM.U_Ruta <> '100,106,109,112,115,118,121,124,127,130,133,136,139,145,146,148,151,154,157,160,169,172,175'
	
		
	/*

	Update OITM set U_Ruta = '100,106,109,112,115,118,121,124,127,130,133,136,139,145,146,148,151,154,157,160,169,172,175' 
	Where OITM.U_TipoMat = 'PT' and OITM.ItmsGrpCod <> 133 and OITM.ItmsGrpCod <> 118 and OITM.ItmsGrpCod <> 122
	and OITM.U_Ruta <> '100,106,109,112,115,118,121,124,127,130,133,136,139,145,146,148,151,154,157,160,169,172,175'
	

	*/

/*=====================================================================================================================
|              Ruta de Obligarotias para Producto Terminado.                                                          |
=======================================================================================================================
*/
-- Ruta sin 100 Planeacion	
	Select '031 RUTA SIN 100' AS REPORTE_31
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_TipoMat AS TM
		, OITM.U_Ruta AS RUTA
	from OITM
	Where OITM.U_TipoMat='PT' and OITM.U_Ruta NOT LIKE '%100%'
	
-- Ruta sin 106	Almacen de Materias Primas.
	Select '033 RUTA SIN 106' AS REPORTE_33, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.U_TipoMat='PT' and OITM.U_Ruta NOT LIKE '%106%'
	Order By OITM.ItemCode
	
-- Ruta sin 109	Inicio del Produccion, Anaquel de Piel.
	Select '035 RUTA SIN 109' AS REPORTE_035, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.U_TipoMat='PT' and OITM.U_Ruta NOT LIKE '%109%' and OITM.frozenFor = 'N'
	Order By OITM.ItemCode
	
-- Ruta sin 148	Almacen de Partes o Terminado.
	Select '037 RUTA SIN 148' AS REPORTE_037, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.U_TipoMat='PT' and OITM.U_Ruta NOT LIKE '%148%' and OITM.frozenFor = 'N'
	Order By OITM.ItemCode

-- Ruta sin 172	Proceso de Empaque.
	Select '039 RUTA SIN 172' AS REPORTE_039, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.U_TipoMat='PT' and OITM.U_Ruta NOT LIKE '%172%' and OITM.frozenFor = 'N'
	Order By OITM.ItemCode

-- Ruta sin 175	Generacion del Recibo de Produccion.
	Select '041 RUTA SIN 175' AS REPORTE_041, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where OITM.U_TipoMat='PT' and OITM.U_Ruta NOT LIKE '%175%' and OITM.frozenFor = 'N'
	Order By OITM.ItemCode

/*=================================================================================================
|              Rutas con Estaciones No Autorizadas.                                     	       |
===================================================================================================
*/
-- Rutas con Estaciones No Autorizadas 103 Activar Orden en Area.	
	Select '045 CON 103' AS REPORTE_45, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%103%'
	
-- Rutas con Estaciones No Autorizadas 110 Corte de Complementos.	
	Select '046 CON 110' AS REPORTE_46, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%110%'
	Order By OITM.ItemCode

-- Rutas con Estaciones No Autorizadas 111 Costura de Mantas.	
	Select '047 CON 111' AS REPORTE_47, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%111%'
	Order By OITM.ItemCode
	
-- Rutas con Estaciones No Autorizadas 140 Pegado de Delcron.	
	Select '048 CON 140' AS REPORTE_48, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%140%'
	Order By OITM.ItemCode

-- Rutas con Estaciones No Autorizadas 142 Llenado del Cojin.	
	Select '049 CON 142' AS REPORTE_49, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%142%'
	Order By OITM.ItemCode

	-- Rutas con Estaciones No Autorizadas 163 SUB-HERRAJES	
	Select '051 CON 163' AS REPO_51, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%163%'
	Order By OITM.ItemCode

	-- Rutas con Estaciones No Autorizadas 166 SUB-PATAS, BASTIDORES
	Select '053 CON 166' AS REPO_53, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%166%'
	Order By OITM.ItemCode

	-- Rutas con Estaciones No Autorizadas 169 Inspeccion Tapiceria	
	-- Solicito Eduardo Belis que se habra esta Inspeccion 251120
	/*
	Select '055 CON 169' AS REPO_55, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%169%'
	Order By OITM.ItemCode
	*/

	-- Rutas con Estaciones No Autorizadas 312 Inspección y Conteo	
	Select '057 CON 312' AS REPO_57, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%312%'
	Order By OITM.ItemCode

	-- Rutas con Estaciones No Autorizadas 412 Preparado de Casco/Acentado	
	Select '059 CON 412' AS REPO_59, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%412%'
	Order By OITM.ItemCode

	
	-- Rutas con Estaciones No Autorizadas 203 --	
	Select '061 CON 203' AS REPO_61, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%203%'
	Order By OITM.ItemCode

	-- Rutas con Estaciones No Autorizadas 215 --	
	Select '063 CON 215' AS REPO_63, OITM.ItemCode, OITM.ItemName, OITM.U_Ruta
	from OITM
	Where  OITM.U_Ruta LIKE '%215%'
	Order By OITM.ItemCode


/*=====================================================================================================================
|              Ruta de Orden de Produccion debe estar igual a la del Articulo.                                        |
=======================================================================================================================
*/

	Select '065 RUTA OP <> ART' AS REPO_065
		, OWOR.DocEntry AS OP
		, OWOR.Status AS ESTATUS
		, OWOR.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_Ruta AS RUTA_OP
	From OWOR
	Inner Join OITM on OWOR.ItemCode = OITM.ItemCode
	Where OITM.U_Ruta <> OWOR.U_Ruta  
	and OWOR.Status <>'C' and OWOR.Status <> 'L'
	Order By ESTATUS, OP

	/*	

	Update OWOR set OWOR.U_Ruta = OITM.U_Ruta
	From OWOR
	Inner Join OITM on OWOR.ItemCode = OITM.ItemCode
	Where OITM.U_Ruta <> OWOR.U_Ruta  
	and OWOR.Status <>'C' and OWOR.Status <> 'L'

	*/

--< EOF > EXCEPCIONES DE RUTAS DE FABRICACION.

