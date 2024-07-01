-- Requisicione para cambio de estatus a ordenes completadas.
-- Elaboro: Ing. Vicente Cueva Ramirez.
-- Actualizado: Lunes 10 de junio del 2024; Origen.

--Parametros Ninguno

-- Estatus Existentes para las Requisiciones.
-- CMM_CREQ_EstadoRequisicion Estatus de las Requisiciones.
--       CMM_ControlId                              CMM_Valor
'558C0ABE-D470-4F45-824D-517432EE28B2'              Detenida
'18FBCAC4-1627-4A33-A3B4-8EB8857198E1'              Abierto
'7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F'              Convertida
'61DCA51E-443E-4B94-B264-672EBAC119AE'              Convertida Parcial
'FFA62252-EEDC-45C1-BF67-D8C606709E0C'              Rechazada
'B9E414F8-9433-487B-B3C0-2CF7B024CEFB'              Cerrada Usuario
'062B2C74-E965-4F51-BA30-28608A20DAE8'              Por Autorizar        -- Validar con Francisco porque dice Autorizado

-- Excepciones para Requisiciones.
-- Las Requisiciones Detenidas de noden estar por mas de una semana detenidas o refrendar estatus.

-- DETENIDAS
-- Definir cuantos dias puede estar una Requisicion Detenida y que se hace despues de ese tiempo.

Select Cast(REQ_FechaRequisicion as DATE) AS FEC_REQ
	, REQ_CodigoRequisicion AS REQUISICION
	, REQD_DescripcionArticulo AS NOM_ITEM
	, CMM_Valor AS ESTATUS
	, Datediff(day, REQ_FechaRequisicion, getdate()) AS DIAS
	, (EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido) AS ELABORO
	, REQD_OC_OrdenCompraId AS NUM_OC
From Requisiciones
Inner join RequisicionesDetalle on REQ_RequisicionId = REQD_REQ_RequisicionId
Inner join ControlesMaestrosMultiples on REQ_CMM_EstadoRequisicionId = CMM_ControlId
Inner Join Empleados on REQ_EMP_CreadoPorId = EMP_EmpleadoId
Where REQ_Eliminado = '0' and REQ_CMM_EstadoRequisicionId = '558C0ABE-D470-4F45-824D-517432EE28B2' 
Order by REQUISICION



-- POR AUTORIZAR
-- Cuando empecemos a generar autorizaciones, se validara las que hace falta que las autorice y enviar notificacion
-- a quien las tiene que autorizar.

Select Cast(REQ_FechaRequisicion as DATE) AS FEC_REQ
	, REQ_CodigoRequisicion AS REQUISICION
	, REQD_DescripcionArticulo AS NOM_ITEM
	, CMM_Valor AS ESTATUS
	, Datediff(day, REQ_FechaRequisicion, getdate()) AS DIAS
	, (EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido) AS ELABORO
	, REQD_OC_OrdenCompraId AS NUM_OC
From Requisiciones
Inner join RequisicionesDetalle on REQ_RequisicionId = REQD_REQ_RequisicionId
Inner join ControlesMaestrosMultiples on REQ_CMM_EstadoRequisicionId = CMM_ControlId
Inner Join Empleados on REQ_EMP_CreadoPorId = EMP_EmpleadoId
Where REQ_Eliminado = '0' and REQ_CMM_EstadoRequisicionId = '062B2C74-E965-4F51-BA30-28608A20DAE8'
Order by REQUISICION


-- CONVERTIDA PARCIAL
-- Validar que se tenga completas las OC en los Articulos y de ser asi cambiar el Estatus por CONVETIDA.
-- Alerta que actue de forma automatica.

Select REQ_RequisicionId AS ID
	, REQD_OC_OrdenCompraId AS NUM_OC
	, Cast(REQ_FechaRequisicion as DATE) AS FEC_REQ
	, REQ_CodigoRequisicion AS REQUISICION
	, REQD_DescripcionArticulo AS NOM_ITEM
	, CMM_Valor AS ESTATUS
	, Datediff(day, REQ_FechaRequisicion, getdate()) AS DIAS
	, (EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido) AS ELABORO
	, REQD_OC_OrdenCompraId AS NUM_OC
From Requisiciones
Inner join RequisicionesDetalle on REQ_RequisicionId = REQD_REQ_RequisicionId
Inner join ControlesMaestrosMultiples on REQ_CMM_EstadoRequisicionId = CMM_ControlId
Inner Join Empleados on REQ_EMP_CreadoPorId = EMP_EmpleadoId
Where  REQ_Eliminado = '0' and REQ_CMM_EstadoRequisicionId = '61DCA51E-443E-4B94-B264-672EBAC119AE'
Order by REQUISICION


 -- ABIERTAS
Select REQ_RequisicionId AS ID
	, REQD_OC_OrdenCompraId AS NUM_OC
	, Cast(REQ_FechaRequisicion as DATE) AS FEC_REQ
	, REQ_CodigoRequisicion AS REQUISICION
	, REQD_DescripcionArticulo AS NOM_ITEM
	, CMM_Valor AS ESTATUS
	, Datediff(day, REQ_FechaRequisicion, getdate()) AS DIAS
	, (EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido) AS ELABORO
	, REQD_OC_OrdenCompraId AS NUM_OC
From Requisiciones
Inner join RequisicionesDetalle on REQ_RequisicionId = REQD_REQ_RequisicionId
Inner join ControlesMaestrosMultiples on REQ_CMM_EstadoRequisicionId = CMM_ControlId
Inner Join Empleados on REQ_EMP_CreadoPorId = EMP_EmpleadoId
Where  REQ_Eliminado = '0' and REQ_CMM_EstadoRequisicionId = '18FBCAC4-1627-4A33-A3B4-8EB8857198E1'  
Order by REQUISICION



-- Cambio de Estatus de la Requisicion:
REQ00389 Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = 'C7D5BC8A-03C9-4E0A-A473-F1AE076B614B'
REQ00390 Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = '98DDB50E-3492-451E-AE9D-C93E54880C27'
REQ00391 Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = 'ADBC11E6-5645-407D-A28E-820CA5AB70E6'
REQ00392 Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = 'BC8B649F-6A20-4F56-9C48-423F0C2A48EC'
REQ00395 Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = '8BB84D38-92CD-4D00-B800-98ECD54025A7'
REQ00396 Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = 'CC49D1B2-14CD-4D2A-B29B-95192CC38BAE'
REQ00400 Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = '73EE9F57-4096-40F9-B199-66F6007D31C4'
REQ00402 Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = 'AA25A316-6FD4-487B-A209-C5CF3A9FF402'
REQ00403 Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = '50F760D1-44EE-4507-9467-B5DD427C8581'
REQ00404 Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = '0BB3B90C-C616-4D89-AD24-65EA8C2D64A1'
REQ00979 Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = '176E4341-D473-45CC-9F66-4DB7F67BAB4B'
REQ01864 Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = '52C77870-E8A2-4E0A-9825-4D229A68E393'
REQ02720 Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = 'BDCD315C-A91B-4B8B-B517-5BE4FDED68B8'
REQ02953 Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = 'E062DA4F-6B45-408D-815F-511A125280B5'
Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = 'C1CB2445-B2F0-4E0F-B16F-672E0684381F'
Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = 'A892FD03-8706-48E7-989F-A2E25772A65C'
Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = '034E4625-89FE-4CDE-818F-ABA7A99B3E07'

Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = '16AC13D2-DFC2-4565-8CDD-E973B9D281F5'
Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = '3E4E25A0-7E6C-4B58-8CDB-275103EB4026'
Update Requisiciones Set REQ_CMM_EstadoRequisicionId = '7AC0E6CE-6DBE-4578-BB56-1DAD6DD6E69F' Where REQ_RequisicionId = '2EF1E19D-406A-4304-A4D4-3996BF4602CF'


--Identificar ID de la Requisicion que se quiere cambiar a Convertida.
SELECT *
FROM Requisiciones 
Inner join RequisicionesDetalle on REQ_RequisicionId = REQD_REQ_RequisicionId
WHERE REQ_CodigoRequisicion =  'REQ03559' 


Select * From Empleados Where EMP_EmpleadoId ='6E9C52A6-6A38-41DB-AAA2-5B93CABE83D1'

--'REQ04010'


SELECT *
FROM ControlesMaestrosMultiples 
--WHERE CMM_ControlId  = '58ACB0EC-F923-4050-AA4D-8538C0A72343'
--WHERE CMM_Control = 'CMM_CREQ_EstadoRequisicion'
WHERE CMM_Control = 'CMM_CREQ_EstadoPartida'

