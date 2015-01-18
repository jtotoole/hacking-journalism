var COMMENT_TIME_ON_SCREEN_SECONDS = 3;


// 	
$.ajax({
  dataType: "json",
  url: 'https://mst4k.herokuapp.com/get_comments?auth=hackingyovids',
  callback : 'test',
  // data: data,
  success: function(d){
  	console.log(d);
  }
});


var comments = [
	{
		time: 2,
		text: "Hello world",
		posiiton_x: 0.4,
		position_y: 0.5
	}
];



$(document).ready(function() {
	videojs("myvideo").ready(function(){
		var myPlayer = this;
		var play_time = 0;

		myPlayer.on("timeupdate", function (){
			var currentTime = myPlayer.currentTime();

			for(var i = 0; i < comments.length; i++) {

				if(currentTime >= comments[i].time && currentTime <= comments[i].time + COMMENT_TIME_ON_SCREEN_SECONDS && comments[i].visible != true) {
					comments[i].visible = true;

					$("body").append("<div>" + comments[i].text + "</div>");
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


		});
		$("#text_box").keypress(function(e){
			console.log(e.which);	
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

				$.get("https://mst4k.herokuapp.com/submit_comment", {
					auth: "hackingyovids",
					time: play_time,
					text: text,
					position_x: position_percentages.left,
					position_y: position_percentages.top
				});
			

			}
		});
	});

	
});
