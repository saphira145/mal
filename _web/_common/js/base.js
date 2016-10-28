$(function(){

	/*---------------
	  初期設定
	--------------- */
	/* バナー */
	changeHeaderBanner();

	/* チェックボックス(IE8) */
	setCheckBoxEvent();

	/* マウスオーバー設定 */
	setMouseOverEvent();

	/* サイドメニュー */
	setRightfloatingPanel();

	/*---------------
	  車種名検索
	--------------- */
	var KC={
		enter:13,
		left :37,
		right:39
	};
	var lastquery;

	// 入力文字の変換
	var z2h = function( str ){
		return str.replace(/[Ａ-Ｚａ-ｚ０-９＿]/g,function(s){
			return String.fromCharCode(s.charCodeAt(0)-65248);
		});
	}

	var h2z = function( str ){
		return str.replace(/[A-Za-z0-9_\w]/g,function(s){
			return String.fromCharCode(s.charCodeAt(0)+65248);
		});
	}

	var h2k = function( str ){
		return str.replace(/[ぁ-ん]/g,function(s){
			return String.fromCharCode(s.charCodeAt(0)+96);
		});
	}

	var k2h = function( str ){
		return str.replace(/[ァ-ン]/g,function(s){
			return String.fromCharCode(s.charCodeAt(0)-96);
		});
	}

	// 該当データ番号の取得
	var find = function( str ){
		if( !str ){
			return [];
		}

		var keywords = str.split(/[+ 　]/);
		var result=[];


		for(var i=0, iMax=data.length; i<iMax; ++i){
			var err     = 0;
			var maker   = data[i].c;
			var model   = data[i].m;
			var modelE  = data[i].me;

			for(var j = 0, jMax = keywords.length; j < jMax; j++){
				var hh   = z2h(k2h(keywords[j]));
				var hz   = h2z(k2h(keywords[j]));
				var kh   = z2h(h2k(keywords[j]));
				var kz   = h2z(h2k(keywords[j]));
				var newK = '(' + hh + '|' + hz + '|' + kh + '|' + kz + ')';
				var reg  = new RegExp(newK, 'gi');

				var resModel = reg.exec(model);
				if( !resModel ){
					var resModelE = reg.exec(modelE);
					if( !resModelE ){
						var resMaker = reg.exec(maker);
						if( !resMaker ){
							err=1;
							break;
						}
					}
				}
			}

			if( err != 1 ){
				result.push([i]);
			}
		}
		return result;
	}

	// 画面クリア
	var viewClear = function(){
		$("#modelNameResult ul").remove();
		$("#searchModelName .arwIcon").css({visibility:"hidden",display:"none"});
		lastquery = null;
	}

	// 画面出力
	var view = function( result, offset){
		var url = $(":hidden[name^='url']").val();

		if( !result ){
			return;
		}

		viewClear();

		$("#searchModelName .arwIcon").css({visibility:"visible",display:"block"});
		$("#modelNameResult").append("<ul></ul>");
		for( var i = 0, iMax = result.length; i < iMax; i++ ){
			var num = result[i][0];
			$("#modelNameResult ul").append("<li onclick=\"location.href='" + url + "/COMPARE/" + data[num].me + "/?from=carname'\" class='faChevronRight' ><span>" + data[num].m + "</span></li>");
		}

		/* マウスオーバー設定 */
		setMouseOverEvent();
	}

	// キーイベント
	$("#modelNameInput").keyup(function(){
		var inpCarName = $(this).val();

		if( inpCarName == "" ){
			viewClear();
			return;
		}

		if( lastquery == inpCarName ){return}
		lastquery = inpCarName;

		// 車種名リストから該当するデータを保持する
		var getList = find(inpCarName);

		if( getList.length ){
			// 保持したデータを画面に出力する
			view(getList);

		}else{
			viewClear();
			return;
		}
	});

	//------------------------------------------------
	// ページのトップへ
	//------------------------------------------------
	$(".gotoPageTop").click(function(){
		$("html,body").animate( {"scrollTop":"0"}, 1500);
	});

});

/*---------------
  ヘッダーのサガシテ画像切り替え
--------------- */
function changeHeaderBanner(){
	var url = $(":hidden[name^='url']").val();

	if( $(".header_top").length > 0 ){

		var URL = "http://www.mal-marche.com/jp/estimate/";
		var TOP_HEADER_1_PATH = url + "/_common/img/hl/top_header_1.png";
		var TOP_HEADER_2_PATH = url + "/_common/img/hl/top_header_2.png";
		var TOP_HEADER_3_PATH = url + "/_common/img/hl/top_header_3.png";
		var PNG = url + "/_common/img/hl/1_1_trans.png";

		var img2 = $("<img src='" + TOP_HEADER_2_PATH + "'  class='remove' style='position: absolute;top: 0;right: 0;display: none;'>").appendTo("#header");
		var img3 = $("<img src='" + TOP_HEADER_3_PATH + "'  class='remove' style='position: absolute;top: 0;right: 0;display: none;'>").appendTo("#header");
		var img1 = $("<img src='" + TOP_HEADER_1_PATH + "'  class='remove' style='position: absolute;top: 0;right: 0;display: none;'>").appendTo("#header");

		setTimeout(function(){
			$(img2).fadeIn(1000);
			setTimeout(function(){
				$(img3).fadeIn(1000);

				$("#header").append("<a href='" + URL + "' target='_blank' class='remove'><div style='position: absolute;width: 247px;height: 40px;top: 66px;right: 366px;background: url(" + PNG + ") 0 0 repeat;'></div></a>");

				/* マウスオーバー設定 */
				setMouseOverEvent();
				
				setTimeout(function(){
					$(img1).fadeIn(1000);
					setTimeout(function(){
						$("#header .remove").remove();
						changeHeaderBanner();
					}, 1000);
				}, 18000);
				
			}, 9000);
		}, 6000);
	}
}

/*---------------
  IE8対応：チェックボックスのクリックイベント設定
--------------- */
function setCheckBoxEvent(){
	var userAgent = window.navigator.userAgent.toLowerCase();
	var appVersion = window.navigator.appVersion.toLowerCase();

	if (userAgent.indexOf("msie") != -1) {
		if (appVersion.indexOf("msie 6.") != -1) {

		//	    return 'ie6';
		} else if (appVersion.indexOf("msie 7.") != -1) {
		//	    return 'ie7';
		} else if (appVersion.indexOf("msie 8.") != -1) {

			// IE8対応 ラベルを使用している＋チェックボックスを非表示にしている場合、チェックボックスのクリックイベントが実行できない対応
			$("label").find(":checkbox").each(function(){
				if( $(this).css("display") == "none" ){
					$(this).parents("label").on("click", function(){
						$(this).find(":checkbox").trigger("click");
					});
				}
			})
		//	    return 'ie8';
		} else if (appVersion.indexOf("msie 9.") != -1) {
		//	    return 'ie9';
		} else {
		//	    return 'ie';
		}
	}
}


/*---------------
  ヘッダーのサガシテ画像切り替え
--------------- */
function changeRnkingData( targetValue ){
	var url = $(":hidden[name^='url']").val();
	var optionT = "TTT";

	if( targetValue ){
		optionT = targetValue;
	}

	location.href = url + "/RANKING/MMM/BBB/" + optionT + "/PPP/";
}


/*---------------
  ヘッダーのサガシテ画像切り替え
--------------- */
function setMouseOverEvent(){

	/* ボタン透過リスト */
	var hoverList = [{selecter:"#campaign"           ,target:".campaignimg"}					// キャンペーン：キャンペーン(リンク)
					,{selecter:"#newCar"             ,target:"a"}								// 今月の新車：スペックを見るボタン
					,{selecter:"#rankingForm"        ,target:".themeBox li" }					// ランキング：各車種毎のテーマ
					,{selecter:"#rankingForm"        ,target:"label"}							// ランキング：チェックボックス
					,{selecter:"#rankingForm"        ,target:".nextListButton"}					// ランキング：ランキングの続きを見る
					,{selecter:"#compare"            ,target:".compareSearchData a"}			// 比較：ランキングに戻るボタン
					,{selecter:"#compare"            ,target:".compareCarData .themeBox li"}	// 比較：各車種毎のテーマ
					,{selecter:"#compare"            ,target:".carChange td>a"}					// 比較：グレード変更
					,{selecter:"#compareDetail"      ,target:"span+span"}						// 比較：詳細開く／閉じるボタン
					,{selecter:"#selectModelTab"     ,target:"li"}								// 車種の変更：車種名
					,{selecter:"#modelNameResult"    ,target:"li"}								// 車種名検索：車種名
					,{selecter:"#footer"             ,target:"li"}								// フッター：お問い合わせ／お見積りのご依頼ボタン
					,{selecter:"#gotoTop"            ,target:"a",}								// フッター：ページのトップへボタン
					,{selecter:".searchForm"         ,target:".setCol"}							// 共通：検索条件(バリュー、メーカー、ボディタイプ)
					,{selecter:".actionBox"          ,target:"a"}								// 選択した検索条件(共通)：「この条件で検索」ボタン
					,{selecter:".actionBtn"          ,target:"a"}								// 選択した検索条件(共通)：「チェックした車種を比較」ボタン
					,{selecter:".searchBtn"          ,target:"a"}								// 選択した検索条件(共通)：「OK」／「キャンセル」ボタン
					,{selecter:"#popup"              ,target:"#footer a"}						// バリュー設定基準：「閉じる」ボタン
					,{selecter:"#checkAlert"         ,target:".closeBtn a"}						// ランキングのアラート：「閉じる」ボタン

					,{selecter:".header_top"         ,target:"a>div"}							// ヘッダー：「お見積りはこちら」ボタン

					,{selecter:"#rightfloatingPanel" ,target:"a"}								// サイドメニュー
					,{selecter:"#compareData"        ,target:".webCatalogue a"}					// 比較：「Webカタログ」リンク
					,{selecter:"#compareData"        ,target:"a.photoGalleryUrl"}				// 比較：「写真ギャラリー」リンク

					];

	// ボタン
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


	/* リンク */
	var linkList  = [{selecter:"#header"         ,target:".faul a"                 , color:"#4C00EE"}	// ヘッダー：「お見積りのご依頼」／「使い方ガイド」リンク
					,{selecter:"#campaign"       ,target:".campaignNoImg"          , color:"#EC7C00"}	// キャンペーン：キャンペーン(リンク)
					,{selecter:"#footer"         ,target:"div a"                   , color:"#4C00EE"}	// フッター：「プライバシーポリシー」リンク
					,{selecter:"#footerMal"      ,target:"li a"                    , color:"#4C00EE"}	// フッター：「プライバシーポリシー」／「お問い合わせ」リンク
					,{selecter:"#topPage"        ,target:".selectBox a"            , color:"#4C00EE"}	// トップ：「クリア」ボタン
					,{selecter:"#topPage"        ,target:".priceBox .clearBtn a"   , color:"#DAC5FF"}	// トップ：「クリア」ボタン(価格)
					,{selecter:"#rankingPage"    ,target:".searchForm .clearBtn a" , color:"#4C00EE"}	// ランキング：「クリア」ボタン
					,{selecter:"#rankingPage"    ,target:".selectBox .clearBtn a"  , color:"#A486E4"}	// ランキング：「条件を変更する」ボタン
					,{selecter:"#rankingPage"    ,target:".priceBox .clearBtn a"   , color:"#DAC5FF"}	// ランキング：「条件を変更する」ボタン(価格)
					,{selecter:"#selectMakerTab" ,target:".clearChecked a"         , color:"#DAC5FF"}	// 車種の変更：「クリア」ボタン
					,{selecter:"#topPage"        ,target:".basisOfSelectionLink a" , color:"#A486E4"}	// トップ：「設定基準」リンク
					,{selecter:"#rankingPage"    ,target:".basisOfSelectionLink a" , color:"#A486E4"}	// ランキング：「設定基準」リンク
					];

	// リンク
	for(var i = 0, i_len = linkList.length; i < i_len; i++){

		if( $(linkList[i].selecter).size() > 0){
			$(linkList[i].selecter).find(linkList[i].target).each(function(){
				var oleColor = $(this).css("color");
				var newColor = linkList[i].color;

				$(this).mouseover(function(){
					$(this).css("color",newColor);
				}).mouseup(function(){
					$(this).css("color","");
				}).mouseout(function(){
					$(this).css("color","");
				});
			})
		}
	}

}

/*---------------
  サイドメニュー
--------------- */
function setRightfloatingPanel(){

	var positionRight = $("#rightfloatingPanel .linkBlock").width() + 10;
    
	//cookieあるかどうか
	if (document.cookie.indexOf("rightfloatingPanelClose=on") != -1) {
		$("#rightfloatingPanel").stop(true, false).css({"visibility": "visible", 'right': '-' + positionRight + 'px'}).animate({opacity : 1}, 500);
		$("#rightfloatingPanel #rightfloatingPanelClose a").addClass("faChevronLeft").removeClass("faChevronRight");
	} else {
		$("#rightfloatingPanel").stop(true, false).css("visibility", "visible").animate({opacity : 1}, 500);
	}


	$("#rightfloatingPanel #rightfloatingPanelClose a").bind("click", function() {
		if( $("#rightfloatingPanel #rightfloatingPanelClose a").hasClass("faChevronLeft") ){
			// 開くボタン
				document.cookie = "rightfloatingPanelClose=off; path=/;";

			$("#rightfloatingPanel").animate({'right':'0px'}, 500);
			$("#rightfloatingPanel #rightfloatingPanelClose a").removeClass("faChevronLeft").addClass("faChevronRight");
		} else {
			// 閉じるボタン
				document.cookie = "rightfloatingPanelClose=on; path=/;";

			$("#rightfloatingPanel").animate({'right': '-' + positionRight + 'px'}, 500);
			$("#rightfloatingPanel #rightfloatingPanelClose a").addClass("faChevronLeft").removeClass("faChevronRight");
		}
	});

	var rfp_height;
	var window_height = $(window).height();

	set_center();

	$(window).resize(function() {
		set_center();
	});
}

/* 縦位置の設定 */
function set_center() {
	window_height = $(window).height();
	rfp_height = 82 * ($("#rightfloatingPanel #rightfloatingPanelInner a").length - 1) + 22;
	var parcent = Math.floor((((window_height - rfp_height) / 2) / window_height) * 100);
	$("#rightfloatingPanel").css({
		top : parcent + "%"
	})

}

/*-----------------------------------------------
  車種詳細画面の表示
------------------------------------------------*/
var openWndow = [];
function openDetailWindow( g_windowName, g_url, g_width, g_height ){
	var url = $(":hidden[name^='url']").val();
	var windowName = g_windowName.replace(/\s+|-/g, "");
	
	// ウィンドウが存在している場合、フォーカスを当てる
	if( openWndow[windowName] && !openWndow[windowName].closed ){
		openWndow[windowName].focus();
		return false;
	}

	if( !openWndow[windowName] ){
		openWndow.splice(windowName, windowName);
	}
	
	openWndow[windowName] = window.open( url + g_url, windowName, 'width=' + g_width + ',height=' + g_height + ',scrollbars=yes');

	return false;
}
