
final int M_MODE=8;

int mpas=10;
ArrayList<PAnimal> pas;

float mid_pos;
float dest_pos;


PImage texture_img;
boolean save_frame=false;

ArrayList<MeatTexture> mtexts;
PGraphics mtext_pg;


DistortGraphic fill_canvas,stroke_canvas;

SkateBoard sktb;
int play_mode=0;

int mpas_to_play=0;
float angle_for_mode=0;

ArrayList<SpotLight> sps;



void setup(){
	
	size(800,800,P3D);
	
 	//mtext_pg=createGraphics(width,height);
	
	pas=new ArrayList<PAnimal>();
	float tmp_pos=0;
	for(int i=0;i<mpas;++i){
		float tmp_h=random(0.6,1.2)*height/mpas;
		pas.add(new PAnimal(0,tmp_pos+tmp_h,width/5*random(.6,1.4),tmp_h));
		tmp_pos+=tmp_h;
		if(tmp_h>height) return;
	}
	mpas=pas.size();

	mid_pos=0;

	fill_canvas=new DistortGraphic(25);
	fill_canvas.transform_mag=2;
	fill_canvas.transform_vel=28;
	stroke_canvas=new DistortGraphic(1);

	// texture_img=loadImage("Oil_Paint_01.jpg");

	// mtext_pg=createGraphics(width,height);
	// mtexts=new ArrayList<MeatTexture>();
	// for(int i=0;i<mpas;++i){
	// 	PAnimal pa=pas.get(i);
	// 	mtexts.add(new MeatTexture(0,pa.y,width,pa.hei,mtext_pg));
	// }
	// updateMText();

	sps=new ArrayList<SpotLight>();
	for(int i=0;i<3;++i)
		sps.add(new SpotLight(i));

}

void draw(){
	
	background(0);	
	

	fill_canvas.beginDraw();
	stroke_canvas.beginDraw();
	
	if(play_mode==7){
		stroke_canvas.background(color(255,0));
		fill_canvas.fill(color(0,20));
	}else{
		fill_canvas.background(color(255,0));
		stroke_canvas.background(color(255,0));
	}
	if(play_mode==8) fill_canvas.transform_vel=32;
	else fill_canvas.transform_vel=28;

	if(play_mode==0){
		background(255);
	}else if(play_mode==1){
		background(255);
		fill_canvas.pg.translate(width/2,height/2);
		fill_canvas.pg.rotate(PI/4);
		fill_canvas.pg.translate(-width/2,-height/2);
		
		stroke_canvas.pg.translate(width/2,height/2);
		stroke_canvas.pg.rotate(PI/4);
		stroke_canvas.pg.translate(-width/2,-height/2);
	}else if(play_mode==2){

		background(0,0,255);	

		fill_canvas.pg.translate(width/2,height*.5);
		fill_canvas.pg.rotate(angle_for_mode);
		fill_canvas.pg.translate(-width/2,-height*.5);
		
		stroke_canvas.pg.translate(width/2,height*.5);
		stroke_canvas.pg.rotate(angle_for_mode);
		stroke_canvas.pg.translate(-width/2,-height*.5);

	}else if(play_mode==3||play_mode==4){
		background(20);
	}else if(play_mode==6){
		background(0);
		drawMoon(stroke_canvas.pg,false);
		drawMoon(fill_canvas.pg,true);	
	}else if(play_mode==7){
		background(0,0,3);
		drawSpace(this.g,true);
	}
	for(int i=0;i<mpas_to_play;++i){
		PAnimal pa=pas.get(i);
		pa.draw(stroke_canvas.pg,false);
		pa.draw(fill_canvas.pg,true);
		// image(pa.mtext.pg,pa.x,pa.y);
	}

	if(play_mode==7){
		
		for(SpotLight sp:sps)
			sp.drawCone(fill_canvas.pg,true);
		// translate(width/2,height/2);
		// rotate(-PI/4);
		// translate(-width/2,-height/2);
	}
	stroke_canvas.endDraw();
	fill_canvas.endDraw();
	if(play_mode>2) blendMode(ADD);
   	fill_canvas.draw();
   	//stroke_canvas.draw();
   	blendMode(NORMAL);
   	image(stroke_canvas.pg,-width/20,0);


	
	switch(play_mode){
		case 1:
		case 2:
			float cur_min_pos=Integer.MAX_VALUE;
			for(int i=0;i<mpas_to_play;++i){
				PAnimal pa=pas.get(i); 
				cur_min_pos=min(pa.x,cur_min_pos);
			}
			cur_min_pos/=pas.size();
			//println(cur_min_pos);
			if(cur_min_pos>width/7){
				for(int i=0;i<mpas_to_play;++i){
					PAnimal pa=pas.get(i); 
					pa.x=-random(width/2);
				 	pa.land_vel=(int)random(2,10);
				 }
				 angle_for_mode=-PI/8;
			}
			break;
		case 0:
			if(frameCount%100==0){
				mid_pos=0;
				for(int i=0;i<mpas_to_play;++i){
					PAnimal pa=pas.get(i);
					mid_pos+=(pa.x+pa.wid);
				}
				mid_pos/=pas.size();
				mid_pos*=.8;
			// println(mid_pos);
			}else{
				for(int i=0;i<mpas_to_play;++i){
					PAnimal pa=pas.get(i);
					pa.x-=(play_mode==1)?mid_pos/80:mid_pos/100;
				}
			}
			break;


	}
	if(play_mode==2){
		//angle_for_mode+=.02;
		//angle_for_mode=constrain(angle_for_mode,-PI/4,PI/4);
	}

	//tint(255,120);
	//blend(texture_img,(int)(mid_pos%texture_img.width),0,width,height,0,0,width,height,BURN);
	//updateMText();

	// image(mtext_pg,0,0,width,height);
	// if(mousePressed) updateMText();

	frame.setTitle(String.valueOf(frameRate));
	if(save_frame) saveFrame("pee-####.png");
}

void keyPressed(){

	switch(key){
		case 'a':
			for(PAnimal pa:pas) pa.x=0;
			break;
		case 's':
			save_frame=!save_frame;
			break;
		case 'd':
			
			fill_canvas.reset();

			play_mode=(play_mode+1)%M_MODE;
			float tmpx=0;
			float tmpy=0;
			moon_edge_y=height;
			for(PAnimal pa:pas){
			 	pa.transport_mode=play_mode;
			 	if(play_mode==3){
			 		pa.x=tmpx;
			 		pa.y=constrain(random(height/2,height),pa.sship.y,height-pa.hei*2);
			 		tmpx+=(float)width/mpas*random(0.6,1.5);
			 		if(tmpx>width) tmpx-=(float)width/mpas*random(1,3);
			 		
			 		pa.sship.x=pa.x;
					pa.sship.ray_bottom_y=pa.y+pa.body_hei;//+jump_pos_y;
					pa.sship.ray_animal_y=pa.y;
					pa.sship.start_frame=frameCount;

			 	}else if(play_mode<3){
			 		 float tmp_h=random(0.6,1.2)*height/mpas;
				 	 pa.x=0;
				 	 pa.y=tmpy+tmp_h;
				 	 tmpy+=tmp_h;
			 	}else if(play_mode==6){
			 		pa.volcano.x=pa.x+pa.body_wid/2;
			 		// pa.volcano.y=pa.y+pa.body_hei*3;
			 		pa.y=pa.volcano.y-pa.hei-pa.leg_hei;
			 		moon_edge_y=min(moon_edge_y,pa.volcano.y);
			 	}else if(play_mode==7){
			 		float tmp_h=random(0.6,1.2)*height/mpas;
			 		pa.x=random(pa.wid,width-pa.wid);
				 	pa.y=tmpy+tmp_h;
				 	pa.disco_stage=-2;
				 	tmpy+=tmp_h;
			 	}
			 	pa.land_vel=(int)random(2,10);
			 		
			}
			// if(play_mode==7){
			// 	for(SpotLight sp:sps) sp.setRandomPaSource();
			// }
			moon_edge_y*=.8;
			mid_pos=0;
			for(PAnimal pa:pas) mid_pos+=(pa.x+pa.wid);
			mid_pos/=pas.size();
			mid_pos*=.8;
			angle_for_mode=-PI/4;
			break;
		case 'q':
			if(mpas_to_play<mpas){
				mpas_to_play++;
				pas.get(mpas_to_play-1).x=0;
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


void updateMText(){
	// for(int i=0;i<mpas;++i){
	// 	PAnimal pa=pas.get(i);
	// 	MeatTexture mt=mtexts.get(i);
	// 	mt.x=pa.x; mt.y=pa.y; 
	// 	mt.wid=pa.wid; mt.hei=pa.hei; 	
	// }
	mtext_pg.beginDraw();
	mtext_pg.background(255,0);	
		for(MeatTexture mt:mtexts) mt.draw();
	mtext_pg.endDraw();
}

