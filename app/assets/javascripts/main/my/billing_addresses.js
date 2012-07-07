$(document).ready(function () {

    $('.delete').live("click", function () {
        setTimeout(function () {
            $("#addr_form .fields:hidden input").removeAttr("required");
        }, 500);
    });

});
