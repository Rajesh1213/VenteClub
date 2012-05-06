$(document).ready(function () {

    $("#product_type_id").change(function () {
        $("#results_wrapper").hide();
        update_data();
    });

    update_data();

    $("a.input-newmember").live("click", function () {
        var id = $(this).attr("id").split("_")[1];
        $.post("/shipping_calculator/flat_rate_price/?format=json&id=" + id, $("#data_form").serialize(),
            function (data) {
                if (data.value) {
                    $("#e_value").html(data.value);
                    $("#e_shipping_cost").html(data.shipping_cost);
                    $("#e_customs_duty").html(data.customs_duty);
                    $("#e_vat").html(data.vat);
                    $("#e_total").html(data.total);
                    $("#e_country").html(data.country);
                    $("#e_name").html(data.name);
                    $("#results_wrapper").show();
                    window.location.hash = ("results");
                } else {
                    alert(data.error);
                }
            });
    });


});

function update_data() {
    $.post("/shipping_calculator/flat_rate_products/?format=json", $("#data_form").serialize(),
        function (data) {
            var html = "";
            $.each(data.product_type.flat_rate_products, function (index, flat_rate_product) {
                html += '<div class="productFlatWrapper">';
                html += '<img src="' + flat_rate_product.url + '">';
                html += flat_rate_product.name;
                html += '<a href="#1" class="input-newmember" id="calc_' + flat_rate_product.id + '">CALCULATE</a>';
                html += '</div>'
            });
            $("div.productTypeWrapper").html(html);
        });
}
