function hasAutofocus() { 
	var element = document.createElement('input');
	return 'autofocus' in element;
}

$(function(){
	if (!hasAutofocus()) {
		$('input[autofocus=true]').focus();
	}
});

$(document).read(function() {
	$('#signup_button').click(function() {
		$('#signup_form').submit();
	});
});
