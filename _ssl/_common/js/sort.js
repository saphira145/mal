
	/*-----------------------------------------------
	  上へ移動
	------------------------------------------------*/
	function moveUpElement( emName ) {

		var selectbox = document.getElementById(emName);
		var option_list = selectbox.getElementsByTagName('option');

		for (var i = 0; i < option_list.length; i++) {
			if (option_list[i].selected) {
				if (i > 0 && !option_list[i-1].selected) {
					selectbox.insertBefore(option_list[i], option_list[i-1]);
				}
			}
		}

		selectbox.focus();
	}



	/*-----------------------------------------------
	  下へ移動
	------------------------------------------------*/
	function moveDownElement(emName) {

		var selectbox = document.getElementById(emName);
		var option_list = selectbox.getElementsByTagName('option');

		for (var i = option_list.length-1; i >= 0; i--) {
			if (option_list[i].selected) {
				if (i < option_list.length-1 && !option_list[i+1].selected) {
					selectbox.insertBefore(option_list[i+1], option_list[i]);
				}
			}
		}

		selectbox.focus();
	}


	/*-----------------------------------------------
	  決定
	------------------------------------------------*/
	function fix(){

		var f2 = document.toDispNumConfirm;

		var selectbox = document.getElementById('selectboxIDs');
		var option_list = selectbox.getElementsByTagName('option');

		a2 = [];

		for (var i = 0; i < option_list.length; i++) {
			if ( option_list[i].value != undefined ) {
				a2.push(option_list[i].value);
			}
		}

		document.toDispNumConfirm.dispSortIDs.value = a2.join(',');
		document.toDispNumConfirm.submit();

	}


	/*-----------------------------------------------
	  決定 (バリュー用)
	------------------------------------------------*/
	function fixTheme(){

		var f2 = document.toDispNumConfirm;

		// 優先度
		var prioritybox = document.getElementById('priorityboxIDs');
		var option_list = prioritybox.getElementsByTagName('option');

		a2 = [];

		for (var i = 0; i < option_list.length; i++) {
			if ( option_list[i].value != undefined ) {
				a2.push(option_list[i].value);
			}
		}

		document.toDispNumConfirm.prioritySortIDs.value = a2.join(',');


		// 表示順
		var dispbox = document.getElementById('dispboxIDs');
		var option_list = dispbox.getElementsByTagName('option');
		a2 = [];

		for (var i = 0; i < option_list.length; i++) {
			if ( option_list[i].value != undefined ) {
				a2.push(option_list[i].value);
			}
		}

		document.toDispNumConfirm.dispSortIDs.value = a2.join(',');

		document.toDispNumConfirm.submit();

	}

