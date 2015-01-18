
function startDrawing(){
    ///**
// * Created by viviandiep on 1/17/15.
// */

    paper.install(window);
    //window.onload = function() {
    paper.setup('main-canvas');
    // Create a simple drawing tool:
    var tool = new Tool();
    tool._minDistance = 10;
    var path;
    var colors = ['#c783c4','#6578df','#5aef96'];
    var saved = [];
    var project = paper.project;
    // Define a mousedown and mousedrag handler
    setMeUp();
    function setMeUp(){
        var screenHeight = screen.height;
        var videoHeight = $("#myvideo").css('height');
        console.log(videoHeight);
        $("#main-canvas").css('top',"-"+videoHeight);
    }
    tool.onMouseDown = function(event) {
        // Create a new path and select it:
        path = new Path();
        var randy = Math.random();
        var cc;
        if(randy<0.33){
            cc = colors[0];
        }
        if(randy<0.66 && randy>0.33){
            cc = colors[1];
        }else{
            cc=colors[2];
        }

        path.strokeColor = cc;

        // Add a segment to the path where
        // you clicked:
        path.add(event.point);
    }

    tool.onMouseDrag = function(event) {
        // Every drag event, add a segment
        // to the path at the position of the mouse:
        path.add(event.point);
    }

    tool.onKeyDown = function(event){
        event.preventDefault();
        console.log("TOOL KEYDOWN");
        console.log(event.key);
        if(event.key == 'a'){
            project.clear();
            console.log('SAVED AT 0');
            console.log(saved[0]);

        }
        if (event.key == 'space') {
            //console.log(document.getElementById("youtube-video").paused);
            if(document.getElementById("myvideo").paused == true){
                //save drawing
                saveDrawing();
                $("#myvideo").trigger('play');
            }else{
                $("#myvideo").trigger('pause');
            }

        }
    }

    function saveDrawing(){
        var currentTimeVideo = document.getElementById("myvideo").currentTime;
        var jsonExport = project.exportJSON();
        var pushMe = {'time':currentTimeVideo, 'data':jsonExport};
        if(jsonExport.length==0 || jsonExport==null ){

        }else{
            saved.push(pushMe);
            project.clear();
            console.log(currentTimeVideo);
            localStorage.setItem("videoDrawings",JSON.stringify(saved));
        }

        //paper.clear();
    }


    function getDrawing(){
        console.log('in get drwaing');
        if(localStorage.getItem('oldDrawings')!==null){
            console.log("returning oldDrawings");
            return localStorage.getItem('oldDrawings');
        }else{
            return false;
        }

    }

    setInterval(function(){
        console.log("UNLOOOOOOOAAADDDIIINNNNGGG");
        var newDrawings = JSON.parse(localStorage.getItem('videoDrawings'));
        var oldDrawings = JSON.parse(localStorage.getItem('oldDrawings'));
        if(oldDrawings==null){
            oldDrawings = [];
        }
        oldDrawings.push(newDrawings);
        localStorage.clear();
        localStorage.setItem('oldDrawings',JSON.stringify(oldDrawings));
    },5000);

    $("#myvideo").on('pause',function(){
        //console.log("HIT PAUSE");
        //switch zindex
        $("#myvideo").css('z-index',0)
        //console.log($("#myvideo").css('z-index'));
        $("#main-canvas").css('z-index',200);
        //console.log($("#main-canvas").css('z-index'));
    });

    $("#myvideo").on('play',function(){
        //console.log("HIT PLAY");
        //switch zindex
        $("#myvideo").css('z-index',200)
        //console.log($("#youtube-video").css('z-index'));
        $("#main-canvas").css('z-index',0);
        //console.log($("#main-canvas").css('z-index'));
        function retrieveDrawing(){
            if(document.getElementById('myvideo').paused==false){

                var vid = document.getElementById('myvideo');
                var drawings = JSON.parse(getDrawing());
                if(drawings){
                    drawings.forEach(function(item,index){
                        if(item!==null && item!==undefined){
                            item.forEach(function(drawing,iindex){
                                if(vid.currentTime.toString().substring(0,2) == drawing.time.toString().substring(0,2)){
                                    console.log("EXISTS!");
                                    $("#myvideo").css('z-index',0);
                                    $('#main-canvas').css('z-index',200);
                                    path = new Path();
                                    path.importJSON(drawing.data);
                                    paper.view.update();
                                    setTimeout(function(){
                                        project.activeLayer.remove();
                                        paper.view.update();
                                    },2000);
                                }
                            })

                        }

                    })
                }
                setTimeout(retrieveDrawing,1000);
            }
        }
        retrieveDrawing();


    });

    //}





}