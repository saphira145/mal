<?php


	/* ==================================================================

	        C O N V E R T E R

	================================================================== */


	/*----------------------------------------------------
	    CONVERT : 1byte
	----------------------------------------------------*/
	function CONVERT_1byte ( &$value, $key="", $arg="" ) {

		if ( $value == "" ) {
			return;
		}

		if ( is_array ( $value ) ) {
			foreach ( $value as $k => $v ) {
				CONVERT_1byte( &$value[$k], $key, $arg );
			}
		}
		else {
			$ret = mb_convert_kana ( $value, "ask" );
			if ( $value != $ret ) {
				$value = $ret;
				return 1;
			}
		}

	}

	/*----------------------------------------------------
	    CONVERT : numeric
	----------------------------------------------------*/
	function CONVERT_numeric ( &$value, $key="", $arg="" ) {

		if( $value == "" ) {
			return;
		}

		$value_1 = $value;
		$value_2 = vsprintf ( "%d", $value );

		$value   = $value_2;

		if ( $value_1 != $value_2 ) {
			return 1;
		}

	}

	/*----------------------------------------------------
	    CONVERT : oneOfThose
	----------------------------------------------------*/
	function CONVERT_oneOfThose ( &$value, $key="", $arg="" ) {

		if ( is_array ( $arg ) ) {

			foreach ( $arg as $val ) {
				if ( $value == $val ) {
					return;
				}
			}

			$value = array_shift ( $arg );

		}

	}

	/* -----------------------------------------------------
		CONVERT : 1byteNoKana
	----------------------------------------------------- */
	function CONVERT_1byteNoKana ( &$value, $key="", $arg="" ) {

		$ret = mb_convert_kana ( $value, "as" );
		if ( $value != $ret ) {
			$value = $ret;
			return 1;
		}

	}

	/* -----------------------------------------------------
		CONVERT : trim
	----------------------------------------------------- */
	function CONVERT_trim ( &$value, $key="", $arg="" ) {

		$ret = trim( $value );
		if ( $value != $ret ) {
			$value = $ret;
			return 1;
		}

	}

	/* -----------------------------------------------------
		CONVERT : multiKana
	----------------------------------------------------- */
	function CONVERT_multiKana ( &$value, $key="", $arg="" ) {

		$value = mb_convert_kana ( $value, "KC" );

	}

	/* -----------------------------------------------------
		CONVERT : htmlspecialchars
	----------------------------------------------------- */
	function CONVERT_htmlspecialchars ( &$value, $key="", $arg="" ) {

		$value = htmlspecialchars ( $value, ENT_QUOTES, mb_internal_encoding() );

	}

	/* -----------------------------------------------------
		CONVERT : normalizeSpace
		連続する半角・全角スペースを半角スペース1つに置換
	----------------------------------------------------- */
	function CONVERT_normalizeSpace ( &$value, $key="", $arg="" ) {

		$value = preg_replace( "/[ 　]+/", " ", $value );

	}

	/* -------------------------------------
		CONVERT: parseDate
			日付の区切り文字は -./半角空白
	------------------------------------- */
	function CONVERT_parseDate ( &$value, $key="", $arg="" ) {

		if ( $value == "" ) {
			return;
		}

		preg_match( "/^(\d+)[-\.\/ ](\d+)[-\.\/ ](\d+)$/", $value, $match );
		if ( count( $match ) == 0 ) {
			return 1;
		}

		$year   = $match[1];
		$mon    = $match[2];
		$month  = $match[2];
		$day    = $match[3];
		$value  = sprintf( "%d/%d/%d", $year, $month, $day );

	}

	/* -------------------------------------
		CONVERT: parseTime
			時間の区切り文字は :
	------------------------------------- */
	function CONVERT_parseTime ( &$value, $key="", $arg="" ) {

		if ( $value == "" ) {
			return;
		}

		preg_match( "/^(\d+):(\d+)$/", $value, $match );
		if ( count( $match ) == 0 ) {
			$orgInput = $value;
			$value = array();
			$value["time"]  = $orgInput;
			return;
		}

		$value = array();
		$value["hour"]   = $match[1];
		$value["min"]    = $match[2];
		$value["minute"] = $match[2];
		$value["time"]   = sprintf( "%d:%02d", $value["hour"], $value["minute"] );

	}

	/* -------------------------------------
		CHECK: validDate
	------------------------------------- */
	function CHECK_validDate ( &$value, $key="", $arg="" ) {

		if ( $value == "" || count( $value ) == 0 ) {
			return;
		}

		preg_match( "/^(\d+)[-\.\/ ](\d+)[-\.\/ ](\d+)$/", $value, $match );
		$year   = $match[1];
		$mon    = $match[2];
		$month  = $match[2];
		$day    = $match[3];

		if ( @checkdate( $month, $day, $year ) === FALSE ) {
				return 1;
		}
		return;

	}

	/* -------------------------------------
		CHECK: validTime
	------------------------------------- */
	function CHECK_validTime ( &$value, $key="", $arg="" ) {

		if ( $value["hour"] >= 0
			&& $value["hour"] <= 23
			&& $value["min"] >= 0
			&& $value["min"] <= 59 ) {
			return;
		}
		else {
			return 1;
		}


	}

	/* -------------------------------------
		CONVERT: dateRange
		期間の開始日と終了日が逆なら入れ替える
	------------------------------------- */
	function CONVERT_dateRange ( &$value, $key="", $arg="" ) {

		preg_match( "/^(\d+)[-\.\/ ](\d+)[-\.\/ ](\d+)$/", $value["dateFrom"], $match );
		if ( count( $match ) == 0 ) {
			return;
		}

		preg_match( "/^(\d+)[-\.\/ ](\d+)[-\.\/ ](\d+)$/", $value["dateTo"], $match );
		if ( count( $match ) == 0 ) {
			return;
		}

		if ( $value["dateFrom"] > $value["dateTo"] ) {
			list( $value["dateFrom"], $value["dateTo"] ) = array( $value["dateTo"], $value["dateFrom"] );
		}

	}

	/* -------------------------------------
		CHECK: dateFormat
	------------------------------------- */
	function CHECK_dateFormat ( &$value, $key="", $arg="" ) {

		if ( $value == "" ) {
			return;
		}

		preg_match( "/^(\d+)[-\.\/ ](\d+)[-\.\/ ](\d+)$/", $value, $match );
		if ( count( $match ) == 0 ) {
			return 1;
		}

	}

	/* -------------------------------------
		CHECK: timeFormat
	------------------------------------- */
	function CHECK_timeFormat ( &$value, $key="", $arg="" ) {

		if ( $value["time"] == "" ) {
			return;
		}
		preg_match( "/^(\d+):(\d+)$/", $value["time"], $match );

		if ( count( $match ) == 0 ) {
			return 1;
		}

	}














	/* ==================================================================

	        F I L T E R

	================================================================== */

	/*----------------------------------------------------
	    FILTER : length_cut
	----------------------------------------------------*/
	function FILTER_length_cut ( &$value, $key="", $arg="" ) {

		if ( !is_array ( $value ) ) {
			if ( mb_strlen ( $value ) > $arg[0] ) {
				$value = mb_substr( $value, 0, $arg[0] );
				return 1;
			}
		}

	}

	/*----------------------------------------------------
	    FILTER : numeric
	----------------------------------------------------*/
	function FILTER_numeric ( &$value, $key="", $arg="" ) {

		if ( is_array ( $value ) ) {
			foreach ( $value as $key => $val ) {
				$num = vsprintf ( "%d", $val );
				if ( $num != $val ) {
					$val = NULL;
					return 1;
				}
			}
		}
		else {
			$num = @vsprintf ( "%d", $value );
			if ( $num != $value ) {
				$value = NULL;
				return 1;
			}
		}
	}


	/* ==================================================================

	        C H E C K E R

	================================================================== */

	/*----------------------------------------------------
	    CHECK : must
	----------------------------------------------------*/
	function CHECK_must ( &$value, $key="", $arg="" ) {

		if ( $value == "" || empty ( $value ) ) {
			return 1;
		}

		if ( is_array ( $value ) && is_array ( $value[0] ) ) {
			foreach ( $value[0] as $v ) {
				if ( $v != "" ) {
					return 0;
				}
			}
			return 1;
		}

	}

	/*----------------------------------------------------
	    CHECK : CHECK_mustCombine_OnOff
	----------------------------------------------------*/
	function CHECK_mustCombine_OnOff ( &$value, $key="", $arg="" ) {

		if ( ( $arg[0] != "" || !empty ( $arg[0] ) ) &&
         ( $arg[1] == "" ||  empty ( $arg[1] ) ) &&
         ( $value  == "" ||  empty ( $value  ) ) )
		{
			return 1;
		}

	}

	/*----------------------------------------------------
	    CHECK : CHECK_mustBothOnOrOff
	----------------------------------------------------*/
	function CHECK_mustBothOnOrOff ( &$value, $key="", $arg="" ) {

		if (
		     ( $arg[0] != "" || !empty ( $arg[0] ) ) && ( $value  == "" ||  empty ( $value  ) )
		     ||
		     ( $arg[0] == "" || empty ( $arg[0] ) ) && ( $value  != "" ||  !empty ( $value  ) )
		   )
		{
			return 1;
		}

	}

	/*----------------------------------------------------
	    CHECK : CHECK_mustEqual
	----------------------------------------------------*/
	function CHECK_mustEqual ( &$value, $key="", $arg="" ) {

		if ( $arg[0] == $arg[1] && $value == "" ) { return 1; }

	}

	/*----------------------------------------------------
	    CHECK : length
	----------------------------------------------------*/
	function CHECK_length ( &$value, $key="", $arg="" ) {

		list ( $min, $max ) = explode ( "-", $arg[0] );

		if ( $min > 0 && mb_strlen ( $value ) < $min ) {
			return 1;
		}

		if ( $max > 0 && mb_strlen ( $value ) > $max ) {
			return 1;
		}

	}

	/*----------------------------------------------------
	    CHECK : lengthUtf8
	----------------------------------------------------*/
	function CHECK_lengthUtf8 ( &$value, $key="", $arg="" ) {

		list ( $min, $max ) = explode ( "-", $arg[0] );

		if ( $min > 0 && mb_strlen ( $value, "utf-8" ) < $min ) {
			return 1;
		}

		if ( $max > 0 && mb_strlen ( $value, "utf-8" ) > $max ) {
			return 1;
		}

	}

	/*----------------------------------------------------
	    CHECK : equal
	----------------------------------------------------*/
	function CHECK_equal ( &$value, $key="", $arg="" ) {

		if ( $value == "" ) { return; }

		if ( is_array ( $value ) ) {
			foreach ( $value as $valVal ) {
				foreach ( $arg as $argVal ) {
					if ( $argVal == $valVal ) {
						$hitFlg = 1;
					}
				}
			}
			if ( $hitFlg != 1 ) {
				return 1;
			}
		}

		else if ( is_array ( $arg ) ) {
			foreach ( $arg as $argVal ) {
				if ( $argVal == $value ) {
					$hitFlg = 1;
				}
			}
			if ( $hitFlg != 1 ) {
				return 1;
			}
		}

	}

	/*----------------------------------------------------
	    CHECK : alpha_num
	----------------------------------------------------*/
	function CHECK_alpha_num ( &$value, $key="", $arg="" ) {

		if ( !preg_match ( "/^[a-zA-Z0-9_\-. ]*$/", $value ) ) {
			return 1;
		}

	}

	/*----------------------------------------------------
	    CHECK : alpha_num_att
	----------------------------------------------------*/
	function CHECK_alpha_num_att ( &$value, $key="", $arg="" ) {

		if ( !preg_match ( "/^[a-zA-Z0-9\-.@]*$/", $value ) ) {
			return 1;
		}

	}

	/*----------------------------------------------------
	    CHECK : empty
	----------------------------------------------------*/
	function CHECK_empty ( &$value, $key="", $arg="" ) {

		if ( is_array ( $value ) ) {
			foreach ( $value as $key => $val ) {
				if ( $val != "" ) {
					return 0;
				}
			}

			return 1;

		}

	}

	/*----------------------------------------------------
	    CHECK : arg0
	----------------------------------------------------*/
	function CHECK_arg0 ( &$value, $key="", $arg="" ) {

		if ( is_array ( $arg ) ) {
			foreach ( $arg as $key => $val ) {
				if ( $val != "" ) {
					return 0;
				}
			}

			return 1;

		}

	}

	/*----------------------------------------------------
	    CHECK : arg1_val0
	----------------------------------------------------*/
	function CHECK_arg1_val0 ( &$value, $key="", $arg="" ) {

		if ( $value == "" && $arg[0] != "" ) {
			return 1;
		}

	}

	/*----------------------------------------------------
	    CHECK : is_numeric
	----------------------------------------------------*/
	function CHECK_is_numeric ( &$value, $key="", $arg="" ) {

		if ( $value == "" || is_numeric ( $value ) ) {
			if ( is_numeric ( $arg[0] ) && $value < $arg[0] ) {
				return 1;
			}
			if ( is_numeric ( $arg[1] ) && $value > $arg[1] ) {
				return 1;
			}
			if ( is_numeric ( $arg[0] ) && is_numeric ( $arg[1] ) &&
			     ( $value < $arg[0] || $value > $arg[1] ) ) {
				return 1;
			}
		}
		else {
			return 1;
		}

	}

	/*----------------------------------------------------
	    CHECK : number
	----------------------------------------------------*/
	function CHECK_number ( &$value, $key="", $arg="" ) {

		if ( is_numeric ( $arg[0] ) ) {
			if ( $value < $arg[0] ) {
				return 1;
			}
		}
		if ( is_numeric ( $arg[1] ) ) {
			if ( $value > $arg[1] ) {
				return 1;
			}
		}

	}

	/* -----------------------------------------------------
		CHECK : atLeastOneEntry
	----------------------------------------------------- */
	function CHECK_atLeastOneEntry ( &$value, $key="", $arg="" ) {

		if ( count( $value ) == 0 ) {
			return 1;
		}

	}

	/* -----------------------------------------------------
		CHECK : byteLength
	----------------------------------------------------- */
	function CHECK_byteLength ( &$value, $key="", $arg="" ) {

		list ( $min, $max ) = explode ( "-", $arg[0] );
		if ( $min > 0 && strlen ( $value ) < $min ) {
			return 1;
		}
		if ( $max > 0 && strlen ( $value ) > $max ) {
			return 1;
		}

	}

	/*----------------------------------------------------
	    CHECK : kanaType
	----------------------------------------------------*/
	function CHECK_kanaType ( &$value, $key="", $arg="" ) {

		$han_pattan = "ｱ-ﾝﾞﾟ";
		$zen_pattan = "ア-ン";

		switch( $arg[0] ) {
			case "k": $pattan = $han_pattan; break;
			case "K": $pattan = $zen_pattan; break;
			default : $pattan = $han_pattan . $zen_pattan;
		}

		$regex = ".*[^$pattan]+";

		if( mb_ereg_match( $regex, $value )) {
			return 1;
		}

	}

	/*----------------------------------------------------
	    CHECK : dateType
	----------------------------------------------------*/
	function CHECK_dateType ( &$value, $key="", $arg="" ) {

		$year  = $value["year"];
		$month = $value["month"];
		$day   = $value["day"];

		// 未入力はチェック対象外
		if( $year == "" && $month == "" && $day == "" ) {
			return;
		}

		// 桁数のチェック
		if( strlen( $year ) != 4 ) {
			return 1;
		}

		if( !@checkdate( $month, $day, $year ) ) {
			return 1;
		}

	}

	/*----------------------------------------------------
	    CHECK : url
	----------------------------------------------------*/
	function CHECK_url ( $value, $key="", $arg="" ) {

		if( $value == "" ) {
			return 0;
		}

		if( !preg_match( '/^(https?|ftp)(:\/\/[-_.!~*\'()a-zA-Z0-9;\/?:\@&=+\$,%#]+)$/', $value ) ) {
				return 1;
		}

	}







?>