-- Consulta para Cotizaciones.
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Miercoles 06 de Abril del 2022; Origen.

-- Parametros: Fecha de Cerrado.
DECLARE @FechaIS date

Set @FechaIS = CONVERT (DATE, '2022-04-06', 102) 

/*
Select * from Cotizaciones
Where  COT_FechaCerrada is null  
and COT_CodigoCotizacion <> '01692'
and COT_CodigoCotizacion <> '01691'
and COT_CodigoCotizacion <> '01690'
and COT_CodigoCotizacion <> '01688'
and COT_CodigoCotizacion <> '01687'
and COT_CodigoCotizacion <> '01676'
and COT_CodigoCotizacion <> '01675'
and COT_CodigoCotizacion <> '01640'
and COT_CodigoCotizacion <> '01609'
and COT_CodigoCotizacion <> '01606'
and COT_CodigoCotizacion <> '01514'
and COT_CodigoCotizacion <> '01677'
and COT_CodigoCotizacion <> '01666'
and COT_CodigoCotizacion <> '01655'
and COT_CodigoCotizacion <> '01537'
and COT_CodigoCotizacion <> '01666'
and COT_CodigoCotizacion <> '01625'
and COT_CodigoCotizacion <> '01672'
and COT_CodigoCotizacion <> '01396'
and COT_CodigoCotizacion <> '01004'
and COT_CodigoCotizacion <> '01397'
Order by COT_CodigoCotizacion
*/

Select TOP(50) * from Cotizaciones
Where  COT_CodigoCotizacion like '%1514%'
--COT_FechaCerrada = @FechaIS 
Order By COT_CodigoCotizacion, COT_Revision


Update Cotizaciones set COT_CMM_EstatusId = 'F5708F9D-B034-4BB9-A086-F370EE519E85', COT_FechaCerrada = GETDATE(),
COT_EMP_ModificadoPorId = 'D117CCA7-7114-4B55-9EEB-9F8553BF6179'
Where  COT_FechaCerrada is null  
and COT_CotizacionId = 'C84D6F62-8B29-41D5-977D-5902A75B5BD9'



-- Select * from ControlesMaestrosMultiples where CMM_ControlId = 'F5708F9D-B034-4BB9-A086-F370EE519E85'
/*
Select * from ControlesMaestrosMultiples where CMM_Control = 'CMM_EstatusCotizacion'
	CMM_ControlId							CMM_Control			CMM_Valor
E639357E-D8AF-4B39-8AD7-B6C05E1C6B57	CMM_EstatusCotizacion	ALTA
29094EEC-33D5-4929-B206-8A34FB1D4239	CMM_EstatusCotizacion	AUTORIZADA
4E747C7B-8E8E-43B1-944B-3985B89ED4A8	CMM_EstatusCotizacion	CANCELADA
F5708F9D-B034-4BB9-A086-F370EE519E85	CMM_EstatusCotizacion	CERRADA
22C17A34-1C0D-42DF-89BE-8592AB61EF2B	CMM_EstatusCotizacion	COTIZADA
0EC4CC6C-A7D8-4F18-AED0-A92A22FF27F3	CMM_EstatusCotizacion	PROGRAMADA
2B585138-9007-41BB-9DC9-14EE70AB2385	CMM_EstatusCotizacion	REVISADA
*/