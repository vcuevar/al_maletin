/*  Buscar en lista de materiales de ordenes (WOR1) en una semana especificada, un Donde Usado 
pero en un Programa */
-- -------------------------------------------------------------------------------------------
/* Donde Usado en Ordenes de Produccion */
-- -------------------------------------------------------------------------------------------
	select V3.Status as Estatus, V3.DocEntry as OP, V3.PlannedQty as Cant,V4.U_VS, V3.ItemCode as Codigo, V4.ItemName as Mueble, 
	WOR1.ItemCode as Material, v2.ItemName as Nombre_Material, WOR1.BaseQty as Cant_Mat, WOR1.wareHouse as Almacen
	from WOR1 
	inner join OITM V2 on WOR1.ItemCode = V2.ItemCode
	inner join OWOR V3 on WOR1.DocEntry = V3.DocEntry
	inner join OITM V4 on V3.ItemCode=V4.ItemCode
	where WOR1.ItemCode = '11001' and WOR1.IssuedQty = 0 and V3.Status <> 'C' and V3.Status<>'L' 
	--and V3.ItemCode like '%3499%'
	--and V1.wareHouse='APP-ST'
	order by V3.DocEntry

	go
/* Cambio de Un Material por otro codigo, en caso para Borrar usar ItemCode='10916'
    Papel Kapper que ya no se compra. */

	update WOR1 set WOR1.ItemCode ='11000'
	from WOR1 
	inner join OITM on WOR1.ItemCode = OITM.ItemCode
	inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
	where WOR1.ItemCode = '11001' and WOR1.IssuedQty = 0 and OWOR.Status <> 'C' and OWOR.Status<>'L' 
	
	
	go
/* Borrar El Codigo 10916 que se haya asignado a las Ordenes*/
	delete WOR1
	from WOR1 V1
	inner join OWOR V3 on V1.DocEntry = V3.DocEntry
	where V1.ItemCode='10916' and V1.IssuedQty =0 and V3.Status<>'C' and V3.Status<>'L'
	
-- -------------------------------------------------------------------------------------------
/* Donde Usado en Ordenes de Produccion para cambiar el ALMACEN */
-- -------------------------------------------------------------------------------------------
	select V3.Status as Estatus, V3.DocEntry as OP, V3.PlannedQty as Cant,V4.U_VS, V3.ItemCode as Codigo, V4.ItemName as Mueble, 
	V1.ItemCode as Material, v2.ItemName as Nombre_Material, V1.BaseQty as Cant_Mat, V1.wareHouse as Almacen
	from WOR1 V1
	inner join OITM V2 on V1.ItemCode=V2.ItemCode
	inner join OWOR V3 on V1.DocEntry=V3.DocEntry
	inner join OITM V4 on V3.ItemCode=V4.ItemCode
	where V1.ItemCode = '10823' and V3.Status <> 'C' and V3.Status<>'L' 
	and V1.wareHouse='APP-ST' 
	order by V3.DocEntry
	

-- Cambio de Almacen de donde toma el Material. 
	update WOR1 set wareHouse = 'APT-PA'
	from WOR1 V1
	inner join OITM V2 on V1.ItemCode=V2.ItemCode
	inner join OWOR V3 on V1.DocEntry=V3.DocEntry
	inner join OITM V4 on V3.ItemCode=V4.ItemCode
	where V1.ItemCode = '11360' and V1.IssuedQty = 0 and V3.Status <> 'C' and V3.Status<>'L' 
	and V1.wareHouse='APP-ST'









/* ------------------------------------------------------------------------------------------------------------------------
	Donde Usado en Ordenes REPORTADOS                                                                                     |
-------------------------------------------------------------------------------------------------------------------------*/	

select V3.Status, V3.DocEntry, V3.PlannedQty, V3.ItemCode, V4.ItemName, 
V1.ItemCode, v2.ItemName, V1.BaseQty, V1.wareHouse
from WOR1 V1
inner join OITM V2 on V1.ItemCode=V2.ItemCode
inner join OWOR V3 on V1.DocEntry=V3.DocEntry
inner join OITM V4 on V3.ItemCode=V4.ItemCode
where V3.[PlannedQty] = V3.[CmpltQty] and V1.ItemCode = '10176' and V3.Status='R' and V1.IssuedQty= 0
order by V3.DocEntry


/* Cambio de Un Material por otro codigo, en caso para Borrar usar ItemCode='10916'
    Papel Kapper que ya no se compra. */
	update WOR1 set ItemCode='10916'
	from WOR1 V1
	inner join OITM on V1.ItemCode=OITM.ItemCode
	inner join OWOR V3 on V1.DocEntry=V3.DocEntry
	inner join OITM V4 on V3.ItemCode=V4.ItemCode
	where V3.[PlannedQty] = V3.[CmpltQty] and V1.ItemCode = '10176' and V3.Status='R' and V1.IssuedQty= 0

/* Borrar El Codigo 10916 que se haya asignado a las Ordenes*/
	delete WOR1
	from WOR1 V1
	inner join OWOR V3 on V1.DocEntry = V3.DocEntry
	where V3.[PlannedQty] = V3.[CmpltQty] and V1.ItemCode = '10916' and V3.Status='R'


-- Cambio de Almacen a Ordenes Reportadas APG-ST
	select V3.Status as Estatus, V3.DocEntry as OP, V3.PlannedQty as Cant,V4.U_VS, V3.ItemCode as Codigo, V4.ItemName as Mueble, 
	V1.ItemCode as Material, v2.ItemName as Nombre_Material, V1.BaseQty as Cant_Mat, V1.wareHouse as Almacen
	from WOR1 V1
	inner join OITM V2 on V1.ItemCode=V2.ItemCode
	inner join OWOR V3 on V1.DocEntry=V3.DocEntry
	inner join OITM V4 on V3.ItemCode=V4.ItemCode
	where V3.[PlannedQty] = V3.[CmpltQty] and V3.Status = 'R' and V1.IssuedQty= 0
	and (V1.wareHouse = 'APP-ST' or V1.wareHouse = 'APT-PA') 
	order by V3.DocEntry
	
	-- Cambio de Almacen al de APG-ST. 
	update WOR1 set wareHouse = 'APG-ST'
	from WOR1 V1
	inner join OITM V2 on V1.ItemCode=V2.ItemCode
	inner join OWOR V3 on V1.DocEntry=V3.DocEntry
	inner join OITM V4 on V3.ItemCode=V4.ItemCode
	where V3.[PlannedQty] = V3.[CmpltQty] and V3.Status = 'R' and V1.IssuedQty= 0
	and (V1.wareHouse = 'APP-ST' or V1.wareHouse = 'APT-PA') 




/* ------------------------------------------------------------------------------------------------------------------------
	Donde Usado en Ordenes en Proceso especificando el AREA DONDE SE UBICA.                                                                                     |
-------------------------------------------------------------------------------------------------------------------------*/	
	Select OP.Status, OP.DocEntry, OP.ItemCode, A3.ItemName, OM.ItemCode, A1.ItemName, OM.PlannedQty
	from WOR1 OM
	inner join [@CP_OF] ST on OM.DocEntry = ST.U_DocEntry
	inner join OWOR OP on OP.DocEntry= OM.DocEntry
	inner join OITM A1 on OM.ItemCode=A1.ItemCode
	inner join OITM A3 on OP.ItemCode=A3.ItemCode
	where ST.U_CT > 136 and A1.ItemCode='12713'

-- Cambio de Un material por Otro.
	update OM set ItemCode='12710'
	from WOR1 OM
	inner join [@CP_OF] ST on OM.DocEntry = ST.U_DocEntry
	inner join OWOR OP on OP.DocEntry= OM.DocEntry
	inner join OITM A1 on OM.ItemCode=A1.ItemCode
	inner join OITM A3 on OP.ItemCode=A3.ItemCode
	where ST.U_CT > 136 and A1.ItemCode='12713'

/* Borrar El Codigo 10916 que se haya asignado a las Ordenes*/
	delete WOR1
	from WOR1 V1
	inner join OWOR V3 on V1.DocEntry = V3.DocEntry
	where V1.ItemCode='10916' and V1.IssuedQty =0 and V3.Status<>'C' and V3.Status<>'L'

-- ----------------------------------------------------------------------------------------------------
/* Cambio de Cantidad en ORDENES un Material en su cantidad unitaria, si y solo si este en cero lo consumido */
-- ------------------------------------------------------------------------------------------------------
select V3.Status, V3.DocEntry, V3.PlannedQty, V3.ItemCode, V4.ItemName, 
V1.ItemCode, v2.ItemName, V1.BaseQty, V1.wareHouse
from WOR1 V1
inner join OITM V2 on V1.ItemCode=V2.ItemCode
inner join OWOR V3 on V1.DocEntry=V3.DocEntry
inner join OITM V4 on V3.ItemCode=V4.ItemCode
where V1.ItemCode = '11405'and V1.IssuedQty =0 and V3.Status<>'C' and V3.Status<>'L' --and V3.ItemCode like '3703%'
order by V3.DocEntry

update WOR1 set BaseQty= V1.BaseQty*16
from WOR1 V1
inner join OITM V2 on V1.ItemCode=V2.ItemCode
inner join OWOR V3 on V1.DocEntry=V3.DocEntry
inner join OITM V4 on V3.ItemCode=V4.ItemCode
where V1.ItemCode = '14528'and V1.IssuedQty =0 and V3.Status<>'C' and V3.Status<>'L' -- and V3.ItemCode like '3703%'

update WOR1 set PlannedQty=(V1.BaseQty*V3.PlannedQty) 
from WOR1 V1
inner join OITM V2 on V1.ItemCode=V2.ItemCode
inner join OWOR V3 on V1.DocEntry=V3.DocEntry
inner join OITM V4 on V3.ItemCode=V4.ItemCode
where V1.ItemCode = '14528'and V1.IssuedQty =0 and V3.Status<>'C' and V3.Status<>'L' and V3.ItemCode like '3703%'

/*  En caso de haber modificado cantidades de Ordenes hay que actualizar saldos del material. */



-- -----------------------------------------------------------------------------------------------
/* Donde usado en Listas de Materiales del Articulo (CODIGOS MAESTROS). */
-- -----------------------------------------------------------------------------------------------

select M1.Father, M3.ItemName, M1.Code, M2.ItemName, M1.Quantity, M2.InvntryUom, M2.U_TipoMat
from ITT1 M1
inner join OITM M2 on M1.Code = M2.ItemCode
left join OITM M3 on M1.Father=M3.ItemCode
where Code = '11001' --and M3.ItemCode like '3564-40'
order by M3.ItemName


-- Consultar Material DOnde Usado en Lista de Materiales.
Select * from ITT1
where Code= '15818'

/* Cambio de Un Material por otro codigo */
update ITT1 set Code = '11000'
where Code = '11001' -- and Father like '3735%'

-- Para Borrar Articulos 
delete ITT1
where Code = '17908' 







SELECT ITT1.Father, ITT1.Code, ITT1.Quantity from ITT1
where ITT1.Code = '18129'
order by Quantity

update ITT1 set Quantity= 14 
where Code = '18129' and Quantity=14.4



/* Cambiar de Almacen la lista de Materiales */

update WOR1 set wareHouse='APP-ST'
from WOR1 V1
inner join OITM on V1.ItemCode=OITM.ItemCode
inner join OWOR V3 on V1.DocEntry=V3.DocEntry
inner join OITM V4 on V3.ItemCode=V4.ItemCode
where V1.ItemCode='17073'and V1.IssuedQty =0 and V3.Status<>'C' and V3.Status<>'L' and V3.Status<>'P'
and V4.ItemName like '%PIZZA%'




/* Catalogo de Materiales*/
select OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, OITM.ItmsGrpCod, OITM.U_estacion,
OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr, OITM.U_VS, OITM.U_VSPago
from OITM 
where ItemCode like '%H%'

/*
update OITM set U_VS=0
where ItemCode like '%H%'
*/

/*  Cambiar o Donde Usado en Lista Maestra */
select * from [@TC_LISMAT]
where [@TC_LISMAT].U_NumArt = '10514'

select * from OITM where ItemCode='11441'

update [@TC_LISMAT] set U_NumArt='11441'
where [@TC_LISMAT].U_NumArt = '10514'

update [@TC_LISMAT] set U_NomArt ='CINTA TRANSPARENTE DE 48X 150 MTS. (EMPAQUE EXPORTACION).'
where [@TC_LISMAT].U_NumArt = '11441'


