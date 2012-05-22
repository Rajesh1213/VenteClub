$(document).ready(function () {


    $(".productPlaceholder").hover(
        function () {
            $(this).find(".productInfo").slideDown("fast");
        },
        function () {
            $(".productInfo").slideUp("fast");

        }
    );

});