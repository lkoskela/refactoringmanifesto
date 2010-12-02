function hasAutofocus() { 
	var element = document.createElement('input');
	return 'autofocus' in element;
}

$(function(){
	if(!hasAutofocus()) {
		$('input[autofocus=true]' ).focus();
	}
});
