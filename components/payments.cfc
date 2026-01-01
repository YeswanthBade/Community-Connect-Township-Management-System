<cfcomponent>


    <!--- Get invoices --->
    <cffunction name="getInvoices" access="public" returntype="any">
            <cfquery name="invoices" datasource="#session.datasource#">
            SELECT i.invoice_id, TO_CHAR(i.invoice_date, 'Mon dd, yyyy') as invoice_date, TO_CHAR(i.due_date, 'Mon dd, yyyy') as due_date, i.amount, i.status, i.description, u.first_name AS resident_name, TO_CHAR(p.payment_date, 'Mon dd, yyyy') as payment_date
            FROM #session.schema#.invoices i
            INNER JOIN #session.schema#.residents u ON i.resident_id = u.res_id
            LEFT JOIN #session.schema#.payments p ON i.invoice_id = p.invoice_id
            <cfif session.userdetails.ROLE_ID eq 2>
                WHERE resident_id = <cfqueryparam value="#session.userdetails.RES_ID#" cfsqltype="cf_sql_integer">
            </cfif>
            ORDER BY i.status ASC;
        </cfquery>
        <cfreturn invoices>
    </cffunction>

    <!--- Make a payment --->
    <cffunction name="makePayment" access="public" returntype="any">
        <cfargument name="invoice_id" type="numeric" required="true">
        <cfargument name="amount" type="numeric" required="true">
        <cfargument name="payment_mode" type="string" required="true">
        <cfargument name="reference_number" type="string" required="true">

        <cfquery datasource="#session.datasource#">
            INSERT INTO #session.schema#.payments (invoice_id, paid_by, payment_date, amount, payment_mode, reference_number)
            VALUES (
                <cfqueryparam value="#arguments.invoice_id#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#session.userdetails.RES_ID#" cfsqltype="cf_sql_integer">,
                CURRENT_DATE,
                <cfqueryparam value="#arguments.amount#" cfsqltype="cf_sql_decimal">,
                <cfqueryparam value="#arguments.payment_mode#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.reference_number#" cfsqltype="cf_sql_varchar">
            )
        </cfquery>

        <!--- date invoice status to Paid --->
        <cfquery datasource="#session.datasource#">
            UPDATE #session.schema#.invoices
            SET status = 'Paid'
            WHERE invoice_id = <cfqueryparam value="#arguments.invoice_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn true>
    </cffunction>


    <!--- Bulk Invoice Generator --->
    <cffunction name="generateBulkMonthlyInvoices" access="public" returntype="any">
        <cfquery name="getResidents" datasource="#session.datasource#">
            SELECT res_id, first_name
            FROM #session.schema#.residents
            WHERE role_id = 2
        </cfquery>

        <cfset invoiceForMonth = DateAdd("m", -1, now())>
        <cfset descriptionMonth = DateFormat(invoiceForMonth, "mmmm yyyy")>
        <cfset dueDate = DateAdd("d", 15, now())>  <!--- Due 15 days from today --->
        <cfset monthlyFee = 2500>

        <cfset count = 0>
        <cfloop query="getResidents">
            <cfquery datasource="#session.datasource#">
                INSERT INTO #session.schema#.invoices (resident_id, due_date, amount, status, description)
                VALUES (
                    <cfqueryparam value="#getResidents.res_id#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#dueDate#" cfsqltype="cf_sql_date">,
                    <cfqueryparam value="#monthlyFee#" cfsqltype="cf_sql_decimal">,
                    'Unpaid',
                    <cfqueryparam value="Monthly Maintenance Fee for #descriptionMonth#" cfsqltype="cf_sql_longvarchar">
                )
            </cfquery>
            <cfset count = count + 1>
        </cfloop>

        <cfreturn #count#>
    </cffunction>

</cfcomponent>
