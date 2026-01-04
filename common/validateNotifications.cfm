<cfquery name="getNotifications" datasource="#session.datasource#">
    SELECT id, message, created_at, is_read 
    FROM #session.schema#.notifications 
    WHERE resident_id = #session.userdetails.RES_ID# and is_read = false
    ORDER BY created_at DESC;
</cfquery>

<cfoutput>
    <cfif getNotifications.recordCount() GT 0>
        <cfloop query="getNotifications">
            <div class="notification-item <cfif #getNotifications.is_read#>read</cfif>" data-id="#getNotifications.id#">
                <p>#getNotifications.message#</p>
                <div class="date-and-btn"><small>#dateFormat(getNotifications.created_at, "yyyy-mm-dd")#</small>
                <button class="mark-as-read" data-id="#getNotifications.id#">Mark as Read</button></div>
            </div><br>
        </cfloop>
    <cfelse>
        <br>
        <div class="no-notification">
            <p>No Notifications</p>
        </div><br>
    </cfif>
</cfoutput>