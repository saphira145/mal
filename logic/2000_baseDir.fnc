<?php

/**
 * 2013-12-10  井上 義勝 <y-inoue@hoyusys.co.jp>
 * Apache などの Alias 設定に対応
 * (スクリプトがドキュメントルート外にある)
 */
$output['BASE_DIR'] = ($path['alias'])
	? $path['alias']
	: '';

?>
