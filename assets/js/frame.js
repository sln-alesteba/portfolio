// http://jsfiddle.net/PQS3A/7/

$(window).load(function(){
    
    var canvas = $('#cv').get(0);
    var ctx    = canvas.getContext('2d');

    fitToContainer(canvas);

    ctx.fillStyle='yellow';
    // for (var i=0;i<5;++i) ctx.fillRect(i*18+2,2,16,16);

    function fitToContainer(canvas){
        canvas.style.width='100%';
        // canvas.style.height='100%';
        canvas.width  = canvas.offsetWidth;
        // canvas.height = canvas.offsetHeight;
    }   

    function get_rnd_pt(min, max) {

        return Math.floor(Math.random() * (max - min)) + min;
      }

    // get the point in the screen:

    function get_rnd_scr()
    {
        var min_x = 0;
        var max_x = canvas.width;

        x = get_rnd_pt(min_x, max_x)

        var min_y = 0;
        var max_y = canvas.height;

        y = get_rnd_pt(min_y, max_y)

        return [x, y]
    }

    // var ctx = $('#cv').get(0).getContext('2d');

    var circles = [

        // { x: get_rnd_pt(), y: get_rnd_pt(), r: 25 },
        // { x: get_rnd_pt(), y: get_rnd_pt(), r: 25 },
        // { x: get_rnd_pt(), y: get_rnd_pt(), r: 25 },
        // { x: get_rnd_pt(), y: get_rnd_pt(), r: 25 },
    ];

    for (i = 0; i < 5; i++)
    {
        p_data = get_rnd_scr()

        circles.push({x:p_data[0],y:p_data[1], r:25})
    }

    function drawCircle(data) {
        ctx.beginPath();
        ctx.arc(data.x, data.y, data.r, 0, Math.PI * 2);
        ctx.fill();
    }

    function drawLine(from, to) {
        ctx.beginPath();
        ctx.moveTo(from.x, from.y);
        ctx.lineTo(to.x, to.y);
        ctx.stroke();
    }
        
    function drawBezier(data)
    {
        c_points = BezierCurve(data, 0.01)

        var c_prev = c_points[0];

        $.each(c_points, function(){

            drawLine(c_prev, this)

            c_prev = this;
        });
    }

    // create function -> 

    function draw_dots()
    {
        var prev = circles[0]

        $.each(circles, function() {
            drawCircle(this);
            drawLine(prev, this);
            prev = this;
        });
    }

    draw_dots()

    // aplicamos funciones:

    var focused_circle, lastX, lastY ;

    function test_distance( n, test_circle ){ 

        if( focused_circle ) return false;
        var dx = lastX - test_circle.x,
        dy = lastY - test_circle.y;
    
        if( dx * dx + dy * dy < test_circle.r * test_circle.r  ){
            focused_circle = n;
            $(document).bind( 'mousemove.move_circle' , drag_circle );
            $(document).bind( 'mouseup.move_circle' , clear_bindings);
            return false; 
        }
    }

    $('#cv').mousedown( function( e ){
        lastX = e.pageX - $(this).offset().left;
        lastY = e.pageY - $(this).offset().top;
        $.each( circles, test_distance );
    });


    function drag_circle( e ){
        var newX = e.pageX - $('#cv').offset().left,
            newY = e.pageY - $('#cv').offset().top;

        circles[ focused_circle ].x += newX - lastX;
        circles[ focused_circle ].y += newY - lastY;

        lastX = newX, lastY = newY;

        ctx.clearRect( 0, 0, ctx.canvas.width, ctx.canvas.height );

        // repaint:

        draw_dots()

        drawBezier(circles)
    }

    function clear_bindings( e ){ 
        $(document).unbind( 'mousemove.move_circle mouseup.move_circle' );
        focused_circle=undefined;
    }

});