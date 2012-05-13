$(document).ready(function () {

    $('.del_product').live("click", function () {
        var id = this.id.split("_")[1];
        $.post("/my/shopping_cart_del/", {authenticity_token:$('meta[name=csrf-token]').attr("content"), id:id},
            function (data) {
                if (data.success) {
                    $("#item_wrapper_" + id).hide();
                    $("#total").html(data.total);
                    $("#cart_items").html(data.cart_items);
                } else {
                    alert(data);
                }
            });
    });

});
