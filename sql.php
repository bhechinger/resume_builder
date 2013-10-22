<?php
require_once "pgsql.php";
#require_once "mysql.php";
#require_once "oracle.php";

function runQuery($query) {
	global $conf;
	if ($conf['sql']['type'] == 'pgsql') {
		return(pg_runQuery($query));
	} elseif ($conf['sql']['type'] == 'mysql') {
		#dummy placeholder
	} elseif ($conf['sql']['type'] == 'oracle') {
		#dummy placeholder
	} else {
		return(NULL);
	}
}

?>
