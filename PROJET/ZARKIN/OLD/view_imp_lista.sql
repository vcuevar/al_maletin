USE [SALOTTO]
GO

/****** Object:  View [dbo].[View_Imp_Lista]    Script Date: 05/17/2021 09:33:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[View_Imp_Lista]
AS
SELECT     dbo.OITT.Code, OITM_1.U_CodAnt,
                          (SELECT     ItemName
                            FROM          dbo.OITM
                            WHERE      (ItemCode = dbo.OITT.Code)) AS descripcion, OITM_1.ItemCode, OITM_1.ItemName, dbo.ITT1.Quantity, OITM_1.AvgPrice, OITM_1.InvntryUom, dbo.[@PL_RUTAS].Name AS Estacion, 
                      OITM_1.LastPurCur, dbo.ITT1.U_SubEns, OITM_1.ItmsGrpCod, dbo.OCRD.CardName AS Proveedor, OITM_1.QryGroup29, OITM_1.QryGroup30, OITM_1.QryGroup31, OITM_1.QryGroup32
FROM         dbo.OITT INNER JOIN
                      dbo.ITT1 ON dbo.OITT.Code = dbo.ITT1.Father INNER JOIN
                      dbo.OITM AS OITM_1 ON dbo.ITT1.Code = OITM_1.ItemCode LEFT OUTER JOIN
                      dbo.[@PL_RUTAS] ON OITM_1.U_estacion = dbo.[@PL_RUTAS].Code LEFT OUTER JOIN
                      dbo.OCRD ON OITM_1.CardCode = dbo.OCRD.CardCode

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "OITT"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ITT1"
            Begin Extent = 
               Top = 6
               Left = 265
               Bottom = 114
               Right = 454
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OITM_1"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "@PL_RUTAS"
            Begin Extent = 
               Top = 114
               Left = 265
               Bottom = 234
               Right = 463
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OCRD"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Imp_Lista'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Imp_Lista'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Imp_Lista'
GO

