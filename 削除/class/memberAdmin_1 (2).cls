<?php
/* -------------------------------------
	管理者管理
	for NetGRID PHP Framework v2
	最終更新: 2009-02-06
------------------------------------- */


	class memberAdmin_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function memberAdmin () {

		}


		/*----------------------------------------------------
		    メンバー情報追加
		----------------------------------------------------*/
		function insert_DB ( $input ) {

			global $class;

			// セッションメンバーに追加
			unset( $insert );
			$insert["loginID"]            = $input["memberInfo"]["loginID"];
			$insert["level"]              = $input["memberInfo"]["level"];
			$insert["autoLogin"]          = "0"; // 0:なし

			// 暗号化パスワードの作成
			$insert["salt"]               = $class["encryption"]->get_makeSalt();
			$insert["password"]           = $class["encryption"]->get_makeHash($input["memberInfo"]["password"], $insert["salt"]);

			$sql = "INSERT INTO sessionMember {insert_value}";
			list( $affected_row, $memberID ) = sql_query( $sql, $insert, "1" );

			// メンバー情報に追加
			unset( $insert );
			$insert["memberID"]           = $memberID;
			$insert["memberName"]         = val2db_name( $input["memberInfo"]["memberName"] );
			$insert["companyName"]        = $input["memberInfo"]["companyName"];
			$insert["email"]              = val2db_email( $input["memberInfo"]["email"] );
			$insert["addDatetime"]["com"] = "now()";
			$insert["addMemberID"]        = $class["session"]->memberID;

			$sql = "INSERT INTO memberInfo {insert_value}";
			list( $affected_row, $insert_id ) = sql_query( $sql, $insert, "1" );


			// 管理者情報更新
			unset( $insert );
			$input                        = $this->convert_dbInfo($input);
			$insert["memberID"]           = $memberID;
			$insert["salesGroup"]         = $input["memberInfo"]["salesGroup"];
			$insert["authorityLevel"]     = $input["memberInfo"]["authorityLevel"];
			$insert["expirationDatetime"] = $input["memberInfo"]["expirationDatetime"];

			$sql = "INSERT INTO  salesMember {insert_value}";
			list( $affected_row, $insert_id ) = sql_query( $sql, $insert, "1" );

			return $memberID;

		}


		/*----------------------------------------------------
		    メンバー情報更新
		----------------------------------------------------*/
		function update_DB ( $input ) {

			if ( $input["memberID"] == ""
				|| $input["memberID"] == "0" ){
				return;
			}

			// SQLインジェクション対応
			$sql_escape["memberID"] = sql_escapeString($input["memberID"]);

			if( !empty($input["memberInfo"]["password"]) ){
				// パスワードの更新
				$this->update_DB_password($input);
			}

			// セッションメンバー更新
			unset( $update );
			$update["loginID"]            = $input["memberInfo"]["loginID"];
			$update["level"]              = $input["memberInfo"]["level"];

			$sql = "UPDATE sessionMember SET {update_set} WHERE memberID = '{$sql_escape["memberID"]}'";
			sql_query( $sql, $update, "1" );


			// メンバー情報更新
			unset( $update );
			$update["memberName"]         = val2db_name( $input["memberInfo"]["memberName"] );
			$update["companyName"]        = $input["memberInfo"]["companyName"];
			$update["email"]              = val2db_email( $input["memberInfo"]["email"] );

			$sql = "UPDATE memberInfo SET {update_set} WHERE memberID = '{$sql_escape["memberID"]}'";
			sql_query( $sql, $update, "1" );

			// 管理者情報更新
			unset( $update );
			$input                        = $this->convert_dbInfo($input);
			$update["salesGroup"]         = $input["memberInfo"]["salesGroup"];
			$update["authorityLevel"]     = $input["memberInfo"]["authorityLevel"];
			$update["expirationDatetime"] = $input["memberInfo"]["expirationDatetime"];

			$sql = "UPDATE salesMember SET {update_set} WHERE memberID = '{$sql_escape["memberID"]}'";
			sql_query( $sql, $update, "1" );

		}


		/*----------------------------------------------------
		    メンバー情報削除
		----------------------------------------------------*/
		function delete_DB ( $input ) {

			if ( $input["memberID"] == ""
				|| $input["memberID"] == "0" ){
				return;
			}

			// SQLインジェクション対応
			$sql_escape["memberID"] = sql_escapeString($input["memberID"]);

			// セッションメンバー削除
			$sql = "DELETE FROM sessionMember WHERE memberID = '{$sql_escape["memberID"]}'";
			sql_query( $sql, "", "1" );

			// メンバー情報削除
			$sql = "DELETE FROM memberInfo WHERE memberID = '{$sql_escape["memberID"]}'";
			sql_query( $sql, "", "1" );

			// セッションマスター削除
			$sql = "DELETE FROM sessionMaster WHERE memberID = '{$sql_escape["memberID"]}'";
			sql_query( $sql, "", "1" );

			// セッションライブ削除
			$sql = "DELETE FROM sessionLive WHERE memberID = '{$sql_escape["memberID"]}'";
			sql_query( $sql, "", "1" );

			// 管理者情報削除
			$sql = "DELETE FROM salesMember WHERE memberID = '{$sql_escape["memberID"]}'";
			sql_query( $sql, "", "1" );
		}


		/*----------------------------------------------------
		  メンバーリスト取得
		----------------------------------------------------*/
		function get_list ( $input ) {

			global $ini;

			// where句の生成
			$where[] = "memberInfo.memberID = sessionMember.memberID";
			$where[] = "memberInfo.memberID = salesMember.memberID";

			// 会員ID
			if ( $input["searchMemberID"] > 0 ) {
				$sql_escape["searchMemberID"] = sql_escapeString($input["searchMemberID"]);
				$where[] = "memberInfo.memberID = '{$sql_escape["searchMemberID"]}'";
			}

			// 会員名
			if ( $input["searchMemberName"] != "" ) {
				$sql_escape["searchMemberName"] = sql_escapeString($input["searchMemberName"]);
				$where[] = "( REPLACE ( memberInfo.memberName, '@', '' ) LIKE '%{$sql_escape["searchMemberName"]}%' )";
			}

			// メールアドレス
			if ( $input["searchEmail"] != "" ) {
				$sql_escape["searchEmail"] = sql_escapeString($input["searchEmail"]);
				$where[] = "memberInfo.email LIKE '%{$sql_escape["searchEmail"]}%'";
			}

			// 会社名
			if ( $input["searchCompanyName"] != "" ) {
				$sql_escape["searchCompanyName"] = sql_escapeString($input["searchCompanyName"]);
				$where[] = "memberInfo.companyName LIKE '%{$sql_escape["searchCompanyName"]}%'";
			}

			// 権限
			if ( $input["searchLevel"] != "" ) {
				$sql_escape["searchLevel"] = sql_escapeString($input["searchLevel"]);
				$where[] = "sessionMember.level = '{$sql_escape["searchLevel"]}'";
			}

			// 所属グループ
			if ( $input["searchSalesGroup"] != "" ) {
				$sql_escape["searchSalesGroup"] = sql_escapeString($input["searchSalesGroup"]);
				$where[] = "salesMember.salesGroup = '{$sql_escape["searchSalesGroup"]}'";
			}

			// アクセス権限レベル
			if ( $input["searchAuthorityLevel"] != "" ) {

				if( $ini["systemLevel"]["setAuthorityLevel"] != $input["searchAuthorityLevel"] ){
					// 一般
					$tmp_authorityLevel[] = $input["searchAuthorityLevel"];
				} else {
					// 管理者
					if( $input["searchSalesGroup"] != "" ){
						if( $ini["systemLevel"]["salesGroup"] == $input["searchSalesGroup"] ){
							// グループ＝システム
							$tmp_authorityLevel[] = $input["searchAuthorityLevel"];
						} else {
							// グループ＝各グループ
							$tmp_authorityLevel[] = $ini["systemLevel"]["authorityLevel"];
						}
					} else {
						// グループ指定なし
						$tmp_authorityLevel[] = $input["searchAuthorityLevel"];
						$tmp_authorityLevel[] = $ini["systemLevel"]["authorityLevel"];
					}
				}

				if( count($tmp_authorityLevel) > 0 ){
					for( $i = 0; $i < count($tmp_authorityLevel); $i++ ){
						$tmp["authorityLevel"][] = sql_escapeString($tmp_authorityLevel[$i]);
					}

					$authorityLevel = @implode( " , ", $tmp["authorityLevel"] );
					$sql_escape["authorityLevel"] = $authorityLevel;

					$where[] = "salesMember.authorityLevel in ({$sql_escape["authorityLevel"]})";
				} 
			}

			if ( count( $where ) > 0 ) {
				$sql_where = "WHERE " . @implode( " AND ", $where );
			}

			// 件数の取得
			$sql = "SELECT count(*) AS cnt FROM memberInfo, sessionMember, salesMember {$sql_where}";
			$tbl = sql_query( $sql, "single" );

			// ページ情報の取得
			$pageInfo = adjust_pageState( $tbl["cnt"], $ini["pageLimit"]["memberAdmin"], $input["pageNum"] );

			// SQLインジェクション対応
			$sql_escape["days"]       = sql_escapeString($ini["systemLevel"]["days"]);
			$sql_escape["limitStart"] = sql_escapeString($pageInfo["limitStart"]);
			$sql_escape["pageLimit"]  = sql_escapeString($ini["pageLimit"]["memberAdmin"]);

			$sql  = "SELECT * , coalesce( to_days(expirationDatetime) - to_days(now()) , {$sql_escape["days"]}) as dayDiff ";
			$sql .= "FROM memberInfo, sessionMember ,salesMember ";
			$sql .= "{$sql_where} ";
			$sql .= "ORDER BY sessionMember.level DESC, memberInfo.memberID DESC ";
			$sql .= "LIMIT {$sql_escape["limitStart"]}, {$sql_escape["pageLimit"]}";
			$list = (array)sql_query( $sql );

			for( $i=0; $i<count( $list ); $i++ ) {
				$list[$i]["memberName"]         = db2val_name( $list[$i]["memberName"] );
				$list[$i]["email"]              = db2val_email( $list[$i]["email"] );
				$list[$i]["addDatetime"]        = db2val_date( $list[$i]["addDatetime"] );
				$list[$i]["expirationDatetime"] = db2val_date( $list[$i]["expirationDatetime"] );
				// 確認用パスワード
				$list[$i]["passwordConfirm"]    = $list[$i]["password"];

			}

			return array( $list, $pageInfo );
		}


		/*----------------------------------------------------
		  メンバー情報取得
		----------------------------------------------------*/
		function get_info ( $memberID ) {

			if( $memberID ){
				global $ini;

				// SQLインジェクション対応
				$sql_escape["days"]     = sql_escapeString($ini["systemLevel"]["days"]);
				$sql_escape["memberID"] = sql_escapeString($memberID);

				$sql  = "SELECT * , coalesce( to_days(expirationDatetime) - to_days(now()) , {$sql_escape["days"]}) as dayDiff ";
				$sql .= "FROM memberInfo, sessionMember ,salesMember ";
				$sql .= "WHERE memberInfo.memberID = sessionMember.memberID ";
				$sql .= "AND memberInfo.memberID = salesMember.memberID ";
				$sql .= "AND memberInfo.memberID = '{$sql_escape["memberID"]}'";

				$ret = sql_query( $sql, "single" );

				$ret["memberName"]         = db2val_name( $ret["memberName"] );
				$ret["email"]              = db2val_email( $ret["email"] );
				$ret["addDatetime"]        = db2val_date( $ret["addDatetime"] );

				// 確認用パスワード
				$ret["passwordConfirm"]    = $ret["password"];

				// 有効期限まで残り日数
				if( $ini["systemLevel"]["salesGroup"] == $ret["salesGroup"] ){
					$ret["expirationDatetime"] = date("Y-m-d");
				}

				// 現在の有効期限
				$ret["expirationDatetime"]        = db2val_date( $ret["expirationDatetime"] );
				$ret["defaultExpirationDatetime"] = $ret["expirationDatetime"];

			}

			return $ret;
		}


		/*----------------------------------------------------
		  メンバー情報を表示用に変更
		----------------------------------------------------*/
		function convert_Info ( $info ) {

			global $ini;

			// 権限名取得
			$info["levelName"]          = get_levelName( $info["level"] );

			// 登録者名取得
			$addMemberInfo              = $this->get_info( $info["addMemberID"] );
			$info["addMemberName"]      = $addMemberInfo["memberName"];

			// 所属グループ
			$info["salesGroupName"]     = get_salesGroupName( $info["salesGroup"] );

			// 権限レベル
			$info["authorityLevelName"] = get_authorityLevelName( $info["authorityLevel"]);

			// 現在の有効期限
			if( $ini["systemLevel"]["salesGroup"] == $info["salesGroup"] ){
				$info["expirationDatetime"] = db2val_date( "0000-00-00 00:00:00" );
			}

			if( count($info["expirationDatetime"]) == 1 ){
				$info["expirationDatetime"] = db2val_date($info["expirationDatetime"]);
			}

			// ログインID(一般権限の場合、非表示にする)
			if( $ini["expirationUserLevel"] == $info["authorityLevel"] && !get_dispModeAdminFlg()){
				$info["loginHidden"] = 1;
			}

			// ステータスチェック
			if( $info["level"] == "100" || $ini["systemLevel"]["salesGroup"] == $info["salesGroup"]){
				$info["expirationDisablFlg"] = 1;
			}

			// 有効日数の設定
			$info = $this->convert_expirationDay($info);

			return $info;
		}

		/*----------------------------------------------------
		  メンバー情報(管理権限)をDB用に変更
		----------------------------------------------------*/
		function convert_dbInfo ( $info ) {

			global $ini;

			// 所属グループ
			$info["memberInfo"]["salesGroup"]         = $info["memberInfo"]["salesGroup"];

			// 権限レベル
			if( $ini["systemLevel"]["salesGroup"] == $info["memberInfo"]["salesGroup"] ){
				// グループ＝システム
				$info["memberInfo"]["authorityLevel"] = $info["memberInfo"]["authorityLevel"];
			} else if( $info["memberInfo"]["authorityLevel"] == $ini["systemLevel"]["setAuthorityLevel"] ) {
				// グループ＝各グループ(管理者)
				$info["memberInfo"]["authorityLevel"] = $ini["systemLevel"]["authorityLevel"];
			} else {
				// グループ＝各グループ(一般)
				$info["memberInfo"]["authorityLevel"] = $info["memberInfo"]["authorityLevel"];
			}

			return $info;
		}


		/*----------------------------------------------------
		  一般権限のログインID作成(グループ管理者用)
		----------------------------------------------------*/
		function set_userDefaultLoginID ( $length = 16 ) {

			$baseString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

			return substr(str_shuffle($baseString), 0, $length);
		}


		/*----------------------------------------------------
		    メンバー情報の確認
		----------------------------------------------------*/
		function check_emailbyMemberInfo( $email ){

			global $ini;

			// SQLインジェクション対応
			$sql_escape["email"] = sql_escapeString($email);

			// メンバー情報の取得
			$sql = "SELECT sessionMember.* FROM memberInfo, sessionMember WHERE sessionMember.memberID = memberInfo.memberID AND email='{$sql_escape["email"]}'";
			$ret = sql_query( $sql, "single" );

			if( count($ret) == 0 ){
				$ret["loginID"] = $email;
			}

			return $ret;

		}


		/*----------------------------------------------------
		    メンバー情報更新(パスワードのみ)
		----------------------------------------------------*/
		function update_DB_password ( $input ) {

			if ( $input["memberID"] == "" || $input["memberID"] == "0" ){
				return;
			}

			global $class;
			
			// SQLインジェクション対応
			$sql_escape["memberID"] = sql_escapeString($input["memberID"]);

			// ソルトの取得
			$sql = "SELECT salt from sessionMember WHERE memberID = '{$sql_escape["memberID"]}'";
			$ret = sql_query( $sql, "single" );

			if( empty($ret["salt"]) ){
				$ret["salt"]    = $class["encryption"]->get_makeSalt();
				$update["salt"] = $ret["salt"];
			}

			// パスワードの暗号化
			$newPassword = $class["encryption"]->get_makeHash($input["memberInfo"]["password"], $ret["salt"]);

			// セッションメンバー更新
			$update["password"]    = $newPassword;
			$sql = "UPDATE sessionMember SET {update_set} WHERE memberID = '{$sql_escape["memberID"]}'";
			sql_query( $sql, $update, "1" );
		}

		/*----------------------------------------------------
		  メンバー情報(パスワード有効期限)を表示用に変更
		----------------------------------------------------*/
		function convert_expirationDay ( $info ) {

			global $ini;

			if( $info["expirationDisablFlg"] ){
				if( $ini["systemLevel"]["salesGroup"] == $info["salesGroup"] && $info["level"] == $ini["systemLevel"]["level"] ){
					// システム管理者
					$info["expirationDayFlg"]["systemLevel"] = 1;
				} else {
					// 無効
					$info["expirationDayFlg"]["expiration"] = 1;
				}
			} else {

				// 当日チェック
				$expirationDatetime = date("Y-m-d" , mktime(0, 0, 0, $info["expirationDatetime"]["month"], $info["expirationDatetime"]["day"], $info["expirationDatetime"]["year"]));
				$today              = date("Y-m-d");
				if( strtotime($expirationDatetime) == strtotime($today)){
					$info["expirationDayFlg"]["today"] = 1;
				}

				// 残り日数チェック
				if( $info["dayDiff"] < 0 || strtotime($expirationDatetime) < strtotime($today)){
					$info["dayDiffFlg"] = 1;
				}
			}

			// ログインID(一般権限の場合、非表示にする)
			if( $ini["expirationUserLevel"] == $info["authorityLevel"] && !get_dispModeAdminFlg() ){
				$info["loginHidden"] = 1;
			}

			return $info;

		}
	}


?>