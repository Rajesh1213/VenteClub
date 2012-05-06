$(document).ready(function () {

    $('#fmh').submit(function () {
        $("#fmh_submit").val("Processing..");
        $("#fmh_submit").attr("disabled", true);
        return true;
    });

});