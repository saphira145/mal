<?php
/* -------------------------------------
	管理者管理
	for NetGRID PHP Framework v2
	最終更新: 2009-02-06
------------------------------------- */


	class modelAdmin_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function modelAdmin () {

		}


		/*----------------------------------------------------
		    情報追加
		----------------------------------------------------*/
		function insert_DB ( $input ) {

			unset( $insert );
			$insert["modelCode"]           = $input["modelInfo"]["modelCode"];
			$insert["makerCode"]           = $input["modelInfo"]["makerCode"];
			$insert["modelName"]           = $input["modelInfo"]["modelName"];
			$insert["modelNameEng"]        = $input["modelInfo"]["modelNameEng"];
			$insert["miniPrice"]           = $input["modelInfo"]["miniPrice"];
			$insert["maxPrice"]            = $input["modelInfo"]["maxPrice"];
			$insert["miniTotalLength"]     = $input["modelInfo"]["miniTotalLength"];
			$insert["maxTotalLength"]      = $input["modelInfo"]["maxTotalLength"];
			$insert["miniTotalWidth"]      = $input["modelInfo"]["miniTotalWidth"];
			$insert["maxTotalWidth"]       = $input["modelInfo"]["maxTotalWidth"];
			$insert["miniTotalHeight"]     = $input["modelInfo"]["miniTotalHeight"];
			$insert["maxTotalHeight"]      = $input["modelInfo"]["maxTotalHeight"];
			$insert["announcementDay"]     = $input["modelInfo"]["announcementDay"];
			$insert["campaignScore"]       = $input["modelInfo"]["campaignScore"];
			$insert["lowPriceCarGradeID"]  = $input["modelInfo"]["lowPriceCarGradeID"];
			$insert["s2wdCarGradeID"]      = $input["modelInfo"]["s2wdCarGradeID"];
			$insert["s4wdCarGradeID"]      = $input["modelInfo"]["s4wdCarGradeID"];
			$insert["webCatalogueUrl"]     = $input["modelInfo"]["webCatalogueUrl"];
            $insert["valueUrl"]            = $input["modelInfo"]["valueUrl"];
			$insert["photoGalleryUrl"]     = $input["modelInfo"]["photoGalleryUrl"];


            // ＤＢ名取得
            $DBName = get_DBName( "work" );

            $sql = "INSERT INTO {$DBName}.model {insert_value};";
            list( $affected_row, $insert_id ) = sql_query( $sql, $insert, "1" );


            return $insert["modelCode"];

		}


		/*----------------------------------------------------
		    情報更新
		----------------------------------------------------*/
		function update_DB ( $input ) {

			if ( $input["orgMakerCode"] == ""
				|| $input["orgMakerCode"] == 0
				|| $input["orgModelCode"] == ""
				|| $input["orgModelCode"] == "0" ){
				return;
			}

			unset( $update );
			$update["modelCode"]           = $input["modelInfo"]["modelCode"];
			$update["makerCode"]           = $input["modelInfo"]["makerCode"];
			$update["modelName"]           = $input["modelInfo"]["modelName"];
			$update["modelNameEng"]        = $input["modelInfo"]["modelNameEng"];
			$update["miniPrice"]           = $input["modelInfo"]["miniPrice"];
			$update["maxPrice"]            = $input["modelInfo"]["maxPrice"];
			$update["miniTotalLength"]     = $input["modelInfo"]["miniTotalLength"];
			$update["maxTotalLength"]      = $input["modelInfo"]["maxTotalLength"];
			$update["miniTotalWidth"]      = $input["modelInfo"]["miniTotalWidth"];
			$update["maxTotalWidth"]       = $input["modelInfo"]["maxTotalWidth"];
			$update["miniTotalHeight"]     = $input["modelInfo"]["miniTotalHeight"];
			$update["maxTotalHeight"]      = $input["modelInfo"]["maxTotalHeight"];
			$update["announcementDay"]     = $input["modelInfo"]["announcementDay"];
			$update["campaignScore"]       = $input["modelInfo"]["campaignScore"];
			$update["lowPriceCarGradeID"]  = $input["modelInfo"]["lowPriceCarGradeID"];
			$update["s2wdCarGradeID"]      = $input["modelInfo"]["s2wdCarGradeID"];
			$update["s4wdCarGradeID"]      = $input["modelInfo"]["s4wdCarGradeID"];
			$update["webCatalogueUrl"]     = $input["modelInfo"]["webCatalogueUrl"];
            $update["valueUrl"]            = $input["modelInfo"]["valueUrl"];
			$update["photoGalleryUrl"]     = $input["modelInfo"]["photoGalleryUrl"];

            // ＤＢ名取得
            $DBName = get_DBName( "work" );

            // SQLインジェクション対応
            $sql_escape["orgMakerCode"]  = sql_escapeString($input["orgMakerCode"]);
            $sql_escape["orgModelCode"]  = sql_escapeString($input["orgModelCode"]);

            $sql = "UPDATE {$DBName}.model SET {update_set} WHERE makerCode = '{$sql_escape["orgMakerCode"]}' AND modelCode = '{$sql_escape["orgModelCode"]}'";
            sql_query( $sql, $update, "1" );

		}


		/*----------------------------------------------------
		    情報削除
		----------------------------------------------------*/
		function delete_DB ( $input ) {

			if ( $input["orgMakerCode"] == ""
				|| $input["orgMakerCode"] == 0
				|| $input["orgModelCode"] == ""
				|| $input["orgModelCode"] == "0" ){
				return;
			}

			// 関連情報も削除
			delete_modelInfoAndRelationData ( $input["orgMakerCode"], $input["orgModelCode"] );

		}


		/*----------------------------------------------------
		  リスト取得
		----------------------------------------------------*/
		function get_list ( $input ) {

			global $ini;

			// 車種コード
			if ( $input["searchModelCode"] != "" ) {
				$sql_escape["searchModelCode"]  = sql_escapeString($input["searchModelCode"]);
				$where[] = "modelCode = '{$sql_escape["searchModelCode"]}'";
			}

			// メーカーコード
			if ( $input["searchMakerCode"] != "" ) {
				$sql_escape["searchMakerCode"]  = sql_escapeString($input["searchMakerCode"]);
				$where[] = "makerCode = '{$sql_escape["searchMakerCode"]}'";
			}

			// 車種名
			if ( $input["searchModelName"] != "" ) {
				$sql_escape["searchModelName"]  = sql_escapeString($input["searchModelName"]);
				$where[] = "( modelName LIKE '%{$sql_escape["searchModelName"]}%' OR modelNameEng LIKE '%{$sql_escape["searchModelName"]}%' )";
			}

			if ( count( $where ) > 0 ) {
				$sql_where = "WHERE " . @implode( " AND ", $where );
			}

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// 件数の取得
			$sql = "SELECT count(*) AS cnt FROM {$DBName}.model {$sql_where}";
			$tbl = sql_query( $sql, "single" );

			// ページ情報の取得
			$pageInfo = adjust_pageState( $tbl["cnt"], $ini["pageLimit"]["modelAdmin"], $input["pageNum"] );

			// SQLインジェクション対応
			$sql_escape["limitStart"] = sql_escapeString($pageInfo["limitStart"]);
			$sql_escape["pageLimit"]  = sql_escapeString($ini["pageLimit"]["modelAdmin"]);

			$sql  = "SELECT makerCode, modelCode FROM {$DBName}.model ";
			$sql .= "{$sql_where} ";
			$sql .= "ORDER BY modelCode DESC ";
			$sql .= "LIMIT {$sql_escape["limitStart"]}, {$sql_escape["pageLimit"]}";
			$list = (array)sql_query( $sql );

			for( $i=0; $i<count( $list ); $i++ ) {

				$list[$i] = $this->get_info( $list[$i]["makerCode"], $list[$i]["modelCode"] );

			}

			return array( $list, $pageInfo );
		}


		/*----------------------------------------------------
		  情報取得
		----------------------------------------------------*/
		function get_info ( $makerCode, $modelCode ) {

			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["makerCode"] = sql_escapeString($makerCode);
			$sql_escape["modelCode"] = sql_escapeString($modelCode);

			$sql = "SELECT * FROM {$DBName}.model WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
			$ret = sql_query( $sql, "single" );

			$ret["price"]["mini"]          = $ret["miniPrice"];
			$ret["price"]["max"]           = $ret["maxPrice"];
			$ret["totalLength"]["mini"]    = $ret["miniTotalLength"];
			$ret["totalLength"]["max"]     = $ret["maxTotalLength"];
			$ret["totalWidth"]["mini"]     = $ret["miniTotalWidth"];
			$ret["totalWidth"]["max"]      = $ret["maxTotalWidth"];
			$ret["totalHeight"]["mini"]    = $ret["miniTotalHeight"];
			$ret["totalHeight"]["max"]     = $ret["maxTotalHeight"];
			$ret["announcementDay"]        = db2val_dateType1( $ret["announcementDay"] );
			$ret["topUpdateDay"]           = db2val_dateType1( $ret["topUpdateDay"] );


			return $ret;
		}


		/*----------------------------------------------------
		  表示用に変更
		----------------------------------------------------*/
		function convert_Info ( $info ) {

			global $ini;

			// メーカー名取得
			$info["makerName"]               = get_makerName( $info["makerCode"] );

			// 車種グレード情報取得(最廉価)
			$info["lowPriceCarGrade"]  = $this->get_infoWorkDBorActiveDB($info["lowPriceCarGradeID"]);

			// 車種グレード情報取得(標準2WD)
			$info["s2wdCarGrade"]      = $this->get_infoWorkDBorActiveDB($info["s2wdCarGradeID"]);

			// 車種グレード情報取得(標準4WD)
			$info["s4wdCarGrade"]      = $this->get_infoWorkDBorActiveDB($info["s4wdCarGradeID"]);

			// キャンペーンスコア名取得
			$info["campaignScoreName"] = get_campaignScoreName( $info["campaignScore"] );

			return $info;
		}



		/*----------------------------------------------------
		  一時画像を保存（車体画像）
		----------------------------------------------------*/
		function save_tempCarBodyPhoto ( $orgFile, $tempFileName ) {

			global $class, $path, $ini;

			// 一時画像
			$dstFullPath = $path["modelPhoto"]["tmpDir"] . "/temp_$tempFileName";

			// 一時サムネイル画像
			$sub_dstFullPath = $path["modelPhoto"]["tmpDir"] . "/temp_s_$tempFileName";

			// 一時画像を保存実行
			$this->copy_tempPhoto( $orgFile, $dstFullPath );

			// サムネイル画像保存
			$this->resize_img( $dstFullPath, $sub_dstFullPath, $ini["modelPhoto"]["carBody1"]["width"], $ini["modelPhoto"]["carBody1"]["height"] );

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
		  車体画像を本番へ移動
		----------------------------------------------------*/
		function move_carBodyPhoto ( $orgFile, $makerCode, $modelCode ) {

			global $path, $ini;

			// 拡張子を取り出す
			$result = explode( ".", $orgFile );
			$extension = array_pop( $result );
			$extension = "jpg";

			// ファイル名取得
			$newFileName = get_photoFileName( $makerCode, $modelCode );

			// ファイル移動
			$this->move_photo( $orgFile, $newFileName, $makerCode, $extension );

		}


		/*----------------------------------------------------
		  ファイル移動
		----------------------------------------------------*/
		function move_photo ( $orgFile, $newFileName, $makerCode, $extension ) {

			global $path, $ini;

			// 車体画像（大）を移動
			$orgFullPath1 = $path["modelPhoto"]["tmpDir"]   . "/temp_s_$orgFile";
			$dstFullPath1 = $path["modelPhoto"]["WORK"]["carBody"]  . "/$newFileName.$extension";

			@rename( $orgFullPath1, $dstFullPath1 );

			// オリジナルファイル
			$orgFilePath  = $path["modelPhoto"]["tmpDir"]   . "/temp_$orgFile";

			// 車体画像（小）ファイルパス
			$dstFullPath2 = $path["modelPhoto"]["WORK"]["carBody"]  . "/s_$newFileName.$extension";

			// サムネイル画像保存
			$this->resize_img( $orgFilePath, $dstFullPath2, $ini["modelPhoto"]["carBody2"]["width"], $ini["modelPhoto"]["carBody2"]["height"] );

			// 元画像削除
			if( file_exists( $orgFilePath ) ) {
				@unlink( $orgFilePath );
			}

		}



		/*----------------------------------------------------
		  画像削除
		----------------------------------------------------*/
		function delete_carBodyPhoto ( $makerCode, $modelCode ) {

			global $path;

			if( $makerCode == ""
			 || $modelCode == "" ) {
				return NULL;
			}

			// ファイル名取得
			$newFileName = get_photoFileName( $makerCode, $modelCode );

			// 削除実行
			$this->delete_photo( $newFileName );

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
			$delete_filePath1 = $path["modelPhoto"]["WORK"]["carBody"]    . "/$newFileName.jpg";

			// ファイルがあれば削除
			if( file_exists( $delete_filePath1 ) ) {
				unlink( $delete_filePath1 );
			}

			// 保存ファイルパスの設定
			$delete_filePath2 = $path["modelPhoto"]["WORK"]["carBody"]    . "/s_$newFileName.jpg";

			// ファイルがあれば削除
			if( file_exists( $delete_filePath2 ) ) {
				unlink( $delete_filePath2 );
			}
		}


		/*----------------------------------------------------
		    一時画像ファイルの削除
		----------------------------------------------------*/
		function delete_tmpPhotoFile () {

			global $ini, $path;

			// テンプディレクトリパスの取得
			$temp_path = $path["modelPhoto"]["tmpDir"];

			// 削除対象の日付取得
			$y  = date( "Y" );
			$m  = date( "m" );
			$d  = date( "d" );
			$h  = date( "H" );
			$i  = date( "i" );
			$s  = date( "s" );

			$from_date  = date( "Y-m-d H:i:s", mktime( $h, $i, $s, $m, $d - $ini["temp"]["deleteDayUnit"], $y ) );

			$process_date = date( "Y-m-d H:i:s" );

			foreach( glob("$temp_path/temp_*.*") as $file_path ) {
				$file_date = date('Y-m-d H:i:s', filemtime( $file_path ) );
				if( $file_date < $from_date ) {
					@unlink ( $file_path );
				}
			}

		}



	/*----------------------------------------------------------------------
		resize_img：画像ファイルの拡大・縮小（縦横比固定）
			戻り値：なし
	----------------------------------------------------------------------*/
		function resize_img( $src_file, $dst_file, $dst_width, $dst_height, $quality=100 ) {

			if(trim($src_file) == ""
				|| trim($dst_file) == ""
				|| !(isset($dst_width))
				|| !(is_numeric($dst_width))
				|| $dst_width == 0
				|| !(isset($dst_height))
				|| !(is_numeric($dst_height))
				|| $dst_height == 0
				){
				return;
			}

			if( !file_exists( $src_file ) ) {
				return;
			}

			$filetype = array( 0, "gif", "jpg", "png", "bmp" );
			$p  = $dst_width / $dst_height;

			list( $file_width, $file_height ) = getimagesize( $src_file );

			if(!(isset($file_width))
				|| !(is_numeric($file_width))
				|| $file_width == 0
				|| !(isset($file_height))
				|| !(is_numeric($file_height))
				|| $file_height == 0
				){
				return;
			}

			$pp = $file_width / $file_height;

			if( $file_width > $dst_width || $file_height > $dst_height ) {
				// 横長
				if( $pp > $p ) {
					$fin_width  = $dst_width;
					$fin_height = $file_height * ( $dst_width / $file_width );
				}
				// 縦長
				else {
					$fin_width  = $file_width * ( $dst_height / $file_height );
					$fin_height = $dst_height;
				}
			}
			else {
				$fin_width  = $file_width;
				$fin_height = $file_height;
			}

			list( $width, $height, $type, $attr ) = getimagesize( $src_file  );
			if( $filetype[$type] == "gif" ) {
				$im_in  = imagecreatefromgif( $src_file );
			}
			elseif( $filetype[$type] == "png" ) {
				$im_in  = imagecreatefrompng( $src_file );
			}
			elseif( $filetype[$type] == "jpg" ) {
				$im_in  = imagecreatefromjpeg( $src_file );
			}

			if( $fin_width < 1 ){
				$fin_width = 1;
			}
			if( $fin_height < 1 ){
				$fin_height = 1;
			}
			$im_out = imagecreatetruecolor ( $fin_width, $fin_height );

			// PNG画像透過対応
			if( $filetype[$type] == "png" ) {
				imagealphablending($im_out, false);
				$color = imagecolorallocatealpha($im_out, 0, 0, 0, 127);
				imagefill($im_out, 0, 0, $color);
				imagesavealpha($im_out, true);
			}

			imagecopyresampled( $im_out, $im_in, 0, 0, 0, 0, $fin_width, $fin_height, $file_width, $file_height );
			if( $filetype[$type] == "gif" ) {
				imagegif( $im_out, $dst_file );
			}
			elseif( $filetype[$type] == "png" ) {
				if ( $quality > 9 || $quality < 0 ) { $quality = 9; }
				imagepng( $im_out, $dst_file, 9 );
			}
			elseif( $filetype[$type] == "jpg" ) {
				imagejpeg( $im_out, $dst_file, $quality );
			}

			imagedestroy( $im_in );
			imagedestroy( $im_out );

		}


		/*----------------------------------------------------
		   車種グレード情報取得（ワーク優先）
		----------------------------------------------------*/
		function get_infoWorkDBorActiveDB ( $carGradeID ) {

			if( empty($carGradeID) ){
				return NULL;
			}

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["carGradeID"]  = sql_escapeString($carGradeID);

			// ワークから取得
			$sql  = "SELECT * ";
			$sql .= "FROM {$DBName}.carGrade as cg ";
			$sql .= "LEFT JOIN {$DBName}.maintenance as mt ";
			$sql .= "ON cg.makerCode = mt.makerCode AND cg.modelCode = mt.modelCode AND cg.carGradeID = mt.carGradeID ";
			$sql .= "WHERE cg.carGradeID = '{$sql_escape["carGradeID"]}'";

			$ret = sql_query( $sql, "single" );

			// ワークになければアクティブＤＢから取得
			if( $ret["carGradeID"] == "" ) {
				$DBNum = get_activeDBNum();
				if( $DBNum > 0 ) {
					$sql  = "SELECT * ";
					$sql .= "FROM {$DBName}.carGrade as cg ";
					$sql .= "LEFT JOIN {$DBName}.maintenance as mt ";
					$sql .= "ON cg.makerCode = mt.makerCode AND cg.modelCode = mt.modelCode AND cg.carGradeID = mt.carGradeID ";
					$sql .= "WHERE cg.carGradeID = '{$sql_escape["carGradeID"]}'";

					$ret = sql_query( $sql, "single" );
					$ret["activeFlg"] = 1;
				}
			}

			// ボディタイプ名の設定
			$ret["bodyModelName"] = get_bodyTypeName($ret["bodyModel"]);

			// メンテナンス区分
			$ret["mainteStateName"] = "未登録";

			if( $ret["mainteID"] ){
				$ret["mainteName"] = $ret["mainteID"];

				$tmp_mainteState = get_maintenanceStateInfo($ret["mainteState"]);
				$ret["mainteStateName"] = $tmp_mainteState["name"];
			}

			return $ret;
		}

	}

?>