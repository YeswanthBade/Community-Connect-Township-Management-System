$(document).ready(function () {
    var isEmailValid = false;
    var isPhoneValid = false;


    $("#email").blur(function () {
        const email = $(this).val().trim();
        const emailFormat = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if(email === ""){
            $('#emailError').text("");
            return;
        }
        else if(!emailFormat.test(email)){
            $('#emailError').text("Email format is not correct");
            isEmailValid = false;
            return;
        }

        $.ajax({
            url: "../common/validateEmailPhone.cfm",
            method: "POST",
            data: { field: "email", value: email },
            success: function (response) {
                if (response.trim() == "true") {
                    isEmailValid = false;
                    $('#emailError').text("Email is already registered");
                } else {
                    isEmailValid = true;
                    $('#emailError').text("");
                }
            },
            error: function () {
                isEmailValid = false;
                $('#emailError').text("Error checking email");
            }
        });
    });






    //  // Function to check for existing phone number
    $("#phoneNumber").blur(function () {
        const phoneNumber = $(this).val().trim();
        const phnnumFormat = /^[6789]\d{9}$/;

        if(phoneNumber === ""){
            $('#phoneError').text("");
            return;
        }
        else if(phoneNumber.length !== 10 || !phnnumFormat.test(phoneNumber)){
            isPhoneValid = false;
            $('#phoneError').text("phone Number format is not correct");
            return;
        }

        $.ajax({
            url: "../common/validateEmailPhone.cfm",
            method: "POST",
            data: { field: "phone", value: phoneNumber },
            success: function (response) {
                if (response.trim() == "true") {
                    isPhoneValid = false;
                    $("#phoneError").text("Phone number is already registered");
                } else {
                    isPhoneValid = true;
                    $("#phoneError").text("");
                }
            },
            error: function () {
                isPhoneValid = false;
                $("#phoneError").text("Error checking phone number");
            }
        });
    });




    $('#registrationForm').submit(function (event) {
        event.preventDefault(); // Prevent default form submission
        
        const password = $('#password').val();
        const confirmPassword = $('#confirmPassword').val();
        const errorMessage = $('#errorMessage');
        const successMessage = $('#successMessage');
        var encryptedPassword = CryptoJS.MD5(password).toString();
        

        // Validate passwords match
        if (password !== confirmPassword) {
            alert("reenter password")
            // errorMessage.text("Passwords do not match").removeClass("d-none");
            return;
        }

        if (!isEmailValid || !isPhoneValid) {
            errorMessage.text("Please ensure the email and phone number are valid before submitting.");
            return;
        }

        // Collect form data

        var formElement = $('#registrationForm')[0];
        var formData = new FormData(formElement);
        formData.delete('password');
        formData.delete('confirmPassword');
        formData.append('password', encryptedPassword);


        
        errorMessage.text(" ");
        successMessage.text(" ");
        console.log(formElement);
        console.log(formData);
        // Send AJAX request to validateRegistration.cfm
        $.ajax({
            url: '../common/validateRegistration.cfm',
            method: 'POST',
            dataType: 'json',
            data: formData,
            processData: false, // Important: Prevent jQuery from automatically processing the data 
            contentType: false, // Important: Prevent jQuery from automatically setting the content type
            success: function (response) {
                var value = response.status;
                if (value == "success") {
                    //alert("success");
                    successMessage.text(response.message);
                    $('#registrationForm')[0].reset();//for remove the data before redirecting to login page
                    setTimeout(function () {
                        successMessage.text(" ");
                        window.location.href = "../pages/login.cfm";
                    }, 3000);
                } 
                else {
                    errorMessage.text(response.message);
                    return; 
                }
            },

            error: function() {
                errorMessage.text("An error occurred while connecting to the server.");
            }
        });
    });
});
