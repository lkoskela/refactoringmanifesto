function hasAutofocus() { 
	var element = document.createElement('input');
	return 'autofocus' in element;
}

$(function(){
	if (!hasAutofocus()) {
		$('input[autofocus=true]').focus();
	}
});

$(document).ready(function() {
	$('#signup_button').click(function() {
		$('#signup_form').submit();
	});
});
