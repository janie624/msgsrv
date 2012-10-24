$(function() {

  $(".video-gallery").fancybox({
    nextEffect: 'fade',
    prevEffect: 'fade',
    arrows: true,
    width: 800,
    height: 600,
    fitToView: false,
    autoCenter: true,
    autoSize: false,
    loop: false,
    helpers: {
      media: true
    },
    youtube: {
      autoplay: 1
    }
  });

  $('body').on('click', '.oauth2-window', function(e) {
    e.preventDefault();

    var left = (screen.width-800)/2,
        top = (screen.height-600)/2;

    window.open(this.href, "oauth2", 'width=800, height=600, left='+left+',top='+top+', status=no, toolbar=no, menubar=no');
  });

  $('[rel~="tooltip"]').tooltip();

});
