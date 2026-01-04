<cfset phonenum = trim(phonenum)>
<cfset password = trim(password)>


<cfset output = application.checked.logincheck(phone=phonenum, password=password)>

<cfoutput>#output#</cfoutput>