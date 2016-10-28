<?php

	/* -----------------------------------------------------
	    入力チェッククラス
	----------------------------------------------------- */
	class inputCheck_class {

		/* -----------------------------------------------------
		    入力チェックの実行
		----------------------------------------------------- */
		function exec_inputCheck ( $inputCheckGroup, $flg_doubleCheck="yes" ) {

			global $ini, $justInput, $input;

			if ( $ini["doubleCheckFlag"] == 1 && $flg_doubleCheck != "yes" ) {
				return $input;
			}
			$ini["doubleCheckFlag"] = 1;

			// ■■ ここから入力チェック！ ■■

			// 入力チェック設定の展開
			$inputSet = $this->fix_inputCheckSetting ( $inputCheckGroup );

			// 入力チェック
			$input = $this->inputSetup ( $inputSet["fwValidator_noloop"] );

			// ■■ ここまで！ ■■

			return (array)$input;

		}


			function fix_inputCheckSetting ( $inputCheckGroup ) {

				global $ini;

				$inputCheckList = array ();

				for ( $i=0; $i<count($inputCheckGroup); $i++ ) {

					if ( count($ini["inputList"][$inputCheckGroup[$i]]) > 0 ) {
						if ( is_array ( $ini["inputList"][$inputCheckGroup[$i]] ) ) {
							foreach ( $ini["inputList"][$inputCheckGroup[$i]] as $key => $value ) {
								$evalLine = "\$inputSet";
								preg_match_all ( "#\.|/|[^\./]*#", $key, $fieldMatch );
								$validatorType = "no";
								for ( $j=0; $j<count($fieldMatch[0])-1; $j++ ) {
									switch ( $fieldMatch[0][$j] ) {
										case ".":
											$validatorType = "no";
											break;
										case "/":
											$validatorType = "";
											break;
										default:
											$evalLine .= "[\"fwValidator_{$validatorType}loop\"][\"{$fieldMatch[0][$j]}\"]";
									}
								}
								if ( $ini["field"][$value["group"]] != "" ) {
									$value["func"] = $ini["field"][$value["group"]];
									foreach ( $value["func"] as $cKey => $checker ) {
										for ( $k=0; $k<count($checker); $k++ ) {
											if ( is_array ( $checker[$k]["argument"] ) ) {
//												$arParam = explode ( ",", $value["parameter"] );
$arParam = $value["parameter"];
												for ( $l=0; $l<count($checker[$k]["argument"]); $l++ ) {

														// FIELD.lst 由来の {xxx} をエスケープする
														$value["func"][$cKey][$k]["argument"][$l] = preg_replace( '/{/', '\{', $value["func"][$cKey][$k]["argument"][$l] );
														$value["func"][$cKey][$k]["argument"][$l] = preg_replace( '/}/', '\}', $value["func"][$cKey][$k]["argument"][$l] );

//													preg_match_all ( "#\{(\d+)\}#", $value["func"][$cKey][$k]["argument"][$l], $paraMatch, PREG_SET_ORDER );
preg_match_all ( "#\\\{(\d+)\\\}#", $value["func"][$cKey][$k]["argument"][$l], $paraMatch, PREG_SET_ORDER );
													$paraCount = $paraMatch[0][1] - 1;
													$paraValue = preg_replace ( "#\{#", "\\\{", $paraMatch[0][0] );
													$paraValue = preg_replace ( "#\}#", "\\\}", $paraValue );
													$value["func"][$cKey][$k]["argument"][$l] = preg_replace ( "#$paraValue#", "{$arParam[$paraCount]}", $value["func"][$cKey][$k]["argument"][$l] );
												}
											}
										}
									}

									$eval  = "{$evalLine}['accept']=\$value['accept'];\n";
									$eval .= "{$evalLine}['field']=\$value['field'];\n";
									$eval .= "{$evalLine}['group']=\$value['group'];\n";
									$eval .= "{$evalLine}['parameter']=\$value['parameter'];\n";
									$eval .= "{$evalLine}['func']=\$value['func'];\n";
/*
									$evalLine .= "['field']=\$value['field'];";
									$evalLine .= "['group']=\$value['group'];";
									$evalLine .= "['parameter']=\$value['parameter'];";
									$evalLine .= "['func']=\$value['func'];";
*/
									eval ( $eval );
								}
								else {
								}
							}

						}
					}

				}

				return $inputSet;

			}


			/* -----------------------------------------------------
			    
			----------------------------------------------------- */
			function inputSetup ( $inputSet ) {

				global $ini, $input, $justInput, $fwArrayBreadCrumb;

				if ( ! is_array( $inputSet ) || count( $inputSet ) == 0 ) {
					return;
				}

				foreach ( $inputSet as $key => $value ) {

					$fwArrayBreadCrumb["inputSet"][] = $key;

					// チェック設定あり
					if ( isset( $value["func"] ) ) {
						$input = $this->checkLoop ( $value["func"], $value["field"], $value["accept"] );
					}

					// 下位階層に移る前にループを挟む
					if ( isset( $value["fwValidator_loop"] ) ) {

						$str = '["' . @implode('"]["', $fwArrayBreadCrumb["inputSet"] ) . '"]';

						// ループ回数
						$keys = array();
						eval( 'foreach(array_keys((array)$justInput' . $str . ') as $key){if(preg_match(\'/^[0-9]+$/\',$key)){$keys[] = $key;}}' );
						foreach ( $keys as $key ) {
							$fwArrayBreadCrumb["inputSet"][] = $key;
							$fwArrayBreadCrumb["inputSetLoop"][] = $key;
							$ret = $this->inputSetup ( $value["fwValidator_loop"] );
							array_pop( $fwArrayBreadCrumb["inputSetLoop"] );
							array_pop( $fwArrayBreadCrumb["inputSet"] );
						}

					}

					// 下位階層に移る前にループは不要
					if ( isset( $value["fwValidator_noloop"] ) ) {
						$ret = $this->inputSetup ( $value["fwValidator_noloop"] );
					}

					array_pop( $fwArrayBreadCrumb["inputSet"] );

				}


				return $input;

			}


			/* -----------------------------------------------------
			    入力チェックループ
			----------------------------------------------------- */
			function checkLoop ( $func, $field, $accept=0 ) {

				global $ini, $input, $justInput;

				// エラーレベル初期値
				$this->errorLevel = 10000;

				foreach ( array( "convert", "filter", "check" ) as $funcType ) {

					$iMax = count( $func[$funcType] );

					for ( $i=0; $i<$iMax; ++$i ) {

						// チェック関数
						$function = strtoupper($funcType) . "_" . $func[$funcType][$i]["process"];

						if ( is_callable ( $function ) ) {

							// 引数
							if ( is_array( $func[$funcType][$i]["argument"] ) ) {

								$jMax = count( $func[$funcType][$i]["argument"] );
								for ( $j=0; $j<$jMax; ++$j ) {


									// 引数内の変数から入力値に変換
									$str = $this->conv_fieldToInput( $func[$funcType][$i]["argument"][$j], $field, '$justInput' );

									if ($str != "") {
										$evalLine = "\$func[{$funcType}][{$i}][\"argument\"][{$j}] = \"" . $str . '";';
										eval( $evalLine );
									}

								}

							}

							// フィールド名から入力値に変換
							$str = $this->conv_fieldToInput( "{{$field}}" );

							if ($str != "") {
								$evalLine = "\$value = &\$justInput" . $str . ';';
								eval( $evalLine );
							}

							// チェック関数実行
							$err = $function( &$value, $field, $func[$funcType][$i]["argument"] );

							// エラー処理：メッセージ処理
							if ( $err == 1 ) {

								if ( $func[$funcType][$i]["priority"] > 0 ) {

									// エラー (+err) 生成
									$vErr = preg_replace ( '/"]$/', '+err"]', $str );

									if ( $this->minErrorPriority[$field] > $func[$funcType][$i]["priority"] ) {

										$evalLine = "\$input{$vErr} = array();";
										eval( $evalLine );
										$evalLine = "\$input{$vErr}[][\"msg\"] = \"{$func[$funcType][$i]["message"]}\";";
										eval( $evalLine );
										$this->minErrorPriority[$field] = $func[$funcType][$i]["priority"];
									}
									elseif ( $this->minErrorPriority[$field] == 0 || $this->minErrorPriority[$field] == $func[$funcType][$i]["priority"] ) {
										$evalLine = "\$input{$vErr}[][\"msg\"] = \"{$func[$funcType][$i]["message"]}\";";
										eval( $evalLine );
										$this->minErrorPriority[$field] = $func[$funcType][$i]["priority"];
									}

									$this->errorLevel = (integer)$this->errorLevel;
									if ( $this->errorLevel == 0 || $this->errorLevel > $this->minErrorPriority[$field] ) {
										$this->errorLevel = $this->minErrorPriority[$field];
									}

								}

							}

						}

					}

				}

				// 入力値の受け入れ可否
				if ( $accept == 1 ) {
					$evalLine = "\$input{$str} = \$justInput{$str};";
					eval( $evalLine );
				}

				if ( $this->errorLevel > 0 && $this->errorLevel < 10000 ) {
					$input["errSetFlag"] = 1;
					if ( $this->errorLevel >= 100 && $this->errorLevel < 1000 ) {
						$ini["system"]["errRank"] = 2;
					}
					elseif ( $this->errorLevel > 0 && $this->errorLevel < 100 ) {
						$ini["system"]["errRank"] = 1;
					}
				}


				return $input;

			}


			/* -----------------------------------------------------
			    フィールド名を配列の添え字形式に展開
			    変換例: {members/name.family}
			            → ["members"][3]["name"]["family"]
			            {members/name.family}
			----------------------------------------------------- */
			function conv_fieldToInput ( $str, $field="", $valHeader="" ) {

				global $justInput, $fwArrayBreadCrumb;


				// 変数が含まれているか?
				if ( ! preg_match( '/\{.+\}/', $str, $matches ) ) {
					return;
				}


				// フィールド名から階層を取得
				preg_match( '/(.*[\/\.])*[^\/\.]+$/', $field, $matches );
				$fieldPath = ( $matches[1] == "" )
					? ""
					: $matches[1];

				// . で始まる変数
				$str = preg_replace( '/\{\.([^\}]+)\}/', "{{$fieldPath}$1}", $str );
				// / で始まる変数
				$str = preg_replace( '/\{\/([^\}]+)\}/', "{{$fieldPath}$1}", $str );

				// 変数を置換
//				while ( preg_match( '/\{([^\$][^\}]*)\\?\}/', $str, $matches ) ) {
				while ( preg_match( '#\{([^\$][^\}\\\]*)\}#', $str, $matches ) ) {
					$new = '$["' . preg_replace( "/\./", '"]["', $matches[1] ) . '"]';
					$str = preg_replace( "#{$matches[1]}#", "{$new}", $str );
				}

				// '/' はループに置換
				$str = preg_replace( '/\//', '"][fwValidator_loop]["', $str, -1, $count );
				$old = array_pad( array(), $count, '/fwValidator_loop/' );
				$str = preg_replace( $old, $fwArrayBreadCrumb["inputSetLoop"], $str, 1 );

				if ( $valHeader === "" ) {
//					$str = preg_replace( '/{\$(.*)}/', "$1", $str );
					$str = preg_replace( '/{\$([^}]*)}/', "$1", $str );
				}
				else {
//					$str = preg_replace( '/{\$(.*)}/', "{{$valHeader}$1}", $str );
					$str = preg_replace( '/{\$([^}]*)}/', "{{$valHeader}$1}", $str );
				}

				// FIELD.lst 由来の {xxx} のエスケープをはずす
				$str = preg_replace( '/\\\{/', '{', $str );
				$str = preg_replace( '/\\\}/', '}', $str );

				return $str;

			}

	}
?>
