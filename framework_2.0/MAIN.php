<?php


	/*----------------------------------------------------
	    初期ファイルの検索 （ロジック・テンプレート検索）
	----------------------------------------------------*/
	baseSystem_find_theFile();


	/*----------------------------------------------------
	    フレームワークの読み込みとクラスの生成
	----------------------------------------------------*/
	baseSystem_create_frameworkClass();


	/*----------------------------------------------------
	    ログクラスの生成
	----------------------------------------------------*/
	$class["log"] = new log_class( __file__  );


	/*----------------------------------------------------
	    パスをログに保存
	----------------------------------------------------*/
	$logPath = serialize ( $path );
	$class["log"]->systemLog ( "system", "path", $logPath );


	/*----------------------------------------------------
	    入力設定
	----------------------------------------------------*/
	$justInput = $class["framework"]->get_justInput();
	$justInputKeep = $justInput;


	/*----------------------------------------------------
	    初期ステータス設定
	----------------------------------------------------*/
	$status = $class["framework"]->set_status();
	$viewStatus = $status;


	/*----------------------------------------------------
	    DB接続
	----------------------------------------------------*/
	if ( $ini["db"]["use"] == "yes" ) {
		connect_db();
	}


	/*----------------------------------------------------
	    テンプレートクラスの生成
	----------------------------------------------------*/
	$class["template"] = new template_class();


	/*----------------------------------------------------
	    セッションクラスの生成
	----------------------------------------------------*/
	if ( $ini["script"]["type"] != "bat" && $ini["session"]["mode"] != "none" && $ini["session"]["mode"] != "" ) {

		/**
		 * 2014-06-05
		 * メールアドレスでログイン
		 * memberAdmin_1.cls より
		 */
		if ( $ini["session"]["loginWithEmail"] == "yes") {
			// SQLインジェクション対応
			$sql_escape["email"] = sql_escapeString($justInput["ngdFW034"]["loginID"]);

			// メンバー情報の取得
			$sql = "SELECT sessionMember.* FROM memberInfo, sessionMember WHERE sessionMember.memberID = memberInfo.memberID AND email = '{$sql_escape["email"]}'";
			$db = sql_query($sql, "single");
			if ($db["loginID"]) {
				$justInput["ngdFW034"]["loginID"] = $db["loginID"];
			}
		}

		$class["encryption"] = new encryption_class();
		$class["session"] = new session_class();
		if ( $ini["flg_logout"] == 1 ) {
			unset ( $class["session"] );
			$class["session"] = new session_class();
		}
	}




	/*----------------------------------------------------
	    実行チェック
	----------------------------------------------------*/
	if ( $ini["flag_execute"] != "none" ) {

		if ( check_secureMode() ) {


			/*----------------------------------------------------
			    入力チェッククラスの生成
			----------------------------------------------------*/
			$class["inputCheck"] = new inputCheck_class();


			/*----------------------------------------------------
			    ブレッドクラムクラスの生成
			----------------------------------------------------*/
//			$class["breadcrumbs"] = new breadcrumbs_class();

			/*----------------------------------------------------
			    汎用クラスの生成
			----------------------------------------------------*/
			$class["framework"]->create_newClass();


			/*----------------------------------------------------
			    中間外部ファイルの読み込み
			----------------------------------------------------*/
			$class["framework"]->include_numbered_outerfile ( 1000, 2000 );


			/*----------------------------------------------------
			    ロジック
			----------------------------------------------------*/

			if ( $ini["logicAction"] == "action" || $ini["logicAction"] == "logic" ) {

				// ロジッククラスの生成
				$class["logic"] = new logicClass();

				switch ( $ini["logicAction"] ) {

					case "action":
						// ロジックの実行
						$status = $class["logic"]->callCTRL();
						break;

					case "logic":
						// ロジックの実行
						$class["logic"]->callLogic();

				}

				if ( $viewStatus != "" ) {
					$path["template"]["fileAP"] = set_templateFileAP( $viewStatus );
					$path["template"]["fileRP"] = preg_replace ( "#^{$path["templateRoot"]["dirAP"]}#", "", $path["template"]["fileAP"] );
				}

				if( $ini["view"] != "xml" ) {
					$ini["view"] = "template";
				}

			}


			/*----------------------------------------------------
			    出力調整
			----------------------------------------------------*/
			// 入力値統合
			$output["INPUT"] = $justInputKeep;

			/*----------------------------------------------------
			    ステータス込パスの生成
			----------------------------------------------------*/
			$shortStatus = $class["framework"]->set_shortStatus( $viewStatus );

			if ( $ini["statusType"] == "get" ) {
				$vs = $viewStatus != "" ? "/?st=$viewStatus" : "";
				$path["unit"]["actionRP"]  = pathGlue ( $path["unit"]["dirRP"] . $vs );
				$ss = $shortStatus != "" ? "/?st=$shortStatus" : "";
				$path["unit"]["actionRPs"] = pathGlue ( $path["unit"]["dirRP"] . $ss );
			}
			else {
				$vs = $viewStatus != "" ? "/$viewStatus" : "";
				$path["unit"]["actionRP"]  = pathGlue ( $path["unit"]["dirRP"] . $vs );
				$ss = $shortStatus != "" ? "/$shortStatus" : "";
				$path["unit"]["actionRPs"] = pathGlue ( $path["unit"]["dirRP"] . $ss );
			}

			if ( $ini["script"]["type"] != "bat" ) {


				/*----------------------------------------------------
				    ブレッドクラム生成
				----------------------------------------------------*/
//				$class["breadcrumbs"]->create_breadcrumbList_class();

				/*----------------------------------------------------
				    SEOの生成
				----------------------------------------------------*/
				$class["seo"] = new seo_class();

			}


			/*----------------------------------------------------
			    DEFINEの生成
			----------------------------------------------------*/
			$class["framework"]->include_fixed_outerfile( "define" );

		}


		/*----------------------------------------------------
		    セキュアモード不整合
		----------------------------------------------------*/
		else {


			$ini["view"] = "404";



		}

	}

	// ログインフォームへのエラーメッセージセット
	if ( isset( $class["session"]->st["sessionLive"] ) ){
		$output["session"]["errmsg"] = $ini["session"]["errmsg"]["{$class["session"]->st["sessionLive"]}"];
	}


	/*----------------------------------------------------
	    最終外部ファイルの読み込み
	----------------------------------------------------*/
	$class["framework"]->include_numbered_outerfile ( 2000, 3000 );

	/*----------------------------------------------------
		出力
	----------------------------------------------------*/

	switch ( $ini["view"] ) {

		case "txt":
			header('Content-Type: text/plain; charset='.$ini["jp_encoding"], true);
			break;

		case "css":
			header('Content-Type: text/css; charset='.$ini["jp_encoding"], true);
			break;

		case "xml":
			header('Content-Type: text/xml; charset='.$ini["jp_encoding"],true);
			break;

		case "json":
			header('Content-Type: application/json; charset=UTF-8',true);
			break;

		case "pdf":
			header('Content-Type: application/pdf;',true);
			break;

		case "jpeg":
			header('Content-Type: image/jpeg',true);
			break;

		case "gif":
			header('Content-Type: image/gif',true);
			break;

		case "png":
			header('Content-Type: image/png',true);
			break;

		case "wmv":
			header('Content-Type: video/x-ms-wmv',true);
			break;

		case "png":
			header('Content-Type: audio/mp3',true);
			break;

		case "exe":
			header('Content-Type: application/octet-stream',true);
			break;

		case "sessionFault":
			header('Content-Type: text/html; charset='.$ini["jp_encoding"], true);
			$path["template"]["fileAP"] = $path["loginRoot"]["template"]["fileAP"];
			break;

		case 404:
			header('HTTP/1.1 404 Not Found', true);
			header('Content-Type: text/html; charset='.$ini["jp_encoding"], true);
			$output["script"]["fileRP"] = $path["script"]["fileRP"];
			$path["template"]["fileAP"] = 404;
			break;

		default:
			header('Content-Type: text/html; charset='.$ini["jp_encoding"], true);
			break;

	}

	// 表示
	$op = $class["template"]->attach_template( $path["template"]["fileAP"], $output );
	if ( $op != "" ) { echo $op; }













	/* x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-

	    各種ファンクション

	x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x- */


	/*----------------------------------------------------
	    WEB /SSL ?
	----------------------------------------------------*/
	function check_secureMode () {

		global $ini, $path;

		if ( $path["ssl"] == "on" && $ini["secureMode"] == "on" ) {
			return true;
		}
		elseif ( $path["ssl"] == "" && $ini["secureMode"] == "off" ) {
			return true;
		}
		elseif ( $ini["secureMode"] == "none" || $ini["secureMode"] == "" ) {
			return true;
		}

		return false;

	}




	/*----------------------------------------------------
	    初期ファイルの検索
	----------------------------------------------------*/
	function baseSystem_find_theFile () {

		global $ini, $path, $pathInput, $pathInfo, $class;

		// SSL
		$path["ssl"] = $_SERVER["HTTPS"];
		$path["protocol"] = $_SERVER["HTTPS"] == "" ? "http" : "https";

		// フロントコントローラ用 PATH_INFO
		if ( $ini["script"]["type"] == "bat" ) {
			/**
			 * バッチファイル
			 */
			$serverURI   = $path["script"]["fileRP"];
		} else {
			/**
			 * ウェブ経由
			 */
//			$serverURI   = mb_convert_encoding( $_SERVER["REQUEST_URI"], $ini["jp_encoding"], auto );
			$serverURI = mb_convert_encoding($_SERVER['PATH_INFO'], $ini['jp_encoding'], auto);
		}
		$serverLastD = preg_match ( "#/$#", $serverURI ) ? "" : "/";
		$serverURI_d = $serverURI . $serverLastD;

		// ローカルディレクトリ
		$unitDirRP = preg_replace ( "#/[^/]*$#", "", $serverURI_d );
		$path["unit"]["dirRP"] = preg_replace ( "#/\?.*#", "", $unitDirRP );

		// テンプレートトライリスト
		$tryTMPlist = array ( "index.html", "index.htm", "index.tmp", ".html", ".htm", ".tmp" );


		// ■■■ ディレクトリ検索
		for ( $i=0; $i<100; $i++ ) {

			// ベースパス
			$path["unit"]["dirAP"] = pathGlue ( "{$path["logicRoot"]["dirAP"]}/{$path["unit"]["dirRP"]}" );

				// ベースパスが全周回と同じパスだったら終わり
				if ( ( $path["unit"]["dirRP"] != "" || $lastFlag > 1 ) && $path["unit"]["dirRP"] == $pre_unitDirRP ) {
					$breakFlag = 404;
					break;
				}
				if ( $path["unit"]["dirRP"] == "" ) { $lastFlag++; }
				$pre_unitDirRP = $path["unit"]["dirRP"];



			// ■ アクションリストを探す

				// アクションファイルがある（想定）パス
				$actionFilePath = pathGlue ( "{$path["unit"]["dirAP"]}/{$path["actionList"]["fileName"]}" );

				// アクションファイルがあった
				if ( is_file ( $actionFilePath ) || $path["unit"]["dirRP"] == "" ) {

					// アクションリストからのパス設定
					if ( config_pathByActionlist( $actionFilePath ) ) {
						$breakFlag  = 59;
					}

				}


				// テンプレート直呼びの場合、下位ディレクトリを認めない
				$pathSave[$i] = $path;
				if ( $i > 0 || $breakFlag == 59 ) {

					if ( $i > 0 && $breakFlag != 59 ) {
						$path = $pathSave[$i-1];
					}


				// ■ 単体ロジックファイルを探す

					// LOGICファイルパス（想定）
					unset( $path["logic"] );
					$logicFilePath_1 = pathGlue ( "{$path["unit"]["dirAP"]}.lgc" );
					$logicFilePath_2 = pathGlue ( "{$path["unit"]["dirAP"]}/index.lgc" );

						// xxx.lgc の形
						if ( is_file ( $logicFilePath_1 ) && $path["unit"]["dirRP"] != "" ) {
							$path["logic"]["fileAP"] = $logicFilePath_1;
						}

						// xxx/index.lgc の形
						elseif ( is_file ( $logicFilePath_2 ) ) {
							$path["logic"]["fileAP"] = $logicFilePath_2;
						}

					// 単体ロジックファイルがあった
					if ( isset( $path["logic"]["fileAP"] ) ) {

						// 単体ロジックファイルからのパス設定
						config_pathByLogicfile( $path["logic"]["fileAP"] );
						$breakFlag = 59;

					}



				// ■ テンプレートを探す

					// 拡張子を求める
					preg_match ( "#([^/]*)\.([^\./]*)$#", $path["unit"]["dirRP"], $extMatch );
					$ext = $extMatch[2];
					$ext = $ext == "jpg" ? "jpeg" : $ext;

					// 直ファイル名で検索
					$tryfileAP  = pathGlue ( $path["templateRoot"]["dirAP"] . "/" . $path["unit"]["dirRP"] );

					if ( is_file( $tryfileAP ) ) {
						$tmpfileAP  = $tryfileAP;
						$view       = $ext;
					}
					else {

						// index.html, index.htm, index.tmp, .html, .htm, .tmp の展開
						$templateDirAP = pathGlue ( "{$path["templateRoot"]["dirAP"]}/{$path["unit"]["dirRP"]}" );
						for ( $j = 0; $j < count ( $tryTMPlist ); $j++ ) {
							$tryTMPfile   = preg_match ( "#^\.#", $tryTMPlist[$j] ) ? $tryTMPlist[$j] : "/" . $tryTMPlist[$j];
							$tryTMPfileAP = pathGlue ( "{$path["templateRoot"]["dirAP"]}/{$path["unit"]["dirRP"]}$tryTMPfile" );
							if ( is_file( $tryTMPfileAP ) ) {
								$tmpfileAP  = $tryTMPfileAP;
								$view       = "template";
							}
						}

					}


					// テンプレートファイルがある
					if ( $tmpfileAP != "" ) {
						config_pathByTemplatefile ( $tmpfileAP );
						$breakFlag = 59;
					}
					elseif ( $breakFlag == 59 ) {
						config_pathByTemplatefile ( "", $templateDirAP );
						$breakFlag = 59;
					}

			}

			// ロジックがある
			if ( $breakFlag == 59 ) { break; }

			// パスを戻す
			$path = $pathSave[$i];

			// あと処理（ディレクトリ名の保存）
			preg_match ( "#(/)([^/]*)$#", $path["unit"]["dirRP"], $match );
			if ( !preg_match ( "#^\?#", $match[2] ) ) {
				$pathData   = preg_replace ( "#/$#", "", $match[2] );
				$pathInfo[] = $pathData;
			}

			// 一階層減らす
			$path["unit"]["dirRP"] = preg_replace ( "#/[^/]*$#", "", $path["unit"]["dirRP"] );

		}


		if ( $breakFlag == 404 ) {
			$view = 404;
		}
		else {
			$path["referer"]["url"] = $_SERVER["HTTP_REFERER"];
		}


		$ini["view"] = $view;

	}


			/*----------------------------------------------------
			    アクションリストからのパス設定
			----------------------------------------------------*/
			function config_pathByActionlist ( $actionFilePath ) {

				global $ini, $path, $pathInput, $pathInfo, $status;

				$lastPathInfo       = $pathInfo;
				$lastRP             = @array_pop ( $lastPathInfo );
				$actionFilePathRP   = preg_replace ( "#^{$path["logicRoot"]["dirAP"]}#",    "", $actionFilePath );

				//  アクションリストの取り込み
				$actionList   = setup_action_list( $actionFilePath );
				$actionListIX = $actionList["ix"];
				$ini["actionFlag"]["ix"] = 1;

				// アクション有
				if ( @in_array ( $lastRP, $actionList ) || @array_key_exists ( $lastRP, $actionList ) || $actionList["ix"] != "" ) {

					$path["actionList"]["fileAP"] = $actionFilePath;
					$path["actionList"]["fileRP"] = $actionFilePathRP;
					$ini["action"]                = $actionList;
					$ini["actionIX"]              = $actionListIX;
					$ini["actionIXname"]          = $actionList[$actionListIX];
					$path["logic"]["dirRP"]       = preg_replace ( "#{$path["actionList"]["fileName"]}#", "", $actionFilePathRP );
					$path["logic"]["dirAP"]       = pathGlue ( "{$path["logicRoot"]["dirAP"]}/{$path["logic"]["dirRP"]}" );

					$pathInput                    = @array_reverse( $pathInfo );

					$ini["logicAction"] = "action";

					return true;

				}

				return false;

			}


			/*----------------------------------------------------
			    単体ロジックファイルからのパス設定
			----------------------------------------------------*/
			function config_pathByLogicfile ( $logicFilePath ) {

				global $ini, $path;

				$path["logic"]["fileRP"]     = preg_replace ( "#^{$path["logicRoot"]["dirAP"]}#", "", $logicFilePath );
				$path["logic"]["dirAP"]      = preg_replace ( "#/[^/]*$#", "", $logicFilePath );
				$path["logic"]["dirRP"]      = preg_replace ( "#^{$path["logicRoot"]["dirAP"]}#", "", $path["logic"]["dirAP"] );

				$ini["logicAction"] = "logic";

			}


			/*----------------------------------------------------
			    テンプレートファイルからのパス設定
			----------------------------------------------------*/
			function config_pathByTemplatefile ( $templateFilePath=NULL, $templateDirPath=NULL ) {

				global $ini, $path;

				if ( $templateFilePath != NULL ) {
					$path["template"]["fileAP"]   = $templateFilePath;
					$path["template"]["fileRP"]   = preg_replace ( "#^{$path["templateRoot"]["dirAP"]}#", "", $templateFilePath );
					$path["template"]["dirAP"]    = preg_replace ( "#/[^/]*$#", "", $templateFilePath );
					$path["template"]["dirRP"]    = preg_replace ( "#^{$path["templateRoot"]["dirAP"]}#", "", $path["template"]["dirAP"] );
					$ini["view"] = "template";
				}
				elseif ( $templateDirPath != NULL ) {
					$path["template"]["dirAP"]    = $templateDirPath;
					$path["template"]["dirRP"]    = preg_replace ( "#^{$path["templateRoot"]["dirAP"]}#", "", $path["template"]["dirAP"] );
					$ini["view"] = "template";
				}


			}




	/*----------------------------------------------------
	    フレイムワーククラスの読み込み
	----------------------------------------------------*/
	function baseSystem_create_frameworkClass () {

		global $path;

		if ( $path["frameworkClass"]["fileAP"] == "" || !include_once( $path["frameworkClass"]["fileAP"] ) ) {
			echo "フレームワーククラス実行ファイルがありません。 ({$path["frameworkClass"]["fileAP"]})";
			exit();
		}


		global $class;

		$class["framework"] = new framework_class();

		$path["head"]["http"]   = $path["ssl"] == "on" ? "https://" : "http://";
		$path["head"]["domain"] = $path["ssl"] == "" ? $path["http"]["domain"] : $path["https"]["domain"];
//		$path["unit"]["url"] = pathGlue ( $path["head"]["http"] . $path["host"]["name"] . "/" . $path["unit"]["dirRP"] );
		$path['unit']['url'] = pathGlue($path['head']['http'].$path['host']['name'].'/'.$path['alias'].'/'.$path['unit']['dirRP']);

	}



		/*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		    (3) アクションリスト設定の取り込み
		-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
		function setup_action_list( $pathActionList_fileAP ) {

			global $path, $ini;

			if ( is_readable ( $pathActionList_fileAP ) ) {
				$field_conf = read_conf_file ( $pathActionList_fileAP );
				$actionList = parse_action_list ( $field_conf );
			}
			else {
				$ini["fwerr"][][4] = "FrameWork :: アクション設定ファイルがありません。";
				$ini["fwerr"][][5] = "  path: $fullpath";
			}


			return $actionList;

		}


				/*----------------------------------------------------
				    アクション設定を解析
				----------------------------------------------------*/
				function parse_action_list ( $action_conf ) {

					$line = explode ( "\n", $action_conf );

					for ( $i = 0; $i < count ( $line ); $i++ ) {

						$elem = explode( ",", trim ( $line[$i] ) );
						$ret[$elem[0]] = trim($elem[1]);

					}


					return $ret;

				}




		/*----------------------------------------------------
		    アクション設定を解析
		----------------------------------------------------*/
		function set_templateFileAP ( $viewStatus ) {

			global $path;
			$ret = $path["templateRoot"]["dirAP"] . "/" . preg_replace ( "#{$path["actionList"]["fileName"]}$#", "", $path["actionList"]["fileRP"] ) . "/" . $viewStatus . ".tmp";
			$ret = pathGlue ( $ret );

			return $ret;

		}


?>
