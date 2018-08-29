var toc = $("#toc");

$(window).scroll(function() {

    if (this.scrollY > 215) {
        toc.addClass("fix-toc");
    } else {
        toc.removeClass("fix-toc");
    }

});

// toc.on("scroll", function(e) {
//
//     if (this.scrollTop > 147) {
//         toc.addClass("fix-toc");
//     } else {
//         toc.removeClass("fix-toc");
//     }
//
// });