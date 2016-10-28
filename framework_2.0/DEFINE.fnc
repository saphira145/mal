<?php

	global $output, $path, $class, $status;

	/*----------------------------------------------------
	  URL設定
	----------------------------------------------------*/
	$output["HTTP_URL"]  = $path["http"]["domain"];
	$output["SSL_URL"]   = $path["https"]["domain"];
	$output["THIS-PAGE"] = $path["url"];
	$output["UNIT_URL"]  = $path["unit"]["url"];
	$output["REFERER"]   = $path["referer"]["url"];


	/*----------------------------------------------------
	  メンバー情報の取得
	----------------------------------------------------*/
	if ( $class["session"]->memberID > 0 ) {
		// SQLインジェクション対応
		$sql_escape["memberID"]     = sql_escapeString($class["session"]->memberID);
		$sql_escape["proxyAdminID"] = sql_escapeString($class["session"]->proxyAdminID);


		$sql = "SELECT * FROM memberInfo WHERE memberID = '{$sql_escape["memberID"]}' ";
		$tbl = sql_query( $sql, "single" );
		preg_match ( "#([^@]+)@(.+)#", $tbl["memberName"], $match );

		$output["MEMBER"]["MEMBER_ID"] = $class["session"]->memberID;

		$output["MEMBER"]["NAME"]["FULL"]    = preg_replace ( "#@#", "&nbsp;", $match[0] );
		$output["MEMBER"]["NAME"]["LNAME"]   = $match[1];
		$output["MEMBER"]["NAME"]["FNAME"]   = $match[2];

		// 営業ツール用
		unset($match);
		preg_match ( "#([^@]+)@(.+)#", $tbl["email"], $match );
		$output["MEMBER"]["EMAIL"]["FULL"]    = $match[0];
		$output["MEMBER"]["EMAIL"]["ACCOUNT"] = $match[1];
		$output["MEMBER"]["EMAIL"]["DOMAIN"]  = $match[2];

		// レベルはセッションメンバーから取得
		$sql  = "SELECT level FROM sessionMember WHERE memberID = '{$sql_escape["memberID"]}' ";
		$tbl3 = sql_query( $sql, "single" );

		$output["MEMBER"]["LEVEL"] = $tbl3["level"];
		$output["MEMBER"]["LEVEL-SET"][$tbl3["level"]] = 1;

		// 代理ログイン情報
		if ( $class["session"]->proxyAdminID > 0 ) {
			$output["MEMBER"]["ADMIN_MEMBER_ID"] = $class["session"]->proxyAdminID;

			$sql  = "SELECT memberName FROM memberInfo WHERE memberID = '{$sql_escape["proxyAdminID"]}' ";
			$tbl2 = sql_query( $sql, "single" );
			preg_match ( "#([^@]+)@(.+)#", $tbl2["memberName"], $match2 );

			$output["MEMBER"]["ADMIN_NAME"]["FULL"]    = preg_replace ( "#@#", "&nbsp;", $match2[0] );
			$output["MEMBER"]["ADMIN_NAME"]["LNAME"]   = $match2[1];
			$output["MEMBER"]["ADMIN_NAME"]["FNAME"]   = $match2[2];
		}

		// 残り日数の保持
		$sql_escape["days"] = sql_escapeString($ini["systemLevel"]["days"]);
		
		$sql  = "SELECT salesGroup, coalesce( to_days(expirationDatetime) - to_days(now()) , {$sql_escape["days"]}) as dayDiff ";
		$sql .= "FROM salesMember ";
		$sql .= "WHERE memberID = '{$sql_escape["memberID"]}'";
		$tbl4 = sql_query( $sql, "single" );

		$output["MEMBER"]["DAYCNT"] = $tbl4["dayDiff"];
		$output["MEMBER"]["DAYCNTFlg"] = 1;
		if( $tbl4["dayDiff"] == $ini["systemLevel"]["days"] || $ini["systemLevel"]["salesGroup"] == $tbl4["salesGroup"] ) {
			unset($output["MEMBER"]["DAYCNT"]);
			unset($output["MEMBER"]["DAYCNTFlg"]);
		}
	}


	/*----------------------------------------------------
	  日時設定
	----------------------------------------------------*/
	$output["NOW"] = date( "Y/m/d H:i:s" );



	/*----------------------------------------------------
	  文字コード
	----------------------------------------------------*/
	$output["jpEncoding"] = $ini["jp_encoding"];



	/*----------------------------------------------------
	  ステータス
	----------------------------------------------------*/
	$output["ST"][$status] = 1;











?>