<?php


	/*----------------------------------------------------
	  テンプレート管理クラス
	----------------------------------------------------*/
	class template_class {




		/*----------------------------------------------------
		  ＨＴＭＬ出力（外部から呼出し）
		----------------------------------------------------*/
		function attach_template( $filePath, $output=NULL ) {

			global $ini, $class, $path;

			// 画像ファイル
			if ( $ini["view"] == "jpeg" || $ini["view"] == "gif" || $ini["view"] == "png" ) {
				$jpgFH = fopen ( $path["template"]["fileAP"], "r" );
					$jpgFile = fread ( $jpgFH, filesize ( $path["template"]["fileAP"] ) );
				fclose ( $jpgFH );
				return $jpgFile;
			}

			// クラス内で共有変数
			$this->output   = $output;
			$this->root_dir = $path["templateRoot"]["dirAP"];

			// 入力によるシステムエラー
			if ( $ini["system"]["errRank"] == 1 ) {
				$filePath = $path["template"]["inputError"]["fileAP"];
			}
			elseif ( $filePath == 404 ) {
				$logDat[] = 404;
				$class["log"]->systemLog ( __file__, "err", $logDat );
				$filePath = $path["template"]["notFound"]["fileAP"];
			}
			else {
				$filePath = $filePath == "" ? $this->set_template_file( $status ) : $this->set_template_file( "", $filePath );
			}

			// ベースファイルの読み込み
			if ( !( $this->html = @file_get_contents( $filePath ) ) ) {
				$ini["fwerr"][][2] = "Template :: テンプレートファイルがありません。";
				$ini["fwerr"][][3] = "  $filePath";
				fw_exit();
			}


			// 前部 文字調整
			$this->html = $this->pre_adjust_strings( $this->html );


			$this->parseCount = 100;

			while ( $this->parseCount > 0 ) {

				$this->cnt_dynRes = 0;
				$this->parseCount--;

				// ■■■■ parsing ■■■■

				// file文の実行
				$this->html = $this->file_parse( $this->html, $filePath );

				// var の変換
				$this->var_parse();

				// dbTicket の変換
				$this->dbTicket_parse();

				// input の実行
				$this->input_parse();

				// val の変換
				$this->val_parse();

				// loop の変換
				$this->loop_parse();

				// loop_expand の変換
				$this->loop_expand_parse();

				// set の変換
				$this->set_parse();

				// loop_count の変換
				$this->loop_count_parse();

				// setLoop の変換
				$this->setLoop();

				// padLoopHead の変換
				$this->padLoopHead();

				// padLoopTail の変換
				$this->padLoopTail();

				// コメントをはずす
				$this->drop_comment();

				// showval
				$this->showval();

				// 一旦EVALする
				$this->html = $this->doEval();

				// 動的ファイルがなかった場合
				if ( $this->cnt_dynRes == 0 ) { break; }

				//  ■■■■■■■■■■■■

			}

			// val の変換
			$this->val_parse();

			// PHP eval の実行
			if ( $this->output["DEBUG"] != "on" ) {
				$output = $this->doEval();
			}
			else {
				echo $this->html;
			}

			// 後部 文字調整
			$output = $this->final_adjust_strings( $output );

			// 文字コード変換
			$output = mb_convert_encoding( $output, $ini["jp_encoding"] );

			return $output;

		}


		/*----------------------------------------------------
		  eval実行
		----------------------------------------------------*/
		function doEval() {

			$show_php = 0;
//			$show_php = 59;

			if ( $show_php > 0 ) {
				echo $this->html;
			}

			else {
				ob_start();
					eval( '?>' . $this->html );
					$php = ob_get_contents();
				ob_end_clean();
			}

			return $php;

		}


		/*----------------------------------------------------
		  前部 文字調整
		----------------------------------------------------*/
		function pre_adjust_strings( $html ) {

			// 検索文字列のエスケープ
			$html = preg_replace( "/(\\\)(\d+)/", "&#165;$2", $html );

			// 改行コード変換
			$html = preg_replace( "/(\r\n)/", "\n", $html );
			$html = preg_replace( "/\r/", "\n", $html );

			// トリム
			$html = preg_replace( "/^\n*/", "", $html );
			$html = preg_replace( "/\n*$/", "", $html );

			// 余計な文字の削除
			if (ord($html{0}) == 0xef && ord($html{1}) == 0xbb && ord($html{2}) == 0xbf) {
				$html = substr($html, 3);
			}

			// テンプレート用タグ記号変換
			$html = preg_replace( "/<\?/", chr(11), $html );
			$html = preg_replace( "/\?>/", chr(12), $html );

			return $html;

		}


		/*----------------------------------------------------
		  後部 文字調整
		----------------------------------------------------*/
		function final_adjust_strings( $html ) {

			// テンプレート用タグ記号変換
			$html = preg_replace( "/".chr(11)."/", "<?php", $html );
			$html = preg_replace( "/".chr(12)."/", "?>", $html );

			return $html;

		}


		/*----------------------------------------------------
		  テンプレートファイルバスの設定
		----------------------------------------------------*/
		function set_template_file( $status="", $filePath="" ) {

			global $ini, $path;

			switch ( $status ) {

				case "login":
					$ret = pathGlue ( "{$path["templateRoot"]["dirAP"]}/{$path["loginRoot"]["dirName"]}/{$path["loginTmp"]["fileName"]}" );
					break;

				case "logout":
					$ret = pathGlue ( "{$path["templateRoot"]["dirAP"]}/{$path["loginRoot"]["dirName"]}/{$path["logoutTmp"]["fileName"]}" );
					break;

				case "loginLockout":
					$ret = pathGlue ( "{$path["templateRoot"]["dirAP"]}/{$path["loginRoot"]["dirName"]}/{$path["loginLockoutTmp"]["fileName"]}" );
					break;

				case "":
					if ( is_file ( $filePath ) ) { $ret = $filePath; }
					break;

				default:
					$ret = pathGlue ( "{$path["templateRoot"]["dirAP"]}/{$path["unit"]["dirRP"]}/${status}.tmp" );
					$ret = preg_replace ( "/\.tmp\.tmp$/", ".tmp", $ret );

			}


			return pathGlue( $ret );

		}


// ■■■■■■■■■■■■■■■■■■■■ PARSES ■■■■■■■■■■■■■■■■■■■■


		/*----------------------------------------------------
		  file文の実行
		----------------------------------------------------*/
		function file_parse( $html, $filePath ) {

			global $path;

			// file の読み込みと当て込み
			$html = $this->file_parse_exec( $html, $filePath );

			// frameの実行
			list( $file_dir, $file_name ) = $this->path_setting( $filePath );
			$html = $this->frame_parse( $html, $file_dir );


			return $html;

		}

				/*----------------------------------------------------
				  file文の実行
				----------------------------------------------------*/
				function file_parse_exec( $html, $filePath ) {

					global $path;

					// 該当文字列の取得
					preg_match_all( "/(?<!\\\)\{file\s+([^{}]+)\}/i", $html, $result, PREG_SET_ORDER );

					while ( list( , $match ) = @each( $result ) ) {

						// 親ファイルのベースディレクトリとファイル名の取得
						list( $parent_local_dir, $parent_file_name ) = $this->path_setting( $filePath );

						// 子ファイルのベースディレクトリ設定
						$dir = ( preg_match( "#^/#", $match[1] ) ) ? $this->root_dir : $parent_local_dir;
						$child_filePath = pathGlue( $dir . $match[1] );

						unset ( $file );

						if ( is_file( $child_filePath ) ) {

							// 子ファイルのベースディレクトリとファイル名の取得
							list( $child_local_dir, $child_file_name ) = $this->path_setting( $child_filePath );

							// ファイルリストの保存
							$this->file_list[] = array(
								"parent_local_dir"  => $parent_local_dir,
								"parent_file_name"  => $parent_file_name,
								"child_local_dir"   => $child_local_dir,
								"child_file_name"   => $child_file_name
							);

							// ファイル内容の取得
							$file = file_get_contents( $child_filePath );

							// 前部 文字調整
							$file = $this->pre_adjust_strings( $file );

							// ■■ 再帰 ■■  更にfile文があればそれを取り込む
							if ( preg_match( "/\{file\s+([^\}]+)\}/", $file ) ) {
								$file = $this->file_parse_exec( $file, $child_filePath );
							}

							$file = $this->frame_parse( $file, $parent_local_dir );

						}

						// 置換の実行
						$html = preg_replace ( "#$match[0]#", $file, $html );

					}

					preg_match_all( "/((?<!\\\)\{file\s+)(.*(\{val\s+[^}]+\}))+([^}]*\})/i",  $html, $dynRes, PREG_SET_ORDER );

					$dirRP = preg_replace ( "#^{$path["templateRoot"]["dirAP"]}|/[^/]*$#", "", $filePath );
					$dirRP = $dirRP != "" ? $dirRP."/" : "";

					$this->cnt_dynRes += count( $dynRes );

					while ( list( , $match ) = @each( $dynRes ) ) {
						if ( !preg_match ( "#^\{file $dirRP#", $match[0] ) && !preg_match ( "#^/#", $match[2] ) ) {
							$html = preg_replace( "#{$match[0]}#", "$match[1]$dirRP$match[2]$match[4]", $html );
						}
					}


					return $html;

				}

				/*----------------------------------------------------
				  ベースディレクトリ移動設定
				----------------------------------------------------*/
				function path_setting( $local_path ) {

					// ファイル文の取得
					preg_match_all( "#(.*)([^/]*$)#iU", $local_path, $result, PREG_SET_ORDER );

					return array( $result[0][1], $result[0][2] );

				}


		/*----------------------------------------------------
		  frameの実行
		----------------------------------------------------*/
		function frame_parse( $html, $filePath ) {

			// 該当文字列の取得
			preg_match_all( "/(?<!\\\)\{frame\s+([^\}]+)\}/i", $html, $result, PREG_SET_ORDER );

			// 検索結果を分割
			list( , $match ) = @each( $result );

			// ヒットしていれば
			if ( $match[1] != "" ) {

				// フレームパスの設定
				$dir = ( preg_match( "#^/#", $match[1] ) ) ? $this->root_dir : $filePath;
				$frame_path = pathGlue( "$dir/$match[1]" );

				if ( is_file( $frame_path ) ) {

					// ベースディレクトリの調整
					list( $this->base_dir, $frame_file_name ) = $this->path_setting( $frame_path );

					// フレームの読み込み
					$frame = file_get_contents( $frame_path );

					// 前部 文字調整
					$frame = $this->pre_adjust_strings( $frame );

					// file の読み込みと当て込み
					$frame = $this->file_parse_exec( $frame, $frame_path );

					// ■■ 再帰 ■■  更にframe文があればそれを処理を繰り返す
					if ( preg_match( "/\{frame\s+([^\}]+)\}/", $frame ) ) {
						$file_add = "$filePath/".preg_replace ( "#/[^/]+$#", "", $match[1] );
						$filePath = pathGlue( $file_add );
						$frame = $this->frame_parse( $frame, $filePath );
					}

				}

				// アタッチの実行
				$html = preg_replace( "#\{attach\}(\n)?#", $html, $frame );

				// フレーム文の削除
				$html = preg_replace( "#$match[0](\n)?#", "", $html );

			}

			return $html;

		}


		/*----------------------------------------------------
		  input文の実行
		----------------------------------------------------*/
		function input_parse() {

			// テンプレートタグ文字列の取得
			// サイトマップの文字対応のため応急的に修正。日本語不完全対応（田村）
			preg_match_all( "/(?<!\\\)\{input\s+?((.|\n)*[^\\\\])\}/iU", $this->html, $result, PREG_SET_ORDER );

			while ( list( , $match ) = @each( $result ) ) {

				// 変数名と値の取得
				list( $key, $value ) = explode( "=", $match[1] );
				$value = mb_ereg_replace( "^\"|\"$", "", $value );
				$value = addslashes( $value );
				preg_match_all ( "#([^/|\.]+)([/.])?#", $key, $refex );

				unset ( $refs );
				for ( $i = 0; $i < count ( $refex[1] ); $i++ ) {
					unset ( $glue );
					if ( isset ( $refex[1][$i+1] ) ) {
						if ( $i == 0 ) {
							$cnts = $refex[1][$i] . $refex[2][$i] . $refex[1][$i+1];
						}
						else {
							$cnts .= $refex[2][$i] . $refex[1][$i+1];
						}
						if ( $refex[2][$i] == "/" ) {
							$glue = "[" . sprintf( "%d", $count[$cnts] ) . "]";
						}
						$count[$cnts]++;
					}
					$refs .= "[\"" . $refex[1][$i] . "\"]" . $glue;
				}

				$eval = "\$this->output$refs=\"$value\";";
				eval( $eval );

				// input文の削除
//				$ma = quotemeta ( $match[0] );
				$ma = $match[0];
				$ma = preg_replace ( "/\|/", "\\\|", $ma );
				$ma = preg_replace ( "/\{/", "\\\{", $ma );
				$ma = preg_replace ( "/\}/", "\\\}", $ma );
				$ma = preg_replace ( "/\(/", "\\\(", $ma );
				$ma = preg_replace ( "/\)/", "\\\)", $ma );

				$this->html = mb_ereg_replace( "$ma(\n)?", "", $this->html );

			}

		}


		/*----------------------------------------------------
		  var文の変換
		----------------------------------------------------*/
		function var_parse() {

			// テンプレートタグ文字列の取得
			preg_match_all( "/(?<!\\\)\{var\s+([^\}]+)\}/i", $this->html, $result, PREG_SET_ORDER );

			// valタイプの特定（配列の場合のみ判断する）
			while ( list( , $match ) = @each( $result ) ) {
				list ( $arr, $modify ) = preg_split ( "#\|#", $match[1] );

				unset ( $arkeys );
				unset ( $arval );

				preg_match_all ( "#([^/|\.]+)([/.])?#", $arr, $refex );

				if ( count ( $refex[1] ) == 1 && preg_match ( "#^\"[^\"]+\"$#", $refex[1][0] ) ) {
					$arvalue = "\"".preg_replace ( "#^\"|\"$#", "", $refex[1][0] )."\"";
				}
				else {
					for ( $i = 0; $i < count ( $refex[1] ); $i++ ) {
						$arkeys[] = $refex[1][$i];
						$arkey    = join ( ":", $arkeys );
						$arcnt    = "\$i[\"$arkey\"]";
						$arval   .= "[\"{$refex[1][$i]}\"]";
						if ( $refex[2][$i] == "/" ) {
							$arval   .= ( $j == count( $refex[1] ) - 1 ) ? NULL : "[$arcnt]";
						}
					}
					$arvalue = "\$this->output$arval";
				}

				// 変数をPHP化
				if ( !isset( $modify ) ) {
					$eval = "<?php \$putval=$arvalue; ?>";
				}
				else {
					list ( $modifier, $param ) = preg_split ( "/:/", $modify, 2 );
					$param_count = count ( $this->parameter );
					if ( $param != "" ) {
						$this->parameter[$param_count] = explode ( ":", $param );
					}
					$putval = "<?php \$putval=\$this->modifier_return_val(\"$modifier\",$arvalue,\$this->parameter[$param_count]); ?>";
				}
				eval( '?>' . $eval );

				// 置換の実行
				$ma = quotemeta ( $match[0] );
				$ma = preg_replace ( "/\|/", "\\\|", $ma );

				$this->html = preg_replace( "#(?<!\\\)$ma#", $putval, $this->html );
			}

		}


		/*----------------------------------------------------
		  dbTicket文の変換
		----------------------------------------------------*/
		function dbTicket_parse() {

			// テンプレートタグ文字列の取得
			preg_match_all( "/(?<!\\\)\{dbTicket\}/i", $this->html, $result, PREG_SET_ORDER );

			// dbTicketタイプの特定（配列の場合のみ判断する）
			if ( $result[0][0] == "{dbTicket}" ) {
				global $ini;
				if ( $ini["dbTicket"]["full"] == "" ) {
					issue_dbTicket();
				}
				$this->html = preg_replace( "#(?<!\\\)\{dbTicket\}#", "<input type=\"hidden\" name=\"dbTicket\" value=\"{$ini["dbTicket"]["full"]}\">", $this->html );
			}

		}


		/*----------------------------------------------------
		  val文の変換
		----------------------------------------------------*/
		function val_parse() {

			// テンプレートタグ文字列の取得
			preg_match_all( "/{val\s+([^\}]+)\}/i", $this->html, $result, PREG_SET_ORDER );

			// valタイプの特定（配列の場合のみ判断する）
			while ( list( , $match ) = @each( $result ) ) {

				list ( $arr, $modify ) = preg_split ( "#\|#", $match[1], 2 );

				unset ( $arkeys );
				unset ( $arval );

				preg_match_all ( "#([^/|\.]+)([/.])?#", $arr, $refex );

				if ( count ( $refex[1] ) == 1 && preg_match ( "#^\"[^\"]+\"$#", $refex[1][0] ) ) {
					$arvalue = "\"".preg_replace ( "#^\"|\"$#", "", $refex[1][0] )."\"";
				}
				else {
					for ( $i = 0; $i < count ( $refex[1] ); $i++ ) {
						$arkeys[] = $refex[1][$i];
						$arkey    = join ( ":", $arkeys );
						$arcnt    = "sprintf(\"%d\",\$i[\"$arkey\"])";
						$arval   .= "[\"{$refex[1][$i]}\"]";
						if ( $refex[2][$i] == "/" ) {
							$arval   .= ( $j == count( $refex[1] ) - 1 ) ? NULL : "[$arcnt]";
						}
					}
					$arvalue = "\$this->output$arval";
				}

				// 変数をPHP化
				if ( !isset( $modify ) ) {
					$putval = "<?php echo $arvalue; ?>";
				}
				else {
					$modifyList = preg_split ( "#\|#", $modify, 2 );
					$modifyCount = count ( $this->modifyCall );
					for ( $i=0; $i<count($modifyList); $i++ ) {
						list ( $modifier, $param ) = preg_split ( "/:/", $modifyList[$i], 2 );
						$this->modifyCall[$modifyCount]["modifier"][] = $modifier;
						$this->modifyCall[$modifyCount]["param"][]    = explode ( ":", $param );
					}
					$putval = "<?php \$this->modifier_echo_val(\$this->modifyCall[$modifyCount][\"modifier\"],$arvalue,\$this->modifyCall[$modifyCount][\"param\"]); ?>";
				}

				// 置換の実行
				$ma = quotemeta ( $match[0] );
				$ma = preg_replace ( "/\|/", "\\\|", $ma );

				$this->html = preg_replace( "#$ma#", $putval, $this->html );
			}

		}


		/*----------------------------------------------------
		  modifierの変換 :: echo
		----------------------------------------------------*/
		function modifier_echo_val ( $function, $value, $param=NULL ) {

			for ( $i=0; $i<count($function); $i++ ) {
				$modFnc = "MODIFIER_" . $function[$i];
				if ( !is_callable ( $modFnc ) && is_callable ( $function[$i] ) ) {
					$modFnc = $function[$i];
				}
				$eval = "\$value = $modFnc ( \$value, \$param[$i] );";
				eval ( $eval );
			}

			echo $value;

		}


		/*----------------------------------------------------
		  modifierの変換 :: return
		----------------------------------------------------*/
		function modifier_return_val ( $function, $value, $param=NULL ) {

			if ( is_callable ( $function ) ) {
				if ( isset ( $param ) ) {
					$ret = $function ( $value, $param );
				}
				else {
					$ret = $function ( $value );
				}
				return $ret;
			}

			else {
				$mod_fnc = "MODIFIER_" . $function;
				if ( is_callable ( $mod_fnc ) ) {
					$ret = @$mod_fnc ( $value, $param );
					return $ret;
				}
			}

		}


		/*----------------------------------------------------
		  loop文の変換
		----------------------------------------------------*/
		function loop_parse() {

			// テンプレートタグ文字列の取得
			preg_match_all( "/(?<!\\\)<!--\{(r)?loop\s+([^\}]+)\}-->/i", $this->html, $result, PREG_SET_ORDER );

			// 配列部分（変数部分の後部）の生成
			while ( list( , $match ) = @each( $result ) ) {
				$arr = $match[2];

				unset ( $arkeys );
				unset ( $arval );

				preg_match_all ( "#([^/|\.]+)([/.])?#", $arr, $refex );

				for ( $i = 0; $i < count ( $refex[1] ); $i++ ) {
					$arkeys[] = $refex[1][$i];
					$arkey    = join ( ":", $arkeys );
					$arcnt    = "\$i[\"$arkey\"]";
					$arval   .= "[\"{$refex[1][$i]}\"]";
					if ( $refex[2][$i] == "/" ) {
						$arval   .= "[$arcnt]";
					}
					$arvalTotal = preg_replace ( "/\"\]$/", "_", $arval );
					$loop_i   = $arcnt;
				}

				// 置換の実行
				$ma = quotemeta ( $match[0] );
				$ma = preg_replace ( "/\|/", "\\\|", $ma );
				if( preg_match( "/^<!--\{rloop/", $ma ) ) {
					$this->html = preg_replace( "#(?<!\\\)$ma(\n)?#", "<?php \$this->output{$arvalTotal}TOTAL\"] = count( \$this->output$arval ); for ( $loop_i = count( \$this->output$arval ) - 1; $loop_i >= 0; $loop_i-- ) { \$this->output{$arval}[{$loop_i}][\"COUNT\"] = $loop_i; ?>", $this->html );
				}
				else {
					$this->html = preg_replace( "#(?<!\\\)$ma(\n)?#", "<?php \$this->output{$arvalTotal}TOTAL\"] = count( \$this->output$arval ); for ( $loop_i = 0; $loop_i < count( \$this->output$arval ); $loop_i++ ) { \$this->output{$arval}[{$loop_i}][\"COUNT\"] = $loop_i; ?>", $this->html );
				}
			}

			// ループ閉じタグを置換する
			$this->html = preg_replace( "/(?<!\\\)<!--\{\/(r)?loop}-->(\n)?/", "<?php } ?>", $this->html );

		}


		/*----------------------------------------------------
		  loop文中の値の展開
		----------------------------------------------------*/
		function loop_expand_parse() {

			// テンプレートタグ文字列の取得
			preg_match_all( "/(?<!\\\)\{loop_expand\s+([^\}]+)\}/i", $this->html, $result, PREG_SET_ORDER );

			// 配列部分（変数部分の後部）の生成
			while ( list( , $match ) = @each( $result ) ) {
				list( $key, $value ) = explode( "=", $match[1] );
				$value = mb_ereg_replace( "^\"|\"$", "", $value );
				$value = addslashes( $value );


				unset ( $arkeys );
				unset ( $arval );

				preg_match_all ( "#([^/|\.]+)([/.])?#", $value, $refex );

				for ( $i = 0; $i < count ( $refex[1] ); $i++ ) {
					$arkeys[] = $refex[1][$i];
					$arkey    = join ( ":", $arkeys );
					$arcnt    = "\$i[\"$arkey\"]";
					$arval   .= "[\"{$refex[1][$i]}\"]";
					if ( $refex[2][$i] == "/" ) {
						$arval   .= "[$arcnt]";
					}
					$loop_i   = $arcnt;
				}

				// 置換の実行
				$ma = quotemeta ( $match[0] );
				$ma = preg_replace ( "/\|/", "\\\|", $ma );
				$eval = "<?php unset( \$this->output[\"$key\"] ); \$this->output[\"$key\"] = \$this->output${arval}[\$i$arval]; ?>";
				$this->html = preg_replace( "#(?<!\\\)$ma(\n)?#", $eval, $this->html );

			}

		}


		/*----------------------------------------------------
		  set文の変換
		----------------------------------------------------*/
		function set_parse() {

			// テンプレートタグ文字列の取得
			preg_match_all( "/(?<!\\\)<!--\{(un)?set\s+([^\}]+)\}-->/i", $this->html, $result, PREG_SET_ORDER );

			while ( list( , $match ) = @each( $result ) ) {
				list ( $arr, $modifier ) = preg_split ( "#\|#", $match[2] );

				unset ( $arkeys );
				unset ( $arval );

				preg_match_all ( "#([^/|\.]+)([/.])?#", $arr, $refex );

				for ( $i = 0; $i < count ( $refex[1] ); $i++ ) {
					$arkeys[] = $refex[1][$i];
					$arkey    = join ( ":", $arkeys );
					$arcnt    = "\$i[\"$arkey\"]";
					$arval   .= "[\"{$refex[1][$i]}\"]";
					if ( $refex[2][$i] == "/" ) {
						$arval   .= ( $j == count( $refex[1] ) - 1 ) ? NULL : "[$arcnt]";
					}
				}

				// 変数をPHP化
				if ( !isset( $modifier ) ) {
					$setval = "unset( \$setvalue ); if ( isset( \$this->output$arval ) ) { \$setvalue = \$this->output$arval; }";
				}
				else {
					$setval = "unset( \$setvalue ); if ( isset( \$this->output$arval ) ) { \$setvalue = \$this->modifier_echo_val( \"$modifier\", \$this->output$arval ); }";
				}

				// 置換の実行
				$ma = quotemeta ( $match[0] );
				$ma = preg_replace ( "/\|/", "\\\|", $ma );

				switch( $match[1] ) {

					default:     // SET の置換
						$this->html = preg_replace( "#(?<!\\\)$ma\n?#", "<?php ${setval}if ( ( \$setvalue != \"0\" && \$setvalue != \"\" ) || ( is_array( \$setvalue ) && count( \$setvalue ) > 0 ) ) { ?>", $this->html );
						break;

					case "un":   // UNSET の置換
						$this->html = preg_replace( "#(?<!\\\)$ma\n?#", "<?php ${setval}if ( ( \$setvalue == \"0\" || \$setvalue == \"\" ) && !( is_array( \$setvalue ) && count( \$setvalue > 0 ) ) ) { ?>", $this->html );

				}

			}

			// セット閉じタグを置換する
			$this->html = preg_replace( "/(?<!\\\)<!--\{\/(un)?set}-->(\n)?/", "<?php } ?>\n", $this->html );

		}


		/*----------------------------------------------------
		  loop_count文の変換
		----------------------------------------------------*/
		function loop_count_parse() {

			// テンプレートタグ文字列の取得
			preg_match_all( "/(?<!\\\)<!--\{loop_count_([a-z]+)?\s+([^\!=]+)(\!|=)(\d+)?\/?(-?\d+)?\}-->/i", $this->html, $result, PREG_SET_ORDER );

			while ( list( , $match ) = @each( $result ) ) {

				if ( ( $match[3] != "!" && $match[3] != "=" ) || $match[4] < 0 ) { continue; }

				unset ( $arkeys );
				unset ( $arval );

				preg_match_all ( "#([^/|\.]+)([/.])?#", $match[2], $refex );

				for ( $i = 0; $i < count ( $refex[1] ); $i++ ) {
					$arkeys[] = $refex[1][$i];
					$arkey    = join ( ":", $arkeys );
					$arcnt    = "\$i[\"$arkey\"]";
					$arval   .= "[\"{$refex[1][$i]}\"]";
					if ( $refex[2][$i] == "/" ) {
						$arval   .= ( $j == count( $refex[1] ) - 1 ) ? NULL : "[$arcnt]";
					}
				}

				// 置換の実行
				switch ( $match[1] ) {
					case "head":
					case "tail":
					case "between":
						switch ( $match[1] ) {
							case "head":
								$this->html = preg_replace( "#(?<!\\\)$match[0](\n)?#", "<?php if ( $arcnt % $match[4] == 0 ) { ?>", $this->html );
								break;
							case "tail":
								$this->html = preg_replace( "#(?<!\\\)$match[0](\n)?#", "<?php if ( $arcnt % $match[4] == $match[4] - 1 || $arcnt == count( \$this->output$arval ) - 1 ) { ?>", $this->html );
								break;
							case "between":
								if ( $match[4] <= 1 ) {
									$this->html = preg_replace( "#(?<!\\\)$match[0](\n)?#", "<?php if ( $arcnt != count( \$this->output$arval ) - 1 ) { ?>", $this->html );
								}
								else {
									$this->html = preg_replace( "#(?<!\\\)$match[0](\n)?#", "<?php if ( $arcnt % $match[4] != $match[4] - 1 && $arcnt != count( \$this->output$arval ) - 1 ) { ?>", $this->html );
								}
								break;
						}
						// ループ閉じタグを置換する
						$this->html = preg_replace( "/(?<!\\\)<!--\{\/loop_count_$match[1]?\}-->(\n)?/", "<?php } ?>", $this->html );
						break;
					case "pad":
						$this->html = preg_replace( "#(?<!\\\)$match[0](\n)?#", "<?php if ( !isset( \$pad_i$arval ) ) { \$pad_i$arval = ceil( count( \$this->output$arval ) / $match[4] ) * $match[4] - count ( \$this->output$arval ); } if ( ( $arcnt == count( \$this->output$arval ) - 1 ) && ( \$pad_i$arval > 0 ) ) { for( \$pad_i4$arval = 0; \$pad_i4$arval < \$pad_i$arval; \$pad_i4$arval++ ) { ?>", $this->html );
						// ループ閉じタグを置換する
						$this->html = preg_replace( "/(?<!\\\)<!--\{\/loop_count_$match[1]?\}-->(\n)?/", "<?php } } ?>", $this->html );
						break;
				}

			}


		}


		/*----------------------------------------------------
		  setLoop文の変換
		----------------------------------------------------*/
		function setLoop() {

			// テンプレートタグ文字列の取得
			preg_match_all( "/(?<!\\\)<!--\{(un)?setLoop\s+([^\!=]+)\s*(\!|=)\s*(\d+)?\/?(\+?-?\d+)?(t?h?)\}-->/i", $this->html, $result, PREG_SET_ORDER );

			while ( list( $key, $value ) = each( $result ) ) {

				list( $tag, $un, $variable, $eq, $count, $slip, $headTail ) = $value;
				$slip = sprintf ( "%d", $slip );

				if ( !is_numeric( $count ) || $count < 0 ) { continue; }

				unset ( $arkeys );
				unset ( $arval );

				preg_match_all ( "#([^/|\.]+)([/.])?#", $variable, $refex );

				for ( $i = 0; $i < count ( $refex[1] ); $i++ ) {
					$arkeys[] = $refex[1][$i];
					$arkey    = join ( ":", $arkeys );
					$arcnt    = "\$i[\"$arkey\"]";
					$arval   .= "[\"{$refex[1][$i]}\"]";
					if ( $refex[2][$i] == "/" ) {
						$arval   .= ( $j == count( $refex[1] ) - 1 ) ? NULL : "[$arcnt]";
					}
				}

				// 最初と最後の処理
				$tag = preg_replace ( "/\+/", "\\\+", $tag );
				unset( $htval );
				if ( $un != "un" ) {
					switch ( $headTail ) {
						case "h":
							$htval = " || $arcnt % $count == 0";
							break;
						case "t":
							$htval = " || $arcnt == count( \$this->output$arval ) - 1";
							break;
						case "ht":
							$htval = " || $arcnt % $count == 0 || $arcnt == count( \$this->output$arval ) - 1";
							break;
					}
					// 置換の実行
					if ( $slip < 0 ) {
						$this->html = preg_replace( "#(?<!\\\)$tag(\n)?#", "<?php if ( $arcnt % $count == abs( $count$slip ) $htval ) { ?>", $this->html );
					}
					elseif ( $slip == 0 ) {
						$this->html = preg_replace( "#(?<!\\\)$tag(\n)?#", "<?php if ( $arcnt % $count == 0 $htval ) { ?>", $this->html );
					}
					else {
						$this->html = preg_replace( "#(?<!\\\)$tag(\n)?#", "<?php if ( $arcnt % $count == $slip $htval ) { ?>", $this->html );
					}
				}
				else {
					switch ( $headTail ) {
						case "h":
							$htval = " && $arcnt % $count !=0";
							break;
						case "t":
							$htval = " && $arcnt != count( \$this->output$arval ) - 1";
							break;
						case "ht":
							$htval = " && $arcnt % $count !=0 && $arcnt != count( \$this->output$arval ) - 1";
							break;
					}
					// 置換の実行
					if ( $slip < 0 ) {
						$this->html = preg_replace( "#(?<!\\\)$tag(\n)?#", "<?php if ( $arcnt % $count != abs( $count$slip ) $htval ) { ?>", $this->html );
					}
					elseif ( $slip == 0 ) {
						$this->html = preg_replace( "#(?<!\\\)$tag(\n)?#", "<?php if ( $arcnt % $count != 0 $htval ) { ?>", $this->html );
					}
					else {
						$this->html = preg_replace( "#(?<!\\\)$tag(\n)?#", "<?php if ( $arcnt % $count != $slip $htval ) { ?>", $this->html );
					}
				}

			}

			// 閉じタグを置換する
			$this->html = preg_replace( "/(?<!\\\)<!--\{\/(un)?setLoop\}-->(\n)?/", "<?php } ?>", $this->html );

		}


		/*----------------------------------------------------
		  padLoopHead文の変換
		----------------------------------------------------*/
		function padLoopHead() {

			// テンプレートタグ文字列の取得
			preg_match_all( "/(?<!\\\)<!--\{padLoopHead\s+([^\!=]+)\s*(\!|=)\s*(\d+)?\/?(\+?-?\d+)?\}-->/i", $this->html, $result, PREG_SET_ORDER );

			while ( list( $key, $value ) = each( $result ) ) {

				list( $tag, $variable, $eq, $count ) = $value;

				if ( !is_numeric( $count ) || $count < 0 ) { continue; }

				unset ( $arkeys );
				unset ( $arval );

				preg_match_all ( "#([^/|\.]+)([/.])?#", $variable, $refex );

				for ( $i = 0; $i < count ( $refex[1] ); $i++ ) {
					$arkeys[] = $refex[1][$i];
					$arkey    = join ( ":", $arkeys );
					$arcnt    = "\$i[\"$arkey\"]";
					$arval   .= "[\"{$refex[1][$i]}\"]";
					if ( $refex[2][$i] == "/" ) {
						$arval   .= ( $j == count( $refex[1] ) - 1 ) ? NULL : "[$arcnt]";
					}
				}

				$arcntUP      = preg_replace ( "/:[^:]*$/", "\"]", $arcnt );
				$arvalNum     = $arval."[$arcnt]";

				// 置換の実行
				$this->html = preg_replace( "#(?<!\\\)$tag(\n)?#", "<?php if(($arcnt==0||\$this->padHead[$arcntUP]==1)&&count(\$this->output$arvalNum)<2){\$this->padHead[$arcntUP]=1; ?>", $this->html );

			}

			// 閉じタグを置換する
			$this->html = preg_replace( "/(?<!\\\)<!--\{\/padLoopHead\}-->(\n)?/", "<?php }else{\$this->padHead[$arcntUP]=0;} ?>", $this->html );

		}


		/*----------------------------------------------------
		  padLoopTail文の変換
		----------------------------------------------------*/
		function padLoopTail() {

			// テンプレートタグ文字列の取得
			preg_match_all( "/(?<!\\\)<!--\{padLoopTail\s+([^\!=]+)\s*(\!|=)\s*(\d+)?\/?(\+?-?\d+)?\}-->/i", $this->html, $result, PREG_SET_ORDER );

			while ( list( $key, $value ) = each( $result ) ) {

				list( $tag, $variable, $eq, $count ) = $value;

				if ( !is_numeric( $count ) || $count < 0 ) { continue; }

				unset ( $arkeys );
				unset ( $arval );

				preg_match_all ( "#([^/|\.]+)([/.])?#", $variable, $refex );

				for ( $i = 0; $i < count ( $refex[1] ); $i++ ) {
					$arkeys[] = $refex[1][$i];
					$arkey    = join ( ":", $arkeys );
					$arcnt    = "\$i[\"$arkey\"]";
					$arval   .= "[\"{$refex[1][$i]}\"]";
					if ( $refex[2][$i] == "/" ) {
						$arval   .= ( $j == count( $refex[1] ) - 1 ) ? NULL : "[$arcnt]";
					}
				}

				$arcntUP      = preg_replace ( "/:[^:]*$/", "\"]", $arcnt );
				$arvalNum     = $arval."[$arcnt]";

				// 置換の実行
				$this->html = preg_replace( "#(?<!\\\)$tag(\n)?#", "<?php if($arcnt==count(\$this->output$arval)-1){\$pad_i$arval=ceil(count(\$this->output$arval)/$count)*$count-count(\$this->output$arval);for(\$pad_i4=0;\$pad_i4<\$pad_i$arval;\$pad_i4++){\$this->output$arval"."[][\"COUNT\"]=$arcnt+\$pad_i4;}} ?>", $this->html );

			}

			// 閉じタグを置換する
			$this->html = preg_replace( "/(?<!\\\)<!--\{\/padLoopTail\}-->(\n)?/", "<?php  ?>", $this->html );


		}


		/*----------------------------------------------------
		  コメントをはずす
		----------------------------------------------------*/
		function drop_comment() {

			$this->html = preg_replace ( "/\n?(?<!\\\)\{\*([^(\*\})]+)\*\}\n?/", "", $this->html );

		}




		/*----------------------------------------------------
		  showval実行
		----------------------------------------------------*/
		function showval() {

			$showval = "<pre>" . print_r($this->output, true) . "</pre>";

			$this->html = preg_replace( "/\{showval\}/", $showval, $this->html );

		}






























	}





?>