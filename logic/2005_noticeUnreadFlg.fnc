<?php

	/* 営業ツールのみ実施
		お知らせ未読チェック
	 */
	if( $output["MEMBER"] && $_SERVER["HTTPS"] && !preg_match( "#/admin#", $path["url"] ) && !preg_match( "#/bg/#", $path["url"] ) ){

		// お知らせの取得
		$DBName = get_DBName("base");

		$sql  = "SELECT * ";
		$sql .= "FROM {$DBName}.notice ";
		$sql .= "WHERE noticeID = '1' ";
		$ret  = sql_query( $sql , "single");

		// 日付変換
		$ret["updateDatetime"] = db2val_datetimeType1( $ret["updateDatetime"] );

		// チェック
		if( $ret["noticeText"] ){
			// クッキーの確認
			if( $_COOKIE["noticeUnread"] ){
				// 更新日時の取得
				$dataDatetime    = mktime( $ret["updateDatetime"]["hour"], $ret["updateDatetime"]["min"], $ret["updateDatetime"]["sec"], $ret["updateDatetime"]["month"], $ret["updateDatetime"]["day"], $ret["updateDatetime"]["year"] );
				list($cookieDatetime, $checkList) = explode( "_", $_COOKIE["noticeUnread"] );

				if( $dataDatetime == $cookieDatetime ){
					if( !check_noticeUnread( $output["MEMBER"]["MEMBER_ID"] ,$checkList) ){
						$output["NOTICEUNREAD_FLG"] = 1;
					}
				} else {
					$output["NOTICEUNREAD_FLG"] = 1;
					setcookie( "noticeUnread", "", time() - 3600, "/", $path["host"]["name"] );
				}
			} else {
				$output["NOTICEUNREAD_FLG"] = 1;
			}
		} else {
			// クッキーの削除
			setcookie( "noticeUnread", "", time() - 3600, "/", $path["host"]["name"] );
		}
	}

?>