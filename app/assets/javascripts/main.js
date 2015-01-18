var COMMENT_TIME_ON_SCREEN_SECONDS = 2;
var TEXT_MAX = 40;

comments = [];

function load_initial_comments() {
	$.ajax({
	  dataType: "json",
	  url: '//mst4k.herokuapp.com/get_comments.json',
	  data: {
	  	auth: "hackingyovids"
	  },
	  jsonp: 'test',
	  success: function(d){
	  	comments = d;
	  }
	});
}
load_initial_comments();

/*var comments = [
	{
		time: 2,
		text: "Hello world",
		position_x: 0.4,
		position_y: 0.5
	}
];*/




$(document).ready(function() {
	videojs("myvideo").ready(function(){
		var myPlayer = this;
		var play_time = 0;

		var user_name = "James";
		//var user_name = window.prompt("Please enter your name.");


		myPlayer.on("timeupdate", function (){
			var currentTime = myPlayer.currentTime();

			for(var i = 0; i < comments.length; i++) {

				var commentTime = parseFloat(comments[i].time);

				if(currentTime >= commentTime && currentTime <= commentTime  + COMMENT_TIME_ON_SCREEN_SECONDS && comments[i].visible != true) {
					comments[i].visible = true;

					var el = $("<div class='text-comment'>" + comments[i].user + ": " + comments[i].text + "</div>");
					var video = $("#myvideo_html5_api");
					
					var video_position = video.position();

					var video_height = video.height();
					var video_width  = video.width();


					var comment_left = parseFloat(comments[i].position_x) * video_width+video_position.left;
					var comment_top  = parseFloat(comments[i].position_y) * video_height + video_position.top;

					el.css({
						top: comment_top,
						left: comment_left
					});

					$("body").append(el);

					comments[i].element = el;
				}


				if(comments[i].visible == true && (currentTime <= commentTime || currentTime >= commentTime  + COMMENT_TIME_ON_SCREEN_SECONDS)) {
					comments[i].element.remove();
					comments[i].visible = false;
				}
			}
		});

		$("#myvideo_html5_api").click(function(e) {
			console.log("Video clicked", e);
			var text_box = $("#text_box");

			play_time = myPlayer.currentTime();
				

			text_box.css({
				top: e.clientY + 'px',
				left: e.clientX + 'px'
			});

			text_box.show();
			text_box.val("");
			text_box.focus();

			myPlayer.pause();

		});
		$("#text_box").keypress(function(e){
			if (e.which === 13) {
				var video = $("#myvideo_html5_api");

				//
				// Figure out the position of the text box
				//
				var video_position = video.position();
				var text_box_position = $(this).position();

				var position_relative_to_video = {
					top: text_box_position.top - video_position.top,
					left: text_box_position.left - video_position.left
				};

				var video_height = video.height();
				var video_width = video.width();

				var position_percentages = {
					top: position_relative_to_video.top / video_height,
					left: position_relative_to_video.left / video_width
				}

				//
				// Grab the text
				//

				var text = $(this).val();
				if (text.length > TEXT_MAX) {
					text = text.substring(0, TEXT_MAX);
				}


				$(this).hide();
				$(this).val("");

				$.get("https://mst4k.herokuapp.com/submit_comment", {
					auth: "hackingyovids",
					time: play_time,
					text: text,
					user: user_name,
					position_x: position_percentages.left,
					position_y: position_percentages.top
				});
				
				myPlayer.play();

			}else {
				if ($(this).val().length > TEXT_MAX){
					return false;
				}
			}
		});
	});

	
});
