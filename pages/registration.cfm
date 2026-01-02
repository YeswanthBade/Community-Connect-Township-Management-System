<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resident Registration</title>
    <link rel="stylesheet" href="../css/registration.css">
    <script src="../scripts/jquery.min.js"></script>
    <script src="../scripts/crypto-js.min.js"></script>
    <script src="../scripts/registration.js"></script>
</head>
<body>
    <div class="registration-container">
        <div>
            <h1>Resident Registration</h1>
        </div>
        <form id="registrationForm">
            <div class="form-group">
                <label for="firstName">First Name:</label>
                <input type="text" id="firstName" name="firstName" placeholder="Enter your first name" required>
            </div>
            <div class="form-group">
                <label for="lastName">Last Name:</label>
                <input type="text" id="lastName" name="lastName" placeholder="Enter your last name" required>
            </div>
            <div class="form-group">
                <label for="email">Email Address:</label>
                <input type="text" id="email" name="email" placeholder="Enter your email" required>
            </div>
            <p id="emailError" style="color: red; font-size: 10px;"></p>
            <div class="form-group">
                <label for="phoneNumber">Phone Number:</label>
                <input type="text" id="phoneNumber" name="phoneNumber" placeholder="Enter your phone number" required>
            </div>
            <p id="phoneError" style="color: red; font-size: 10px;" ></p>
            <div class="form-group">
                <label for="address">Address:</label>
                <input type="text" id="address" name="address" placeholder="Enter your address" required>
            </div>
            <div class="form-group" id="role">
                <label for="roleSelect">Role: </label>
                <select id="roleSelect" name="role">
                    <option value="">--select--</option>
                    <option value="3">Security</option>
                    <option value="4">Maintenance</option>
                </select>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" placeholder="Enter a password" required>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Confirm Password:</label>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" required>
            </div>
            <button type="submit" class="submit-button">Register</button>
        </form>
        <p id="errorMessage" style="color: red;"></p>
        <p id="successMessage" style="color: green;"></p>
    </div>
</body>
</html>
