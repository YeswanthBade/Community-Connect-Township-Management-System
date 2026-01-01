<cfcomponent>
    <cffunction name="logincheck" access="public" returntype="any">
        <cfargument required="true" type="string" name="phone">
        <cfargument required="true" type="string" name="password">

       
        <cfquery name="qLogin" datasource="#session.datasource#">
            SELECT r.res_id, r.first_name, r.address, r.role_id, r.email, (SELECT ro.role_name FROM #session.schema#.roles ro WHERE ro.role_id = r.role_id) AS role_name
            FROM #session.schema#.residents r
            WHERE phone_number = <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar"> 
            and password = <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <!--- <cfset var qrole = serializeJSON(qLogin)> --->
        
        <cfif qLogin.recordCount gt 0>
            <cfset session.userdetails = qLogin>
            <cfset session.ROLE_ID = qLogin.role_id>
            <cfquery name="checkStatus" datasource="#session.datasource#">
                SELECT invoice_id, due_date FROM #session.schema#.invoices
                WHERE status = 'Unpaid'
            </cfquery>
            <cfloop query="checkStatus">
                <cfquery datasource="#session.datasource#">
                <cfif now() GT #due_date#>
                    UPDATE #session.schema#.invoices
                    SET status = 'Overdue'
                    WHERE invoice_id = <cfqueryparam value="#invoice_id#" cfsqltype="cf_sql_integer">
                </cfif>
                </cfquery>
            </cfloop>


            <cfquery name="overdueOfResident" datasource="#session.datasource#">
                SELECT i.resident_id, i.invoice_id, n.is_read
                FROM #session.schema#.invoices i
                LEFT JOIN #session.schema#.notifications n
                ON i.resident_id = n.resident_id and i.invoice_id = n.invoice_id
                WHERE i.status = 'Overdue' and i.resident_id = #session.userdetails.RES_ID#
            </cfquery>

            <cfloop query="overdueOfResident">
                <cfif #is_read# eq 1>
                    <cfquery datasource="#session.datasource#">
                        UPDATE #session.schema#.notifications
                        SET is_read = false
                        WHERE resident_id = #overdueOfResident.resident_id# and invoice_id = #overdueOfResident.invoice_id#
                    </cfquery>
                <cfelseif #is_read# neq 0>
                    <cfquery datasource="#session.datasource#">
                        INSERT INTO #session.schema#.notifications (resident_id, invoice_id, message)
                        VALUES (#overdueOfResident.resident_id#, #overdueOfResident.invoice_id#, 'Your invoice is overdue. Please make a payment.')
                    </cfquery>
                </cfif>
            </cfloop>
            <cfreturn true>
        <cfelse>
            <cfreturn false>
        </cfif>
        
    </cffunction>
</cfcomponent>
 