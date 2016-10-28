<?php



	/*■■■■■■■■■■■■■■■■■■■■■■■■■■■■

	      フレームワーククラス

	 ■■■■■■■■■■■■■■■■■■■■■■■■■■■■*/


	class framework_class {



		/*============================================================================
		    コンストラクタ
		    ■■ 外部ファイル読み込み ■■
		============================================================================*/
		function framework_class () {

			global $path, $ini, $input, $argv, $pathInput, $pathInfo;

			// 外部ファイルパス設定
			$this->dirPathListStep["logic"]           = $this->set_application_dir_list ();
			$this->dirPathListStep["externalFile"]    = $this->dirPathListStep["logic"];
			array_unshift ( $this->dirPathListStep["externalFile"], $path["frameworkRoot"]["dirAP"] );
			$this->filePathList["externalFile"] = $this->get_outer_filelist( $this->dirPathListStep["externalFile"] );

			/*
			    NUMBERED外部ファイルの階層的取り込み
			    ※ディレクトリをさかのぼる
			        【ファイル例】
			            210_array_mix.fnc
			            110_public.ini
			*/

				//  NUMBERED外部ファイルの取り込み
				$this->include_numbered_outerfile ();

				//  定型外部ファイルの取り込み
				$this->include_fixed_outerfile ();

				// mb_internal_encoding
				if ( isset( $ini["mb_internal_encoding"] ) ) {
					mb_internal_encoding( $ini["mb_internal_encoding"] );
				}


			/*
			    リスト設定の取り込み
			            形態：特殊リスト形態である為、特別な解析が必要
			*/

				//  入力チェックリスト  ※ディレクトリをさかのぼる
				$this->setup_input_list ();

				// ACTION-INPUTファイルの読み込み
				$this->setup_actionInput_list ();

				//  フィールドリスト  ※ディレクトリをさかのぼる
				$this->setup_field_list ();

				// パスインフォが無い時は４０４
				if( $ini["script"]["type"] != "bat" ) {
					for ( $i = 0; $i < count($pathInfo); $i++ ) {
						if ( $pathInfo[$i] != "" && $ini["input"]["lineOrder"][$i] == "" ) {
							$path["actionList"] = "";
							$ini["logicAction"] = "";
							$ini["view"] = 404;
							break;
						}
					}
				}

		}


			/*----------------------------------------------------
			    初期値取り込み
			----------------------------------------------------*/
			function get_justInput ( $sessionFlag="" ) {

				global $ini, $pathInput;

				// POST ストリップスラッシュする
				arrayWalk_recursive ( $_POST, array( $this, "aw_stripslashes" ) );

				// GET ストリップスラッシュする
				arrayWalk_recursive ( $_GET, array( $this, "aw_stripslashes" ) );

				// コマンドラインパラメーターの取得
				@array_shift( $argv );

				// アップロードファイル
				$this->arrayFileExchange["nest"] = -1;
				$this->arrayFileExchange( $_FILES );

				// FCパラメーター
/*
				if ( count( $ini["input"] ) > 0 && is_array ( $ini["input"] ) ) {
					arrayWalk_recursive ( $pathInput, array( $this, "aw_stripslashes" ) );
					for ( $i=0; $i<count($pathInput); $i++ ) {
						$pathParam[$ini["input"]["lineOrder"][$i]] = $pathInput[$i];
					}
				}
*/
				arrayWalk_recursive ( $pathInput, array( $this, "aw_urldecode" ) );
				arrayWalk_recursive ( $pathInput, array( $this, "aw_stripslashes" ) );

				for ( $i=0; $i<count($pathInput); $i++ ) {
					$pathParam[$ini["input"]["lineOrder"][$i]] = $pathInput[$i];
				}

				// インプットミックス
				if ( $sessionFlag == "session" ) {
					$ret = array_mix ( $argv, $this->arrayFXS, $_POST, $pathParam, $_GET );
				}
				else {
					$ret = array_mix ( $argv, $this->arrayFX,  $_POST, $pathParam, $_GET );
				}

				return $ret;

			}

				/*----------------------------------------------------
				    ストリップスラッシュ
				----------------------------------------------------*/
				function aw_stripslashes ( &$value ) {

					global $ini;

					$value = stripslashes ( $value );
//					$value = urldecode ( $value );
					$value = mb_convert_encoding( $value, "UTF-8", "auto" );

				}

				/*----------------------------------------------------
				    urldecode
				----------------------------------------------------*/
				function aw_urldecode ( &$value ) {

					$value = urldecode ( $value );

				}

				/*----------------------------------------------------
				    存在する外部ファイルリストの取得
				----------------------------------------------------*/
				function get_outer_filelist ( $dirlist ) {

					if ( is_array ( $dirlist ) ) {

						foreach ( $dirlist as $key => $dir ) {

							$filelist = $this->scandir_4 ( $dir );

							unset ( $eret );

							// 読み込み対象ファイルを読み込む
							for ( $j = 0; $j < count( $filelist ); $j++ ) {

								$fullpath = $dir . "/" . $filelist[$j]["filename"];

								// ファイルタイプの選別
								if ( is_readable ( $fullpath ) ) {
									if ( preg_match ( "/^[a-zA-z0-9_]/", basename( $fullpath ) ) && filetype( $fullpath ) == "file" ) {
										$eret[] = $fullpath;
									}
								}

							}

							@usort ( $eret, array ( $this, "usort_by_filename" ) );
							if ( !is_array ( $ret ) ) { $ret = array(); }
							if ( is_array ( $eret ) ) {
								$ret = (array)array_merge( $ret, $eret );
							}
						}

						return $ret;

					}

				}


					/*----------------------------------------------------
					    外部ファイルリストの並べ替え
					----------------------------------------------------*/
					function usort_by_filename ( $a, $b ) {

						$filename_a = preg_replace ( "#.+/#", "", $a );
						$filename_b = preg_replace ( "#.+/#", "", $b );


						return ($filename_a < $filename_b) ? -1 : 1;

					}




				/*----------------------------------------------------
				    アプリケーションディレクトリの取得
				----------------------------------------------------*/
				function set_application_dir_list () {

					global $path;

					// アプリケーションローカルパスを配列で取得
					$app_local_pathname = explode( "/", $path["unit"]["dirRP"] );

					// 階層毎のディレクトリ処理
					for ( $i = 0; $i < count( $app_local_pathname ); $i++ ) {
						$app_local_dir .= $app_local_pathname[$i];
						$ret[$i] = $path["logicRoot"]["dirAP"] . pathGlue ( $app_local_dir );
						$app_local_dir .= "/";
					}

					return $ret;

				}


				/*----------------------------------------------------
				    ディレクトリ・ファイルリストの取得
				         （scandirのphp ver4向け)
				       ※階層的にディレクトリサーチはしません！
				----------------------------------------------------*/
				function scandir_4 ( $dir, $for="all", $add_path="path_off" ) {

					if ( is_dir( $dir ) ) {
						if ( $DH = opendir( $dir ) ) {
							$rDir = ( $add_path == "path_on" ) ? $dir . "/" : "";
							$n = 0;
							while ( ( $file = readdir( $DH ) ) !== false ) {
								$filetype = filetype( $dir . "/" . $file );
								if ( $for == "all" ) {
									$file_list[$n]["filename"] = $rDir . $file;
									$file_list[$n]["filetype"] = $filetype;
								}
								elseif ( $for == "file" || $for == "dir" ) {
									if ( $filetype != $for ) { continue; }
									$file_list[$n] = $rDir . $file;
								}
								else {
									$ext = get_extention ( $file );
									if ( $ext != $for ) { continue; }
									$file_list[$n] = $rDir . $file;
								}
								$n++;
							}
							closedir( $DH );
						}
						else { return false; }
					}
					else { return false; }

					return $file_list;

				}







		/*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		    (1) NUMBERED外部ファイルの階層的取り込み
		-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
		function include_numbered_outerfile ( $bottom=0, $top=1000 ) {

			if ( $top > $bottom ) {

				// 読み込み対象ファイルリストの取得
				for ( $i = 0; $i < count( $this->filePathList["externalFile"] ); $i++ ) {

					// 先頭に数字のあるファイルのみを選別
					if ( preg_match ( "/^[0-9]+/", basename( $this->filePathList["externalFile"][$i] ), $match ) ) {
						if ( $bottom <= $match[0] && $match[0] < $top ) {
							$this->include_outerfile ( $this->filePathList["externalFile"][$i], "must" );
						}
					}

				}

			}

		}


				/*----------------------------------------------------
				    外部ファイルの取り込み：ファイル単体
				----------------------------------------------------*/
				function include_outerfile ( $fullpath, $must="no" ) {

					global $ini, $path, $input, $output, $class, $theClass, $newAppClass;

					// 読み込み可能なファイルであれば・・・
					if ( is_readable ( $fullpath ) ) {

						// 拡張子の取り出し
						preg_match ( "#[^\.]+$#", $fullpath, $match );
						$ext = $match[0];

						// 拡張子によって取込方を変える
						switch ( $ext ) {
							case "ini":
								// 読み込む
								$conf_data = read_conf_file ( $fullpath );
								$this->parse_ini_data ( $conf_data, $fullpath );
								return true;
								break;
							default:
								// 読み込む
								include_once ( $fullpath );
								return true;
								break;
						}

					}

					// 読み込めない（もしくは存在しない）ファイルであれば・・・
					elseif ( $must == "must" ) {
						$ini["fwerr"][][6] = "FrameWork :: 外部ファイルがありません。";
						$ini["fwerr"][][7] = "path: $fullpath";
					}

				}


						/*----------------------------------------------------
						    初期データの展開設定
						----------------------------------------------------*/
						function parse_ini_data ( $confData="empty", $fullPath=NULL ) {

							global $ini, $val, $path;

							if ( $confData != "empty" ) {

								// 改行コード統一 (無駄ループさせないため)
								$confData = str_replace( "\r", "\n", str_replace( "\r\n", "\n", $confData ) );

								$line = preg_split ( "/[\n\r]/", $confData );

								$iMax = count( $line );
								for ( $i=0; $i<$iMax; ++$i ) {
									$aLine = trim ( $line[$i] );
									list ( $key, $value ) = explode ( "=", $aLine );
									$key   = trim ( $key );
									if ( $key == "" ) { continue; }
									if ( $key == "session.mode" && $value == "loginStrict" ) {
										$thePath = preg_replace ( "#(^{$path["logicRoot"]["dirAP"]})|(/[^/]*)$#", "", $fullPath );
										$ini["session"]["loginStrict"] = $thePath;
									}
									else {
										$value = trim( $value );
										if ( $value !== "" ) {
											// "" が閉じていなければ、値に改行が含まれていると見なす
											while ( preg_match( '/^"([^"]*)$/', $value ) ) {
												$i++;
												$value .= "\n" . $line[$i];
											}
										}

										// 変数内の "/" の展開
										if ( preg_match( "#/#", $key ) ) {
											$p = split( "/", $key );
											$jMax = count( $p );
											$arr = array();
											for ( $j=0; $j<$jMax; ++$j ) {
												$p2 = implode( "/", array_slice( $p, 0, $j+1 ) );
												$p3 = implode( "/", array_slice( $p, $j+1 ) );
												if ($p3 !== "") {;
													if (! $pointer[$p2][$p3] ) {
														$pointer[$p2][$p3] = 0;
													}
													$arr[] = "\"][{$pointer[$p2][$p3]}][\"";
													$pointer[$p2][$p3]++;
												}
											}
										}
										$arr2 = array_pad( array(), count( $arr ), '#/#' );
										$key = preg_replace( $arr2, $arr, $key, 1 );
									}

									$key = "[\"" . preg_replace ( "/\./", "\"][\"", $key ) . "\"]";

									$value = trim ( $value );
									$value = preg_replace ( "/(^\"|\"$)/", "", $value );
									$value = addslashes ( $value );
									$eval = "\$ini$key = \"$value\";";

									eval( $eval );

								}

							}

						}




		/*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		    入力チェックリスト設定の取り込み
		-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
		function setup_input_list() {

			global $ini, $path;

			/*
			    $this->dirPathListStep["externalFile"] = ARRAY 読み込み対象ディレクトリリスト
			*/

			// 読み込み対象ファイルリストの取得
			for ( $i = 0; $i < count( $this->dirPathListStep["externalFile"] ); $i++ ) {

				// フィールド設定ファイル名は固定なので、パスはすぐに決定できる
				$fullpath = $this->dirPathListStep["externalFile"][$i] . "/" . $path["inputList"]["fileName"];

				// 対象ファイルが存在すれば・・・
				if ( is_readable ( $fullpath ) ) {

					// 対象ファイルを設定ファイルとして読み込む
					$fieldConf   = read_conf_file ( $fullpath );

					// 読み込んだ情報を入力チェック設定として解析する
					$ini["inputList"] = array_mix ( $ini["inputList"], $this->parse_input_list ( $fieldConf ) );

					// フィールド設定の存否チェック
					$empty_input_setup_file[] = $fullpath;

				}

			}

			// 入力チェック設定の存否チェック結果、入力チェック設定が存在しなかった場合
			if ( count( $empty_input_setup_file ) == 0 ) {
				$ini["fwerr"][][4] = "FrameWork :: 入力チェック設定ファイルがありませんでした。";
				for ( $i = 0; $i < count( $empty_input_setup_file ); $i++ ) {
					$ini["fwerr"][][5] = "  $empty_input_setup_file[$i]";
				}
			}

		}


				/*----------------------------------------------------
				    入力チェック設定を解析
				----------------------------------------------------*/
				function parse_input_list ( $fieldConf ) {

					$line = explode ( "\n", $fieldConf );

					for ( $i = 0; $i < count ( $line ); $i++ ) {

						if ( !preg_match ( "#^\t#", $line[$i] ) ) {
							$groupID = trim ( $line[$i] );
							$count[$groupID] = 0;
						}
						elseif ( $groupID != "" ) {
							$arAccept = explode( ",", trim ( $line[$i] ) );
							$arAccept = preg_replace ( "#^\s+|\s+$#", "", $arAccept );

							// 各項目データ
							$accept = ( $arAccept[0] == "a" ) ? 1 : 0;
							array_shift ( $arAccept );
							$else = join ( "," , $arAccept );
							list ( $field, $group ) = explode ( "=", $else );
							$field  = trim ( $field );
							list ( $group, $parameter ) = explode ( "(", trim ( $group ) );
							$group = trim ( $group );
							$parameter = trim ( preg_replace ( "#\)#", "", $parameter ) );
$parameter2 = (array)explode ( ":", $parameter );
							// 受入れ設定変換 a/NULL => 1/0
							if ( $field != "" && $group != "" ) {
								$ret[$groupID][$field]["accept"]    = $accept;
								$ret[$groupID][$field]["field"]     = $field;
								$ret[$groupID][$field]["group"]     = $group;
								$ret[$groupID][$field]["parameter"] = $parameter2;
							}
						}

					}

					return $ret;

				}




		/*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		    フィールドリスト設定の取り込み
		-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
		function setup_field_list() {

			global $ini, $path;

			/*
			    $this->dirPathListStep["externalFile"] = ARRAY 読み込み対象ディレクトリリスト
			*/
			// 読み込み対象ファイルリストの取得
			for ( $i = 0; $i < count( $this->dirPathListStep["externalFile"] ); $i++ ) {

				// フィールド設定ファイル名は固定なので、パスはすぐに決定できる
				$fullpath = $this->dirPathListStep["externalFile"][$i] . "/" . $path["fieldList"]["fileName"];

				// 対象ファイルが存在すれば・・・
				if ( is_readable ( $fullpath ) ) {

					// 対象ファイルを設定ファイルとして読み込む
					$fieldConf   = read_conf_file ( $fullpath );

					// 読み込んだ情報をフィールド設定として解析する
					$ini["field"] = array_mix ( $ini["field"], $this->parse_field_list ( $fieldConf ) );

					// フィールド設定の存否チェック
					$empty_field_setup_file[] = $fullpath;

				}

			}

			// フィールド設定の存否チェック結果、フィールド設定が存在しなかった場合
			if ( count( $empty_field_setup_file ) == 0 ) {
				$ini["fwerr"][][4] = "FrameWork :: フィールド設定ファイルがありませんでした。";
				for ( $i = 0; $i < count( $empty_field_setup_file ); $i++ ) {
					$ini["fwerr"][][5] = "  $empty_field_setup_file[$i]";
				}
			}

			// プライオリティ順に並び替える
			if ( is_array ( $ini["field"] ) ) {
				foreach ( $ini["field"] as $key => $value ) {
					for ( $i = 0; $i < count ( $ini["checkList"] ); $i ++ ) {
						if ( is_array ( $ini["field"][$key][$ini["checkList"][$i]] ) ) {
							usort( $ini["field"][$key][$ini["checkList"][$i]], array ( $this, "priority_sort" ) );
						}
					}
				}
			}

		}


				/*----------------------------------------------------
				    プライオリティ順に並び替え
				----------------------------------------------------*/
				function priority_sort( $a, $b ) {

					return ( $a["priority"] > $b["priority"] ) ? 1 : -1;

				}


				/*----------------------------------------------------
				    フィールド設定を解析
				----------------------------------------------------*/
				function parse_field_list ( $fieldConf ) {

					$line = explode ( "\n", $fieldConf );

					for ( $i = 0; $i < count ( $line ); $i++ ) {

						$elem = explode( ",", $line[$i] );

						if ( !preg_match ( "#^\t#", $elem[0] ) ) {
							$field_id = $elem[0];
						}
						else {
							$telem = preg_replace ( "#^\s+|\s+$#", "", $elem );
							list( $process_s, $args )  = explode( '(', preg_replace( '/\)$/', '', $telem[2] ) );
							$pros_arg  = (array)explode( ':', $args );
//							array_unshift( $pros_arg, $func );
//							$process_s = array_shift ( $pros_arg );
							list ( $process, $process_array ) = (array)explode ( "-", $process_s );
							if ( count ( $pros_arg ) == 0 ) {
								unset ( $pros_arg );
							}

							$ret["$field_id"][$telem[0]][] = array ( "priority"       => $telem[1],
							                                         "process"        => $process,
							                                         "process_array"  => $process_array,
							                                         "argument"       => $pros_arg,
							                                         "message"        => $telem[3]  );

						}

					}

					return $ret;

				}




		/*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		    ACTION-INPUTリスト設定の取り込み
		-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
		function setup_actionInput_list() {

			global $ini, $path;

			/*
			    $this->dirPathListStep["externalFile"] = ARRAY 読み込み対象ディレクトリリスト
			*/
			// 読み込み対象ファイルリストの取得
			for ( $i = 0; $i < count( $this->dirPathListStep["externalFile"] ); $i++ ) {

				// ファイルパス設定
				$fullpath = $this->dirPathListStep["externalFile"][$i] . "/" . $path["actionInputList"]["fileName"];

				// 対象ファイルが存在すれば・・・
				if ( is_readable ( $fullpath ) ) {

					// 対象ファイルを設定ファイルとして読み込む
					$fieldConf   = read_conf_file ( $fullpath );

					// 読み込んだ情報を入力チェック設定として解析する
					$ini["actionInputList"] = array_mix ( $ini["actionInputList"], $this->parse_actionInput_list ( $fieldConf ) );

					// フィールド設定の存否チェック
					$empty_input_setup_file[] = $fullpath;

				}

			}

			// 入力チェック設定の存否チェック結果、入力チェック設定が存在しなかった場合
			if ( count( $empty_input_setup_file ) == 0 ) {
				$ini["fwerr"][][4] = "FrameWork :: 入力チェック設定ファイルがありませんでした。";
				for ( $i = 0; $i < count( $empty_input_setup_file ); $i++ ) {
					$ini["fwerr"][][5] = "  $empty_input_setup_file[$i]";
				}
			}

		}


				/*----------------------------------------------------
				    ACTION-INPUT設定を解析
				----------------------------------------------------*/
				function parse_actionInput_list ( $fieldConf ) {

					$line = explode ( "\n", $fieldConf );

					for ( $i = 0; $i < count ( $line ); $i++ ) {

						$elem = explode( ",", trim ( $line[$i] ) );
						$inputGroups = preg_split ( "#\s+#", trim($elem[1]) );
						$ret[$elem[0]] = $inputGroups;

					}


					return $ret;

				}












		/*============================================================================
		    ■ 汎用クラスの生成
		============================================================================*/
		function setup_newCalss () {

			global $ini, $path, $class, $theClass, $newAppClass;

			//  汎用クラスの生成
			$ini["appClass"] = array_merge( (array)$ini["appClass"], $newAppClass );
			$this->create_newClass( $ini["appClass"] );

			//  汎用クラスの共有
			for ( $i=0; $i<count($newAppClass); $i++ ) {
				$theClass[$i] = $class[$newAppClass[$i]];
			}

		}


		/*============================================================================
		    ■ 汎用クラスの生成
		============================================================================*/
		function create_newClass ( $appClass=NULL ) {

			global $ini, $path, $class;

			if ( $appClass == NULL ) { return; }

			if ( !is_array ( $ini["classHasRead"] ) ) {
				$ini["classHasRead"] = array();
			}


			if ( is_dir ( $path["classRoot"]["dirAP"] ) ) {
				for ( $i = 0; $i < count ( $appClass ); $i++ ) {
					unset ( $ar_needClass );
					$arr_appClass = explode ( "_", $appClass[$i] );
					for ( $j = 0; $j < count ( $arr_appClass ); $j++ ) {
						$ar_needClass[] = $arr_appClass[$j];
						if ( $j < 1 ) { continue; }
						$needClass[$j] = join ( "_", $ar_needClass );
						$classPath = pathGlue ( "{$path["classRoot"]["dirAP"]}/{$needClass[$j]}.cls" );
						$flag = 1;
						if ( is_file ( $classPath ) && is_readable ( $classPath ) && !in_array ( $needClass[$j], $ini["classHasRead"] ) ) {
							include_once ( $classPath );
							$class[$needClass[$j]] = new $needClass[$j]();
							$ini["classHasRead"][] = $needClass[$j];
							$flag = 59;
						}
						if ( $flag != 59 ) {
// error
						}
					}
				}
			}

		}


		/*============================================================================
		    ■ ステータス設定
		============================================================================*/
		function set_status () {

			global $ini, $justInput;

			if ( $justInput["st"] != "" && @array_key_exists ( $justInput["st"], $ini["action"] ) ) {
				$status = $ini["action"][$justInput["st"]];
			}
			elseif ( $justInput["status"] != "" && @array_key_exists ( $justInput["status"], $ini["action"] ) ) {
				$status = $ini["action"][$justInput["status"]];
			}
			elseif ( $justInput["status"] != "" && @in_array ( $justInput["status"], $ini["action"] ) ) {
				$status = $justInput["status"];
			}
			elseif ( $justInput["st"] != "" && @in_array ( $justInput["st"], $ini["action"] ) ) {
				$status = $justInput["st"];
			}
			else {
				$status = $ini["action"][$ini["actionIX"]];
			}

			if ( $status == "" ) {
				$ini["fwerr"][][4] = "FrameWork :: ステータス設定が出来ていません。";
			}


			return $status;

		}


		/*============================================================================
		    ■ ショートステータス設定
		============================================================================*/
		function set_shortStatus ( $status ) {

			global $ini;

			if ( isset ( $status ) && count( $ini["action"] ) > 0 ) {

				$shortStatus = array_search ( $status, $ini["action"] );

				return $shortStatus;

			}



		}




		/*============================================================================
		    ■ ログを書き出す（バッチ処理用）
		============================================================================*/
		function output_2_log() {

			global $path;

			$date      = date ( "Ymd" );
			$log_path  = pathGlue ( "{$path["siteRoot"]["dirAP"]}/{$path["logDatRoot"]["dirAP"]}/{$date}.log" );

			$this_file = $_SERVER["PWD"] . preg_replace ( "/^\./", "", $_SERVER["SCRIPT_NAME"] );
			$time      = date ( "H:i:s" );


			$wr_log   .= "== $time ====================================================================\n";
			$wr_log   .= "$this_file\n";

			for ( $i = 0; $i < count ( $ini["fwerr"] ); $i++ ) {
				for ( $j = 1; $j <= $ini["level"]["debug"]; $j++ ) {
					if ( isset ( $ini["fwerr"][$i][$j] ) ) {
						$wr_log   .= "  {$ini["fwerr"][$i][$j]}($j)\n";
					}
				}
			}

			$wr_log   .= "\n";


			if ( !file_exists ( $log_path ) ) {
				touch ( $log_path );
			}


			if ( is_writable ( $log_path ) ) {

				if ( !$handle = fopen ( $log_path, 'a' ) ) {
					echo "ログファイルを開けません ($log_path)";
					fw_exit();
				}

				if ( fwrite ( $handle, $wr_log ) === FALSE ) {
					echo "ログファイルに書き込めません ($log_path)";
					fw_exit();
				}

				fclose($handle);

			}
			else {
				echo "ログファイルは書き込み禁止となっています。";
			}

		}


		/*============================================================================
		    ■ ファイルアップロード（配列）の入れ替え
		============================================================================*/
		function arrayFileExchange ( $input, $inName="", $orgField="", $defaultFlag="" ) {

			// 空の名称はセットしない
			if ( $inName != "" || $inName =="0" ) {
				if( $defaultFlag != "1" ){
					$this->arrayFXt["names"][$this->arrayFXt["nest"]] = $inName;
				}
			}

			// 以下の項目が全てある場合は、$_FILES固有フィールド列とみなす
			if ( isset( $input["name"] )
				&& isset( $input["type"] )
				&& isset( $input["tmp_name"] )
				&& isset( $input["error"] )
				&& isset( $input["size"] ) )   {
				$defaultFlag = "1";
			}
			else{
				$defaultFlag = "";
			}

			// 配列だったら、再帰処理
			if ( is_array( $input ) ){
				foreach ( $input as $k => $v ){

					$this->arrayFXt["nest"]++;
					if( $defaultFlag == 1 ) {
						$orgField = $k;
					}
					$this->arrayFileExchange( $v, $k, $orgField, $defaultFlag );
					unset( $this->arrayFXt["names"][$this->arrayFXt["nest"]] );
					$this->arrayFXt["nest"]--;

				}
			}
			// 配列でなかったら、値を、組替後の変数（配列）に格納する
			else{
				$arrayName = "[\"" . implode( "\"][\"", $this->arrayFXt["names"] ) . "\"][\"{$orgField}\"]";
				$php = "\$this->arrayFX" . $arrayName . " = \"{$input}\";";
				eval( $php );
				if ( $orgField == "tmp_name" ) {
					global $path;
					$input_s = preg_replace ( "#.*/#", $path["temporaryUpload"]["dirAP"]."/", $input );
				}
				else {
					$input_s = $input;
				}
				$php = "\$this->arrayFXS" . $arrayName . " = \"{$input_s}\";";
				eval( $php );
			}

		}






		/*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		    定型外部ファイルの階層的取り込み
		-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
		function include_fixed_outerfile ( $fixedForm = "" ) {

			if ( $fixedForm != "" ) {

				global $path;

				// 読み込み対象ファイルリストの取得
				for ( $i = 0; $i < count( $this->filePathList["externalFile"] ); $i++ ) {

					// 先頭に数字のあるファイルのみを選別
					$fileName_fnc = $path["{$fixedForm}Fnc"]["fileName"];
					$fileName_ini = $path["{$fixedForm}Ini"]["fileName"];

					if ( basename( $this->filePathList["externalFile"][$i] ) == $fileName_fnc || basename( $this->filePathList["externalFile"][$i] ) == $fileName_ini ) {
						$this->include_outerfile ( $this->filePathList["externalFile"][$i], "must" );
					}

				}

			}

		}

























	}




























?>