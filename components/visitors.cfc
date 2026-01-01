<cfcomponent> 
    <cffunction name="visitorLogging" access="public" returntype="any" output="false">
        <!--- Define required arguments --->
        <cfargument required="true" type="string" name="visitorName">
        <cfargument required="true" type="string" name="contactNumber">
        <cfargument required="false" type="string" name="res_id">
        <cfargument required="true" type="string" name="visitorPurpose">
        <cfargument required="true" type="string" name="date">
        <cfargument required="true" type="string" name="time">


        <cfset timeDate = "#arguments.date#" & " " & "#arguments.time#" & ":00">

        <cfif session.userdetails.res_id eq 2>
            <cfset res_id = "#session.userdetails.res_id#">
        <cfelse>
            <cfset res_id = "#arguments.res_id#"></cfif>

        <!--- Insert the new resident details --->
        <cfquery datasource="#session.datasource#">
            INSERT INTO #session.schema#.visitors (resident_id, visitor_name, phonenumber, purpose, visit_date)
            VALUES (
                <cfqueryparam value="#res_id#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#arguments.visitorName#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.contactNumber#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.visitorPurpose#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#timeDate#" cfsqltype="cf_sql_timestamp">

            )
        </cfquery>
        
        <cfreturn true>
    </cffunction>

    <cffunction name="visitorsData" access="public" returntype="any" output="false">
        <cfargument required="false" type="string" name="datefil">
        <cfargument required="false" type="string" name="namefil">

        <cfset var getVisitors = "">

        <cfquery name="getVisitors" datasource="#session.datasource#">
            SELECT r.first_name, v.visitor_name, TO_CHAR(v.visit_date,'Month dd, yyyy hh12:mi am') as visitor_date, v.phonenumber, v.visitor_id
            FROM #session.schema#.visitors v
            INNER JOIN #session.schema#.residents r ON r.res_id = v.resident_id
            WHERE 1=1
            <cfif session.userdetails.ROLE_ID eq 2>
                AND resident_id = 2
            </cfif>
            <cfif datefil neq "">
                AND date(visit_date) = <cfqueryparam value="#datefil#" cfsqltype="cf_sql_timestamp">
            </cfif>
            <cfif len(trim(namefil)) gt 0>
                AND LOWER(visitor_name) LIKE LOWER(<cfqueryparam value="%#trim(namefil)#%" cfsqltype="cf_sql_varchar">)
            </cfif>
            ORDER BY visit_date DESC
        </cfquery>

        <cfreturn getVisitors>
    </cffunction>

    <cffunction name="editVisitor" access="public" returntype="any" output="false">
        <cfargument name="visitorid" type="string" required="true">
        <cfargument name="firstName" type="string" required="true">
        <cfargument name="dateOfVisit" type="string" required="true">

        <cfset var result = "">

        <cftry>
            <!--- Update query to modify visitor details --->
            <cfquery datasource="#session.datasource#">
                UPDATE #session.schema#.visitors
                SET 
                    visitor_name = <cfqueryparam value="#arguments.firstName#" cfsqltype="cf_sql_varchar">,
                    visit_date = <cfqueryparam value="#arguments.dateOfVisit#" cfsqltype="cf_sql_timestamp">
                WHERE 
                    visitor_id = <cfqueryparam value="#arguments.visitorid#" cfsqltype="cf_sql_integer">
            </cfquery>

            <cfset result = "Visitor details updated successfully.">
            <cfcatch>
                <cfset result = "Error updating visitor: #cfcatch.message#">
            </cfcatch>
        </cftry>

        <cfreturn result>
    </cffunction>


    <cffunction name="deleteVisitor" access="public" returntype="any" output="false">
        <cfargument name="visitorid" type="string" required="true">

        <cfset var result = "">

        <cftry>
            <!--- Delete query to remove visitor details --->
            <cfquery datasource="#session.datasource#">
                DELETE FROM #session.schema#.visitors
                WHERE visitor_id = <cfqueryparam value="#arguments.visitorid#" cfsqltype="cf_sql_integer">
            </cfquery>

            <cfset result = "Visitor deleted successfully.">
            <cfcatch>
                <cfset result = "Error deleting visitor: #cfcatch.message#">
            </cfcatch>
        </cftry>

        <cfreturn result>
    </cffunction>
</cfcomponent>