class SpaceShip{
	
	float x,y,wid,hei;		
	float phi;
	int mwindow;
	FloatList window_portion;
	int mray;
	FloatList ray_portion;
	float vel;
	
	float ray_bottom_y; 
	float play_mode;
	
	float rot_vel;
	float ray_wid;
	float ray_animal_y;
	float ray_cur_y;

	float ship_delta_x=0;
	float ship_far_pos;

	int stage=0;
	int start_frame;
	float portion=0;

	SpaceShip(float x_,float y_,float wid_,float hei_,float phi_,float vel_,int mode_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		phi=phi_;
		vel=vel_;
		mwindow=(int)random(3,8);	
		window_portion=new FloatList();
		for(int i=0;i<mwindow;++i){
			window_portion.append(random(.2,1));
		}
		mray=(int)random(4,12);
		ray_portion=new FloatList();
		// for(int i=0;i<mray;++i) ray_portion.append(random(.1,1));

		play_mode=mode_;

		rot_vel=random(10,50);
		ray_wid=random(PI/50,PI/8);
		ship_far_pos=width*((random(2)>1)?1:-1)*random(-2,2);
		
		start_frame=frameCount;

	}
	

	void draw(PGraphics pg,boolean draw_fill){
		

		portion=((float)(frameCount-start_frame)/vel+phi)%TWO_PI;
		float draw_portion=1;//abs(cos(portion));
	

		pg.pushStyle();
		if(draw_fill){
			pg.fill(20,phi*125*random(.8,1.2),phi/TWO_PI*20+180,255);
			pg.noStroke();
		}else{
			// pg.fill(255,255);
			pg.noFill();
			pg.stroke(255,200);
			// pg.strokeWeight(1);
		}

		pg.pushMatrix();
		pg.translate(x+ship_delta_x,y+hei/2);		
		pg.scale(TOTAL_SCALE);

		pg.pushMatrix();
		pg.translate(0,0);
			pg.beginShape();

				pg.vertex(0,0);
				pg.bezierVertex(wid/8,-hei/8*draw_portion,
							wid/8,-hei/8*draw_portion,
							wid/4,-hei/12);
				pg.bezierVertex(wid/4,-hei/3-hei/6*draw_portion,
							wid/4*3+wid/8,-hei/4-hei/6*draw_portion,
							wid/4*3,-hei/12);
				pg.bezierVertex(wid/8*7,-hei/8*draw_portion,
							wid/8*7,-hei/8*draw_portion,
							wid,-hei/12);
				pg.bezierVertex(wid/8*7,hei/5+hei/7*draw_portion,
							 wid/2*sin(phi),hei/4+hei/7*draw_portion,
							 0,0);

			pg.endShape();
			pg.beginShape();

				pg.vertex(0,0);
				pg.bezierVertex(wid/8,hei/8*draw_portion,
							wid/8,hei/8*draw_portion,
							wid/4,hei/12);
				pg.bezierVertex(wid/4,hei/3+hei/16*draw_portion,
							wid/4*3+wid/8,hei/4+hei/6*draw_portion,
							wid/4*3,hei/12);
				pg.bezierVertex(wid/12*7,hei/8*draw_portion,
							wid/12*11,hei/11*draw_portion,
							wid,0);

			pg.endShape();
		

		
		pg.popStyle();

		pg.pushStyle();
			if(draw_fill){
				pg.fill(255);
				pg.noStroke();
			}else{
				pg.noFill();
				pg.stroke(0,200);
			}


			pg.pushMatrix();
			pg.translate(wid/3.5*draw_portion/5+wid/4,0);
				float wwindow=wid/2/(float)mwindow*.65;

				
				// window
				pg.beginShape(QUADS);
				for(int i=0;i<mwindow;++i){
						float port=window_portion.get(i);
						pg.vertex(wwindow*i,0);
						pg.vertex(wwindow*(i+port),0);
						pg.vertex(wwindow*(i+sin(port)),-hei/12);
						pg.vertex(wwindow*i*cos(port),-hei/12);				
				}
				pg.endShape();

			pg.popMatrix();

		pg.popStyle();

		pg.popMatrix();

		pg.popMatrix();

		pg.pushStyle();
		

	}


	
}