$(document).ready(function () {

    $("#product_type_id").change(function () {
        update_data();
    });

    update_data();

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
            $(".productTypeWrapper").html(html);
        });
}
