<cfcomponent>

    <cffunction name="getUpdates" access="public" returntype="any">
        <cfquery name="getUpdatesQuery" datasource="#session.datasource#">
            SELECT u.update_id, u.title, u.description, c.committee_name, r.first_name, u.posted_date, u.status, u.committee_id
            FROM #session.schema#.committee_updates u
            INNER JOIN #session.schema#.committee_details c ON u.committee_id = c.committee_id
            INNER JOIN #session.schema#.residents r ON u.posted_by = r.res_id
            ORDER BY u.created_at DESC;
        </cfquery>

        <cfreturn getUpdatesQuery>
    </cffunction>

     
    <cffunction name="getMembers" access="public" returntype="any">
        <cfargument name="memberrole" type="string">
        <cfargument name="committeeid" type="string">
        <cfquery name="getMembersQuery" datasource="#session.datasource#">
            SELECT m.member_id, r.first_name, d.committee_name, m.member_role, r.phone_number
            FROM #session.schema#.committee_members m
            INNER JOIN #session.schema#.residents r ON m.resident_id = r.res_id
            INNER JOIN #session.schema#.committee_details d ON m.committee_id = d.committee_id
            <cfif len(arguments.memberrole) gt 0>
                WHERE m.committee_id = <cfqueryparam value="#arguments.committeeid#" cfsqltype="cf_sql_integer">
            </cfif>
            ORDER BY m.committee_id DESC, m.member_role ASC;
        </cfquery>

        <cfreturn getMembersQuery>
    </cffunction>

    <cffunction name="addUpdate" access="public" returntype="any">
        <cfargument name="title" type="string">
        <cfargument name="committee_id" type="numeric">
        <cfargument name="description" type="string">
        <cfargument name="status" type="string">

        <cfquery datasource="#session.datasource#">
            INSERT INTO #session.schema#.committee_updates (title, description, committee_id, posted_by, posted_date, status)
            VALUES (
                <cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar">,
                <cfqueryparam value="#arguments.committee_id#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#session.userdetails.RES_ID#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#DateFormat(Now(), 'yyyy-mm-dd')#" cfsqltype="cf_sql_date">,
                <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
            );
        </cfquery>

        <cfreturn true>
    </cffunction>


    <cffunction name="addCommittee" access="public" returntype="any">
        <cfargument name="cname" type="string">
        <cfargument name="residentid" type="numeric">
        <cfargument name="description" type="string">

        <cfquery datasource="#session.datasource#">
            INSERT INTO #session.schema#.committee_details (committee_name, committee_description, created_date)
            VALUES (
                <cfqueryparam value="#arguments.cname#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar">,
                <cfqueryparam value="#DateFormat(Now(), 'yyyy-mm-dd')#" cfsqltype="cf_sql_date">
            );
        </cfquery>

        <cfquery name="comid" datasource="#session.datasource#">
            SELECT committee_id FROM #session.schema#.committee_details 
            WHERE committee_name = <cfqueryparam value="#arguments.cname#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <cfquery datasource="#session.datasource#">
            INSERT INTO #session.schema#.committee_members (resident_id, committee_id, member_role)
            VALUES (
                <cfqueryparam value="#arguments.residentid#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#comid.committee_id#" cfsqltype="cf_sql_integer">,
                'Head'
            );
        </cfquery>
        <cfreturn true>
    </cffunction>


    <cffunction name="addMumber" access="public" returntype="any">
        <cfargument name="residentid" type="numeric">
        <cfargument name="committeeid" type="numeric">

        <cfquery datasource="#session.datasource#">
            INSERT INTO #session.schema#.committee_members (resident_id, committee_id, member_role)
            VALUES (
                <cfqueryparam value="#arguments.residentid#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#arguments.committeeid#" cfsqltype="cf_sql_integer">,
                'Member'
            );
        </cfquery>
        <cfreturn true>
    </cffunction>


    <cffunction name="editUpdate" access="public" returntype="any">
        <cfargument name="updateid" type="numeric">
        <cfargument name="title" type="string">
        <cfargument name="description" type="string">
        <cfargument name="status" type="string">

        <cfquery datasource="#session.datasource#">
            UPDATE #session.schema#.committee_updates
            SET title = <cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">,
                description = <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar">,
                status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
            WHERE update_id = <cfqueryparam value="#arguments.updateid#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn true>
    </cffunction>


    <cffunction name="deleteUpdate" access="public" returntype="any">
        <cfargument name="update_id" type="numeric" required="true">

        <cfquery datasource="#session.datasource#">
            DELETE FROM #session.schema#.committee_updates
            WHERE update_id = <cfqueryparam value="#arguments.update_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn SerializeJSON({ "status": "success", "message": "Committee Update Deleted Successfully!" })>
    </cffunction>

</cfcomponent>
