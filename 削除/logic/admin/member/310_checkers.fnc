<?php



	/* ==================================================================

	        C O N V E R T E R

	================================================================== */






	/* ==================================================================

	        F I L T E R

	================================================================== */

	/*----------------------------------------------------
	    FILTER : memberIdExist
	----------------------------------------------------*/
	function FILTER_memberIdExist ( &$value, $key="", $arg="" ) {

		// SQLインジェクション対応
		$sql_escape["value"] = sql_escapeString($value);

		$sql = "SELECT memberID FROM memberInfo WHERE memberID = '{$sql_escape["value"]}'";
		$tbl = sql_query ( $sql, "single" );

		if ( $tbl["memberID"] != $value ) {
			unset ( $value );
			return 1;
		}

	}










	/* ==================================================================

	        C H E C K E R

	================================================================== */

	/*----------------------------------------------------
	    CHECK : emailType
	----------------------------------------------------*/
	function CHECK_emailType ( &$value, $key="", $arg="" ) {

		if ( $value["account"] != "" && $value["domain"] ) {
			$email = $value["account"] . "@" . $value["domain"];
			if(!preg_match('/^[^@]+@[^.]+\..+/', $email)) {
				return 1;
			}
		}

	}


	/*----------------------------------------------------
	    CHECK : dup_mail
	----------------------------------------------------*/
	function CHECK_dup_mail ( &$value, $key="", $arg="" ) {

		$account   = $value["account"];
		$domain    = $value["domain"];
		$memberID  = $arg[0];

		if( $account == "" || $domain == "" ) {
			return;
		}

		$email = $account . "@" . $domain;

		// SQLインジェクション対応
		$sql_escape["email"]    = sql_escapeString($email);
		$sql_escape["memberID"] = sql_escapeString($memberID);

		$sql = "SELECT email FROM memberInfo WHERE email = '{$sql_escape["email"]}' AND memberID != '{$sql_escape["memberID"]}'";
		$tbl = sql_query( $sql );

		if( count( $tbl ) > 0 ) {
			return 1;
		}

	}


	/*----------------------------------------------------
	    CHECK : dup_loginID
	----------------------------------------------------*/
	function CHECK_dup_loginID ( &$value, $key="", $arg="" ) {

		$loginID     = $value;
		$memberID    = $arg[0];

		if( $value == "" ) {
			return;
		}

		// SQLインジェクション対応
		$sql_escape["loginID"]  = sql_escapeString($loginID);
		$sql_escape["memberID"] = sql_escapeString($memberID);

		$sql = "SELECT loginID FROM sessionMember WHERE loginID = '{$sql_escape["loginID"]}' AND memberID != '{$sql_escape["memberID"]}'";
		$tbl = sql_query( $sql );

		if( count( $tbl ) > 0 ) {
			return 1;
		}

	}


	/*----------------------------------------------------
	    CHECK : levelExist
	----------------------------------------------------*/
	function CHECK_levelExist ( &$value, $key="", $arg="" ) {

		if ( $value == "" ){
			return;
		}

		global $ini;

		for( $i=0; $i<count( $ini["level"] ); $i++ ){
			if ( $ini["level"][$i]["id"] == $value ){
				return;
			}
		}

		return 1;

	}


	/*----------------------------------------------------
	    CHECK : memberStatusExist
	----------------------------------------------------*/
	function CHECK_memberStatusExist ( &$value, $key="", $arg="" ) {

		if ( $value == "" ){
			return;
		}

		global $ini;

		for( $i=0; $i<count( $ini["memberStatus"] ); $i++ ){
			if ( $ini["memberStatus"][$i]["id"] == $value ){
				return;
			}
		}

		return 1;

	}


	/*----------------------------------------------------
	    CHECK : inputEqual
	----------------------------------------------------*/
	function CHECK_inputEqual ( &$value, $key="", $arg="" ) {

		// 未入力はチェック対象外
		if( $value == "" ){
			return;
		}

		if( $value != $arg[0] ) {
			return 1;
		}

	}



	/*----------------------------------------------------
	    CHECK : authorityLevelEqual
	----------------------------------------------------*/
	function CHECK_authorityLevelEqual ( &$value, $key="", $arg="" ) {

		global $ini;

		$authorityLevel = $value;
		$salesGroup     = $arg[0];

		if ( $authorityLevel == "" ){
			return;
		}

		if( $salesGroup == $ini["systemLevel"]["salesGroup"] && $authorityLevel <> $ini["systemLevel"]["setAuthorityLevel"] ){
			return 1;
		}

		return;

	}



	/* -------------------------------------
	  CHECK: salesGroupEqual
	------------------------------------- */
	function CHECK_salesGroupEqual ( &$value, $key="", $arg="" ) {

		if ( isset ( $value ) ) {
			if ( $value != "" ) {
				return 0;
			}
			return 1;
		}

	}


?>