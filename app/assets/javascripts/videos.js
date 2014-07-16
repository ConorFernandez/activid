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
    
    $("#video").click(function() {
       var src = $(".vid-src").text();
       var title = $(".vid-title").text();
       var desc =  $(".vid-desc").text();
       $("#vid_frame").attr("src", src);
       $("#vid-main-title").text(title);
       $("#vid-main-description").text(desc);
    })

});