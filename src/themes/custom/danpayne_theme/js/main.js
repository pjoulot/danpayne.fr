(function ($, Drupal) {
  Drupal.behaviors.DanPayneTheme = {
    attach: function (context, settings) {
      $(context).find('input.DanPayneThemeBehavior').once('DanPayneThemeBehavior').each(function () {
        $(".owl-carousel").owlCarousel({
          autoPlay: true,
          slideSpeed : 300,
          singleItem:true
        });
      });
    }
  };
})(jQuery, Drupal);

jQuery(document).ready(function() {
    
    jQuery(".owl-carousel").owlCarousel({
	    autoPlay: false,
	    slideSpeed : 300,
      singleItem:true
	  });
   
  });