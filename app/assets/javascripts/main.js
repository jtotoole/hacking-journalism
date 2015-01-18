var COMMENT_TIME_ON_SCREEN_SECONDS = 2;
var TEXT_MAX = 40;

comments = [];

var player = {};

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

function createCommentMarker(time, data, duration, controlsElement){
	// time and duration in seconds
	var commentLeft =  time / duration * 100;
	var containerWidth = controlsElement.width();
	var boxLeft = ((time/duration * containerWidth) - 18) / containerWidth * 100;

	// create marker
	// shouldn't write html in jquery but whatever
	var markerHtml = '<div id="' + data.id + '" class="comment-marker" style="left: ' + commentLeft + '%;"></div>';
	var boxHtml = '<div data-comment-id="' + data.id + '" class="comment-marker-box text-left" style="left: ' + boxLeft + '%;"><p class="text-small kicker text-uppercase">' + data.user + '</p><p>' + data.text + '</p></div>';
	controlsElement.append(markerHtml);
	controlsElement.append(boxHtml);

	// store data associated to marker in the marker itself
	var $marker = $('.comment-marker#' + data.id);
	var $box = $('.comment-marker-box[data-comment-id="' + data.id + '"]');
	$marker.data(data);

	$marker.on('mouseover', function(){
		$box.addClass('comment-marker-box-visible');
	}).on('mouseout', function(){
		$box.removeClass('comment-marker-box-visible');
	}).on('click', function(){
		player.video.currentTime(data.time.toString());
	});
}

function addEventListeners(){
	var $inputOpts = $('.input-options-buttons');
	$inputOpts.on('click', 'li', function(){
		input_type = $(this).attr('data-type');
		console.log('clicked: ', input_type);
		if(input_type=='draw'){
			startDrawing(); //THIS IS IN THE drawing.js FILE IN FRONTEND
		}
	});
}

$(document).ready(function() {
	addEventListeners();

	videojs("myvideo").ready(function(){
		player.video = this;
		var myPlayer = this;
		var play_time = 0;

		var user_name = "James";
		//var user_name = window.prompt("Please enter your name.");

		myPlayer.on('loadedmetadata', function(){
			 player.duration = myPlayer.duration();

			$.each(comments, function(index, comment){
				createCommentMarker(comment.time, comment, player.duration, $('.vjs-progress-control'));
			});
		});

		myPlayer.on("timeupdate", function (){
			var currentTime = myPlayer.currentTime();

			for(var i = 0; i < comments.length; i++) {

				var commentTime = parseFloat(comments[i].time);

				if(currentTime >= commentTime && currentTime <= commentTime  + COMMENT_TIME_ON_SCREEN_SECONDS && comments[i].visible != true) {
					comments[i].visible = true;

					var el = $("<div class='text-comment text-left'><p class='kicker text-small'>" + comments[i].user + "</p><p>" + comments[i].text + "</p></div>");
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
			var $inputWrapper = $("#input-options"),
				text_box = $inputWrapper.find('#text_box');

			play_time = myPlayer.currentTime();


			$inputWrapper.css({
				top: e.clientY + 'px',
				left: e.clientX + 'px'
			});

			$inputWrapper.show();
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


        // $(this).hide();
        //hide input options
        $("#input-options").hide();
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
