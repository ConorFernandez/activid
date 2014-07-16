$(document).ready(function () {
    $(".arrow-right").bind("click", function (event) {
        event.preventDefault();
        $(".vid-list-container").stop().animate({
            scrollLeft: "+=336"
        }, 750);
    });
    $(".arrow-left").bind("click", function (event) {
        event.preventDefault();
        $(".vid-list-container").stop().animate({
            scrollLeft: "-=336"
        }, 750);
    });
    
    $(".vid-item").click(function(e) {
      var src = $(this).find(".vid-src").text();
      var title = $(this).find(".vid-title").text();
      var desc = $(this).find(".vid-desc").text();
      $("#vid_frame").attr("src", src);
      $("#vid-main-title").text(title);
      $("#vid-main-description").text(desc);
  })
});