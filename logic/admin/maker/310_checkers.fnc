<?php


	/* ==================================================================

	        C O N V E R T E R

	================================================================== */




	/* ==================================================================

	        F I L T E R

	================================================================== */




	/* ==================================================================

	        C H E C K E R

	================================================================== */

	/* -------------------------------------
	  CHECK: argEqualMustURI_unreservedChars_and_space
	------------------------------------- */
	function CHECK_argEqualMustURI_unreservedChars_and_space ( &$value, $key="", $arg="" ) {

		$makerCode  = $arg[0];
		$targetID   = $arg[1];

		if( $targetID != $makerCode ) {
			return NULL;
		}

		// URLのチェック
		if ( preg_match( "/[^0-9a-zA-Z\-\.\_~ ]/", $value ) ) {
			return 1;
		}


	}


	/* -------------------------------------
	  CHECK: URI_unreservedChars_and_space

	    RFC3986 の unreserved
	    - 数字
	    - 英字
	    - ハイフン(-)
	    - ドット(.)
	    - アンダースコア(_)
	    - チルダ(~)

	    空白
	------------------------------------- */
	function CHECK_URI_unreservedChars_and_space ( &$value, $key="", $arg="" ) {

		if ( preg_match( "/[^0-9a-zA-Z\-\.\_~ ]/", $value ) ) {
			return 1;
		}

	}










?>