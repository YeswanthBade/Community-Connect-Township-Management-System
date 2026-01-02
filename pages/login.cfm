<!DOCTYPE html>
<html lang="en">
<head>
    <title>Login - communityConnect</title>
    <link rel="stylesheet" href="../css/login.css">
    <script src="../scripts/jquery.min.js" defer></script>
    <script src="../scripts/crypto-js.min.js" defer></script>
    <script src="../scripts/login.js" defer></script>
</head>
<body>
    <div class="loginbox">
        <div>
            <h2 class="title">Login</h2>
            <form id="loginForm">
                <div class="form-group">
                    <label for="phonenum">Phone Number</label>
                    <input type="number" id="phonenum" name="phonenum" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <button type="button" class="btn">Login</button>
            </form>
        </div>
    </div>
</body>
</html>
