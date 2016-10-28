<?php


	/*----------------------------------------------------
	    有無存在チェック
	----------------------------------------------------*/
	function CSV2DB_commonType ( $value ) {

		global $ini;

		for( $i=0; $i<count( $ini["commonType"] ); $i++ ) {
			if( $ini["commonType"][$i]["name"] == $value ) {
				return $ini["commonType"][$i]["value"];
			}
		}

		return NULL;
	}



	/*----------------------------------------------------
	    注目存在チェック
	----------------------------------------------------*/
	function CSV2DB_commonSpot ( $value ) {

		global $ini;

		for( $i=0; $i<count( $ini["commonSpot"] ); $i++ ) {
			if( $ini["commonSpot"][$i]["name"] == $value ) {
				return $ini["commonSpot"][$i]["value"];
			}
		}

		return NULL;
	}














?>