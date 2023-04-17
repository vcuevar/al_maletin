SELECT 
ALM_CodigoAlmacen,
ALM_Nombre,
ALM_AlmacenId,
LOC_CodigoLocalidad,
LOC_Nombre,
LOC_LocalidadId		
from Localidades
inner join Almacenes on LOC_ALM_AlmacenId = ALM_AlmacenId
where LOC_Eliminado = 0
Order By ALM_Nombre, LOC_Nombre


-- Se utilizo para cambiar de Nombre a los codigos de las localidaes y darles Secuencia y Referencia para los reportes 
-- Que muestras solo este codigo y no el nombre.

Select * from Localidades Where LOC_Eliminado = 0 Order by LOC_CodigoLocalidad, LOC_Nombre

update Localidades set LOC_CodigoLocalidad = 'L101_GENERAL' Where LOC_LocalidadId = '49D778C5-BF1C-4683-A9B5-46DB602862C8'
update Localidades set LOC_CodigoLocalidad = 'L102_CONSIGNA' Where LOC_LocalidadId = '0547A9FC-4919-459E-920B-15A9A09882AD'
update Localidades set LOC_CodigoLocalidad = 'L103_MERMA' Where LOC_LocalidadId = '24F8921F-F6BA-47AC-8E93-C035D44F5E99'
update Localidades set LOC_CodigoLocalidad = 'L104_METALMX' Where LOC_LocalidadId = '5E9328DD-B7D4-4582-A7D5-1E479AE9BE1E'

update Localidades set LOC_CodigoLocalidad = 'L211_ANAQUEL' Where LOC_LocalidadId = '581650A9-63D6-43C0-815D-30922AD402D9'
update Localidades set LOC_CodigoLocalidad = 'L212_HULES' Where LOC_LocalidadId = '6F3F5BE4-285E-4DF7-B189-A62F0A74AA1B'
update Localidades set LOC_CodigoLocalidad = 'L213_PISO' Where LOC_LocalidadId = 'E6FD8AA4-62FA-4B67-BCCE-D549C9E3BABF'

update Localidades set LOC_CodigoLocalidad = 'L221_ANAQUEL' Where LOC_LocalidadId = '0D6A6312-1B21-4D49-9A3A-632B89ACBA2D'
update Localidades set LOC_CodigoLocalidad = 'L222_LACA' Where LOC_LocalidadId = '61AF170D-A584-4AC9-B1AA-5540DB65E6B0'
update Localidades set LOC_CodigoLocalidad = 'L223_MADERAS' Where LOC_LocalidadId = '1FB5AA3F-45E3-4511-B4AE-27941334CDCC'
update Localidades set LOC_CodigoLocalidad = 'L224_PISO' Where LOC_LocalidadId = 'F4B69178-D90C-450C-BA3A-7AEAEC308180'

update Localidades set LOC_CodigoLocalidad = 'L231_VALLARTA' Where LOC_LocalidadId = '8DCEC3E4-B9C1-4014-9643-5B777473576C'

update Localidades set LOC_CodigoLocalidad = 'L241_TEMPORAL' Where LOC_LocalidadId = '34EDC394-529F-4EAE-9761-E12C4D838EDE'

update Localidades set LOC_CodigoLocalidad = 'L301_TERMINADO' Where LOC_LocalidadId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF'




-- Se utilizo para cambiar de Nombre a los codigos de los Almacenes y darles Secuencia y Referencia para los reportes 
-- Que muestras solo este codigo y no el nombre.

Select * from Almacenes Where ALM_Eliminado = 0 Order by ALM_CodigoAlmacen

update Almacenes set ALM_CodigoAlmacen = 'A11_MP' Where ALM_AlmacenId = 'CB35B14B-7BB1-4771-84DA-A4CBE159C8D6'

update Almacenes set ALM_CodigoAlmacen = 'A21_WIP1' Where ALM_AlmacenId = 'A3ECCB9D-13E6-4942-9EF1-0C64CECAB672'
update Almacenes set ALM_CodigoAlmacen = 'A22_WIP2' Where ALM_AlmacenId = 'C0138CFF-C57E-401D-BFE4-05C4188732B9'
update Almacenes set ALM_CodigoAlmacen = 'A23_VALLARTA' Where ALM_AlmacenId = 'DCC5A0E6-3FA4-4C23-B48E-A120D5B2F6B8'
update Almacenes set ALM_CodigoAlmacen = 'A24_TEMPORAL' Where ALM_AlmacenId = 'B43FAD82-AF04-4CA8-AB7F-C09FA8C445A1'

update Almacenes set ALM_CodigoAlmacen = 'A31_PT' Where ALM_AlmacenId = '0B2FFBB7-44A4-485F-A2D4-792E281591E5'

