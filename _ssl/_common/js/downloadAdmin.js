
	/*-----------------------------------------------
	  アクション変更後送信
	------------------------------------------------*/
	function actionChangeSubmit () {

		for( var i=0; i<document.form_search.elements['downloadInfo[outputType]'].length; i++ ) {
			if( document.form_search.elements['downloadInfo[outputType]'][i].checked ) {
				if( document.form_search.elements['downloadInfo[outputType]'][i].value == 1 ) {
					document.form_search.st.value = "mde";
					document.form_search.submit();
					document.form_search.st.value = "";
					return false;
				}
				else{
					document.form_search.st.value = "sde";
					document.form_search.submit();
					document.form_search.st.value = "";
					return false;
				}
			}
		}

		// ラジオボタンは選択されていない
		document.form_search.st.value = "mde";
		document.form_search.submit();
		document.form_search.st.value = "";

		return false;
	}


	function actionChangeCsvSubmit () {

		for( var i=0; i<document.form_csvImportOnly.elements['importOnlyDownloadInfo[outputType]'].length; i++ ) {
			if( document.form_csvImportOnly.elements['importOnlyDownloadInfo[outputType]'][i].checked ) {
				var checkVal = document.form_csvImportOnly.elements['importOnlyDownloadInfo[outputType]'][i].value;

				document.form_csvImportOnly.st.value = checkVal;
				document.form_csvImportOnly.submit();
				document.form_csvImportOnly.st.value = "";
				return false;
			}
		}
	}


