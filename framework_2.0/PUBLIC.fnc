<?php






	/* x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-

	    共通ファンクション

	- - - - - - - - - - - - - - - - - - - - - - - - -  */


		/*----------------------------------------------------
	    配列全体に処理を行う
		----------------------------------------------------*/
		function arrayWalk_recursive ( &$value ) {

			$function = func_get_arg(1);

			if ( func_num_args() > 2 ) {
				for ( $i = 2; $i < func_num_args(); $i++ ) {
					$j = $i - 2;
					$arg[$j]   = func_get_arg($i);
					$argument .= ", \$arg[$j]";
				}
			}

			if ( is_array ( $value ) || $value != "" ) {
				if ( is_array ( $value ) ) {
					foreach ( $value as $key => $val ) {
						$eval = "arrayWalk_recursive ( \$value[\$key], \$function$argument );";
						eval ( $eval );
					}
				}
				else {
					if ( is_array ( $function ) ) {
						$class = $function[0];
						$eval = "\$return = \$class->\$function[1] ( \$value$argument );";
						eval ( $eval );
						return $return;
					}
					elseif ( is_callable ( $function ) ) {
						$eval = "\$return = $function( \$value$argument );";
						eval ( $eval );
						return $return;
					}
					else {
						global $ini;
						$ini["fwerr"][][4] = "arrayWalk_recursive :: ファンクション（$function）がありません。";
					}
				}
			}

		}




		/*----------------------------------------------------
		  配列結合function
		----------------------------------------------------*/
		function array_mix() {

			$arrTotal = array();

			for ( $i = 0; $i < func_num_args(); $i++ ) {
				$array = func_get_arg($i);
				if ( is_array ( $array ) ) {
					$arrToal = $arrTotal + $array;
					$this_eval = array_expander( $array );
					$eval .= $this_eval;
				}
			}

			// 脆弱性対応
/***初期状態*************/
//			$lines = explode( "\n", $eval );
//			for( $i=0; $i<count( $lines ); $i++ ) {
//				if( $lines[$i] == "" ) { continue; }
//				$lines[$i] = preg_replace( "# = \"#", "\a", $lines[$i] );
//				$lines[$i] = preg_replace( "#\";#", "", $lines[$i] );
//				list( $key, $value ) = explode( "\a", $lines[$i] );
//
//				$evalStr = "$key = \$value;";
//				eval( $evalStr );
//			}
/****************/
/***日刊自ver*************/
		// 脆弱性対応
		$lines = explode( "\";\n", $eval );
		for( $i=0; $i<count( $lines ); $i++ ) {
			if( $lines[$i] == "" ) { continue; }
			$lines[$i] = preg_replace( "# = \"#", "\a", $lines[$i] );
			$lines[$i] = preg_replace( "#\";#", "", $lines[$i] );
			list( $key, $value ) = explode( "\a", $lines[$i] );
			if( $key == "" ) { continue; }
			$evalStr = "$key = \$value;";
			eval( $evalStr );
		}
/****************/



			arrayWalk_recursive ( $mixed_array, 'aw_revers_question' );


			return $mixed_array;

		}


				/*----------------------------------------------------
			    配列全体に処理を行う
				----------------------------------------------------*/
				function aw_revers_question ( &$value ) {

					$chr11 = chr(11);
					$value = preg_replace ( "/$chr11/", "?", $value );

				}


		/*----------------------------------------------------
	    配列⇒テキスト
		----------------------------------------------------*/
		function array_expander( $array, $key="" ) {

			if( is_array( $array ) ) {

				$chr11 = chr(11);

				foreach( $array as $ky => $val ) {
					$key[] = $ky;
					if( is_array( $val ) ) {
						$ret_word .= array_expander( $val, $key );
					}
					else {
						// 脆弱性対応
						for( $i=0; $i<count( $key ); $i++ ) {	
							$key[$i] = addslashes( $key[$i] );
						}

						$keys = "\$mixed_array[\"" . join( "\"][\"", $key ) . "\"]";
						$val  = preg_replace ( "/\?/", $chr11, $val );
						$val  = preg_replace ( "/(?<!\\\)\"/", "\\\"", $val );
						$ret_word .= "${keys} = \"$val\";\n";
					}
					array_pop( $key );
				}
			}

			return $ret_word;

		}


		/*----------------------------------------------------
	    ファイルから拡張子を取り出す
		----------------------------------------------------*/
		function get_extention ( $file ) {

			$ext_ar = explode ( ".", $file );
			$ret = strtolower ( array_pop ( $ext_ar ) );


			return $ret;

		}


		/*----------------------------------------------------
	    エラー時の強制終了
		----------------------------------------------------*/
		function fw_exit () {

			global $ini;

			$top_msg = "何らかの理由により、システムが強制終了しました";

			if ( $ini["script"]["type"] == "bat" ) {
				for ( $i = 0; $i < count ( $ini["fwerr"] ); $i++ ) {
					for ( $j = 1; $j <= $ini["debug"]["level"]; $j++ ) {
						if ( isset ( $ini["fwerr"][$i][$j] ) ) {
							echo "&nbsp;&nbsp;" . preg_replace ( "/ /", "&nbsp;", $ini["fwerr"][$i][$j] ) . $ini["breakTag"];
						}
					}
				}
			}
			elseif ( $ini["script"]["type"] == "web" ) {
				echo "【{$top_msg}】\n<br>\n";
				for ( $i = 0; $i < count ( $ini["fwerr"] ); $i++ ) {
					for ( $j = 1; $j <= $ini["debug"]["level"]; $j++ ) {
						if ( isset ( $ini["fwerr"][$i][$j] ) ) {
							echo "  {$ini["fwerr"][$i][$j]}{$ini["breakTag"]}<br>\n";
						}
					}
				}
			}

			exit();

		}


		/*----------------------------------------------------
		    リスト設定ファイルの取り込み
		----------------------------------------------------*/
		function read_conf_file ( $fullpath ) {

			// ファイルを読み込む
			$file = file_get_contents ( $fullpath );

			// コメント行ははずす
			$file = preg_replace( "#\r\n?#", "\n", $file );
			$file = preg_replace( "#(?<!\\\)/\*(.|\n)+?(?<!\\\)\*/#", NULL, $file );
			$file = preg_replace( "#(?<!\\\)//.*#", NULL, $file );
			$file = preg_replace( "#\n{2,}#", "\n", $file );
//			$file = preg_replace( "# *#", "", $file );
			$file = preg_replace( "#\\\/#", "/", $file );
			$file = trim ( $file );

			return $file;

		}




		/*---------------------------------------------------------
		    ディレクトリがなければ生成しつつファイルをコピー
		---------------------------------------------------------*/
		function copyFile ( $src, $dst ) {

			if ( is_dir ( $src ) ) {
				global $class;
				$srclist = $class["framework"]->scandir_4 ( $src, "file" );

				for ( $i = 0; $i < count ( $srclist ); $i++ ) {
					$src_path = pathGlue( "$src/$srclist[$i]" );
					$dst_path = pathGlue( "$dst/$srclist[$i]" );
					make_dir_for_copy ( $dst_path );
					copyFileSingle ( $src_path, $dst_path );
				}

			}

			else {
				make_dirForCopy ( $dst );
				copyFileSingle ( $src, $dst );
			}

		}


		function make_dirForCopy ( $dst ) {

			$dir = explode ( "/", $dst );

			for ( $i = 1; $i < count ( $dir ) - 1; $i++ ) {
				$fullpath .= "/$dir[$i]";
				if ( !is_dir ( $fullpath ) ) {
					umask(0);
					mkdir  ( $fullpath, 0775 );
				}
			}

		}


		function copyFileSingle ( $src, $dst ) {

			if ( $src != "" && $dst != "" ) {
				@copy ( $src, $dst );
			}
			else {
				global $ini;
				$ini["fwerr"][][2] = "コピーファイルの指定が間違っています。";
				$ini["fwerr"][][3] = "SRC：$src";
				$ini["fwerr"][][3] = "DST：$dst";
			}

		}




		/*---------------------------------------------------------
		    セレクト、チェックを入れる
		---------------------------------------------------------*/
		function set_checked ( $searchList, $hitValue, $checkKey, $checkedLetter="checked" ) {

			if ( is_array ( $searchList ) ) {
				foreach ( $searchList as $k => $v ) {
					if ( is_array ( $hitValue ) ) {
						foreach ( $hitValue as $hk => $hv ) {
							if ( $v[$checkKey] == $hv ) {
								$searchList[$k][$checkedLetter] = 1;
							}
						}
					}
					else {
						if ( $v[$checkKey] == $hitValue ) {
							$searchList[$k][$checkedLetter] = 1;
						}
					}
				}
			}

			return $searchList;
		}




		/*---------------------------------------------------------
		    設定リストのIDを探して、その名を返す
		---------------------------------------------------------*/
		function get_nameFromMaster ( $searchList, $hitValue, $checkKey, $returnKey ) {

			if ( is_array ( $searchList ) ) {
				foreach ( $searchList as $k => $v ) {
					if ( $hitValue == $v[$checkKey] ) {
						return $v[$returnKey];
					}
				}
			}

		}




		/*----------------------------------------------------
		    乱数文字列の生成
		----------------------------------------------------*/
		function create_randomString ( $len = 8, $case="" ) {

			srand( ( double ) microtime() * 48918731 );
			if ( $case == "upper" ) {
				$strings     = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			}
			elseif ( $case == "lower" ) {
				$strings     = "abcdefghijklmnopqrstuvwxyz";
			}
			else {
				$strings     = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456790";
			}
			$ar_strings  = preg_split("//", $strings, 0, PREG_SPLIT_NO_EMPTY);

			for ( $i = 0; $i < $len; $i++ ) {
				$randStr .= $ar_strings[array_rand ( $ar_strings, 1 )];
			}

			return $randStr;

		}




		/*----------------------------------------------------
		    CSVファイルを読み込む
		----------------------------------------------------*/
		function fgetcsv_reg (&$handle, $length = null, $d = ',', $e = '"') {

			$d = preg_quote($d);
			$e = preg_quote($e);
			$_line = "";

			while ($eof != true) {
				$_line .= (empty($length) ? fgets($handle) : fgets($handle, $length));
				$itemcnt = preg_match_all('/'.$e.'/', $_line, $dummy);
				if ($itemcnt % 2 == 0) $eof = true;
			}

			$_csv_line = preg_replace('/(?:\r\n|[\r\n])?$/', $d, trim($_line));
			$_csv_pattern = '/('.$e.'[^'.$e.']*(?:'.$e.$e.'[^'.$e.']*)*'.$e.'|[^'.$d.']*)'.$d.'/';
			preg_match_all($_csv_pattern, $_csv_line, $_csv_matches);
			$_csv_data = $_csv_matches[1];

			for($_csv_i=0;$_csv_i<count($_csv_data);$_csv_i++){
				$_csv_data[$_csv_i]=preg_replace('/^'.$e.'(.*)'.$e.'$/s','$1',$_csv_data[$_csv_i]);
				$_csv_data[$_csv_i]=str_replace($e.$e, $e, $_csv_data[$_csv_i]);
			}


			return empty($_line) ? false : $_csv_data;

		}




		/*----------------------------------------------------
		    日本語対応シリアライズ
		----------------------------------------------------*/
		function ngdfw_serialize ( $value ) {

			arrayWalk_recursive ( $value, "aw_urlEncode" );
			$ngdfw_serialize = serialize ( $value );

			return $ngdfw_serialize;

		}




		/*----------------------------------------------------
		    日本語対応「アン」シリアライズ
		----------------------------------------------------*/
		function ngdfw_unserialize ( $value ) {

			$ngdfw_serialize = unserialize ( $value );
			arrayWalk_recursive ( $ngdfw_serialize, "aw_urlDecode" );

			return $ngdfw_serialize;

		}




		/*----------------------------------------------------
		    url encode
		----------------------------------------------------*/
		function aw_urlEncode ( &$value ) {

			$value = urlencode ( $value );

		}




		/*----------------------------------------------------
		    url encode
		----------------------------------------------------*/
		function aw_urlDecode ( &$value ) {

			$value = urldecode ( $value );

		}


	/* -------------------------------------
		ページ送り
		リスト取得前処理
		(引数)
		$rowsPerPage: 1ページあたりの最大表示件数
		$pageNum    : 表示対象のページ番号
		(戻り値)
		$pageNum    : 表示対象のページ番号
		$pageInfo   : ページ情報
	------------------------------------- */
	function preAdjust_pageState ( $rowsPerPage, $pageNum=1 ) {

		// 表示ページとしてゼロ以下を渡された場合は1に強制的にセット
		$pageNum = ( $pageNum < 1 ) ? 1 : $pageNum;

		// 何件目から表示するか
		$pageInfo["limitStart"] = $rowsPerPage * ( $pageNum - 1 );

		return array( $pageNum, $pageInfo );

	}

	/*---------------------
	ページ数部分
	(引数)
	$maxCount: 対象データの最大件数
	$maxLine:  １ページあたりの最大表示件数
	$pageNum:  表示対象のページ番号
	
	(戻り値)以下配列で戻す
	["totalCount"]: 対象データの最大件数
	["prevNum"]:    前のページ番号
	["nextNum"]:    次のページ番号
	["rangeStart"]: 表示するリストの最初のカウント数
	["nextCount"]:  次頁リスト件数

	----------------------*/
	function adjust_pageState ( $maxCount, $maxLine, $pageNum=1 ) {

		global $ini;

		$pageNum = $pageNum == NULL ? 1 : $pageNum;

		if( $pageNum < 1 ){
			$pageNum = 1;
		}

		$ret["totalCount"] = $maxCount;
		$ret["totalPageCount"] = @ceil ( $maxCount / $maxLine );

		$ret["prevCount"] = $maxLine;

		// ページ数制限越え調整
		$ret["pageNum"] = ( $pageNum - 1 ) * $maxLine - $maxCount >= 0 && $pageNum > 1 ? $ret["totalPageCount"] : $pageNum;

		// 残りの数
		$remainResult   = $maxCount > ( $ret["pageNum"] * $maxLine ) ? $maxCount - ( $ret["pageNum"] * $maxLine ) : 0;


		// 【前×；次○】前ページはなく、次ページが存在する場合
		if ( $ret["pageNum"] == 1 && ( $maxLine - ( $maxLine * $ret["pageNum"] ) ) >= 0 && $remainResult > 0 ) {
			$ret["nextPage"] = $ret["pageNum"] + 1;
			$ret["nextCount"] = $maxLine > $remainResult ? $remainResult : $maxLine;
		}
		// 【前○；次○】前も次ページも存在する場合
		elseif ( $ret["pageNum"] > 1 && ( $maxCount - ( $maxLine * $ret["pageNum"] ) ) > 0 ){
			$ret["prevPage"]  = $ret["pageNum"] - 1;
			$ret["nextPage"]  = $ret["pageNum"] + 1;
			$ret["nextCount"] = $maxLine > $remainResult ? $remainResult : $maxLine;
		}
		// 【前○；次×】前は存在するが、次ページは存在しない場合
		elseif ( $maxLine <= $maxCount ) {
			$ret["prevPage"]  = $ret["pageNum"] - 1;
		}
		// 【前×；次×】前は存在するが、次ページは存在しない場合は設定ナシ
		elseif ( $ret["totalPageCount"] == 1 ) {
			$ret["pageOne"]  = 1;
		}

		// 実際に表示される件数範囲
		$ret["limitStart"] = ( $ret["pageNum"] -1 ) * $maxLine;


		// 表示範囲
		$ret["rangeStart"] = $ret["limitStart"] + 1;
		$ret["rangeEnd"] = $pageNum < ceil ( $maxCount / $maxLine ) ? $maxLine : $maxCount - ( $ret["pageNum"] - 1 ) * $maxLine;
		$ret["rangeEnd"] = ( $pageNum - 1 ) * $maxLine + $ret["rangeEnd"];
		$ret["rangeOne"] = $ret["rangeStart"] == $ret["rangeEnd"] ? 1 : 0;



		// ページリスト
		$ini["pageNumberLimit"] = (int)$ini["pageNumberLimit"];
		if ( $ret["totalPageCount"] > $ini["pageNumberLimit"] * 2 ) {
			// ページ番号の後ろにLIMIT分ない場合
			if ( $ret["pageNum"] > $ret["totalPageCount"] - $ini["pageNumberLimit"] ) {
				$start = $ret["totalPageCount"] - $ini["pageNumberLimit"] * 2 - 1;
				$end   = $ret["totalPageCount"];
				$dotSet = "end";
			}
			// ページ番号の前にLIMIT分ない場合
			elseif ( $ret["pageNum"] <= $ini["pageNumberLimit"] ) {
				$start = 0;
				$end   = $ini["pageNumberLimit"] * 2 + 1;
				$dotSet = "front";
			}
			// 前後にあまりがある場合
			else {
				$start = $ret["pageNum"] - $ini["pageNumberLimit"] - 1;
				$end   = $start + $ini["pageNumberLimit"] * 2 + 1;
				$dotSet = "both";
			}
		}
		else {
			$start = 0;
			$end   = $ret["totalPageCount"];
			$dotSet = "non";
		}



		$c = 0;

		for ( $i = $start; $i < $end; $i++ ) {

			$dispPage = $i + 1;
			$ret["pageList"][$c]["pageNum"]  = $dispPage;
			$ret["pageList"][$c]["pageDisp"] = $dispPage;

			switch ( $dotSet ) {
				case "end":
					if ( $i == $start ) {
						$ret["pageList"][$c]["pageDisp"] = "..." . $dispPage;
					}
					break;
				case "front":
					if ( $i == $end - 1 ) {
						$ret["pageList"][$c]["pageDisp"] = $dispPage . "...";
					}
					break;
				case "both":
					if ( $i == $start ) {
						$ret["pageList"][$c]["pageDisp"] = "..." . $dispPage;
					}
					if ( $i == $end - 1 ) {
						$ret["pageList"][$c]["pageDisp"] = $dispPage . "...";
					}
					break;
				default:
					$ret["pageList"][$c]["pageDisp"] = $dispPage;
			}

			if ( $ret["pageNum"] == $dispPage ) {
				$ret["pageList"][$c]["checked"] = 1;
			}

			$c++;

		}

		// 最初のページ、最後のページフラグのセット
		if( count( $ret["pageList"] ) > 0 ) {
			for( $i=0; $i<count( $ret["pageList"] ); $i++ ) {
				if( $ret["pageList"][$i]["pageNum"] == 1 ) {
					$unsetPageFirst = 1;
				}
				if( $ret["pageList"][$i]["pageNum"] == $ret["totalPageCount"] ) {
					$unsetPageLast = 1;
				}
			}
			if( $unsetPageFirst != 1 ) {
				$ret["pageFirst"] = 1;
			}
			if( $unsetPageLast != 1 ) {
				$ret["pageLast"]  = $ret["totalPageCount"];
			}
		}


		return $ret;

	}










	/* - - - - - - - - - - - - - - - - - - - - - - - - - -

	    共通ファンクション（終わり）

	x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-  */





?>