-- Consulta para Macro 116 Programa de Corte de Piel.
-- Elaboro: Ing. Vicente Cueva Ramírez.
-- Actualizado: Viernes 16 de Abril del 2021; Origen para SAP 10
-- Actualizado: Lunes 28 de julio del 2025; Agregar Materiales Piel y Tela 

-- Parametros Numero del Programa.

Declare @NumProg as nvarchar(20)
Set @NumProg = '25334'


-- Consulta del Programa al 28 de julio del 2025.

Select	OWOR.Status AS ESTADO
		, OWOR.DocNum AS NUM_ORDEN
		, OWOR.U_NoSerie AS SERIE
		, owor.OriginNum AS PEDIDO
		, OWOR.U_Grupo AS PROG_MANTA
		, OWOR.U_OT AS FOLIO
		, OWOR.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, owor.PlannedQty AS Q_ORDEN
		, OITM.U_VS AS VS
		, (OWOR.PlannedQty*OITM.U_VS) AS TVS
		, Cast(OWOR.DueDate as date) AS F_TERMINO
		, OWOR.CardCode AS COD_CLIENTE
		, OCRD.cardname AS CLIENTE
		, DT2.Descr AS ES_ESPECIAL
		, UFD1.Descr AS ESTATUS
		, (Select Top 1 RT.Name from [@CP_OF] PR inner join  [@PL_RUTAS] RT on RT.Code = PR.U_CT where PR.U_DocEntry=OWOR.DocEntry order by PR.U_CT) AS EST_CP 
		, A1.ItemCode AS COD_MAT
		, A1.ItemName AS MATERIAL
		, WOR1.PlannedQty AS Q_PLAN
		, A1.U_GrupoPlanea AS GRP_MAT
		, OWOR.U_Starus AS ASIGNADO
From OWOR 
Left join WOR1 on OWOR.DocEntry = WOR1.DocEntry 
Inner Join OITM A1 on WOR1.ItemCode = A1.ItemCode and (A1.U_GrupoPlanea = 9 or A1.U_GrupoPlanea = 11)
Inner join OITM on OITM.ItemCode = OWOR.ItemCode 
Inner join OCRD on ocrd.cardcode = OWOR.CardCode 
Inner join ORDR on OWOR.OriginNum= ORDR.DocEntry 
inner join UFD1 on OWOR.U_Starus= UFD1.FldValue and UFD1.TableID='OWOR'and UFD1.FieldID = 2
Inner join UFD1 DT2 on ORDR.U_Especial = DT2.FldValue and DT2.TableID='ORDR'and DT2.FieldID = 6
Where  OWOR.U_Grupo = @NumProg
Order by OWOR.U_NoSerie, OWOR.DocNum     




/*
-- Consulta del Programa al 16 de abril del 2021.

Select	OWOR.Status as Estado
		, OWOR.DocNum as NuOrden
		, OWOR.U_NoSerie as Serial
		, owor.OriginNum as Pedido
		, OWOR.U_Grupo as ProgManta
		, OWOR.U_OT as Folio
		, OWOR.ItemCode as Codigo
		, OITM.ItemName as Descripcion
		, owor.PlannedQty as Cant
		, OITM.U_VS as Valor
		, (OWOR.PlannedQty*OITM.U_VS) as Total
		, OWOR.DueDate as F_Termino
		, OWOR.CardCode as CodeClie
		, OCRD.cardname as Cliente
		, DT2.Descr as Tipo
		, UFD1.Descr as Estatus
		, (Select Top 1 RT.Name from [@CP_OF] PR inner join  [@PL_RUTAS] RT on RT.Code = PR.U_CT where PR.U_DocEntry=OWOR.DocEntry order by PR.U_CT) as Es_CP 
from OWOR 
Inner join OITM on OITM.ItemCode = OWOR.ItemCode 
Inner join OCRD on ocrd.cardcode = OWOR.CardCode 
Inner join ORDR on OWOR.OriginNum= ORDR.DocEntry 
inner join UFD1 on OWOR.U_Starus= UFD1.FldValue and UFD1.TableID='OWOR'and UFD1.FieldID = 2
Inner join UFD1 DT2 on ORDR.U_Especial = DT2.FldValue and DT2.TableID='ORDR'and DT2.FieldID = 6
where  OWOR.U_Grupo = @NumProg
Order by OWOR.U_NoSerie, OWOR.DocNum     
*/
