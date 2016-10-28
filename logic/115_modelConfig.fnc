<?php


	/* -----------------------------------------------------
	    画像ディレクトリ 設定 一時ディレクトリ
	----------------------------------------------------- */

	// 一時ディレクトリ
	$path["modelPhoto"]["tmpDir"]               = pathGlue ( "{$path["systemRoot"]["dirAP"]}/{$path["sslDocRoot"]["dirName"]}/_common/archive/temp" );


	/* -----------------------------------------------------
	    画像ディレクトリ 設定 /PHOTO
	----------------------------------------------------- */

	// 車体画像ディレクトリ（ＷＯＲＫ）
	$path["modelPhoto"]["WORK"]["carBody"]               = pathGlue ( "{$path["httpDocRoot"]["dirAP"]}/_common/PHOTO/WORK/CARBODY" );

	// 車体画像ディレクトリ（開発環境用：ＤＢ１）
	$path["modelPhoto"]["DB1"]["carBody"]                = pathGlue ( "{$path["httpDocRoot"]["dirAP"]}/_common/PHOTO/DB1/CARBODY" );

	// 車体画像ディレクトリ（開発環境用：ＤＢ２）
	$path["modelPhoto"]["DB2"]["carBody"]                = pathGlue ( "{$path["httpDocRoot"]["dirAP"]}/_common/PHOTO/DB2/CARBODY" );


	/* -----------------------------------------------------
	    画像サイズ設定
	----------------------------------------------------- */

	// 車体画像サイズ（大）
	$ini["modelPhoto"]["carBody1"]["width"]  = 260;
	$ini["modelPhoto"]["carBody1"]["height"] = 156;

	// 車体画像サイズ（小）
	$ini["modelPhoto"]["carBody2"]["width"]  = 140;
	$ini["modelPhoto"]["carBody2"]["height"] = 84;


	/* -----------------------------------------------------
	    車種名JS
	----------------------------------------------------- */
	// ディレクトリ
	$path["modelJs"]["DB1"]["dir"]       = pathGlue ( "{$path["httpDocRoot"]["dirAP"]}/_common/carList/DB1" );
	$path["modelJs"]["DB2"]["dir"]       = pathGlue ( "{$path["httpDocRoot"]["dirAP"]}/_common/carList/DB2" );
	
	$path["modelJsSsl"]["DB1"]["dir"]    = pathGlue ( "{$path["sslDocRoot"]["dirAP"]}/_common/carList/DB1" );
	$path["modelJsSsl"]["DB2"]["dir"]    = pathGlue ( "{$path["sslDocRoot"]["dirAP"]}/_common/carList/DB2" );

	// ファイル名
	$path["modelJs"]["fileName"]  = "carlist.js";


?>
