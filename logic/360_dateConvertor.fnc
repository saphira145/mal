<?php

	// ### Version Data ### parts_convertor.fnc 1.00.00

	/*----------------------------------------------------
	  データ型変換のパーツ群
	----------------------------------------------------*/


	/*=============================================================================
		 DB => VAL
	==============================================================================*/

	/*----------------------------------------------------
		日付変換 DB -> VAL
	----------------------------------------------------*/
	function db2val_dateType1( $input ) {

		if ( $input != "" && $input != "0000-00-00" ) {
			list( $year, $month, $day ) = explode( "-", $input );

			// ゼロサプレス
			$ret["year"]   = sprintf( "%d", $year );
			$ret["month"]  = sprintf( "%d", $month );
			$ret["day"]    = sprintf( "%d", $day );
			$ret["date"]   = sprintf( "%d/%d/%d", $year, $month, $day );
			$ret["month_zero"]  = sprintf( "%02d", $month );
			$ret["day_zero"]    = sprintf( "%02d", $day );
		}
		else {
			$ret["year"]   = "";
			$ret["month"]  = "";
			$ret["day"]    = "";
			$ret["date"]   = "";
		}

		return $ret;

	}



	/*----------------------------------------------------
		日時変換 DB -> VAL
	----------------------------------------------------*/
	function db2val_datetimeType1( $input ) {

		if ( $input != "" && $input != "0000-00-00 00:00:00" ) {
			list( $date, $time ) = explode( " ", $input );
			list( $year, $month, $day ) = explode( "-", trim( $date ) );
			list( $hour, $min,   $sec ) = explode( ":", trim( $time ) );

			// ゼロサプレス
			$ret["year"]          = sprintf( "%d", $year );
			$ret["month"]         = sprintf( "%d", $month );
			$ret["day"]           = sprintf( "%d", $day );
			$ret["hour"]          = sprintf( "%d", $hour );
			$ret["min"]           = sprintf( "%d", $min );
			$ret["sec"]           = sprintf( "%d", $sec );
			$ret["date"]          = sprintf( "%d/%d/%d", $year, $month, $day );
			$ret["time"]          = sprintf( "%d:%d:%d", $hour, $min,   $sec );
			$ret["time_notSec"]   = sprintf( "%d:%d",    $hour, $min );
			$ret["month_zero"]    = sprintf( "%02d", $month );
			$ret["day_zero"]      = sprintf( "%02d", $day );
			$ret["hour_zero"]     = sprintf( "%02d", $hour );
			$ret["min_zero"]      = sprintf( "%02d", $min );
		}
		else {
			$ret["year"]          = "";
			$ret["month"]         = "";
			$ret["day"]           = "";
			$ret["hour"]          = "";
			$ret["min"]           = "";
			$ret["sec"]           = "";
			$ret["date"]          = "";
			$ret["time"]          = "";
			$ret["time_notSec"]   = "";
		}

		return $ret;

	}









	/*=============================================================================
		 VAL => DB
	==============================================================================*/


	/*----------------------------------------------------
		年月変換 VAL -> DB
	----------------------------------------------------*/
	function val2db_dateType1( $input ) {

		if( $input["date"] != "" ) {
			list( $year, $month, $day ) = explode( "/", $input["date"] );
		}
		else{
			$year  = $input["year"];
			$month = $input["month"];
			$day   = $input["day"];
		}

		$ret = sprintf( "%04d-%02d-%02d", $year, $month, $day );


		return $ret;
	}






?>