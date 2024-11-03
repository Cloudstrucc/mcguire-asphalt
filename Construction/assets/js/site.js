(function($) {
    "use strict";

    // Preloader
    $(window).on('load', function() {
        $('.preloader').fadeOut('slow');
    });

    // Navigation
    $(window).scroll(function() {
        if ($(".navbar").offset().top > 50) {
            $(".navbar-fixed-top").addClass("top-nav-collapse");
        } else {
            $(".navbar-fixed-top").removeClass("top-nav-collapse");
        }
    });

    // Smooth Scrolling
    $('a[href*="#"]:not([href="#"])').click(function() {
        if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
            var target = $(this.hash);
            target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
            if (target.length) {
                $('html, body').animate({
                    scrollTop: target.offset().top - 60
                }, 1000);
                return false;
            }
        }
    });

    // Initialize other features
    $(document).ready(function() {
        // Initialize WOW.js
        new WOW().init();
        
        // Initialize Owl Carousel for logo section
        if ($("#logo").length) {
            $("#logo").owlCarousel({
                autoPlay: true,
                pagination: false,
                items: 6,
                itemsDesktop: [1199, 4],
                itemsDesktopSmall: [979, 3],
                itemsTablet: [768, 3],
                itemsMobile: [479, 2]
            });
        }

        // Form validation
        $('#form').on('submit', function(e) {
            e.preventDefault();
            var error = false;
            var name = $('#name').val();
            var email = $('#email').val();
            var subject = $('#subject').val();
            var message = $('#message').val();

            if (name.length == 0) {
                error = true;
                $('#name').css("border-color", "#D8000C");
            } else {
                $('#name').css("border-color", "#666");
            }
            if (!validateEmail(email)) {
                error = true;
                $('#email').css("border-color", "#D8000C");
            } else {
                $('#email').css("border-color", "#666");
            }
            if (subject.length == 0) {
                error = true;
                $('#subject').css("border-color", "#D8000C");
            } else {
                $('#subject').css("border-color", "#666");
            }
            if (message.length == 0) {
                error = true;
                $('#message').css("border-color", "#D8000C");
            } else {
                $('#message').css("border-color", "#666");
            }

            if (!error) {
                $('#error').fadeOut(500);
                // Handle form submission
                $('#success').fadeIn(500).css("display", "block");
                $('#form')[0].reset();
            } else {
                $('#error').fadeIn(500);
                $('#success').fadeOut(500);
            }

            return false;
        });
    });

    function validateEmail(email) {
        var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(email);
    }

})(jQuery);

// Google Maps Integration - Define globally
function initMap() {
    // Wait for Google Maps to be fully loaded
    if (typeof google === 'undefined') {
        setTimeout(initMap, 1000);
        return;
    }

    if (document.getElementById('map')) {
        const location = {
            lat: 45.3188867,
            lng: -75.761676
        };

        const mapOptions = {
            zoom: 15,
            center: location,
            scrollwheel: false,
            mapTypeControl: true,
            streetViewControl: true,
            styles: [
                {
                    "featureType": "administrative",
                    "elementType": "labels.text.fill",
                    "stylers": [{"color": "#444444"}]
                },
                {
                    "featureType": "landscape",
                    "elementType": "all",
                    "stylers": [{"color": "#f2f2f2"}]
                },
                {
                    "featureType": "poi",
                    "elementType": "all",
                    "stylers": [{"visibility": "off"}]
                },
                {
                    "featureType": "road",
                    "elementType": "all",
                    "stylers": [{"saturation": -100}, {"lightness": 45}]
                },
                {
                    "featureType": "road.highway",
                    "elementType": "all",
                    "stylers": [{"visibility": "simplified"}]
                },
                {
                    "featureType": "road.arterial",
                    "elementType": "labels.icon",
                    "stylers": [{"visibility": "off"}]
                },
                {
                    "featureType": "transit",
                    "elementType": "all",
                    "stylers": [{"visibility": "off"}]
                },
                {
                    "featureType": "water",
                    "elementType": "all",
                    "stylers": [{"color": "#46bcec"}, {"visibility": "on"}]
                }
            ]
        };

        try {
            // Create the map
            const map = new google.maps.Map(document.getElementById('map'), mapOptions);

            // Add marker
            const marker = new google.maps.Marker({
                position: location,
                map: map,
                title: 'McGuire Asphalt',
                animation: google.maps.Animation.DROP
            });

            // Add info window
            const infowindow = new google.maps.InfoWindow({
                content: `
                    <div style="width:250px">
                        <strong>McGuire Asphalt</strong><br>
                        Professional Paving Services<br>
                        Ottawa, ON<br>
                        <a href="tel:+16135550123">(613) 555-0123</a>
                    </div>`
            });

            // Open info window by default
            infowindow.open(map, marker);

            // Add click event to marker
            marker.addListener('click', () => {
                infowindow.open(map, marker);
            });

        } catch (e) {
            console.error('Error initializing map:', e);
        }
    }
}
