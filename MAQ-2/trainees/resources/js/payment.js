$(document).ready(function () {
    $(".days").inputmask("integer", {
        min: 0,
        rightAlign: false
    });

    $("#amount").inputmask('currency', {
        "autoUnmask": true,
        radixPoint: ",",
        groupSeparator: ".",
        allowMinus: false,
        prefix: 'R$ ',
        digits: 2,
        digitsOptional: false,
        rightAlign: true,
        unmaskAsNumber: true
    });
});
