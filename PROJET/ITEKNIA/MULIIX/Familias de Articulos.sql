-- Consulta para sacar Familias de Productos Terminados
-- Inicio: Sabado 04 de Agosto del 2018.
-- Actualizado: Sabado 04 Agosto del 2018.

-- Familias de Producto Terminado  (55 Registros):

Select AFAM_Codigo, AFAM_Nombre, AFAM_Descripcion, AFAM_Comprado, AFAM_Fabricado
from ArticulosFamilias
where AFAM_Comprado = 0 and AFAM_Fabricado = 1 

Select	ACAT_Codigo, ACAT_Nombre, ACAT_Descripcion, ACAT_Comprado, ACAT_Fabricado 
from ArticulosCategorias
Where ACAT_Comprado = 0 and ACAT_Fabricado = 1

