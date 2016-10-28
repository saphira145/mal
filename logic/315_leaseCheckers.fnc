<?php


	/* ==================================================================

	        C O N V E R T E R

	================================================================== */
	/*----------------------------------------------------
	    CONVERT : carAddDateConvert
	----------------------------------------------------*/
	function CONVERT_carAddDateConvert ( &$value, $key="", $arg="" ) {

		if( empty($value) ) {
			$value = null;
			return;
		}

		$year  = substr($value, 0, 4);
		$month = substr($value, 4, 2);
		$day   = "01";

		$value = $year . "/" . $month . "/" . $day;
	}


	/* ==================================================================

	        F I L T E R

	================================================================== */


	/* ==================================================================

	        C H E C K E R

	================================================================== */
	/*----------------------------------------------------
	    CHECK : dupPassword
	----------------------------------------------------*/
	function CHECK_dupPassword ( &$value, $key="", $arg="" ) {

		global $class;

		$password = $value;
		$email    = $arg[0];

		if( $value == "" ) {
			return;
		}

		// SQLインジェクション対応
		$sql_escape["password"] = sql_escapeString($password);
		$sql_escape["email"]    = sql_escapeString($email);

		// メンバーIDの取得
		$sql = "SELECT sessionMember.loginID FROM memberInfo, sessionMember WHERE sessionMember.memberID = memberInfo.memberID AND email = '{$sql_escape["email"]}'";
		$db  = sql_query($sql, "single");
		if ( !$db["loginID"] ) {
			return 1;
		}

		$sql_escape["loginID"]  = sql_escapeString($db["loginID"]);

		// ソルト情報の取得
		$sql = "SELECT password, salt FROM sessionMember WHERE loginID = '{$sql_escape["loginID"]}' ";
		$saltInfo = sql_query($sql, "single");

		// パスワードチェック
		$passwordHash = $class["encryption"]->get_makeHash($sql_escape["password"], $saltInfo["salt"]);
		if( !$class["encryption"]->check_hashEquals($saltInfo["password"], $passwordHash) ){
			return 1;
		}

	}


	/*----------------------------------------------------
	    CHECK : passwordEqual
	----------------------------------------------------*/
	function CHECK_passwordEqual ( &$value, $key="", $arg="" ) {

		// 未入力はチェック対象外
		if( $value == "" ){
			return;
		}

		if( $value != $arg[0] ) {
			return 1;
		}
	}


	/*----------------------------------------------------
	    CHECK : leaseParamFormat
	----------------------------------------------------*/
	function CHECK_leaseParamFormat ( &$value, $key="", $arg="" ) {

		if( empty($value) ) {
			return;
		}

		$matchString = "/^" . $arg[0] . "[0-9]+$/";
		if ( !preg_match ( $matchString, $value ) ) {
			return 1;
		}
	}


	/*----------------------------------------------------
	    CHECK : leaseParamDrop
	----------------------------------------------------*/
	function CHECK_leaseParamDrop ( &$value, $key="", $arg="" ) {

		$ret = preg_replace("/\D*/", "", $value);

		if( $ret <> "" ){
			$tmpValue = ltrim($ret, 0);

			if( empty($tmpValue) ){
				$tmpValue = 0;
			}
		}
		$value = $tmpValue;
	}


	/*----------------------------------------------------
	    CHECK : leaseParamOptionFormat
	----------------------------------------------------*/
	function CHECK_leaseParamOptionFormat ( &$value, $key="", $arg="" ) {

		if( !is_array($value) ) {
			return;
		}

		$matchString = "/^" . $arg[0] . "[0-9]+I[0-9]$/";
		for( $i = 0; $i < count($value); $i++ ){
			if ( !preg_match ( $matchString, $value[$i] ) ) {
				return 1;
			}
		}
	}


	/*----------------------------------------------------
	    CHECK : leaseParamOptionDrop
	----------------------------------------------------*/
	function CHECK_leaseParamOptionDrop ( &$value, $key="", $arg="" ) {

		for( $i = 0, $iMax = count($value); $i < $iMax; $i++ ){
			$ret = ltrim(preg_replace("/[^0-9I]/", "", $value[$i]), 0);
			if( $ret <> "" ){
				$tmpValue[] = $ret;
			}
		}
		$value = $tmpValue;
	}


	/*----------------------------------------------------
	    CHECK : leaseMileageIDExist
	----------------------------------------------------*/
	function CHECK_leaseMileageIDExist ( &$value, $key="", $arg="" ) {

		global $ini;

		if( empty($value) ){
			$value = 0;
		}

		// iniファイルから取得
		for( $i = 0, $iMax = count($ini["lease"]["mileage"]); $i < $iMax; $i++ ){
			$chkArr[$ini["lease"]["mileage"][$i]["id"]] = 1;
		}

		if( !$chkArr[$value] ){
			return 1;
		}
	}


	/*----------------------------------------------------
	    CHECK : leaseGasolineIDExist
	----------------------------------------------------*/
	function CHECK_leaseGasolineIDExist ( &$value, $key="", $arg="" ) {

		global $ini;

		if( empty($value) ){
			$value = 0;
		}

		// iniファイルから取得
		for( $i = 0, $iMax = count($ini["prefecture"]); $i < $iMax; $i++ ){
			$chkArr[$ini["prefecture"][$i]["id"]] = 1;
		}

		if( !$chkArr[$value] ){
			return 1;
		}
	}


	/*----------------------------------------------------
	    CHECK : leaseAnyInsuranceIDExist
	----------------------------------------------------*/
	function CHECK_leaseAnyInsuranceIDExist ( &$value, $key="", $arg="" ) {

		global $ini;

		if( empty($value) ){
			$value = 0;
		}

		// iniファイルから取得
		for( $i = 0, $iMax = count($ini["lease"]["voluntaryInsurance"]); $i < $iMax; $i++ ){
			$chkArr[$ini["lease"]["voluntaryInsurance"][$i]["id"]] = 1;
		}

		if( !$chkArr[$value] ){
			return 1;
		}
	}


	/*----------------------------------------------------
	    CHECK : leaseOptionIDExist
	----------------------------------------------------*/
	function CHECK_leaseOptionIDExist ( &$value, $key="", $arg="" ) {

		for( $i = 0, $iMax = count($value); $i < $iMax; $i++ ){
			list( $optionID, $optionItem ) = explode( "I", $value[$i] );
			$value[$i] = "{$optionID}-{$optionItem}";
		}
	}


	/*----------------------------------------------------
	    CHECK : ngPassword
	----------------------------------------------------*/
	function CHECK_ngPassword ( &$value, $key="", $arg="" ) {

		global $ini;

		// 同じ文字のみチェック
		$repeatStr = substr($value, 0, 1);
		$strLen    = strlen($value);
		$checkStr  = str_repeat($repeatStr, $strLen);

		if( $value === $checkStr ){
			return 1;
		}

		// リストチェック
		for( $i = 0, $iMax = count($ini["ngPasswordList"]); $i < $iMax; $i++ ){
			$checkList[$ini["ngPasswordList"][$i]] = 1;
		}

		if( $checkList[$value] ){
			return 1;
		}
	}

?>