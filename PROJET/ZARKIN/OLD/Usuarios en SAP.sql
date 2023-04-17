

-- Usuarios de SAP

select userSign2, * from OUSR
order by ousr.userSign2

select USERID, INTERNAL_K, USER_CODE, U_NAME, E_Mail, DISCOUNT, WallPaper
from OUSR
where U_NAME like '%DEY%'
order by USER_CODE


-- Usuarios Reporteria.

select * from SIRS
where clv=234

update SIRS set clv=948, nom='SALVADOR FUENTES MALDONADO'
where clv=234



sELECT * FROM OHEM
oRDER by U_EmpGiro