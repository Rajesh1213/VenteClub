$(document).ready(function () {

    $('.to_bag').click(function () {
        if (sizeSelected()) {
            var id = $(".to_bag").attr("id").split("_")[2];
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
        } else {
            alert("Please select Size")
        }
    });

    $('.mainImgWrapper img').hover(
        function () {
            addZoom($(this));
        },
        function () {
            // out
        }
    );

    $('.altImgWrapper').live({
            mouseenter:function () {
                changeBigImg($(this).find("img"));
            },
            mouseleave:function () {
                // out
            }
        }
    );

    $('.propertyColor').click(function () {
        if (!$(this).hasClass("disabled")) {
            var color_name = $(this).attr("colorName");
            $('#color_name').text(color_name);
            $('.propertyColor').removeClass("selected");
            $(this).addClass("selected");
            $('#last_clicked').val("color");
            updateData();
        }
    });

    $('#product_size').change(function () {
        if (sizeSelected()) {
            $('#last_clicked').val("size");
            updateData();
        } else {
            $('.propertyColor').removeClass("disabled");
            updateButtons("");
        }
    });

    $('.propertyColor.disabled').live({
            mouseenter:function () {
                $(this).tooltip("show");
            },
            mouseleave:function () {
                $(this).tooltip("hide");
            }
        }
    );

    $('#product_size').tooltip({title:"Disabled options are not available for selected color"});

});

function updateData() {
    var product_id = $(".to_bag").attr("id").split("_")[2];
    var color_id = $('.propertyColor.selected').attr("id").split("_")[2];
    var size_id = $('#product_size').val();
    var last_clicked = $('#last_clicked').val();
    $.post("/my/update_data/?format=json", {authenticity_token:$('meta[name=csrf-token]').attr("content"), product_id:product_id, color_id:color_id, size_id:size_id, last_clicked:last_clicked},
        function (data) {
            updateAltWrapper(data);
            updateSizes(data);
            updateColors(data);
            updateButtons(data);
        });
}

function updateButtons(data) {
    $(".input-member").hide();
    if (data != "") {
        $('.to_bag').attr("id", "to_bag_" + data.product.id);
        $('.to_preorder').attr("id", "to_preorder_" + data.product.id);
        if (sizeSelected()) {
            if (data.product.sold_out == true) {
                $('.to_preorder').show();
            } else {
                $('.to_bag').show();
            }
        }
    }
}

function updateColors(data) {
    if (!sizeSelected()) {
        $('.propertyColor').removeClass("disabled");
    } else {
        $('.propertyColor').addClass("disabled");
        $.each(data.product.available_colors, function (index, color) {
            $("#product_color_" + color.id).removeClass("disabled");
        });
        $('.propertyColor.disabled').tooltip({trigger:"manual", title:"color not available for selected size"});
    }
}

function updateSizes(data) {
    $('#product_size option').attr("disabled", "disabled");
    $('#product_size option:first').removeAttr("disabled");
    $.each(data.product.available_sizes, function (index, size) {
        $('#product_size option[value="' + size.id + '"]').removeAttr("disabled");
    });
//    $('#product_size option:disabled').tooltip({placement:"right", title:"size not available for selected color"});
}

function updateAltWrapper(data) {
    var html = '';
    $.each(data.product.images, function (index, image) {
        html += '<li class="altImgWrapper"><div class="tableCell"><img src="/pictures/s/';
        html += image.file_name;
        html += '"></div></li>'
    });
    $('.altWrapper ul').html(html);
    changeBigImg($('.altImgWrapper img').first());
}

function addZoom(el) {
    el.addimagezoom({
        zoomrange:[5, 10],
        magnifiersize:[300, 450],
        magnifierpos:'right',
        cursorshade:true,
        largeimage:el.attr("src").replace("pictures/m", "pictures/l")
    })
}

function changeBigImg(over_el) {
    var new_path = over_el.attr("src").replace("pictures/s", "pictures/m");
    $('.mainImgWrapper img').attr("src", new_path);
    addZoom($('.mainImgWrapper img'));
}

function sizeSelected() {
    if ($('#product_size').val() == "-1") {
        return false
    } else {
        return true
    }
}
