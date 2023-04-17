-- Consulta para Macro 116 Programa de Corte de Piel.
-- Elaboro: Ing. Vicente Cueva Ramírez.
-- Actualizado: Viernes 16 de Abril del 2021; Origen para SAP 10

-- Parametros Numero del Programa.

Declare @NumProg as nvarchar(20)
Set @NumProg = '21162'

-- Consulta del Programa

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

