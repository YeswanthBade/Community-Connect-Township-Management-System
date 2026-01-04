<cfset firstName = trim(form.firstName)>
<cfset lastName = trim(form.lastName)>
<cfset email = trim(form.email)>
<cfset phoneNumber = trim(form.phoneNumber)>
<cfset address = trim(form.address)>
<cfset role = trim(form.role)>
<cfset password = trim(form.password)>

<!--- Call the registerResident function --->
<cfset output = application.registration.registerResident(
    firstName=firstName, 
    lastName=lastName, 
    email=email, 
    phoneNumber=phoneNumber, 
    address=address,
    role=role,
    password=password
)>

<!--- Output the result --->
<cfoutput>#serializeJSON(output)#</cfoutput>
