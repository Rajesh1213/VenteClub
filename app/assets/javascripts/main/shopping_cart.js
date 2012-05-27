$(document).ready(function () {

    var onSelect = false;

    $('.cartTop').live({
            mouseenter:function () {
                $('.cartTop').css("background-color", "#C6C7C7");
                $(".cartData").show();
            },
            mouseleave:function () {
                $('.cartTop').css("background-color", "#ffffff");
                $(".cartData").hide();
            }
        }
    );

    $('.cartData table').live({
            mouseenter:function () {
            },
            mouseleave:function () {
                setTimeout(function () {
                    onSelect = false;
                }, 0)
            }
        }
    );

    $(".quantitySelect").live("mousedown", function () {
        onSelect = true;
    });

    $('.cartData').live({
            mouseenter:function () {
                $(".cartTop").css("background-color", "#C6C7C7");
                $(".cartData").show();
            },
            mouseleave:function () {
                if (onSelect == false) {
                    $(".cartTop").css("background-color", "#ffffff");
                    $(".cartData").hide();
                }
            }
        }
    );

//    cart end

    $('.del_product').live("click", function () {
        var id = this.id.split("_")[1];
        $.post("/my/shopping_cart_del/", {authenticity_token:$('meta[name=csrf-token]').attr("content"), id:id},
            function (data) {
                if (data.success) {
                    $("#item_wrapper_" + id).hide();
                    $("#total").html(data.total);
                    $("#cart_items").html(data.cart_items);
                    if (data.items_count == 0) {
                        $(".cartData").remove();
                        $(".cartTop").css("background-color", "#ffffff");
                    }
                } else {
                    alert(data);
                }
            });
    });

});
