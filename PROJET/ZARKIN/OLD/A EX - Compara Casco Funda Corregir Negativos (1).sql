/* Consulta para Correccion de Negativos en el Reporte de Compara Casco
algo pasa que no captura la cantidad recibida */
	update [@CP_OF] set U_Comentarios=' ', U_CTCalidad=0 where  Code = 489920
	update [@CP_OF] set U_DocEntry = 61384 where Code=428928
	update [@CP_OF] set U_Entregado = 1, U_Procesado = 1 where Code = 25295
	update [@CP_OF] set U_Recibido=50 where Code=21481
	update [@CP_OF] set U_DocEntry = 3249 where Code = 3878
	update [@CP_OF] set U_CT = 315, U_Orden = 315 where U_DocEntry = 32
	
	update [@CP_OF] set U_CT = 175, U_Orden = 175 where Code = 38049
	delete [@CP_OF] where Code = 27820
	update [@CP_OF] set U_Recibido= 7 where Code= 47395
--  ------------------------------------------------------------------------------------
-- Revision del Historial de la Orden.  
	DECLARE @NumOrd as int
	Set @NumOrd = 3269
	select OWOR.Status, CP.* from [@CP_OF] CP inner join OWOR on CP.U_DocEntry=OWOR.DocNum 
	where U_DocEntry = @NumOrd ORDER BY U_CT
	Select * from [@CP_LOGOT] where U_OP=@NumOrd  order by U_CT
	select HIS.U_idEmpleado, HIS.U_CT, SUM(HIS.U_Cantidad) as PROD --, DATEPART(WK, HIS.U_FechaHora) as SEMANA
	from [@CP_LOGOF] HIS where HIS.U_DocEntry = @NumOrd 
	Group by HIS.U_idEmpleado, HIS.U_CT order by HIS.U_CT 
 
---------------------------------------------------------------------------------

--select DISTINCT CP.U_DocEntry 
Select *
from [@CP_OF] CP 
left join [@CP_LOGOF] TE on CP.U_DocEntry = TE.U_DocEntry --and TE.U_CT = 418
where CP.U_CT is null and TE.U_CT > 318

-- ---------------------------------------------------------------------------------
-- delete [@CP_OF] where U_DocEntry = 63824
-- delete [@CP_LOGOT] where U_OP=63824 and U_CT >=121
-- delete [@CP_LOGOF] where U_DocEntry=68683

update [@CP_LOGOF] set U_CT=3
where Code=494595 

update [@CP_OF] set U_Recibido=1 where Code=291268 
update [@CP_OF] set U_CT=17 where Code=278199 
update [@CP_OF] set U_Orden=17 where Code=278199 


-- Para la Tabla de Inicializar Ordenes

select * from [@CP_LOGOT] where U_OP=78832 and U_CT > 109 order by U_CT

 --update [@CP_LOGOT] set U_OP = 77777 where U_OP=61022 and U_CT > 145 
 --delete [@CP_LOGOT] where U_OP=73667 and U_CT > 109


	-- Para la Tabla de Produccion terminadas.
	select * from [@CP_LOGOF] where U_DocEntry= 4012 -- and U_CT = 115 
	order by U_FechaHora

	-- Para cambiar el numero de un empleado
	update [@CP_LOGOF] set U_idEmpleado = 16  where U_DocEntry= 6242 and U_CT = 115 
	

	--update [@CP_LOGOF] set U_idEmpleado = 98 where Code = 75878
	
	--update [@CP_LOGOF] set U_DocEntry = 1561  where U_DocEntry= 61022 and U_CT >145

--delete [@CP_LOGOF] where  U_DocEntry= 4138 and U_CT > 106 

-- delete [@CP_LOGOF] where Code = 28404
--delete [@CP_LOGOF] where U_DocEntry= 77777
--delete [@CP_LOGOT] where U_OP=51022 

--delete [@CP_LOGOF] where U_DocEntry=50138 and Code=424093 
--delete [@CP_LOGOT] where U_OP=50138 and Code = 260837

--delete [@CP_LOGOF] where U_DocEntry=50138 and Code=424094
--delete [@CP_LOGOT] where U_OP=50138 and Code = 260838

select U_CT, U_DocEntry, SUM(U_Cantidad) as Cant
from [@CP_LOGOF]
where U_DocEntry=47873
group by U_CT, U_DocEntry


/* Para corregir la cantidad entregada en OF */

update [@CP_OF] set U_Recibido=30 where Code=220668 and U_DocEntry=47873

/* Para quitar un registro mal aplicado se borran en las tres tablas el movimiento. */

delete [@CP_OF] where  U_DocEntry=54967 and Code=282934

delete [@CP_LOGOF] where U_DocEntry=50151 and Code=409674 
delete [@CP_LOGOT] where U_OP=50151 and Code = 250821

	/* PARA MOVER UNA ORDEN A UN PROCESO ANTERIOR 
	/*Señalar en que proceso es en el que esta, ejemplo 17 en Tapiceria.*/
	update [@CP_OF] set U_CT=17 where U_DocEntry=5721
	update [@CP_OF] set U_Orden=17 where U_DocEntry=5721
	
	/*Borra de LOGOF los registros arriba de la estacion a dejar la orden. 
	select * from [@CP_LOGOF] where U_DocEntry=5870 and U_CT > 12 */
	delete [@CP_LOGOF] where U_DocEntry=5721 and U_CT > 12

	/*Borra de LOGOT los registros arriba de la estacion a dejar la orden.
	select * from [@CP_LOGOT] where U_OP=5870 and U_CT > 12 */
	delete [@CP_LOGOT] where U_OP=5721 and U_CT > 12  */



-- Buscar por el modelo que ordenes son las que puedan ser las equivocadas.
	select * from OWOR where ItemCode='346417' and OWOR.Status='R'

-- Con la Orden de Produccion se valida que movimiento quedo incompleto en 
--la parte de U_Recibido
	select * from [@CP_OF] where U_Defectuoso <> 0 

-- Se captura la cantidad recibida que debio haber tenido.
/*
update [@CP_OF] set U_Recibido=1 where Code=295946 

update [@CP_OF] set U_CT=17 where Code=229658 and U_DocEntry=48784


delete [@CP_LOGOF] where U_DocEntry=48784 and Code=370253
delete [@CP_LOGOF] where U_DocEntry=48784 and Code=370256
delete [@CP_LOGOT] where U_OP=54967 and Code = 287161
delete [@CP_LOGOT] where U_OP=48784 and Code = 232596


update [@CP_OF] set U_Orden=15 where Code=230696 and U_DocEntry=50121

-- Borrar registro duplicado.
delete [@CP_OF] where code=220727

delete [@CP_OF] where code=141679
delete [@CP_OF] where code=77554
delete [@CP_OF] where code=77556
delete [@CP_OF] where code=56169
delete [@CP_OF] where code=56185
delete [@CP_OF] where code=56204
*/
/*    update [@CP_OF] set U_CT=22 where U_DocEntry=48784    */

SELECT MAX(CONVERT(INT,CODE))+1 as Sig_LOGOT FROM [@CP_LOGOT] 
SELECT MAX(CONVERT(INT,CODE))+1 as Sig_LOGOF FROM [@CP_LOGOF]  













/*  Hacer compara casco mediante limite del numero del programa */
/*
SELECT MODELO, NomModelo , Code, ItemName,
(SELECT TOP 1 U_VS FROM OITM WHERE LEFT(ItemCode,7)=MODELO ) AS VS , SUM(Fundas) AS FUNDAS,
(SUM(INVENTARIO)+ SUM(CASCOS)) AS CASCOS,
CASE WHEN SUM(FUNDAS)<=(SUM(INVENTARIO)+SUM(CASCOS)) THEN SUM(FUNDAS) ELSE (SUM(INVENTARIO)+SUM(CASCOS)) END AS FUNDASCCASC,
CASE WHEN (SUM(INVENTARIO)+SUM(CASCOS))-SUM(Fundas)>0 THEN (SUM(INVENTARIO)+SUM(CASCOS))-SUM(Fundas) ELSE 0 END AS CASCOSSFUNDA,
CASE WHEN SUM(Fundas)-(SUM(INVENTARIO)+SUM(CASCOS)) >0 THEN SUM(Fundas)-(SUM(INVENTARIO)+SUM(CASCOS)) ELSE 0 END AS FUNDASSCASCO 
from ( select Vw_SimilarControl005.MODELO ,  Vw_SimilarControl005.NomModelo  ,
ITT1.Code,OITM.ItemName, SUM(Vw_SimilarControl005.Cantidad) AS Fundas, 0 AS INVENTARIO, 0 AS CASCOS
from Vw_SimilarControl005
inner join ITT1 on ITT1.Father = Vw_SimilarControl005.CODIGO_ARTICULO
inner join OITM on OITM.ItemCode = ITT1.Code
where OITM.QryGroup29 = 'Y' and (oitm.ItemName not like 'PATA%' and
oitm.ItemName not like '%PATA%' and oitm.ItemName not like '%PATA') and
Vw_SimilarControl005.SEMANA2<343
GROUP BY  ITT1.Code,OITM.ItemName, Vw_SimilarControl005.MODELO , Vw_SimilarControl005.NomModelo

Union ALL 

select LEFT(OITW.itemcode,4) + '-' + SUBSTRING (OITW.ItemCode,5,2) as modelo,
(SELECT ITEMNAME 
FROM OITM 
WHERE ITEMCODE= LEFT(OITW.ITEMCODE,4)) AS NOMMODELO,OITW.ItemCode, OITM.ItemName, 0 as Fundas  ,
sum(OITW.OnHand ) as INVENTARIO, 0 AS CASCOS
from OITW inner join OITM on OITM.ItemCode = OITW.ItemCode
where OITM.QryGroup29 = 'Y' and (oitm.ItemName not like 'PATA%' and 
oitm.ItemName not like '%PATA%' and oitm.ItemName not like '%PATA')
group by OITW.ItemCode, OITM.ItemName

Union ALL

SELECT LEFT(OWOR.itemcode,4) + '-' + SUBSTRING (OWOR.ItemCode,5,2) as modelo,
(SELECT ITEMNAME 
FROM OITM 
WHERE ITEMCODE= LEFT(OWOR.ITEMCODE,4)) AS NOMMODELO, OWOR.ItemCode , OITM.ItemName  , 0 AS FUNDAS,
0 AS INVENTARIO, SUM(OWOR.PlannedQty- OWOR.CmpltQty  ) AS CASCOS 
from OWOR inner join OITM on OITM.ItemCode = OWOR.ItemCode where OITM.QryGroup29 = 'Y' and OWOR.Status = 'R' and (oitm.ItemName not like 'PATA%' and oitm.ItemName not like '%PATA%' and oitm.ItemName not like '%PATA') GROUP BY OWOR.ItemCode, OITM.ItemName ) CASCOS where Fundas > 0 Or INVENTARIO > 0 Or CASCOS > 0 GROUP BY MODELO, NomModelo , Code, ItemName ORDER BY NomModelo ASC 


*/