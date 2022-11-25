-- Consulta para reporte 122 Auditoria de Acabados en LDM
-- Solicitado: Mauricio y Osien de Diseño.
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 18 de Junio del 2021; Origen.
-- Actualizado: Lunes 22 de Noviembre del 2021; Agrego Grupo Planeacion 11 TELAS.
-- Actualizado: Miercoles 28 de Septiembre del 2022; Columna Cantidad de LDM.

-- Parametros Ninguno.

Select	OITT.Code AS CODIGO
		, (Case When A3.U_TipoMat = 'PT' Then SUBSTRING(A3.ItemCode, 6,2) else SUBSTRING(A3.ItemCode, 5,2) end) AS MUEBLE
		, A3.ItemName AS DESCRIPCION
		, A3.InvntryUom AS UDMA
		, A1.ItemCode AS CODE
		, A1.ItemName AS MATERIAL
		, A1.InvntryUom AS UDMM
		, ITT1.Quantity AS CANT
		, T1.Descr AS GRUPPLAN
From OITT 
Inner Join ITT1 on ITT1.Father = OITT.Code 
Inner Join OITM A3 on OITT.Code = A3.ItemCode 
Inner Join OITM A1 on ITT1.Code = A1.ItemCode
left join UFD1 T1 on A1.U_GrupoPlanea=T1.FldValue and T1.TableID='OITM' and T1.FieldID=9 
Where T1.FldValue = 10 OR T1.FldValue = 18 OR T1.FldValue = 19 OR T1.FldValue = 9  OR T1.FldValue = 11 
Order By A3.ItemName





--Select top(20) * from ITT1



/*
Select * from UFD1 T1 Where T1.TableID='OITM' and T1.FieldID=9 Order by T1.Descr


1	ACCESORIOS
27	ACCESORIOS CINES
2	CASCO Y HABILITADOS
19	CIERRES
24	CRISTALES, ESPEJO, MARMOL
21	DELCRONES Y PLUMA
3	EMPAQUE
4	GENERAL
22	GRAPAS Y CLAVOS
5	HERRAJES Y MECANISMOS
18	HILOS
6	HULE ESPUMA
23	LACAS, ESMALTES, PIGMENTOS
20	MADERAS Y DERIVADOS
26	MAQUILAS
7	METALES CROMADOS
8	METALES REFUERZO
14	PATAS DE MADERA
25	PATAS, RIEDAS Y REGATONES
9	PIEL
16	SUB-ENSAMBLE
10	TELAS COMPLEMENTO
11	TELAS Y VINILES
17	TORNILLERIA Y SIMILARES
15	Z MUEBLES
12	Z PRODUCTO TERMINADO
13	Z REFACCIONES
*/



