<cfcomponent>

<!--- Submit a Maintenance Request --->
<cffunction name="submitRequest" access="public" returntype="any">
    <cfargument name="service_id" type="string" required="true">
    <cfargument name="issue_description" type="string" required="true">

    <cfquery datasource="#session.datasource#">
        INSERT INTO #session.schema#.maintenance_requests (resident_id, service_id, issue_description)
        VALUES (
            <cfqueryparam value="#session.userdetails.RES_ID#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#arguments.service_id#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#arguments.issue_description#" cfsqltype="cf_sql_longvarchar">
        );
    </cfquery>

    <cfreturn true>
</cffunction>

<!--- Get All Maintenance Requests (For Admin & Maintenance Staff) --->
<cffunction name="getAllRequests" access="public" returnformat="json">
    <cfquery name="requests" datasource="#session.datasource#">
        SELECT r.request_id, u.first_name, u.last_name, s.service_name, r.issue_description, r.assigned_to, COALESCE(staff.first_name, 'Not Assigned') AS assigned_to_name, r.status, COALESCE(r.completion_notes, 'N/A') AS completion_notes
        FROM #session.schema#.maintenance_requests r
        INNER JOIN #session.schema#.residents u ON r.resident_id = u.res_id
        INNER JOIN #session.schema#.maintenance_services s ON r.service_id = s.service_id
        LEFT JOIN #session.schema#.residents staff ON r.assigned_to = staff.res_id
        <cfif session.userdetails.ROLE_ID eq 2>
            WHERE r.resident_id = <cfqueryparam value="#session.userdetails.RES_ID#" cfsqltype="cf_sql_integer">
        </cfif>
        ORDER BY r.request_date DESC;
    </cfquery>

    <cfreturn requests>
</cffunction>

<!--- Update Maintenance Request Status (Maintenance Staff) --->
<cffunction name="updateStatus" access="public" returntype="any">
    <cfargument name="request_id" type="numeric" required="true">
    <cfargument name="status" type="string" required="true">
    <cfargument name="completion_notes" type="string" required="false">

    <cfquery datasource="#session.datasource#">
        UPDATE #session.schema#.maintenance_requests
        SET status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">,
            completion_notes = <cfqueryparam value="#arguments.completion_notes#" cfsqltype="cf_sql_longvarchar">
        WHERE request_id = <cfqueryparam value="#arguments.request_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfreturn true>
</cffunction>

<!--- Fetch All Maintenance Staff --->
<cffunction name="getMaintenanceStaff" access="public" returnformat="json">
    <cfquery name="staffList" datasource="#session.datasource#">
        SELECT res_id, first_name 
        FROM #session.schema#.residents
        WHERE role_id = 4;
    </cfquery>

    <cfreturn SerializeJSON(staffList)>
</cffunction>

</cfcomponent>
