/* Consulta para Correccion de Negativos en el Reporte de Compara Casco
algo pasa que no captura la cantidad recibida */
	update [@CP_OF] set U_Comentarios=' ', U_CTCalidad=0 where  Code = 489920
	update [@CP_OF] set U_DocEntry = 61384 where Code=428928
	
	update [@CP_OF] set U_Recibido=50 where Code=21481
	
	update [@CP_OF] set U_CT = 17787, U_Orden = 17787 where Code = 2528
	
	update [@CP_OF] set U_Entregado = 6, U_Procesado = 6 where Code = 234032

	update [@CP_OF] set U_Entregado = 3, U_Procesado = 3 where Code = 399822
	update [@CP_OF] set U_Recibido= 1 where Code= 23199

	delete [@CP_OF] where Code = 636373
	delete [@CP_OF] where Code = 388704
	delete [@CP_OF] where Code = 388705
	delete [@CP_OF] where Code = 388700
	delete [@CP_OF] where Code = 506616


-- Para asignar un nuevo codigo, primero ver que no exista

Select * from [@CP_OF] CP  Where Name > 163132  and Name < 163140 Order by Code DESC

Select * from [@CP_OF] CP  Where Name = 163134

	update [@CP_OF] set Code = 163134, Name = 163134 where Code = 2630 

-- 17/Noviembre/2023
update [@CP_OF] set U_DocEntry = 77  where Code=491315
-- Pongo esto como OP 77 por si necesito regresarlos al Docentry = 39917


-- Para poner un registro que se perdio en OF
-- Usamos estos codigo que no se han borrado.
Select Top(20) CP.Code, CP.U_DocEntry, OP.ItemCode, A3.ItemName, OP.Status 
from [@CP_OF] CP inner join OWOR OP on CP.U_DocEntry= OP.DocEntry 
inner join OITM A3 on OP.ItemCode = A3.ItemCode where OP.Status = 'C' 
ORDER BY CP.U_DocEntry

-- La estacion ultima en el historial, se pone la que sigue en ruta, entregado y procesado 0 cuando 
--solo es una pieza y recibido en 1

	update [@CP_OF] set U_DocEntry = 54053  where Code=72952
	update [@CP_OF] set U_CT = 136, U_Orden = 136 where Code = 72952
	update [@CP_OF] set U_Entregado = 0, U_Procesado = 0 where Code = 72952
	update [@CP_OF] set U_Recibido= 233 where Code= 72952


	update [@CP_OF] set U_DocEntry = 41826, U_CT = 109, U_Orden = 109, U_Entregado = 0, U_Procesado = 0, U_Recibido= 1 where Code= 75787
		delete [@CP_OF] where Code = 767709

--  ------------------------------------------------------------------------------------
-- Revision del Historial de la Orden.  
	DECLARE @NumOrd as int
	Set @NumOrd = 66587 
	select OWOR.Status AS ESTAT_CP_OF, CP.* from [@CP_OF] CP inner join OWOR on CP.U_DocEntry=OWOR.DocNum 
	where U_DocEntry = @NumOrd ORDER BY U_CT,Code
	--Select * from [@CP_LOGOT] where U_OP=@NumOrd  order by U_CT
	select HIS.U_CT, SUM(HIS.U_Cantidad) as PROD , HIS.U_idEmpleado --, DATEPART(WK, HIS.U_FechaHora) as SEMANA
	from [@CP_LOGOF] HIS where HIS.U_DocEntry = @NumOrd 
	Group by  HIS.U_CT , HIS.U_idEmpleado 
	order by HIS.U_CT
---------------------------------------------------------------------------------
-- CORREGIR REGISTROS EN TABLA DE TERMINADOS LOGOF.

	select * from [@CP_LOGOF] where U_DocEntry= 65099 --and U_CT = 175   -- and U_idEmpleado = 2 -- and U_CT = 415  
	order by  U_FechaHora, U_CT
	 
	-- Para cambiar el numero de un empleado
	-- Usuario 6.- Virtual Costura (83)

	update [@CP_LOGOF] set U_idEmpleado = 298 Where Code = 795761
	update [@CP_LOGOF] set U_idEmpleado = 374 Where Code = 782525

	   	

	update [@CP_LOGOF] set U_FechaHora = '2024-11-30 14:27:00.000'  Where Code = 693252
	2024-11-30 14:27:00.000

DELETE [@CP_LOGOF] WHERE Code = 781888


DELETE [@CP_LOGOF] WHERE Code = 603594

DELETE [@CP_LOGOF] WHERE Code = 495333

DELETE [@CP_LOGOF] WHERE Code = 662140
DELETE [@CP_LOGOF] WHERE Code = 474695
DELETE [@CP_LOGOF] WHERE Code = 474696
DELETE [@CP_LOGOF] WHERE Code = 474697
DELETE [@CP_LOGOF] WHERE Code = 474698
DELETE [@CP_LOGOF] WHERE Code = 474699
DELETE [@CP_LOGOF] WHERE Code = 474700
DELETE [@CP_LOGOF] WHERE Code = 474701
DELETE [@CP_LOGOF] WHERE Code = 474702
DELETE [@CP_LOGOF] WHERE Code = 474703


update [@CP_LOGOF] set U_Cantidad = 5 Where Code = 766653


--De la OP 36994 se borraron estos renglones que no fueron reales 18 de Agosto 2023.
--454761	454761	68	160	T	2023-08-11 14:09:00.000	36994	1	N
--454764	454764	85	172	T	2023-08-11 14:10:00.000	36994	1	N
--454765	454765	267	175	T	2023-08-11 14:12:24.000	36994	1	N

DELETE [@CP_LOGOF] WHERE Code = 454761
DELETE [@CP_LOGOF] WHERE Code = 454764
DELETE [@CP_LOGOF] WHERE Code = 454765


De la OP 36995 se borraron estos renglones que no fueron reales 18 de Agosto 2023.
454762	454762	68	160	T	2023-08-11 14:09:00.000	36995	1	N
454763	454763	85	172	T	2023-08-11 14:10:00.000	36995	1	N
454766	454766	267	175	T	2023-08-11 14:12:43.000	36995	1	N

DELETE [@CP_LOGOF] WHERE Code = 454762
DELETE [@CP_LOGOF] WHERE Code = 454763
DELETE [@CP_LOGOF] WHERE Code = 454766
	
---------------------------------------------------------------------------------
	-- Ordenes que se Cancelaron y no se Borro de Control de Piso.
	-- Se pueden usar los codigos para asignar a otro que se haya borrado.
	Select CP.Code, CP.U_DocEntry, OP.ItemCode, A3.ItemName, OP.Status 
	from [@CP_OF] CP inner join OWOR OP on CP.U_DocEntry= OP.DocEntry 
	inner join OITM A3 on OP.ItemCode = A3.ItemCode where OP.Status = 'C' 
	ORDER BY CP.U_DocEntry









---------------------------------------------------------------------------------

	
	-- Para modificar la cantidad Fabricada
	update [@CP_LOGOF] set U_Cantidad = 1 where Code = 252738

	delete [@CP_LOGOF] where Code = 673605

	

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

select * from [@CP_LOGOT] where U_OP=10208 --and U_CT > 109 order by U_CT

 --update [@CP_LOGOT] set U_OP = 77777 where U_OP=61022 and U_CT > 145 
 --delete [@CP_LOGOT] where U_OP=73667 and U_CT > 109
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

--update [@CP_OF] set U_Recibido=30 where Code=220668 and U_DocEntry=47873

/* Para quitar un registro mal aplicado se borran en las tres tablas el movimiento. */

--delete [@CP_OF] where  U_DocEntry=54967 and Code=282934
--delete [@CP_LOGOF] where U_DocEntry=50151 and Code=409674 
--delete [@CP_LOGOT] where U_OP=50151 and Code = 250821

	/* PARA MOVER UNA ORDEN A UN PROCESO ANTERIOR 
	/*Se�alar en que proceso es en el que esta, ejemplo 17 en Tapiceria.*/
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