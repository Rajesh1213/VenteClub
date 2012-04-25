$('form').live('nested:fieldAdded', function (event) {
    var up_div = $(event.field).find('.file-uploader')[0];
    var progress = $(event.field).find('.progress');
    var btn = $(event.field).find('.btn.btn-success');
    var uploader = new qq.FileUploaderBasic({
        element:up_div,
        action:'/uploads/image_upload',
        debug:false,
        multiple:false,
        allowedExtensions:['jpg', 'jpeg', 'png', 'gif', 'bmp'],
        sizeLimit:11000000,
        button:$(event.field).find('.btn.btn-success')[0],
        params:{
            authenticity_token:$('meta[name=csrf-token]').attr("content"),
            type:"product"
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
                var img_div = $(event.field).find('.admImage');
                img_div.html('<img src="/tmp/s/' + responseJSON.new_filename + '">');
                $(event.field).find('.input-xlarge').val(responseJSON.new_filename);
            }
            else {
                alert("Error");
            }
        }
    });
});
