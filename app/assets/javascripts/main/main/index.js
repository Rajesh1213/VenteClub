$(window).load(function () {

    $(".eventProducts").jCarouselLite({
        btnNext:".next",
        btnPrev:".prev",
        visible: vis_el
    });

//    $(".eventProducts").hide("slow");

    $(".eventBig").hover(
        function () {
            $(".rotatorWrapper").slideDown();
        },
        function () {
            $(".rotatorWrapper").slideUp();
        }
    );

});