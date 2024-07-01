-- Sistema SIZ
-- Autor: Alberto Jimenez Medina.
-- Fecha: Miercoles 14 de Noviembre del 2019
-- TRASLADOS ENTRE ALMECENES PENDIENTES 

/*
ARTICULOS			
EstatusLinea			
S	Activo		
C	Cancelado		
A	No autorizado		RAUL 
T	Terminado, Surtido por completo		
P	Pendiente, tiene Cantidad Pendiente		
N	No se va surtir		
			
			
I	Linea para Traslado Interno		T
E	Linea para Traslado Externo		S-T

*/

  
 Select	'TRASLADOS' AS TIPO_DOC,
		SIZ_SolicitudesMP.Id_Solicitud AS NUMERO,
		Cast(SIZ_SolicitudesMP.FechaCreacion AS DATE) AS FECHA,
		(Select OHEM.firstName +'  '+ OHEM.lastName from OHEM Where OHEM.U_EmpGiro = SIZ_SolicitudesMP.Usuario) AS USUARIO,
		Destino AS DESTINO,
		SIZ_SolicitudesMP.Status AS ST_SOL,
		SIZ_MaterialesTraslados.ItemCode AS CODIGO,
		OITM.ItemName AS DESCRIPCION,
		OITM.InvntryUom AS UDM,
		SIZ_MaterialesTraslados.Cant_Pendiente AS PENDIENTE,
		SIZ_MaterialesTraslados.EstatusLinea AS ST_LIN
 From SIZ_SolicitudesMP
 inner join SIZ_MaterialesTraslados on SIZ_MaterialesTraslados.Id_Solicitud = SIZ_SolicitudesMP.Id_Solicitud 
 inner join OITM on SIZ_MaterialesTraslados.ItemCode = OITM.ItemCode
 Where  SIZ_SolicitudesMP.Id_Solicitud = 60215
 --and SIZ_MaterialesTraslados.EstatusLinea <> 'S' 
 --and SIZ_SolicitudesMP.Status like 'Cancelada'
 --SIZ_MaterialesTraslados.ItemCode = '17653'
  Order By SIZ_SolicitudesMP.Id_Solicitud


  Select * from SIZ_SolicitudesMP Where SIZ_SolicitudesMP.Id_Solicitud = 11496

  Select * from SIZ_MaterialesTraslados Where SIZ_MaterialesTraslados.Id_Solicitud = 11496 --and EstatusLinea = 'S' --SIZ_MaterialesTraslados.ItemCode = '18205' and 

  Select * from SIZ_MaterialesTraslados Where ItemCode = '17653'

  Select * from SIZ_MaterialesSolicitudes Where Id_Solicitud = 60215


-- Para cancelar una solicitud.
  Update SIZ_MaterialesTraslados set Cant_Pendiente = 0, EstatusLinea = 'C' Where SIZ_MaterialesTraslados.Id_Solicitud = 48486 --and EstatusLinea = 'S'

  Update SIZ_SolicitudesMP set Status = 'Cerrada' Where SIZ_SolicitudesMP.Id_Solicitud = 56267
  
  -- Cambiar estatus a linea de los materiales trasladados. T Terminada C Cancelada
  Select * from SIZ_MaterialesTraslados  Where Id = 4791
  Update SIZ_MaterialesTraslados Set EstatusLinea = 'T' Where Id = 19814


   Select * from SIZ_MaterialesSolicitudes Where Id = 56267

   Update SIZ_MaterialesSolicitudes Set EstatusLinea = 'T', Cant_PendienteA = 0  Where Id = 64412

 Select DISTINCT EstatusLinea, Status 
 from SIZ_MaterialesSolicitudes
 inner join SIZ_SolicitudesMP on SIZ_SolicitudesMP.Id_Solicitud = SIZ_MaterialesSolicitudes.Id
 order by estatuslinea



-- Select	* From SIZ_MaterialesSolicitudes
 -- Where Id_Solicitud  = 3350
  
  --Select * from SIZ_MaterialesTraslados
  --where Id_Solicitud = 3350
 
 









 /*
select	[SIZ_SolicitudesMP].[Id_Solicitud], 
		[SIZ_SolicitudesMP].[FechaCreacion],
		[SIZ_SolicitudesMP].[Status], 
		[SIZ_SolicitudesMP].[AlmacenOrigen], 
		[SIZ_SolicitudesMP].[Usuario], 
		([OHEM].[firstName]+ ' ' + [OHEM].[lastName]) AS USUARIO, 
		Destino,
		[OHEM].[dept] as NumDeptOrigen, 
		[OUDP].[Name] as Depto_Origen 
from [SIZ_SolicitudesMP] 
inner join [SIZ_MaterialesTraslados] on [SIZ_MaterialesTraslados].[Id_Solicitud] = [SIZ_SolicitudesMP].[Id_Solicitud] 
left join [OHEM] on [OHEM].[U_EmpGiro] = [SIZ_SolicitudesMP].[Usuario] 
left join [OUDP] on [OUDP].[Code] = [dept] 
--inner join [SIZ_AlmacenesTransferencias] on [SIZ_AlmacenesTransferencias].[Code] = SUBSTRING(Destino, 1, 6) 
--and [SIZ_AlmacenesTransferencias].[TrasladoDeptos] <> 'D' and [TrasladoDeptos] is not null 
 
where [SIZ_SolicitudesMP].[AlmacenOrigen] is not null 
 and [SIZ_MaterialesTraslados].[Cant_Pendiente] > 0 
 -- and [SIZ_AlmacenesTransferencias].[Dept] = '1'
 and [SIZ_MaterialesTraslados].[EstatusLinea] in ('S', 'P') and [SIZ_SolicitudesMP].[Status] = 'Pendiente' 
 group by [SIZ_SolicitudesMP].[Id_Solicitud], [SIZ_SolicitudesMP].[FechaCreacion], 
 [SIZ_SolicitudesMP].[Usuario], [SIZ_SolicitudesMP].[Status], [firstName], [lastName], 
 [OHEM].[dept], [Name], [SIZ_SolicitudesMP].[AlmacenOrigen], Destino

 --Select *
 --from [SIZ_SolicitudesMP] 
 --inner join [SIZ_MaterialesTraslados] on [SIZ_MaterialesTraslados].[Id_Solicitud] = [SIZ_SolicitudesMP].[Id_Solicitud] 
 --left join [OHEM] on [OHEM].[U_EmpGiro] = [SIZ_SolicitudesMP].[Usuario] 
 --left join [OUDP] on [OUDP].[Code] = [dept]
 --WHERE --[SIZ_SolicitudesMP].[Status] = 'Pendiente' 
 --and AlmacenOrigen = 'AMP-CC'
  --ItemCode = '14524'
  --[SIZ_SolicitudesMP].Id_Solicitud = 885


 
 Select *
 from [SIZ_SolicitudesMP] 
 


 Select DISTINCT EstatusLinea, Status 
 from SIZ_MaterialesSolicitudes
 inner join SIZ_SolicitudesMP on SIZ_SolicitudesMP.Id_Solicitud = SIZ_MaterialesSolicitudes.Id
 order by estatuslinea


 Select *
 from SIZ_MaterialesTraslados
 where ItemCode = '16603'

  Select *
 from SIZ_MaterialesSolicitudes
 where ItemCode = '16603'

 


 Select	'SOLICITUD' AS TIPO_DOC,
		SIZ_SolicitudesMP.Id_Solicitud AS NUMERO,
		Cast(SIZ_SolicitudesMP.FechaCreacion AS DATE) AS FECHA,
		(Select OHEM.firstName +'  '+ OHEM.lastName from OHEM Where OHEM.U_EmpGiro = SIZ_SolicitudesMP.Usuario) AS USUARIO,
		Destino AS DESTINO,
		SIZ_SolicitudesMP.Status AS ST_SOL,
		SIZ_MaterialesSolicitudes.ItemCode AS CODIGO,
		OITM.ItemName AS DESCRIPCION,
		OITM.InvntryUom AS UDM,
		SIZ_MaterialesSolicitudes.Cant_Pendiente AS PENDIENTE,
		SIZ_MaterialesSolicitudes.EstatusLinea AS ST_LIN
 From SIZ_SolicitudesMP
 inner join SIZ_MaterialesSolicitudes on SIZ_MaterialesSolicitudes.Id_Solicitud = SIZ_SolicitudesMP.Id_Solicitud 
 inner join OITM on SIZ_MaterialesSolicitudes.ItemCode = OITM.ItemCode
 Where SIZ_MaterialesSolicitudes.EstatusLinea in ('C') AND  
  SIZ_SolicitudesMP.Status like 'Regresa%'

 and SIZ_MaterialesSolicitudes.ItemCode = '349121'
 

 Select	'TRASLADOS' AS TIPO_DOC,
		SIZ_SolicitudesMP.Id_Solicitud AS NUMERO,
		Cast(SIZ_SolicitudesMP.FechaCreacion AS DATE) AS FECHA,
		(Select OHEM.firstName +'  '+ OHEM.lastName from OHEM Where OHEM.U_EmpGiro = SIZ_SolicitudesMP.Usuario) AS USUARIO,
		Destino AS DESTINO,
		SIZ_SolicitudesMP.Status AS ST_SOL,
		SIZ_MaterialesTraslados.ItemCode AS CODIGO,
		OITM.ItemName AS DESCRIPCION,
		OITM.InvntryUom AS UDM,
		SIZ_MaterialesTraslados.Cant_Pendiente AS PENDIENTE,
		SIZ_MaterialesTraslados.EstatusLinea AS ST_LIN
 From SIZ_SolicitudesMP
 inner join SIZ_MaterialesTraslados on SIZ_MaterialesTraslados.Id_Solicitud = SIZ_SolicitudesMP.Id_Solicitud 
 inner join OITM on SIZ_MaterialesTraslados.ItemCode = OITM.ItemCode
 Where SIZ_SolicitudesMP.Id_Solicitud = 3681
 --SIZ_MaterialesTraslados.EstatusLinea in ('C') AND 
 --SIZ_SolicitudesMP.Status like 'Regresa%'

 --and SIZ_MaterialesTraslados.ItemCode = '349121'
  Order By SIZ_SolicitudesMP.Id_Solicitud

  */






