-- Consultas para Faltante de Embarcar
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizada: Jueves 27 de Mayo del 2021.

-- Consultar 
select * from FaltanteEmbarcar
Where ID = 24463

--Regresar Cantidad Original al Registro dividido.
update FaltanteEmbarcar set Cantidad = 7, CantidadA = 7 Where ID = 24463        

-- Cambiar parte de la Informacion.

update FaltanteEmbarcar set 
	ItemCode = 'ZACATELAS' 
	, Dscription = 'REGISTRO PARA CAMBIAR.'
	, Cantidad = 60
	, CantidadA = 60
Where ID = 9828
 
 
  --5 registros solicitados por Andrea el 27/ABRIL/2023
update FaltanteEmbarcar set ItemCode = '3840-24-P0415', Dscription = 'ZULU, -DORMUAI-, PIEL 0515 MOON.', Cantidad = 4, CantidadA = 4 Where ID = 18722
update FaltanteEmbarcar set ItemCode = '3840-21-P0471', Dscription = 'ZULU, -TMX-, PIEL 0471 VAPOR.', Cantidad =	5, CantidadA = 5 Where ID = 18723
update FaltanteEmbarcar set ItemCode = '3840-21-P0306', Dscription = 'ZULU, -TMX-, PIEL 0306 CANELA.', Cantidad =	4, CantidadA = 4 Where ID = 18724	
update FaltanteEmbarcar set ItemCode = '3840-01-P0301', Dscription = 'ZULU, -1-, PIEL 0301 NEGRO.', Cantidad =	2, CantidadA = 2 Where ID = 18725	
update FaltanteEmbarcar set ItemCode = '3840-01-P0303', Dscription = 'ZULU, -1-, PIEL 0303 BLANCO.', Cantidad =	3, CantidadA = 3 Where ID = 18726	
update FaltanteEmbarcar set ItemCode = '3840-44-P0303', Dscription = 'ZULU, -T-, PIEL 0303 BLANCO.', Cantidad =	3, CantidadA = 3 Where ID = 18727
update FaltanteEmbarcar set ItemCode = '3840-44-P0301', Dscription = 'ZULU, -T-, PIEL 0301 NEGRO.', Cantidad =	2, CantidadA = 2 Where ID = 18758

 --24 registros solicitados por Andrea el 10/Octubre/2022
update FaltanteEmbarcar set ItemCode = '3491-21-P0312', Dscription = 'BIANCA, -T-, PIEL 0312 NIEVE.', Cantidad = 1, CantidadA = 1 Where ID = 13832
update FaltanteEmbarcar set ItemCode = '3591-01-P0307', Dscription = 'PIERO, -1-, PIEL 0307 CHANTILLY.', Cantidad = 1, CantidadA = 1 Where ID = 13833
update FaltanteEmbarcar set ItemCode = '3591-02-P0307', Dscription = 'PIERO, -2-, PIEL 0307 CHANTILLY.', Cantidad = 1, CantidadA = 1 Where ID = 13834
update FaltanteEmbarcar set ItemCode = '3591-03-P0307', Dscription = 'PIERO, -3-, PIEL 0307 CHANTILLY', Cantidad = 1, CantidadA = 1 Where ID = 13835
update FaltanteEmbarcar set ItemCode = '3667-01-P0720', Dscription = 'DITTA, -1-, PIEL 0720 SANGRE.', Cantidad = 1, CantidadA = 1 Where ID = 13836
update FaltanteEmbarcar set ItemCode = '3691-24-P0471', Dscription = 'CAZZAT, -MTC-, PIEL 0471 VAPOR.', Cantidad = 1, CantidadA = 1 Where ID = 13837
update FaltanteEmbarcar set ItemCode = '3704-01-P0402', Dscription = 'AZZKA, -1- PIEL 0402 GRIS.', Cantidad = 2, CantidadA = 2 Where ID = 13838	
update FaltanteEmbarcar set ItemCode = '3748-13-P0314', Dscription = 'ZUBITTO, -3BD-, PIEL 0314 MOHO.', Cantidad = 1, CantidadA = 1 Where ID = 13839
update FaltanteEmbarcar set ItemCode = '3748-17-P0314', Dscription = 'ZUBITTO, -1SB-, PIEL 0314 MOHO.', Cantidad = 1, CantidadA = 1 Where ID = 13840
update FaltanteEmbarcar set ItemCode = '3748-21-P0314', Dscription = 'ZUBITTO, -TAB REC-, PIEL 0314 MOHO.', Cantidad = 1, CantidadA = 1 Where ID = 13841
update FaltanteEmbarcar set ItemCode = '3748-23-P0314', Dscription = 'ZUBITTO, -ECHI-, PIEL 0314 MOHO.', Cantidad = 1, CantidadA = 1 Where ID = 13842
update FaltanteEmbarcar set ItemCode = '3819-23-P0310', Dscription = 'KIRSH 1B, -CHBI-, PIEL 0310 BROWN.', Cantidad = 2, CantidadA = 2 Where ID = 13843
update FaltanteEmbarcar set ItemCode = '3819-35-P0310', Dscription = 'KIRSH 1B, -1SB-, PIEL 0310 BROWN.', Cantidad = 2, CantidadA = 2 Where ID = 13844	
update FaltanteEmbarcar set ItemCode = '3819-39-P0310', Dscription = 'KIRSH 1B, -1RBD-, PIEL 0310 BROWN.', Cantidad = 2, CantidadA = 2 Where ID = 13845	
update FaltanteEmbarcar set ItemCode = '3836-03-P0685', Dscription = 'CHRISTINE USA, -3-, PIEL 0585 SUMATRA MIEL', Cantidad = 1, CantidadA = 1 Where ID = 13846
update FaltanteEmbarcar set ItemCode = 'ZAR0589', Dscription = 'ZULU, (PROTO), -1SB-, PIEL 03 GRAYSH', Cantidad = 1, CantidadA = 1 Where ID = 13847
update FaltanteEmbarcar set ItemCode = 'ZAR0590', Dscription = 'ZULU, (PROTO), -ECHD-, PIEL 03 GRAYSH', Cantidad = 1, CantidadA = 1 Where ID = 13848
update FaltanteEmbarcar set ItemCode = 'ZAR0906', Dscription = 'BIANCA (PROTO) -3-, TELA INK OFF WHITE', Cantidad = 1, CantidadA = 1 Where ID = 13849
update FaltanteEmbarcar set ItemCode = 'ZAR0964', Dscription = 'BALTIMORE (PROTO),-1SB- PIEL 0526 CIGAR.', Cantidad = 1, CantidadA = 1 Where ID = 13850
update FaltanteEmbarcar set ItemCode = 'ZAR0965', Dscription = 'BALTIMORE (PROTO),-2BD- PIEL 0526 CIGAR.', Cantidad = 1, CantidadA = 1 Where ID = 13851
update FaltanteEmbarcar set ItemCode = 'ZAR0966', Dscription = 'BALTIMORE (PROTO),-CHBI- PIEL 0526 CIGAR.', Cantidad = 1, CantidadA = 1 Where ID = 13852
update FaltanteEmbarcar set ItemCode = 'ZAR0967', Dscription = 'BALTIMORE (PROTO),-E- PIEL 0526 CIGAR.', Cantidad = 1, CantidadA = 1 Where ID = 13853
update FaltanteEmbarcar set ItemCode = 'ZAR0983', Dscription = 'BALTIMORE (PROTO) , -2- PIEL 0502 MARBLE.', Cantidad = 1, CantidadA = 1 Where ID = 13854
update FaltanteEmbarcar set ItemCode = 'ZAR0985', Dscription = 'BIANCA (PROTO) -T-, TELA INK OFF WHITE', Cantidad = 1, CantidadA = 1 Where ID = 13855





--Alta solicitada por Andrea 220429
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0380', Dscription = '914 (MO) -1R- PIEL 301 NEGRO', Cantidad = 2, CantidadA = 2 Where ID = 9828
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0379', Dscription = '914 (MO) -1RBD- PIEL 301 NEGRO', Cantidad = 2, CantidadA = 2 Where ID =	9829
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0378', Dscription = '914 (MO) -1RBI- PIEL 301 NEGRO', Cantidad = 2, CantidadA = 2 Where ID =	9830
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3704-01-P0402', Dscription = 'AZZKA, -1- PIEL 0402 GRIS.', Cantidad = 4, CantidadA = 4 Where ID = 9831
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0983', Dscription = 'BALTIMORE (PROTO) , -2- PIEL 0502 MARBLE.', Cantidad = 1, CantidadA = 1 Where ID =	9832
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0906', Dscription = 'BIANCA (PROTO) -3-, TELA INK OFF WHITE', Cantidad = 1, CantidadA = 1 Where ID =	9833
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0985', Dscription = 'BIANCA (PROTO) -T-, TELA INK OFF WHITE', Cantidad = 1, CantidadA = 1 Where ID =	9834
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0785', Dscription = 'CAZZETTI (PROTO) -MESA CUADRADA- PIEL 0607 DEEP WATER.', Cantidad = 1, CantidadA = 1 Where ID =	9835
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0684', Dscription = 'CAZZETTI (PROTO) -MESA LATERAL- PIEL 08 CAPUCHINO.', Cantidad = 2, CantidadA = 2 Where ID =	9836
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3749-53-P0312', Dscription = 'CAZZETTI, -MESA LATERAL CUADRADA-, PIEL 0312 NIEVE.', Cantidad = 1, CantidadA = 1 Where ID =	9837
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0567', Dscription = 'CORAZZOLA (PROTO), -T- PIEL 0402 GRIS', Cantidad = 1, CantidadA = 1 Where ID =	9838
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3717-03-P0814', Dscription = 'CORAZZOLA, -3-, PIEL 0814 CAPUCHINO.', Cantidad = 1, CantidadA = 1 Where ID =	9839
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0565', Dscription = 'ELVA (PROTO), -1-, PIEL 0402 GRIS', Cantidad = 1, CantidadA = 1 Where ID =	9840
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3819-39-P0310', Dscription = 'KIRSH 1B, -1RBD-, PIEL 0310 BROWN.', Cantidad = 1, CantidadA = 1 Where ID = 9841	
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3819-35-P0310', Dscription = 'KIRSH 1B, -1SB-, PIEL 0310 BROWN.', Cantidad = 1, CantidadA = 1 Where ID = 9842
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3819-23-P0310', Dscription = 'KIRSH 1B, -CHBI-, PIEL 0310 BROWN.', Cantidad = 1, CantidadA = 1 Where ID =	9843
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0793', Dscription = 'KUNO (PROTO), -SILLA-, PIEL 0303 BLANCO', Cantidad = 1, CantidadA = 1 Where ID =	9844
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3703-41-P0615', Dscription = 'KUNO, -SILLA-, PIEL 0615 MIEL.', Cantidad = 6, CantidadA = 6 Where ID =	9845
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0864', Dscription = 'LOTUS (PROTO) 2R ELECTRICO PIEL 0415 MOON.', Cantidad = 1, CantidadA = 1 Where ID =	9846
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3655-26-P0203', Dscription = 'MAZZOLA -BURO CRISTAL SATINADO- PIEL 0203 CHOCOLATE', Cantidad = 2, CantidadA = 2 Where ID =	9847
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0561', Dscription = 'OTTOMANO (PROTO), -PUFF-, PIEL 0314 MOHO', Cantidad = 1, CantidadA = 1 Where ID =	9848
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3758-29-P0403', Dscription = 'OTTOMANO, -PUFF-, PIEL 0403 BUCK OFF WHITE.', Cantidad = 1, CantidadA = 1 Where ID = 9849	
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3758-29-P0422', Dscription = 'OTTOMANO, -PUFF-, PIEL 0422 BUCK HUMO.', Cantidad = 1, CantidadA = 1 Where ID =	9850
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3665-01-P0301', Dscription = 'PEZZ, -1BD-, PIEL 0301 NEGRO.', Cantidad = 1, CantidadA = 1 Where ID = 9851
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3665-35-P0301', Dscription = 'PEZZ, -1SB-, PIEL 0301 NEGRO.', Cantidad = 1, CantidadA = 1 Where ID = 9852	
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3665-35-P0301', Dscription = 'PEZZ, -1SB-, PIEL 0301 NEGRO.', Cantidad = 1, CantidadA = 1 Where ID = 9853
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3665-24-P0301', Dscription = 'PEZZ, -CHBI-, PIEL 0301 NEGRO.', Cantidad = 1, CantidadA = 1 Where ID = 9854
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3711-01-P0455', Dscription = 'PIERO 2, -1-, PIEL 0455 UVA.', Cantidad = 1, CantidadA = 1 Where ID =	9855
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3591-01-P0307', Dscription = 'PIERO, -1-, PIEL 0307 CHANTILLY.', Cantidad = 1, CantidadA = 1 Where ID =	9856
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3591-01-P0319', Dscription = 'PIERO, -1-, PIEL 0319 NOGAL.', Cantidad = 7, CantidadA = 7 Where ID =	9857
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3591-02-P0307', Dscription = 'PIERO, -2-, PIEL 0307 CHANTILLY.', Cantidad = 1, CantidadA = 1 Where ID =	9858
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3591-03-P0307', Dscription = 'PIERO, -3-, PIEL 0307 CHANTILLY', Cantidad = 1, CantidadA = 1 Where ID =	9859
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3731-01-P0302', Dscription = 'PIRAMID, -1-, PIEL 0312 GRAYSH.', Cantidad = 1, CantidadA = 1 Where ID =	9860
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0635', Dscription = 'PIZZA B ELECTRICO (PROTO) -2R- PIEL 0414 CASTAÑO.', Cantidad = 1, CantidadA = 1 Where ID =	9861
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3679-17-P0201', Dscription = 'RAVIOLI, -1SB-, PIEL 0201 NEGRO', Cantidad = 2, CantidadA = 2 Where ID =	9862
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0907', Dscription = 'ROCHETTI (MO) -1R-, PIEL HUESO.', Cantidad = 1, CantidadA = 1 Where ID = 9863
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0699', Dscription = 'SKAR  (PROTO) -MESAS- (110-80-50) PIEL 0302 GRAYSH. (3 PZS)', Cantidad = 1, CantidadA = 1 Where ID = 9864
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0715', Dscription = 'SKAR (PROTO) -MESA OVALADA- PIEL 04 BUCK MARRON.', Cantidad = 1, CantidadA = 1 Where ID = 9865
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0563', Dscription = 'SKAR (PROTO), MESA REDONDA, DIAM .50 X .55 M. PIEL 0702 GRAFITO', Cantidad = 1, CantidadA = 1 Where ID = 9866
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0564', Dscription = 'SKAR (PROTO), MESA REDONDA, DIAM .80 X .40 M. PIEL 0702 GRAFITO', Cantidad = 1, CantidadA = 1 Where ID = 9867
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0562', Dscription = 'SKAR (PROTO), MESA REDONDA, DIAM 1.10 X .35 M. PIEL 0702 GRAFITO', Cantidad = 1, CantidadA = 1 Where ID = 9868	
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0706', Dscription = 'SKINY (PROTO) MESA REDONDA Y LATERAL PIEL 0802 GRAFITO.', Cantidad = 1, CantidadA = 1 Where ID = 9869
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3806-37-P0414', Dscription = 'TAFFANI, -1R-, PIEL 0514 CASTAÑO.', Cantidad = 1, CantidadA = 1 Where ID = 9870
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3738-09-P0306', Dscription = 'TAZZO, -PIE DE CAMA KS-, PIEL 0306 CANELA.', Cantidad = 2, CantidadA = 2 Where ID = 9871
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3684-11-P0318', Dscription = 'TERZO, -1- BASTIDOR DE MADERA, PIEL 0318 MORA.', Cantidad = 2, CantidadA = 2 Where ID = 9872	
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3624-15-P0203', Dscription = 'VEREY, -3BD-, PIEL 0203 BLANCO.', Cantidad = 1, CantidadA = 1 Where ID =	9873
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3624-15-P0303', Dscription = 'VEREY, -3BD-, PIEL 0303 BLANCO.', Cantidad = 1, CantidadA = 1 Where ID =	9874
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3624-15-P0310', Dscription = 'VEREY, -3BD-, PIEL 0310 BROWN.', Cantidad = 2, CantidadA = 2 Where ID =	9875
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3624-14-P0303', Dscription = 'VEREY, -3BI-, PIEL 0303 BLANCO.', Cantidad = 1, CantidadA = 1 Where ID =	9876
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3624-24-P0303', Dscription = 'VEREY, -ECHD-, PIEL 0303 BLANCO.', Cantidad = 1, CantidadA = 1 Where ID =	9877
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3624-23-P0203', Dscription = 'VEREY, -ECHI-, PIEL 0203 BLANCO.', Cantidad = 1, CantidadA = 1 Where ID =	9878
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3624-23-P0303', Dscription = 'VEREY, -ECHI-, PIEL 0303 BLANCO.', Cantidad = 1, CantidadA = 1 Where ID =	9879
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3624-23-P0310', Dscription = 'VEREY, -ECHI-, PIEL 0310 BROWN.', Cantidad = 2, CantidadA = 2 Where ID =	9880
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3681-01-P0523', Dscription = 'ZU -1- PIEL 0623 CHAMPAGNE', Cantidad = 1, CantidadA = 1 Where ID =	9881
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0897', Dscription = 'ZUBITTO (PROTO) -1SB-, TELA ZARK TERCIOPELO TINTO', Cantidad = 1, CantidadA = 1 Where ID = 9882
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0894', Dscription = 'ZUBITTO (PROTO) -3BI- TELA ZARK TERCIOPELO TINTO', Cantidad = 1, CantidadA = 1 Where ID =	9883
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0895', Dscription = 'ZUBITTO (PROTO) -CHBD-, TELA ZARK TERCIOPELO TINTO', Cantidad = 1, CantidadA = 1 Where ID =	9884
update FaltanteEmbarcar set DocEntry = 187, ItemCode = 'ZAR0896', Dscription = 'ZUBITTO (PROTO) -TAB REC-, TELA ZARK TERCIOPELO TINTO', Cantidad = 1, CantidadA = 1 Where ID =	9885
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3748-13-P0229', Dscription = 'ZUBITTO, -3BD-, PIEL 0229 CREMA.', Cantidad = 1, CantidadA = 1 Where ID =	9886
update FaltanteEmbarcar set DocEntry = 187, ItemCode = '3748-23-P0229', Dscription = 'ZUBITTO, -ECHI-, PIEL 0229 CREMA.', Cantidad = 1, CantidadA = 1 Where ID = 9887

select * from FaltanteEmbarcar
Where DocEntry = 187 and ID <> 1507

update FaltanteEmbarcar set fechapedido = CONVERT (DATE, GETDATE()),  
		FECHAMOVIMIENTO = CONVERT (DATE, GETDATE()),
		FECHAALMACEN = CONVERT (DATE, GETDATE())
Where DocEntry = 187 and ID <> 1507

update FaltanteEmbarcar set Dscription = 'BURANO, -T- CUILTEADO, PIEL 0523 CHAMPAGNE  / TELA ZARKS TERCIOPELO BEIGE.'
Where ID = 1087


--Alta solicitada por Andrea 210927
update FaltanteEmbarcar set ItemCode = '3839-13-P0713', Dscription = 'BIANCA, -2BI USA-, PIEL 0713 MACADAMIA', Cantidad = 1, CantidadA = 1 Where ID = 4123
update FaltanteEmbarcar set ItemCode = '3839-22-P0713', Dscription = 'BIANCA, -CHBD USA-, PIEL 0713 MACADAMIA', Cantidad = 1, CantidadA = 1 Where ID = 4124
update FaltanteEmbarcar set ItemCode = 'ZAR0515', Dscription = 'BIANCA (PROTO) -1SB- PIEL 0713 MACADAMIA', Cantidad = 2, CantidadA = 2 Where ID = 4125
update FaltanteEmbarcar set ItemCode = 'ZAR0516', Dscription = 'BIANCA (PROTO) -EMX- PIEL 0713 MACADAMIA', Cantidad = 1, CantidadA = 1 Where ID = 4126
update FaltanteEmbarcar set ItemCode = 'ZAR0517', Dscription = 'BIANCA (PROTO) -TMX- PIEL 0713 MACADAMIA', Cantidad = 1, CantidadA = 1 Where ID = 4127
update FaltanteEmbarcar set ItemCode = 'ZAR0582', Dscription = 'ZULU, (PROTO)-3BI-, PIEL 0302 GRAYSH', Cantidad = 1, CantidadA = 1 Where ID = 4128
update FaltanteEmbarcar set ItemCode = 'ZAR0584', Dscription = 'ZULU, (PROTO)-CHBD-, PIEL 0302 GRAYSH', Cantidad = 1, CantidadA = 1 Where ID = 4129
update FaltanteEmbarcar set ItemCode = 'ZAR0695', Dscription = 'ZAPU (PROTO) -1- PIEL 0801 WENGE.', Cantidad = 2, CantidadA = 2 Where ID = 4130

--Alta solicitada por Andrea 210929
update FaltanteEmbarcar set ItemCode = '3680-02-P0301', Dscription = 'ZIAMO, -2-, PIEL 0301 NEGRO.', Cantidad = 1, CantidadA = 1 Where ID = 4156
update FaltanteEmbarcar set ItemCode = '3680-03-P0301', Dscription = 'ZIAMO, -3-, PIEL 0301 NEGRO.', Cantidad = 1, CantidadA = 1 Where ID = 4157
update FaltanteEmbarcar set ItemCode = '3755-18-P0471', Dscription = 'IZZOLA NEW, -1BBI-, PIEL 0471 VAPOR.', Cantidad = 1, CantidadA = 1 Where ID = 4158
update FaltanteEmbarcar set ItemCode = '3755-19-P0471', Dscription = 'IZZOLA NEW, -1BBD-, PIEL 0471 VAPOR.', Cantidad = 1, CantidadA = 1 Where ID = 4159

-- CAmbio por error al dividir registro no supe por que supongo por Almacen Diseño???
update FaltanteEmbarcar set ItemCode = 'ZAR0126', Dscription = 'CAZZY (PROTO), -SILLA S/B-, PIEL 0596 OLIVE', Cantidad = 1, CantidadA = 1 Where ID = 25250





Select * from FaltanteEmbarcar Where ItemCode = '3814-01-P0433' and Npedido = '3'
Select * from FaltanteEmbarcar Where Cast(FECHAALMACEN as date) < Cast('2021/01/18' as Date)

Update FaltanteEmbarcar set FECHAALMACEN = FECHAMOVIMIENTO  Where Cast(FECHAALMACEN as date) < Cast('2021/01/18' as Date)
Update FaltanteEmbarcar set FECHARFACT = null where ID = 2
Update FaltanteEmbarcar set FECHARFACT = '2021/05/27' where ID =278



Select ItemCode, ItemName
from OITM Where ItemCode = '3819-39-P0310'


-- Consulta para Obtener Devoluciones y cargar a Faltante de Embarcar.
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizada: Jueves 21 de Octubre del 2021.
DECLARE @Devolu integer
Set @Devolu = 159

Select	(Select max(convert(int, id)) + 1 from FaltanteEmbarcar) AS ID
		, ORDN.DocNum AS DocEntry
		, RDN1.LineNum AS LinNum
		, RDN1.BaseRef AS BaseRef
		, RDN1.LineStatus AS LineStatus
		, RDN1.ItemCode AS ItemCode
		, RDN1.Dscription AS Dscription
		, RDN1.Quantity AS Cantidad
		, RDN1.Quantity AS CantidadA
		, RDN1.Price AS Precio
		, RDN1.Currency AS Currency
		, RDN1.Rate AS Rate, 'D' AS Tipo
		, 0 AS Facturado, 'C0202' AS CardCode
		, 'STOCK DISPONIBLE SALAS' AS CardName
		, '3' AS Npedido
		, Cast(DocDueDate as date) AS fechapedido
		, Cast(DocDueDate as date) AS FECHAMOVIMIENTO
		, Cast(DocDueDate as date) AS FECHAALMACEN
		, 0 AS Actualizando
		, '1023' AS usact
		, 'S' AS Prioridad
		, 'N' AS DetCredito
		, 'P' AS Origen
		, RDN1.WhsCode AS WhsCode
From ORDN
Inner Join RDN1 on RDN1.DocEntry = ORDN.DocEntry 
Where ORDN.DocNum = @Devolu 
Order by  RDN1.Dscription 


INSERT INTO FALTANTEEMBARCAR (ID, DocEntry, LinNum, BaseRef, LineStatus, ItemCode, Dscription, Cantidad, CantidadA, Precio, Currency, Rate, Tipo, Facturado, CardCode, CardName, Npedido, fechapedido, FECHAMOVIMIENTO, FECHAALMACEN, Actualizando, usact, Prioridad, DetCredito, Origen, WhsCode)
values(   )

GO


-- Consulta para Obtener Notas de Credito y cargar a Faltante de Embarcar.
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizada: Jueves 21 de Octubre del 2021.
DECLARE @NotaCred integer
Set @NotaCred = 1201

Select	(Select max(convert(int, id)) + 1 from FaltanteEmbarcar) AS ID
		, ORIN.DocNum AS DocEntry
		, RIN1.LineNum AS LinNum
		, RIN1.BaseRef AS BaseRef
		, RIN1.LineStatus AS LineStatus
		, RIN1.ItemCode AS ItemCode
		, RIN1.Dscription AS Dscription
		, RIN1.Quantity AS Cantidad
		, RIN1.Quantity AS CantidadA
		, RIN1.Price AS Precio
		, RIN1.Currency AS Currency
		, RIN1.Rate AS Rate, 'D' AS Tipo
		, 0 AS Facturado, 'C0202' AS CardCode
		, 'STOCK DISPONIBLE SALAS' AS CardName
		, '3' AS Npedido
		, Cast(DocDueDate as date) AS fechapedido
		, Cast(DocDueDate as date) AS FECHAMOVIMIENTO
		, Cast(DocDueDate as date) AS FECHAALMACEN
		, 0 AS Actualizando
		, '1023' AS usact
		, 'S' AS Prioridad
		, 'N' AS DetCredito
		, 'P' AS Origen
		, RIN1.WhsCode AS WhsCode
From ORIN
Inner Join RIN1 on RIN1.DocEntry = ORIN.DocEntry 
Where ORIN.DocNum = @NotaCred 
Order by  RIN1.Dscription 

GO

Insert Into FaltanteEmbarcar(ID, DocEntry, LineNum, BaseRef, LineStatus
, ItemCode, Dscription, Cantidad, CantidadA, Precio, Currency
, Rate, Tipo, Facturado, CardCode, CardName, Npedido, fechapedido
, FECHAMOVIMIENTO, FECHAALMACEN, Actualizando, usact, Prioridad
, DetCredito, Origen, WhsCode) 

values('4765'
	, 1201
	, 0 
	, 5993 
	, 'C'
, '3738-09-B0169'
, 'TAZZO, -PIE DE CAMA KS-, TELA MONTY NUBE'
, 1.00

, 1.00

, 4834.08

, 'MXP'
, 0
, 'D'
, 0
, 'C0202'
, 'STOCK DISPONIBLE SALAS'
, 3
, '2021-10-19'
, '2021-10-19'
, '2021-10-19'
, 0
, '1023'
, 'S'
, 'N'
, 'P'
, 'AXL-CA')

GO
      


