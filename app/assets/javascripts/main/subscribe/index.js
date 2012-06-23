jQuery(document).ready(function () {
    jQuery("#subscribe").validationEngine({
        ajaxFormValidation:true,
        ajaxFormValidationMethod:'post',
        autoHidePrompt:true,
        autoHideDelay:5000,
        promptPosition:"centerRight",
        onBeforeAjaxFormValidation:function (form, status) {
            $('#submit_btn').validationEngine('hideAll');
            $("#submit_btn").val("Processing..");
            $("#submit_btn").attr("disabled", true);
        },
        onAjaxFormComplete:function (form, status) {
            $("#submit_btn").val("Submit");
            $("#submit_btn").attr("disabled", false);
        }
    });

    $("#subscriber_mail").focus(function () {
        $('#submit_btn').validationEngine('hideAll');
    });
});