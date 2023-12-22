function enableScrollToTop() {
	$('<a href="" class="scrollup"><span class="glyphicon glyphicon-arrow-up" title="Back To Top"></span></a>')
		.appendTo('body');
		//scroll to top css and functions
	  $(".scrollup").css({
		  width: "60px",
		  height: "60px",
		  position: "fixed",
		  bottom: "10px",
		  right: "10px",
		  "text-align": "center",
		  padding: "10px",
		  "z-index": 100,
		  display: "none"	
		}
	  ).click(function() {
		  $("html, body").animate({
			    scrollTop: 0
			  }, 600);
			  return false;
		});
	  $(window).scroll(function() {
		  if ($(this).scrollTop() > $(window).height()/6) {
		    $(".scrollup").fadeIn();
		  } else {
		    $(".scrollup").fadeOut();
		  }
		});	
}