<?php
/* -------------------------------------
	管理者管理
	for NetGRID PHP Framework v2
	最終更新: 2009-02-06
------------------------------------- */


	class csvImport_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function csvImport () {

		}



		/*----------------------------------------------------
		    アップロードファイルを一時ディレクトリへ
		----------------------------------------------------*/
			function copy_tempDir ( $tempFile ) {

				global $path;

				// ディレクトリパスの設定
				$dirPath  = $path["csv"]["tmpDir"];

				// 一時ファイル名の取得
				$resultName = explode( "/", $tempFile );
				$newFileName = array_pop( $resultName );
				$newFileName .= ".csv";

				// ファイルパスの設定
				$filePath = "$dirPath/$newFileName";

				// コピー
				if ( !copy( $tempFile, $filePath ) ) {
					echo "コピー失敗！";
					return NULL;
				}


				return array( $filePath, $newFileName );
			}



			/*----------------------------------------------------
				   文字コード変換（配列対応）
			----------------------------------------------------*/
			function mbConvertEncodingDeep ( $value, $encFrom, $encTo ) {

				if ( is_array( $value ) ) {
					foreach( $value as $key => $val ) {
						$value[$key] = $this->mbConvertEncodingDeep( $val, $encFrom, $encTo );
					}
				}
				else{
					$value = mb_convert_encoding( $value, $encTo, $encFrom );
				}


				return $value;
			}



			/*--------------------------------------------------
			     改行、タブを取り外す
			---------------------------------------------------*/
			function conv_textData ( $text ) {

				$str      = trim( $text );
				$str      = str_replace( "\r\n", "\n", $str );
				$str      = str_replace( "\r", "\n", $str );
				$str      = str_replace( "\n", "", $str );
				$text     = str_replace( "\t", "", $str );


				return $text;
			}



			/*----------------------------------------------------
			    一時アーカイブファイルの削除
			----------------------------------------------------*/
			function delete_tmpCSVFile () {

				global $ini, $path;

				// テンプディレクトリパスの取得
				$temp_path = $path["csv"]["tmpDir"];

				// 削除対象の日付取得
				$y  = date( "Y" );
				$m  = date( "m" );
				$d  = date( "d" );
				$h  = date( "H" );
				$i  = date( "i" );
				$s  = date( "s" );

				$from_date  = date( "Y-m-d H:i:s", mktime( $h, $i, $s, $m, $d - $ini["tempCSV"]["deleteDayUnit"], $y ) );

				$process_date = date( "Y-m-d H:i:s" );

				foreach( glob("$temp_path/*") as $file_path ) {
					$file_date = date('Y-m-d H:i:s', filemtime( $file_path ) );
					if( $file_date < $from_date ) {
						@unlink ( $file_path );
					}
				}

			}



			/*----------------------------------------------------
			    車種グレード登録
			----------------------------------------------------*/
			function insert_carGrade ( $input ) {

				unset( $insert );
				$insert            = $input;

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "INSERT INTO {$DBName}.carGrade {insert_value}";
				list( $affected_row, $memberID ) = sql_query( $sql, $insert, "1" );

				return $memberID;
			}



			/*----------------------------------------------------
			    車種グレード削除
			----------------------------------------------------*/
			function delete_carGrade () {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "DELETE FROM {$DBName}.carGrade";
				sql_query( $sql, "", "1" );

			}



			/*----------------------------------------------------
			    視界登録
			----------------------------------------------------*/
			function insert_view ( $input ) {

				unset( $insert );
				$insert            = $input;

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "INSERT INTO {$DBName}.view {insert_value}";
				list( $affected_row, $memberID ) = sql_query( $sql, $insert, "1" );

				return $memberID;
			}



			/*----------------------------------------------------
			    視界削除
			----------------------------------------------------*/
			function delete_view () {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "DELETE FROM {$DBName}.view";
				sql_query( $sql, "", "1" );

			}



			/*----------------------------------------------------
			    運転席まわり登録
			----------------------------------------------------*/
			function insert_seatCircumference ( $input ) {

				unset( $insert );
				$insert            = $input;

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "INSERT INTO {$DBName}.seatCircumference {insert_value}";
				list( $affected_row, $memberID ) = sql_query( $sql, $insert, "1" );

				return $memberID;
			}



			/*----------------------------------------------------
			    運転席まわり削除
			----------------------------------------------------*/
			function delete_seatCircumference () {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "DELETE FROM {$DBName}.seatCircumference";
				sql_query( $sql, "", "1" );

			}



			/*----------------------------------------------------
			    空調登録
			----------------------------------------------------*/
			function insert_airConditioning ( $input ) {

				unset( $insert );
				$insert            = $input;

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "INSERT INTO {$DBName}.airConditioning {insert_value}";
				list( $affected_row, $memberID ) = sql_query( $sql, $insert, "1" );

				return $memberID;
			}



			/*----------------------------------------------------
			    空調削除
			----------------------------------------------------*/
			function delete_airConditioning () {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "DELETE FROM {$DBName}.airConditioning";
				sql_query( $sql, "", "1" );

			}



			/*----------------------------------------------------
			    オーディオ登録
			----------------------------------------------------*/
			function insert_audio ( $input ) {

				unset( $insert );
				$insert            = $input;

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "INSERT INTO {$DBName}.audio {insert_value}";
				list( $affected_row, $memberID ) = sql_query( $sql, $insert, "1" );

				return $memberID;
			}



			/*----------------------------------------------------
			    オーディオ削除
			----------------------------------------------------*/
			function delete_audio () {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "DELETE FROM {$DBName}.audio";
				sql_query( $sql, "", "1" );

			}



			/*----------------------------------------------------
			    シート・内装関係登録
			----------------------------------------------------*/
			function insert_seatInterior ( $input ) {

				unset( $insert );
				$insert            = $input;

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "INSERT INTO {$DBName}.seatInterior {insert_value}";
				list( $affected_row, $memberID ) = sql_query( $sql, $insert, "1" );

				return $memberID;
			}



			/*----------------------------------------------------
			    シート・内装関係削除
			----------------------------------------------------*/
			function delete_seatInterior () {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "DELETE FROM {$DBName}.seatInterior";
				sql_query( $sql, "", "1" );

			}



			/*----------------------------------------------------
			    外装登録
			----------------------------------------------------*/
			function insert_exterior ( $input ) {

				unset( $insert );
				$insert            = $input;

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "INSERT INTO {$DBName}.exterior {insert_value}";
				list( $affected_row, $memberID ) = sql_query( $sql, $insert, "1" );

				return $memberID;
			}



			/*----------------------------------------------------
			    外装削除
			----------------------------------------------------*/
			function delete_exterior () {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "DELETE FROM {$DBName}.exterior";
				sql_query( $sql, "", "1" );

			}



			/*----------------------------------------------------
			    足廻り登録
			----------------------------------------------------*/
			function insert_footSurroundings ( $input ) {

				unset( $insert );
				$insert            = $input;

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "INSERT INTO {$DBName}.footSurroundings {insert_value}";
				list( $affected_row, $memberID ) = sql_query( $sql, $insert, "1" );

				return $memberID;
			}



			/*----------------------------------------------------
			    足廻り削除
			----------------------------------------------------*/
			function delete_footSurroundings () {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "DELETE FROM {$DBName}.footSurroundings";
				sql_query( $sql, "", "1" );

			}



			/*----------------------------------------------------
			    安全登録
			----------------------------------------------------*/
			function insert_safety ( $input ) {

				unset( $insert );
				$insert            = $input;

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "INSERT INTO {$DBName}.safety {insert_value}";
				list( $affected_row, $memberID ) = sql_query( $sql, $insert, "1" );

				return $memberID;
			}



			/*----------------------------------------------------
			    安全削除
			----------------------------------------------------*/
			function delete_safety () {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "DELETE FROM {$DBName}.safety";
				sql_query( $sql, "", "1" );

			}



			/*----------------------------------------------------
			    金額のアップデート
			----------------------------------------------------*/
			function update_modelPrice () {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				// 車種リスト取得
				$modelList = $this->get_modelList();

				for( $i=0; $i<count( $modelList ); $i++ ) {
					// 最小・最大の金額取得
					list( $mini, $max ) = $this->get_miniMaxprice( $modelList[$i]["makerCode"], $modelList[$i]["modelCode"] );

					// 車種マスタ更新
					unset( $update );
					if( is_numeric( $mini ) ) {
						$update["miniPrice"]       = $mini;
					}
					if( is_numeric( $max ) ) {
						$update["maxPrice"]        = $max;
					}

					if( is_array( $update ) ) {
						// SQLインジェクション対応
						$sql_escape["makerCode"] = sql_escapeString($modelList[$i]["makerCode"]);
						$sql_escape["modelCode"] = sql_escapeString($modelList[$i]["modelCode"]);

						$sql = "UPDATE {$DBName}.model SET {update_set} WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
						sql_query( $sql, $update, "1" );
					}
				}

			}



			/*----------------------------------------------------
			    車種リスト取得
			----------------------------------------------------*/
			function get_modelList () {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql  = "SELECT makerCode, modelCode FROM {$DBName}.model GROUP BY makerCode, modelCode";
				$list = (array)sql_query( $sql );

				return $list;
			}



			/*----------------------------------------------------
			    最小・最大の金額取得
			----------------------------------------------------*/
			function get_miniMaxprice ( $makerCode, $modelCode ) {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				// SQLインジェクション対応
				$sql_escape["makerCode"] = sql_escapeString($makerCode);
				$sql_escape["modelCode"] = sql_escapeString($modelCode);

				$sql   = "SELECT price FROM {$DBName}.carGrade WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
				$list  = sql_query( $sql );

				unset( $tbl );
				$defaultSetFlg = 0;
				for( $i=0; $i<count( $list ); $i++ ) {

					// 数値以外の場合は処理しない
					if( !is_numeric( $list[$i]["price"] ) ) { continue; }

					// 初期設定
					if( $defaultSetFlg == 0 ) {
						$tbl["mini"] = $list[$i]["price"];
						$tbl["max"]  = $list[$i]["price"];
						$defaultSetFlg = 1;
					}
					else{
						// 現在の最小値より小さければ値を入れ替える
						if( $tbl["mini"] > $list[$i]["price"] ) {
							$tbl["mini"] = $list[$i]["price"];
						}
						// 現在の最大値より大きければ値を入れ替える
						elseif( $tbl["max"] < $list[$i]["price"] ) {
							$tbl["max"] = $list[$i]["price"];
						}
					}
				}


				return array( $tbl["mini"], $tbl["max"] );
			}



			/*----------------------------------------------------
			    全長のアップデート
			----------------------------------------------------*/
			function update_modelLength () {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				// 車種リスト取得
				$modelList = $this->get_modelList();

				for( $i=0; $i<count( $modelList ); $i++ ) {
					// 最小・最大の全長取得
					list( $mini, $max ) = $this->get_miniMaxLength( $modelList[$i]["makerCode"], $modelList[$i]["modelCode"] );

					// 車種マスタ更新
					unset( $update );
					if( is_numeric( $mini ) ) {
						$update["miniTotalLength"]       = $mini;
					}
					if( is_numeric( $max ) ) {
						$update["maxTotalLength"]        = $max;
					}

					if( is_array( $update ) ) {
						// SQLインジェクション対応
						$sql_escape["makerCode"] = sql_escapeString($modelList[$i]["makerCode"]);
						$sql_escape["modelCode"] = sql_escapeString($modelList[$i]["modelCode"]);

						$sql = "UPDATE {$DBName}.model SET {update_set} WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}' ";
						sql_query( $sql, $update, "1" );
					}
				}

			}



			/*----------------------------------------------------
			    最小・最大の全長取得
			----------------------------------------------------*/
			function get_miniMaxLength ( $makerCode, $modelCode ) {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				// SQLインジェクション対応
				$sql_escape["makerCode"] = sql_escapeString($makerCode);
				$sql_escape["modelCode"] = sql_escapeString($modelCode);

				$sql  = "SELECT totalLength FROM {$DBName}.carGrade WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
				$list  = sql_query( $sql );

				unset( $tbl );
				$defaultSetFlg = 0;
				for( $i=0; $i<count( $list ); $i++ ) {

					// 数値以外の場合は処理しない
					if( !is_numeric( $list[$i]["totalLength"] ) ) { continue; }

					// 初期設定
					if( $defaultSetFlg == 0 ) {
						$tbl["mini"] = $list[$i]["totalLength"];
						$tbl["max"]  = $list[$i]["totalLength"];
						$defaultSetFlg = 1;
					}
					else{
						// 現在の最小値より小さければ値を入れ替える
						if( $tbl["mini"] > $list[$i]["totalLength"] ) {
							$tbl["mini"] = $list[$i]["totalLength"];
						}
						// 現在の最大値より大きければ値を入れ替える
						elseif( $tbl["max"] < $list[$i]["totalLength"] ) {
							$tbl["max"] = $list[$i]["totalLength"];
						}
					}
				}


				return array( $tbl["mini"], $tbl["max"] );
			}



			/*----------------------------------------------------
			    全幅のアップデート
			----------------------------------------------------*/
			function update_modelWidth () {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				// 車種リスト取得
				$modelList = $this->get_modelList();

				for( $i=0; $i<count( $modelList ); $i++ ) {
					// 最小・最大の全長取得
					list( $mini, $max ) = $this->get_miniMaxWidth( $modelList[$i]["makerCode"], $modelList[$i]["modelCode"] );

					// 車種マスタ更新
					unset( $update );
					if( is_numeric( $mini ) ) {
						$update["miniTotalWidth"]       = $mini;
					}
					if( is_numeric( $max ) ) {
						$update["maxTotalWidth"]        = $max;
					}

					if( is_array( $update ) ) {
						// SQLインジェクション対応
						$sql_escape["makerCode"] = sql_escapeString($modelList[$i]["makerCode"]);
						$sql_escape["modelCode"] = sql_escapeString($modelList[$i]["modelCode"]);

						$sql = "UPDATE {$DBName}.model SET {update_set} WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
						sql_query( $sql, $update, "1" );
					}

				}


			}



			/*----------------------------------------------------
			    最小・最大の全幅取得
			----------------------------------------------------*/
			function get_miniMaxWidth ( $makerCode, $modelCode ) {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				// SQLインジェクション対応
				$sql_escape["makerCode"] = sql_escapeString($makerCode);
				$sql_escape["modelCode"] = sql_escapeString($modelCode);

				$sql  = "SELECT totalWidth FROM {$DBName}.carGrade WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
				$list  = sql_query( $sql );

				unset( $tbl );
				$defaultSetFlg = 0;
				for( $i=0; $i<count( $list ); $i++ ) {

					// 数値以外の場合は処理しない
					if( !is_numeric( $list[$i]["totalWidth"] ) ) { continue; }

					// 初期設定
					if( $defaultSetFlg == 0 ) {
						$tbl["mini"] = $list[$i]["totalWidth"];
						$tbl["max"]  = $list[$i]["totalWidth"];
						$defaultSetFlg = 1;
					}
					else{
						// 現在の最小値より小さければ値を入れ替える
						if( $tbl["mini"] > $list[$i]["totalWidth"] ) {
							$tbl["mini"] = $list[$i]["totalWidth"];
						}
						// 現在の最大値より大きければ値を入れ替える
						elseif( $tbl["max"] < $list[$i]["totalWidth"] ) {
							$tbl["max"] = $list[$i]["totalWidth"];
						}
					}
				}


				return array( $tbl["mini"], $tbl["max"] );
			}



			/*----------------------------------------------------
			    全高のアップデート
			----------------------------------------------------*/
			function update_modelHeight () {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				// 車種リスト取得
				$modelList = $this->get_modelList();

				for( $i=0; $i<count( $modelList ); $i++ ) {
					// 最小・最大の全長取得
					list( $mini, $max ) = $this->get_miniMaxHeight( $modelList[$i]["makerCode"], $modelList[$i]["modelCode"] );

					// 車種マスタ更新
					unset( $update );
					if( is_numeric( $mini ) ) {
						$update["miniTotalHeight"]       = $mini;
					}
					if( is_numeric( $max ) ) {
						$update["maxTotalHeight"]        = $max;
					}

					if( is_array( $update ) ) {
						// SQLインジェクション対応
						$sql_escape["makerCode"] = sql_escapeString($modelList[$i]["makerCode"]);
						$sql_escape["modelCode"] = sql_escapeString($modelList[$i]["modelCode"]);

						$sql = "UPDATE {$DBName}.model SET {update_set} WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
						sql_query( $sql, $update, "1" );
					}

				}


			}



			/*----------------------------------------------------
			    最小・最大の全高取得
			----------------------------------------------------*/
			function get_miniMaxHeight ( $makerCode, $modelCode ) {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				// SQLインジェクション対応
				$sql_escape["makerCode"] = sql_escapeString($makerCode);
				$sql_escape["modelCode"] = sql_escapeString($modelCode);

				$sql  = "SELECT totalHeight FROM {$DBName}.carGrade WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
				$list  = sql_query( $sql );

				unset( $tbl );
				for( $i=0; $i<count( $list ); $i++ ) {

					// 数値以外の場合は処理しない
					if( !is_numeric( $list[$i]["totalHeight"] ) ) { continue; }

					// 初期設定
					if( $tbl["mini"] == "" && $tbl["max"] == "" ) {
						$tbl["mini"] = $list[$i]["totalHeight"];
						$tbl["max"]  = $list[$i]["totalHeight"];
					}
					else{
						// 現在の最小値より小さければ値を入れ替える
						if( $tbl["mini"] > $list[$i]["totalHeight"] ) {
							$tbl["mini"] = $list[$i]["totalHeight"];
						}
						// 現在の最大値より大きければ値を入れ替える
						elseif( $tbl["max"] < $list[$i]["totalHeight"] ) {
							$tbl["max"] = $list[$i]["totalHeight"];
						}
					}
				}


				return array( $tbl["mini"], $tbl["max"] );
			}



			/*----------------------------------------------------
			    リース料(調達価格・諸税)登録
			----------------------------------------------------*/
			function insert_lease ( $input ) {

				unset( $insert );
				$insert            = $input;

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "INSERT INTO {$DBName}.lease {insert_value}";
				list( $affected_row, $memberID ) = sql_query( $sql, $insert, "1" );

				return $memberID;
			}


			/*----------------------------------------------------
			    リース料(メンテナンス区分)登録
			----------------------------------------------------*/
			function insert_maintenance ( $input ) {

				unset( $insert );
				$insert            = $input;

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "INSERT INTO {$DBName}.maintenance {insert_value}";
				list( $affected_row, $memberID ) = sql_query( $sql, $insert, "1" );

				return $memberID;
			}


			/*----------------------------------------------------
			    リース料(調達価格・諸税)削除
			----------------------------------------------------*/
			function delete_lease () {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "DELETE FROM {$DBName}.lease";
				sql_query( $sql, "", "1" );
			}


			/*----------------------------------------------------
			    リース料(メンテナンス区分)削除
			----------------------------------------------------*/
			function delete_maintenance () {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "DELETE FROM {$DBName}.maintenance";
				sql_query( $sql, "", "1" );
			}


			/*----------------------------------------------------
			    リース料(残価・任意保険)登録
			----------------------------------------------------*/
			function insert_leaseValue ( $input ) {

				unset( $insert );
				$insert            = $input;

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "INSERT INTO {$DBName}.leaseValue {insert_value}";
				list( $affected_row, $memberID ) = sql_query( $sql, $insert, "1" );

				return $memberID;
			}


			/*----------------------------------------------------
			    リース料(残価・任意保険)削除
			----------------------------------------------------*/
			function delete_leaseValue () {

				// ＤＢ名取得
				$DBName = get_DBName( "work" );

				$sql = "DELETE FROM {$DBName}.leaseValue";
				sql_query( $sql, "", "1" );
			}


			/*----------------------------------------------------
			    ガソリン価格登録
			----------------------------------------------------*/
			function insert_gasoline ( $input ) {

				unset( $insert );
				$insert            = $input;

				// ＤＢ名取得
				$DBName = get_DBName( "base" );

				$sql = "INSERT INTO {$DBName}.gasoline {insert_value}";
				list( $affected_row, $memberID ) = sql_query( $sql, $insert, "1" );

				return $memberID;
			}


			/*----------------------------------------------------
			    ガソリン価格削除
			----------------------------------------------------*/
			function delete_gasoline () {

				// ＤＢ名取得
				$DBName = get_DBName( "base" );

				$sql = "DELETE FROM {$DBName}.gasoline";
				sql_query( $sql, "", "1" );
			}


			/*----------------------------------------------------
			    オプション登録
			----------------------------------------------------*/
			function insert_leaseOption ( $input ) {

				unset( $insert );
				$insert            = $input;

				// ＤＢ名取得
				$DBName = get_DBName( "base" );

				$sql = "INSERT INTO {$DBName}.leaseOption {insert_value}";
				list( $affected_row, $memberID ) = sql_query( $sql, $insert, "1" );

				return $memberID;
			}


			/*----------------------------------------------------
			    オプション削除
			----------------------------------------------------*/
			function delete_leaseOption () {

				// ＤＢ名取得
				$DBName = get_DBName( "base" );

				$sql = "DELETE FROM {$DBName}.leaseOption";
				sql_query( $sql, "", "1" );
			}
	}





?>