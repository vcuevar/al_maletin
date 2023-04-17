-- Consulta para Generar Explosion de los Herrajes detallada.
-- Ing. Vicente Cueva R.
-- Solicitado: Lunes 18 de Junio del 2018.
-- Inicio: Viernes 29 de Junio del 2018. 

DECLARE @FechaIS date
DECLARE @FechaFS date
DECLARE @Grupo nvarchar(20)
DECLARE @Codigo nvarchar(20)

--Parametros Fecha Inicial y Fecha Final
Set @FechaIS = CONVERT (DATE, '2018-04-16', 102)
Set @FechaFS = CONVERT (DATE, '2018-04-16', 102) 
Set @Grupo  = '7'
Set @Codigo = '3718-36-P'
Set @Codigo = @Codigo + '%'

 -- Catalogo de Grupos de Planeación
-- select * from UFD1 where UFD1.TableID='OITM' and UFD1.FieldID=19 and UFD1.FldValue = '7'
-- Piel 9, Metales 7, Tornillos 17

--Determina el codigo de la Funda
Set @Codigo = (Select top 1 * from OITM where OITM.ItemCode like @Codigo order by OITM.ItemCode)

PRINT 'Ingresado: CODIGO ' + cast(@CODI as varchar(10))  + '  ' + cast(@NAME as varchar (50))

-- Determina los articulos con lista de Materiales
Select * from ITT1 where ITT1.Father = @Codigo

/*
SELECT        dbo.OITT.Code, OITM_1.U_CodAnt,
                             (SELECT        ItemName
                               FROM            dbo.OITM
                               WHERE        (ItemCode = dbo.OITT.Code)) AS descripcion, OITM_1.ItemCode, OITM_1.ItemName, dbo.ITT1.Quantity, OITM_1.AvgPrice, OITM_1.InvntryUom, dbo.[@PL_RUTAS].Name AS Estacion, 
                         OITM_1.LastPurCur, dbo.ITT1.U_SubEns, OITM_1.ItmsGrpCod, dbo.OCRD.CardName AS Proveedor, OITM_1.QryGroup29, OITM_1.QryGroup30, OITM_1.QryGroup31, OITM_1.QryGroup32
FROM            dbo.OITT INNER JOIN
                         dbo.ITT1 ON dbo.OITT.Code = dbo.ITT1.Father INNER JOIN
                         dbo.OITM AS OITM_1 ON dbo.ITT1.Code = OITM_1.ItemCode LEFT OUTER JOIN
                         dbo.[@PL_RUTAS] ON OITM_1.U_estacion = dbo.[@PL_RUTAS].Code LEFT OUTER JOIN
                         dbo.OCRD ON OITM_1.CardCode = dbo.OCRD.CardCode


*/

