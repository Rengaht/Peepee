
final int M_MODE=8;

int mpas=10;
ArrayList<PAnimal> pas;

float mid_pos;
float dest_pos;


PImage texture_img;
boolean save_frame=false;


DistortGraphic fill_canvas,stroke_canvas;
color back_color=color(172,199,204);

int play_mode=0;

int mpas_to_play=0;
float angle_for_mode=0;


void setup(){
	
	size(800,800,P3D);
	
 	//mtext_pg=createGraphics(width,height);
	
	pas=new ArrayList<PAnimal>();
	float tmp_pos=0;
	for(int i=0;i<mpas;++i){
		float tmp_h=random(0.6,1.2)*height/mpas;
		pas.add(new PAnimal(random(50,width-50),tmp_pos+tmp_h,width/5*random(.6,1.4),tmp_h));
		tmp_pos+=tmp_h;
		if(tmp_h>height) return;
	}
	mpas=pas.size();

	mid_pos=0;

	fill_canvas=new DistortGraphic(25);
	fill_canvas.transform_mag=2;
	fill_canvas.transform_vel=28;
	stroke_canvas=new DistortGraphic(1);

	initCloud();


}

void draw(){
	
	background(back_color);	
	

	fill_canvas.beginDraw();
	stroke_canvas.beginDraw();
	
	fill_canvas.background(color(255,0));
	stroke_canvas.background(color(255,0));

	// background(255);
	
	drawSkyBackground(fill_canvas.pg,true);
	drawSkyBackground(stroke_canvas.pg,false);
	updateSky();

	for(int i=0;i<mpas_to_play;++i){
		PAnimal pa=pas.get(i);
		pa.draw(stroke_canvas.pg,false);
		pa.draw(fill_canvas.pg,true);
		// image(pa.mtext.pg,pa.x,pa.y);
	}

	
	stroke_canvas.endDraw();
	fill_canvas.endDraw();
	// if(play_mode>2) blendMode(ADD);
   	fill_canvas.draw();
   	//stroke_canvas.draw();
   	// blendMode(NORMAL);
   	image(stroke_canvas.pg,-width/20,0);


	
	

	frame.setTitle(String.valueOf(frameRate));
	if(save_frame) saveFrame("pee-####.png");
}

void keyPressed(){

	switch(key){
		case 'a':
			for(PAnimal pa:pas){
			 	pa.x=random(20,width-20);
			 	pa.land_vel=(int)random(2,10);
			 }
			break;
		case 's':
			save_frame=!save_frame;
			break;
		case 'd':
			
			fill_canvas.reset();

			play_mode=(play_mode+1)%M_MODE;
			float tmpx=0;
			float tmpy=0;
			// moon_edge_y=height;
			for(PAnimal pa:pas){
			 	pa.transport_mode=play_mode;
			 	
			 	pa.land_vel=(int)random(2,10);
			 		
			}
			// if(play_mode==7){
			// 	for(SpotLight sp:sps) sp.setRandomPaSource();
			// }
			// moon_edge_y*=.8;
			// mid_pos=0;
			// for(PAnimal pa:pas) mid_pos+=(pa.x+pa.wid);
			// mid_pos/=pas.size();
			// mid_pos*=.8;
			// angle_for_mode=-PI/4;
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
			pas.clear();
			float tmp_pos=0;
			for(int i=0;i<mpas;++i){
				float tmp_h=random(0.6,1.2)*height/mpas;
				pas.add(new PAnimal(0,tmp_pos+tmp_h,width/5*random(.6,1.4),tmp_h));
				tmp_pos+=tmp_h;
				if(tmp_h>height) return;
			}
			for(PAnimal pa:pas) pa.transport_mode=play_mode;
			mpas=pas.size();
			break;
	}
}

