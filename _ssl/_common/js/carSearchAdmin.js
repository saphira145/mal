
	/*-----------------------------------------------
	  車種グレード検索画面の表示
	------------------------------------------------*/
	function openCarGradeSearchWindow(g_windowName,makerCode,modelCode,baseDir) {
		baseDir=(typeof(baseDir)!=='string')?'':baseDir;
		var searchVar = "";
		if( modelCode != null && makerCode != null ){
			searchVar = "?searchModelCode=" + modelCode + "&searchMakerCode=" + makerCode;
		}
		window.open(baseDir+'/admin/carGradeSearch/'+searchVar, g_windowName, 'width=1070,height=700,scrollbars=yes');
		return false;
	}

	/*-----------------------------------------------
	  車種検索画面の表示
	------------------------------------------------*/
	var openWndow = [];
	function openCarSearchWindow(st, g_windowName, bodyType ){

		// ウィンドウが存在している場合、フォーカスを当てる
		if( openWndow[g_windowName] && !openWndow[g_windowName].closed ){
			openWndow[g_windowName].focus();
			return false;
		}

		if( !openWndow[g_windowName] ){
			openWndow.splice(g_windowName,g_windowName);
		}

		var searchVar = "";
		var url = window.document.getElementById('url').value;
		if( bodyType != null ){
			// ステータス=有効／無効で新規登録の場合、アラートを表示する
			var statusType   = window.document.getElementsByName('themeInfo[statusType]')[0];
			var statusTypeID = statusType.options[statusType.selectedIndex].value;

			if( window.document.getElementById('themeID') ){
				var themeID = window.document.getElementById('themeID').value;
			} 
			else if(statusTypeID != '200'){
				for( var i =0; i < statusType.length; i++ ){
					if( statusType.options[i].value == '200'){
						var statusTypeName = statusType.options[i].text;
						break;
					}
				}
				alert("ステータスが" + statusTypeName + "ではない為、おすすめ車種を設定する事が出来ません。");
				return false;
			}

			var themeID = (statusTypeID == '200') ? '' : themeID + "/";
			searchVar = themeID + searchVar + "?searchBodyType=" + bodyType;
		}
		openWndow[g_windowName] = window.open(url+'/admin/carModelSearch/' + st + '/' + searchVar, g_windowName, 'width=1070,height=700,scrollbars=yes');

		return false;
	}





	/*-----------------------------------------------
	  車種グレード選択(親画面の該当項目に車種名を表示)
	------------------------------------------------*/
	function setCarGrade( carGradeID ) {

		if(!window.opener || window.opener.closed){
			//親ウィンドウが存在しない
			window.close();
		} else{
			var g_window = window.name;

			// 名称の取得
			var g_makerName     = window.document.getElementById( 'makerName[' + carGradeID + ']').value;
			var g_modelName     = window.document.getElementById( 'modelName[' + carGradeID + ']').value;
			var g_grade         = window.document.getElementById( 'grade[' + carGradeID + ']').value;
			var g_totalEmission = window.document.getElementById( 'totalEmission[' + carGradeID + ']').value;
			var g_driveSystem   = window.document.getElementById( 'driveSystem[' + carGradeID + ']').value;
			var g_bodyModel     = window.document.getElementById( 'bodyModel[' + carGradeID + ']').value;
			var g_capacity      = window.document.getElementById( 'capacity[' + carGradeID + ']').value;
			var g_price         = window.document.getElementById( 'price[' + carGradeID + ']').value;
			var g_mainte        = window.document.getElementById( 'mainte[' + carGradeID + ']').value;
			var g_transmissionType = window.document.getElementById( 'transmissionType[' + carGradeID + ']').value;
			var g_roofModel        = window.document.getElementById( 'roofModel[' + carGradeID + ']').value;
			var g_useFuel          = window.document.getElementById( 'useFuel[' + carGradeID + ']').value;
			var g_door             = window.document.getElementById( 'door[' + carGradeID + ']').value;

			var id_carGradeID    = "modelInfo[" + g_window + "CarGradeID]";
			var id_carGradeName  = "modelInfo[" + g_window + "CarGradeName]";
			var id_delBtn        = "delBtn_" + g_window;

			var msg_r1 = "車種グレードＩＤ ：" + carGradeID + "&nbsp;、 メンテナンス区分：" + g_mainte;
			var msg_r2 = g_makerName + "　" + g_modelName + "　" + g_grade;
			var msg_r3 = g_bodyModel + "、" + g_driveSystem + "、" + g_transmissionType + "、" + g_roofModel + "、" + g_useFuel + "、" + g_totalEmission + "、" + g_capacity + "、" + g_door + "、" + g_price;


			if( window.opener.document.getElementById(id_carGradeName) ){
				window.opener.document.getElementById(id_carGradeName).innerHTML = msg_r1 + "<br>" + msg_r2 + "<br>" + "[ " + msg_r3 + " ]";
				window.opener.document.getElementById(id_carGradeID).value       = carGradeID;
				window.opener.document.getElementById(id_delBtn).disabled        = false;
			}
			window.close();
		}
	}


	/*-----------------------------------------------
	  車種選択(親画面の該当項目に車種名を表示)
	------------------------------------------------*/
	function setCarModel(g_makerCode, g_modelCode) {

		if(!window.opener || window.opener.closed){
			//親ウィンドウが存在しない
			window.close();
		} else{
			var g_window = window.name;
			var makerName = window.document.getElementById( 'makerName[' + g_makerCode + '][' + g_modelCode + ']').value;
			var modelName = window.document.getElementById( 'modelName[' + g_makerCode + '][' + g_modelCode + ']').value;

			var id_modelName = "carModel[" + g_window + "][modelName]";
			var id_makerCode = "carModel[" + g_window + "][makerCode]";
			var id_modelCode = "carModel[" + g_window + "][modelCode]";
			var id_delBtn    = "delBtn_" + g_window;

			if( window.opener.document.getElementById(id_modelName) ){
				window.opener.document.getElementById(id_modelName).innerHTML = makerName + "　" + modelName;
				window.opener.document.getElementById(id_makerCode).value     = g_makerCode;
				window.opener.document.getElementById(id_modelCode).value     = g_modelCode;
				window.opener.document.getElementById(id_delBtn).disabled     = false;
			}
			window.close();
		}
	}

