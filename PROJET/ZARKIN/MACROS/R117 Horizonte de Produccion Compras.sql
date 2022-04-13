-- Consulta para Reporte 114 Saldos de Cuentas Contables.
-- Elaborado: Ing. Vicente Cueva Ramírez.
-- Actualizado: Lunes 12 de Abril del 2021; Origen

-- Parametros Fecha Inicial y Final


Declare @Anio as Int            
Set @Anio = (CONVERT(int, SUBSTRING(CAST(DATEPART(YY, GETDATE ()) AS varchar(4)), 3, 2))) * 100 

SELECT U_Starus, SUM(VENCIDOS) AS VENCIDOS, SUM(semanaA) AS SemanaA, SUM(semana1) AS Semana1, SUM(semana2) AS Semana2, SUM(semana3) AS Semana3, SUM(semana4) AS Semana4
, SUM(semana5) AS Semana5, SUM(semana6) AS Semana6, SUM(semana7) AS Semana7, SUM(semana8) AS Semana8, SUM(semana9) AS Semana9, SUM(semana10) AS Semana10
, SUM(semana11) AS Semana11, SUM(semana12) AS Semana12, SUM(semana13) AS Semana13, SUM(semana14) AS Semana14, SUM(semana15) AS Semana15, SUM(semana16) AS Semana16
, SUM(semana17) AS Semana17, SUM(semana18) AS Semana18, SUM(semana19) AS Semana19, SUM(semana20) AS Semana20, SUM(semana21) AS Semana21, SUM(semana22) AS Semana22
FROM (
SELECT	BP.U_Starus  
		, CASE WHEN BP.SEMANA4  < (@Anio +  DATEPART(iso_week, GETDATE())) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END AS VENCIDOS
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(iso_week, GETDATE())) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END AS semanaA
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 1, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana1
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 2, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana2
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 3, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana3
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 4, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana4
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 5, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana5
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 6, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana6
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 7, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana7
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 8, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana8
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 9, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana9
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 10, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana10
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 11, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana11
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 12, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana12
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 13, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana13
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 14, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana14
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 15, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana15
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 16, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana16
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 17, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana17
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 18, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana18
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 19, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana19
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 20, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana20
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 21, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana21
		, CASE WHEN BP.SEMANA4  = (@Anio +  DATEPART(ISO_WEEK, DATEADD(week, 22, GETDATE()))) THEN SUM(BP.Cantidad * BP.VSInd) ELSE 0 END semana22
FROM dbo.VwBackOrderProgramadoOP AS BP
GROUP BY BP.U_Starus, SEMANA4
) AS T0
GROUP BY U_Starus 

    





/*

 --Anio, semana, Semana_A,, RIGHT(Anio, 1) * 100 AS Programa
  
SELECT U_Starus , SUM(VENCIDOS) AS VENCIDOS, SUM(semanaA) AS SemanaA
	,SUM(semana1) AS Semana1
	, SUM(semana2) AS Semana2, SUM(semana3) AS Semana3, SUM(semana4) AS Semana4
	, SUM(semana5) AS Semana5, SUM(semana6) AS Semana6, SUM(semana7) AS Semana7
	, SUM(semana8) AS Semana8, SUM(semana9) AS Semana9, SUM(semana10) AS Semana10
	, SUM(semana11) AS Semana11, SUM(semana12) AS Semana12
	, SUM(semana13) AS Semana13, SUM(semana14) AS Semana14, SUM(semana15) AS Semana15
	, SUM(semana16) AS Semana16, SUM(semana17) AS Semana17, SUM(semana18) AS Semana18
	, SUM(semana19) AS Semana19, SUM(semana20) AS Semana20, SUM(semana21) AS Semana21
	, SUM(semana22) AS Semana22
	, SUM(CADENAS) AS Cadenas
	, SUM(TUTTO_PELLE) AS Tutto_pelle
	, SUM(RUTAS) AS Rutas
	, SUM(CINES) AS Cines
	, SUM(RESTO) AS Resto
	--prueba AS finsemana
FROM
(

SELECT	BP.U_Starus  
		--, DATEPART(YY, GETDATE()) AS Anio
		--, DATEPART(iso_week, GETDATE()) AS Semana_A
		--, CONVERT(int, SUBSTRING(CAST(DATEPART(YY, GETDATE ()) AS varchar(4)), 3, 2)) * 100 + DATEPART(iso_week, GETDATE() )  as semana
		--, (CONVERT(int, SUBSTRING(CAST(DATEPART(YY, GETDATE ()) AS varchar(4)), 3, 2)) * 100 + DATEPART(iso_week, GETDATE() )) + 11 AS ssm
		--, CONVERT(int, SUBSTRING(CAST(DATEPART(YY, '2013/12/31') AS varchar(4)), 3, 2)) * 100 + DATEPART(iso_week, '2013/12/31') As fss
		-- , CONVERT(int, SUBSTRING(CAST(DATEPART(YY, GETDATE ()) AS varchar(4)), 3, 2)) * 100 + 101 as tonces 
		--, CASE WHEN BP.OP IS NULL THEN datepart(iso_week, BP.FechaEntregaPedido) ELSE datepart(iso_week, BP.FENTREGA) END AS SEMANA_REG
		--, 7 - DATEPART(W, GETDATE()) AS Faltafinsemana
		--, GETDATE() + (7 - DATEPART(W, GETDATE())) AS Finsemana
		--, CONVERT(char, GETDATE() + (7 - DATEPART(W, GETDATE())), 103) AS prueba, BP.OP, BP.FENTREGA
		, CASE WHEN BP.SEMANA4  < (CONVERT(int, SUBSTRING(CAST(DATEPART(YY, GETDATE ()) AS varchar(4)), 3, 2)) * 100 + DATEPART(iso_week, GETDATE() ))  THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END AS VENCIDOS
		, CASE WHEN BP.SEMANA4  = (CONVERT(int, SUBSTRING(CAST(DATEPART(YY, GETDATE ()) AS varchar(4)), 3, 2)) * 100 + DATEPART(iso_week, GETDATE() ))  THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END AS semanaA
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 1, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 1, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana1
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 2, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 2, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana2
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 3, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 3, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana3
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 4, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 4, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana4
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 5, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 5, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana5
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 6, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 6, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana6
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 7, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 7, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana7
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 8, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 8, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana8 
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 9, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 9, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana9
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 10, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 10, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana10
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 11, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 11, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana11
        , CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 12, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 12, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana12
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 13, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 13, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana13
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 14, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 14, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana14
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 15, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 15, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana15
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 16, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 16, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana16
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 17, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 17, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana17
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 18, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 18, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana18
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 19, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 19, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana19
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 20, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 20, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana20
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 21, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 21, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana21
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 22, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 22, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana22

		

		, CASE OCRG.GroupName WHEN 'CADENAS' THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END AS CADENAS
		, CASE OCRG.GroupName WHEN 'TUTTO PELLE' THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END AS TUTTO_PELLE
		, CASE OCRG.GroupName WHEN 'RUTAS' THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END AS RUTAS
		, CASE OCRG.GroupName WHEN 'PROYECTOS' THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END AS CINES
		, CASE WHEN (OCRG.GroupName <> 'CADENAS' AND OCRG.GroupName <> 'TUTTO PELLE' AND OCRG.GroupName <> 'RUTAS' AND 
          OCRG.GroupName <> 'PROYECTOS') THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END AS RESTO
		 --, CASE WHEN OP IS NULL AND Tipo = 'W' THEN 'S' ELSE 'N' END AS QUITAR
FROM dbo.SIZ_View_ReporteBO AS BP 
INNER JOIN dbo.OCRD AS O ON BP.CODIGO_CLIENTE = O.CardCode 
LEFT OUTER JOIN dbo.OCRG ON O.GroupCode = dbo.OCRG.GroupCode
WHERE (BP.OP IS NOT NULL)
GROUP BY BP.U_Starus, SEMANA4, OCRG.GroupName 

--DATEPART(iso_week, BP.FechaEntregaPedido), BP.OP, 
--BP.FENTREGA, BP.Cant, BP.Tipo, SEMANA4 


) AS T0
--WHERE (QUITAR = 'N')
GROUP BY U_Starus --, semana, Semana_A, Anio, prueba    



  SELECT BP.U_Starus  
		, DATEPART(YY, GETDATE()) AS Anio
		, DATEPART(iso_week, GETDATE()) AS Semana_A
		, CONVERT(int, SUBSTRING(CAST(DATEPART(YY, GETDATE ()) AS varchar(4)), 3, 2)) * 100 + DATEPART(iso_week, GETDATE() )  as semana
		, (CONVERT(int, SUBSTRING(CAST(DATEPART(YY, GETDATE ()) AS varchar(4)), 3, 2)) * 100 + DATEPART(iso_week, GETDATE() )) + 11 AS ssm
		, CONVERT(int, SUBSTRING(CAST(DATEPART(YY, '2013/12/31') AS varchar(4)), 3, 2)) * 100 + DATEPART(iso_week, '2013/12/31') As fss
		, CONVERT(int, SUBSTRING(CAST(DATEPART(YY, GETDATE ()) AS varchar(4)), 3, 2)) * 100 + 101 as tonces 
		--, CASE WHEN BP.OP IS NULL THEN datepart(iso_week, Cast(BP.FechaEntregaPedido as date)) ELSE datepart(iso_week, Cast(BP.FENTREGA as date)) END AS SEMANA_REG
		--, BP.FechaEntregaPedido
		, 7 - DATEPART(W, GETDATE()) AS Faltafinsemana
		, GETDATE() + (7 - DATEPART(W, GETDATE())) AS Finsemana
		, CONVERT(char, GETDATE() + (7 - DATEPART(W, GETDATE())), 103) AS prueba
		--, BP.OP
		--, BP.FENTREGA
		, CASE WHEN BP.SEMANA4  < (CONVERT(int, SUBSTRING(CAST(DATEPART(YY, GETDATE ()) AS varchar(4)), 3, 2)) * 100 + DATEPART(iso_week, GETDATE() ))  THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END AS VENCIDOS
		, CASE WHEN BP.SEMANA4  = (CONVERT(int, SUBSTRING(CAST(DATEPART(YY, GETDATE ()) AS varchar(4)), 3, 2)) * 100 + DATEPART(iso_week, GETDATE() ))  THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END AS semanaA
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 1, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 1, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana1
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 2, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 2, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana2
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 3, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 3, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana3
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 4, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 4, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana4
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 5, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 5, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana5
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 6, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 6, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana6
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 7, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 7, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana7
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 8, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 8, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana8 
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 9, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 9, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana9
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 10, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 10, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana10
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 11, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 11, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana11
        , CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 12, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 12, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana12
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 13, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 13, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana13
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 14, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 14, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana14
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 15, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 15, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana15
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 16, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 16, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana16
		, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 17, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 17, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana17
		--, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 18, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 18, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana18
		--, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 19, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 19, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana19
		--, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 20, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 20, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana20
		--, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 21, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 21, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 0 END semana21
		--, CASE WHEN BP.SEMANA4  =  (SUBSTRING( CAST(year(DATEADD(week, 22, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 22, GETDATE()))) THEN SUM(BP.Cant * BP.VSInd) ELSE 
		
		
 FROM dbo.SIZ_View_ReporteBO AS BP 
 GROUP BY BP.U_Starus, SEMANA4


 -- A lo mejor es poner la semana y despues sumar por agrupar por semanas y por estarus sacarlo por nombres.

 -- Registros = 1983 


 
SELECT	BP.COD_STUS
		, BP.ESTATUS
		, BP.SEMC 
		, SUM(BP.VS) AS TVS 
		
FROM (


SELECT	OWOR.U_Starus AS COD_STUS
		,UFD1.Descr AS ESTATUS
		, CONVERT(int, SUBSTRING(CAST(DATEPART(YY, OWOR.U_FCompras) AS varchar(4)), 3, 2)) * 100 + DATEPART(iso_week, OWOR.U_FCompras) AS SEMC
		--, CONVERT(int, SUBSTRING(CAST(DATEPART(YY, OWOR.U_FProduccion) AS varchar(4)), 3, 2)) * 100 + DATEPART(iso_week, OWOR.U_FProduccion) AS SEMC
		, (OWOR.PlannedQty-OWOR.CmpltQty) * OITM.U_VS AS VS
		, OWOR.U_FCompras
		
		, (CONVERT(int, SUBSTRING(CAST(DATEPART(YY, OWOR.U_FCompras) AS varchar(4)), 3, 2)) * 100 + DATEPART(ISO_WEEK, OWOR.U_FCompras) ) +7 AS SEMANA4
		, (CONVERT(int, SUBSTRING(CAST(DATEPART(YY, GETDATE ()) AS varchar(4)), 3, 2)) * 100 + DATEPART(iso_week, GETDATE() )) AS SEMANA
		, ((SUBSTRING( CAST(year(DATEADD(week, 1, GETDATE())) as nvarchar(5)), 3, 2) * 100 + DATEPART(ISO_WEEK, DATEADD(week, 1, GETDATE()))))+ 7 AS SEMANA1
FROM OWOR 
inner join OITM on OWOR.ItemCode = OITM.ItemCode and OITM.U_TipoMat = 'PT'
inner join UFD1 on OWOR.U_Starus = UFD1.FldValue and UFD1.TableID ='OWOR'and UFD1.FieldID = 2
Where OWOR.Status <> 'L' and OWOR.Status <> 'C' and OWOR.CmpltQty < OWOR.PlannedQty

) BP
GROUP BY BP.ESTATUS, BP.SEMC, BP.COD_STUS
ORDER BY BP.SEMC, BP.COD_STUS 

--select * from UFD1 where UFD1.TableID='OWOR' 
*/



Execute sp_DistribucionTapiceria2 3