function insert_fields(link, method, content, css_class) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + method, "g")
    if ($(css_class + " tr").length > 1)
        $(content.replace(regexp, new_id)).insertBefore(css_class + " tr:last");
    else
        $(content.replace(regexp, new_id)).insertAfter(css_class + " tr:last");
    $('.chosen-select').chosen();
}

function remove_fields(link) {
    var hidden_field = $(link).prevAll('input[id*="_destroy"]');
    if (hidden_field) {
        hidden_field.value = '1';
    }
    $(link).parentsUntil("tbody").hide();
}