-- Ejercicio para hacer las excepciones en forma automatica y enviar los resultados a archivo de Texto.
-- Sigo con mi ROBOT BEV_1.00  (Robot Buscador de Exepciones Version 1.00).


-- BCP comando de linea para hacer copia masiva de informacion en SQL

Declare @Sql as nvarchar(4000)
Declare @bcp as nvarchar(4000)
Set @Sql = 'SELECT Id_Producto, Sucursal, TipoProducto, Clave1, Observacion FROM Productos WHERE Clave1 is not null' 
Set @bcp = 'bcp "'+@Sql+'" queryout C:\producto.txt -T -t, -c' 
exec master..xp_cmdshell @bcp 

--Ordenes no aparecen en Reporte de Terminado (EX-PRODUCCION-01)

select OWOR.DocEntry, OWOR.CmpltQty, [@CP_LOGOF].U_DocEntry as OP_Piso, OITM.ItemName, OITM.U_VS, OWOR.Type 
from OWOR 
inner join OITM on OWOR.ItemCode=OITM.ItemCode 
left join [@CP_LOGOF] on OWOR.DocEntry=[@CP_LOGOF].U_DocEntry and ([@CP_LOGOF].U_CT=20 or [@CP_LOGOF].U_CT=175) 
where OWOR.CmpltQty>0 and OITM.QryGroup29='N' and OITM.QryGroup30='N' and OITM.QryGroup31='N' and [@CP_LOGOF].U_DocEntry is null
and OITM.ItemName not like '%CINTIL%' and OWOR.Type='S' and OITM.U_TipoMat='PT' 
and OWOR.DocEntry <> 31896
order by OWOR.DocEntry 

--& " and OWOR.DocEntry > 8597  and  OWOR.DocEntry <> 20295 and  OWOR.DocEntry <> 10711 and OWOR.DocEntry <> 21944 and OWOR.DocEntry <> 22079 and OWOR.DocEntry <> 40638 and OWOR.DocEntry <> 56873 and OWOR.DocEntry <> 63824 

 FileStream Query = new FileStream("C:/DatosQuery.txt", FileMode.Append, FileAccess.Write);
    StreamWriter Escriba = new StreamWriter(Query);
    SqlCommand comando = new SqlCommand("Select x,m * from xxx", cn);
    SqlDataReader leer;
    leer = comando.ExecuteReader();
    while (leer.Read())
    {              
      Escriba.Write(leer[0].ToString());
      Escriba.Write(leer[1].ToString());
      Escriba.WriteLine();
      Escriba.Flush();

    }    
Escriba.Close();