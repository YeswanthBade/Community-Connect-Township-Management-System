$(document).ready(function () {
    $('.btn').click(function(){
        var phonenum = $('#phonenum').val();
        var password = $('#password').val();

        // password encryption with md5 algo
        var encryptedPassword = CryptoJS.MD5(password).toString();

        // AJAX request to validate login
        $.ajax({
            url: '../common/validateLogin.cfm',
            type: 'POST',
            //dataType: 'json',
            data: {phonenum: phonenum, password: encryptedPassword},
            success: function (response) {
                console.log(response);
                if (response.trim() == "true") {
                    window.location.href = "../pages/homePage.cfm";
                } 
                else {
                    alert("Invalid login credentials");
                }
            },
            error: function (error) {
                alert("An error occurred. Please try again later.");
                console.error("Error:", error);
            }
        });
    });
});
