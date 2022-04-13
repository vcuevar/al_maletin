-- Revision del Historial de la Orden.  

DECLARE @NumOrd as int
Set @NumOrd =  10175


Select Cast(HIS.U_FechaHora as date) AS FECHA
		, HIS.U_CT
		, SUM(HIS.U_Cantidad) as PROD
		, HIS.U_idEmpleado 
from [@CP_LOGOF] HIS 
Where HIS.U_DocEntry = @NumOrd 
Group by  HIS.U_CT, HIS.U_idEmpleado, HIS.U_FechaHora 
Order by HIS.U_FechaHora, HIS.U_CT, HIS.U_idEmpleado 
