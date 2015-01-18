var COMMENT_TIME_ON_SCREEN_SECONDS = 2;
var TEXT_MAX = 40;

var OVERLAY_VIDEOS = true;

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

var recorder;
var player;


$(document).ready(function() {
	videojs("myvideo").ready(function(){
		var myPlayer = this;
		var play_time = 0;

		recorder = ZiggeoApi.Embed.embed("#recorder", {width: "320", height: "240", countdown: 0 });

		var user_name = "James";
		//var user_name = window.prompt("Please enter your name.");

		ZiggeoApi.Events.on("submitted", function(data) {
			console.log(data);

			$("#recorder").hide();

			recorder.reset();

			var position_percentages = {
				left: 0,
				top: 0
			};

			var play_time = myPlayer.currentTime();

			$.get("//mst4k.herokuapp.com/submit_comment", {
				auth: "hackingyovids",
				time: play_time,
				text: data.video.token,
				user: user_name,
				position_x: position_percentages.left,
				position_y: position_percentages.top,
				kind: "video"
			});

			$("#close_recorder").hide();
		});

		ZiggeoApi.Events.on("stop", function (data) {
			$("#"+data.video.token).remove();

			if(OVERLAY_VIDEOS == false ) {
				myPlayer.play();
			}
		});
		$("recorder").css({width: "320px", height:"240px"});

		myPlayer.on("timeupdate", function (){
			var currentTime = myPlayer.currentTime();

			for(var i = 0; i < comments.length; i++) {

				var commentTime = parseFloat(comments[i].time);

				if(currentTime >= commentTime - 1.5 && currentTime <= commentTime && comments[i].preloaded != true) {
					if(comments[i].kind == "video") {
						el = $("<div class='player' id='" + comments[i].text + "''></div>");
						$("body").append(el);
						player = ZiggeoApi.Embed.embed("#" + comments[i].text, { width: 320, height: 240, video: comments[i].text });
						comments[i].element = el;
						comments[i].player = player;
						comments[i].preloaded = true;

					}
				}

				if(currentTime >= commentTime && currentTime <= commentTime  + COMMENT_TIME_ON_SCREEN_SECONDS && comments[i].visible != true) {
					comments[i].visible = true;

					if(comments[i].kind == "text") {
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
					else if(comments[i].kind == "video") {
						if(comments[i].preloaded == true) {
							comments[i].element.css({ visibility: 'visible' });
							comments[i].player.play();

							if(OVERLAY_VIDEOS == false) {
								myPlayer.pause();
							}
						}
					}
				}

				if(comments[i].visible == true && (currentTime <= commentTime || currentTime >= commentTime  + COMMENT_TIME_ON_SCREEN_SECONDS)) {
					if(comments[i].kind == "text") {
						comments[i].element.remove();

						comments[i].visible = false;
					}
				}
			}
		});

		$("#record_button").click(function(e){
			$("#recorder").show();
			$("#recorder").css({width: "320px", height: "240px"});
			$("#close_recorder").show();
			$(this).hide();
			myPlayer.pause();
		});

		$("#close_recorder").click(function(e){
				$("#close_recorder").hide();
				$("#recorder").hide();
				$("#record_button").show();

				myPlayer.play();
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

				$.get("//mst4k.herokuapp.com/submit_comment", {
					auth: "hackingyovids",
					time: play_time,
					text: text,
					user: user_name,
					position_x: position_percentages.left,
					position_y: position_percentages.top,
					kind: "text"
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
