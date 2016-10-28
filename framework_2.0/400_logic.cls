<?php




	/*====================================================*
	      ロジッククラス
	 *====================================================*/


	class logicClass {



		/*----------------------------------------------------
		    ロジックの実行
		----------------------------------------------------*/
		function callLogic () {

			global $path, $ini, $input, $justInput, $output, $class, $status, $actc, $viewStatus, $theClass;

			// ロジック実行
			if ( is_file ( $path["logic"]["fileAP"] ) && is_readable ( $path["logic"]["fileAP"] ) ) {

				// ■■ ロジックの読み込み ■■

				    include ( $path["logic"]["fileAP"] );

				// ■■■■■■■■■■■■■■

			}
			else {
			}

		}


		/*----------------------------------------------------
		    コントロールロジックの実行
		----------------------------------------------------*/
		function callCTRL ( $inputStatus=NULL ) {

			global $path, $ini, $input, $justInput, $output, $class, $status, $actc, $viewStatus, $theClass;

			// ステイタス調整
			if ( $inputStatus != NULL ) { $status = $inputStatus; }

			$viewStatus = $viewStatus == "" ? $status : $viewStatus;

			// ロジックファイル名の生成
			$path["ctrlLogic"]["fileName"] = "CTRL_{$status}.lgc";
			$path["ctrlLogic"]["fileAP"]   = pathGlue ( "{$path["unit"]["dirAP"]}/{$path["ctrlLogic"]["fileName"]}" );

			// ロジック実行
			if ( is_file ( $path["ctrlLogic"]["fileAP"] ) && is_readable ( $path["ctrlLogic"]["fileAP"] ) ) {

				// ■■ ロジックの読み込み ■■
				    $inputCheckGroup = $ini["actionInputList"][$status];
				    include ( $path["ctrlLogic"]["fileAP"] );

				// ■■■■■■■■■■■■■■

			}
			else {

			}


			return $status;

		}



		/*----------------------------------------------------
		    プロセスロジックの実行
		----------------------------------------------------*/
		function callPROC ( $procName=NULL ) {

			global $path, $ini, $input, $justInput, $output, $class, $actc, $theClass;

			// ロジックファイル名の生成
			$path["procLogic"]["fileName"] = "PROC_{$procName}.lgc";
			$path["procLogic"]["fileAP"]   = pathGlue ( "{$path["unit"]["dirAP"]}/{$path["procLogic"]["fileName"]}" );

			// ロジック実行
			if ( is_file ( $path["procLogic"]["fileAP"] ) && is_readable ( $path["procLogic"]["fileAP"] ) ) {

				// ■■ ロジックの読み込み ■■

				    include ( $path["procLogic"]["fileAP"] );

				// ■■■■■■■■■■■■■■

			}
			else {
				// error
			}


			return $status;

		}



		/*----------------------------------------------------
		    VIEWロジックの実行
		----------------------------------------------------*/
		function callVIEW( $viewName=NULL ) {

			global $path, $ini, $input, $justInput, $output, $class, $actc, $viewStatus, $theClass;

			// ロジックファイル名の生成
			$path["viewLogic"]["fileName"] = "VIEW_{$viewName}.lgc";
			$path["viewLogic"]["fileAP"]   = pathGlue ( "{$path["unit"]["dirAP"]}/{$path["viewLogic"]["fileName"]}" );

			// ロジック実行
			if ( is_file ( $path["viewLogic"]["fileAP"] ) && is_readable ( $path["viewLogic"]["fileAP"] ) ) {

				// ■■ ロジックの読み込み ■■

				    include ( $path["viewLogic"]["fileAP"] );

				// ■■■■■■■■■■■■■■

			}
			else {
				// error
			}


			$viewStatus = $viewStatus == "" ? $status : $viewStatus;


			return $status;

		}



	}


?>