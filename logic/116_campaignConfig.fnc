<?php


	/* -----------------------------------------------------
	    画像ディレクトリ 設定 一時ディレクトリ
	----------------------------------------------------- */

	// 一時ディレクトリ
	$path["campaignPhoto"]["tmpDir"]               = pathGlue ( "{$path["systemRoot"]["dirAP"]}/{$path["sslDocRoot"]["dirName"]}/_common/archive/temp" );


	/* -----------------------------------------------------
	    画像拡張子 設定 /PHOTO
	----------------------------------------------------- */

	// キャンペーン画像（ＢＡＳＥ）
	$path["campaignPhoto"]["extension"][] = ".jpg";
	$path["campaignPhoto"]["extension"][] = ".png";



	/* -----------------------------------------------------
	    画像ディレクトリ 設定 /PHOTO
	----------------------------------------------------- */

	// キャンペーン画像ディレクトリ（ＢＡＳＥ）
	$path["campaignPhoto"]["campaign"]            = pathGlue ( "{$path["httpDocRoot"]["dirAP"]}/_common/PHOTO/CAMPAIGN" );


?>
