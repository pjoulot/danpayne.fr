(function ($, Drupal) {
  Drupal.behaviors.DanPayneTheme = {
    attach: function (context, settings) {
      $(context).find('input.DanPayneThemeBehavior').once('DanPayneThemeBehavior').each(function () {

        $('.owl-carousel').owlCarousel({
          items: 1,
          margin: 10,
          loop: true,
          autoplay: true,
          autoplay: true,
          autoplaySpeed: 300
        })
      });
      
      $(".js-mobile-menu-button").on('click', function() {
        if ($(".navigation-menu").height() == 0 || $(".navigation-menu").height() == "0px") {
          let heightMenu = $(".navigation-menu>li").length * 40;
          $(".navigation-menu").css("height", heightMenu + "px");
        }
        else {
          $(".navigation-menu").css("height", 0);
        }
      });
      jQuery(document).ready(function() {
        $('.owl-carousel').owlCarousel({
          items: 1,
          margin: 10,
          loop: true,
          autoplay: true,
          autoplaySpeed: 300
        });
      });
    }
  };
})(jQuery, Drupal);