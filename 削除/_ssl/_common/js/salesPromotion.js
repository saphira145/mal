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
		$("#salespromotionPanel").stop(true, false).css({'top': '-' + positionHeight + 'px'});
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
		var hoverList = [{selecter:"#compareData"         ,target:".lease .leaseDetail a"}					// 比較：「詳細」リンク
						,{selecter:"#compareData"         ,target:".lease li"}								// 比較：リース期間
						,{selecter:"#salesPromotionDisp"  ,target:"a"}										// 比較(条件)：算出条件リンク
						,{selecter:"#carLeaseInfo"        ,target:".carGradeList h2 span+*"}				// 車種詳細：開閉ボタン
						,{selecter:"#carLeaseInfo"        ,target:".carGradeList .leaseData dt.total+dd a"}	// 車種詳細：▲ボタン
						,{selecter:"#carLeaseInfo"        ,target:".leaseOption .btnArea a"}				// 車種詳細：オプションボタン
						,{selecter:"#carLeaseOption"      ,target:".itemList li"}							// オプション：オプション項目
						,{selecter:"#carLeaseOption"      ,target:".optionCheck span"}						// オプション：チェックボタン
						,{selecter:"#carLeaseOption"      ,target:".btnArea a"}								// オプション：戻るボタン、決定ボタン
						,{selecter:"#salespromotionPanel" ,target:"#panelMenu a"}							// マイページ：各リンク
						,{selecter:"#leaseBaseDisp"       ,target:"span"}									// マイページ：社外秘帯
						,{selecter:"#salespromotionPanel" ,target:".modeChangeLoginBox .btnArea a"}			// マイページ：ログインボタン
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

			// 現在の位置を確認
			this.top = $("#salespromotionPanel").position().top;

			if( 0 > this.top ){
				// 閉じている状態の為、下に移動させる
				$("#salespromotionPanel").animate({'top':'0px'}, 'normal');
				$("#salespromotionPanel").addClass("positionTop");
				$("#salespromotionPanel").removeClass("positionBottom");
			} else {
				// 開いている状態の為、上に移動させる

				// コンテンツが開いている場合、閉じる
				var displayCss = $("#salespromotionPanel  #panelContent").css("display");
				if( displayCss != "none" ){

					// 全リンクの初期化
					for( var i = 0 ; i < $("#login .float-r li").length; i++){
						if( $("#login .float-r li").eq(i).hasClass("selTab") ){
							$("#login .float-r li").eq(i).removeClass("selTab");
							var className = $("#login .float-r li").eq(i).attr("class");
							$("#login .float-r li").eq(i).addClass("selTab");
						}
					}

					if( className ){
						$("#login ." + className ).trigger("click");
					}
				}

				$("#salespromotionPanel").animate({'top': '-' + positionHeight + 'px'}, 'normal');
				$("#salespromotionPanel").addClass("positionBottom");
				$("#salespromotionPanel").removeClass("positionTop");
			}
		});

		/*---------------
		  お知らせ画面の表示処理
		--------------- */
		$("#login .notice").on("click", function(){
			// コンテンツの初期化
			var cntentOpenFlg = setContentArea("notice");

			if( cntentOpenFlg ){
				return;
			}

			// 既にコンテンツが存在する場合、開閉処理のみ
			if( $("#salespromotionPanel .contentArea.notice .noticeBox").size() > 0 ){
				var displayCss = $("#salespromotionPanel  #panelContent").css("display");

				$("#salespromotionPanel  #panelContent").slideToggle('slow');
				isClicked = false;
				return;
			}

			// コンテンツ取得
			var url         = $(":hidden[name^='url']").val();
			$.ajax({
				type		: "post",
				dataType	: "html",
				url			: url + "/bg/noticeText/",
				success		: function(ret){
					$("#salespromotionPanel .contentArea.notice").empty().append(ret);

					$(".msgBox").text("");
					$("#login .notice").find("span").removeClass("setPreset");
					
					if( !cntentOpenFlg ){
						$("#salespromotionPanel  #panelContent").slideToggle('slow');
						isClicked = false;
					}
				}
			});
		});

		/*---------------
		  事前設定画面の表示処理
		--------------- */
		$("#login .preset").on("click", function(){

			// コンテンツの初期化
			var cntentOpenFlg = setContentArea("preset");

			if( cntentOpenFlg ){
				return;
			}

			// 既にコンテンツが存在する場合、開閉処理のみ
			if( $("#salespromotionPanel .contentArea.preset .presetBox").size() > 0 ){
				var displayCss = $("#salespromotionPanel  #panelContent").css("display");

				$("#salespromotionPanel  #panelContent").slideToggle('slow');
				isClicked = false;
				return;
			}

			// コンテンツ取得
			var url         = $(":hidden[name^='url']").val();
			$.ajax({
				type		: "post",
				data		: {
				},
				dataType	: "html",
				url			: url + "/bg/leasePreset/?st=in",
				success		: function(ret){
					$("#salespromotionPanel .contentArea.preset").empty().append(ret);
					
					// イベント設定
					setPresetEvent()

					/* チェックボックス対応 */
					setCheckBoxEvent();

					$(".msgBox").text("");
					
					if( !cntentOpenFlg ){
						$("#salespromotionPanel  #panelContent").slideToggle('slow');
						isClicked = false;
					}
				}
			});
		});

		/*---------------
		  パスワード変更画面の表示処理
		--------------- */
		$("#login .password").on("click", function(){

			// コンテンツの初期化
			var cntentOpenFlg = setContentArea("password");

			if( cntentOpenFlg ){
				return;
			}
			$(".msgBox").text("");

			// 既にコンテンツが存在する場合、開閉処理のみ
			if( $("#salespromotionPanel .contentArea.password .memberBox").size() > 0 ){
				var displayCss = $("#salespromotionPanel  #panelContent").css("display");

				if( displayCss == "none" ){
					$("#salespromotionPanel").find(':password[name^="memberInfo[password]"]').val("");
					$("#salespromotionPanel").find(':password[name^="memberInfo[passwordNew]"]').val("");
					$("#salespromotionPanel").find(':password[name^="memberInfo[passwordConfirm]"]').val("");
					$(".passwordErr").text("");
					$(".passwordNewErr").text("");
					$(".passwordConfirmErr").text("");
				}

				$("#salespromotionPanel  #panelContent").slideToggle('slow');
				isClicked = false;
				return;
			}
			

			// コンテンツ取得
			var url         = $(":hidden[name^='url']").val();
			$.ajax({
				type		: "post",
				data		: {
				},
				dataType	: "html",
				url			: url + "/bg/changePassword/?st=in",
				success		: function(ret){
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
						$("#salespromotionPanel  #panelContent").slideToggle('slow');
						isClicked = false;
					}
				}
			});
		});

		/*---------------
		  試算設定(ログイン)画面の表示処理
		--------------- */
		$("#login .modeChange").on("click", function(){
			// コンテンツの初期化
			var cntentOpenFlg = setContentArea("modeChange");

			if( cntentOpenFlg ){
				return;
			} 

			$(".msgBox").text("");
			$(".passwordErr").text("");
			$("#salespromotionPanel").find(':password[name^="modeChenge[password]"]').val("");
			$("#salespromotionPanel .contentArea.modeChange .modeChangeLoginBox").show();
			$("#salespromotionPanel  #panelContent").slideToggle('slow');
			isClicked = false;
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

		if( cntentOpenFlg && isClicked ){
			return true;
		}

		isClicked = true;
		if( displayCss != "none"){
			$("#salespromotionPanel  #panelContent").slideToggle('slow', function(){
				// コンテンツを消す
				$("#salespromotionPanel .contentArea.modeChange .modeChangeBox").remove();

				// 全コンテンツの非表示
				for( var i = 0 ; i < $("#salespromotionPanel .contentArea").length; i++){
					$("#salespromotionPanel .contentArea").eq(i).css({"display":"none"});
				}
                
				// 全リンクの初期化
				for( var i = 0 ; i < $("#login .float-r li").length; i++){
					$("#login .float-r li").eq(i).removeClass("selTab");
				}

				if( !cntentOpenFlg ){
					// 設定
					$("#salespromotionPanel .contentArea." + className ).css({"display":"block"});
					$("#login ."  + className ).addClass("selTab");
				}

			});
		} else {

			// 全コンテンツの非表示
			for( var i = 0 ; i < $("#salespromotionPanel .contentArea").length; i++){
				$("#salespromotionPanel .contentArea").eq(i).css({"display":"none"});
			}

			// 設定
			$("#salespromotionPanel .contentArea." + className ).css({"display":"block"});
			$("#login ."  + className ).addClass("selTab");
		}

		return cntentOpenFlg;
	}




	/*---------------
	  比較画面
	--------------- */
	function setCompare(){
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
		for( var i = 0 ; i < $(".compareCarData .lease").length; i++){
			
			$(".compareCarData .lease").eq(i).find( "." +setClassName).addClass("selLease");
		}

		$(".compareCarData .lease li").bind("click", function(e) {
			var setClass = $(this).removeClass("hoverOpacity").removeClass("selLease").attr("class");
			var setEmt   = $(".compareCarData .lease");
			$(setEmt).find(".y3, .y4, .y5").removeClass("selLease");
			$(setEmt).find("." + setClass).addClass("selLease");
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
		$("#carLeaseInfo .carGradeList h2 span").bind("click", function(e) {
			var detail = $("a", this).attr("data-carGrade");
			var newAlt;

			if( $("a", this).hasClass("faChevronUp") ){
				 newAlt = "開く";
				 $("a", this).removeClass("faChevronUp");
				 $("a", this).addClass("faChevronBown");
				 
			} else {
				 newAlt = "閉じる";
				 $("a", this).removeClass("faChevronBown");
				 $("a", this).addClass("faChevronUp");
			}

			$("#" + detail + " dl.leaseBox").slideToggle('slow');
			$("a", this).text(newAlt);
		});

		/* トータルコストの開閉 */
		$("#carLeaseInfo .total+dd a").bind("click", function(e) {
			var detail = $(this).attr("data-totalDetail");
			var newAlt;

			if( $(this).hasClass("faCaretUp") ){
				 $(this).removeClass("faCaretUp");
				 $(this).addClass("faCaretDown");
				 
			} else {
				 $(this).removeClass("faCaretDown");
				 $(this).addClass("faCaretUp");
			}

			$("#" + detail + " .totalDetail").slideToggle('normal');
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
			url : url + "/bg/changePassword/?st=pu",
			success : function(re){

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
		$("#salespromotionPanel .presetBox .mileage input:checkbox, #salespromotionPanel .presetBox .voluntaryInsurance input:checkbox").on("change", function(){
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
			var i_mileage      = $("#salespromotionPanel .presetBox").find(':checkbox[name^="preset[mileage]"]:checked').val();
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
					"mileage"      : i_mileage,
					"gasoline"     : i_prefecture,
					"carAddDate"   : i_addDate,
					"voluntaryInsurance" : i_voluntaryInsurance,
					"option"       : arrOption.join("-")
				},
				url : url + "/bg/leasePreset/?st=ps",
				success : function(re){
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
			type        : "post",
			dataType    : "json",
			data        : {
				"email"           : i_account + "@" + i_domain,
				"password"        : i_password,
			},
			url : url + "/bg/modeChange/",
			success : function(re){

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
						type        : "post",
						dataType	: "html",
						data        : {
							"option"      : optionList,
						},
						url : url + "/bg/modeChange/" + setHrefArr[1] + "?st=bp",
						success : function(ret){
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
				type        : "post",
				dataType    : "json",
				data        : {
					"baseMode"    : baseMode,
					"profit"      : profit,
				},
				url : url + "/bg/modeChange/" + setHrefArr[1] + "?st=bc",
				success : function(re){
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
			var optionSet  = $("#salespromotionPanel #modePrice").find('input[name^="modeChange[optionSet]"]:checked').val();
			var optionList = [];
			$("#carLeaseInfo").find(':hidden[name^="option[]"]').each(function(){
				if( $.inArray($(this).val(), optionList) == -1 ){
					optionList.push($(this).val());
				}
			});
			var setHrefArr = location.href.split("/LEASEINFO/");
			var arrSearch  = setHrefArr[1].split("/");
			arrSearch[1]   = $("#salespromotionPanel #modePrice").find('*[name^="modeChange[carGrade]"]').val();
			setHrefArr[1]  = arrSearch.join("/");

			// 入力チェック
			if( !$.isNumeric(profit) ){
				$("#modePrice .profitMsgErr").text("半角数字で入力してください");
				return;
			}

			$("#loading img").css({"visibility":"visible"});
			// 試算取得
			$.ajax({
				type        : "post",
				dataType	: "html",
				data        : {
					"baseMode"    : baseMode,
					"profit"      : profit,
					"option"      : optionList,
					"optionSet"   : optionSet,
				},
				url : url + "/bg/modeChange/" + setHrefArr[1] + "?st=ll",
				success : function(ret){
					
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
		var hoverList = [{selecter:"#salespromotionPanel .modeChangeBox" ,target:"a"}
						,{selecter:"#salespromotionPanel .modeChangeBox" ,target:"label"}
						];
		setMouseOver( hoverList );
	}
});
