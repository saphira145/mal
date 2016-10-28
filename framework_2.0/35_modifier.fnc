<?php


	/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*

	      テンプレート MODIFIER

	*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

	/*----------------------------------------------------
	  ゼロサプレス
	----------------------------------------------------*/
	function MODIFIER_zeroSuppress ( $value, $param=NULL ) {

		return (int)$value;
	}


	/*----------------------------------------------------
	  htmlspecialchars
	----------------------------------------------------*/
	function MODIFIER_htmlspecialchars ( $value, $param=NULL ) {

		return htmlspecialchars( $value );
	}


	/*----------------------------------------------------
	  nl2br
	----------------------------------------------------*/
	function MODIFIER_nl2br ( $value, $param=NULL ) {

		return nl2br( $value );
	}


	/*----------------------------------------------------
	  number_format
	----------------------------------------------------*/
	function MODIFIER_number_format ( $value, $param=NULL ) {

		// 数値以外はそのまま
		if( !is_numeric( $value ) ) {
			return $value;
		}

		$decimals = sprintf( "%d", $param[0] );

		return number_format( $value, $decimals );
	}


	/*----------------------------------------------------
		数字を指定された桁数にする
	----------------------------------------------------*/
	function MODIFIER_zeroPadding( $value, $param=NULL ){

		// 数値以外はそのまま
		if( !is_numeric( $value ) ) {
			return $value;
		}

		$digit = $param[0];

		$ret = sprintf( "%0{$digit}d", $value );

		return $ret;

	}


	/*----------------------------------------------------
	  コメント
	----------------------------------------------------*/
	function MODIFIER_dispComment ( $value, $param=NULL ) {

		$value  = htmlspecialchars( $value );
		$value  = nl2br( $value );

		return $value;
	}


	/*----------------------------------------------------
		文字列を指定された桁数で折り返す
	----------------------------------------------------*/
	function MODIFIER_addWbr ( $value, $param=NULL ){

		if ( $value == "" ){
			return;
		}

		$cutLen = $param[0];

		$ret = "";

		$value = htmlspecialchars( $value );

		if ( $value != "" && $cutLen != "" ){
			$total_digit = mb_strlen( $value );
			$count = $total_digit/$cutLen;
			for( $i=0; $i<$count-1; $i++ ){
				$ret .= mb_substr($value, $i * $cutLen, $cutLen);
				$ret .= "<wbr>";
			}
			$ret .= mb_substr($value, $i * $cutLen, $cutLen);
		}
		else{
			$ret = $value;
		}

		$ret = nl2br( $ret );

		return $ret;
	}


	/*----------------------------------------------------
		文字列を指定された桁数で切る
	----------------------------------------------------*/
	function MODIFIER_lengthCut ( $value, $param=NULL ){

		if ( $value == "" ) {
			return NULL;
		}

		if ( is_array( $param ) ){
			if ( mb_strlen ( $value ) > $param[0] ) {
				$ret = mb_substr( $value, 0, $param[0] );
				return $ret . "...";
			}
		}
		else{
			if ( mb_strlen ( $value ) > $param ) {
				$ret = mb_substr( $value, 0, $param );
				return $ret . "...";
			}
		}

		return $value;
	}


	/*----------------------------------------------------
		文字列を指定された行数で切る
	----------------------------------------------------*/
	function MODIFIER_sentence ( $value, $param=NULL ){

		if ( $value == "" ) {
			return NULL;
		}

		unset ( $sent );
		$sentence = preg_split ( "#<br( /)?>|\n#", $value );

		for ( $i = 0; $i < count ( $sentence ); $i++ ) {
			if ( $sentence[$i] != "" && !preg_match ( "#^\n#", $sentence[$i] ) ) {
				$sent[] = $sentence[$i];
			}
		}

		if ( count ( $sent ) > 0 ) {
			$arr = @array_chunk ( $sent, $param );
			$value = @join ( "<br />", $arr[0] );
		}
		else {
			$value = "";
		}

		return $value;
	}


	/*----------------------------------------------------
		時刻変換（HH:MM:SS=>HH:MM）
	----------------------------------------------------*/
	function MODIFIER_timeHMM ( $value, $param=NULL ){

		global $ini;

		$times = explode( ":", $value );
		$ret = $times[0] . ":" . $times[1];

		return $ret;
	}


	/*----------------------------------------------------
	  時刻（分）の表示形式
	----------------------------------------------------*/
	function MODIFIER_dispMin ( $value, $param=NULL ) {

		$ret = sprintf( "%02d", $value );

		return $ret;
	}


	/* -------------------------------------
	  htmlEntityDecode
	  HTML タグを有効にする
	------------------------------------- */
	function MODIFIER_htmlEntityDecode ( $value, $param=NULL ) {

		$ret = html_entity_decode( $value, ENT_QUOTES );
		return $ret;

	}


	/* -------------------------------------
	  stripTags
	  HTML・PHP タグを除去する
	------------------------------------- */
	function MODIFIER_stripTags ( $value, $param=NULL ) {

		$ret = strip_tags( $value );
		return $ret;

	}












?>