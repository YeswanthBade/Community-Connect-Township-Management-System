<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Home - Community Connect</title>
    <link href="../css/homePage.css" rel="stylesheet"/>
    <script src="../scripts/jquery.min.js" defer></script>
    <script src="../scripts/crypto-js.min.js" defer></script>
</head>

<body>

    <cfinclude template="header.cfm">

    <cfif session.userdetails.ROLE_ID eq 1>
        <section class="welcome">
            <cfoutput><h2>Welcome, #session.userdetails.FIRST_NAME#!</h2></cfoutput>
            <p>Manage community operations and keep everything running smoothly.</p>
        </section>

        <div class="newsevents">
        <cfinclude template="../newsAndEvents/newsDashBoard.cfm"></div>

        <main class="content admin-dashboard">
            <section class="highlights">
                <article class="card">
                    <h3>visitor management</h3>
                    <p>View, add and manage visitors of all residents.</p>
                    <a class="btn" href="../visitorManagement/visitorManagement.cfm">Add visitors</a>
                </article>
                <article class="card">
                    <h3>Payments & Billing</h3>
                    <p>Oversee financial records and outstanding payments.</p>
                    <a class="btn" href="../payments/payments.cfm">View Payments</a>
                </article>
                <article class="card">
                    <h3>manage amenities</h3>
                    <p>View and manage amenities of community.</p>
                    <a class="btn" href="../amenities/amenities.cfm">View Amenities</a>
                </article>
                <article class="card">
                    <h3>Committee Updates</h3>
                    <p>View and know what all are happening inside your community.</p>
                    <a class="btn" href="../committeeUpdates/committeeUpdates.cfm">Manage Updates</a>
                </article>
                <article class="card">
                    <h3>Maintenance</h3>
                    <p>View all maintenance requests and assign them to any</p>
                    <a class="btn" href="../maintenance/maintenance.cfm">View maintenance</a>
                </article>
            </section>
        </main>


    <cfelseif session.userdetails.ROLE_ID eq 2>
        <section class="welcome">
            <cfoutput><h2>Welcome, #session.userdetails.FIRST_NAME#!</h2></cfoutput>
            <p>Access your community dashboard to stay informed and take action.</p>
        </section>
        
        <div class="newsevents">
        <cfinclude template="../newsAndEvents/newsDashBoard.cfm"></div>
        <main class="content resident-dashboard">
            <section class="highlights">
                <article class="card">
                    <h3>Add a Visitor</h3>
                    <p>enter your visitor details and make your visitors' entry easy.</p>
                    <a class="btn" href="../visitorManagement/visitorManagement.cfm">Add visitor</a>
                </article>
                <article class="card">
                    <h3>Make a Payment</h3>
                    <p>Settle outstanding dues quickly and easily.</p>
                    <a class="btn" href="../payments/payments.cfm">Make Payment</a>
                </article>
                <article class="card">
                    <h3>Committee Updates</h3>
                    <p>View and know what all are happening inside your community.</p>
                    <a class="btn" href="../committeeUpdates/committeeUpdates.cfm">View Updates</a>
                </article>
                <article class="card">
                    <h3>Book an Amenity</h3>
                    <p>Reserve amenities like the gym, pool, or clubhouse.</p>
                    <a class="btn" href="../amenities/amenities.cfm">Book Now</a>
                </article>
                <article class="card">
                    <h3>Submit Maintenance Request</h3>
                    <p>Report and track issues in your apartment or the community.</p>
                    <a class="btn" href="../maintenance/maintenance.cfm">Submit Request</a>
                </article>
            </section>
        </main>

    <cfelseif session.userdetails.ROLE_ID eq 3>
        <section class="welcome">
            <cfoutput><h2>Welcome, #session.userdetails.FIRST_NAME#!</h2></cfoutput>
            <p>Manage visitor logs and report incidents for the community.</p>
        </section>
        <main class="content security-dashboard">
            <section class="highlights">
                <article class="card">
                    <h3>Visitor Management</h3>
                    <p>Approve or deny visitor access based on resident requests.</p>
                    <a class="btn" href="../visitorManagement/visitorManagement.cfm">Manage Visitors</a>
                </article>
                <article class="card">
                    <h3>Committee Updates</h3>
                    <p>View and know what all are happening inside your community.</p>
                    <a class="btn" href="../committeeUpdates/committeeUpdates.cfm">Manage Updates</a>
                </article>
            </section>
        </main>


    <cfelseif session.userdetails.ROLE_ID eq 4>
        <section class="welcome">
            <cfoutput><h2>Welcome, #session.userdetails.FIRST_NAME#!</h2></cfoutput>
            <p>Access and manage assigned maintenance tasks.</p>
        </section>
        <main class="content maintenance-dashboard">
            <section class="highlights">
                <article class="card">
                    <h3>View Assigned Tasks</h3>
                    <p>Check your pending and in-progress tasks.</p>
                    <a class="btn" href="../maintenance/maintenance.cfm">View Tasks</a>
                </article>
                <article class="card">
                    <h3>Committee Updates</h3>
                    <p>View and know what all are happening inside your community.</p>
                    <a class="btn" href="../committeeUpdates/committeeUpdates.cfm">Manage Updates</a>
                </article>
            </section>
        </main>
    </cfif>
    <cfinclude template="footer.cfm">

</body>
</html>
