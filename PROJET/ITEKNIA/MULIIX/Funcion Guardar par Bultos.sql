public function guardar(){
        \DB::beginTransaction();
        try{
            ini_set('memory_limit', '-1');
            set_time_limit(0);

            $tabla = json_decode(Request::input('tabla'), true);
            $fecha = Request::input('fechaRecibo');
            $fecha = explode('/', $fecha);
            $fecha = $fecha[2].$fecha[1].$fecha[0];
            
            for ($i = 0; $i < count($tabla); $i++) {
                $bultoId = $tabla[$i]['DT_RowId'];
                $numeroBulto = $tabla[$i]['BUL_NumeroBulto'];
                $almacenId = $tabla[$i]['ALM_AlmacenId'];
                $localidadId = $tabla[$i]['LOC_LocalidadId'];
                $complemento = $tabla[$i]['COMPLEMENTO'];

                if($complemento == 0) {
                    $consulta = "
                        SELECT 
                              BULD_BUL_BultoId
                            , BULD_OT_OrdenTrabajoId
                            , BULD_ART_ArticuloId
                            , BULD_Cantidad - ISNULL(BOR_Cantidad, 0.0) AS CANTIDAD
                            , LOT_LoteId
                            , OT_Codigo
                            , BUL_NumeroBulto
                            , '(' + ART_CodigoArticulo + ') ' + ART_Nombre AS ARTICULO
                            , ABS(CHECKSUM(NEWID())) AS CodigoLote
                        FROM Bultos
                        INNER JOIN BultosDetalle ON BUL_BultoId = BULD_BUL_BultoId
                        INNER JOIN OrdenesTrabajo ON BULD_OT_OrdenTrabajoId = OT_OrdenTrabajoId
                        INNER JOIN Articulos ON BULD_ART_ArticuloId = ART_ArticuloId
                        LEFT  JOIN (
                                    SELECT 
                                          BOR_BUL_BultoId
                                        , BOR_OT_OrdenTrabajoId
                                        , BOR_ART_ArticuloId
                                        , SUM(BOR_Cantidad) AS BOR_Cantidad
                                    FROM BultoOTRecibo
                                    GROUP BY 
                                          BOR_BUL_BultoId
                                        , BOR_OT_OrdenTrabajoId
                                        , BOR_ART_ArticuloId
                                   ) AS BultoOTRecibo ON BULD_BUL_BultoId = BOR_BUL_BultoId 
                                        AND BULD_OT_OrdenTrabajoId = BOR_OT_OrdenTrabajoId 
                                        AND BULD_ART_ArticuloId = BOR_ART_ArticuloId
                        LEFT  JOIN (
                                    SELECT 
                                          LOT_LoteId
                                        , LOT_ART_ArticuloId
                                        , ROW_NUMBER() OVER(PARTITION BY LOT_ART_ArticuloId ORDER BY LOT_LoteId, LOT_FechaCreacion DESC) AS FILA
                                    FROM Lotes
                                    WHERE LOT_Eliminado = 0
                                    ) AS Lotes ON BULD_ART_ArticuloId = LOT_ART_ArticuloId AND FILA = 1
                        WHERE BULD_Eliminado = 0
                              AND BULD_BUL_BultoId = '$bultoId'
                        GROUP BY 
                              BULD_BUL_BultoId
                            , BULD_OT_OrdenTrabajoId
                            , BULD_ART_ArticuloId
                            , BULD_Cantidad
                            , BOR_Cantidad
                            , LOT_LoteId
                            , OT_Codigo
                            , BUL_NumeroBulto
                            , ART_CodigoArticulo
                            , ART_Nombre
                        HAVING BULD_Cantidad - ISNULL(BOR_Cantidad, 0.0) > 0
                ";

                    $bulto = \DB::select(\DB::raw($consulta));

                    for ($x = 0; $x < count($bulto); $x++) {
                        $movimientos = new \stdClass();
                        $movimientos->ALMACEN_ID = $almacenId;
                        $movimientos->LOCALIDAD_ID = $localidadId;
                        $movimientos->LOTE_ID = $bulto[$x]->LOT_LoteId;
                        $movimientos->CANTIDAD = $bulto[$x]->CANTIDAD;

                        $ot = $bulto[$x]->OT_Codigo;
                        $articulo = $bulto[$x]->ARTICULO;

                        if(is_null($movimientos->LOTE_ID)){
                            $lote = new Lotes();
                            $lote->LOT_LoteId = $this->dao->nuevoId();
                            $lote->LOT_NumeroLote = '';
                            $lote->LOT_ART_ArticuloId = $bulto[$x]->BULD_ART_ArticuloId;
                            $lote->LOT_CodigoLote = $bulto[$x]->CodigoLote;
                            $lote->LOT_FechaCreacion = $this->dao->getFechaHoraServidorANSI();
                            $lote->LOT_FechaUltimaModificacion = $this->dao->getFechaHoraServidorANSI();
                            $lote->LOT_Eliminado = 0;
                            $lote->LOT_EMP_ModificadoPorId = DataBaseSession::getEmpleadoId();
                            $lote->LOT_CMM_EstatusLoteId = '362B0AC5-85A1-4DB1-A725-DA1C64702E7D';
                            $lote->LOT_FechaLote = $this->dao->getFechaHoraServidorANSI();
                            $lote->LOT_LoteManual = 0;
                            $lote->LOT_Cerrado = 0;
                            $lote->LOT_MateriaPrima = 0;
                            $lote->save();

                            $movimientos->LOTE_ID = $lote->LOT_LoteId;
                            //throw new \Exception("No se encontró ningún lote para el artículo $articulo del bulto $numeroBulto", 124);
                        }

                        $traspasoMovtoId = self::guardaTransferenciaMovto($movimientos, $bulto[$x]);

                        $bor = new BultoOTRecibo();
                        $bor->BOR_BultoOTReciboId = $this->dao->nuevoId();
                        $bor->BOR_OT_OrdenTrabajoId = $bulto[$x]->BULD_OT_OrdenTrabajoId;
                        $bor->BOR_BUL_BultoId = $bultoId;
                        $bor->BOR_ART_ArticuloId = $bulto[$x]->BULD_ART_ArticuloId;
                        $bor->BOR_FechaRecibo = $fecha;
                        $bor->BOR_Cantidad = $bulto[$x]->CANTIDAD;
                        $bor->BOR_EMP_CreadoPorId = DataBaseSession::getEmpleadoId();
                        $bor->BOR_EMP_ModificadoPorId = DataBaseSession::getEmpleadoId();
                        $bor->BOR_TRAM_TraspasoMovtoId = $traspasoMovtoId;
                        $bor->save();
                    }
                }

                $bul = Bultos::find($bultoId);
                $bul->BUL_CMM_EstatusBultoId = self::RECIBO_COMPLETO;
                $bul->save();

            }

            \DB::commit();

            $ajaxData = array();
            $ajaxData['codigo'] = 200;
            return json_encode($ajaxData);
        } 
        catch (\Exception $e){
            \DB::rollback();

            if($e->getCode() == '124') {
                header('HTTP/1.1 500 Internal Server Error');
                header('Content-Type: application/json; charset=UTF-8');
                die(json_encode(array("mensaje" => $e->getMessage(),
                    "codigo" => '',
                    "clase" => '',
                    "linea" => '')));
            } else {
                header('HTTP/1.1 500 Internal Server Error');
                header('Content-Type: application/json; charset=UTF-8');
                die(json_encode(array("mensaje" => $e->getMessage(),
                    "codigo" => $e->getCode(),
                    "clase" => $e->getFile(),
                    "linea" => $e->getLine())));
            }
        }
    }