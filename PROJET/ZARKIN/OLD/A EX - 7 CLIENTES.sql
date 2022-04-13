/* EXCEPCIONES DE PROVEEDORES SOLO PROVEEDORES ACTIVOS (frozenfor <> 'Y') */

-- Provedores sin lista de compras o equivocada.
	Select '004 ! SIN LISTA A-COMPRAS CORREGIDO' AS REPORTE, OCRD.CardCode, OCRD.CardName, OCRD.CardType, OCRD.GroupCode, OCRD.ListNum
	from OCRD
	Where OCRD.CardType = 'S' and OCRD.ListNum <> 9

	Select '004 ! SIN LISTA A-COMPRAS CORREGIDO' AS REPORTE, OCRD.CardCode, OCRD.CardName, OCRD.CardType, OCRD.GroupCode, OCRD.ListNum
	from OCRD
	Where OCRD.CardType = 'S' and OCRD.ListNum IS NULL

	update OCRD set OCRD.ListNum = 9
	Where OCRD.CardType = 'S' and OCRD.ListNum <> 9
	
-- Provedores sin lista de compras o equivocada.
	Select '006 ! SIN LISTA A-VENTAS' AS REPORTE, OCRD.CardCode, OCRD.CardName, OCRD.CardType, OCRD.GroupCode, OCRD.ListNum
	from OCRD
	Where OCRD.CardType = 'C' and OCRD.ListNum <> 2

	
	update OCRD set OCRD.ListNum = 2
	Where OCRD.CardType = 'C' and OCRD.ListNum <> 2
	


/* EXCEPCIONES DE CLIENTES */

-- Clientes sin numero de Cuenta Contable.
	--QUE CLAUDIA CONTROLA ESTO CON SU GENTE, NO REPORTAR.
	--Select '012 CLIENTE SIN C.C.' AS REPORTE, OCRD.CardCode, OCRD.CardName, OCRD.CardType, OCRD.U_Cuenta
	--from OCRD
	--where OCRD.CardType='C' and OCRD.U_Cuenta is null 
	
/* Clientes sin Canal de Distribucion asignado, considerado como Clientes, solicitar a ventas que 
	cambie a un canal adecuado.*/
		Select '011 ? CLIENTE SIN CANAL' AS REPORTE, OCRD.CardCode,  OCRD.CardType, OCRD.CardName, OCRD.GroupCode, OCRG.GroupName
		from OCRD 
		inner join OCRG on OCRD.GroupCode=OCRG.GroupCode
		where OCRD.GroupCode= '100' and OCRD.CardType <> 'L'
		
-- Poner Datos de Codigo Postal Autorizados por el SAT.
	--Select '029	? MODIFICA C.P. AUT. SAT' AS REPORTE, OCRD.CardCode, OCRD.CardType, OCRD.CardName,
	--OCRD.U_CP,
	--(Select top 1 CRD1.ZipCode from CRD1 where CRD1.CardCode = OCRD.CardCode) AS ZIP,
	--OCRD.GroupCode, OCRD.U_CP, OCRD.U_Municipio, OCRD.U_Estado, OCRD.U_Pais
	--From OCRD
	--where (Select top 1 CRD1.ZipCode from CRD1 where CRD1.CardCode = OCRD.CardCode) <> OCRD.U_CP 
	
	--Select '036	? U_CP NULO' AS REPORTE, OCRD.CardCode, OCRD.CardType, OCRD.CardName,
	--OCRD.U_CP,
	--(Select top 1 CRD1.ZipCode from CRD1 where CRD1.CardCode = OCRD.CardCode) AS ZIP,
	--OCRD.GroupCode, OCRD.U_CP, OCRD.U_Municipio, OCRD.U_Estado, OCRD.U_Pais
	--From OCRD
	--where OCRD.U_CP is null 
	
	--Select '043	? U_CP VACIO' AS REPORTE, OCRD.CardCode, OCRD.CardType, OCRD.CardName,
	--OCRD.U_CP,
	--(Select top 1 CRD1.ZipCode from CRD1 where CRD1.CardCode = OCRD.CardCode) AS ZIP,
	--OCRD.GroupCode, OCRD.U_CP, OCRD.U_Municipio, OCRD.U_Estado, OCRD.U_Pais
	--From OCRD
	--where (OCRD.U_CP = '' OR OCRD.U_CP is null)
	--order by (Select top 1 CRD1.ZipCode from CRD1 where CRD1.CardCode = OCRD.CardCode)
			 
-- Fin del Archivo Excepciones de Socios de Negocios. 