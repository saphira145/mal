<?php


	class releaseUser_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function releaseUser () {

		}


		/*----------------------------------------------------
		    リリース済みの予定時間削除
		----------------------------------------------------*/
		function delete_releasedReserveDatetime ( $targetTime ) {

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// SQLインジェクション対応
			$sql_escape["targetTime"] = sql_escapeString($targetTime);

			$update["reserveDatetime"]          = "0000-00-00 00:00:00";

			$sql = "UPDATE {$DBName}.tableAdmin SET {update_set} WHERE reserveDatetime <= '{$sql_escape["targetTime"]}' AND reserveDatetime != '0000-00-00 00:00:00'";
			sql_query( $sql, $update );


		}



		/*----------------------------------------------------
		    最終切り替え日更新
		----------------------------------------------------*/
		function update_activeDatetime ( $targetTime ) {

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			$update["activeDatetime"]          = $targetTime;

			$sql = "UPDATE {$DBName}.tableAdmin SET {update_set}";
			sql_query( $sql, $update );


		}



		/*----------------------------------------------------
		    アクティブDBの切り替え
		----------------------------------------------------*/
		function activeDBSwitch () {

			// 現在どのＤＢがアクティブか？
			$num = get_activeDBNum ();

			// アクティブＤＢの切り替え
			if( $num == 1 ) {
				change_activeDB ( 2 );
			}
			else{
				change_activeDB ( 1 );
			}


		}



		/*----------------------------------------------------
		    コピーするテーブル一覧取得
		----------------------------------------------------*/
		function get_tableList ( $targetTime ) {

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// 渡された日時以降のリリース予定テーブル名を取得する
			$sql_escape["targetTime"] = sql_escapeString($targetTime);

			$sql  = "SELECT tableID FROM {$DBName}.tableAdmin WHERE reserveDatetime <= '{$sql_escape["targetTime"]}' AND reserveDatetime > '0000-00-00 00:00:00'";
			$list = (array)sql_query( $sql );

			// リリースされていない場合は空を返す
			if( count( $list ) == 0 ) {
				return NULL;
			}

			// リリースがあれば下記のテーブルを加える
			$list[]["tableID"] = "maker";
			$list[]["tableID"] = "model";
			$list[]["tableID"] = "themeMst";
			$list[]["tableID"] = "carTheme";		// tableAdmin の更新日時は CSV 取込時間. 手で修正した場合は更新されないのでここで指定.
			$list[]["tableID"] = "themeRecommend";
			$list[]["tableID"] = "lease";
			$list[]["tableID"] = "leaseValue";
			$list[]["tableID"] = "maintenance";
			$list[]["tableID"] = "maintenanceFee";

			return $list;
		}



		/*----------------------------------------------------
		    ワークDBがロックされているか
		----------------------------------------------------*/
		function is_workDBLocked () {

			// ワークＤＢロックフラグ取得
			$flg = get_DBLockFlg( "workDBLockFlg" );


			return $flg == 1 ? true: false;
		}



		/*----------------------------------------------------
		    リリース時間を延期
		----------------------------------------------------*/
		function postpone_reserveDatetime () {

			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// 延期後のリリース時間
			$postponeTime = date("Y-m-d H:i:s", mktime( date( "H" ), date( "i" ) + $ini["reserve"]["limit"], 0, date( "m" ), date( "d" ), date( "Y" ) ) );

			$update["reserveDatetime"]          = $postponeTime;

			$sql = "UPDATE {$DBName}.tableAdmin SET {update_set}";
			sql_query( $sql, $update );

		}



		/*----------------------------------------------------
		    非アクティブDBの全データ削除
		----------------------------------------------------*/
		function delete_allData ( $inactiveDBNum ) {

			// ＤＢ名
			$DBName = get_DBName( $inactiveDBNum );

			// 非アクティブＤＢのテーブル名全て取得
			$sql  = "SHOW TABLES FROM {$DBName}";
			$result = mysql_query( $sql );

			// リストに入れる
			while ( $row = mysql_fetch_row( $result ) ) {
				$list[]["tableID"] = $row[0];
			}

			// 結果保持用メモリを開放する
			mysql_free_result( $result );

			for( $i=0; $i<count( $list ); $i++ ) {
				$sql_escape["tableID"] = sql_escapeString($list[$i]["tableID"]);

				$sql = "DELETE FROM {$DBName}.{$sql_escape["tableID"]}";
				sql_query( $sql );
			}

		}



		/*----------------------------------------------------
		    検索DBコピー
		----------------------------------------------------*/
		function copy_tables ( $list, $inactiveDBNum ) {

			// ＤＢ名（コピー先）
			$inactiveDBName = get_DBName( $inactiveDBNum );

			// ＤＢ名（コピー元）
			$workDBName   = get_DBName( "work" );

			for( $i=0; $i<count( $list ); $i++ ) {
				$sql_escape["tableID"] = sql_escapeString($list[$i]["tableID"]);

				$sql = "INSERT INTO {$inactiveDBName}.{$sql_escape["tableID"]} SELECT * FROM {$workDBName}.{$sql_escape["tableID"]}";
				sql_query( $sql );
			}

		}



		/*----------------------------------------------------
		    画像ファイルコピー
		----------------------------------------------------*/
		function copy_photo ( $inactiveDBNum ) {

			global $path;

			// パスの設定（コピー先）
			$toFilePath = $this->get_toCopyPhotoFilePath( $inactiveDBNum );

			// ＤＢ名（コピー元：ＷＯＲＫ）
			$fromFilePath   = $this->get_photoFilePath();

			// コピー先ディレクトリ内の画像を全て削除
			$this->delete_toCopyDirPhoto( $toFilePath );

			// コピー実行
			$this->do_copy( $toFilePath, $fromFilePath );

		}



		/*----------------------------------------------------
		    パスの設定（コピー先）
		----------------------------------------------------*/
		function get_toCopyPhotoFilePath ( $DBNum ) {

			global $path;

			if( $DBNum == "" || $DBNum == 0 ) {
				return NULL;
			}

			$ret["carBody"][]["dirPath"]    = $path["modelPhoto"]["DB{$DBNum}"]["carBody"];

			return $ret;
		}



	/*----------------------------------------------------
	  画像ファイルパスの設定
	----------------------------------------------------*/
	function get_photoFilePath () {

		global $path;

		$ret["carBody"]     = $path["modelPhoto"]["WORK"]["carBody"];

		return $ret;
	}



		/*----------------------------------------------------
		    コピー先ディレクトリ内の画像を全て削除
		----------------------------------------------------*/
		function delete_toCopyDirPhoto ( $filePath ) {

			// 車体画像削除
			for( $i=0; $i<count( $filePath["carBody"] ); $i++ ) {
				// ファイル削除
				$this->delete_file( $filePath["carBody"][$i]["dirPath"] ) ;
			}

		}



		/*----------------------------------------------------
		    ファイル削除
		----------------------------------------------------*/
		function delete_file ( $dirPath ) {

			if( $dirPath == "" ) {
				return NULL;
			}

			foreach( glob( "$dirPath/*" ) as $filePath ) {
				@unlink ( $filePath );
			}
		}



		/*----------------------------------------------------
		    コピー実行
		----------------------------------------------------*/
		function do_copy ( $toList, $formList ) {

			if( count( $toList ) == 0 || count( $formList ) == 0 ) {
				return NULL;
			}

			// 画像ファイル取得
			foreach( $formList as $photoType => $path ) {
				$i=0;
				$formList2[$photoType]["dirPath"] = $path;
				foreach( glob( "$path/*" ) as $filePath ) {
					$formList2[$photoType]["fileNameList"][$i] = basename( $filePath );
					$i++;
				}
			}


			// 車体画像コピー
			for( $i=0; $i<count( $toList["carBody"] ); $i++ ) {
				for( $j=0; $j<count( $formList2["carBody"]["fileNameList"] ); $j++ ) {
					$sourceFile     = $formList2["carBody"]["dirPath"]  . "/{$formList2["carBody"]["fileNameList"][$j]}";
					$destFile       = $toList["carBody"][$i]["dirPath"] . "/{$formList2["carBody"]["fileNameList"][$j]}";
					@copy( $sourceFile, $destFile );
					@chmod( $destFile, 0777 );
				}
			}
		}



		/*----------------------------------------------------
		    carList.jsの作成
		----------------------------------------------------*/
		function make_carListJs ( $inactiveDBNum ) {

			global $path;

			// ディレクトリパスの設定
			$dirPath    = $path["modelJs"]["DB{$inactiveDBNum}"]["dir"];
			$dirPathSsl = $path["modelJsSsl"]["DB{$inactiveDBNum}"]["dir"];

			// ファイルパスの設定
			$output["filePath"]    = $dirPath . "/". $path["modelJs"]["fileName"] ;
			$output["filePathSsl"] = $dirPathSsl . "/". $path["modelJs"]["fileName"] ;

			// すでにあれば削除
			if( file_exists ( $output["filePath"] ) ) {
				@unlink( $output["filePath"] );
			}

			if( file_exists ( $output["filePathSsl"] ) ) {
				@unlink( $output["filePathSsl"] );
			}

			// 車種名の取得
			$list = get_carListData($inactiveDBNum);

			// JSで使用する形にする
			if( count( $list ) > 0 ) {

				// ファイルの作成
				$txtList[] = "var data=[\n";

				// データ出力
				for( $i = 0; $i < count( $list ); $i++ ) {
					unset($txt);
					$txt[] = "{c:'"  . $list[$i]["c"];
					$txt[] = " m:'"  . $list[$i]["m"];
					$txt[] = " me:'" . $list[$i]["me"];
					$txts = join( $txt, "',");

					$txtList[] = $txts . "'},\n";

				}
				$txtList[] = "];";
			}

			// 該当JSファイルの作成
			if( count( $txtList ) > 0 ) {
				for( $i = 0; $i < count( $txtList ); $i++ ) {
					//_web
					$fp   = fopen( $output["filePath"], "a" );
					fputs( $fp, $txtList[$i] );
					fclose( $fp );

					//_ssl
					$fpSsl = fopen( $output["filePathSsl"], "a" );
					fputs( $fpSsl, $txtList[$i] );
					fclose( $fpSsl );
				}
			}

		}


	}





?>