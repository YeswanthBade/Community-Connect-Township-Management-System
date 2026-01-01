<cfcomponent>

    <!--- Method to fetch news --->
    <cffunction name="getNews" access="public" returntype="any" output="false">
        <cfquery name="getNewsQuery" datasource="#session.datasource#">
            SELECT news_id, title, contents, postedby, TO_CHAR(posteddate,'dd-mm-yyyy') as posteddate FROM #session.schema#.news
            ORDER BY posteddate DESC
        </cfquery>
        
        <cfreturn getNewsQuery>
    </cffunction>

    <!--- Method to fetch events --->
    <cffunction name="getEvents" access="public" returntype="any" output="false">
        <cfquery name="getEventsQuery" datasource="#session.datasource#">
            SELECT e.event_id, e.eventname, e.eventlocation, e.hostedby, e.status, TO_CHAR(e.eventdate,'dd-mm-yyyy') as eventdate, (SELECT r.response from #session.schema#.rsvp r WHERE e.event_id = r.event_id and r.resident_id = #session.userdetails.RES_ID#) FROM #session.schema#.events e
            ORDER BY e.eventdate DESC
        </cfquery>
        
        <cfreturn getEventsQuery>
    </cffunction>


    <!--- Add News --->
    <cffunction name="addNews" access="public" returntype="any">
        <cfargument name="title" type="string" required="true">
        <cfargument name="content" type="string" required="true">

        <cfquery name="addnews" datasource="#session.datasource#">
            INSERT INTO #session.schema#.news (title, contents, postedby)
            VALUES (<cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.content#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#session.userdetails.RES_ID#" cfsqltype="cf_sql_integer">
                    )
        </cfquery>
        <cfreturn true>
    </cffunction>

    <!--- Add Event --->
    <cffunction name="addEvent" access="public" returntype="any">
        <cfargument name="eventname" type="string" required="true">
        <cfargument name="eventdate" type="string" required="true">
        <cfargument name="eventlocation" type="string" required="true">

        <cfquery datasource="#session.datasource#">
            INSERT INTO #session.schema#.events (eventname, eventdate, eventlocation, hostedby)
            VALUES (
                <cfqueryparam value="#arguments.eventname#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.eventdate#" cfsqltype="cf_sql_date">,
                <cfqueryparam value="#arguments.eventlocation#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#session.userdetails.RES_ID#" cfsqltype="cf_sql_integer">
            )
        </cfquery>
        <cfreturn true>
    </cffunction>

    <!--- Edit news --->
    <cffunction name="editNews" access="public" returntype="any">
        <cfargument name="newsId" type="numeric" required="true">
        <cfargument name="newContent" type="string" required="true">

        <cfquery datasource="#session.datasource#">
            UPDATE #session.schema#.news
            SET contents = <cfqueryparam value="#arguments.newContent#" cfsqltype="cf_sql_varchar">
            WHERE news_id = <cfqueryparam value="#arguments.newsId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <!--- Edit Event --->
    <cffunction name="editEvent" access="public" returntype="any">
        <cfargument name="eventId" type="numeric" required="true">
        <cfargument name="eventdate" type="string" required="true">
        <cfargument name="eventlocation" type="string" required="true">
        <cfargument name="status" type="string" required="true">

        <cfquery datasource="#session.datasource#">
            UPDATE #session.schema#.events
            SET eventdate = <cfqueryparam value="#arguments.eventdate#" cfsqltype="cf_sql_date">,
                status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">,
                eventlocation = <cfqueryparam value="#arguments.eventlocation#" cfsqltype="cf_sql_varchar">
            WHERE event_id = <cfqueryparam value="#arguments.eventId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <!--- RSVP Event --->
    <cffunction name="rsvpEvent" access="public" returntype="any">
        <cfargument name="eventId" type="numeric" required="true">
        <cfargument name="rsvp" type="string" required="true">

        <cfquery datasource="#session.datasource#">
            INSERT INTO #session.schema#.rsvp (event_id, resident_id, response)
            VALUES (
                <cfqueryparam value="#arguments.eventId#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#session.userdetails.RES_ID#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#arguments.rsvp#" cfsqltype="cf_sql_varchar">
            )
        </cfquery>
        <cfreturn true>
    </cffunction>

</cfcomponent>


