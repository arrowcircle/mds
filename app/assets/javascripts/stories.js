$(document).ready(function(){

  $("#jquery_jplayer_1").jPlayer({
    ready: function (event) {
      $(this).jPlayer("setMedia", {
        mp3: $('#jquery_jplayer_1').data('link')
      });
    },
    swfPath: "assets",
    supplied: "mp3",
    wmode: "window"
  });
});
console.log($('#jquery_jplayer_1').data('link'));