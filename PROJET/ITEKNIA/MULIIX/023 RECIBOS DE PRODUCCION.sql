-- Nombre: 023 Recibos de Producion (Montar en Macro)
-- Objetivo: Mostrar la producion ingresada al Almacen de PT.
-- Desarrollo: Ing. Vicente Cueva Ramírez.
-- Actualizado: Miercoles 07 de Septiembre del 2022; Origen

-- Parametros 
Declare @FechaIS as nvarchar(30)
Declare @FechaFS as nvarchar(30)

Set @FechaIS = CONVERT (DATE, '2023/06/23', 102)
Set @FechaFS = CONVERT (DATE, '2023/06/23', 102)

-- Desarrollo de la Consulta.

Select BOR_BultoOTReciboId AS IDE 
		, Cast(BOR_FechaRecibo As Date) AS FECH_RECIBO
        , BUL_NumeroBulto AS BULTO
        , OT_Codigo AS NUM_OT
        , OV_CodigoOV AS OV
        , PRY_CodigoEvento + '   ' + PRY_NombreProyecto AS PROYECTO
        , ART_CodigoArticulo + '  ' + ART_Nombre AS ARTICULO
        , BOR_Cantidad AS CANT_RECIBIDA
        , OVD_PrecioUnitario AS PRECIO
        , MON_Abreviacion AS MONEDA  
        , OV_MONP_Paridad AS PARIDAD
        , BOR_Cantidad * OVD_PrecioUnitario * OV_MONP_Paridad AS IMPORTE_MX
        , EMP_CodigoEmpleado + '  ' +  EMP_Nombre + '  ' + EMP_PrimerApellido AS RECIBIO        
from BultoOTRecibo
Inner Join Bultos on BOR_BUL_BultoId = BUL_BultoId
Inner Join OrdenesTrabajo on BOR_OT_OrdenTrabajoId = OT_OrdenTrabajoId
Inner Join Articulos on BOR_ART_ArticuloId = ART_ArticuloId
Inner Join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = OT_OrdenTrabajoId
Inner Join OrdenesVentaDetalle on OTRE_OV_OrdenVentaId = OVD_OV_OrdenVentaId and OVD_ART_ArticuloId = ART_ArticuloId
Inner join OrdenesVenta on OVD_OV_OrdenVentaId = OV_OrdenVentaId
Inner Join Monedas on MON_MonedaId = OV_MON_MonedaId
Inner Join Proyectos on PRY_ProyectoId = OV_PRO_ProyectoId
Inner Join Empleados on EMP_EmpleadoId = BOR_EMP_CreadoPorId
where Cast(BOR_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS --and BUL_NumeroBulto BETWEEN '12019' and '12148'
order by Cast(BOR_FechaRecibo As Date), BUL_NumeroBulto


/*
Select * from BultoOTRecibo 
Inner Join Bultos on BOR_BUL_BultoId = BUL_BultoId
where Cast(BOR_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS
*/


-- Para montar en la Macro
/*
Select Cast(BOR_FechaRecibo As Date) AS FECH_RECIBO, BUL_NumeroBulto AS BULTO, OT_Codigo AS NUM_OT, OV_CodigoOV AS OV, PRY_CodigoEvento + '   ' + PRY_NombreProyecto AS PROYECTO, ART_CodigoArticulo + '  ' + ART_Nombre AS ARTICULO, BOR_Cantidad AS CANT_RECIBIDA, OVD_PrecioUnitario AS PRECIO, MON_Abreviacion AS MONEDA, OV_MONP_Paridad AS PARIDAD, BOR_Cantidad * OVD_PrecioUnitario * OV_MONP_Paridad AS IMPORTE_MX, EMP_CodigoEmpleado + '  ' +  EMP_Nombre + '  ' + EMP_PrimerApellido AS RECIBIO from BultoOTRecibo Inner Join Bultos on BOR_BUL_BultoId = BUL_BultoId Inner Join OrdenesTrabajo on BOR_OT_OrdenTrabajoId = OT_OrdenTrabajoId Inner Join Articulos on BOR_ART_ArticuloId = ART_ArticuloId Inner Join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = OT_OrdenTrabajoId Inner Join OrdenesVentaDetalle on OTRE_OV_OrdenVentaId = OVD_OV_OrdenVentaId and OVD_ART_ArticuloId = ART_ArticuloId
Inner join OrdenesVenta on OVD_OV_OrdenVentaId = OV_OrdenVentaId Inner Join Monedas on MON_MonedaId = OV_MON_MonedaId Inner Join Proyectos on PRY_ProyectoId = OV_PRO_ProyectoId Inner Join Empleados on EMP_EmpleadoId = BOR_EMP_CreadoPorId where Cast(BOR_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS 
*/




/*

-- Consulta inicial no funciono.
Select	'VAL_REG' AS VAL_RBV
        , OTR_FechaUltimaModificacion AS F_RECIBO
        , OT_Codigo AS NUM_OT
        , ISNULL((Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = PR_ID ), 'SIN_RELACION') AS PROYECTO
        , ISNULL((Select ART_CodigoArticulo + '   ' + ART_Nombre from Articulos Where ART_ArticuloId = AR_ID), 'SIN RELACION') AS ARTICULO
        , OTRD_CantidadRecibo AS CANT
        , ISNULL(OV_CD, 'SIN RELACION') AS OV_RBV
        , ISNULL((Select OVR_PrecioUnitario 
from OrdenesVentaReq 
where OVR_OVDetalleId = OVD_ID), PRE_OV) AS P_VENTA

, ISNULL((Select MON_Nombre from Monedas Where MON_MonedaId = MON_OV),'S/REL') AS MONEDA
, ISNULL((Select OV_MONP_Paridad from OrdenesVenta where OV_OrdenVentaId = OV_ID), TCA_OV) AS PARIDAD 
from OrdenesTrabajoRecibo 

inner join OrdenesTrabajoReciboDetalle on OTR_OrdenTrabajoReciboId = OTRD_OTR_OrdenTrabajoReciboId
inner join OrdenesTrabajo on OTR_OT_OrdenTrabajoId = OT_OrdenTrabajoId 
left join RBV_OT on OTR_OT_OrdenTrabajoId = OT_ID 

where Cast(OTR_FechaUltimaModificacion As Date) BETWEEN @FechaIS and @FechaFS 
Order by Cast(OTR_FechaUltimaModificacion As Date)
*/



-- Cambio de Fecha a Esta Produccion por ser pruebas para embarques se cambia a 31/12/2020
/*
Select * from BultoOTRecibo Where BOR_BultoOTReciboId = '0364C4C5-299C-41D0-984C-D2CA18B60630'

UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '0364C4C5-299C-41D0-984C-D2CA18B60630'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '0364C4C5-299C-41D0-984C-D2CA18B60630'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'A10CDBDB-AF59-4F28-9AA6-E11FAC125C4F'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '2EAC6805-EEDF-44A2-97EF-637E801CD012'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '08857DF8-C5FB-4A11-9A48-79A5FE1E2C44'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'F01444DF-1C87-469F-B43F-F82374CAF674'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'BC4F0CC8-B4F8-4F2D-A3EA-E27204D33598'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'AA7D2BE4-EE7A-4247-850B-94D9EE48C0C7'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'A93859C3-6390-4882-BDB5-1D8693EEA019'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'FB589221-BCA6-42EE-A6D8-3BCC2D336FBD'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '93616D24-0B65-4DCE-90BF-8ED6FEF48853'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '6A7C527C-ECCF-4915-B37E-6ECE6E8253BC'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '319BB1D1-7B91-4ED2-8C86-0D5202742F25'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'C49B723A-4E48-4CA5-93F6-DD2429109773'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '8796CB03-9FF8-431C-9FF0-8FFBB5125626'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '222A0683-6037-4E1D-8B98-C14C14F28C3E'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '1305202A-E53F-4A48-BDA9-EA6D2298BB9B'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '82C5922F-B85B-4F8D-A27F-EAFA1B0209F2'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '9966A586-89F6-4363-B597-C0DF8A2FCA65'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '81DFECFE-AB46-42C8-AE7A-7BD705E081A3'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '11C957F2-D2B0-4ADB-9257-68114C78A972'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'A89503DF-0910-407C-9DFF-3DA43FCE8286'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '12D46673-3AAC-48E1-B454-6C933D55465F'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'C220194D-6B09-46EA-A9FE-0FF53BD9C955'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '2CCF07F7-2187-4C30-B3EC-91212123CE3C'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'E60352BA-9E29-4527-9F3D-B50E2D413B62'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '378AE3C6-EB65-4742-B031-D8806FB1133E'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '094B8C22-58B6-489D-824F-DD0E6C323589'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '27E44EBF-E41B-4298-861D-0700FC02FD73'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'C87C7665-DE5B-4459-9E60-FF05E06F21EA'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'B3BCCB9B-3C91-40DF-9AB7-FB429BD617DB'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'DE5134B1-1818-4097-A8C9-5B9E568C6AA5'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '3F535942-B9C4-4E79-955B-0018418637B6'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'E3D141C3-801C-4967-B4F0-C627D1DAB045'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '6B62CF86-2A70-4CE1-AFFA-A17EE72DD5DF'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'F1DFF5E8-4AAD-477E-8378-4F105B624E41'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '1D1CEBC5-CC24-4323-94D6-5BFEFBEB8042'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'C71B54B7-9F6D-46A2-8DD4-5E2583134E5F'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'B0982233-DF56-4396-A645-EF9E77C12132'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'CF565916-7D30-423F-A726-0EBF23B07A23'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '8020FF57-3E18-4F73-B35C-BBEBDD5BC41B'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'A6A2B288-F64D-44BF-A5A0-9951A3A51A31'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '495C0421-FFE8-4101-86FB-3F7310E2E88E'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '730F614E-D1C6-458B-8165-A9CF25F8C990'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'B922E064-8F71-498B-A99A-4D4AE68F1BE6'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '383B9783-9FA4-474C-9A52-DAEA47ADE394'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '91C9342A-3585-4B89-A129-55C64D477059'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '0F1FED13-2224-4B00-9F1F-5347B00D9991'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '2BE1F406-F992-43C1-8887-6B4D568BA820'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'FC896AB0-19BD-4F30-B892-6C856E67171A'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'C1416C34-C6E7-4330-A06F-AA23D6718552'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '325C2DE6-00AB-4BB4-B99C-9CF9F000BC1B'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '0D274662-C82B-4A8C-B632-6674CCAC5E9F'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'CFD133B7-D7EE-4299-BD32-1AF2E916D38F'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'EA1A77F0-E98F-483F-8113-16A760F44A5C'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'D598BDD0-CB36-45C2-98B3-81A9504E5778'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '75DCAF03-9E81-487D-9004-C523F299E397'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '68F54B8C-3026-44C1-BE6B-506D426B509E'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'D2C5D7B5-F27E-4C69-BEBF-88AE88B59908'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '428CA399-62A5-4321-9B2A-FB93BE4966D3'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '6720D76A-1391-45BD-8376-5E785E84EE5C'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'A00BECCA-CCC3-4CA2-A40D-D43B48539720'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'E92D8EC4-E2B3-488D-B2E6-52D736C00C4E'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '0419664A-1474-4A9D-BF04-AD412F62C7C5'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'EB332B17-88DA-4EF7-B447-9A4EF75E13E1'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '669A3CC9-542D-430B-B0B7-B251D4BF278B'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'D17AC7F8-A916-42A5-8670-E9F2BCD336A2'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'A3F70A93-54B1-4DA1-AB46-2D455C01350B'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '4A577026-7F33-4007-8EDF-B65CA062F724'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '0761C3C6-25A8-43E9-9774-60E5A4719E53'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'E7786BB3-7DEF-4C56-958C-613C5CE34868'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '5C4D9D24-93AB-48F5-812E-A9D60E56068C'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '56AB4950-CEA7-4745-8601-AEAEA6D8A9E7'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'E263F8DF-DFE6-4B91-B95B-F2205F92CCF6'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '3275B720-A619-4D27-8E91-E4A92A4E6D0B'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '8B0872A4-3AD3-4ACC-B43F-8A3D9454A13F'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '43035F19-DEB9-412F-B27E-CACF91011155'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '4FAF0BE3-500F-41DA-9101-C293EE716C84'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '9802A3B6-9896-4861-9D2D-39196FEC2D17'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'D786F290-1875-4C5A-B754-44F785507253'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '72890BF3-217E-4937-8EA9-6B8D05613C10'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'E8721612-BAD7-4EF8-8175-D7D0722238AA'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '476B70E3-A4DD-448F-A176-49BEAEEA6DD9'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '2170D1AF-B972-4AD7-9EF2-2CCADADC202E'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'C8FBCA52-9308-42A5-81D8-7FA073FCF3C2'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '28AC18FF-9A9D-419C-97BD-0B83790AD5C2'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'F3A5AA19-1A07-48E2-8530-D1E892E21379'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'DF4CB781-7724-4FEF-943D-F272854EEF35'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '70C6B458-94D5-4B39-ADC9-6DA025F5CBA9'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'C41F334D-5C04-40CA-843B-A419C4214979'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '83B7C528-5525-48A0-A124-C2AAE5ACB24B'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'D32CCBEA-5774-4BF7-A1F3-89B24E5806F4'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '119A38B8-2BE7-4F72-B3BC-97380A46196C'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '3964F436-CFA9-4C46-AEFC-1A60FCCC0FC5'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '622BB4D8-EEBB-4276-AB30-BC1903F5B58D'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '13E297F9-2671-43BD-ABF2-7ED51E81F8DE'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '6BB682DB-7FD8-4702-9627-1BF9FFA62B17'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'E0AEC162-75E0-4B20-842A-F2A568E08A7F'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '04EEB554-A09A-4D88-8A33-F836806907DE'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '1F0F914C-846B-40FB-9A4E-518B378C8584'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '8F2F41EB-9590-4F94-A4DB-D149CAEA4A3E'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '828FD993-380F-421C-A237-9E2301E91074'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'AFA2847A-59C0-4D09-AFAD-1709CF7A7615'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'D2420DCC-A195-4AA8-8DCE-317807FA0973'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '02898E02-2F88-4808-B97A-730E9BCD09F9'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '07FEF2FA-2838-454B-A24D-93FFD08FEB33'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '2CAB8280-0F3B-4FCA-AF63-957AA489A946'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '177CAE7B-3DF1-4E61-B971-5C9EABE07420'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'A1670652-7BFA-453D-9808-BE740D6A3084'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'FAE15AB1-F933-4758-B228-1F3D0584F24C'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'B23B71AD-7441-4F23-9DD2-E5975347C208'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '733DF9B4-0AD3-4D87-868F-F4C51B13A721'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '26EC0D1B-A9D2-4DB8-97B8-C80847761109'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '651A23C7-A4AD-4C7B-9F50-DF2EE13CC146'

UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'A48FCC9E-A431-4446-B3EF-E6FEC4BD4BF0'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '8B169698-8FF6-409A-BF56-3ACF2FDB1FD8'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '48D7BC69-00C1-4D7C-92DC-C36F96A12880'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '7C363E34-46A3-43B3-9287-F35477B6569B'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '034095C5-F9AB-4792-8F9E-182116D8735C'
UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = 'C78FEB23-0BFE-48CE-94C7-0972CB1EA526'


UPDATE BultoOTRecibo SET BOR_FechaRecibo = Cast('2020/12/31' as date) Where BOR_BultoOTReciboId = '2CFBF869-FA17-456A-8707-AC6518EED3DF'

*/



