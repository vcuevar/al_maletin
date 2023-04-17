SELECT GETDATE() AS fechaDeEjecucion,
       Descr,
       Itemcode,
       ItemName,
       UM,
       ExistGDL,
       ExistLERMA,
       WIP,
       semana,
       semana_c,
       Cant,
       queryview.OC,
       Reorden,
       Minimo,
       Maximo,
       TE,
       Costo,
       Moneda,
       Proveedor,
       Comprador,
       queryview.U_C_Orden
FROM
  (------------------------------------------------------------------------
 SELECT tf.Descr,
        CASE
            WHEN tf.U_C_Orden = 'S' THEN 'C'
            ELSE tf.U_C_Orden
        END AS U_C_Orden,
        tf.ItemCode,
        ItemName,
        tf.UM,
        tf.A_Gdl AS ExistGDL,
        tf.A_Lerma AS ExistLERMA,
        tf.WIP,
        tf.Costo,
        tf.Moneda,
        tf.Proveedor,
        tf.Comprador,
        Reorden,
        Maximo,
        Minimo,
        semana,
        semana_c,
        sum(Cant) Cant,
        TE,
        ordenes.oc AS OC
   FROM
     (-------------------------------------------------------------------------
--ACTUALIZACION 19/06/2019 ALBERTO MEDINA
-- CUANDO UNA ORDEN TENGA CONSUMIDA PIEL NO DEBE CONTARSE/SUMARSE LA DIFERENCIA COMO "CANTIDAD" VÁLIDA, *SOLO PIELES
SELECT mrp_g.docEntry,
       mrp_g.Descr,
       mrp_g.U_C_Orden,
       ItemCode,
       ItemName,
       mrp_g.UM,
       mrp_g.A_Gdl,
       mrp_g.A_Lerma,
       mrp_g.WIP, --Sum(Cantidad) as Cant , IssuedQty,
 semana,
 semana_c,
 SUM(CASE
         WHEN CONSUMO_PIEL > 0 THEN 0
         ELSE CASE
                  WHEN CONSUMOS_MP > 0 THEN CASE
                                                WHEN (Cantidad - CONSUMOS_MP) > 0 THEN (Cantidad - CONSUMOS_MP)
                                                ELSE 0
                                            END
                  ELSE Cantidad
              END
     END) AS Cant,
 mrp_g.Price AS Costo,
 mrp_g.Currency AS Moneda,
 CASE
     WHEN mrp_g.CardName IS NULL THEN 'No definido'
     ELSE mrp_g.CardName
 END AS Proveedor,
 CASE
     WHEN mrp_g.Comprador IS NULL THEN 'No definido'
     ELSE mrp_g.Comprador
 END AS Comprador,
 Reorden,
 Maximo,
 Minimo,
 CASE
     WHEN TE IS NULL THEN 0
     ELSE TE
 END AS TE
      FROM
        (--------------------------------------------------------------------------
 SELECT View_MRP2017_2.DocEntry, --(select top 1 ItemName from OITM oo where oo.itemCode = OWOR.itemCode) as nombreOP,
 -- DueDate as FechaFin,
 OITM.NumInBuy CONVERSION, --case when @optionsemana = 'c' then View_MRP2017_2.semana_c else View_MRP2017_2.semana_p end as semana,
 View_MRP2017_2.semana_c,
 View_MRP2017_2.semana_p AS semana, -- View_MRP2017_2.semana_c as semana,
 View_MRP2017_2.U_C_Orden,
 View_MRP2017_2.ItemCode,
 View_MRP2017_2.ItemName, --View_MRP2017_2.WIP, View_MRP2017_2.Exist_Gdl,
 --View_MRP2017_2.Exist_Lerma,
 ALMACENES.A_Gdl,
 ALMACENES.A_Lerma,
 ALMACENES.WIP,
 View_MRP2017_2.PlannedQty * View_MRP2017_2.Cantidad AS Cantidad,
 OCRD.CardName,
 OITM.InvntryUom AS UM,
 UFD1.Descr,
 UF.Descr AS Comprador,
 OITM.U_ReOrden AS Reorden,
 OITM.U_Minimo AS Minimo,
 OITM.U_Maximo AS Maximo,
 OITM.LeadTime AS TE,
 ITM1.Price,
 ITM1.Currency,
 COALESCE(IssuedQty, 0) AS CONSUMO_PIEL,
 COALESCE(CONSUMO_MP.Entregado, 0) AS CONSUMOS_MP
         FROM ----------------------------------------------------------------------------------
 View_MRP2017_2
         INNER JOIN
           (SELECT ItemCode,
                   SUM(CASE
                           WHEN WhsCode = 'AMP-ST'
                                OR WhsCode = 'AMP-CC'
                                OR WhsCode = 'AMP-TR'
                                OR WhsCode = 'AXL-TC'
                                OR WhsCode = 'APG-PA' THEN OnHand
                           ELSE 0
                       END) AS A_Lerma,
                   SUM(CASE
                           WHEN WhsCode = 'AMG-ST'
                                OR WhsCode = 'AMG-CC' THEN OnHand
                           ELSE 0
                       END) AS A_Gdl,
                   SUM(CASE
                           WHEN WhsCode = 'APP-ST'
                                OR WhsCode = 'APT-PA'
                                OR WhsCode = 'APG-ST' THEN OnHand
                           ELSE 0
                       END) AS WIP
            FROM dbo.OITW
            GROUP BY ItemCode) AS ALMACENES ON View_MRP2017_2.ItemCode = ALMACENES.ItemCode
         LEFT JOIN OITM ON OITM.ItemCode = View_MRP2017_2.ItemCode
         LEFT JOIN ITM1 ON ITM1.ItemCode = OITM.ItemCode
         AND ITM1.PriceList = 9 --se cambio la lista 10 (equivale a 1) por la de A COMPRAS (equivale a 9)
 --					AND POR1.OpenQty > 0

         LEFT JOIN OCRD ON OCRD.CardCode = OITM.CardCode
         LEFT JOIN UFD1 ON UFD1.FldValue = OITM.U_GrupoPlanea
         AND UFD1.TableID = 'UITM'
         AND UFD1.FieldID = 9
         LEFT OUTER JOIN dbo.UFD1 AS UF ON OITM.U_Comprador = UF.FldValue
         AND UF.TableID = 'OITM'
         LEFT JOIN OWOR ON OWOR.DocEntry = View_MRP2017_2.DocEntry
         LEFT JOIN
           (SELECT IssuedQty,
                   w.DocEntry,
                   w.ItemCode
            FROM WOR1 w
            INNER JOIN OITM i ON i.ItemCode = w.ItemCode
            WHERE ItmsGrpCod = '113') AS PIEL ON PIEL.DocEntry = View_MRP2017_2.DocEntry
         AND PIEL.ItemCode = View_MRP2017_2.ItemCode --Aquitoy

         LEFT JOIN
           (SELECT OW.ItemCode,
                   BO.OP,
                   sum(OW.IssuedQty) AS Entregado
            FROM Vw_BackOrderExcel BO
            INNER JOIN WOR1 OW ON BO.OP = OW.DocEntry
            INNER JOIN OITM A1 ON OW.ItemCode = A1.ItemCode
            WHERE BO.U_Starus = '06'
              AND A1.ItmsGrpCod <> 113
              AND OW.IssuedQty > 0 --and BO.CODIGO <> '17814' --AND OP = '29401'

            GROUP BY OW.ItemCode,
                     BO.OP) AS CONSUMO_MP ON CONSUMO_MP.OP = View_MRP2017_2.DocEntry
         AND CONSUMO_MP.ItemCode = View_MRP2017_2.ItemCode
         WHERE --View_MRP2017_2.ItemCode = '10428' and
 -- View_MRP2017_2.itemName  like 'HE  ZADIK -2BI-%' and
 (View_MRP2017_2.Status = 'R'
  OR View_MRP2017_2.Status = 'P')
           AND ((OITM.QryGroup29 = 'N')
                OR (OITM.QryGroup30 = 'N')
                OR (OITM.QryGroup31 = 'N')
                OR (OITM.QryGroup32 = 'N'))--and (View_MRP2017_2.ItemCode = '17242' or View_MRP2017_2.ItemCode = '17243')
 --and View_MRP2017_2.docEntry = '75113'
 --AND POR1.OpenQty > 0

         GROUP BY PIEL.IssuedQty,
                  CONSUMO_MP.Entregado,
                  View_MRP2017_2.semana_c,
                  View_MRP2017_2.semana_p,
                  View_MRP2017_2.U_C_Orden,
                  View_MRP2017_2.ItemCode,
                  View_MRP2017_2.ItemName,
                  ALMACENES.WIP,
                  ALMACENES.A_Gdl,
                  ALMACENES.A_Lerma,
                  OITM.itemCode,
                  OCRD.CardName,
                  UFD1.Descr,
                  UF.Descr,
                  OITM.InvntryUom,
                  OITM.U_ReOrden,
                  OITM.U_Minimo,
                  OITM.U_Maximo,
                  OITM.LeadTime,
                  ITM1.Price,
                  ITM1.Currency,
                  View_MRP2017_2.DocEntry,
                  View_MRP2017_2.Cantidad,
                  View_MRP2017_2.PlannedQty,
                  OITM.NumInBuy ,
                  OWOR.ItemCode,
                  DueDate)AS mrp_g --LEFT JOIN OPOR ON OPOR.DocEntry = mrp_g.DocEntry
 --where ItemCode = '19328' --PIEL 0403 BUCK OFF WHITE.

      GROUP BY mrp_g.Conversion,
               U_C_Orden,
               mrp_g.ItemCode,
               mrp_g.ItemName,
               mrp_g.A_Gdl,
               mrp_g.A_Lerma,
               WIP,
               mrp_g.Descr,
               mrp_g.Comprador,
               mrp_g.UM,
               mrp_g.CardName,
               mrp_g.Reorden,
               mrp_g.Minimo,
               mrp_g.Maximo,
               mrp_g.TE,
               mrp_g.Price,
               mrp_g.Currency,
               mrp_g.semana,
               mrp_g.semana_c,
               mrp_g.DocEntry --FIN ACTUALIZACION 19/06/2019
 )AS tf
   LEFT JOIN
     (SELECT POR1.itemCode,
             SUM(OITM.NumInBuy * POR1.OpenQty) AS oc
      FROM OPOR
      INNER JOIN POR1 ON OPOR.DocEntry = POR1.DocEntry
      LEFT JOIN OITM ON POR1.ItemCode = OITM.ItemCode
      WHERE POR1.LineStatus <> 'C'
      GROUP BY POR1.ItemCode)AS ordenes ON ordenes.ItemCode = tf.ItemCode
   GROUP BY tf.Descr,
            U_C_Orden,
            tf.ItemCode,
            tf.ItemName,
            tf.A_Gdl,
            tf.A_Lerma,
            WIP,
            tf.Descr,
            tf.Comprador,
            tf.UM,
            tf.Reorden,
            tf.Minimo,
            tf.Maximo,
            tf.TE,
            tf.Costo,
            tf.Moneda,
            tf.Proveedor,
            semana,
            semana_c,
            ordenes.oc)AS queryview
GROUP BY queryview.Descr,
         queryview.Itemcode,
         queryview.ItemName,
         queryview.UM,
         queryview.ExistGDL,
         queryview.ExistLERMA,
         queryview.WIP,
         queryview.Costo,
         queryview.Moneda,
         queryview.Proveedor,
         queryview.Comprador,
         queryview.Reorden,
         queryview.Maximo,
         queryview.Minimo,
         queryview.TE,
         queryview.OC,
         semana,
         semana_c,
         Cant,
         queryview.U_C_Orden