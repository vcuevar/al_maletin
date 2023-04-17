-- Nombre Reporte: R117 Back Order Horizonte de Produccion.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Lunes 19 de Abril del 2021; Origen a SAP 10.

--Procedimiento para Agrupar por Grupo de Cadenas de Distribución.

Execute sp_DistribucionTapiceria2 1


-- Procedimiento por Avance´o Estatus de Producción, con la fecha de Compras..

Execute sp_DistribucionTapiceria1 2


-- Procedimiento para Agrupar por Avance´o Estatus de Producción con la fecha de Produccion.

Execute sp_DistribucionTapiceria2 1




-- Consulta para obtener los datos para el Horizonte de Produccion.

Select * 
from OWOR 
Where OWOR.Status = 'L' and 
