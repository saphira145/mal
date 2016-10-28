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

	/*----------------------------------------------------
	    CHECK : searchCount
	----------------------------------------------------*/
	function CHECK_searchCount ( &$value, $key="", $arg="" ) {

		global $class, $input;

		$input["downloadInfo"]["from"]["date"] = $arg[0];
		$input["downloadInfo"]["to"]["date"]   = $arg[1];
		$outputType                            = $arg[2];

		if( $outputType == "" || $input["errSetFlag"] == 1 ) {
			return NULL;
		}

		// 車種別集計
		if( $outputType == 1 ) {
			$list = $class["csvDownload_1"]->get_modelSummaryList( $input );
		}

		// グレード別集計
		if( $outputType == 2 ) {
			$list = $class["csvDownload_1"]->get_searchList( $input );
		}

		// 集計元データがなければエラー
		if( count( $list ) == 0 ) {
			return 1;
		}

	}




?>