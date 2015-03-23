

class DiscoLight{
	
	float x,y,rad;
	color light_color;
	float splash_time;

	float dest_x,dest_y,dest_rad;
	float orig_x,orig_y,orig_rad;
	// float update_t;
	float vel=random(30,90);
	float phi=random(TWO_PI);
	
	int update_stage;
	boolean finished=false;
	int dest_iani;

	int color_index;

	DiscoLight(int color_i){
		color_index=color_i;
		int iani=(int)random(mpas_to_play);
		PAnimal pa=pas.get(iani);
		orig_x=x=pa.x+pa.body_wid/2;
		orig_y=y=pa.y;
		orig_rad=rad=max(pa.wid,pa.hei);

		resetColor();
		splash_time=2+random(5);

	}
	DiscoLight(float x_,float y_,float rad_){
		x=x_; y=y_; rad=rad_;
		orig_x=x_; orig_y=y_; orig_rad=rad_;
		
		light_color=color(255,20,147);
		splash_time=2+random(5);

	}

	
	void draw(PGraphics pg,boolean draw_fill){
		pg.pushStyle();
		if(draw_fill){
			pg.noStroke();
			if(random(splash_time)<1) pg.fill(light_color);
		}
		pg.pushMatrix();
		pg.translate(x,y);
		pg.ellipse(0,0,rad,rad);
		pg.popMatrix();

		pg.popStyle();

		update();
	}

	void update(){
		
		float frame_portion=(float)frameCount/(vel)+phi;
		frame_portion%=TWO_PI;
		int new_stage=(int)((frame_portion)/(PI/2));

		PAnimal pa=pas.get(dest_iani);
		dest_x=pa.x+pa.body_wid/2; dest_y=pa.y; dest_rad=max(pa.wid,pa.hei);
		
				
		if(update_stage==3 && new_stage==0){
			setRandomPaDest();
			resetColor();
		}
		update_stage=new_stage;
		switch(update_stage){
			case 0:
				rad=orig_rad-orig_rad/2*sin(frame_portion);
				break;
			case 1:
				x=(dest_x-orig_x)*sin((frame_portion-PI/2))+orig_x;
				y=(dest_y-orig_y)*sin((frame_portion-PI/2))+orig_y;
				break;
			case 2:
				rad=orig_rad/2+(dest_rad-orig_rad)*sin(frame_portion-PI);
				break;
			case 3:
				x=dest_x; y=dest_y; rad=dest_rad*random(.8,2.5);
				resetColor();
				break;
		}
	}
	void setDest(float x_,float y_,float rad_){
		
		dest_x=x_; dest_y=y_; dest_rad=rad_;
		orig_x=x; orig_y=y; orig_rad=rad;

		finished=true;
	}
	boolean finisheUpdate(){
		return finished;
	}
	void setRandomPaDest(){
		int iani=(int)random(mpas_to_play);
		PAnimal pa=pas.get(iani);
		setDest(pa.x+pa.body_wid/2,pa.y,max(pa.wid,pa.hei));
		dest_iani=iani;

	}
	void resetColor(){
		switch(color_index){
			case 0:
				light_color=color(200+random(50),50+random(50),60+random(50),120);
				break;
			case 1:
				light_color=color(200+random(50),200+random(50),random(50),120);
				break;
			case 2:
				light_color=color(random(50),200+random(50),random(50),120);
				break;
				
		}
	}
}