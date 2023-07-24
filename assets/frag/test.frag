// Author @kyndinfo - 2016
// http://www.kynd.info
// Title: Cubic Bezier
// Original bezier function by Golan Levin and Collaborators
// http://www.flong.com/texts/code/shapers_bez/

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// Helper functions:
float slopeFromT (float t, float A, float B, float C){
    // derivative of the function.

  float dtdx = 1.0/(3.0*A*t*t + 2.0*B*t + C); 
  return dtdx;
}

float xFromT (float t, float A, float B, float C, float D){
  float x = A*(t*t*t) + B*(t*t) + C*t + D;
  return x;
}

float yFromT (float t, float E, float F, float G, float H){
  float y = E*(t*t*t) + F*(t*t) + G*t + H;
  return y;
}
float lineSegment(vec2 p, vec2 a, vec2 b) {

    // smoothstep es lo que necesito usar a modo de diferencial.

    vec2 pa = p - a, ba = b - a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    return smoothstep(0.0, 1.0 / u_resolution.x, length(pa - ba*h));
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
	float px = 1.0 / u_resolution.y;
    
    // control point
    vec2 cp0 = vec2(0.25, sin(u_time) * 0.25 + 0.5);
    vec2 cp1 = vec2(0.75, cos(u_time) * 0.25 + 0.5);
    //float l = cubicBezier(st.x, cp0, cp1);
    //vec3 color = vec3(smoothstep(l, l+px, st.y));

    // curva de bezier a modo de smoothstep.

    vec3 color = vec3(0.0,0.0,0.0);

    // podría dibujar un lado de un color y el otro de otro.
    
    // draw control points
    color = mix(vec3(0.5), color, lineSegment(st, vec2(0.0), cp0));
    color = mix(vec3(0.5), color, lineSegment(st, vec2(1.0), cp1));
    color = mix(vec3(0.5), color, lineSegment(st, cp0, cp1));
    color = mix(vec3(1.0,0.0,0.0), color, smoothstep(0.01,0.01+px,distance(cp0, st)));
    color = mix(vec3(1.0,0.0,0.0), color, smoothstep(0.01,0.01+px,distance(cp1, st)));
    
    // todo se dibuja con el color y luego va al gl_frag_color.

    gl_FragColor = vec4(color, 1.0);
}