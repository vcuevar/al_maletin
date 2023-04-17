-- Movimientos realizados para corregir Saldos de Proveedores.
-- Si hay problema con uno de ellos aplicar reversa


Use iteknia
select * from CXPPagos Where CXPP_IdentificacionPago Like '%3838860%'
Select	* from CXPPagosDetalle Where CXPPD_CXPP_PagoCXPId = 'A98731E8-B813-4886-A6D2-825E832D8A8F'



Select * from CXPPagos where CXPP_PagoCXPId = 'A98731E8-B813-4886-A6D2-825E832D8A8F'

Update CXPPagos set CXPP_Borrado = 0 where CXPP_PagoCXPId = 'A98731E8-B813-4886-A6D2-825E832D8A8F'


-- P160 TORNILLOS Y ACCESORIOS Y CONTROLES, S.A. DE C.V. 
-- Presenta un Saldo de 0.01 Entre pago y factura FM149095
Select * from CXPPagos Where CXPP_PagoCXPId = 'C28D61AB-832F-4E4C-94CA-2F09FA622307'
-- CXPP_MontoPago = 341.59
Select	* from CXPPagosDetalle Where CXPPD_DetalleId = 'A8318E5E-BAB1-4DED-90DF-21BC64E772D2'
-- CXPPD_MontoAplicado = 341.59

--Update CXPPagos Set CXPP_MontoPago = 341.60 Where CXPP_PagoCXPId = 'C28D61AB-832F-4E4C-94CA-2F09FA622307'
--Update CXPPagosDetalle Set CXPPD_MontoAplicado = 341.60 Where CXPPD_DetalleId = 'A8318E5E-BAB1-4DED-90DF-21BC64E772D2'



-- P166 SUMINISTROS DE ACERO PARA LA INDUSTRIA, S.A. DE C.V.
-- Presenta un Saldo de -114.20 Trae varias diferencias.
Select * from CXPPagos Where CXPP_PagoCXPId = '59CC0F66-C4D0-4C4C-80DA-9EA825C6F1E4'
-- CXPP_MontoPago = 1419.66
Select	* from CXPPagosDetalle Where CXPPD_DetalleId = '4AFC9368-AFB8-4119-9BFC-B4783B3A7289'
-- CXPPD_MontoAplicado = 1019.13

--Update CXPPagos Set CXPP_MontoPago = 1419.65 Where CXPP_PagoCXPId = '59CC0F66-C4D0-4C4C-80DA-9EA825C6F1E4'
--Update CXPPagosDetalle Set CXPPD_MontoAplicado = 1019.12 Where CXPPD_DetalleId = '4AFC9368-AFB8-4119-9BFC-B4783B3A7289'
 
-- P73	PROYECTA TEX S DE RL DE CV
-- Presenta un Saldo de -0.02 Un pago menor al cargo.
Select * from CXPPagos Where CXPP_PagoCXPId = '4C029171-4E75-43C5-89D7-3231CF662E8F'
-- CXPP_MontoPago = 22254.59
Select	* from CXPPagosDetalle Where CXPPD_DetalleId = '80AC5AFB-2F07-4D83-97D8-BE94AD7DE6CF'
-- CXPPD_MontoAplicado = 22254.59
Select	* from CXPPagosDetalle Where CXPPD_DetalleId = '494E8A40-2C1D-41E4-813A-7BFC6DDBEB4F'
-- CXPPD_MontoAplicado = 22254.59

--Update CXPPagos Set CXPP_MontoPago = 22254.61 Where CXPP_PagoCXPId = '4C029171-4E75-43C5-89D7-3231CF662E8F'
--Update CXPPagosDetalle Set CXPPD_MontoAplicado = 22254.61 Where CXPPD_DetalleId = '80AC5AFB-2F07-4D83-97D8-BE94AD7DE6CF'
--Update CXPPagosDetalle Set CXPPD_MontoAplicado = 22254.61 Where CXPPD_DetalleId = '494E8A40-2C1D-41E4-813A-7BFC6DDBEB4F'



Use iteknia
select * from CXPPagos Where CXPP_IdentificacionPago Like '%8229%'
Select	* from CXPPagosDetalle Where CXPPD_CXPP_PagoCXPId = 'B690E43E-714B-4536-9AA1-BF01551466DC'

 
-- P239	REPRESENTACIONES INDUSTRIALES DINAMICAS, S.A. DE C.V.
-- Presenta un Saldo de -0.02 Un pago menor al cargo.
Select * from CXPPagos Where CXPP_PagoCXPId = 'B690E43E-714B-4536-9AA1-BF01551466DC'
-- CXPP_MontoPago = 22254.59
Select	* from CXPPagosDetalle Where CXPPD_DetalleId = '94046375-F037-4C25-9B1F-15F8ABB3A1C2'
-- CXPPD_MontoAplicado = 421.52

Update CXPPagos Set CXPP_MontoPago = 421.51 Where CXPP_PagoCXPId = 'B690E43E-714B-4536-9AA1-BF01551466DC'
Update CXPPagosDetalle Set CXPPD_MontoAplicado = 421.51 Where CXPPD_DetalleId = '94046375-F037-4C25-9B1F-15F8ABB3A1C2'

