<?php


	class campaignAdmin_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function campaignAdmin_1 () {

		}


		/*----------------------------------------------------
		    更新
		----------------------------------------------------*/
		function update_DB ( $input ) {
			global $class;

			if ( $input["campaignInfo"]["campaignNum"] == ""){
				return;
			}

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// SQLインジェクション対応
			$sql_escape["campaignNum"] = sql_escapeString($input["campaignInfo"]["campaignNum"]);

			// 既に登録されているか？
			$sql = "SELECT campaignNum FROM {$DBName}.campaign WHERE campaignNum = '{$sql_escape["campaignNum"]}'";
			$tbl = sql_query( $sql, "single" );

			$DBInfo["campaignName"]          = $input["campaignInfo"]["campaignName"];
			$DBInfo["campaignURL"]           = $input["campaignInfo"]["campaignURL"];
			$DBInfo["dispNum"]               = $input["campaignInfo"]["dispNum"];
			$DBInfo["updateDatetime"]["com"] = "now()";
			$DBInfo["updateMemberID"]        = $class["session"]->memberID;

			// 更新
			if( $tbl["campaignNum"] > 0 ) {
				$sql = "UPDATE {$DBName}.campaign SET {update_set} WHERE campaignNum = '{$sql_escape["campaignNum"]}'";
			}
			// 登録
			else{
				$DBInfo["campaignNum"]          = $input["campaignInfo"]["campaignNum"];
				$sql = "INSERT INTO {$DBName}.campaign {insert_value}";
			}

			sql_query( $sql, $DBInfo, "1" );

		}


		/*----------------------------------------------------
		   リスト取得
		----------------------------------------------------*/
		function get_list ( $lixtCnt=3 ) {

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// SQLインジェクション対応
			$sql_escape["lixtCnt"] = sql_escapeString($lixtCnt);

			$sql = "SELECT * FROM {$DBName}.campaign ORDER BY campaignNum LIMIT {$sql_escape["lixtCnt"]}";
			$list = (array)sql_query( $sql );

			return $list;
		}


		/*----------------------------------------------------
		  一時画像を保存（キャンペーン画像）
		----------------------------------------------------*/
		function save_tempCampaignyPhoto ( $orgFile, $tempFileName ) {

			global $class, $path, $ini;

			// 一時画像
			$dstFullPath = $path["campaignPhoto"]["tmpDir"] . "/$tempFileName";

			// 一時画像を保存実行
			$this->copy_tempPhoto( $orgFile, $dstFullPath );
		}

		/*----------------------------------------------------
		  一時画像を保存実行
		----------------------------------------------------*/
		function copy_tempPhoto ( $tmpFileName, $newTempFilePath ) {

			if( !is_uploaded_file( $tmpFileName )){
				return NULL;
			}

			// ファイルのアップロード
			if( !copy( $tmpFileName, $newTempFilePath ) ) {
				echo "コピー失敗<br>\n";
			}

		}


		/*----------------------------------------------------
		  画像を本番へ移動
		----------------------------------------------------*/
		function move_campaignPhoto ( $orgFile, $campaignNum ) {

			global $path, $ini;

			// 拡張子を取り出す
			$result = explode( ".", $orgFile );
			$extension = array_pop( $result );

			// 小文字に変換
			$extension = strtolower( $extension );

			// ファイル名取得
			$newFileName = get_campaignPhotoFileName( $campaignNum ) . "." . $extension;

			// ファイル移動
			$this->move_photo( $orgFile, $newFileName );

		}

		/*----------------------------------------------------
		  ファイル移動
		----------------------------------------------------*/
		function move_photo ( $orgFile, $newFileName ) {

			global $path, $ini;

			// 画像を移動
			$orgFullPath = $path["campaignPhoto"]["tmpDir"] . "/$orgFile";
			$dstFullPath = $path["campaignPhoto"]["campaign"] . "/$newFileName";
			@rename( $orgFullPath, $dstFullPath );

			// 元画像削除
			if( file_exists( $orgFilePath ) ) {
				@unlink( $orgFilePath );
			}

		}

		/*----------------------------------------------------
		  画像削除
		----------------------------------------------------*/
		function delete_campaignPhoto ( $campaignNum ) {

			global $path;

			if( !isset($campaignNum) ) {
				return false;
			}

			for( $i = 0, $iMax = count($path["campaignPhoto"]["extension"]); $i < $iMax; $i++){
				// ファイル名取得
				$newFileName = get_campaignPhotoFileName( $campaignNum ) . $path["campaignPhoto"]["extension"][$i];

				// 削除実行
				$this->delete_photo( $newFileName );
			}
		}

		/*----------------------------------------------------
		  削除実行
		----------------------------------------------------*/
		function delete_photo ( $newFileName ) {

			global $path;

			if( $newFileName == "" ) {
				return;
			}

			// 保存ファイルパスの設定
			$delete_filePath = $path["campaignPhoto"]["campaign"] . "/$newFileName";

			// ファイルがあれば削除
			if( file_exists( $delete_filePath ) ) {
				unlink( $delete_filePath );
			}

		}

	}
?>