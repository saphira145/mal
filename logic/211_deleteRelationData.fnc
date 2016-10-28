<?php


	/*=============================================================================
		 メーカーの削除
	==============================================================================*/

	/*----------------------------------------------------
		車種情報と関連データ削除
		削除対象データ
		 ・メーカー情報
		 ・車種情報
		 ・車種グレード
		 ・視界
		 ・運転席周り
		 ・空調
		 ・オーディオ
		 ・シート・内装
		 ・外装
		 ・足回り
		 ・安全
		 ・備考
		 ・車体画像
		 ・ロゴ画像
	----------------------------------------------------*/
	function delete_makerInfoAndRelationData ( $makerCode ) {

		// 車種に紐づく車種グレードＩＤ取得
		$modelList = (array)get_relationModelCode( $makerCode );

		for( $i=0; $i<count( $modelList ); $i++ ) {
			// 車種情報と関連情報削除
			delete_modelInfoAndRelationData( $makerCode, $modelList[$i]["modelCode"] );
		}

		/**
		 * 2014-02-07 追加
		 * バリュー情報削除
		 */
		delete_carTheme($makerCode);

		// メーカー情報削除
		delete_makerInfo( $makerCode );

	}



	/*----------------------------------------------------
		メーカーに紐づく車種コード取得
	----------------------------------------------------*/
	function get_relationModelCode ( $makerCode ) {

		if( $makerCode == ""
		 || $makerCode == 0 ) {
			return NULL;
		}

		// ＤＢ名取得
		$DBName = get_DBName( "work" );

		// SQLインジェクション対応
		$sql_escape["makerCode"] = sql_escapeString($makerCode);

		$sql = "SELECT makerCode, modelCode FROM {$DBName}.model WHERE makerCode = '{$sql_escape["makerCode"]}'";
		$list = sql_query( $sql );

		return $list;
	}



	/*----------------------------------------------------
		車種情報削除
	----------------------------------------------------*/
	function delete_makerInfo ( $makerCode ) {

		if( $makerCode == ""
		 || $makerCode == 0 ) {
			return NULL;
		}

		// ＤＢ名取得
		$DBName = get_DBName( "work" );

		// SQLインジェクション対応
		$sql_escape["makerCode"] = sql_escapeString($makerCode);

		// メーカー情報
		$sql = "DELETE FROM {$DBName}.maker WHERE  makerCode = '{$sql_escape["makerCode"]}'";
		sql_query( $sql );
	}
















	/*=============================================================================
		 車種の削除
	==============================================================================*/

	/*----------------------------------------------------
		車種情報と関連データ削除
		削除対象データ
		 ・車種情報
		 ・車種グレード
		 ・視界
		 ・運転席周り
		 ・空調
		 ・オーディオ
		 ・シート・内装
		 ・外装
		 ・足回り
		 ・安全
		 ・備考
		 ・車体画像
		 ・ロゴ画像
	----------------------------------------------------*/
	function delete_modelInfoAndRelationData ( $makerCode, $modelCode ) {

		global $ini;

		// 車種に紐づく車種グレードＩＤ取得
		$carGradeIDList = (array)get_relationCarGradeID( $makerCode, $modelCode );

		for( $i=0; $i<count( $carGradeIDList ); $i++ ) {

			// スペック（車種グレードなど）削除
			delete_relationSpec( $carGradeIDList[$i]["carGradeID"] );

			// グレード画像削除
			delete_relationGradePhoto( $makerCode, $modelCode, $carGradeIDList[$i]["carGradeID"] );

		}

		// 画像削除
		delete_relationPhoto( $makerCode, $modelCode );

		// 車種情報削除
		delete_ModelInfo( $makerCode, $modelCode );

		return $ret;

	}



	/*----------------------------------------------------
		車種に紐づく車種グレードＩＤ取得
	----------------------------------------------------*/
	function get_relationCarGradeID ( $makerCode, $modelCode ) {

		if( $makerCode == ""
		 || $makerCode == 0
		 || $modelCode == ""
		 || $modelCode == 0 ) {
			return NULL;
		}


		// ＤＢ名取得
		$DBName = get_DBName( "work" );

		// SQLインジェクション対応
		$sql_escape["makerCode"] = sql_escapeString($makerCode);
		$sql_escape["modelCode"] = sql_escapeString($modelCode);

		$sql = "SELECT carGradeID FROM {$DBName}.carGrade WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
		$list = sql_query( $sql );

		return $list;
	}



	/*----------------------------------------------------
		スペック（車種グレードなど）削除
	----------------------------------------------------*/
	function delete_relationSpec ( $carGradeID ) {

		if( $carGradeID == ""
		 || $carGradeID == 0 ) {
			return NULL;
		}

		// ＤＢ名取得
		$DBName = get_DBName( "work" );

		// SQLインジェクション対応
		$sql_escape["carGradeID"] = sql_escapeString($carGradeID);

		// 車種グレード
		$sql = "DELETE FROM {$DBName}.carGrade WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
		sql_query( $sql );

		// 視界
		$sql = "DELETE FROM {$DBName}.view WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
		sql_query( $sql );

		// 運転席周り
		$sql = "DELETE FROM {$DBName}.seatCircumference WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
		sql_query( $sql );

		// 空調
		$sql = "DELETE FROM {$DBName}.airConditioning WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
		sql_query( $sql );

		// オーディオ
		$sql = "DELETE FROM {$DBName}.audio WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
		sql_query( $sql );

		// シート内装関係
		$sql = "DELETE FROM {$DBName}.seatInterior WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
		sql_query( $sql );

		// 外装
		$sql = "DELETE FROM {$DBName}.exterior WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
		sql_query( $sql );

		// 足回り
		$sql = "DELETE FROM {$DBName}.footSurroundings WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
		sql_query( $sql );

		// 安全
		$sql = "DELETE FROM {$DBName}.safety WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
		sql_query( $sql );
	}



	/*----------------------------------------------------
		画像削除
	----------------------------------------------------*/
	function delete_relationPhoto ( $makerCode, $modelCode ) {

		global $path;

		if( $makerCode == ""
		 || $makerCode == 0
		 || $modelCode == ""
		 || $modelCode == 0 ) {
			return NULL;
		}

		// ファイル名取得
		$fileName = get_photoFileName( $makerCode, $modelCode );

		// 画像削除
		delete_photoFile( $fileName );

	}



	/*----------------------------------------------------
		グレード画像削除
	----------------------------------------------------*/
	function delete_relationGradePhoto ( $makerCode, $modelCode, $carGradeID ) {

		global $path;

		if( $makerCode  == ""
		 || $makerCode  == 0
		 || $modelCode  == ""
		 || $modelCode  == 0
		 || $carGradeID == ""
		 || $carGradeID == 0 ) {
			return NULL;
		}

		// ファイル名取得
		$fileName = get_photoGradeFileName( $makerCode, $modelCode, $carGradeID );

		// 画像削除
		delete_photoFile( $fileName );

	}



	/*----------------------------------------------------
		削除実行
	----------------------------------------------------*/
	function delete_photoFile ( $fileName ) {

		global $path;

		// 車体画像ディレクトリ（ＷＯＲＫ）
		$carBodyFile1 = $path["modelPhoto"]["WORK"]["carBody"] . "/$fileName.jpg";

		// 車体画像削除
		if( file_exists( $carBodyFile1 ) ) {
			@unlink( $carBodyFile1 );
		}

		// 車体画像ディレクトリ（ＷＯＲＫ）
		$carBodyFile2 = $path["modelPhoto"]["WORK"]["carBody"] . "/s_$fileName.jpg";

		// 車体画像削除
		if( file_exists( $carBodyFile2 ) ) {
			@unlink( $carBodyFile2 );
		}
	}



	/*----------------------------------------------------
		車種情報削除
	----------------------------------------------------*/
	function delete_ModelInfo ( $makerCode, $modelCode ) {

		if( $makerCode == ""
		 || $makerCode == 0
		 || $modelCode == ""
		 || $modelCode == 0 ) {
			return NULL;
		}

		// ＤＢ名取得
		$DBName = get_DBName( "work" );

		// SQLインジェクション対応
		$sql_escape["makerCode"] = sql_escapeString($makerCode);
		$sql_escape["modelCode"] = sql_escapeString($modelCode);

		// 車種情報
		$sql = "DELETE FROM {$DBName}.model WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
		sql_query( $sql );


	}



	/**
	 * バリュー(テーマ)情報削除
	 *
	 * @param int $makerCode メーカーコード
	 * @return NULL
	 * @version 20140207
	 */
	function delete_carTheme($makerCode) {
		if ($makerCode == '' || $makerCode == 0) {
			return NULL;
		}
		// DB名取得
		$DBName = get_DBName('work');

		// SQLインジェクション対応
		$sql_escape["makerCode"] = sql_escapeString($makerCode);

		// 削除実行
		$sql = "DELETE FROM {$DBName}.model WHERE makerCode = '{$sql_escape["makerCode"]}'";
		sql_query($sql);
	}



?>