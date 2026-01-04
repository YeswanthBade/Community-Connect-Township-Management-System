<cfset field = trim(form.field)>
<cfset value = trim(form.value)>

<cfif field eq "email" >
    <cfset outputc = application.emailPhoneChecker.checkEmail(email=value)>
<cfelse>
    <cfset outputc = application.emailPhoneChecker.checkPhone(phoneNumber=value)>
</cfif>

<cfoutput>#outputc#</cfoutput>
