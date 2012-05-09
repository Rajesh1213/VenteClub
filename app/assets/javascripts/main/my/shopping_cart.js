$(document).ready(function () {

    $('.del_product').click(function () {
        var id = this.id.split("_")[1];
        $.post("/my/shopping_cart_del/?format=json", {authenticity_token:$('meta[name=csrf-token]').attr("content"), id:id},
            function (data) {
                if (data.success) {
                    $("#item_wrapper_" + id).hide();
                    $("#total").html(data.total);
                } else {
                    alert(data);
                }
            });
    });

});
