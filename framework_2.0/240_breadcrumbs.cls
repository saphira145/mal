<?php


	/*----------------------------------------------------
	  ブレッドクラムクラス
	----------------------------------------------------*/
	class breadcrumbs_class {




		/*----------------------------------------------------
		  ブレッドクラムリスト
		----------------------------------------------------*/
		function create_breadcrumbList_class() {

			global $path, $class, $output;

			// ブレッドクラムクッキーKEY
			$this->bcPlot = "ngdFW034bcPlot";
			$this->bcRet  = "ngdFW034bcReturn";

			// 読み込み対象ファイルリストの取得
			for ( $i = 0; $i < count( $class["framework"]->dirPathListStep["externalFile"] ); $i++ ) {

				// フィールド設定ファイル名は固定なので、パスはすぐに決定できる
				$fullpath = $class["framework"]->dirPathListStep["externalFile"][$i] . "/" . $path["breadcrumbsList"]["fileName"];

				// 対象ファイルが存在すれば・・・
				if ( is_readable ( $fullpath ) ) {

					// 対象ファイルを設定ファイルとして読み込む
					$fieldConf   = read_conf_file ( $fullpath );

					// 読み込んだ情報をブレッドクラム設定として解析する
					$fieldEval = preg_replace ( "#( |　|\t)*=( |　|\t)*#", "=", $fieldConf );
					$fieldEval = preg_replace ( "#(.+)=(\d*),([^\n]+)#", "\$this->name[\"$1\"]=\"$3\";\n\$this->return[\"$1\"]=\"$1\";\n\$this->depth[\"$1\"]=$2;", $fieldEval );
					$fieldEval = preg_replace ( "#(\\\$this->(name|return|depth)\[[^\]]*)(\([^\)]*\))([^\]]*])#", "$1$4", $fieldEval );
					$fieldEval = preg_replace ( "#(\\\$this->return\[[^\]]*\]=\")([^\(]*)(\(?)([^\)]*)(\)?)([^;]*;)#", "$1$2$4$6", $fieldEval );

					eval ( $fieldEval );

				}

			}


			if ( is_array ( $this->depth ) ) {
				foreach ( $this->depth as $key=>$depth ) {
					$this->order[] = $key;
					if ( $depth > 0 && $lastKeyByDepth[$depth-1] != "" ) {
						$this->parent[$key] = $lastKeyByDepth[$depth-1];
					}
					$lastKeyByDepth[$depth] = $key;
				}
			}

			$this->add_outputToBREADCRUMBS();

			$output["BREADCRUMBS"] = $this->breadcrumbs;
			$output["RETURN"]      = $this->output["RETURN"];

		}




		/*----------------------------------------------------
		  ブレッドクラム設定
		----------------------------------------------------*/
		function add_outputToBREADCRUMBS() {

			global $ini, $path;

			// ディレクトリからブレッドクラム配列を生成
				// status 付き
				$bcStr = $path["script"]["url"] == "" ? "/" : urldecode( $path["unit"]["actionRP"] );
				$this->parentBcStr = $bcStr;

				if ( !$this->set_priorPlot() ) {

					// smallStatus 付き
					$bcStr = $path["script"]["url"] == "" ? "/" : urldecode( $path["unit"]["actionRPs"] );
					$this->parentBcStr = $bcStr;

					if ( !$this->set_priorPlot() ) {

						// GETを削って探す
						$scriptURL = $path["unit"]["actionRP"];
						for ( $i=0; $i<100; $i++ ) {
							$bcStr = $path["script"]["url"] == "" ? "/" : urldecode( $scriptURL );
							$this->parentBcStr = $bcStr;
							if ( $this->set_priorPlot() || $pre_scriptURL == $scriptURL ) { break; }
							$pre_scriptURL = $scriptURL;
							$scriptURL = preg_replace ( "#&[^&]*$#", "", $scriptURL );
						}

					}

				}


				// 階層情報のまとめ
				$priorPlot = $this->plot;
				if ( is_array( $priorPlot ) ) {
					krsort($priorPlot);
					$maxPriorPlot = array_shift ( $priorPlot );
					$maxPriorPlotDepth = $this->depth[$maxPriorPlot];
					$minPriorPlot = array_pop ( $priorPlot );
					$minPriorPlotDepth = $minPriorPlot == "" ? 1 : $this->depth[$minPriorPlot];
				}
				$this->return[$this->plot[$maxPriorPlotDepth]] = $path["script"]["url"];


			// クッキーからブレッドクラム情報を取り出し上書きする
			if ( is_array ( $_COOKIE[$this->bcPlot] ) && $ini["breadcrumbs"]["priorPlot"] != 1 ) {

				foreach ( $_COOKIE[$this->bcPlot] as $cDepth=>$cVal ) {

					$decoded_cVal = urldecode ( $cVal );
					$array_cookieValue = explode ( "/", $decoded_cVal );
					unset ( $ar_cVal );

					for ( $i=0; $i<count($array_cookieValue); $i++ ) {
						if ( $array_cookieValue[$i] != "" ) {
							$ar_cVal[] = $array_cookieValue[$i];
						}
					}

					if ( count($ar_cVal) > 0 ) {
						$cArr     = "[\"" . join ( "\"][0][\"", $ar_cVal ) . "\"]";
						$cRet     = $_COOKIE[$this->bcRet][$cDepth] != "" ? $_COOKIE[$this->bcRet][$cDepth] : "";
						$urccRetstr = urldecode($cRet);
						if ( !preg_match ( "#\"#", $urccRetstr ) ) {
							$theEval  = "\$this->output[\"RETURN\"]{$cArr}[\"LINK\"] = \"$urccRetstr\";\n";
							$cRetEval .= $theEval;
						}
					}

					// 現在の深度より浅いか、そして設定が存在しているクッキーは有効か！？
					if ( $cDepth < $maxPriorPlotDepth && $this->name[$decoded_cVal] != "" ) {
						$this->plot[$cDepth]   = $decoded_cVal;
						$this->return[$this->plot[$cDepth]] = $_COOKIE[$this->bcRet][$cDepth] != "" ? urldecode($_COOKIE[$this->bcRet][$cDepth]) : "";
					}

				}

				eval ($cRetEval);

			}

			// クッキーを設定する
			if ( $maxPriorPlotDepth > 0 ) {

				$bcRetKey  = "{$this->bcRet}[$maxPriorPlotDepth]";
				$bcRetVal  = urlencode( $path["script"]["url"] );
				setcookie( $bcRetKey, $bcRetVal, 0, "/", $path["host"]["name"] );
				$bcLastKey = "{$this->bcPlot}[$maxPriorPlotDepth]";
				$bcLastVal = urlencode( $this->plot[$maxPriorPlotDepth] );
				setcookie( $bcLastKey, $bcLastVal, 0, "/", $path["host"]["name"] );

				// クッキーを消す
				for ( $j = 20; $j > $maxPriorPlotDepth; $j-- ) {
					if ( $_COOKIE[$this->bcPlot][$j] != "" ) {
						setcookie( "{$this->bcPlot}[$j]", "", time()-3600, "/", $path["host"]["name"] );
						setcookie( "{$this->bcRet}[$j]",  "", time()-3600, "/", $path["host"]["name"] );
					}
				}

			}


			// ブレッドクラム配列の生成
			$j=0;
			for ( $i=$minPriorPlotDepth; $i<=$maxPriorPlotDepth; $i++ ) {
				$this->breadcrumbs[$j]["link"] = $this->return[$this->plot[$i]];
				$this->breadcrumbs[$j]["name"] = $this->name[$this->plot[$i]];
				$j++;
			}


		}








			function matching_cookieBcList( $j, $bcPart ) {

				global $ini;

				$sl   = $j != 1 ? "/" : "";
				$dir .= $sl . $bcPart;

				if ( $_COOKIE[$this->bcPlot][$j] != "" && $ini["breadcrumbs"]["priorPlot"] != 1 ) {
					$ccStr       = pathGlue ( $_COOKIE[$this->bcPlot][$j] . "/" );
					$ccArray     = explode ( "/", $ccStr );
					$ccListCount = count ( $ccArray ) - 2;
					if ( $bcListCount > $ccListCount ) {
						$this->bcList[$j] = $_COOKIE[$this->bcPlot][$j];
					}
				}
				else {
					$this->bcList[$j] = $dir;
				}


			}


			/*----------------------------------------------------
			  設定通りにブレッドクラムを配置する
			----------------------------------------------------*/
			function set_priorPlot() {

				$depth = sprintf( "%d", $this->depth[$this->parentBcStr] );

				if ( $depth > 0 ) { $return = false; }

				$hitFlag = 1;

				while ( $this->parentBcStr != "" ) {

					$depth = sprintf( "%d", $this->depth[$this->parentBcStr] );

					if ( $depth > 0 ) {

						$this->plot[$depth] = $this->parentBcStr;

						if ( $this->parent[$this->parentBcStr] != "" ) {
							$this->parentBcStr = $this->parent[$this->parentBcStr];
							continue;
						}

					}

					$this->parentBcStr = preg_replace ( "#/[^/]*$#", "", $this->parentBcStr );

				}

				$ini["bck"]["plot"] = $this->plot;


				return $return;

			}













		/*----------------------------------------------------
		  GETパラメータをクッキーに入れる
		----------------------------------------------------*/
		function set_getParamURL( $getInfo ) {

			$this->keyArray = array();
			$ret = $this->openArray( $getInfo );


		}


		/*----------------------------------------------------
		  配列を文字列に展開する
		----------------------------------------------------*/
		function openArray( $getInfo ) {

			if ( is_array ( $getInfo ) ) {
				foreach ( $getInfo as $key=>$val ) {
					if ( is_array ( $val ) ) {
						$this->keyArray[] = $key;
						$ret .= $this->openArray( $val );
					}
					else {
						if ( count ( $this->keyArray ) > 0 ) {
							$firstKey = array_shift ( $this->keyArray );
							$keyString  = "{$firstKey}[".join ( "][", $this->keyArray )."]";
							$this->keyArray = array();
							$ret .= "{$keyString}[$key]=\"$val\";<br>\n";
						}
						else {
							$ret = "$key=\"$val\";<br>\n";
						}
					}
				}
			}

			return $ret;

		}





	}



?>