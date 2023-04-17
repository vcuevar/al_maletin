-- SAP Consulta para Preparar Informacion de Camio de Fecha a Ordenes Reportadas.
-- Ing. Vicente Cueva R.
-- Iniciado: Martes 17 de Julio del 2018
-- Actualizado: Martes 17 de Julio del del 2018.

DECLARE @FechaIS as date
DECLARE @Estacion as Int
                            -- Año-Mes-Dia
Set @FechaIS = CONVERT (DATE, '2018-05-28', 102)
Set @Estacion = 315

-- Datos de Orden a Cambiar Fechas.
select * from [@CP_LOGOF] where Cast (U_FechaHora as DATE) = @FechaIS  and U_CT = @Estacion order by U_FechaHora


--Excepciones Inicios Mayores a fecha de Termino.
Select [@CP_LOGOT].Code,  OT.U_FechaHora, * from [@CP_LOGOT]
inner join [@CP_LOGOF] OT on [@CP_LOGOT].U_CT = OT.U_CT
and [@CP_LOGOT].U_OP = OT.U_DocEntry
where [@CP_LOGOT].Code = 88486
where Cast([@CP_LOGOT].U_FechaHora as DATE) > Cast( OT.U_FechaHora as DATE)
order by [@CP_LOGOT].U_OP, [@CP_LOGOT].U_CT

update [@CP_LOGOT] set U_FechaHora = fecha where Code = codigo 
update [@CP_LOGOT] set U_FechaHora = ('2018/6/18') where Code =  88486


Select [@CP_LOGOT].Code, * from [@CP_LOGOT]
where  [@CP_LOGOT].Code = 88486

where Cast([@CP_LOGOT].U_FechaHora as DATE) > Cast( OT.U_FechaHora as DATE)