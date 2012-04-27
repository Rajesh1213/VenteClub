$(document).ready(function () {

    $("#event_start_at, #event_end_at").AnyTime_picker({
        format:"%m-%d-%Y %H:%i"
    });

    var up_div_big = $('#file-uploader_big');
    var progress_big = $('#progress_big');
    var btn_big = $('#browse_big');
    var uploader_big = new qq.FileUploaderBasic({
        element:up_div_big,
        action:'/uploads/image_upload',
        debug:true,
        multiple:false,
        allowedExtensions:['jpg', 'jpeg', 'png', 'gif', 'bmp'],
        sizeLimit:11000000,
        button:btn_big[0],
        params:{
            authenticity_token:$('meta[name=csrf-token]').attr("content"),
            type:"event_big"
        },
        onSubmit:function (id, fileName) {
            progress_big.show();
            btn_big.hide();
        },
        onProgress:function (id, fileName, loaded, total) {
            var percentLoaded = parseInt((loaded / total) * 100);
            progress_big.find('.bar').width(percentLoaded.toString() + "%");
        },
        onComplete:function (id, fileName, responseJSON) {
            progress_big.hide();
            progress_big.find('.bar').width("0%");
            if (responseJSON.success == true) {
                var img_div = $('#admImage_big');
                img_div.html('<img src="/tmp/e_b/' + responseJSON.new_filename + '">');
                $('#event_big_image_attributes_file_name').val(responseJSON.new_filename);
            }
            else {
                alert("Error");
            }
            btn_big.removeClass("qq-upload-button-hover");
            btn_big.show();
        }
    });

    var up_div_small = $('#file-uploader_small');
    var progress_small = $('#progress_small');
    var btn_small = $('#browse_small');
    var uploader_small = new qq.FileUploaderBasic({
        element:up_div_small,
        action:'/uploads/image_upload',
        debug:true,
        multiple:false,
        allowedExtensions:['jpg', 'jpeg', 'png', 'gif', 'bmp'],
        sizeLimit:11000000,
        button:btn_small[0],
        params:{
            authenticity_token:$('meta[name=csrf-token]').attr("content"),
            type:"event_small"
        },
        onSubmit:function (id, fileName) {
            progress_small.show();
            btn_small.hide();
        },
        onProgress:function (id, fileName, loaded, total) {
            var percentLoaded = parseInt((loaded / total) * 100);
            progress_small.find('.bar').width(percentLoaded.toString() + "%");
        },
        onComplete:function (id, fileName, responseJSON) {
            progress_small.hide();
            progress_small.find('.bar').width("0%");
            if (responseJSON.success == true) {
                var img_div = $('#admImage_small');
                img_div.html('<img src="/tmp/e/' + responseJSON.new_filename + '">');
                $('#event_small_image_attributes_file_name').val(responseJSON.new_filename);
            }
            else {
                alert("Error");
            }
            btn_small.removeClass("qq-upload-button-hover");
            btn_small.show();
        }
    });

});
