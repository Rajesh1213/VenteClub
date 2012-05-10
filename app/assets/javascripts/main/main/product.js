$(document).ready(function () {

    $('.add_btn').click(function () {
        var id = this.id.split("_")[1];
        var $img = $(".content-body img").first();
        $img.animate_from_to('#shopping_cart_top', {
            initial_css:{
                image:$img.attr("src")
            },
            callback:function () {
                $.post("/my/shopping_cart_add/?format=json", {authenticity_token:$('meta[name=csrf-token]').attr("content"), id:id},
                    function (data) {
                        if (data.success) {

                        } else {
                            alert(data);
                        }
                    });
            }
        });
    });


    $('.content-body img').hover(
        function () {
            $(this).addimagezoom({
                zoomrange:[5, 10],
                magnifiersize:[600, 600],
                magnifierpos:'right',
                cursorshade:true,
                largeimage:$(this).attr("src").replace("pictures/sm", "pictures/l")
            })
        },
        function () {
            // out
        }
    );

});