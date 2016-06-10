function insert_fields(link, method, content, css_class) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + method, "g");
    var regexp2 = new RegExp("1234567", "g");
    $(content.replace(regexp, new_id).replace(regexp2,new_id)).insertAfter(css_class + " tr:last");
    $('.chosen-select').chosen();
}

function remove_fields(link) {
    var hidden_field = $(link).prevAll('input[id*="_destroy"]');
    if (hidden_field) {
        hidden_field.value = '1';
    }
    $(link).parentsUntil("tbody").hide();
}