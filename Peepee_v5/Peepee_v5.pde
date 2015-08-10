
final int M_MODE=8;

int mpas=7;
ArrayList<PAnimal> pas;

float mid_pos;
float dest_pos;


PImage texture_img;
boolean save_frame=false;


DistortGraphic fill_canvas,stroke_canvas;
color back_color=color(random(100,255),random(20,80)+100,random(20,85));

int play_mode=0;

int mpas_to_play=0;
float angle_for_mode=0;

PShader blur;
PGraphics shader_canvas;
PFont logo_font;
PImage mask_img;


void setup(){
	
	size(800,800,P3D);
	
 	initAnimal();

	mid_pos=0;

	fill_canvas=new DistortGraphic(25);
	fill_canvas.transform_mag=2;
	fill_canvas.transform_vel=28;
	stroke_canvas=new DistortGraphic(1);

	mask_img=loadImage("grid.png");

	blur = loadShader("stroke.glsl");
  	blur.set("blurSize",255);
  	blur.set("sigma",3);
  	blur.set("maskImage",mask_img);


  	shader_canvas=createGraphics(width,height,P3D);

  	logo_font=loadFont("ppfont2.vlw");
  	

}
void initAnimal(){
	
	if(pas==null) pas=new ArrayList<PAnimal>();
	else pas.clear();

	float tmp_pos=0;
	float tmp_rad=width/2.5;
	float eang=TWO_PI/(float)mpas;
	for(int i=0;i<mpas;++i){
		float tmp_h=random(0.6,1.2)*height/15;
		float tmp_ang=eang*i;//*random(.95,1.05);
		pas.add(new PAnimal(width/2+tmp_rad*sin(tmp_ang),height/2+tmp_rad*cos(tmp_ang),width/5*random(.6,1.4),tmp_h));
		pas.get(i).phi=PI-tmp_ang;
		// tmp_pos+=tmp_h;
		// if(tmp_h>height) return;
		PVector p1=new PVector(width/2+tmp_rad*.9*sin(tmp_ang-eang/2),height/2+tmp_rad*.9*cos(tmp_ang-eang/2));
		PVector p2=new PVector(width/2+tmp_rad*.9*sin(tmp_ang+eang/2),height/2+tmp_rad*.9*cos(tmp_ang+eang/2));
		
		PAnimal pa=pas.get(i);

		p1.sub(pa.getCurPos()); p1.rotate(-pa.phi);
		p2.sub(pa.getCurPos()); p2.rotate(-pa.phi);
		
		pa.tail_land_pos=p2.get();
		pa.head_land_pos=p1.get();
	}
	mpas=pas.size();
	mpas_to_play=mpas;
}

void draw(){
	
	background(back_color);	
	

	fill_canvas.beginDraw();
	stroke_canvas.beginDraw();
	
	fill_canvas.background(back_color);
	stroke_canvas.background(color(255,0));

	// background(255);
	
	float tmp_rad=width/3;
	float eang=TWO_PI/(float)mpas;
	for(int i=0;i<mpas;++i){
		float tmp_ang=eang*i-(float)frameCount/250;
		pas.get(i).x=width/2+tmp_rad*sin(tmp_ang);
		pas.get(i).y=height/2+tmp_rad*cos(tmp_ang);
		pas.get(i).phi=PI-tmp_ang;
	}

	for(int i=0;i<mpas_to_play;++i){
		PAnimal pa=pas.get(i);
		// pa.draw(stroke_canvas.pg,false);
		PVector p1=pas.get((i+1)%mpas).getCurHeadLandPos();
		PVector p2=pas.get((i-1+mpas)%mpas).getCurTailLandPos();
		PVector p3=pas.get((i+mpas/2)%mpas).getCurTailLandPos();
		int ti=(int)(i+mpas/3)%mpas;
		// if(ti==i) ti=(ti+2)%mpas;
		PVector p4=pas.get(ti).getCurHeadLandPos();

		p1.sub(pa.getCurPos()); p1.rotate(-pa.phi);
		p2.sub(pa.getCurPos()); p2.rotate(-pa.phi);
		p3.sub(pa.getCurPos()); p3.rotate(-pa.phi);
		p4.sub(pa.getCurPos()); p4.rotate(-pa.phi);

		pa.draw(fill_canvas.pg,true,
				p1,p2,p3,p4);
		pa.draw(stroke_canvas.pg,false,p1,p2,p3,p4);
		// image(pa.mtext.pg,pa.x,pa.y);
	}
	 	// fill_canvas.pg.shader(blur);
	
	fill_canvas.endDraw();


	// for(int i=0;i<mpas_to_play;++i){
	// 	PAnimal pa=pas.get(i);
	// 	// pa.draw(stroke_canvas.pg,false,
	// 	// 	    pas.get((i-1+mpas)%mpas).getCurHeadLandPos(),pas.get((i+1)%mpas).getCurTailLandPos());
	// }
	
	for(int i=0;i<mpas_to_play;++i){
		PAnimal pa=pas.get(i);
		pa.drawLandLine(stroke_canvas.pg,pas.get((i-1+mpas)%mpas),i%2);
	}
	drawPPLogo(stroke_canvas.pg);
	stroke_canvas.endDraw();

	pushMatrix();
	// smooth();
	// translate(width/2,height/2);
	// rotate((float)frameCount/500);
	// translate(-width/2,-height/2);
	
	// if(play_mode>2) blendMode(ADD);
  	shader_canvas.beginDraw();
	   	fill_canvas.draw(shader_canvas);
	   	// float ew=width/3.0;
	   	// shader_canvas.noStroke();
	   	// for(int i=0;i<3;++i){
	   	// 	for(int j=0;j<3;++j){
	   			
	   	// 		shader_canvas.fill(i*255/3,j*255/3,120);
	   	// 		shader_canvas.beginShape();
		   // 			shader_canvas.vertex(i*ew,j*ew);
		   // 			shader_canvas.vertex(i*ew+ew,j*ew);
		   // 			shader_canvas.vertex(i*ew+ew,j*ew+ew);
		   // 			shader_canvas.vertex(i*ew,j*ew+ew);
	   	// 		shader_canvas.endShape();
	   	// 	}
	   	// }
	   	shader_canvas.shader(blur);
   	shader_canvas.endDraw();

   	image(shader_canvas,0,0);
   
   	image(stroke_canvas.pg,-width/20,0);
   	 
   	popMatrix();

   

	frame.setTitle(String.valueOf(frameRate));
	if(save_frame) saveFrame("pee-####.png");
}

void keyPressed(){

	switch(key){
		case 'a':
			back_color=color(random(100,255),random(20,80)+100,random(20,85));
			for(PAnimal pa:pas){
				
			 	pa.land_vel=(int)random(2,10);
			 }
			break;
		case 's':
			save_frame=!save_frame;
			break;
		case 'd':
			break;
		case 'q':
			if(mpas_to_play<mpas){
				mpas_to_play++;
				// pas.get(mpas_to_play-1).x=0;
			}
			break;
		case 'w':
			mpas_to_play--;
			mpas_to_play=constrain(mpas_to_play, 0, mpas);
			break;
		case 'z':
			initAnimal();
			break;
	}
}


void drawPPLogo(PGraphics pg){

	pg.textFont(logo_font,48);
	pg.pushStyle();
	pg.fill(red(back_color)*.95,green(back_color)*.95,blue(back_color)*.95);
	pg.noStroke();
	int rate=20;
	if((frameCount+rate/2)%rate!=0) pg.text("P",width-60,height-48);
	if(frameCount%rate!=0) pg.text("P",width-32,height-48);


	pg.popStyle();
}

