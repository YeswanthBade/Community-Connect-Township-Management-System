<cfif structKeyExists(session, "role_id")>
<!DOCTYPE html>
<html lang="en">
<head>
    <link href="../css/navbar.css" rel="stylesheet"/>
    <script src="../scripts/header.js" defer></script>
</head>

<body>
    <header class="header">
        <nav>
            <ul class="nav-menu">
                <li><a href="../pages/homePage.cfm">Home</a></li>
            </ul>
        </nav>
        <h2>Welcome to Community Connect!!</h2>
        <cfoutput>
        <nav>
            <ul class="nav-menu">
                <li><button id="notif-btn">Notifications</button></li>
                <li><a href="../residentDirectory/residentDirectory.cfm">Resident Details</a></li>
                <li><a href="../pages/aboutUs.cfm">About Us</a></li>
                <li class="dropdown">
                    <a id="profile-link">Profile</a>
                    <div class="dropdown-menu" id="profile-dropdown">
                        <p id="user-name">#session.userdetails.first_name#</p>
                        <p id="user-email">#session.userdetails.email#</p>
                        <div class="btns">
                            <button class="edit-profile-btn" id="edit-profile-button">Edit Profile</button>
                            <a class="logout-btn" href="../common/validateLogout.cfm">Logout</a>
                        </div>
                    </div>
                </li>
            </ul>
        </nav>
        </cfoutput>
        <div id="nOverlay"></div>
        <div id="notifications" class="popup-notifs">
            <div id="notifications-box">
            </div>
            <button id="closeNotifs">Close</button>
        </div>

        <div id="edit-profile" class="popup-edit-profile">
            <cfquery name="profileDetails" datasource="#session.datasource#">
                SELECT first_name, last_name, email, phone_number, address
                FROM #session.schema#.residents
                WHERE res_id = #session.userdetails.RES_ID#
            </cfquery>
            <cfoutput>
                <form id="edit-profile-form">
                    <h2>Profile Details</h2>
                    <div class="form-group">
                        <label for="first-name">First Name:</label>
                        <input id="first-name" name="firstname" value="#profileDetails.first_name#">
                    </div>
                    <div class="form-group">
                        <label for="last-name">Last Name:</label>
                        <input id="last-name" name="lastname" value="#profileDetails.last_name#">
                    </div>
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input id="email" name="email" value="#profileDetails.email#">
                    </div>
                    <div class="form-group">
                        <label for="phone-number">Phone NUmber:</label>
                        <input id="phone-number" name="phone" value="#profileDetails.phone_number#">
                    </div>
                    <div class="form-group">
                        <label for="address">Address:</label>
                        <input id="address" name="address" value="#profileDetails.address#">
                    </div>
                    <div class="buttons">
                        <div><button type="button" id="closeEdit">Close</button>
                        <button type="submit" id="Save-details">Save</button></div>
                        <button type="button" class="change-password-btn" id="change-password-btn">Change Password</button>
                    </div>
                </form>     
            </cfoutput>
        </div>

        <div id="change-password" class="popup-change-password">
            <form id="change-password-form">
                <h2>Change Password</h2>
                <div class="form-group">
                    <label for="current-password">Current Password:</label>
                    <input id="current-password" name="password" placeholder="Enter your current password">
                </div>
                <div class="form-group">
                    <label for="new-password">New Password:</label>
                    <input id="new-password" name="newPassword" placeholder="Enter your new password">
                </div>
                <div class="form-group">
                    <label for="confirm-password">Confirm Password:</label>
                    <input id="confirm-password" placeholder="Re-enter your new password">
                </div>
                <div class="bottons">
                    <div><button type="button" id="closePassword">Close</button>
                    <button type="submit" id="Save-password">Save</button></div>
                </div>
            </form>
        </div>
    </header>
</body>
</html>
<cfelse>
    <cflocation url="../pages/login.cfm">
</cfif>