-- Consulta para obtener el catalogo de PT para Facturacion.
-- Identificador: MACRO 132 TENDENCIA DE FACTURACION.
-- Desarrollo: Ing. Vicente Cueva rAMÍREZ.
-- Actualizado: Jueves 22 de Diciembre del 2022.

-- Parametros Solo PT y que no sea Modelo.
-- 17,279 Reg. Al 22/Dic/22

Select A3.ItemCode AS CODIGO
	, A3.ItemName AS PRODUCTO
	, ISNULL((Select M1.ItemName from OITM M1 Where M1.ItemCode = Left(A3.ItemCode, 4)), 'SIN_MODEL') AS MODELO
	, ISNULL(A3.FrgnName, 'SIN_TIPO') AS COMPOSICION
	, ISNULL((Select Top(1) DESCDATO from SIZ_Acabados Where CODIDATO = Right(A3.ItemCode, 5)), 'SIN_ACAB') AS ACABADO
	, A3.U_VS AS VALOR_S
From OITM A3
Where A3.U_TipoMat = 'PT' and A3.U_IsModel = 'N'
Order By A3.ItemName



