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

	float ship_delta_x;
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
	

	boolean draw(PGraphics pg,boolean draw_fill){
		

		boolean finished=false;
		boolean draw_ray=(play_mode==4);

		portion=((float)(frameCount-start_frame)/vel+phi)%TWO_PI;
		float draw_portion=abs(cos(portion));
		
		int new_stage=(int)(portion/PI*2);
		if(new_stage==0&&stage==3){
			finished=true;
			stage=new_stage;
			return finished;
		}
		stage=new_stage;
		
		if(draw_ray){
			if(stage==3|| stage==0) ship_delta_x=ship_far_pos*cos(portion);
			else ship_delta_x=0;
		}else{
			if(stage==3 || stage==0) ship_delta_x=cos(portion)*ship_far_pos;
			else ship_delta_x=(wid)*cos(portion)*(ship_far_pos/abs(ship_far_pos));
		}
		


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

		pg.pushStyle();
		
			//light
			
			if(draw_fill){
				pg.noFill();
				pg.stroke(255,40);
			}else{
				pg.noFill();
				pg.stroke(255,200);
			}
			// float cur_phi=(draw_ray)?0:PI/8*sin((float)frameCount/25+phi);
		float cur_phi=(draw_ray)?0:getCurrentRayPhi();
		PVector rayv=new PVector(0,ray_bottom_y);
		rayv.rotate(-cur_phi);

		PVector rayv_b=new PVector(0,ray_bottom_y);
		rayv_b.rotate(-cur_phi-ray_wid);
		
		
		if(!draw_ray&&draw_fill){
			pg.beginShape();
				
				for(int i=0;i<mray;++i){
					float rad=random(ray_bottom_y);
					float theta=random(0,ray_wid)+cur_phi;
					pg.vertex(wid/2+rad*sin(theta),rad*cos(theta));
				}
			pg.endShape();
		}


		pg.popStyle();

		
		pg.popMatrix();
		if(draw_ray){
			drawCatchRay(x+wid/2+ship_delta_x,y+hei/2,ray_bottom_y,ray_animal_y,wid,pg,draw_fill);
		}
		
		return finished;

	}


	float getCurrentRayPhi(){

		float rot_portion=(float)frameCount/(rot_vel)+phi;
		rot_portion%=TWO_PI;
		int rot_stage=(int)((rot_portion)/(PI/4));
		float ang=0;
		switch(rot_stage){
			case 0:
			case 1:
			case 2:
				rot_portion-=PI/4*rot_stage;
				ang=ray_wid*(sin((rot_portion)*4));
				break;
			case 3:
				rot_portion-=PI/4*3;
				ang=PI*sin((rot_portion)*2);
				break;
			case 4:
			case 5:
			case 6:
				rot_portion-=PI/4*rot_stage;
				ang=PI+ray_wid*(sin((rot_portion)*4));
				break;
			case 7:
				rot_portion-=PI/8*7;
				ang=PI+PI*sin((rot_portion)*2);
				break;
		}
		//println(ang/PI);
		return ang-ray_wid/2;

	}

	void drawCatchRay(float top_x,float top_y,float bottom_y,float animal_y,float animal_w,PGraphics pg,boolean draw_fill){
		
		pg.pushStyle();
		if(draw_fill){
			pg.stroke(0,255,255);
			pg.noFill();
		}else{
			pg.stroke(255,255,0);
			pg.noFill();
		}

		pg.pushMatrix();
		pg.translate(top_x,0);
		pg.scale(TOTAL_SCALE,1);
			// float portion=((float)frameCount/vel+phi)%TWO_PI;
			// int stage=(int)(portion/PI*2);

			ray_cur_y=bottom_y;
			float tmp_wid=animal_w;
			float close_wid=0;

			switch(stage){
				case 0: // down
					ray_cur_y=(bottom_y-top_y)*abs(sin(portion))+top_y;
					tmp_wid=map(ray_cur_y-top_y,0,bottom_y-top_y,0,animal_w);
 					pg.beginShape();
						pg.vertex(tmp_wid/2,ray_cur_y);
						if(ray_cur_y>animal_y) pg.vertex(tmp_wid/2,animal_y);
						
						pg.vertex(0,top_y);
						
						if(ray_cur_y>animal_y) pg.vertex(-tmp_wid/2,animal_y);
						pg.vertex(-tmp_wid/2,ray_cur_y);		
					pg.endShape();
					break;
 				case 1: // close
 					close_wid=map(portion,PI/2,PI,tmp_wid/2,0);
 					pg.beginShape();
 						pg.vertex(close_wid,bottom_y);
						pg.vertex(tmp_wid/2,bottom_y);
						pg.vertex(tmp_wid/2,animal_y);
						
						pg.vertex(0,top_y);
						
						pg.vertex(-tmp_wid/2,animal_y);
						pg.vertex(-tmp_wid/2,bottom_y);		
						pg.vertex(-close_wid,bottom_y);
					pg.endShape();
					break;
				case 2: // up
					ray_cur_y=(bottom_y-top_y-(bottom_y-animal_y)*2)*abs(cos(portion))+top_y+(bottom_y-animal_y)*2;
					pg.beginShape();
 						pg.vertex(close_wid,ray_cur_y);
						pg.vertex(tmp_wid/2,ray_cur_y);
						pg.vertex(tmp_wid/2,ray_cur_y-(bottom_y-animal_y));
						
						pg.vertex(0,top_y);
						
						pg.vertex(-tmp_wid/2,ray_cur_y-(bottom_y-animal_y));
						pg.vertex(-tmp_wid/2,ray_cur_y);		
						pg.vertex(-close_wid,ray_cur_y);
					pg.endShape();
					break;
 				case 3: // stay up
 					ray_cur_y=top_y+(bottom_y-animal_y)*1.5;
					pg.beginShape();
 						pg.vertex(close_wid,ray_cur_y);
						pg.vertex(tmp_wid/2,ray_cur_y);
						pg.vertex(tmp_wid/2,ray_cur_y-(bottom_y-animal_y));
						
						pg.vertex(0,top_y);
						
						pg.vertex(-tmp_wid/2,ray_cur_y-(bottom_y-animal_y));
						pg.vertex(-tmp_wid/2,ray_cur_y);		
						pg.vertex(-close_wid,ray_cur_y);
					pg.endShape();
					break;

			}
			
		pg.popMatrix();

		pg.popStyle();
	}

}