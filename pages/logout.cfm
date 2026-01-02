<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logout - Community Connect</title>
    <link rel="stylesheet" href="../css/logout.css">
    <script>
        setTimeout(function () {
            window.location.href = "../index.cfm"; // Redirect to the index/login page
        }, 3000); // Redirect after 3 seconds
    </script>
</head>
<body>
    <div class="container">
        <h1>You have successfully logged out!</h1>
        <p>Thank you for visiting Community Connect.</p>
        <p>Redirecting you to the homepage in 3 seconds...</p>
        <a href="../index.cfm">Go to Login Page</a>
    </div>
</body>
</html>
