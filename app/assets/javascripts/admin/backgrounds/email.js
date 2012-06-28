$(document).ready(function () {

    var up_div = $('#file-uploader');
    var progress = $('#progress');
    var btn = $('#browse');
    var uploader = new qq.FileUploaderBasic({
        element:up_div,
        action:'/uploads/image_upload',
        debug:true,
        multiple:false,
        allowedExtensions:['jpg', 'jpeg', 'png', 'gif', 'bmp'],
        sizeLimit:11000000,
        button:btn[0],
        params:{
            authenticity_token:$('meta[name=csrf-token]').attr("content"),
            type:"background_email"
        },
        onSubmit:function (id, fileName) {
            progress.show();
            btn.hide();
        },
        onProgress:function (id, fileName, loaded, total) {
            var percentLoaded = parseInt((loaded / total) * 100);
            progress.find('.bar').width(percentLoaded.toString() + "%");
        },
        onComplete:function (id, fileName, responseJSON) {
            progress.hide();
            progress.find('.bar').width("0%");
            if (responseJSON.success == true) {
                $('#new_file_name').val(responseJSON.new_filename);
                $('#current_image').attr("src", "/tmp/backgrounds/" + responseJSON.new_filename);
            }
            else {
                alert("Error");
            }
            btn.removeClass("qq-upload-button-hover");
            btn.show();
        }
    });

    $('#save').click(function(){

    });

});