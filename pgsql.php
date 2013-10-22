<?php
require_once "conf/config.php";

function pg_runQuery($query) {
	global $conf;

	$dbname = $conf['sql']['database'];
	$dbhost = $conf['sql']['server'];
	$dbuser = $conf['sql']['user'];
	$dbpassword = $conf['sql']['password'];

	$dbconn = pg_connect("dbname=$dbname host=$dbhost user=$dbuser password=$dbpassword");
	if ($dbconn == FALSE) {
		return(FALSE);
	}

	$result = pg_query($query);
	if ($result == FALSE) {
		pg_last_error($dbconn);
		return(FALSE);
	}

	pg_close($dbconn);
	while ($row = pg_fetch_row($result)) {
		$r[] = $row;
	}
	return($r);
}

?>
