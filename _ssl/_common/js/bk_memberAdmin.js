
	/*-----------------------------------------------
	  ページ切り替え
	------------------------------------------------*/
	function move_page( num ) {

		var objName = "pageNum";
		document.form_search.elements[objName].value = num;
		document.form_search.submit();

		return false;
	}

	/*-----------------------------------------------
	  form内のクリア
	------------------------------------------------*/
	function clear_form( objForm ) {

		for( var i=0; i<objForm.elements.length; i++ ) {
			var type = objForm.elements[i].type;


			switch( type ){
				case "text":
					objForm.elements[i].value = "";
					break;
				case "textarea":
					objForm.elements[i].value = "";
					break;
				case "select-one":
					for( var k=0; k<objForm.elements[i].options.length; k++ ) {
						objForm.elements[i].options[k].selected = false;
					}
					objForm.elements[i].options.selectedIndex = 0;
					break;
				case "select-multiple":
					for( var k=0; k<objForm.elements[i].options.length; k++ ) {
						objForm.elements[i].options[k].selected = false;
					}
					break;
				case "radio":

					break;
				case "checkbox":
					objForm.elements[i].checked = false;
					break;
				case "hidden":
					break;
				case "button":
				case "submit":
					break;
			}
		}

	}

	/*-----------------------------------------------
	  ランダムログインIDの設定
	------------------------------------------------*/
	function setLoginID( length ){
		var loginID = document.form_main.elements["memberInfo[loginID]"].value;

		// 所属グループの取得
		var salesGroup   = window.document.getElementsByName('memberInfo[salesGroup]')[0];
		var salesGroupID = salesGroup.options[salesGroup.selectedIndex].value;

		// 権限レベルの取得
		var authorityLevel   = window.document.getElementsByName('memberInfo[authorityLevel]')[0];
		var authorityLevelID = authorityLevel.options[authorityLevel.selectedIndex].value;

		if(authorityLevelID == '100' && salesGroupID != '0' && !loginID){
			var randomString = makeRandom( length );
			document.form_main.elements["memberInfo[loginID]"].value = randomString;
		}
	}

	/*-----------------------------------------------
	  ランダムパスワードの設定
	------------------------------------------------*/
	function setPassWord( length ){
		var randomString = makeRandom( length );

		// パスワード項目に代入
		document.form_main.elements["memberInfo[password]"].value        = randomString;
		document.form_main.elements["memberInfo[passwordConfirm]"].value = randomString;
		window.document.getElementById('makePassword').innerHTML       = randomString;
	}


	/*-----------------------------------------------
	  ランダム文字列の作成
	------------------------------------------------*/
	function makeRandom( length ){
		var baseString   = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		var baseNum      = baseString.length;
		var randomString = '';

		//文字列生成
		for(var i=0; i<length; i++) {
		    randomString += baseString.charAt( Math.floor( Math.random() * baseNum));
		}

		return randomString;
	}


	/*-----------------------------------------------
	  有効期限の制御
	------------------------------------------------*/
	function setExpirationDayAction(){
		var expirationDay = true;
		var salesGroupFlg = false;
		var levelFlg      = false;
		var dayMsg       = "期限切れ";

		// 所属グループの取得
		var salesGroup   = window.document.getElementsByName('memberInfo[salesGroup]')[0];
		var salesGroupID = salesGroup.options[salesGroup.selectedIndex].value;

		if(salesGroupID == '0'){
			salesGroupFlg = true;
		}

		// ステータスの取得
		var level   = window.document.getElementsByName('memberInfo[level]')[0];
		var levelID = level.options[level.selectedIndex].value;

		if( levelID == '100' || ( salesGroupFlg && !levelID ) ){
			levelFlg      = true;
		}

		// パスワード有効日数のプルダウン制御
		if( salesGroupFlg || levelFlg ){
			expirationDay = false;
		}

		// パスワード有効日数のプルダウン
		if( expirationDay ){
			// 有効
			window.document.getElementById('memberInfo[expirationDay]').disabled = false;
			window.document.getElementById('expirationDayHid').disabled          = true;
			setExpirationDay();
		} else {
			// 無効
			var expirationDay     = window.document.getElementsByName('memberInfo[expirationDay]')[0];
			var expirationDayID   = expirationDay.options[expirationDay.selectedIndex].value;

			// メッセージ作成
			if( salesGroupFlg && !levelFlg ){
				dayMsg = "期限なし";
			}

			window.document.getElementById('memberInfo[expirationDay]').disabled = true;
			window.document.getElementById('expirationDayHid').disabled          = false;
			window.document.getElementById('expirationDayHid').value             = expirationDayID;
			window.document.getElementById('expirationDays').innerHTML           = dayMsg;
			window.document.getElementById('memberInfo[expirationDay]').value    = expirationDayID;
		}
	}


	/*-----------------------------------------------
	  有効日数の表示設定
	------------------------------------------------*/
	function setExpirationDay(){
		// ステータスの取得
		var expirationDay     = window.document.getElementsByName('memberInfo[expirationDay]')[0];
		var expirationDays    = expirationDay.options[expirationDay.selectedIndex].id;
		var expirationDayID   = expirationDay.options[expirationDay.selectedIndex].value;
		var expirationDayName = expirationDays.replace(/-/g, "/");
		var setHiduke         = expirationDays.split("-");

		// 日付の比較
		var hiduke = new Date();
		var year   = hiduke.getFullYear();
		var month  = hiduke.getMonth()+1;
		var day    = hiduke.getDate();

		var now    = new Date(year, month, day);
		var setDay = new Date(setHiduke[0], setHiduke[1], setHiduke[2]);

		if(now.getTime() == setDay.getTime()){
			dayMsg = "本日まで";
		} 
		else if(now.getTime() > setDay.getTime()){
			dayMsg = "期限切れ";
		} 
		else {
			dayMsg = expirationDayName + " まで";
		}

		window.document.getElementById('expirationDays').innerHTML             = dayMsg;
		window.document.getElementById('memberInfo[expirationDatetime]').value = expirationDays;
		window.document.getElementById('expirationDayHid').value               = expirationDayID;

	}

