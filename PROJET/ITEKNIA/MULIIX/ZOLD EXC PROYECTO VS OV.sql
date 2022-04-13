-- Reporte de Excepcion Un proyecto no debe contener mas de dos Ordenes
-- Elaboro: Ing, Vicente Cueva Ramírez.
-- Actualizado: Miercoles 23 de Diciembre del 2020; Origen.
-- Actualizado: Viernes 07 de Enero del 2022; Declinado ya que si se manejaron Varias OV por proyecto.

-- Parametros
-- Ninguno.

-- Consulta.
Select Cast(PRY_FechaInicia as date) as F_PROY, PRY_CodigoEvento, PRY_NombreProyecto, PRY_Activo, OV_CodigoOV
from Proyectos
left join OrdenesVenta on OV_PRO_ProyectoId  = PRY_ProyectoId
Where PRY_Borrado = 0
Order by PRY_CodigoEvento, OV_CodigoOV


--select * from Proyectos
--select * from OrdenesVenta