-- Consulta para Generar Reporte de Componentes de Materiales.
-- Ing. Vicente Cueva R.
-- Solicitado: Viernes 29 de Junio del 2018.
-- Inicio: Viernes 29 de Junio del 2018. 

-- Declaracion de Variables.
Declare @Codigo nvarchar(20)
Declare @Cantid int 

-- Datos para la generacion del reporte.
Set @Codigo = '18761'
Set @Cantid = 100

--Determina el codigo de la Funda
--Set @Codigo = (Select top 1 * from OITM where OITM.ItemCode like @Codigo order by OITM.ItemCode)
--PRINT 'Ingresado: CODIGO ' + cast(@CODI as varchar(10))  + '  ' + cast(@NAME as varchar (50))

-- Determina los articulos con lista de Materiales
Select	ITT1.Father AS COD_PROD,
		A3.ItemName AS PRODUCTO,
		ITT1.Code AS COD_MP,
		A1.ItemName AS MATERIAL,
		A1.InvntryUom AS UM,
		ITT1.Quantity AS CANT,
		@Cantid AS PROY,
		ITT1.Quantity * @Cantid AS NECESID,
		W1.OnHand AS EX_CC,
		W2.OnHand AS EX_ST,
		W3.OnHand AS EX_CA,
		W1.OnOrder AS OC
from ITT1 
inner join OITM A3 on ITT1.Father = A3.ItemCode
inner join OITM A1 on ITT1.Code = A1.ItemCode
Inner join OITW W1 on A1.ItemCode = W1.ItemCode and W1.WhsCode='AMP-CC' 
Inner join OITW W2 on A1.ItemCode = W2.ItemCode and W2.WhsCode='AMP-ST' 
Inner join OITW W3 on A1.ItemCode = W3.ItemCode and W3.WhsCode='APG-PA' 
where ITT1.Father = @Codigo
Order By MATERIAL

PRINT 'Reporte del: CODIGO ' + Cast(@Codigo as varchar(10)) + ' Por  ' + cast(@Cantid as varchar (10))
