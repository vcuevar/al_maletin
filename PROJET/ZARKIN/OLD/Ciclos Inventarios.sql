

Select * from OWTR
inner join WTR1 on OWTR.DocEntry = WTR1.DocEntry
Where OWTR.CreateDate = '2018/06/02' and OWTR.DocEntry = 381




--Traslados de APG-PA a APT-PA Son Consumos de Carpinteria.
Select OWTR.DocEntry as DOC, OWTR.CreateDate as FEC_SYS,OWTR.Filler as ORIGEN,
 

* from OWTR
inner join WTR1 on OWTR.DocEntry = WTR1.DocEntry
Where OWTR.CreateDate = '2018/06/02' and OWTR.DocEntry = 381