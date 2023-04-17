

SELECT  Distinct Left(A3.ItemCode,7) AS CODIGO
		, A3.ItemName AS DESCRIPCION
		, A3.InvntryUom AS UDM
		, A3.U_TipoMat AS TIPO
	FROM OITM A3
	WHERE A3.U_TipoMat = 'PT' and A3.ItemCode like '%-01-%' 
	ORDER BY A3.ItemName


Select ItemCode, ItemName
from OITM
Where OITM.U_IsModel = 'S'
Order By ItemName


Select ItemCode, ItemName
from OITM
Where Left(ItemCode,5) = '3491-' and ItemCode not like '%P0301' and OITM.InvntItem = 'Y'
and OITM.frozenFor = 'N'
Order By ItemName