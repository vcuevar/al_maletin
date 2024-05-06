-- R134 Reporte de destajos.
-- ID: 220203-1
-- Desarrollo: Ing. Vicente Cueva Ramírez.
-- Actualizado: Viernes 03 de Febrero del 2023; Origen.
-- Actualizado: Lunes 13 de Marzo del 2023; Agregar Telas a 140 por metros.
-- Actualizado: Lunes 10 de Abril del 2023; Dejar solo Tela cuando no hay consumo de Piel, Elias.


-- NOTA: En la macro la hojas PARAMETROS tiene clave de edicion VMA2023


-- Parametros Fecha Inicial y Final
Declare @FechaIS date
Declare @FechaFS date
Declare @EstaTra integer
Declare @Modelo VarChar(5)

Set @FechaIS = CONVERT(DATE, '2023-03-27', 102)
Set @FechaFS = CONVERT(DATE, '2023-04-02', 102)
Set @EstaTra = 112
Set @Modelo = '3841'

-- Relacion de Estaciones de Trabajo:

-- Select RT.Code, RT.Name, RT.U_Calidad from [@PL_RUTAS] RT 


-- Produccion con Valores para cualquier area
Select CAST(CP.U_FechaHora as DATE) as FECHA
	, DATEPART(weekday, CP.U_FechaHora) AS DIA
	, DATEPART(iso_week, CP.U_FechaHora) AS SEMANA
	, RH.U_EmpGiro AS NUM_NOM
	, RH.firstName + ' ' + RH.lastName AS EMPLEADO
	, OP.DocEntry AS OP
	, OP.ItemCode AS CODIGO
	, A3.ItemName AS MUEBLE
	, CP.U_Cantidad AS CANTIDAD
	, A3.U_VS * CP.U_Cantidad AS V_SALA

	, ISNULL((Select  SUM(ITT1.Quantity)  from ITT1
		Inner Join OITM A1 on ITT1.Code = A1.ItemCode and A1.ItmsGrpCod = '113'
		Where ITT1.Father = OP.ItemCode),
		ISNULL((Select  SUM(ITT1.Quantity) * 140 from ITT1
		Inner Join OITM A1 on ITT1.Code = A1.ItemCode and A1.ItmsGrpCod = '114' and A1.U_GrupoPlanea = '11'
		Where ITT1.Father = OP.ItemCode),0)) AS PIEL_TEORICO
			
	, ISNULL(SG.GPO_157, 'NA') AS GRUPO_157
	, ISNULL(SG.GPO_160, 'NA') AS GRUPO_160 
from OWOR OP 
inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry 
inner join OHEM RH on CP.U_idEmpleado=RH.empID 
inner join OITM A3 on OP.ItemCode=A3.ItemCode 
left join SIZ_DestGrupo SG on SUBSTRING(OP.ItemCode,1,7) = SG.CODE01 
Where  CAST (CP.U_FechaHora as Date) Between @FechaIS and @FechaFS and CP.U_CT= @EstaTra 
Order by RH.firstName, RH.lastName, CAST(CP.U_FechaHora as DATE), OP.DocEntry

/*
Se quito tela Elias dijo que siempre no. La tela cuando no es cero la piel.

, ISNULL((Select  SUM(ITT1.Quantity) from ITT1
		Inner Join OITM A1 on ITT1.Code = A1.ItemCode and A1.ItmsGrpCod = '113' 
		Where ITT1.Father = OP.ItemCode),0) AS PIEL_TEORICO
--+
		--ISNULL((Select  SUM(ITT1.Quantity) * 140 from ITT1
		--Inner Join OITM A1 on ITT1.Code = A1.ItemCode and A1.ItmsGrpCod = '114' and A1.U_GrupoPlanea = '11'
		--Where ITT1.Father = OP.ItemCode),0) AS PIEL_TEORICO

sI PIEL ES CERO ENTONCES 
	, ISNULL((Select  SUM(ITT1.Quantity)  from ITT1
		Inner Join OITM A1 on ITT1.Code = A1.ItemCode and A1.ItmsGrpCod = '113'
		Where ITT1.Father = OP.ItemCode),
		ISNULL((Select  SUM(ITT1.Quantity) * 140 from ITT1
		Inner Join OITM A1 on ITT1.Code = A1.ItemCode and A1.ItmsGrpCod = '114' and A1.U_GrupoPlanea = '11'
		Where ITT1.Father = OP.ItemCode),0)) AS PIEL_TEORICO
		*/

-- Para reportes de Corte de Piel Unidad Decimetros y Tambien para los de Valor Sala.
Select DEST.NUM_NOM AS NUM_NOM
	, DEST.EMPLEADO AS EMPLEADO
	, SUM(DEST.V_SALA) AS V_SALA
	, SUM(DEST.PIEL_TEORICO) AS PIEL_TEORICO
From (
Select CAST(CP.U_FechaHora as DATE) as FECHA
	, DATEPART(weekday, CP.U_FechaHora) AS DIA
	, DATEPART(iso_week, CP.U_FechaHora) AS SEMANA
	, RH.U_EmpGiro AS NUM_NOM
	, RH.firstName + ' ' + RH.lastName AS EMPLEADO
	, OP.DocEntry AS OP
	, OP.ItemCode AS CODIGO
	, A3.ItemName AS MUEBLE
	, CP.U_Cantidad AS CANTIDAD
	, A3.U_VS * CP.U_Cantidad AS V_SALA

	, ISNULL((Select  SUM(ITT1.Quantity)  from ITT1
		Inner Join OITM A1 on ITT1.Code = A1.ItemCode and A1.ItmsGrpCod = '113'
		Where ITT1.Father = OP.ItemCode),
		ISNULL((Select  SUM(ITT1.Quantity) * 140 from ITT1
		Inner Join OITM A1 on ITT1.Code = A1.ItemCode and A1.ItmsGrpCod = '114' and A1.U_GrupoPlanea = '11'
		Where ITT1.Father = OP.ItemCode),0)) AS PIEL_TEORICO

	, ISNULL(SG.GPO_157, 'NA') AS GRUPO_157
	, ISNULL(SG.GPO_160, 'NA') AS GRUPO_160 
from OWOR OP 
inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry 
inner join OHEM RH on CP.U_idEmpleado=RH.empID 
inner join OITM A3 on OP.ItemCode=A3.ItemCode 
left join SIZ_DestGrupo SG on SUBSTRING(OP.ItemCode,1,7) = SG.CODE01 
Where  CAST (CP.U_FechaHora as Date) Between @FechaIS and @FechaFS and CP.U_CT= @EstaTra 
) DEST
Group by DEST.NUM_NOM, DEST.EMPLEADO
Order by DEST.EMPLEADO



/*
-- Para realizar con grupos de muebles.
Select DEST.NUM_NOM AS NUM_NOM
	, DEST.EMPLEADO AS EMPLEADO
	, SUM(DEST.GPO_A) AS VS_A
	, SUM(DEST.GPO_B) AS VS_B
	, SUM(DEST.GPO_C) AS VS_C
	, SUM(DEST.GPO_NA) AS VS_NA
From (

Select RH.U_EmpGiro AS NUM_NOM
	, RH.firstName + ' ' + RH.lastName AS EMPLEADO
	, Case When SG.GPO_157 = 'A' then SUM(A3.U_VS * CP.U_Cantidad) Else 0 End AS GPO_A
	, Case When SG.GPO_157 = 'B' then SUM(A3.U_VS * CP.U_Cantidad) Else 0 End AS GPO_B
	, Case When SG.GPO_157 = 'C' then SUM(A3.U_VS * CP.U_Cantidad) Else 0 End AS GPO_C
	, Case When SG.GPO_157 IS NULL then SUM(A3.U_VS * CP.U_Cantidad) Else 0 End AS GPO_NA
from OWOR OP 
inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry 
inner join OHEM RH on CP.U_idEmpleado=RH.empID 
inner join OITM A3 on OP.ItemCode=A3.ItemCode 
left join SIZ_DestGrupo SG on SUBSTRING(OP.ItemCode,1,7) = SG.CODE01 
Where  CAST (CP.U_FechaHora as Date) Between @FechaIS and @FechaFS and CP.U_CT= @EstaTra 
Group By RH.U_EmpGiro, RH.firstName, RH.lastName, SG.GPO_157 
) DEST
Group by DEST.NUM_NOM, DEST.EMPLEADO
Order by DEST.EMPLEADO
*/

/*
Select DEST.NUM_NOM AS NUM_NOM, DEST.EMPLEADO AS EMPLEADO, SUM(DEST.GPO_A) AS VS_A, SUM(DEST.GPO_B) AS VS_B, SUM(DEST.GPO_C) AS VS_C, SUM(DEST.GPO_NA) AS VS_NA From (Select RH.U_EmpGiro AS NUM_NOM, RH.firstName + ' ' + RH.lastName AS EMPLEADO, Case When SG.GPO_157 = 'A' then SUM(A3.U_VS * CP.U_Cantidad) Else 0 End AS GPO_A, Case When SG.GPO_157 = 'B' then SUM(A3.U_VS * CP.U_Cantidad) Else 0 End AS GPO_B, Case When SG.GPO_157 = 'C' then SUM(A3.U_VS * CP.U_Cantidad) Else 0 End AS GPO_C, Case When SG.GPO_157 IS NULL then SUM(A3.U_VS * CP.U_Cantidad) Else 0 End AS GPO_NA from OWOR OP inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry inner join OHEM RH on CP.U_idEmpleado=RH.empID inner join OITM A3 on OP.ItemCode=A3.ItemCode left join SIZ_DestGrupo SG on SUBSTRING(OP.ItemCode,1,7) = SG.CODE01 
Where  CAST (CP.U_FechaHora as Date) Between '" & FechaIS & "' and '" & FechaFS & "' and CP.U_CT= " & EstaTra & " Group By RH.U_EmpGiro, RH.firstName, RH.lastName, SG.GPO_157) DEST Group by DEST.NUM_NOM, DEST.EMPLEADO Order by DEST.EMPLEADO 


SSQL = "Select DEST.NUM_NOM AS NUM_NOM, DEST.EMPLEADO AS EMPLEADO, SUM(DEST.GPO_A) AS VS_A, SUM(DEST.GPO_B) AS VS_B, SUM(DEST.GPO_C) AS VS_C, SUM(DEST.GPO_NA) AS VS_NA From (Select RH.U_EmpGiro AS NUM_NOM, RH.firstName + ' ' + RH.lastName AS EMPLEADO, Case When SG.GPO_160 = 'A' then SUM(A3.U_VS * CP.U_Cantidad) Else 0 End AS GPO_A, Case When SG.GPO_160 = 'B' then SUM(A3.U_VS * CP.U_Cantidad) Else 0 End AS GPO_B, Case When SG.GPO_160 = 'C' then SUM(A3.U_VS * CP.U_Cantidad) Else 0 End AS GPO_C, Case When SG.GPO_160 IS NULL then SUM(A3.U_VS * CP.U_Cantidad) Else 0 End AS GPO_NA from OWOR OP inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry inner join OHEM RH on CP.U_idEmpleado=RH.empID inner join OITM A3 on OP.ItemCode=A3.ItemCode left join SIZ_DestGrupo SG on SUBSTRING(OP.ItemCode,1,7) = SG.CODE01 " _
& " Where  CAST (CP.U_FechaHora as Date) Between '" & FechaIS & "' and '" & FechaFS & "' and CP.U_CT= " & EstaTra & " Group By RH.U_EmpGiro, RH.firstName, RH.lastName, SG.GPO_160) DEST Group by DEST.NUM_NOM, DEST.EMPLEADO Order by DEST.EMPLEADO "
*/

/*
-- Buscar Modelos para cargar el Grupo.

Select Left(OITM.ItemCode, 7) AS CODIGO
	, OITM.FrgnName  AS MUEBLE
	, ISNULL(SG.GPO_157, 'NA') AS TAPICERIA
	, ISNULL(SG.GPO_160, 'NA') AS ARMADO

From OITM
left join SIZ_DestGrupo SG on SUBSTRING(OITM.ItemCode,1,7) = SG.CODE01 
Where OITM.U_TipoMat = 'PT' and Left(OITM.ItemCode, 4) = @Modelo and OITM.U_IsModel = 'N'
and OITM.InvntItem = 'Y'
Group By Left(OITM.ItemCode, 7), OITM.FrgnName, SG.GPO_157, SG.GPO_160
Order By OITM.FrgnName

--Select Left(OITM.ItemCode, 7) AS CODIGO, OITM.FrgnName  AS MUEBLE, ISNULL(SG.GPO_157, 'NA') AS TAPICERIA, ISNULL(SG.GPO_160, 'NA') AS ARMADO From OITM left join SIZ_DestGrupo SG on SUBSTRING(OITM.ItemCode,1,7) = SG.CODE01 Where OITM.U_TipoMat = 'PT' and Left(OITM.ItemCode, 4) = '" & xModelo & "' and OITM.U_IsModel = 'N' and OITM.InvntItem = 'Y' Group By Left(OITM.ItemCode, 7), OITM.FrgnName, SG.GPO_157, SG.GPO_160 Order By OITM.FrgnName
*/

/*
--Para Insertar un nuevo registro

Declare @Codigo as nvarchar(7)
Declare @Nombre as nvarchar(100)
Declare @G_Tapiz as nvarchar(3)
Declare @G_Armar as nvarchar(3)

Set @Codigo = '3831-43'
Set @Nombre = 'BURANO,  -T- CUILTEADO,'
Set @G_Tapiz = 'A'
Set @G_Armar = 'A'

Insert Into [dbo].SIZ_DestGrupo
			( [CODE01], [MUEBLE], [GPO_157], [GPO_160] )
		Values
			(@Codigo, @Nombre, @G_Tapiz, @G_Armar)
Go

Update SIZ_DestGrupo set MUEBLE = '" & xNombre & "', [GPO_157] = '" & xG_Tapiz & "', GPO_160 = '" & xG_Armar & "' Where CODE01 = '" & xCodigo "'

*/


/*


Select  SUM(ITT1.Quantity) AS PIEL_TEORICO from ITT1
Inner Join OITM A1 on ITT1.Code = A1.ItemCode and A1.ItmsGrpCod = '113'
 Where ITT1.Father = '3874-16-P0302'
*/

/*
-- PRODUCCION POR CORTE DE PIEL

Select  OWOR.DocNum
	, sum(WOR1.IssuedQty) as Usado 
	, OWOR.ItemCode 
	, OHEM.firstName AS LOGISTICA
	, OHEM.middleName AS APELLIDO  
	, (a.u_vs * OWOR.PlannedQty ) as u_vs 
	, OITM.ItmsGrpCod
	, OWOR.closedate  
	, a.itemname 
	, sum(WOR1.IssuedQty*OITM.AvgPrice) as mUsado  
	, (vwsof_pieles1.cantidad * OWOR.PlannedQty) as Teorico 
	, (vwsof_pieles1.monto * OWOR.PlannedQty) as mTeorico
	, SUBSTRING(owor.itemcode,9,5) as piel
	
	, (select TOP 1 OH.firstName 
	from [@CP_LOGOF] LF 
	INNER JOIN OHEM OH ON LF.U_idEmpleado = OH.empID 
	WHERE LF.U_CT = @EstaTra AND LF.U_DocEntry = OWOR.DocNum ) AS firstName
	, LOF.FECHA
	,(select TOP 1 OH.middleName from [@CP_LOGOF] LF 
	INNER JOIN OHEM OH ON LF.U_idEmpleado = OH.empID 
	WHERE LF.U_CT = @EstaTra AND LF.U_DocEntry = OWOR.DocNum ) AS middleName  
from WOR1 
inner join OWOR on OWOR.DocEntry = WOR1.DocEntry 
inner join OITM on OITM.ItemCode = WOR1.ItemCode 
inner join OITM a on a.ItemCode = OWOR.itemcode 
inner join vwSof_Pieles1 on vwSof_Pieles1.father = OWOR.ItemCode 
INNER JOIN (SELECT U_DocEntry , sum(U_Cantidad) as Cantidad, U_idEmpleado
, DATEADD(dd, 0, DATEDIFF(dd, 0, U_FechaHora)) AS FECHA 
FROM [@CP_LOGOF] WHERE U_CT = @EstaTra
group by U_DocEntry , U_idEmpleado, DATEADD(dd, 0, DATEDIFF(dd, 0, U_FechaHora))) LOF ON LOF.U_DocEntry = OWOR.DocNum 
inner join OHEM on OHEM.empID =  LOF.U_idEmpleado 
where OITM.ItmsGrpCod = 113 and DATEADD(dd, 0, DATEDIFF(dd, 0, LOF.Fecha)) between @FechaIS and @FechaFS 
group by OITM.ItmsGrpCod , OHEM.firstName, OHEM.middleName , OWOR.ItemCode , a.u_vs 
,OWOR.DocNum , OWOR.closedate , a.itemname , vwsof_pieles1.cantidad, vwsof_pieles1.monto
, OWOR.PlannedQty ,LOF.FECHA 
order by LOF.FECHA, OWOR.DocNum 


select * from vwSof_Pieles1
*/

/*
-- Reporte de Modelos con Grupos.

Select Left(OITM.ItemCode, 4) AS CODIGO
	, ISNULL((Select A3.ItemName From OITM A3 Where A3.ItemCode = Left(OITM.ItemCode, 4)), 'Z_DEF') AS MODELO
	, ISNULL(SG.GPO_157, 'SIN_GPO') AS TAPICERIA
	, ISNULL(SG.GPO_160, 'SIN_GPO') AS ARMADO
From OITM
left join SIZ_DestGrupo SG on SUBSTRING(OITM.ItemCode,1,7) = SG.CODE01 
Where OITM.U_TipoMat = 'PT' and  OITM.U_IsModel = 'N'
and OITM.InvntItem = 'Y' and OITM.frozenFor = 'N'
Group By Left(OITM.ItemCode, 4), SG.GPO_157, SG.GPO_160
Order By MODELO

*/
--Select * from OITM Where ItemCode = 'C'