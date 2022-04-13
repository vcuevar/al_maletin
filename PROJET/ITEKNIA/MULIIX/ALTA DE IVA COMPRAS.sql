-- Cargar IVA del 16% a Proveedores.

Select * from Proveedores
where PRO_CodigoProveedor = 'P101'

select * from ProveedoresCriteriosAdmon
Where PCA_PRO_ProveedorId = '099840D6-E9B9-4CEE-A007-78308D8CEBB6'



select * from ControlesMaestrosMultiples
where CMM_Control = 'CMM_TipoIVA'
where CMM_ControlId = 'A5585C2F-CD77-4641-8853-2926FD929C91'

-- Tipo de IVA Compras
CMM_ControlId
876D445A-7E4A-4F4A-95D1-D90C115C3ABE

-- Tipo de IVA Ventas
CMM_ControlId
A5585C2F-CD77-4641-8853-2926FD929C91


select * from ControlesMaestrosIVA

Update ControlesMaestrosIVA set CMIVA_Predeterminado = 1 where CMIVA_IVAId = '39BC9D8D-D962-4455-B899-3677BBF9E7ED'



/*
INSERT INTO [dbo].[ControlesMaestrosIVA]
           ([CMIVA_IVAId]
           ,[CMIVA_CodigoIVA]
           ,[CMIVA_Descripcion]
           ,[CMIVA_Porcentaje]
		   ,[CMIVA_Predeterminado]
		   ,[CMIVA_CMM_TipoIVA]
		   ,[CMIVA_Activo]
		   ,[CMIVA_FechaUltimaModificacion]
		   ,[CMIVA_EMP_ModificadoPorId])
		   
  VALUES
           (NEWID() , '4', 'IVA AL 0% VENTAS',  0.00, 0, 'A5585C2F-CD77-4641-8853-2926FD929C91',
		   1,  GETDATE(), 'D117CCA7-7114-4B55-9EEB-9F8553BF6179')
		   

GO 

*/
