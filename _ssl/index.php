<?php


/* _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/   
                                                                      
                  NetGRID PHP Framework ver 2.0                       
                                                                      
   _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/ */


	/*----------------------------------------------------
	    faviconへのアクセスは受け付けない
	----------------------------------------------------*/
	$faviconFileRP = "/favicon.ico";
	if ( $_SERVER["PATH_INFO"] == $faviconFileRP ) { exit(); }


	/*----------------------------------------------------
	    フレーム設定
	----------------------------------------------------*/
	$path["system"]["dirName"]    = "bason";
	$path["pathAnc"]["fileName"]  = "bason.anc";
	$path["boot"]["fileName"]     = "boot.php";

    /*----------------------------------------------------
        Check Ip Address & Employee Number
    ----------------------------------------------------*/
    if ( checkIpAddress() ) {
        if ( strpos($_SERVER['REQUEST_URI'], 'salesPromotion/LOGIN?st=ef') == FALSE ) {
            if ( !checkEmployeeNumber() || strpos($_SERVER['REQUEST_URI'], 'salesPromotion/LOGIN') ) {
                header("Location: /mald/sagacite/salesPromotion/LOGIN?st=ef");
                exit;
            }
        }
    } else {
        if ( strpos($_SERVER['REQUEST_URI'], 'salesPromotion/LOGIN?st=ef') ) {
            header("Location: /mald/sagacite/");
            exit;
        }
    }

	/*----------------------------------------------------
	    基礎ディレクトリ調整と起動ファイルの読み込み
	----------------------------------------------------*/
	$path["script"]["fileAP"] = pathGlue ( "{$_SERVER['PWD']}/{$_SERVER['SCRIPT_FILENAME']}" );
	$path["script"]["dirAP"]  = preg_replace ( "#/[^/]*$#", "", $path["script"]["fileAP"] );


	// ブートファイルを探す
	if ( $path["pathAnc"]["fileName"] != "" ) {

		$thePath = $path["script"]["dirAP"];

		for ( $i = 0; $i < 100; $i++ ) {
			$thePath_anc       = pathGlue ( "$thePath/{$path["pathAnc"]["fileName"]}" );
			$thePath_systemAnc = pathGlue ( "$thePath/{$path["system"]["dirName"]}/{$path["pathAnc"]["fileName"]}" );
			if ( is_file ( $thePath_anc ) ) {
				list( $path["boot"]["dirAP"], $path["boot"]["fileAP"] ) = findTheFrameworkDir ( $thePath, $thePath_anc );
				break;
			}
			elseif ( is_file ( $thePath_systemAnc ) ) {
				$thePath_system = pathGlue ( "$thePath/{$path["system"]["dirName"]}" );
				list( $path["boot"]["dirAP"], $path["boot"]["fileAP"] ) = findTheFrameworkDir ( $thePath_system, $thePath_systemAnc );
				break;
			}
			if ( $thePath == "" ) { break; }
			$thePath = preg_replace ( "#/[^/]*$#", "", $thePath );
		}

	}

	else {
		echo "ブートファイル名が設定されていません。( {$path["boot"]["fileName"]} )\n";
		exit();
	}


	// 起動ファイルの読み込みと起動
	if ( !is_readable( $path["boot"]["fileAP"] ) || !include_once( $path["boot"]["fileAP"] ) ) {
		echo "初期ファイルがありません。( {$path["boot"]["fileAP"]} )";
		exit();
	}




	/* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	    function
	<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< */
	function pathGlue ( $path ) {

		$ret = preg_replace ( "#^(http)(s)?(://)#", "$1$2:__slashX2__", $path );
		$ret = preg_replace ( "#/{2,}#", "/", $ret );
		$ret = preg_replace ( "#/$#", "", $ret );
		$ret = preg_replace ( "#:__slashX2__#", "://", $ret );


		return $ret;

	}


	function findTheFrameworkDir ( $thePath, $thePath_anc ) {

		global $path;

		if ( filesize( $thePath_anc ) > 0 ) {
			$ancFH = fopen ( $thePath_anc, "r" );
				$pathAnc = fread ( $ancFH, filesize( $thePath_anc ) );
			fclose ( $ancFH );
		}

		$pathFWname = trim ( $pathAnc );
		$upDirCount = preg_match_all ( "#\.{2}/#", $pathFWname, $matches );

		$pathFWname = preg_replace ( "#\.{2}/#", "", $pathFWname );
		$pathFWname = preg_replace ( "#\.{1}/#", "", $pathFWname );

		for ( $i=0; $i<$upDirCount; $i++ ) {
			$thePath    = preg_replace ( "#/[^/]*$#", "", $thePath, 1 );
		}

		$bootDirAP  = pathGlue ( "{$thePath}/$pathFWname" );
		$bootFileAP = pathGlue ( "{$bootDirAP}/{$path["boot"]["fileName"]}" );

		return array ( $bootDirAP, $bootFileAP );

	}

function checkIpAddress ( $ip = null ) {
    if ( $ip == null ) {
        $ip = $_SERVER['REMOTE_ADDR']?:($_SERVER['HTTP_X_FORWARDED_FOR']?:$_SERVER['HTTP_CLIENT_IP']);
    }

    $specificIPs = array (
        '172.16.6.15', '172.16.9.11','172.16.4.16', // Miyatsu Ips
        '110.50.68.34',
        '110.50.68.47',
        '27.121.0.172',
        '106.186.200.107',
        '106.186.200.116',
        '106.186.200.117',
        '128.11.200.168',
        '180.42.26.238',
        '110.50.68.48'

    );


//** IPアドレスチェック ********************************************
		if ( strpos($_SERVER['REQUEST_URI'], '/salesPromotion/LOGIN') == TRUE ) {

			//logファイル名生成
			$logData  = date("Ymd");
			$fileName = "checkIpAddress" . "_" . $logData . ".log";

			//logファイルの保存先
			$filePath = "../log" . "/" . $fileName;

			// 開始
			$input = array(
				array("key"=> "IP", "ip" => $ip),
				array("key"=> "REQUEST_URI", "ip" => $_SERVER['REQUEST_URI']),
				array("key"=> "REMOTE_ADDR", "ip" => $_SERVER['REMOTE_ADDR']),
				array("key"=> "HTTP_X_FORWARDED_FOR", "ip" => $_SERVER['HTTP_X_FORWARDED_FOR']),
				array("key"=> "HTTP_CLIENT_IP", "ip" => $_SERVER['HTTP_CLIENT_IP']),
			);

			for( $i = 0, $iMax = count($input); $i < $iMax; $i++ ){
				$fp   = fopen( $filePath, "a" );
				$txts = "[".date("c")."] " . $input[$i]["key"] . ":" . $input[$i]["ip"] ;
				fputs( $fp, $txts . "\r\n" );
				fclose( $fp );
			}


			$fp   = fopen( $filePath, "a" );
			$txts = "[".date("c")."] ------------------------------------" ;
			fputs( $fp, $txts . "\r\n" );
			fclose( $fp );
		}
//**********************************************


    if ( in_array($ip, $specificIPs) && strpos($_SERVER['REQUEST_URI'], '/admin') == FALSE ) {
        return true;
    }
    return false;
}

function checkEmployeeNumber () {
    return $_COOKIE['employee_number'] ? $_COOKIE['employee_number'] : false;
}

?>
