window.onload = function() {

    function submit_on_filter_change(filter) {
	//alert(filter);
	n = filter;
	
	while(n.nodeName.toLowerCase() != "form")  {
	    n = n.parentNode;
	}
	if(!(n["title"].checked || n["album"].checked || n["artist"].checked )) {
	    alert("Atleast one among title, album, artist should be chosen!");
	    n["title"].checked = true;
	}
	n.submit();
    }
    
    document.getElementById('s_title').onclick = function() {
	submit_on_filter_change(document.getElementById('s_title'));
    };
    document.getElementById('s_album').onclick = function() {
	submit_on_filter_change(document.getElementById('s_album'));
    };
    document.getElementById('s_artist').onclick = function() {
	submit_on_filter_change(document.getElementById('s_artist'));
    };
};