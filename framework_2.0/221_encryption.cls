<?php


	class encryption_class {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function encryption_class () {

		}


		/*----------------------------------------------------
		    ソルト作成
		----------------------------------------------------*/
		function get_makeSalt() {
			$length   = 22;
			$charList = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
			$cnt       = 0;
			$maxCnt    = 10;

			// 登録済みソルトの取得
			$sql = "SELECT salt from sessionMember ";
			$result = sql_query( $sql );
			//$result = array_unique($ret);

			for( $i = 0; $i < count($result); $i++ ){
				$addSalt[$result[$i]["salt"]] = 1;
			}

			// ソルト作成
			do{
				// 無限ループ回避の為、一定回数を超えたら終了とする
				if( $cnt >= $maxCnt ){
					break;
				}

				$salt     = "";
				$salt  = substr(str_shuffle($charList), 0, $length);
				//for ($i = 0; $i < $length; $i ++) {
				//	$point = mt_rand(0, strlen($charList) - 1);
				//	$salt .= substr($charList, $point, 1);
				//}

				// 重複チェック
				if( isset($addSalt[$salt]) ){
					$salt = "";
				}
				$cnt++;

			}while($salt);

			return $salt;
		}


		/*----------------------------------------------------
		   ハッシュ作成
		----------------------------------------------------*/
		function get_makeHash( $password , $salt ) {

			if( empty($salt) ){
				return null;
			}

			// 固定文字によるソルト
			$textSalt = "MitsubishiAutoLeaseCarSagacite2013";

			// より強固な暗号化を行う
			for( $i = 0; $i < 2; $i++ ){
				$password = crypt( $password, "$2a$12$" . $textSalt . "$" );
				$password = crypt( $password, "$2a$12$" . $salt . "$" );
			}

			return substr($password, 7);
		}


		/*----------------------------------------------------
		  ハッシュチェック
		----------------------------------------------------*/
		function check_hashEquals( $addHash, $inputHash ){
			$res = $addHash ^ $inputHash;
			$ret = 0;
			for ($i = 0; $i < 60; $i++) {
				$ret += ord($res[$i]);
			}
			return $ret === 0;
		}

	}
?>