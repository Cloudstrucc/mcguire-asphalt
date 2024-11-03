(function ($) {
	"use strict";
/* Google Map  */
function gMap () {
if ($('#map').length) {


	            var map;
	            map = new GMaps({
	                div: '#map',
	                scrollwheel: false,
	                lat: -37.812802,
	                lng: 144.956981,
	            });
	            map.addMarker({
	                lat: -37.812802,
	                lng: 144.956981,
	                title: 'Envato HeadQuarter',
	            });


}
}

/* testimonial caroulse */
function testimonial () {
	if ($('#test-slider').length) {

		$("#test-slider").owlCarousel({

      navigation : true, // Show next and prev buttons
      slideSpeed : 300,
      paginationSpeed : 400,
      singleItem:true,
	  navigation:false,
	  pagination:true


  });
    };
	}


/* satisfied client */
function logo () {
	if ($('#logo').length) {


$("#logo").owlCarousel({

navigation : true, // Show next and prev buttons
slideSpeed : 300,
paginationSpeed : 400,
items : 5,
navigation:true,
navigationText: [
"<i class='fa fa-chevron-left'></i>",
"<i class='fa fa-chevron-right'></i>"
],
pagination:false


});


	    };
		};

/* affix the navbar after scroll below header */
function navStick () {
  if($('#nav').length){
	/*	$('#nav').affix({
		      offset: {
		        top: 90
		      }
		});
/* highlight the top nav as scrolling occurs */
$('body').scrollspy({ target: '#nav', offset: 90})

/* smooth scrolling for scroll to top */
$('.scroll-top').click(function(){
  $('body,html').animate({scrollTop:100},1000);

})

$(window).scroll(function () {
        if ($(window).scrollTop() >= 1) {
            $(".navbar").addClass("affix");
        }else {
            $(".navbar").removeClass("affix");
        }
    });

/* smooth scrolling for nav sections */
$('#nav .navbar-nav li>a').click(function(){
  var link = $(this).attr('href');
  var posi = $(link).offset().top;
  $('body,html').animate({scrollTop:posi},700);

});
};
};




/* content carousel  */
function fitnessCarosule () {
if ($('#fitness-coach').length) {
  $("#fitness-coach").owlCarousel({

      autoPlay: 3000, //Set AutoPlay to 3 seconds

      items : 2,
      itemsDesktop : [1170,3],
      itemsDesktopSmall : [979,2]

  });
}
}


/* number counter effect */
function counT () {
if ($('.count').length) {

$('.count').each(function() {
  $(this).prop('Counter', 0).animate({
    Counter: $(this).text()
  }, {
    duration: 4000,
    easing: 'swing',
    step: function(now) {
      $(this).text(Math.ceil(now));
    }
  });
});
}
}

 // wow activator
    function wowActivator () {
    	new WOW().init();
    }
// Contact Form
function contactFormValidation () {
if ($('#form').length) {
$('#form').validate({
        rules: {
            name: {
                required: true,
                minlength: 2
            },
            email: {
                required: true,
                email: true
            },
            mobile: {
                required: true
            },
            adult: {
                required: true,
            }
        },
        messages: {
            name: {
                required: "plese enter your name",
            },
            email: {
                required: "plese enter your email"
            },
            mobile: {
                required: "please enter your mobile number",
                minlength: "10"
            }

        },
        submitHandler: function(form) {
            $('#form').ajaxSubmit({
                type:"POST",
                data: $('#form').serialize(),
                url:"process.php",
                success: function() {
                    //$('#form :input').attr('disabled', 'disabled');
					//this.reset();
                    $('#form').fadeTo( "slow", 1, function() {
                       // $(this).find(':input').attr('disabled', 'disabled');
                       // $(this).find('label').css('cursor','default');
					   this.reset();
                        $('#success').fadeIn();
                    });
                },
                error: function() {
                    $('#form').fadeTo( "slow", 1, function() {
                        $('#error').fadeIn();
                    });
                }
            });
        }
    });
}
}
//Hide Loading Box (Preloader)
	function handlePreloader() {
		if($('.preloader').length){
			$('.preloader').delay(1000).fadeOut(1000);
		}
	}
// Dom Ready Function
	$(document).on('ready', function () {
		// add your functions
		gMap();
		fitnessCarosule();
		counT();
		wowActivator();
		contactFormValidation();
		handlePreloader();
		navStick();
		testimonial ();
		logo ();
	});
	// window on load functino
	$(window).on('load', function () {
		// add your functions
	});

})(jQuery);
