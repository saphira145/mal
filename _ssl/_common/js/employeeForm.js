
$(document).ready(function(){
    $("#employee_login_form").submit(function(e){
        var employeeNumber         = $("#employee_number").val();
        employeeNumber             = $.trim(employeeNumber);
        if (!employeeNumber) {
            $('#employee_login_form .actionMsg span').html('▼IDを入力してください。');
            $('#employee_login_form .actionMsg').show();
            e.preventDefault();
        }
        else if (employeeNumber.length != 7) {
            $('#employee_login_form .actionMsg span').html('▼正しいIDを入力してください');
            $('#employee_login_form .actionMsg').show();
            e.preventDefault();
        }
    });
})
