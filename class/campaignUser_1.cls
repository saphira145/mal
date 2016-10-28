<?php


	class campaignUser_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function campaignUser_1 () {

		}

		/*----------------------------------------------------
		   リスト取得
		----------------------------------------------------*/
		function get_list ( $lixtCnt=3 ) {

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// SQLインジェクション対応
			$sql_escape["lixtCnt"]  = sql_escapeString($lixtCnt);

			$sql = "SELECT * FROM {$DBName}.campaign WHERE dispNum <> 0 ORDER BY dispNum LIMIT {$sql_escape["lixtCnt"]}";
			$list = (array)sql_query( $sql );

			return $list;
		}
		
		/*----------------------------------------------------
		   キャンペーン画像取得
		----------------------------------------------------*/
		function get_photo($campaignNum){
			global $path;
			for( $i = 0, $iMax = count($path["campaignPhoto"]["extension"]); $i < $iMax; $i++){
				// ファイル名取得
				$FileName = get_campaignPhotoFileName( $campaignNum ) . $path["campaignPhoto"]["extension"][$i];
				$filePath = $path["campaignPhoto"]["campaign"] . "/$FileName";
				//fileがあれば返す
				if( file_exists( $filePath ) ) {
					return $FileName;
				}
			}
		}
	}
?>