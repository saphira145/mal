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
	    CHECK : overlap
	----------------------------------------------------*/
	function CHECK_overlap ( $value, $key="", $arg="" ) {

		if( empty($value)){
			return;
		}

		global $tmpCampaignDispNumArr;

		// 重複チェック
		if( count($tmpCampaignDispNumArr) > 0 && in_array( $value ,$tmpCampaignDispNumArr) ){
			return 1;
		}

		$tmpCampaignDispNumArr[] = $value;
	}
	
	
	/*----------------------------------------------------
	    CHECK : is_number
	----------------------------------------------------*/
	function CHECK_is_number ( $value, $key="", $arg="" ) {

		if ( !preg_match ( "/^[1-9]*$/", $value ) ) {
			return 1;
		}

	}

	/*----------------------------------------------------
	    CHECK : campaignMust
	----------------------------------------------------*/
	function CHECK_campaignMust ( &$value, $key="", $arg="" ) {

		if( empty($value)){
			for( $i = 0, $iMax = count($arg); $i < $iMax; $i++ ){
				if( !empty($arg[$i]) ){
					return 1;
				}
			}
		}
	}

	/*----------------------------------------------------
	    CHECK : campaignPhotoExtension
	----------------------------------------------------*/
	function CHECK_campaignPhotoExtension ( &$value, $key="", $arg="" ) {

		global $ini;
		$extensionList = $ini["campaign"]["extension"];

		$fileName = $value["name"];

		if( $fileName == "" ) {
			return;
		}

		// 拡張子を取り出す
		$result = explode( ".", $fileName );
		$extension = array_pop( $result );

		// 小文字に変換
		$extension = strtolower( $extension );

		for( $i=0; $i<count( $extensionList ); $i++ ) {
			$extensions = explode( ",", $extensionList[$i]["type"] );
			for( $j=0; $j<count( $extensions ); $j++ ) {
				if( $extensions[$j] == $extension ) {
					return;
				}
			}
		}

		return 1;
	}



	/*----------------------------------------------------
	    CHECK : campaignPhotoSize
	----------------------------------------------------*/
	function CHECK_campaignPhotoSize ( &$value, $key="", $arg="" ) {

		global $ini;

		$fineName = $value["name"];
		$size     = $value["size"];

		// 未入力時はチェックしない
		if( $fineName == "" ) {
			return;
		}

		if( $size > $ini["campaign"]["photoMaxSize"] || $size == 0 ) {
			return 1;
		}

	}


	/*----------------------------------------------------
	    CHECK : onlyCampaignPhoto
	----------------------------------------------------*/
	function CHECK_onlyCampaignPhoto ( &$value, $key="", $arg="" ) {

		$name        = $arg[0];
		$url         = $arg[1];
		$dispNum     = $arg[2];
		$deletePhoto = $arg[3];
		$inputPhoto  = $arg[4];
		$photoName   = $value["name"];

		// 全て未入力


		if( empty($name) && empty($url) && empty($dispNum) && empty($photoName) && empty($deletePhoto) && empty($inputPhoto) ){
			return;
		}

		if( empty($name) && empty($url) && empty($dispNum) ){
			if( !empty($photoName) ){
				return 1;
				
			} else if ( empty($deletePhoto) && !empty($inputPhoto)  ){
				return 1;
			}
			
		}
	}
?>