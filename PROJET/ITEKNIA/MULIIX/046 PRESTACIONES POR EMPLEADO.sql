


Select Cast(PRE_FechaDoc as DATE) AS FECHA  
	, DATEPART (month, PRE_FechaDoc) AS MES
	, PRE_EMP_EmpleadoId  AS N_NOMI
	, (EMP_Nombre + '  ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido) AS NOMBRE
	, Case When PRE_Describe like '%Ahorro%' then (PRE_Debe -PRE_Haber) end  AS AHORRO
	, Case When PRE_Describe like '%Patron%' then (PRE_Debe -PRE_Haber) end  AS PATRON
	, RPT_PRESTAMOS.* 
From RPT_PRESTAMOS  
Inner Join Empleados on PRE_EMP_EmpleadoId = EMP_CodigoEmpleado
Where PRE_EMP_EmpleadoId = '014' --and PRE_Categoria = 'AHORR' 
Order By PRE_FechaDoc 

--Select * from RPT_PRESTAMOS rp WHERE PRE_EMP_EmpleadoId = '014' 
