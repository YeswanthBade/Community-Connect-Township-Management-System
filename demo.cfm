<cfset demo = 'Cancelled'>

<select class="text-box">
    <option value="Scheduled" <cfif demo eq 'Scheduled'>selected<cfelse></cfif>>Scheduled</option>
    <option value="Cancelled" <cfif demo eq 'Cancelled'>selected<cfelse></cfif>>Cancelled</option>
    <option value="Completed" <cfif demo eq 'Completed'>selected<cfelse></cfif>>Completed</option>
</select>


<select class="text-box">
    <option value="Yes" <cfif #output.response# eq 'Yes'>selected<cfelse></cfif>>Yes</option>
    <option value="No" <cfif #output.response# eq 'No'>selected<cfelse></cfif>>No</option>
    <option value="Maybe" <cfif #output.response# eq 'Maybe'>selected<cfelse></cfif>>Maybe</option>
</select>