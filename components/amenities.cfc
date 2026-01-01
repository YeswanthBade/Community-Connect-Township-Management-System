<cfcomponent>
    
    <!--- Function to Fetch All Amenities --->
    <cffunction name="fetchAmenities" access="public" returntype="any">
        <cfargument name="nameFilter" type="string" required="false">
        <cfargument name="statusFilter" type="string" required="false">

        <cfquery name="getAmenities" datasource="#session.datasource#">
            SELECT amenity_id, name, location, max_capacity, booking_required, TO_CHAR(available_from,'hh12:miam') as available_from, TO_CHAR(available_to,'hh12:miam') as available_to, status
            FROM #session.schema#.amenities
            WHERE name ilike <cfqueryparam value="%#nameFilter#%" cfsqltype="cf_sql_varchar">
            and status ilike <cfqueryparam value="%#statusFilter#%" cfsqltype="cf_sql_varchar">
            ORDER BY location;
        </cfquery>
        
        <cfreturn getAmenities>
    </cffunction>

    <!--- Function to Check for Booking Conflicts --->
    <cffunction name="checkAvailability" access="public" returntype="any">
        <cfargument name="amenity_id" type="numeric" required="true">
        <cfargument name="date" type="string" required="true">
        <cfargument name="time" type="string" required="true">
        <cfargument name="duration" type="numeric" required="true">

        <cfset var endTime = DateAdd("h", arguments.duration, arguments.time)>

        <cfquery name="checkBooking" datasource="#session.datasource#">
            SELECT COUNT(*) AS total FROM #session.schema#.amenity_bookings 
            WHERE amenity_id = <cfqueryparam value="#arguments.amenity_id#" cfsqltype="cf_sql_integer">
            AND booking_date = <cfqueryparam value="#arguments.date#" cfsqltype="cf_sql_date">
            AND (
                (booking_time <= <cfqueryparam value="#arguments.time#" cfsqltype="cf_sql_time"> 
                AND booking_end_time > <cfqueryparam value="#arguments.time#" cfsqltype="cf_sql_time">)
                OR
                (booking_time < <cfqueryparam value="#endTime#" cfsqltype="cf_sql_time"> 
                AND booking_end_time >= <cfqueryparam value="#endTime#" cfsqltype="cf_sql_time">)
            );
        </cfquery>

        <cfif checkBooking.total GT 0>
            <cfreturn { "status": "error", "message": "Time slot is already booked!" }>
        <cfelse>
            <cfreturn { "status": "success", "message": "Slot available." }>
        </cfif>
    </cffunction>

    <!--- Function to Book an Amenity --->
    <cffunction name="bookAmenity" access="public" returntype="any">
        <cfargument name="amenity_id" type="numeric" required="true">
        <cfargument name="date" type="string" required="true">
        <cfargument name="time" type="string" required="true">
        <cfargument name="duration" type="numeric" required="true">
        <cfset var endTime = DateAdd("h", arguments.duration, arguments.time)>

        <!--- First, Check Availability --->
        <cfset availability = checkAvailability(argumentCollection=arguments)>
        <cfif availability.status EQ "error">
            <cfreturn availability>
        </cfif>

        <!--- If available, Insert Booking --->
        <cfquery datasource="#session.datasource#">
            INSERT INTO #session.schema#.amenity_bookings (amenity_id, booking_date, booking_time, booking_end_time, resident_id, duration)
            VALUES (
                <cfqueryparam value="#arguments.amenity_id#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#arguments.date#" cfsqltype="cf_sql_date">,
                <cfqueryparam value="#arguments.time#" cfsqltype="cf_sql_time">,
                <cfqueryparam value="#endTime#" cfsqltype="cf_sql_time">,
                <cfqueryparam value="#session.userdetails.res_id#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#arguments.duration#" cfsqltype="cf_sql_integer">
            );
        </cfquery>

        <cfreturn { "status": "success", "message": "Amenity booked successfully!" }>
    </cffunction>


    <cffunction name="addAmenity" access="public" returntype="any">
        <cfargument name="amenityName" type="string" required="true">
        <cfargument name="amenityLoc" type="string" required="true">
        <cfargument name="capacity" type="string" required="false">
        <cfargument name="bookingReq" type="string" required="true">
        <cfargument name="availableFrom" type="string" required="false">
        <cfargument name="availableTo" type="string" required="true">

        <cfquery name="checkExisting" datasource="#session.datasource#">
            SELECT * from #session.schema#.amenities
            WHERE name ilike <cfqueryparam value="%#arguments.amenityName#%" cfsqltype="cf_sql_varchar">
            AND location ilike <cfqueryparam value="%#arguments.amenityLoc#%" cfsqltype="cf_sql_varchar">
        </cfquery>

        <cfif checkExisting.recordCount eq 0>
            <!--- If available, Insert Booking --->
            <cfquery datasource="#session.datasource#">
                INSERT INTO #session.schema#.amenities (name, location, max_capacity, booking_required, available_from, available_to)
                VALUES (
                    <cfqueryparam value="#arguments.amenityName#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.amenityLoc#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.capacity#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#arguments.bookingReq#" cfsqltype="cf_sql_bit ">,
                    <cfqueryparam value="#arguments.availableFrom#" cfsqltype="cf_sql_time">,
                    <cfqueryparam value="#arguments.availableTo#" cfsqltype="cf_sql_time">
                );
            </cfquery>
            <cfreturn { "status": "success", "message": "Amenity booked successfully!" }>
        </cfif>

        <cfreturn { "status": "error", "message": "Amenity already exists" }>
    </cffunction>


    <cffunction name="getResidentBookings" access="public" returntype="any">
        <cfquery name="fetchBookings" datasource="#session.datasource#">
            SELECT b.booking_id, a.name AS amenity_name, b.booking_date, TO_CHAR(b.booking_date,'Month dd, yyyy') as b_date, TO_CHAR(b.booking_time, 'hh12:mi am') as booking_time, TO_CHAR(b.booking_end_time,'hh12:mi am') as booking_end_time, b.status
            FROM #session.schema#.amenity_bookings b
            INNER JOIN #session.schema#.amenities a ON b.amenity_id = a.amenity_id
            WHERE b.resident_id = <cfqueryparam value="#session.userdetails.res_id#" cfsqltype="cf_sql_integer">
            ORDER BY b.booking_date DESC, b.booking_time DESC;
        </cfquery>

        <cfreturn fetchBookings>
    </cffunction>



    <cffunction name="getAllBookings" access="public" returntype="any">
        <cfquery name="fetchAllBookings" datasource="#session.datasource#">
            SELECT b.booking_id, r.first_name AS first_name, a.name AS amenity_name, 
                   TO_CHAR(b.booking_date,'Month dd, yyyy') as booking_date, TO_CHAR(b.booking_time, 'hh12:mi am') as booking_time, TO_CHAR(b.booking_end_time,'hh12:mi am') as booking_end_time, b.status
            FROM #session.schema#.amenity_bookings b
            INNER JOIN #session.schema#.amenities a ON b.amenity_id = a.amenity_id
            INNER JOIN #session.schema#.residents r ON b.resident_id = r.res_id
            ORDER BY b.booking_date DESC;
        </cfquery>

        <cfset bookingsList = []>
        <cfloop query="fetchAllBookings">
            <cfset temp = {
                "booking_id": fetchAllBookings.booking_id,
                "first_name": fetchAllBookings.first_name,
                "amenity_name": fetchAllBookings.amenity_name,
                "date": fetchAllBookings.booking_date,
                "time": fetchAllBookings.booking_time,
                "end_time": fetchAllBookings.booking_end_time,
                "status": fetchAllBookings.status
            }>
            <cfset ArrayAppend(bookingsList, temp)>
        </cfloop>

        <cfreturn bookingsList>
    </cffunction>


    <cffunction name="updateBookingStatus" access="public" returntype="any">
        <cfargument name="booking_id" type="numeric" required="true">
        <cfargument name="status" type="string" required="true">

        <cfquery datasource="#session.datasource#">
            UPDATE #session.schema#.amenity_bookings
            SET status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
            WHERE booking_id = <cfqueryparam value="#arguments.booking_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn { "status": "success", "message": "Booking status updated!" }>
    </cffunction>

    <cffunction name="updateAmenityStatus" access="public" returntype="any">
        <cfargument name="amenity_id" type="numeric" required="true">
        <cfargument name="status" type="string" required="true">

        <cfquery datasource="#session.datasource#">
            UPDATE #session.schema#.amenities
            SET status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
            WHERE amenity_id = <cfqueryparam value="#arguments.amenity_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn true>
    </cffunction>

</cfcomponent>




