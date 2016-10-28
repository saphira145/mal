$(function(){
	var positionHeight;
	var gasolineList = [];
	var isClicked = false;

	/* 初期表示の設定 */
	initSet();

	/*---------------
	  初期表示の設定
	--------------- */
	function initSet(){

		/* パネルを表示する */
		$("#panelMenu").css({"display":"block"});

		/* パネル全体の高さを設定する */
		positionHeight = $("#salespromotionPanel").height();
		$("#salespromotionPanel").stop(true, false).css({"top": "-" + positionHeight + "px", "visibility" : "visible"});
		$("#panelButton").css({"display":"block"});

		/* メニュー設定 */
		setMenu();

		/* 比較画面の設定 */
		if( $("#panelContent").length > 0 ){
			setCompare();
			setDetailItem();
		}

		/* 車種詳細 */
		if( $("#carLeaseInfo").length > 0 ){
			setLeaseinfo();
		}

		/* オプション選択 */
		if( $("#carLeaseOption").length > 0 ){
			setLeaseOption();
		}


		/* マウスオーバー設定 */
		var hoverList = [{selecter:"#compareData" ,target:".lease .leaseDetail a"}                  // 比較
						,{selecter:"#compareData"         ,target:".lease li"}                              // 比較
						,{selecter:"#salesPromotionDisp"  ,target:"a"}                                      // 比較(条件)
						,{selecter:"#carLeaseInfo"        ,target:".carGradeList h2 span+*"}                // 車種詳細
						,{selecter:"#carLeaseInfo"        ,target:".carGradeList .leaseData dt.total+dd a"} // 車種詳細
						,{selecter:"#carLeaseInfo"        ,target:".leaseOption .btnArea a"}                // 車種詳細
 						,{selecter:"#carLeaseOption"      ,target:".itemList li"}                           // オプション
						,{selecter:"#carLeaseOption"      ,target:".optionCheck span"}                      // オプション
						,{selecter:"#carLeaseOption"      ,target:".btnArea a"}                             // オプション
						,{selecter:"#salespromotionPanel" ,target:"#panelMenu a"}                           // マイページ
						,{selecter:"#leaseBaseDisp"       ,target:"span"}                                   // マイページ
						,{selecter:"#salespromotionPanel" ,target:".modeChangeLoginBox .btnArea a"}         // マイページ
						];
		setMouseOver( hoverList );
	}

	/*---------------
	  マウスオーバーの設定
	--------------- */
	function setMouseOver( hoverList ){

		for(var i = 0, i_len = hoverList.length; i < i_len; i++){
			if( $(hoverList[i].selecter).size() > 0){
				$(hoverList[i].selecter).find(hoverList[i].target).each(function(){
					$(this).mouseover(function(){
						$(this).addClass("hoverOpacity");
					}).mouseup(function(){
						$(this).removeClass("hoverOpacity");
					}).mouseout(function(){
						$(this).removeClass("hoverOpacity");
					});
				})
			}
		}
	}


	/*---------------
	  パネルの各ボタン
	--------------- */
	function setMenu(){
		/*---------------
		  クリックによるパネルのスライド処理
		--------------- */
		$("#panelButton").bind("click", function(e) {

			if( isClicked ){
				return;
			}

			// 現在の位置を確認
			this.top = $("#salespromotionPanel").position().top;

			if( 0 > this.top ){
				// 閉じている状態の為、下に移動させる
				$("#salespromotionPanel").animate({'top':'0px'}, 'normal', function(){
					$("#salespromotionPanel").addClass("positionTop").removeClass("positionBottom");
				});
			} else {
				// 開いている状態の為、上に移動させる

				// コンテンツが開いている場合、閉じる
				var displayCss = $("#salespromotionPanel  #panelContent").css("display");

				if( displayCss != "none" ){

					// 全リンクの初期化
					for( var i = 0 ; i < $("#login .float-r li").length; i++){
						if( $("#login .float-r li").eq(i).hasClass("selTab") ){
							var className = $("#login .float-r li").eq(i).removeClass("selTab").attr("class");
							$("#login .float-r li").eq(i).addClass("selTab");
						}
					}

					if( className ){
						$("#login ." + className ).trigger("click");
					}
				}

				$("#salespromotionPanel").animate({'top': '-' + positionHeight + 'px'}, 'normal', function(){
					$("#salespromotionPanel").addClass("positionBottom").removeClass("positionTop");
				});
			}
		});

		/*---------------
		  お知らせ画面の表示処理
		--------------- */
		$("#login .notice").on("click", function(){

			if( isClicked ){
				return;
			}

			// コンテンツの初期化
			var cntentOpenFlg = setContentArea("notice");

			// コンテンツを閉じた場合は終了
			if( cntentOpenFlg ){
				return;
			}

			isClicked = true;
			// 既にコンテンツが存在する場合、開閉処理のみ
			if( $("#salespromotionPanel .contentArea.notice .noticeBox").size() > 0 ){
				var displayCss = $("#salespromotionPanel  #panelContent").css("display");

				$("#salespromotionPanel  #panelContent").slideDown('slow', function(){
					isClicked = false;
				});
				return;
			}

			// コンテンツ取得
			var url = $(":hidden[name^='url']").val();
			$.ajax({
				type     : "post",
				dataType : "html",
				async    : false,
				url      : url + "/bg/noticeText/",
				success  : function(ret){
					$("#salespromotionPanel .contentArea.notice").empty().append(ret);

					$(".msgBox").text("");
					$("#login .notice").find("span").removeClass("setPreset");

					$("#salespromotionPanel  #panelContent").slideDown('slow', function(){
						isClicked = false;
					});
					return;
				}
			});
		});

		/*---------------
		  事前設定画面の表示処理
		--------------- */
		$("#login .preset").on("click", function(){

			if( isClicked ){
				return;
			}

			// コンテンツの初期化
			var cntentOpenFlg = setContentArea("preset");

			// コンテンツを閉じた場合は終了
			if( cntentOpenFlg ){
				return;
			}

			isClicked = true;
			// 既にコンテンツが存在する場合、開閉処理のみ
			if( $("#salespromotionPanel .contentArea.preset .presetBox").size() > 0 ){
				var displayCss = $("#salespromotionPanel  #panelContent").css("display");

				$("#salespromotionPanel  #panelContent").slideToggle('slow', function(){
					isClicked = false;
				});
				return;
			}

			// コンテンツ取得
			var url = $(":hidden[name^='url']").val();
			$.ajax({
				type     : "post",
				data     : {},
				dataType : "html",
				url      : url + "/bg/leasePreset/?st=in",
				success  : function(ret){
					$("#salespromotionPanel .contentArea.preset").empty().append(ret);

					// イベント設定
					setPresetEvent()

					/* チェックボックス対応 */
					setCheckBoxEvent();

					$(".msgBox").text("");
					if( !cntentOpenFlg ){
						$("#salespromotionPanel  #panelContent").slideToggle('slow', function(){
							isClicked = false;
						});
					}
				}
			});
		});

		/*---------------
		  パスワード変更画面の表示処理
		--------------- */
		$("#login .password").on("click", function(){

			if( isClicked ){
				return;
			}

			// コンテンツの初期化
			var cntentOpenFlg = setContentArea("password");

			// コンテンツを閉じた場合は終了
			if( cntentOpenFlg ){
				return;
			}

			isClicked = true;
			$(".msgBox").text("");

			// 既にコンテンツが存在する場合、開閉処理のみ
			if( $("#salespromotionPanel .contentArea.password .memberBox").size() > 0 ){
				var displayCss = $("#salespromotionPanel  #panelContent").css("display");

				if( displayCss == "none" ){
					$("#salespromotionPanel").find(':password[name^="memberInfo[password]"]').val("");
					$("#salespromotionPanel").find(':password[name^="memberInfo[passwordNew]"]').val("");
					$("#salespromotionPanel").find(':password[name^="memberInfo[passwordConfirm]"]').val("");
					$(".passwordErr, .passwordNewErr, .passwordConfirmErr").text("");
				}

				$("#salespromotionPanel  #panelContent").slideToggle('slow', function(){
					isClicked = false;
				});
				return;
			}

			// コンテンツ取得
			var url = $(":hidden[name^='url']").val();
			$.ajax({
				type     : "post",
				data     : {},
				dataType : "html",
				url      : url + "/bg/changePassword/?st=in",
				success  : function(ret){
					$("#salespromotionPanel .contentArea.password").empty().append(ret);

 					/* マウスオーバー処理 */
					var hoverList = [{selecter:"#salespromotionPanel" ,target:".memberBox .btnArea a"}];
					setMouseOver( hoverList );

					/* 更新ボタン処理 */
					$(".memberBox .updateButton").on("click", function(){
						changePassword();
					});
					$(".msgBox").text("");

					if( !cntentOpenFlg ){
						$("#salespromotionPanel  #panelContent").slideToggle('slow', function(){
							isClicked = false;
						});
						return;
					}
				}
			});
		});

		/*---------------
		  試算設定(ログイン)画面の表示処理
		--------------- */
		$("#login .modeChange").on("click", function(){

			if( isClicked ){
				return;
			}

			// コンテンツの初期化
			var cntentOpenFlg = setContentArea("modeChange");

			// コンテンツを閉じた場合は終了
			if( cntentOpenFlg ){
				return;
			} 

			// コンテンツを開く
			isClicked = true;
			$(".msgBox").text("");
			$(".passwordErr").text("");
			$("#salespromotionPanel").find(':password[name^="modeChenge[password]"]').val("");
			$("#salespromotionPanel .contentArea.modeChange .modeChangeLoginBox").show();
			$("#salespromotionPanel  #panelContent").slideDown('slow', function(){
				isClicked = false;
			});
			return;
		});
	}


	/*---------------
	  コンテンツの初期化
	--------------- */
	function setContentArea( className ){

		var cntentOpenFlg = false;
		var displayCss    = $("#salespromotionPanel  #panelContent").css("display");

		if( $("#login .float-r li."+className).hasClass("selTab") ){
			cntentOpenFlg = true;
		}

		isClicked = true;

		if( displayCss == "none" ) {
			// 閉じている
			$("#salespromotionPanel .contentArea").css({"display":"none"});

			$("#salespromotionPanel .contentArea." + className ).css({"display":"block"});
			$("#login ."  + className ).addClass("selTab");
		} else {

			// 開いている
			$("#salespromotionPanel  #panelContent").slideUp('slow', function(){
				// 試算設定内のコンテンツを消す
				$("#salespromotionPanel .contentArea.modeChange .modeChangeBox").remove();

				// 全コンテンツの非表示
				$("#salespromotionPanel .contentArea").css({"display":"none"});

				// 全リンクの初期化
				$("#login .float-r li").removeClass("selTab");

				if( !cntentOpenFlg ){
					$("#salespromotionPanel .contentArea." + className ).css({"display":"block"});
					$("#login ."  + className ).addClass("selTab");
				}
				isClicked = false;
			});
		}
		return cntentOpenFlg;
	}


	/*---------------
	  比較画面
	--------------- */
	function setCompare(){

		/*---------------
		  ボタン初期設定
		--------------- */
		// 走行距離
		$(".compareCarData .leaseMileage").each(function(){
			$("li", this).eq(0).addClass("selLease");
		});

		// 期間
		var setClassName;
		if( $(".compareCarData .lease").eq(0).find("li.y3").size() > 0 ){
			setClassName = "y3";
		}
		else if($(".compareCarData .lease").eq(0).find("li.y4").size() > 0){
			setClassName = "y4";
		}
		else if($(".compareCarData .lease").eq(0).find("li.y5").size() > 0){
			setClassName = "y5";
		}
		$(".compareCarData .lease").each(function(){
			$("." +setClassName, this).addClass("selLease");

			$(".leaseVal div", this).each(function(){
				$(".leaseBox", this).eq(0).addClass("selLease");
			});
		});

		$(".compareCarData .leaseVal div").each(function(){
			$(".leaseBox", this).eq(0).addClass("selLease");
		});

		/*---------------
		  項目クリック処理
		--------------- */
		// 走行距離
		$(".compareCarData .leaseMileage li").bind("click", function(e) {
			var setClass = $(this).removeClass("hoverOpacity").removeClass("selLease").attr("class");
			var setEmt   = $(".compareCarData .leaseMileage ul");
			$("li", setEmt).removeClass("selLease");
			$("." + setClass, setEmt).addClass("selLease");

			// 該当期間を設定
			var leaseClass;
			$(".compareCarData .lease div").each(function(){
				if( $(this).hasClass("selLease") ){
					leaseClass = $(this).attr("class");
					leaseClass = leaseClass.replace(/selLease/g, "");
				}
			});
			$(".compareCarData .lease div>span" ).removeClass("selLease");
			$(".compareCarData .lease div ." + setClass ).addClass("selLease");
		});

		// 期間
		$(".compareCarData .lease li").bind("click", function(e) {
			var setClass     = $(this).removeClass("hoverOpacity").removeClass("selLease").attr("class");
			var setEmt       = $(".compareCarData .lease");
			var mileageClass = "";

			$("div, li", setEmt).removeClass("selLease");
			$("." + setClass, setEmt).addClass("selLease");
		});
	}


	function setDetailItem(){
		/*---------------
		  選択できる項目にクラスを設定
		--------------- */
		if (document.cookie.indexOf("filterDetailItem=on") == -1) {
			$("#compareDetail div>table th").each(function() {
				if($(this).attr("class") != "a"){
					$(this).addClass("clickSetCol");
				}
			});
		}

		/*---------------
		  項目クリック処理
		--------------- */
		$("#compareDetail div>table th.clickSetCol").click(function () {
			var chkClass = $(this).parents("div>table").attr("class");

			if( !chkClass ){
				// 1件のみ
				if( $(this).hasClass("clickfilter") ){
					$(this).removeClass("clickfilter")
				} else {
					$(this).addClass("clickfilter");
				}
			} else {
				var emt = $(this).parents("div>table");
				$(emt).find("th").each(function() {
					if( $(this).hasClass("clickfilter") ){
						$(this).removeClass("clickfilter")
					} else {
						$(this).addClass("clickfilter");
					}
				});
			}
		});

		/*---------------
		  「絞り込み」リンク押下
		--------------- */
		$("#compareCarName .filter").click(function () {

			var arrDetailItem = [];
			$("#compareDetail").find("div").each(function(){
				if( $(this).find("th").hasClass("clickfilter") && $(this).attr("data-detailItem") && $.inArray($(this).attr("data-detailItem"), arrDetailItem) == -1 ){
					var detailItem = $(this).attr("data-detailItem").replace("d", "");
					arrDetailItem.push(detailItem);
				}
			});

			var cookieStr;
			if (document.cookie.indexOf("filterDetailItem=on") != -1) {
				cookieStr = "off";
			} else {

				// ダイアログ表示
				var w={ w:429, h:160};
				var alertFlg;

				$("#checkAlert .checkNone").css({display: "none"});
				$("#checkAlert .checkOrver").css({display: "none"});

				if( arrDetailItem.length == 0){
					$("#checkAlert .checkNone").css({display: ""});
					alertFlg = 1;
				} else if( arrDetailItem.length > 10){
					$("#checkAlert .checkOrver").css({display: ""});
					alertFlg = 1;
				}

				if( alertFlg ){
					$("#thickboxjs")
						.attr("href", "#TB_inline?height=" + w.h + "&width=" + w.w + "&inlineId=thickboxjsContent2&modal=true" )
						.triggerHandler("click");

					$("#TB_ajaxContent").css({opacity: 0}).animate({opacity : 1}, 200);
					$("#TB_overlay").off("click");
					$("#TB_overlay, #checkAlert .closeBtn").on("click", function(){
						tb_remove();
					});
					return false;
				}
				cookieStr = "on" + "," + arrDetailItem.join("-");
			}
			document.cookie= "filterDetailItem=" + cookieStr + ";path=/";
			location.reload();
		});
	}


	/*---------------
	  車種詳細
	--------------- */
	/* グレードの開閉 */
	function setLeaseinfo(){
		var boxHeight;
		var boxEmtName;

		$("#carLeaseInfo .carGradeList h2 span").bind("click", function(e) {
			var detail = $("a", this).attr("data-carGrade");
			var newAlt;

			if( isClicked ){
				return;
			}

			if( $("a", this).hasClass("faChevronUp") ){
				newAlt = "開く";
				$("a", this).removeClass("faChevronUp");
				$("a", this).addClass("faChevronBown");
				$("#" + detail + " .dataList ").css({"min-height" : ""});
			} else {
				newAlt = "閉じる";
				$("a", this).removeClass("faChevronBown");
				$("a", this).addClass("faChevronUp");
			}

			isClicked = true;
			$("#" + detail + " dl.leaseBox").slideToggle('slow');
			$("#" + detail + " .itemList").slideToggle('slow', function(){
					isClicked = false;
					boxEmtName = "#" + detail;
				});
			$("a", this).text(newAlt);
		});

		/* トータルコストの開閉 */
		$("#carLeaseInfo .total+dd a").bind("click", function(e) {
			var detail = $(this).attr("data-totalDetail");
			var newAlt;

			if( isClicked ){
				return;
			}

			if( $(this).hasClass("faCaretUp") ){
				$("#" + detail + " .total+dd a").removeClass("faCaretUp");
				$("#" + detail + " .total+dd a").addClass("faCaretDown");
				$( boxEmtName + " .dataList ").css({"min-height" : ""});
			} else {
				$("#" + detail + " .total+dd a").removeClass("faCaretDown");
				$("#" + detail + " .total+dd a").addClass("faCaretUp");
			}

			boxHeight = $( boxEmtName + ".dataList ").height() + "px";
			$( boxEmtName + " .dataList ").css({"min-height" : boxHeight});

			isClicked = true;
			$("#" + detail + " .totalDetail").slideToggle('normal', function(){
				isClicked = false;
			});
		});

		/* ON／OFF切り替え */
		$("#carLeaseInfo.filter .leaseBox dt.title span.lease, #carLeaseInfo.filter .leaseBox .leaseData dd span").click(function(){
			var chkClass = $(this).parents(".leaseBox").hasClass("filterColor");

			if( chkClass ){
				$(this).parents(".leaseBox").removeClass("filterColor");
			} else {
				$(this).parents(".leaseBox").addClass("filterColor");
			}
		});

		$("#carLeaseInfo.filter .leaseOption dd").click(function(){
			if( $(this).hasClass("filterColor") ){
				$(this).removeClass("filterColor");
			} else {
				$(this).addClass("filterColor");
			}
		});

		/*---------------
		   走行距離項目の切り替え処理
		--------------- */
		$("#carLeaseInfo .itemList a").bind("click", function() {
			var openBox    = $(this).attr("data-mileageItem");
			var openBoxArr = openBox.split("_");
			var emt        = $("#" + openBoxArr[0]);

			// 既に開いている場合は、処理を行わない
			if( isClicked ||  $("div.selBox" , emt).attr("id") == openBox ){
				return;
			}

			$( boxEmtName + " .dataList ").css({"min-height" : ""});
			boxHeight = $( boxEmtName + " .dataList ").height() + "px";

			// 項目
			$(".itemList a", emt).each(function() {
				$(this).removeClass("selItem");
			});
			$(this).addClass("selItem");

			// リスト
			isClicked = true;
			$( boxEmtName + " .dataList ").css({"min-height" : boxHeight});
			$(".leaseBox ", emt ).slideToggle('slow', function(){
				$(".selBox", emt).removeClass("selBox");
				$("#" + openBox ).addClass("selBox");

				$(".leaseBox ", emt).slideDown('slow', function(){
					isClicked = false;
				});
			});
		});
	}


	/*---------------
	  オプション選択
	--------------- */
	function setLeaseOption(){
		var totalPrice     = Number($(":hidden[name^='totalPrice']").val());
		var totalPrice_out = addFigure(totalPrice);

		// フッターのボタンを非表示
		$("#footer a").remove();

		/* チェックボックス対応 */
		setCheckBoxEvent();

		/*---------------
		   オプション項目の切り替え処理
		--------------- */
		$("#carLeaseOption .itemList a").bind("click", function() {
			var openBox = $(this).attr("data-optionItem");

			// 既に開いている場合は、処理を行わない
			if( isClicked ||  $("#carLeaseOption .selBox").attr("id") == openBox ){
				return;
			}

			// 項目
			$("#carLeaseOption .itemList a").each(function() {
				$(this).removeClass("selItem");
			});
			$(this).addClass("selItem");

			// リスト
			isClicked = true;
			$("#carLeaseOption .selBox").slideToggle('normal', function(){
				$(this).removeClass("selBox");
				$("#" + openBox ).slideToggle('slow', function(){
					$("#" + openBox ).addClass("selBox");
					isClicked = false;
				});
			});
		});

		/*---------------
		  チェックボックス処理
		--------------- */
		$("#carLeaseOption .itemBox .optionCheck span").on("click", function(){
			if( !$(this).find("input:checkbox").attr('checked') ){
				// チェックなしの場合、チェック
				$(this).addClass('selected');
				$(this).find("input:checkbox").attr("checked", true);
				totalPrice = totalPrice + Number($(this).find("input:checkbox").attr("data-price"));
			} else {
				// チェック済みの場合、外す
				$(this).removeClass('selected');
				$(this).find("input:checkbox").attr("checked", false);
				totalPrice = totalPrice - Number($(this).find("input:checkbox").attr("data-price"));
			}

			totalPrice_out = addFigure(totalPrice);
			$("#carLeaseOption .optionTotalPrice span").text(totalPrice_out);
		});

		/* ON／OFF切り替え */
		$("#carLeaseOption.filter .itemBox .price").click(function(){
			var chkClass = $(this).parents(".itemBox").hasClass("filterColor");

			if( chkClass ){
				$(this).parents(".itemBox").removeClass("filterColor");
			} else {
				$(this).parents(".itemBox").addClass("filterColor");
			}
		});

		$("#carLeaseOption.filter .optionTotalPrice").click(function(){
			if( $(this).hasClass("filterColor") ){
				$(this).removeClass("filterColor");
			} else {
				$(this).addClass("filterColor");
			}
		});
	}


	/*---------------
	  金額のフォーマットに変更する
	--------------- */
	function addFigure(num) {
		var str = new String(num);  
		var n     = "";
		var count = 0;  

		for (var i=str.length-1; i>=0; i--){  
			n = str.charAt(i) + n;
			count++;  
			if ( ( (count % 3) == 0) && (i != 0) ){
				n = ","+n;
			}
		}
		return n;
	}


	/*---------------
	  パスワード変更処理
	--------------- */
	function changePassword(){
		var url         = $(":hidden[name^='url']").val();
		var i_password        = $("#salespromotionPanel").find(':password[name^="memberInfo[password]"]').val();
		var i_passwordNew     = $("#salespromotionPanel").find(':password[name^="memberInfo[passwordNew]"]').val();
		var i_passwordConfirm = $("#salespromotionPanel").find(':password[name^="memberInfo[passwordConfirm]"]').val();
		var i_account         = $("#salespromotionPanel").find(':hidden[name^="memberInfo[account]"]').val();
		var i_domain          = $("#salespromotionPanel").find(':hidden[name^="memberInfo[domain]"]').val();
		var i_dbTicket        = $("#salespromotionPanel").find(':hidden[name^="dbTicket"]').val();

		// 対象の件数取得
		$.ajax({
			type        : "post",
			dataType    : "json",
			data        : {
				"dbTicket"        : i_dbTicket,
				"email"           : i_account + "@" + i_domain,
				"password"        : i_password,
				"passwordNew"     : i_passwordNew,
				"passwordConfirm" : i_passwordConfirm
			},
			url         : url + "/bg/changePassword/?st=pu",
			success     : function(re){
				// メッセージを消す
				$(".passwordErr").text("");
				$(".passwordNewErr").text("");
				$(".passwordConfirmErr").text("");
				$("#memberBoxMsg").text("");

				if( re.err ){
					$(".passwordErr").text(re.passwordMsg);
					$(".passwordNewErr").text(re.passwordNewMsg);
					$(".passwordConfirmErr").text(re.passwordConfirmMsg);
					
				} else {
					$("#salespromotionPanel .msgBox").text("パスワードが更新されました。");
					$("#login .password").trigger("click");
					$("#salespromotionPanel .contentArea.password").empty();
					$(document).scrollTop(0);
				}
				return;
			}
		});
	}


	/*---------------
	  事前設定イベント
	--------------- */
	function setPresetEvent(){
		/*---------------
		  チェックボックス処理
		--------------- */
		$("#salespromotionPanel .presetBox .voluntaryInsurance input:checkbox").on("change", function(){
			var emtName = $(this).attr("name");
			$('#salespromotionPanel .presetBox input[name="'+emtName+'"]:checkbox').each(function() {
				$(this).attr("checked", false).parent("label").removeClass("checkcolor");
			});
			$(this).attr("checked", true).parent("label").addClass("checkcolor");
		});

		$("#salespromotionPanel .presetBox .optionCheck span").on("click", function(){
			if( !$(this).find("input:checkbox").attr('checked') ){
				// チェックなしの場合、チェック
				$(this).addClass("checkcolor");
				$(this).find("input:checkbox").attr("checked", true);
			} else {
				// チェック済みの場合、外す
				$(this).removeClass("checkcolor");
				$(this).find("input:checkbox").attr("checked", false);
			}
		});

		/*---------------
		  ガソリン価格取得
		--------------- */
		$(".presetBox .gasolineInfo").change(function(){
			var url          = $(":hidden[name^='url']").val();
			var i_prefecture = $("#salespromotionPanel .presetBox").find('*[name^="preset[prefecture]"]').val();

			if( gasolineList.length <= 0 ){
				// 一覧を取得
				$.ajax({
					type     : "post",
					dataType : "json",
					data     : {},
					async    : false,
					url      : url + "/bg/leasePreset/?st=gl",
					success  : function(re){
						gasolineList = re.gasolineList;
					}
				});
			}

			// 価格の設定
			var prefecture = i_prefecture.replace(/LG0{0,2}/g,'');
			var setGasoline = gasolineList[prefecture];

			$("#salespromotionPanel .gasoline ").slideToggle('slow', function(){
				$("#salespromotionPanel .regular").text(setGasoline.regular);
				$("#salespromotionPanel .highOctane").text(setGasoline.highOctane);
				$("#salespromotionPanel .diesel").text(setGasoline.diesel);
				$("#salespromotionPanel .gasoline ").css({"visibility":"hidden"});
			});

			setTimeout(function(){
				$("#salespromotionPanel .gasoline ").slideToggle('slow').css({"visibility":"visible"});
			}, 700);
		});

		/*---------------
		  条件設定処理
		--------------- */
		$(".presetBox .decisionButton").on("click", function(){
			var arrOption      = [];
			var url            = $(":hidden[name^='url']").val();
			var i_prefecture   = $("#salespromotionPanel .presetBox").find('*[name^="preset[prefecture]"]').val();
			var i_addDate      = $("#salespromotionPanel .presetBox").find('*[name^="preset[addDate]"]').val();
			var i_voluntaryInsurance = $("#salespromotionPanel .presetBox").find(':checkbox[name^="preset[voluntaryInsurance]"]:checked').val();
			$("#salespromotionPanel .presetBox").find(':checkbox[name^="preset[option]"]:checked').each(function(){
				if( $.inArray($(this).val(), arrOption) == -1 ){
					arrOption.push($(this).val());
				}
			});

			// 対象の件数取得
			$.ajax({
				type        : "post",
				dataType    : "json",
				data        : {
					"gasoline"     : i_prefecture,
					"carAddDate"   : i_addDate,
					"voluntaryInsurance" : i_voluntaryInsurance,
					"option"       : arrOption.join("-")
				},
				url         : url + "/bg/leasePreset/?st=ps",
				success     : function(re){
					// メッセージを消す
					$(".addDateErr").text("");
					$("#memberBoxMsg").text("");

					if( re && re.err ){
						$(".addDateErr").text(re.addDateMsg);
					} else {
						$("#salespromotionPanel .msgBox").text("リース条件を設定しました。");
						$("#login .preset").trigger("click");
						$("#login .preset span").addClass("setPreset");
						$("#salespromotionPanel .contentArea.preset").empty();
						$(document).scrollTop(0);
						setTimeout(function(){
							document.location = location.href;
						}, 1000);
					}
					return;
				}
			});
		});

		/*---------------
		  マウスオーバー処理
		--------------- */
		var hoverList = [{selecter:"#salespromotionPanel" ,target:".presetBox label"}
						,{selecter:"#salespromotionPanel" ,target:".presetBox .btnArea a"}
						];
		setMouseOver( hoverList );
	}


	/*---------------
	  パスワードチェック処理
	--------------- */
	$(".modeChangeLoginBox .loginBtn").on("click", function(){
		var url         = $(":hidden[name^='url']").val();
		var i_password        = $("#salespromotionPanel").find(':password[name^="modeChenge[password]"]').val();
		var i_account         = $("#salespromotionPanel").find(':hidden[name^="modeChenge[account]"]').val();
		var i_domain          = $("#salespromotionPanel").find(':hidden[name^="modeChenge[domain]"]').val();

		// 対象の件数取得
		$.ajax({
			type     : "post",
			dataType : "json",
			data     : {
				"email"    : i_account + "@" + i_domain,
				"password" : i_password,
			},
			url      : url + "/bg/modeChange/",
			success  : function(re){

				if( re ){
					$(".passwordErr").text(re.passwordMsg);
					return;
				} else {
					var setHrefArr = location.href.split("/LEASEINFO/");
					var optionList = [];
					$("#carLeaseInfo").find(':hidden[name^="option[]"]').each(function(){
						if( $.inArray($(this).val(), optionList) == -1 ){
							optionList.push($(this).val());
						}
					});

					$.ajax({
						type     : "post",
						dataType : "html",
						data     : {
							"option"      : optionList,
						},
						url      : url + "/bg/modeChange/" + setHrefArr[1] + "?st=bp",
						success  : function(ret){
							$("#salespromotionPanel  #panelContent").slideToggle('normal', function(){
								$("#salespromotionPanel .contentArea.modeChange").append(ret);

								// イベント設定
								modeChangeEvent();

								/* チェックボックス対応 */
								setCheckBoxEvent();

								$("#salespromotionPanel .contentArea.modeChange .modeChangeLoginBox").hide();
								$("#salespromotionPanel  #panelContent").slideToggle('slow');
							});
							return;
						}
					});
				}
			}
		});
	});

	/*---------------
	  試算設定イベント
	--------------- */
	function modeChangeEvent(){
		var url = $(":hidden[name^='url']").val();

		/*---------------
		  チェックボックス処理
		--------------- */
		$("#salespromotionPanel .modeChangeBox input:checkbox").on("change", function(){
			var emtName = $(this).attr("name");
			$('#salespromotionPanel .modeChangeBox input[name="'+emtName+'"]:checkbox').each(function() {
				$(this).attr("checked", false).parent("label").removeClass("checkcolor");
			});
			$(this).attr("checked", true).parent("label").addClass("checkcolor");
		});

		/*---------------
		   項目の切り替え処理
		--------------- */
		$("#salespromotionPanel .modeChangeBox .itemList a").bind("click", function() {
			var openBox = $(this).attr("data-modeChange");

			// 既に開いている場合は、処理を行わない
			if( isClicked || $("#salespromotionPanel .modeChangeBox .selBox").attr("id") == openBox ){
				return;
			}

			// 項目
			$("#salespromotionPanel .modeChangeBox .itemList a").each(function() {
				$(this).removeClass("selItem");
			});
			$(this).addClass("selItem");

			// リスト
			isClicked = true;
			$("#salespromotionPanel .modeChangeBox .selBox").slideToggle('normal', function(){
				$(this).removeClass("selBox");
				$("#" + openBox ).slideToggle('slow', function(){
					$("#" + openBox ).addClass("selBox");
					$("#salespromotionPanel #modePrice .leaseTbl").empty();
					isClicked = false;
				});
			});
		});

		/*---------------
		  ベース価格
		--------------- */
		$("#salespromotionPanel #modeBase .decisionButton").bind("click", function() {
			$("#modeBase .profitMsgErr").text("");

			// 条件取得
			var baseMode   = $("#salespromotionPanel #modeBase").find('input[name^="basePrice[baseMode]"]:checked').val();
			var profit     = $("#salespromotionPanel #modeBase").find('input[name^="basePrice[profit]"]').val();
			var setHrefArr = location.href.split("/LEASEINFO/");

			// ベース変更
			// 対象の件数取得
			$.ajax({
				type     : "post",
				dataType : "json",
				data     : {
					"baseMode"    : baseMode,
					"profit"      : profit,
				},
				url      : url + "/bg/modeChange/" + setHrefArr[1] + "?st=bc",
				success  : function(re){
					// メッセージを消す
					$(".addDateErr").text("");
					$("#memberBoxMsg").text("");

					if( re && re.err ){
						$(".addDateErr").text(re.addDateMsg);
						$("#modeBase .profitMsgErr").text(re.profitMsg);

					} else {
						$("#salespromotionPanel .msgBox").text("ベース価格条件を変更しました。");
						$("#login .modeChange").trigger("click");
						$(document).scrollTop(0);
						setTimeout(function(){
							form_leaseInfoS.action = location.href;
							form_leaseInfoS.submit();
						}, 1000);
					}
					return;
				}
			});
		});

		/*---------------
		  利益額確認
		--------------- */
		$("#salespromotionPanel #modePrice .decisionButton").bind("click", function() {
			$("#modePrice .profitMsgErr").text("");
			var displayCss    = $("#salespromotionPanel  #modePrice .leaseTbl").css("display");

			// 条件取得
			var baseMode   = $("#salespromotionPanel #modePrice").find('input[name^="modeChange[baseMode]"]:checked').val();
			var profit     = $("#salespromotionPanel #modePrice").find('input[name^="modeChange[profit]"]').val();
			var mileage    = $("#salespromotionPanel #modePrice").find('input[name^="modeChange[mileage]"]:checked').val();
			var carGrade   = $("#salespromotionPanel #modePrice").find('*[name^="modeChange[carGrade]"]').val();
			var optionSet  = $("#salespromotionPanel #modePrice").find('input[name^="modeChange[optionSet]"]:checked').val();
			var optionList = [];
			$("#carLeaseInfo").find(':hidden[name^="option[]"]').each(function(){
				if( $.inArray($(this).val(), optionList) == -1 ){
					optionList.push($(this).val());
				}
			});
			var setHrefArr = location.href.split("/LEASEINFO/");

			// 入力チェック
			if( !$.isNumeric(profit) ){
				$("#modePrice .profitMsgErr").text("半角数字で入力してください");
				return;
			}

			$("#loading img").css({"visibility":"visible"});
			// 試算取得
			$.ajax({
				type     : "post",
				dataType : "html",
				data     : {
					"baseMode"     : baseMode,
					"carGradeCode" : carGrade,
					"profit"       : profit,
					"mileage"      : mileage,
					"option"       : optionList,
					"optionSet"    : optionSet,
				},
				url      : url + "/bg/modeChange/" + setHrefArr[1] + "?st=ll",
				success  : function(ret){

					// 開いていたら一旦閉じる
					if( displayCss != "none"){
						$("#salespromotionPanel #modePrice .leaseTbl" ).slideToggle('slow', function(){
							$("#salespromotionPanel #modePrice .leaseTbl").empty().append(ret);
						});
					} else {
						$("#salespromotionPanel #modePrice .leaseTbl").empty().append(ret);
					}

					// 表を開く
					setTimeout(function(){
						$("#salespromotionPanel #modePrice .leaseTbl" ).slideToggle('normal', function(){
							$("#loading img").css({"visibility":"hidden"});
						});
					}, 1000);
				}
			});
		});

		/*---------------
		  マウスオーバー処理
		--------------- */
		var hoverList = [
						 {selecter:"#salespromotionPanel .modeChangeBox" ,target:"a"}
						,{selecter:"#salespromotionPanel .modeChangeBox" ,target:"label"}
						];
		setMouseOver( hoverList );
	}
});
