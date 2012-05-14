$(document).ready(function () {

    $('.add_btn').click(function () {
        var id = this.id.split("_")[1];
        var $img = $(".mainImgWrapper img").first();
        $img.animate_from_to('.cartTop', {
            initial_css:{
                image:$img.attr("src")
            },
            callback:function () {
                $.post("/my/shopping_cart_add/", {authenticity_token:$('meta[name=csrf-token]').attr("content"), id:id},
                    function (data) {
                        $(".cartWrapper").html(data);
                    });
            }
        });
    });


    $('.mainImgWrapper img').hover(
        function () {
            $(this).addimagezoom({
                zoomrange:[5, 10],
                magnifiersize:[300, 450],
                magnifierpos:'right',
                cursorshade:true,
                largeimage:$(this).attr("src").replace("pictures/m", "pictures/l")
            })
        },
        function () {
            // out
        }
    );

});