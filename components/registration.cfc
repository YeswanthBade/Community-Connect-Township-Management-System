<cfcomponent> 
    <cffunction name="registerResident" access="public" returntype="any" output="false">
        <!--- Define required arguments --->
        <cfargument required="true" type="string" name="firstName">
        <cfargument required="true" type="string" name="lastName">
        <cfargument required="true" type="string" name="email">
        <cfargument required="true" type="string" name="phoneNumber">
        <cfargument required="true" type="string" name="address">
        <cfargument required="false" type="string" name="role">
        <cfargument required="true" type="string" name="password">

        <cfif arguments.role eq ''>
            <cfset role = 2>
        <cfelse>
            <cfset role = arguments.role>
        </cfif>

            <!--- Check if phone number or email already exists --->
        <!--- <cfquery name="qCheck" datasource="cc_database">
            SELECT phone_number, email 
            FROM ccschema.residents
            WHERE phone_number = <cfqueryparam value="#arguments.phoneNumber#" cfsqltype="cf_sql_varchar">
               OR email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <cfif qCheck.recordCount gt 0>
            <cfreturn { "status": "error", "message": "Phone number or email already exists." }>
        </cfif> --->

        <!--- Insert the new resident details --->
        <cfquery datasource="#session.datasource#">
            INSERT INTO #session.schema#.residents (first_name, last_name, email, phone_number, address, password,role_id)
            VALUES (
                <cfqueryparam value="#arguments.firstName#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.lastName#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.phoneNumber#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#role#" cfsqltype="cf_sql_integer">
            )
        </cfquery>

        <!--- Return success response --->
        <cfreturn { "status": "success", "message": "Registration successful, Redirecting to..." }>

        <!--- Handle errors and return error response --->
        <!--- <cfreturn { "status": "error", "message": "An error occurred: #cfcatch.message#" }> --->
    </cffunction>
</cfcomponent>
