$(document).ready(function () {

    getNotifications();

    $("#notif-btn").click(function () {
        $("#nOverlay, #notifications").fadeIn(200);
    });

    $("#closeNotifs, #nOverlay").click(function () {
        $("#nOverlay, #notifications").fadeOut(200);
    });

    function getNotifications() {
        $.ajax({
            url: '../common/validateNotifications.cfm',
            type: 'GET',
            //dataType: 'json',
            // data: {phonenum: phonenum, password: encryptedPassword},
            success: function (response) {
                $("#notifications-box").empty();
                $("#notifications-box").append(response);
            },
            error: function (error) {
                alert("An error occurred. Please try again later.");
                console.error("Error:", error);
            }
        });
    }

    $(document).on('click', '.mark-as-read', function () {
        let notifid = $(this).data('id');
        $.ajax({
            url: '../common/validateMarkAsRead.cfm',
            type: 'GET',
            data: {notifid:notifid},
            success: function (response) {
                console.log(response);
                getNotifications();
            },
            error: function (error) {
                alert("An error occurred. Please try again later.");
            }
        });
    });


    $(".edit-profile-btn").click(function () {
        $("#nOverlay, #edit-profile").fadeIn(200);
    });

    $("#closeEdit, #nOverlay").click(function () {
        $("#nOverlay, #edit-profile").fadeOut(200);
    });


    $("#edit-profile-form").submit(function (e) {
        let formData = $(this).serialize();
        $.ajax({
            url: '../common/validateEditProfile.cfm',
            type: 'POST',
            data: formData,
            success: function (response) {
                if (response){
                    alert('Profile updated successfully');
                    //location.reload();
                }
            },
            error: function (error) {
                alert("An error occurred. Please try again later.");
            }
        });
    });

    $("#change-password-btn").click(function () {
        $("#nOverlay, #edit-profile").fadeOut(0);
        $("#nOverlay, #change-password").fadeIn(0);
    });

    $("#closePassword, #nOverlay").click(function () {
        $("#nOverlay, #change-password").fadeOut(200);
    });

    $("#change-password-form").submit(function (e) {
        e.preventDefault();
        let oldPassword = $("#current-password").val();
        let newPassword = $("#new-password").val();
        let confirmPassword = $("#confirm-password").val();
        console.log(oldPassword);

        if (newPassword !== confirmPassword) {
            alert("re-enter your new password")
            // errorMessage.text("Passwords do not match").removeClass("d-none");
            return;
        }

        $.ajax({
            url:"../common/validateChangePassword.cfm",
            type:"POST",
            data:{oldPassword:oldPassword, newPassword:newPassword},
            success:function(response){
                if(response.trim() == 'true'){
                    alert('Password changed successfully');
                    $("#nOverlay, #change-password").fadeOut(200);
                }
                else{
                    alert('Current password is not correct!!');
                }
            },
            error: function (error) {
                alert("An error occurred. Please try again later.");
            }
        })
    })
});

