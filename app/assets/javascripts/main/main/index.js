$(window).load(function () {

    if (vis_el > 0) {
        $(".eventProducts").jCarouselLite({
            btnNext:".next",
            btnPrev:".prev",
            visible:vis_el
        });
    }

//    $(".eventProducts").hide("slow");

    $(".eventBig").hover(
        function () {
            $(".rotatorWrapper").slideDown();
        },
        function () {
            $(".rotatorWrapper").slideUp();
        }
    );

    $(".eventPlaceholder").hover(
        function () {
            $(this).find(".eventInfo").slideDown("fast");
        },
        function () {
            $(".eventInfo").slideUp("fast");
        }
    );

});