var toc = $("#toc");

$(window).scroll(function() {

    if (this.scrollY > 215) {
        toc.addClass("fix-toc");
    } else {
        toc.removeClass("fix-toc");
    }

});

var sec = $(".sect1");
var preamble = $("#preamble");
var footnotes = $("#footnotes");

$(window).resize(function() {
    sec.css({paddingLeft: toc.css("width")});
    preamble.css({paddingLeft: toc.css("width")});
    footnotes.css({paddingLeft: toc.css("width")});
});

$(document).ready(function () {
    sec.css({paddingLeft: toc.css("width")});
    preamble.css({paddingLeft: toc.css("width")});
    footnotes.css({paddingLeft: toc.css("width")});
});