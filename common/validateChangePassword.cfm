<cfset oldPassword = oldPassword>
<cfset newPassword = newPassword>
<cfset password = Hash(oldPassword,'MD5')>
<cfset hashedPassword = Hash(newPassword,'MD5')>


<cfquery name="checkPassword" datasource="#session.datasource#">
	SELECT * from #session.schema#.residents
	WHERE password = lower(<cfqueryparam value="#password#" cfsqltype="cf_sql_varchar">)
	and res_id = <cfqueryparam value="#session.userdetails.RES_ID#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif checkPassword.recordCount() GT 0>
	<cfquery datasource="#session.datasource#">
		UPDATE #session.schema#.residents
		SET password = lower(<cfqueryparam value="#hashedPassword#" cfsqltype="cf_sql_varchar">)
		WHERE res_id = <cfqueryparam value="#session.userdetails.RES_ID#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfoutput>true</cfoutput>
<cfelse>
	<cfoutput>false</cfoutput>
</cfif>