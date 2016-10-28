$(function(){
	// 見積りフォーム
	$(".estimate").on("click", function(e) {
		if( $("form[name=form_estimate]").size() > 0 ){
			e.preventDefault();
			document.form_estimate.submit();
		}
	});


	/*** 比較表開閉 ***/
	$("#compare h2 span").on("click", function() {
		var detail = $("a", this).attr("data-detail");
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

		$("#" + detail + " div:not(.attention)").slideToggle('slow');
		$("a", this).text(newAlt);
		
		setTimeout(function(){
			fixedCompareCarName();
		}, 500);

	});


	// 車種名表示エリア、もっとも長い車種に合わせて高さを調整する
	var carNameHeight = 0;
	$("#compare #compareData .carName").each(function(){
		if( carNameHeight < $(this).height() ){
			carNameHeight = $(this).height();
		}
	});
	if( carNameHeight > 0 ){
		$(".carName").height(carNameHeight);
		
		// 選択した検索条件右の矢印を、車種名表示エリアの中央に調整する
		var csstop = $(".carImg").height() + ( ( $(".carName").height() + $(".carChange").height() ) / 2) - ( $("#compare .caretRight").height() / 2 ) + "px";
		$("#compare .caretRight").css("top", csstop);
	}


	/*** スクロールで特定位置を超えたらフローティング表示 ***/
	var startHeight = $("#compareData .carChange").offset().top;
	var endHeight   = "";
	var compareCarNameHeight = $("#compareCarName").height();
	$("#gotoTop").css({"margin-top" : compareCarNameHeight+"px"});

	$(window).scroll(function(){
		fixedCompareCarName();
	});

	var fixedCompareCarName = function(){
		// 「ページのトップへ」の表示位置 - ウィンドウサイズ
		endHeight   = $("#gotoTop").offset().top - $(window).height();

		if( $(this).scrollTop() > startHeight && $(this).scrollTop() < endHeight ){
			$("#compareCarName").css({"position": "fixed"});
			$("#compareCarName>div").addClass("boxShadow");
			$("#compareCarName .compareIcon").addClass("bgImage");
			$("#gotoTop").css({"margin-top" : compareCarNameHeight+"px"});
		} else {
			$("#compareCarName").css({"position": "static"});
			$("#compareCarName>div").removeClass("boxShadow");
			$("#compareCarName .compareIcon").removeClass("bgImage");
			$("#gotoTop").css({"margin-top" : ""});
		}
	}

    /*---------------
     Ajax Check Password
     --------------- */


    $(".compare-recomCar").on("click", function(){
        var url             = $(".compareCarData .compare-recomCar").attr('data-url');
        var pass            = $(":hidden[name^='compare[string_en]']").val();
        pass = pass.split(',');

        compareShowDialog("パスワードを入力してください", pass, url);

    });

    function compareShowDialog ( msg, pass, url ) {
        var passInput            = prompt( msg, '' );

        if (passInput != null) {
            // check password
            if ( $.inArray(passInput, pass) > -1 ) {
                window.open(url, '_blank');
            } else {
                compareShowDialog("パスワードが違います");
            }
        }

        return true;
    }

});
