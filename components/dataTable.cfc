<cfcomponent>
    <cffunction name="fetchUsersTable" access="public" returntype="any">
        <cfargument required="false" type="string" name="rolefil">
        <cfargument required="false" type="string" name="namefil">

        <cfset var getUsers = "">

        <cfquery name="getUsers" datasource="#session.datasource#">
            SELECT res.res_id, res.first_name, res.address, res.phone_number, res.role_id, r.role_name 
            FROM #session.schema#.residents res
            inner join #session.schema#.roles r
            on r.role_id = res.role_id
            WHERE 1=1
            <cfif rolefil neq "all">
                AND res.role_id = <cfqueryparam value="#rolefil#" cfsqltype="cf_sql_integer">
            </cfif>
            <cfif len(trim(namefil)) gt 0>
                AND LOWER(res.first_name) LIKE LOWER(<cfqueryparam value="%#trim(namefil)#%" cfsqltype="cf_sql_varchar">)
            </cfif>
            ORDER BY res_id ASC
        </cfquery>

        <cfreturn getUsers>
    </cffunction>

    <cffunction name="updateRoles" access="public" returntype="any">
        <cfargument required="true" type="integer" name="newRole">
        <cfargument required="true" type="string" name="ResId">

        <cfquery datasource="#session.datasource#">
            UPDATE #session.schema#.residents
            SET role_id = <cfqueryparam value="#arguments.newRole#" cfsqltype="cf_sql_integer">
            WHERE res_id = <cfqueryparam value="#arguments.ResId#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn true>
    </cffunction>

</cfcomponent>
