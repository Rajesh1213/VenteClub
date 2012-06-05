$(document).ready(function () {

    $(".invertSelection").click(function () {
        var id = $(this).attr("id").split("_")[2];
        $("#event_inner_" + id + " tbody input").each(function () {
            $(this).attr('checked', !$(this).attr('checked'));
        });
    });

    $(".deleteSelected").click(function () {
        var btn = $(this);
        if (!btn.hasClass("disabled")) {
            btn.addClass("disabled");
            var id = $(this).attr("id").split("_")[2];
            var products = [];
            $("#event_inner_" + id + " tbody input:checked").each(function () {
                products.push($(this).attr("id").split("_")[1]);
            });
            $.post("/products/del_selected_products", {authenticity_token:$('meta[name=csrf-token]').attr("content"), products:products}, function (data) {
                if (data == "ok") {
                    $.each(products, function (index, value) {
                        $("#product_row_" + value).remove();
                    });
                    btn.removeClass("disabled");
                } else {
                    btn.removeClass("disabled");
                    alert(data);
                }
            });
        }
    });

});