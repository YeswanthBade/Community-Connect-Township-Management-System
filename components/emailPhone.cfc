<cfcomponent>
    <cffunction name="checkEmail" access="public" returntype="any">
        <cfargument name="email" type="string" required="true">

        <cfquery name="qCheckEmail" datasource="#session.datasource#">
            SELECT email 
            FROM #session.schema#.residents
            WHERE email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <cfif qCheckEmail.recordCount gt 0>
            <cfreturn true>
        <cfelse>
            <cfreturn false>
        </cfif>
    </cffunction>

    <cffunction name="checkPhone" access="public" returntype="any">
        <cfargument name="phoneNumber" type="string" required="true">

        <cfquery name="qCheckPhone" datasource="#session.datasource#">
            SELECT phone_number 
            FROM #session.schema#.residents
            WHERE phone_number = <cfqueryparam value="#arguments.phoneNumber#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <cfif qCheckPhone.recordCount GT 0>
            <cfreturn true>
        <cfelse>
            <cfreturn false>
        </cfif>
    </cffunction>
</cfcomponent>
