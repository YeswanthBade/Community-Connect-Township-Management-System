<cfcomponent>
	<cfset this.name="community_connect">
	<cfset this.appicationtimeout=createTimespan(0,8,0,0)>
	<cfset this.applicationmanagement=true/>
    <cfset this.sessionManagement=true/>
	<cfset this.sessiontimeout=createTimespan(0, 3, 0, 0)> 

    <cffunction name="onApplicationStart" returntype="void">
        <!--- Create an object for login and registration components --->
        <cfset application.checked = createObject('component', 'components.login')>
        <cfset application.registration = createObject('component', 'components.registration')>
        <cfset application.emailPhoneChecker = createObject('component', 'components.emailPhone')>
        <cfset application.getdata = createObject('component', 'components.dataTable')>
        <cfset application.newsevents = createObject('component', 'components.newsAndEvents')>
        <cfset application.visitor = createObject('component', 'components.visitors')>
        <cfset application.amenities = createObject('component', 'components.amenities')>
        <cfset application.committee = createObject('component', 'components.committeeUpdates')>
        <cfset application.maintenance = createObject('component', 'components.maintenance')>
        <cfset application.payments = createObject('component', 'components.payments')>
    </cffunction>

    <cffunction name="onRequestStart" returnType="void" output="false">
    </cffunction>

    <cffunction name="onSessionStart">
        <cfset session.datasource="cc_database">
        <cfset session.schema="ccschema">
    </cffunction> 

    <cffunction name="onError" returntype="void">
        <cfargument name="Exception" type="any" required="true"/>
        <cfargument name="EventName" type="any" required="true"/>
        <cfsavecontent variable="ErrorDetails">
            <h1>Error Info</h1>
            <cfdump var="#arguments#">
        </cfsavecontent>
        <cfset session.showError=ErrorDetails>
    </cffunction>

    <cffunction name="onSessionEnd" returntype="void" access="public">
    </cffunction>
	
</cfcomponent>
