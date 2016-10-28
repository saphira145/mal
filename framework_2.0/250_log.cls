<?php


	/*----------------------------------------------------
	  ログクラス
	----------------------------------------------------*/
	class log_class {


		/*============================================================================
		    システムログ開始
		============================================================================*/
		function log_class ( $theFileAP ) {

			global $ini;

			if ( is_array ( $ini["log"] ) ) {
				if ( array_sum  ( $ini["log"] ) > 0 ) {

					foreach ( $ini["log"] as $logType => $flg ) {

						if ( ( $flg <= 0 && $ini["log"]["ALL"] <= 0 ) || $logType == "ALL" ) { continue; }
						$this->base_logs ( $logType );

					}

				}
			}

		}


				function base_logs ( $logType ) {

					global $path;

					$logDat = array();

					switch ( $logType ) {

						case "system":
							array_unshift ( $logDat, $path["url"] );
							array_unshift ( $logDat, $class["session"]->memberID );
							array_unshift ( $logDat, date("H:i:s") );
							break;

						case "error":
							array_unshift ( $logDat, $path["url"] );
							array_unshift ( $logDat, $class["session"]->memberID );
							array_unshift ( $logDat, date("H:i:s") );
							break;

						case "system":
							array_unshift ( $logDat, $path["url"] );
							array_unshift ( $logDat, $class["session"]->memberID );
							array_unshift ( $logDat, date("H:i:s") );
							break;

						case "template":
							array_unshift ( $logDat, $path["url"] );
							array_unshift ( $logDat, $class["session"]->memberID );
							array_unshift ( $logDat, date("H:i:s") );
							break;

						case "session":
							array_unshift ( $logDat, $path["url"] );
							array_unshift ( $logDat, $class["session"]->memberID );
							array_unshift ( $logDat, date("H:i:s") );
							break;

						case "input":
							array_unshift ( $logDat, $path["url"] );
							array_unshift ( $logDat, $class["session"]->memberID );
							array_unshift ( $logDat, date("H:i:s") );
							break;

					}

					$this->make_logBase ( $logType, $logDat );

				}


						function make_logBase ( $logType, $logDat ) {

							global $path;

							$date   = date ( "Ymd" );
							$pathAP = preg_replace ( "#/#", "__", $path["unit"]["dirRP"] );
							$path["log"][$logType]["fileAP"] = pathGlue ( "{$path["logRoot"]["dirAP"]}/$logType/${date}_${pathAP}.log" );
							$fp = fopen( $path["log"][$logType]["fileAP"], 'a' );
								fputcsv( $fp, $logDat, "\t" );
							fclose( $fp );

						}



		/*============================================================================
		    システムログ保存
		============================================================================*/
		function systemLog ( $logType, $logKind, $logDat = NULL  ) {

			global $path, $class;
if(!$path["log"][$logType]["fileAP"]) return;
			if ( !is_array ( $logDat ) ) {
				$logData = $logDat;
				$logDat = array ( $logData );
			}

			array_unshift ( $logDat, $logKind );
			array_unshift ( $logDat, "" );

			$pathAP = preg_replace ( "#/#", "__", $path["unit"]["dirRP"] );
			if ( $fp = fopen( $path["log"][$logType]["fileAP"], 'a' ) ) {
					fputcsv( $fp, $logDat, "\t" );
				fclose( $fp );
			}

		}







	}





?>