
final int M_MODE=8;

int mpas=10;
ArrayList<PAnimal> pas;
ArrayList<PAnimalSlice> paslices;

float mid_pos;
float dest_pos;


PImage texture_img;
boolean save_frame=false;

PGraphics mtext_pg;


DistortGraphic fill_canvas,stroke_canvas;


int play_mode=0;

int mpas_to_play=0;
float angle_for_mode=0;



Robot robot;
Machine machine;
Machine2 machine2;
Machine2 machine3;


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
	paslices=new ArrayList<PAnimalSlice>();
	tmp_pos=0;
	for(int i=0;i<mpas;++i){
		
		if(i%5==0) tmp_pos=0;

		float tmp_h=random(0.6,1.2)*height/mpas;
		float tmp_w=width/5*random(.6,1.4);
		// paslices.add(new PAnimalSlice(tmp_pos,height/5*(floor(i/5)+1),tmp_w,tmp_h));
		paslices.add(new PAnimalSlice(0,height/5,tmp_w,tmp_h));
		tmp_pos+=tmp_w;

		if(tmp_h>width) return;
	}
	mpas=pas.size();

	mid_pos=0;

	fill_canvas=new DistortGraphic(25);
	fill_canvas.transform_mag=2;
	fill_canvas.transform_vel=28;
	stroke_canvas=new DistortGraphic(1);

	robot=new Robot(width/2,height/1.2,width/12,width/4);
	// machines=new Machine[20];
	// for(int i=0;i<20;++i)
	machine=new Machine(-width/4,0,width*1.5,height);
	machine2=new Machine2();
	
}

void draw(){
	
	background(0);	
	

	fill_canvas.beginDraw();
	stroke_canvas.beginDraw();
	
	fill_canvas.background(color(255,0));
	stroke_canvas.background(color(255,0));
	// drawMeatSpace(fill_canvas.pg,false);
	if(play_mode==0){
		background(255);
		drawMeatSpace(this.g,true);

	}
	// for(int i=0;i<mpas_to_play;++i){
	// 	PAnimal pa=pas.get(i);
	// 	pa.draw(stroke_canvas.pg,false);
	// 	pa.draw(fill_canvas.pg,true);
	// 	// image(pa.mtext.pg,pa.x,pa.y);
	// }
	// robot.draw(stroke_canvas.pg);
	// machine.update();
	machine.draw(fill_canvas.pg,true);
	machine.draw(stroke_canvas.pg,false);

	machine2.draw(stroke_canvas.pg,false);
	machine2.draw(fill_canvas.pg,true);


	for(int i=0;i<mpas_to_play;++i){
		PAnimalSlice pa=paslices.get(i);

		if(pa.draw_stage>1){
			machine2.update(pa.x%width+pa.wid/2,pa.y+pa.hei,pa.elastic_strength,pa.alien_vel/pa.land_vel,pa.phi);
		}
		pa.draw(stroke_canvas.pg,false,true);
		pa.draw(fill_canvas.pg,true,true);

		pa.draw(stroke_canvas.pg,false,false);
		pa.draw(fill_canvas.pg,true,false);
		// image(pa.mtext.pg,pa.x,pa.y);


	}


	
	stroke_canvas.endDraw();
	fill_canvas.endDraw();

	blendMode(LIGHTEST);
   	fill_canvas.draw();
   	//stroke_canvas.draw();

   	blendMode(NORMAL);
   	image(stroke_canvas.pg,-width*stroke_canvas.overlap,-width*stroke_canvas.overlap);


	
	switch(play_mode){
		
		case 0:
			// if(frameCount%100==0){
			// 	mid_pos=0;
			// 	for(int i=0;i<mpas_to_play;++i){
			// 		PAnimal pa=pas.get(i);
			// 		mid_pos+=(pa.x+pa.wid);
			// 	}
			// 	mid_pos/=pas.size();
			// 	mid_pos*=.8;
			// // println(mid_pos);
			// }else{
			// 	for(int i=0;i<mpas_to_play;++i){
			// 		PAnimal pa=pas.get(i);
			// 		pa.x-=(play_mode==1)?mid_pos/80:mid_pos/100;
			// 	}
			// }
			break;


	}
	

	frame.setTitle(String.valueOf(frameRate));
	if(save_frame) saveFrame("pee-2-####.png");
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
			for(PAnimal pa:pas){
			 	pa.transport_mode=play_mode;
			 	pa.land_vel=(int)random(2,10);
			 	// pa.start_frame=frameCount;
			 		
			}
			
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
		case 'e':
			machine=new Machine(-width/4,0,width*1.5,height);
			break;
	}
}


