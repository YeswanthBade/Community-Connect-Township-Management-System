<cfset notifid = notifid>

<cfquery datasource="#session.datasource#">
	UPDATE #session.schema#.notifications
	SET is_read = true
	WHERE id = <cfqueryparam value="#notifid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfoutput>true</cfoutput>