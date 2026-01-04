<cfset firstname = firstname>
<cfset lastname = lastname>
<cfset email = email>
<cfset phone = phone>
<cfset address = address>

<cfquery datasource="#session.datasource#">
	UPDATE #session.schema#.residents
	SET 
	first_name = <cfqueryparam value="#firstname#" cfsqltype="cf_sql_varchar">, 
	last_name = <cfqueryparam value="#lastname#" cfsqltype="cf_sql_varchar">, 
	email = <cfqueryparam value="#email#" cfsqltype="cf_sql_varchar">, 
	phone_number = <cfqueryparam value="#phone#" cfsqltype="cf_sql_varchar">, 
	address = <cfqueryparam value="#address#" cfsqltype="cf_sql_varchar">
	WHERE res_id = #session.userdetails.RES_ID#
</cfquery>

<cfoutput>true</cfoutput>