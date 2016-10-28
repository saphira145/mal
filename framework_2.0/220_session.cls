<?php


	/*---------------------------------------------------------------------------------------

	  セッション管理クラス


	---------------------------------------------------------------------------------------*/

	class session_class {



		/****************************************************************

		        セッション  コンストラクタ

		****************************************************************/
		function session_class() {

			global $ini, $path, $justInput, $class;

			// ベースパス設定
			$this->set_basePath();

			// セッションKey/IDの取得
			$this->get_sessionInfo();


			// ログアウト
			if( $ini["flg_logout"] != 1 && ( preg_match ( "#^logout#", $_SERVER["QUERY_STRING"] ) || preg_match ( "#^logout#", $_POST["stb034logout"] ) || preg_match ( "#logout$#", $path["script"]["fileRP"] ) ) ) {
				$this->logoutFlag = 1;
				$this->logout();

				unset ( $_COOKIE["bason"]["session"][$this->zone] );
				unset ( $_COOKIE );
				$ini["flg_logout"] = 1;

                // Check special Ip
                if ( function_exists('checkIpAddress') && checkIpAddress() ) {
                    // Remove employee_number cookie & salePromotion cookie
                    setcookie('employee_number', '', time() - 3600, "/", $path["host"]["name"] );
                    setcookie( "salesPromotion", '', time() - 3600, "/", $path["host"]["name"] );

                    // Redirect to Login page
                    header("Location: {$path['loginRoot']['url']}?st=ef");
                    exit;
                }
                return;

			}

            // Check special Ip
            if ( function_exists('checkIpAddress') && checkIpAddress() ) {
                return;
            }

			// モード・ゾーンが設定されていない
			if ( !( $this->is_loginPage() ) && ( $ini["session"]["mode"] == "" || $ini["session"]["mode"] == "none" || $ini["session"]["zone"] == "" ) ) {
				return;
			}
			else {
				$loginModeList = array ( "login", "loginAuto", "monitor", "monitorAuto", "loginDenyAuto", "loginStrict", "none" );
				if ( !in_array( $ini["session"]["mode"], $loginModeList ) ) {
					return;
				}
			}



			// 異常ナシをベースにする
			$this->st["sessionLive"] = 10;

				// loginStrict モード
				if ( $ini["session"]["mode"] == "loginStrict" ) {
					if ( !$this->check_loginStrict() ) {
						$this->st["sessionLive"] = 7;
					}
				}

				// ライブIDがDBに存在してない（ログインしていない）
				elseif ( $this->tbl["sessionLive"]["memberID"] == "" ) {
					$this->st["sessionLive"] = 2;
				}

				// ライブIDがタイムアウトしている
				elseif ( $this->is_sessionLive_timeout() ) {
					$this->st["sessionLive"] = 5;
				}

				// loginDenyAuto であり、且つ現在Autoでログイン中
				elseif ( preg_match ( "#DenyAuto#i", $ini["session"]["mode"] ) && $this->tbl["sessionLive"]["auto"] == "auto" ) {
					$this->st["sessionLive"] = 9;
				}

				// レベルが足りない
				elseif ( $this->level > 0 && $this->level < $ini["session"]["level"] ) {
					$this->st["sessionLive"] = 4;
				}


			// 非ログイン状態である
			if ( $this->st["sessionLive"] != 10 ) {

				// 自動ログインモード
				if ( $this->autoLogin == 1 && preg_match ( "#auto#i", $ini["session"]["mode"] ) && !( preg_match ( "#DenyAuto#i", $ini["session"]["mode"] ) ) ) {

					// レベルチェックチェックをクリアした場合
					if ( $this->level > $ini["session"]["level"] ) {
						$this->exec_login( "auto" );
					}
					else {
						$this->st["sessionLive"] = 4;
					}

				}

				// 非自動ログインモード
				else {

					// モニター系モード
					if ( preg_match ( "#monitor#i", $ini["session"]["mode"] ) ) {

						// モニターメンバー情報の取得
						$this->get_monitorMemberInfo();

						// メンバーIDがない
						if ( !( $this->memberID > 0 ) ) {

							// 仮メンバー登録 & マスター登録
							$this->add_loginAsTemporaryMember();
							return;

						}

					}

					// 非モニター系モード（ログインページ以外）
					elseif ( $this->flg_loginPage == "" ) {

						// ■ ログインページにリダイレクション ■
						$this->loginFault_redirection();
						return;

					}

				}

			}

			// ログイン状態である
			else {

				$this->st["sessionLive"] = 10;

				// sessionDBアップデート
				$this->update_sessionDB( "live" );
				$this->update_sessionDB( "master" );


				// ログイン直後
				if ( $this->is_sessionData() ) {

					// データを読み戻す
					list( $originalURL, $sessionData ) = $this->get_originalSessionData();
					$justInput = array_mix ( $justInput, $sessionData );

					// セッションデータを消す
					$this->delete_dbSessionData();

				}


			}



		}







		function set_basePath () {

			global $path, $ini;

			list ( $https, $dirName ) = explode ( ",", $ini["session"]["loginRootUrl"] );

			$path["loginRoot"]["https"]   = trim ( $https );
			$path["loginRoot"]["dirName"] = trim ( $dirName );

			// ログイン関係
			$httpsHead = ( $path["loginRoot"]["https"] == "https" ) ? $path["https"]["domain"] : $path["http"]["domain"];
			$path['loginRoot']['dirName'] = $path['loginRoot']['dirName'];
			$path["loginRoot"]["dirRP"] = $path["loginRoot"]["dirName"];
			/**
			 * 2013-12-09  井上 義勝 <y-inoue@hoyusys.co.jp>
			 * Apache などの Alias 設定に対応
			 */
			if ($path['alias']) {
				$path['loginRoot']['url'] = pathGlue($httpsHead.'/'.$path['alias'].'/'.$path['loginRoot']['dirName']);
			} else {
				$path['loginRoot']['url'] = pathGlue($httpsHead.'/'.$path['loginRoot']['dirName']);
			}
			$path["loginRoot"]["logic"]["dirAP"]     = pathGlue ( "{$path["logicRoot"]["dirAP"]}/{$path["loginRoot"]["dirName"]}" );
			$path["loginRoot"]["template"]["dirRP"]  = $path["loginRoot"]["dirName"];
			$path["loginRoot"]["template"]["dirAP"]  = pathGlue ( "{$path["templateRoot"]["dirAP"]}/{$path["loginRoot"]["dirName"]}" );
			$path["loginRoot"]["template"]["fileRP"] = pathGlue ( "{$path["loginRoot"]["template"]["dirRP"]}/{$path["loginFault"]["fileName"]}" );
			$path["loginRoot"]["template"]["fileAP"] = pathGlue ( "{$path["templateRoot"]["dirAP"]}/{$path["loginRoot"]["template"]["fileRP"]}" );
		}


		/*----------------------------------------------------
		    モニターメンバー情報の取得
		----------------------------------------------------*/
		function get_monitorMemberInfo() {

			if ( $this->id["sessionMaster"] != "" && !( $this->memberID > 0 ) ) {

				$this->get_session( "master", "session" );

			}

		}




		/*----------------------------------------------------
		    仮メンバー登録
		----------------------------------------------------*/
		function add_loginAsTemporaryMember() {

			// 仮メンバー登録
			$this->exec_temporaryMember();

			// sessionIDの発行
			$this->issue_sessionID( "master", "session" );

			// sessionDBに追加
			$this->add_sessionDB( "master" );

		}


				/*----------------------------------------------------
				    仮メンバー登録の実行
				----------------------------------------------------*/
				function exec_temporaryMember() {

					global $ini;

					$insert["level"]     = $ini["session"]["temporaryMember"]["level"];
					$sql = "INSERT INTO sessionMember {insert_value}";
					list ( $affectedRow, $memberID ) = sql_query ( $sql, $insert );

					$this->memberID = $memberID > 0 ? $memberID : "";

				}




		/*----------------------------------------------------
		    セッション情報の取得
		----------------------------------------------------*/
		function get_sessionInfo() {

			global $path, $ini;


			/*
			// ログインゾーンの取得
			if ( $_COOKIE["bason"]["session"]["zone"] != "" ) {
				$ini["session"]["zone"] = $_COOKIE["bason"]["session"]["zone"];
			}
			*/
			$this->zone = $ini["session"]["zone"];

			$this->get_session( "master", "session" );
			$this->get_session( "live", "session" );

			if ( $path["ssl"] == "on" ) {

				$this->get_session( "master", "secure" );
				$this->get_session( "live", "secure" );

			}

			if ( $this->memberID > 0 ) {

				$this->get_basicMemberInfo();

			}

			$this->loginUrlHeader = $path["loginRoot"]["https"];

			$this->loginURL = $path["loginRoot"]["url"];
			$this->flg_loginPage = ( $this->loginURL == $path["unit"]["url"] ) ? 1 : 0;
			$this->sessionDataID = $_COOKIE["bason"]["session"][$this->zone]["sessionDataID"];

		}


				/*----------------------------------------------------
				    セッション情報を取り出す
				----------------------------------------------------*/
				function get_session( $masterLive, $sessionSecure ) {

					global $ini;

					$ucMasterLive = ucfirst( $masterLive );
					$ucSessionSecure = ucfirst( $sessionSecure );

					if ( isset( $_COOKIE["bason"]["session"][$this->zone][$ucMasterLive][$ucSessionSecure] ) ) {
						$this->id["$sessionSecure$ucMasterLive"]  = (string)$_COOKIE["bason"]["session"][$this->zone][$ucMasterLive][$ucSessionSecure];
					}

					$this->get_sessionDataDB( $masterLive, $sessionSecure );

				}


						/*----------------------------------------------------------------
						    sessionLive/Masterテーブルの取得
						----------------------------------------------------------------*/
						function get_sessionDataDB( $masterLive, $sessionSecure ) {

							global $path;

							$ucMasterLive = ucfirst( $masterLive );

							// SQLインジェクション対応
							$sql_escape["id"]         = sql_escapeString($this->id["$sessionSecure$ucMasterLive"]);
							$sql_escape["zone"]       = sql_escapeString($this->zone);
							$sql_escape["whereCaram"] = sql_escapeString($sessionSecure . "ID");
							$sql_escape["table"]      = sql_escapeString("session" . $ucMasterLive);

							$sql = "SELECT * FROM {$sql_escape["table"]} WHERE {$sql_escape["whereCaram"]} = '{$sql_escape["id"]}' AND zone = '{$sql_escape["zone"]}'";
							$this->tbl["session$ucMasterLive"] = sql_query ( $sql, "single" );

							if ( $this->tbl["session$ucMasterLive"]["memberID"] > 0 ) {
								$this->memberID = $this->tbl["session$ucMasterLive"]["memberID"];
							}

						}


				/*----------------------------------------------------
				    メンバー基本情報の取得
				----------------------------------------------------*/
				function get_basicMemberInfo() {

					global $ini;

					// SQLインジェクション対応
					$sql_escape["memberID"] = sql_escapeString($this->memberID);

					$sql = "SELECT * FROM sessionMember WHERE memberID = '{$sql_escape["memberID"]}'";
					$this->tbl["sessionMember"] = sql_query ( $sql, "single" );
					$this->level     = $this->tbl["sessionMember"]["level"];
					$this->autoLogin = $this->tbl["sessionMember"]["autoLogin"];

					// アクセス権限の取得
					$sql = "SELECT *, to_days(expirationDatetime) - to_days(now()) as dayDiff FROM salesMember WHERE memberID = '{$sql_escape["memberID"]}' ";
					$this->sales = sql_query( $sql, "single" );

					// 権限レベル判断
					if( $this->sales["authorityLevel"] == $ini["session"]["systemLevel"] ){
						$this->sales["system"] = 1;
					}
				}




		/*----------------------------------------------------
		    ログインページにいるのか？
		----------------------------------------------------*/
		function is_loginPage() {

			global $path, $ini;

			if ( $this->flg_loginPage != "" ) {
				return $this->flg_loginPage == 1 ? true : false;
			}

			return ( $this->loginURL == $path["unit"]["url"] ) ? true : false;

		}




		/*----------------------------------------------------
		    ログインページにリダイレクション
		----------------------------------------------------*/
		function loginFault_redirection() {

			global $path, $ini, $class, $justInput;


			if ( $this->logoutFlag != 1 ) {

				if ( isset( $_FILES ) ) {

					// アップロードしたファイルを移す ループ
					$this->copyUploadedFiles( $_FILES );

				}

				// セッション用の入力値合わせ
				$justInput = $class["framework"]->get_justInput( "session" );

				// セッションデータを消す
				$this->delete_dbSessionData();

				// 入力値（シリアライズ）をDBに入れる
				$insert["serializedData"] = ngdfw_serialize ( $justInput );
				$insert["sessionID"]      = $this->id["sessionLive"];
				$insert["url"]            = $_SERVER['REQUEST_URI'];

				$sql = "INSERT INTO sessionData {insert_value}";
				list ( $affectedRow, $sessionDataID ) = sql_query ( $sql, $insert );

				// セッションデータIDをクッキーに入れる
				$sql_escape["sessionDataID"] = sql_escapeString($sessionDataID);
				setcookie( "bason[session][$this->zone][sessionDataID]", $sql_escape["sessionDataID"], 0, "/", $path["host"]["name"] );

				// ZONE-IDをクッキーに入れる
				if ( $ini["session"]["zone"] != "" ) {
					$sql_escape["sessionZone"] = sql_escapeString($ini["session"]["zone"]);
					setcookie( "bason[session][zone]", $sql_escape["sessionZone"], 0, "/", $path["host"]["name"] );
				}

			}

			// 転送
			$this->pageRedirection( $this->loginURL );

		}




		/*----------------------------------------------------
		    ログインページにリダイレクション
		----------------------------------------------------*/
		function pageRedirection( $url ) {

			global $ini, $output, $path;

			$output["loginURL"] = $url;
			$ini["flag_execute"] = "none";
			$ini["view"] = "sessionFault";

		}





		/*----------------------------------------------------
		    アップロードしたファイルを移す ループ
		----------------------------------------------------*/
		function copyUploadedFiles( $files ) {

			if ( is_array ( $files ) ) {
				foreach ( $files as $key => $val ) {
					if ( $key === "tmp_name" ) {
						$this->copyUPF_tmpName = 1;
						$copyUPF_tmpName = 1;
					}
					if ( is_array ( $val ) ) {
						$this->copyUploadedFiles( $val );
					}
					else {
						if ( $this->copyUPF_tmpName === 1 ) {
							$this->exec_copyUploadFiles( $val );
						}
					}
					if ( $copyUPF_tmpName == 1 ) {
						$this->copyUPF_tmpName = 0;
						$copyUPF_tmpName = 0;
					}
				}
			}

		}



		/*----------------------------------------------------
		    アップロードしたファイルを移す 実行
		----------------------------------------------------*/
		function exec_copyUploadFiles( $tmp_name ) {

			global $path;

			$filename = preg_replace ( "#.*/#", "", $tmp_name );
			$dest = pathGlue ( "{$path["temporaryUpload"]["dirAP"]}/$filename" );

			copy ( $tmp_name, $dest );

		}




		/*----------------------------------------------------
		    入力値DBの存否
		----------------------------------------------------*/
		function is_sessionData(){

			// SQLインジェクション対応
			$sql_escape["sessionDataID"] = sql_escapeString($this->sessionDataID);
			$sql_escape["sessionLive"]   = sql_escapeString($this->id["sessionLive"]);

			// DBのデータがあるのか？
			$sql = "SELECT sessionID FROM sessionData WHERE sessionDataID = '{$sql_escape["sessionDataID"]}' AND sessionID = '{$sql_escape["sessionLive"]}'";
			$sessionDataDB = sql_query ( $sql, "single" );

			return ( $sessionDataDB["sessionID"] == $this->id["sessionLive"] ) ? true : false;

		}




		/*----------------------------------------------------
		    入力値を戻す
		----------------------------------------------------*/
		function get_originalSessionData(){

			global $justInput, $path, $ini;

			if ( $this->sessionDataID != "" ) {

				// SQLインジェクション対応
				$sql_escape["sessionDataID"] = sql_escapeString($this->sessionDataID);

				// DBからデータを取り出す
				$sql = "SELECT * FROM sessionData WHERE sessionDataID = '{$sql_escape["sessionDataID"]}'";
				$sessionDataDB = sql_query ( $sql, "single" );

				// 取り出した入力値をアンシリアライズ
				if ( $sessionDataDB["serializedData"] != "" ) {
					$originalURL = preg_replace ( "#\?logout$#", "", $sessionDataDB["url"] );
					$sessionData = ngdfw_unserialize ( $sessionDataDB["serializedData"] );
				}
				// セッションデータＩＤを消す
				$this->delete_cookieSessionData();

			}

			if ( $originalURL == "" ) {

				list ( $urlHeader, $fileRP ) = explode ( ",", $ini["session"]["defaultLoginUrl"] );
				$this->defaultLoginUrl = $path[$urlHeader]["head"] . pathGlue ( $path["host"]["name"] . "/" . $path['alias'] . $fileRP );
				$originalURL = $this->defaultLoginUrl;

			}


			return array( $originalURL, $sessionData );


		}




		/*----------------------------------------------------
		    DBのセッションデータを消す
		----------------------------------------------------*/
		function delete_dbSessionData(){

			if ( $this->id["sessionLive"] != "" ) {

				// SQLインジェクション対応
				$sql_escape["sessionLive"] = sql_escapeString($this->id["sessionLive"]);
				$sql = "DELETE FROM sessionData WHERE sessionID = '{$sql_escape["sessionLive"]}'";
				sql_query ( $sql );

			}

		}




		/*----------------------------------------------------
		    クッキーのセッションデータを消す
		----------------------------------------------------*/
		function delete_cookieSessionData(){

			global $path;

			setcookie( "bason[session][$this->zone][sessionDataID]", "", time() - 3600, "/", $path["host"]["name"] );

		}




		/*----------------------------------------------------
		    レベルが足りない
		----------------------------------------------------*/
		function check_sessionLive_level() {

			global $ini;

			$timeout  = date( "YmdHis", mktime( date("H"), date("i") - $ini["session"]["timeout"], date("s"), date("m"), date("d"), date("Y") ) );
			$livetime = preg_replace ( "#-| |:#", "", $this->tbl["sessionLive"]["timestamp"] );

			if ( $livetime < $timeout ) { return true; }

			return false;

		}




		/*----------------------------------------------------
		    ライブIDがタイムアウトしている
		----------------------------------------------------*/
		function is_sessionLive_timeout() {

			global $ini;

			$timeout  = date( "YmdHis", mktime( date("H"), date("i") - $ini["session"]["timeout"], date("s"), date("m"), date("d"), date("Y") ) );
			$livetime = preg_replace ( "#-| |:#", "", $this->tbl["sessionLive"]["timestamp"] );

			if ( $livetime < $timeout ) { return true; }

			return false;

		}




		/*----------------------------------------------------
		    check_loginStrict
		----------------------------------------------------*/
		function check_loginStrict() {

			global $ini, $path;

			// ログイン直後である
			if ( $this->is_sessionData() ) {

				// ログインストリクトモードがオン
				$this->loginStrict = 1;

				return true;

			}


			// リファラーがある
			if ( $_SERVER["HTTP_REFERER"] != "" ) {

				// リファラーＵＲＬ
				$refererURL = pathGlue ( preg_replace ( "#{$path["head"]["domain"]}#", "", $_SERVER["HTTP_REFERER"] ) );

				// ログインストリクト領域内にリファラーＵＲＬが存在しているか？
				if ( preg_match ( "#{$ini["session"]["loginStrict"]}#", $refererURL )  ) {
					return true;
				}

			}

			return false;

		}




		/*----------------------------------------------------
		    logout
		----------------------------------------------------*/
		function logout() {

			global $ini, $path;

			$this->drop_sessionInfo();

			// ZONE-IDをクッキーに入れる
			if ( $ini["session"]["zone"] != "" ) {
				$sql_escape["sessionZone"] = sql_escapeString($ini["session"]["zone"]);
				setcookie( "bason[session][zone]", $sql_escape["sessionZone"], 0, "/", $path["host"]["name"] );
			}

			// 事前設定のクッキーとモード変更した車種のクッキーを全て削除する
			if( count($_COOKIE) > 0 ) {
				foreach( $_COOKIE as $key => $val){
					if( preg_match( "#lease_#", $key ) || preg_match( "#leasePreset#", $key ) ){
						setcookie( $key, "", time() - 3600, "/", $path["host"]["name"] );
					}
				}
			}


			unset ( $this );

		}


				/*----------------------------------------------------
				    セッション情報を消す
				----------------------------------------------------*/
				function drop_sessionInfo() {

					if ( $this->memberID > 0 && $this->zone != "" ) {
						// SQLインジェクション対応
						$sql_escape["memberID"]      = sql_escapeString($this->memberID);
						$sql_escape["zone"]          = sql_escapeString($this->zone);
						$sql_escape["sessionMaster"] = sql_escapeString($this->id["sessionMaster"]);
						$sql_escape["sessionLive"]   = sql_escapeString($this->id["sessionLive"]);

						if ( $this->id["sessionMaster"] != "" ) {
							$sql = "DELETE FROM sessionMaster WHERE memberID = '{$sql_escape["memberID"]}' AND zone = '{$sql_escape["zone"]}' AND sessionID = '{$sql_escape["sessionMaster"]}'";
							sql_query ( $sql );
						}
						if ( $this->id["sessionLive"] != "" ) {
							$sql = "DELETE FROM sessionLive WHERE memberID = '{$sql_escape["memberID"]}' AND zone = '{$sql_escape["zone"]}' AND sessionID = '{$sql_escape["sessionLive"]}'";
							sql_query ( $sql );
						}
					}

				}




		/*----------------------------------------------------
		    セッションライブにエントリーを更新する
		----------------------------------------------------*/
		function update_sessionDB( $masterLive, $autoFlag=NULL ) {

			$ucMasterLive = ucfirst( $masterLive );

			if ( $this->memberID > 0 && $this->zone != "" ) {

				$update["memberID"]         = $this->memberID;
				if ( $this->id["secure$ucMasterLive"] != "" ) {
					$update["secureID"]       = $this->id["secure$ucMasterLive"];
				}
				if ( $autoFlag != NULL ) {
					$update["auto"]             = $autoFlag;
				}
				$update["IPAddress"]        = $_SERVER["REMOTE_ADDR"];
				$update["timestamp"]["com"] = "now()";

				// SQLインジェクション対応
				$sql_escape["id"]    = sql_escapeString($this->id["session$ucMasterLive"]);
				$sql_escape["zone"]  = sql_escapeString($this->zone);
				$sql_escape["caram"] = sql_escapeString("session" . $ucMasterLive);

				$sql = "UPDATE {$sql_escape["caram"]} SET {update_set} WHERE sessionID = '{$sql_escape["id"]}' AND zone = '{$sql_escape["zone"]}'";
				sql_query ( $sql, $update );

			}

		}










/* =============================================================================================

           ログイン処理

============================================================================================= */


		/*----------------------------------------------------
		    ロックアウト判定
		----------------------------------------------------*/
		function is_lockout( $loginID=NULL ){

			global $ini;

			if ( $loginID == NULL ) { return false; }

			// SQLインジェクション対応
			$sql_escape["loginID"] = sql_escapeString($loginID);

			// ロックアウト情報の取得
			$sql = "SELECT * FROM loginTryCount WHERE loginID = '{$sql_escape["loginID"]}'";
			$this->tbl["loginTryCount"] = sql_query( $sql, "single" );
			$this->tbl["loginTryCount"]["counter"] = sprintf ( "%d", $this->tbl["loginTryCount"]["counter"] );

			// ロックアウトしている
			if( $this->tbl["loginTryCount"]["counter"] >= $ini["session"]["lockoutLimit"] ){

				// ロックアウト期間を経過していないか？
				$nowPlus     = date( "YmdHis", mktime( date("H"), date("i") - $ini["session"]["lockoutTimeIN"], date("s"), date("m"), date("d"), date("Y") ) );
				$lockoutTime = preg_replace ( "#-| |:#", "", $this->tbl["loginTryCount"]["lockoutDatetime"] );

				// 今ロックアウトした！
				if ( $lockoutTime == "" ) {
					$update["counter"]                = $this->tbl["loginTryCount"]["counter"] + 1;
					$update["lockoutDatetime"]["com"] = "now()";
					$sql = "UPDATE loginTryCount SET {update_set} WHERE loginID = '{$sql_escape["loginID"]}'";
					sql_query( $sql, $update );
				}
				// ロックアウト期間を経過している
				elseif ( $nowPlus > $lockoutTime ) {
					$sql = "DELETE FROM loginTryCount WHERE loginID = '{$sql_escape["loginID"]}'";
					sql_query( $sql );
					return false;
				}
				// ロックアウト期間中である
				else {
					$update["counter"]                = $this->tbl["loginTryCount"]["counter"] + 1;
					$update["lockoutDatetime"]["com"] = "now()";
					$sql = "UPDATE loginTryCount SET {update_set} WHERE loginID = '{$sql_escape["loginID"]}'";
					sql_query( $sql, $update );

				}
				return true;

			}

			return false;

		}




		/*----------------------------------------------------
		    ログインIDとパスワードの確認
		----------------------------------------------------*/
		function is_authorized( $loginID, $password ){

			global $ini,$class;

			// SQLインジェクション対応
			$sql_escape["loginID"] = sql_escapeString($loginID);
			$sql_escape["password"] = sql_escapeString($password);

			// ソルト情報の取得
			$sql = "SELECT password, salt FROM sessionMember WHERE loginID = '{$sql_escape["loginID"]}' ";
			$saltInfo = sql_query($sql, "single");

			// パスワードチェック
			$passwordHash = $class["encryption"]->get_makeHash($sql_escape["password"], $saltInfo["salt"]);
			if( empty($passwordHash) || !$class["encryption"]->check_hashEquals($saltInfo["password"], $passwordHash) ){
				$this->st["sessionLive"] = 1;
				return false;
			}
			$sql_escape["password"] = sql_escapeString($passwordHash);

			// メンバー情報の取得
			$sql = "SELECT * FROM sessionMember WHERE loginID = '{$sql_escape["loginID"]}' AND password = '{$sql_escape["password"]}'";
			$this->tbl["sessionMember"] = sql_query( $sql, "single" );

			// ＩＤ・パスワード違い
			if( $this->tbl["sessionMember"]["memberID"] == "" ){
				$this->st["sessionLive"] = 1;
				return false;
			}

			// アクセス権限レベルチェック
			elseif( $this->tbl["sessionMember"]["level"] < $ini["session"]["level"] ){
				$this->st["sessionLive"] = 4;
				return false;
			}

			if ( $this->memberID != $this->tbl["sessionMember"]["memberID"] ) {
				$this->monitorID = $this->memberID;
			}
			else {
				$this->monID = $this->memberID;
			}


			$this->memberID = $this->tbl["sessionMember"]["memberID"];

			return true;

		}




		/*----------------------------------------------------
		    ロックアウトカウントアップ
		----------------------------------------------------*/
		function countUp_loginTryCount( $loginID ){

			if ( $this->tbl["loginTryCount"]["counter"] == 0 ) {
				$insert["loginID"]                = $loginID;
				$insert["counter"]                = 1;
				$insert["insertDatetime"]["com"]  = "now()";
				$sql = "INSERT INTO loginTryCount {insert_value}";
				sql_query( $sql, $insert );
			}
			else {
				$update["counter"]                = $this->tbl["loginTryCount"]["counter"] + 1;

				// SQLインジェクション対応
				$sql_escape["loginID"] = sql_escapeString($loginID);
				$sql = "UPDATE loginTryCount SET {update_set} WHERE loginID = '{$sql_escape["loginID"]}'";
				sql_query( $sql, $update );
			}

		}




		/*----------------------------------------------------
		    ログインの実行
		----------------------------------------------------*/
		function exec_login( $autoFlag=NULL ) {

			// セッションIDの発行
			$this->issue_sessionID( "live",   "session" );
			$this->issue_sessionID( "live",   "secure"  );
			$this->issue_sessionID( "master", "session" );
			$this->issue_sessionID( "master", "secure"  );

			// sessionDBに追加
			$this->add_sessionDB( "live", $autoFlag );
			$this->add_sessionDB( "master" );

			// SQLインジェクション対応
			$sql_escape["loginID"] = sql_escapeString($this->loginID);

			// ログイントライカウントをクリア
			$sql = "DELETE FROM loginTryCount WHERE loginID = '{$sql_escape["loginID"]}' ";
			sql_query( $sql );

			// sessionLive/Masterテーブルの取得
			$this->get_sessionDataDB( "live", "session" );
			$this->get_sessionDataDB( "live", "secure" );
			$this->get_sessionDataDB( "master", "session" );
			$this->get_sessionDataDB( "master", "secure" );

			// メンバー基本情報の取得
			$this->get_basicMemberInfo();

		}


				/*----------------------------------------------------
				    セッションIDの発行
				----------------------------------------------------*/
				function issue_sessionID( $masterLive, $sessionSecure ) {

					global $path;

					$ucMasterLive = ucfirst( $masterLive );
					$sessionID = "";
					$ucSessionSecure = ucfirst( $sessionSecure );

					if ( $this->id["$sessionSecure$ucMasterLive"] == "" && ( $masterLive == "master" || $masterLive == "live" ) &&  ( $sessionSecure == "session" || $sessionSecure == "secure" ) ) {

						while ( $sessionID == "" ) {
							$tmpSessionID = create_randomString ( 32 );
							if ( !( $this->is_sessionIDonDB( $tmpSessionID, $ucMasterLive, $sessionSecure ) ) ) {
								$sessionID = $tmpSessionID;
							}
						}

						$secureMode = ( $sessionSecure == "secure" ) ? 1 : 0;


						$expireTerm = $masterLive == "master" ? time() + 3600 * 24 * 365 : 0;
						$sql_escape["sessionID"] = sql_escapeString($sessionID);
						setcookie ( "bason[session][$this->zone][$ucMasterLive][$ucSessionSecure]", $sql_escape["sessionID"], $expireTerm, "/", $path["host"]["name"], $secureMode );

						// 古いIDはDBから削除
						if ( $sessionID != $this->id["$sessionSecure$ucMasterLive"] ) {
							$this->drop_sessionIDfromDB ( $this->id["$sessionSecure$ucMasterLive"], $masterLive, $sessionSecure );
						}

						$this->id["$sessionSecure$ucMasterLive"] = $sessionID;

					}

				}


						/*----------------------------------------------------
						    sessionID の存否確認
						----------------------------------------------------*/
						function is_sessionIDonDB( $sessionID, $ucMasterLive, $sessionSecure ) {

							$table = "session$ucMasterLive";

							// SQLインジェクション対応
							$sql_escape["sessionID"] = sql_escapeString($sessionID);
							$sql_escape["caram"]     = sql_escapeString($sessionSecure . "ID");
							$sql_escape["table"]     = sql_escapeString($table);

							$sql = "SELECT {$sql_escape["caram"]} FROM {$sql_escape["table"]} WHERE {$sql_escape["caram"]} = '{$sql_escape["sessionID"]}'";
							$tbl = sql_query ( $sql, "single" );

							return ( $tbl["{$sessionSecure}ID"] != "" ) ? true : false;

						}


						/*----------------------------------------------------
						    古いIDはDBから削除
						----------------------------------------------------*/
						function drop_sessionIDfromDB( $sessionID, $masterLive, $sessionSecure ) {

							if ( $sessionID != "" && $this->memberID > 0 ) {

								$ucMasterLive = ucfirst( $masterLive );
								$table = "session$ucMasterLive";

								// SQLインジェクション対応
								$sql_escape["memberID"]   = sql_escapeString($this->memberID);
								$sql_escape["sessionID"]  = sql_escapeString($sessionID);
								$sql_escape["table"]      = sql_escapeString($table);
								$sql_escape["whereCaram"] = sql_escapeString($sessionSecure . "ID");

								$sql = "DELETE FROM {$sql_escape["table"]} WHERE {$sql_escape["whereCaram"]} = '{$sql_escape["sessionID"]}' AND memberID = '{$sql_escape["memberID"]}' ";
								sql_query ( $sql );

							}

						}


				/*----------------------------------------------------
				    セッションライブにエントリーを入れる
				----------------------------------------------------*/
				function add_sessionDB( $masterLive, $autoFlag=NULL ) {

					$ucMasterLive = ucfirst( $masterLive );
					$updateFlag = 1;

					if ( $this->tbl["session$ucMasterLive"]["sessionID"] == "" && $this->tbl["session$ucMasterLive"]["secureID"] == "" && $this->memberID > 0 ) {

						// SQLインジェクション対応
						$sql_escape["id"]    = sql_escapeString($this->id["session$ucMasterLive"]);
						$sql_escape["zone"]  = sql_escapeString($this->zone);
						$sql_escape["table"] = sql_escapeString("session" . $ucMasterLive);

						$sql = "SELECT sessionID FROM {$sql_escape["table"]} WHERE sessionID = '{$sql_escape["id"]}' AND zone = '{$sql_escape["zone"]}'";
						$tbl = sql_query ( $sql, "single" );

						if ( $tbl["sessionID"] == "" ) {

							$insert["memberID"]          = $this->memberID;
							$insert["sessionID"]         = $this->id["session$ucMasterLive"];
							$insert["secureID"]          = $this->id["secure$ucMasterLive"];
							$insert["IPAddress"]         = $_SERVER["REMOTE_ADDR"];
							$insert["zone"]              = $this->zone;
							if ( $masterLive == "live" ) {
								$insert["loginTime"]["com"]  = "now()";
							}
							if ( $autoFlag != NULL ) {
								$insert["auto"]      = $autoFlag;
							}

							$sql = "INSERT INTO session$ucMasterLive {insert_value}";
							sql_query ( $sql, $insert );

							$updateFlag = 0;

						}

					}

					// アップデート
					if ( $updateFlag == 1 ) {

						$this->update_sessionDB( $masterLive, $autoFlag );

					}

				}




		/*----------------------------------------------------
		    モニターメンバーの削除
		----------------------------------------------------*/
		function drop_monitorMember() {

			if ( $this->monitorID > 0 ) {

				// SQLインジェクション対応
				$sql_escape["monitorID"] = sql_escapeString($this->monitorID);
				$sql = "DELETE FROM sessionMember WHERE memberID = '{$sql_escape["monitorID"]}'";
				sql_query ( $sql );

			}

		}




		/*----------------------------------------------------
		    自動ログインフラグを立てる
		----------------------------------------------------*/
		function set_autoLoginFlag( $autoLogin ) {

			if ( $this->memberID > 0 ) {
				$update["autoLogin"] = sprintf( "%d", $autoLogin );

				// SQLインジェクション対応
				$sql_escape["memberID"] = sql_escapeString($this->memberID);
				$sql = "UPDATE sessionMember SET {update_set} WHERE memberID = '{$sql_escape["memberID"]}'";
				sql_query( $sql, $update );
			}

			$this->autoLogin = $autoLogin;

		}




		/*----------------------------------------------------
			デバッグテキスト出力
		----------------------------------------------------*/
		function writeDeb ($log,$file_name="") {

			if( $file_name=="" ){
				$file_name="debugLog.txt";
			}

			// ファイルの保存
			$fp = fopen( "$file_name", "a" );
			fputs( $fp, $log . "\n" );
			fclose( $fp );
			chmod( $file_name, 0666 );

		}




		/*----------------------------------------------------
			権限レベルの確認(管理ツール：一般はログイン不可)
		----------------------------------------------------*/
		function is_authorityLevel ( $pageUrl="admin" ) {

			global $ini;

			if ( $this->memberID > 0 ) {

				// SQLインジェクション対応
				$sql_escape["memberID"] = sql_escapeString($this->memberID);
				$sql_escape["days"]     = sql_escapeString($ini["systemLevel"]["days"]);

				// メンバー情報の取得
				$sql = "SELECT * , coalesce( to_days(expirationDatetime) - to_days(now()) , {$sql_escape["days"]}) as dayDiff FROM salesMember WHERE memberID = '{$sql_escape["memberID"]}' ";
				$this->tbl["salesMember"] = sql_query( $sql, "single" );

				// アクセス権限レベルチェック
				$authorityLevel = $this->tbl["salesMember"]["authorityLevel"];
				if( !in_array( $authorityLevel,  $ini["session"]["{$pageUrl}Level"] ) ){
					$this->st["sessionLive"] = 4;
					return false;
				}

				// パスワード有効期限チェック
				$dayDiff = $this->tbl["salesMember"]["dayDiff"];
				if( isset($ini["session"]["{$pageUrl}PWLimit"]) && $ini["session"]["{$pageUrl}PWLimit"] > $dayDiff ){
					$this->st["sessionLive"] = 4;
					return false;
				}

				return true;

			} else {
				return false;
			}

		}









	}





?>