<?php

	/**
	 * デバッグモード
	 */
	$ini["debug"]["level"] = 7;

	if ($_SERVER["HTTPS"]) {
		$ini["secureMode"] = "on";
		$ini["session"]["zone"] = "sagacite:sales";
		$ini["session"]["mode"] = "login";
		$ini["session"]["loginRootUrl"] = "https, salesPromotion/LOGIN";
		$ini["session"]["defaultLoginUrl"] = "https, /";
		$ini["session"]["defaultLogoutUrl"] = "http, /";
		$ini["session"]["loginWithEmail"] = "yes";
	} else {
		$ini["secureMode"] = "none";
		$ini["session"]["zone"] = "";
		$ini["session"]["mode"] = "none";
		$ini["session"]["loginRootUrl"] = "https, /LOGIN";
		$ini["session"]["defaultLoginUrl"] = "https, /admin";
		$ini["session"]["defaultLogoutUrl"] = "http, /";
		$ini["session"]["loginWithEmail"] = "no";
	}

?>
