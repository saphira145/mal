<?php


	/*----------------------------------------------------
	  SEO
	----------------------------------------------------*/
	class seo_class {




		/*----------------------------------------------------
		  SEO設定
		----------------------------------------------------*/
		function seo_class() {

			global $ini, $path, $class, $viewStatus;

			// 読み込み対象ファイルリストの取得
			for ( $i = 0; $i < count( $class["framework"]->dirPathListStep["externalFile"] ); $i++ ) {

				// フィールド設定ファイル名は固定なので、パスはすぐに決定できる
				$fullpath = $class["framework"]->dirPathListStep["externalFile"][$i] . "/" . $path["seoList"]["fileName"];

				// 対象ファイルが存在すれば・・・
				if ( is_readable ( $fullpath ) ) {

					// 対象ファイルを設定ファイルとして読み込む
					$fieldConf   = file_get_contents ( $fullpath );

					// ファイルを解析
					if ( $this->analyze_seoList( $fieldConf ) ) {
						$scriptURL = $path["unit"]["actionRPs"];
						while ( $scriptURL != "" ) {
							if ( is_array( $this->list[$path["protocol"]][$scriptURL] ) ) {
								$this->seo = $this->list[$path["protocol"]][$scriptURL];
								break;
							}
							if ( $ini["actionFlag"]["ix"] == 1 ) {
								$scriptURLix = preg_replace ( "#/\?[^/]*$|{$ini["actionIX"]}$|/$#", "", $scriptURL );
								$scriptURLix = preg_replace ( "#/$#", "", $scriptURLix );
								$scriptURLix = $scriptURLix == "" ? "/" : $scriptURLix;
								$this->seo = $this->list[$path["protocol"]][$scriptURLix];
								break;
							}
							$scriptURL = preg_replace ( "#/[^/]*$#", "", $scriptURL );
						}
					}
				}

			}


			$this->add_outputToSEO();

		}





		function analyze_seoList( $fieldConf=NULL ) {

			if ( $fieldConf == NULL ) { return false; }

			// 改行コード統一 (無駄ループさせないため)
			$fieldConf = str_replace( "\r", "\n", str_replace( "\r\n", "\n", $fieldConf ) );
			$line = preg_split ( "/[\n\r]/", $fieldConf );

			for ( $i=0; $i<count( $line ); ++$i ) {
				if ( preg_match ( "#(^http(s)?)|(^/)#", $line[$i], $match ) ) {
					if ( preg_match ( "#^http(s)?#", $line[$i], $match ) ) {
						$theLine = preg_replace ( "#(\s|\t)*#", "", $line[$i] );
						list ( $http, $url ) = explode ( "," , $theLine );
					}
					else {
						$http = "none";
						$url = trim ( $line[$i] );
					}
					$url = preg_replace ( "#/$#", "", $url );
					$url = $url == "" ? "/" : $url;
					$this->list["http"][$url]["source"] = $line[$i];
					continue;
				}
				elseif ( preg_match ( "/^\t/", $line[$i] ) ) {
					list ( $head, $contents ) = explode ( "=", $line[$i] );
					$head     = trim ( $head );
					$contents = trim ( $contents );
					while ( preg_match( '/^"([^"]*)$/', $contents ) ) {
						$i++;
						$contents .= "\n" . $line[$i];
					}
					$contents = preg_replace ( "/^\"|\"$/", "", $contents );
					if ( $http == "http" || $http == "none" ) {
						$this->list["http"][$url][$head]=$contents;
					}
					if ( $http == "https" || $http == "none" ) {
						$this->list["https"][$url][$head]=$contents;
					}
					continue;
				}

			}


			return ture;

		}




		function add_outputToSEO () {

			global $output;

			if ( is_array ( $this->seo ) && count ( $this->seo ) > 0 ) {

				$outputSEO = $this->seo;

				if ( is_array ( $output["SEO"] ) ) {

					foreach ( $output["SEO"] as $key => $val ) {
						$outputSEO[$key] = $val;
						$flag_preSEO = 1;
					}

				}

				$output["SEO"] = $outputSEO;

			}

		}

	}





?>