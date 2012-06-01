$(document).ready(function () {

    initialSoldOut();

    $(".productPlaceholder").hover(
        function () {
            $(this).find(".productInfo").slideDown("fast");
            changeImage($(this).find("img"));
        },
        function () {
            $(this).find(".productInfo").slideUp("fast");
            var img = $(this).find("img");
            img.stopTime();
            img.attr("src", "/pictures/sm/" + img.attr("views").split("|")[0]);
        }
    );

    $('#size_filter').change(function () {
        if (sizeSelected()) {
            var size_id = $(this).val();
            $('.productPlaceholder').each(function (index) {
                var available_sizes = $(this).attr("available_sizes").split("_");
                if ($.inArray(size_id, available_sizes) < 0) {
                    $(this).hide();
                } else {
                    $(this).show();
                }
            });
            markSoldOut();
        } else {
            $('.productPlaceholder').show();
            $(".soldOut").hide();
            initialSoldOut();
        }
    });

});

function changeImage(img) {
    var views = img.attr("views").split("|");
    var path = "/pictures/sm/";
    var correct = 0;
    if (views.length > 1) {
        $('<img src="' + path + views[1] + '"/>');
    }
    img.everyTime(1000, function (i) {
        if (i == views.length + correct) {
            correct += views.length;
        }
        img.attr("src", path + views[i - correct]);
        if (i + 1 < views.length) {
            $('<img src="' + path + views[i + 1 - correct] + '"/>');
        }
    });
}

function markSoldOut() {
    var size_id = $('#size_filter').val();
    var products = [];
    var visible_products = $('.productPlaceholder:visible');
    visible_products.each(function () {
        $(this).find(".soldOut").hide();
        products.push($(this).attr("id").split("_")[1]);
    });
    $.post("/ajax/check_sold_out", {authenticity_token:$('meta[name=csrf-token]').attr("content"), products:products, size_id:size_id}, function (data) {
        visible_products.each(function (i) {
            if (data[i]) {
                $(this).find(".soldOut").show();
            }
        });
    });
}

function sizeSelected() {
    if ($('#size_filter').val() == "-1") {
        return false
    } else {
        return true
    }
}

function initialSoldOut() {
    $('.productPlaceholder').each(function () {
        if ($(this).attr("sold_out") == "true") {
            $(this).find(".soldOut").show();
        }
    });
}