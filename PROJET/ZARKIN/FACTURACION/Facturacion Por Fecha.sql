


SELECT mgw10008.ciddocum01
	, mgw10008.cseriedo01
	, mgw10008.cfolio
	, mgw10008.cfecha
	, mgw10002.ccodigoc01
	, mgw10008.crazonso01
	, mgw10010.cprecio
	, mgw10010.cneto
	, mgw10010.cimpuesto1
	, mgw10010.ctotal
	, mgw10008.cpendiente
	, mgw10010.cunidades
	, mgw10005.cnombrep01
	, mgw10005.ccodigop01
	, mgw10008.ccancelado
	, mgw10008.cidconce01
	, mgw10008.cidmoneda
	, mgw10008.ctipocam01
	, mgw10008.cobserva01
	, mgw10008.creferen01&#13;&#10;
FROM mgw10002 mgw10002, mgw10005 mgw10005, mgw10008 mgw10008
, mgw10010 mgw10010&#13;&#10;
WHERE mgw10008.ciddocum01 = mgw10010.ciddocum01 AND mgw10002.cidclien01 = mgw10008.cidclien01 
AND mgw10010.cidprodu01 = mgw10005.cidprodu01 
AND ((mgw10008.cidconce01=$4) OR (mgw10008.cidconce01=$3008))&#13;&#10;
ORDER BY mgw10008.ciddocum01, mgw10008.cfecha, mgw10008.cfolio

</odc:CommandText>