// Adapted from:
// http://callumhay.blogspot.com/2010/09/gaussian-blur-shader-glsl.html

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform sampler2D maskImage;
// The inverse of the texture dimensions along X and Y
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform int blurSize;       
uniform int horizontalPass; // 0 or 1 to indicate vertical or horizontal pass
uniform float sigma;        // The sigma value for the gaussian function: higher value means more blur
                            // A good value for 9x9 is around 3 to 5
                            // A good value for 7x7 is around 2.5 to 4
                            // A good value for 5x5 is around 2 to 3.5
                            // ... play around with this based on what you need :)

const float pi = 3.14159265;


float rgb2gray(vec4 col){
  return 0.299*col.r + 0.587*col.g + 0.114*col.b;
}

void main() {  
  // float numBlurPixelsPerSide = float(blurSize / 2); 
  
  // vec2 blurMultiplyVec = 0 < horizontalPass ? vec2(1.0, 0.0) : vec2(0.0, 1.0);

  // // Incremental Gaussian Coefficent Calculation (See GPU Gems 3 pp. 877 - 889)
  // vec3 incrementalGaussian;
  // incrementalGaussian.x = 1.0 / (sqrt(2.0 * pi) * sigma);
  // incrementalGaussian.y = exp(-0.5 / (sigma * sigma));
  // incrementalGaussian.z = incrementalGaussian.y * incrementalGaussian.y;

  vec2 tc0 = vertTexCoord.st + vec2(-texOffset.s, -texOffset.t);
  vec2 tc1 = vertTexCoord.st + vec2(         0.0, -texOffset.t);
  vec2 tc2 = vertTexCoord.st + vec2(+texOffset.s, -texOffset.t);
  vec2 tc3 = vertTexCoord.st + vec2(-texOffset.s,          0.0);
  vec2 tc4 = vertTexCoord.st + vec2(         0.0,          0.0);
  vec2 tc5 = vertTexCoord.st + vec2(+texOffset.s,          0.0);
  vec2 tc6 = vertTexCoord.st + vec2(-texOffset.s, +texOffset.t);
  vec2 tc7 = vertTexCoord.st + vec2(         0.0, +texOffset.t);
  vec2 tc8 = vertTexCoord.st + vec2(+texOffset.s, +texOffset.t);
  
  vec4 col0 = texture2D(texture, tc0);
  vec4 col1 = texture2D(texture, tc1);
  vec4 col2 = texture2D(texture, tc2);
  vec4 col3 = texture2D(texture, tc3);
  vec4 col4 = texture2D(texture, tc4);
  vec4 col5 = texture2D(texture, tc5);
  vec4 col6 = texture2D(texture, tc6);
  vec4 col7 = texture2D(texture, tc7);
  vec4 col8 = texture2D(texture, tc8);

  float gray0=rgb2gray(col0);
  float gray1=rgb2gray(col1);
  float gray2=rgb2gray(col2);
  float gray3=rgb2gray(col3);
  float gray4=rgb2gray(col4);
  float gray5=rgb2gray(col5);
  float gray6=rgb2gray(col6);
  float gray7=rgb2gray(col7);
  float gray8=rgb2gray(col8);

  vec4 sum = 8.0 * col4 - (col0 + col1 + col2 + col3 + col5 + col6 + col7 + col8); 
  float len=(sum.x*sum.x+sum.y*sum.y+sum.z*sum.z);
  float len1=2*(-gray3+gray5)-(gray0+gray6)+(gray2+gray8);
  float len2=2*(-gray1+gray7)-(gray0+gray2)+(gray6+gray8);
  // float len3=2*(gray2+gray4+gray6)-(gray0+gray1+gray3)-(gray5+gray7+gray8);
  // float len4=2*(gray0+gray4+gray8)-(gray1+gray2+gray5)-(gray3+gray6+gray7);
  // float len=gray4*8-(gray0+gray1+gray2+gray3+gray5+gray6+gray7+gray8);
  // if(len1>0.05||len2>0.05||len3>0.05||len4>0.05){

  float factor=1.0;  


  if(abs(len1)+abs(len2)>0.01){
    vec4 avgValue = vec4(0.0, 0.0, 0.0, 0.0);
    float coefficientSum = 0.0;

    
    // avgValue += col4;
    
    float mgrid=50.0;  
    // float ti=vertTexCoord.s-floor(vertTexCoord.s/(1.0/mgrid))*(1.0/mgrid);
    // float tj=vertTexCoord.t-floor(vertTexCoord.t/(1.0/mgrid))*(1.0/mgrid);  
    // ti=ti/(1.0/mgrid);
    // tj=tj/(1.0/mgrid);
    float mpix=16.0;
    for(float i=.0;i<mpix;i+=1.0){
      for(float j=.0;j<mpix;j+=1.0){
        avgValue+=texture2D(maskImage,vec2(i/mpix,j/mpix))*texture2D(texture,vertTexCoord+vec2(i/mgrid/mpix,j/mgrid/mpix));
        coefficientSum+=texture2D(maskImage,vec2(i/mpix,j/mpix)).x;
      }
    }



    // float mxrad=blurSize;
    // float myrad=mxrad*2*vertTexCoord.t;
    // float theta=asin(vertTexCoord);

    // int si=int(vertTexCoord.s*mxrad);
    // int sj=int(vertTexCoord.t*myrad);  
    // vec2 cent=vec2(float(si+.5+.5*sin(theta))/mxrad,float(sj+.5+.5*cos(theta))/myrad);

    // float dist=(vertTexCoord.x-cent.x)*(vertTexCoord.x-cent.x)+(vertTexCoord.y-cent.y)*(vertTexCoord.y-cent.y);
    // float mang=5.0;
    // float thres=1.0/(mxrad)/(myrad)/2.0;
    // if(dist<thres){

    //      for(int i=1;i<mang;++i){
    //       for(int j=1;j<mang;++j){
    //         vec2 neighbor=cent+vec2(i/mang/mxrad,j/mang/mxrad);
    //         vec4 ncolor=texture2D(texture, neighbor.xy);
            
    //           avgValue+=ncolor;
    //           coefficientSum+=1.0;
            
    //       }
    //     }
       vec4 avgcolor=avgValue/coefficientSum;
       gl_FragColor=avgcolor;
    // }else{
    //   gl_FragColor=texture2D(texture,vertTexCoord);
    // }
    // gl_FragColor=vec4(1,0,0,1);
  

  }else{
    gl_FragColor = col4;
    // factor=0.2;
  }
  
    // float mgrid=50.0;  
    // float ti=vertTexCoord.s-floor(vertTexCoord.s/(1.0/mgrid))*(1.0/mgrid);
    // float tj=vertTexCoord.t-floor(vertTexCoord.t/(1.0/mgrid))*(1.0/mgrid);  
    // ti=ti/(1.0/mgrid);
    // tj=tj/(1.0/mgrid);

    // gl_FragColor=col4*((1.0-factor)+factor*(texture2D(maskImage,vec2(ti,tj))));
  

}