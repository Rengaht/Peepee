final float LAND_DISTORT=.6;
final int MAX_GENERATION=5;

class PAnimal{
	
	float x,y,wid,hei;
	float head_wid,head_hei;
	float body_wid,body_hei;
	
	float leg_wid,leg_hei;
	int mleg;
	FloatList leg_span;

	float tail_wid,tail_hei;
	color fcolor;
	
	float phi,run_phi;
	float elastic_strength;
	int alien_stage=0;

	FloatList land_poses;
	int land_length;
	float land_vel;
	int land_index;


	int transport_mode=0;
	float run_vel=50;
	float alien_vel=random(120,250);

	
	float s_body_hei_incre=0;

	PVector first_foot_base;
	PVector last_foot_base;

	float stop_draw_portion;
	float stop_run_portion;

	PAnimal child_animal;
	int generation=0;
	int start_frame;

	PAnimal(float x_,float y_,float wid_,float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		

		float hhead_portion=random(.3,.5);
		head_wid=hhead_portion*wid;
		body_wid=wid-head_wid;
		
		body_hei=(hei)*random(.3,.5);
		float vhead_portion=random(.4,.8);
		head_hei=vhead_portion*body_hei;
		
		leg_hei=hei-body_hei;

		mleg=(int)random(3,6);
		leg_wid=body_wid/mleg*random(.2,.4);
		leg_span=new FloatList();
		//leg_span.append(0);
		for(int i=0;i<mleg;++i){
			leg_span.append(random(0.05,0.5));
		}


		fcolor=color(random(100,255),random(20,80)+100,random(20,85));

		phi=random(HALF_PI);
		run_phi=random(HALF_PI);
				


		land_poses=new FloatList();
		land_length=(int)(random(.5,1.2)*width);
		for(int i=0;i<land_length;++i){
			if(random(20)<1) land_poses.append(random(-LAND_DISTORT,0)*30);
			else land_poses.append(random(-LAND_DISTORT,LAND_DISTORT));
		} 
		land_vel=(int)random(3,10);
		land_index=0;

		elastic_strength=(float)land_vel/10*random(1,3);
		start_frame=frameCount;
		// child_animal=new PAnimal(this);
		
	}	
	PAnimal(PAnimal copy_pa){

		float shrink=random(.7,.96);
		x=copy_pa.x; y=copy_pa.y; wid=copy_pa.wid*shrink; hei=copy_pa.hei*shrink;
		
		head_wid=copy_pa.head_wid*shrink;
		body_wid=copy_pa.body_wid*shrink;
		
		body_hei=copy_pa.body_hei*shrink;
		head_hei=copy_pa.head_hei*shrink;
		
		leg_hei=hei-body_hei;

		mleg=copy_pa.mleg;
		leg_wid=copy_pa.leg_wid*shrink;
		leg_span=new FloatList();
		//leg_span.append(0);
		for(int i=0;i<mleg;++i){
			leg_span.append(copy_pa.leg_span.get(i));
		}

		color pcolor=copy_pa.fcolor;
		fcolor=color(red(pcolor)/shrink,green(pcolor)/shrink,blue(pcolor));

		phi=random(HALF_PI);
		run_phi=copy_pa.stop_run_portion%TWO_PI;


		// land_poses=new FloatList();
		// land_length=(int)(random(.5,1.2)*width);
		// for(int i=0;i<land_length;++i){
		// 	if(random(20)<1) land_poses.append(random(-LAND_DISTORT,0)*30);
		// 	else land_poses.append(random(-LAND_DISTORT,LAND_DISTORT));
		// } 
		land_vel=(int)random(3,10);
		land_index=0;

		// elastic_strength=(float)land_vel/10*random(1,3);

		generation=copy_pa.generation+1;
		println("create child at generation "+generation);

		start_frame=frameCount;
	}
	void draw(PGraphics pg,boolean draw_fill){
		
		
		
		
		float draw_portion=1.5*abs(sin((float)frameCount/(120/land_vel)));

		float run_portion=(float)(frameCount-start_frame)/(run_vel/land_vel)+run_phi;
					

		float frame_portion=(float)(frameCount-start_frame)/(alien_vel/land_vel)+phi;
		frame_portion%=(TWO_PI*2);
		int new_alien_stage=(int)((frame_portion)/(PI/2));
		

		float cur_body_wid=body_wid;
		if(generation!=MAX_GENERATION){
			switch(alien_stage){
				case 2:
					if(new_alien_stage==3){
					 	stop_run_portion=run_portion;
					 	if(generation<MAX_GENERATION){
					 		if(child_animal==null) child_animal=new PAnimal(this);
					 	}
					}
					break;
				case 3:
					if(new_alien_stage==4){
						stop_draw_portion=draw_portion;
						// alien_stage=4;
					}
					run_portion=stop_run_portion;
					break;				
				case 4:
				case 5:
				case 6:
				case 7:
					draw_portion=stop_draw_portion;
					run_portion=stop_run_portion;
					break;

			}
		}
		if(alien_stage<7) alien_stage=new_alien_stage;
		// println(alien_stage+"  "+new_alien_stage);
		
		if(alien_stage>=3){
			if(child_animal!=null) child_animal.draw(pg,draw_fill);	
			else if(generation<MAX_GENERATION) child_animal=new PAnimal(this);
		} 

		pg.pushStyle();
		
		if(draw_fill){
		 	pg.noStroke();
		 	pg.fill(255,0);
		 	// pg.noFill();
		 	// if(alien_stage<6) pg.fill(fcolor);
		 	// else if(alien_stage==6) pg.fill(fcolor,abs(255*sin(frame_portion)));
		}else{
		 	pg.noFill();
		 	// if(alien_stage<6){
		 	 // pg.fill(fcolor);
		 	 pg.stroke(0);
		 	// }else if(alien_stage==6){
		 	// 	pg.fill(fcolor,255*abs(cos(frame_portion)));
		 	// 	pg.stroke(0,255*abs(cos(frame_portion)));
		 	// }else{
		 	// 	pg.noStroke();
		 	// 	pg.noFill();
		 	// }
		}

		pg.pushMatrix();

		if(transport_mode==0){
			pg.translate(x,y);
			
		}

		pg.beginShape();
		pg.vertex(0,0+s_body_hei_incre);
		pg.bezierVertex(cur_body_wid/3,-body_hei*.3*draw_portion+s_body_hei_incre,
						 cur_body_wid/3*2,-body_hei*.3*draw_portion+s_body_hei_incre,
						 cur_body_wid,0);

		if(alien_stage<3 || generation==MAX_GENERATION){
			PVector ear_base1=new PVector(head_hei,0);
			ear_base1.rotate((-PI/3)*draw_portion-PI/6-PI/4);
			PVector ear_base2=new PVector(head_hei,0);
			ear_base2.rotate(-PI/3*draw_portion-PI/4);
			
			pg.bezierVertex(cur_body_wid+ear_base1.x,ear_base1.y,
						  cur_body_wid+ear_base2.x,ear_base2.y,
						  cur_body_wid,0);

			pg.bezierVertex(cur_body_wid+head_wid/2,-body_hei*.1*draw_portion,
						 cur_body_wid+head_wid,head_hei+body_hei*.4*draw_portion,
						 cur_body_wid,head_hei);
			
		}
		pg.vertex(cur_body_wid*(1-(float)(0+leg_span.get(0))/mleg),body_hei);

		for(int i=0;i<mleg;++i){
			if(i>0) pg.vertex(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei);

			if(transport_mode==0){
				if(generation!=MAX_GENERATION && generation!=0 && alien_stage==0) continue;
				drawRunLeg(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei,leg_wid,leg_hei,i,pg,run_portion);
				
			} 
			
					
		}
		
		pg.bezierVertex(-cur_body_wid*.1*draw_portion,body_hei,
					 -cur_body_wid*.1*draw_portion,0,
					 0,0+s_body_hei_incre);


		pg.endShape();
		
		if(alien_stage>=3 && generation!=MAX_GENERATION){
			pg.pushMatrix();
			pg.translate(cur_body_wid,0);
			if(alien_stage==3) pg.rotate(-PI/1.2*cos(frame_portion));
			else pg.rotate(-PI/1.2);
			pg.translate(-cur_body_wid,0);

			pg.beginShape();
			pg.vertex(cur_body_wid,0);

			PVector ear_base1=new PVector(head_hei,0);
			ear_base1.rotate((-PI/3)*draw_portion-PI/6-PI/4);
			PVector ear_base2=new PVector(head_hei,0);
			ear_base2.rotate(-PI/3*draw_portion-PI/4);
			
			pg.bezierVertex(cur_body_wid+ear_base1.x,ear_base1.y,
						  cur_body_wid+ear_base2.x,ear_base2.y,
						  cur_body_wid,0);

			pg.bezierVertex(cur_body_wid+head_wid/2,-body_hei*.1*draw_portion,
						 cur_body_wid+head_wid,head_hei+body_hei*.4*draw_portion,
						 cur_body_wid,head_hei);
			pg.endShape(CLOSE);
			pg.popMatrix();
		}
		


		if(draw_fill){
			pg.stroke(red(fcolor)/1.1,green(fcolor)/1.1,blue(fcolor)/1.3);
			pg.beginShape();
			for(int i=0;i<80;++i){
					// pg.strokeWeight(random(2));
					pg.vertex(random(cur_body_wid),
							   random(-body_hei*.1,body_hei/2));
			
			}
			pg.endShape();
		}



		pg.popMatrix();
		

		pg.popStyle();

		
	
		update();
	}

	void update(){
		switch(transport_mode){
			case 0:
				// if(random(500)<1){
				//  land_vel+=(int)random(-2,2);
				//  elastic_strength=(float)land_vel/10*random(1,3);
				// }
				// land_vel=constrain(land_vel, 5, 20);
				if(generation!=MAX_GENERATION && alien_stage>0 && alien_stage<3) x+=land_vel/10;
				else if(generation==MAX_GENERATION && x<width*1.5) x+=land_vel/10;
				else if(generation==0  && alien_stage==0)  x+=land_vel/10;
				break;

		}
		
	}
	void drawRunLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg,float frame_portion){


		
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		
		float kang=-PI/2.5*(sin(frame_portion));
		if(leg_index%2==1) kang=-PI/2.5*(sin(frame_portion+PI/2));
		float fang=0;//+PI/1.8;
		
		switch(stage){
			case 0:
				fang=kang+PI/1.6;//*(sin(frame_portion));
				break;
			case 1:
				fang=kang+PI/1.6*((sin(frame_portion)));
				break;
				//println(stage+"  "+((sin(frame_portion))));
			case 2:
				//kang=PI/3;//*(sin(frame_portion));
				fang=kang;//PI/1.6*(sin(frame_portion));
				//ang=kang+PI/1.6;//*abs(sin(frame_portion%TWO_PI*2));
				break;
			
			case 3:
				float ang=frame_portion%TWO_PI-PI/2*3;
				//kang=PI/3*(sin(ang*2+PI/2*3));
				fang=kang+PI/1.6*(1-abs(sin(frame_portion)));
				break;
				
		}
		drawLegs(kang,fang,lx,ly,lw,lh,leg_index,pg);
		
	}	
	void drawLegs(float kang,float fang,float lx,float ly,float lw,float lh,int leg_index,PGraphics pg){	
		PVector knee_base=new PVector(0,lh/2);
		knee_base.rotate(kang);

		PVector foot_base=new PVector(0,lh/2);
		foot_base.rotate(fang);
		

		PVector foot_base2=new PVector(-lw,lh/2);
		foot_base2.rotate(fang);
		
		

		foot_base.add(knee_base);
		foot_base2.add(knee_base);
		
		pg.bezierVertex(lx+knee_base.x,ly+knee_base.y,
					 lx+foot_base.x,ly+foot_base.y,
					 lx+foot_base.x,ly+foot_base.y);
		// vertex(lx+knee_base.x,ly+knee_base.y);
		// vertex(lx+foot_base.x,ly+foot_base.y);
		
		pg.vertex(lx+foot_base2.x,ly+foot_base2.y);

		// vertex(lx-lw+knee_base.x,ly+knee_base.y);
		// vertex(lx-lw,ly);

		pg.bezierVertex(lx-lw+knee_base.x,ly+knee_base.y,
					 lx-lw+knee_base.x,ly+knee_base.y,
					 lx-lw,ly);

		switch(transport_mode){
			case 1:
				if(leg_index==0) first_foot_base=new PVector(lx-lw+foot_base.x,ly+foot_base.y);
				else if(leg_index==mleg-1) last_foot_base=new PVector(lx+lw+foot_base.x,ly+foot_base.y);
				break;
			case 2:
				if(leg_index==0) first_foot_base=new PVector(lx-lw+foot_base.x,ly+lh);
				else if(leg_index==mleg-1) last_foot_base=new PVector(lx+lw+foot_base.x,ly+lh);
				break;
			case 7:
				if(leg_index==0) first_foot_base=new PVector(lx-lw+foot_base.x,lx-lw+lh*sin(PI/6));
				else if(leg_index==mleg-1) last_foot_base=new PVector(lx+lw+foot_base.x,lx+lw-lh*sin(PI/6),lx+lw+lh*sin(PI/6));
				break;
		}
	}
	void drawLand(PGraphics pg){
		pg.pushStyle();
		//noFill();
		pg.stroke(0,120);
		pg.translate(-wid,hei);
		

		pg.beginShape();
		int len=land_poses.size();
		for(int i=0;i<len;++i) pg.vertex(i,land_poses.get((i+land_index)%len));
		for(int i=len;i>=0;--i){
		 if(i<0 || i>=land_poses.size()) continue;
		 pg.vertex(i,land_poses.get((i+land_index)%len)+random(-LAND_DISTORT,LAND_DISTORT));
		}
		pg.endShape();
		
		pg.popStyle();
		
		land_index+=land_vel;

		// for(int i=0;i<land_vel;++i) land_poses.remove(0);
		// for(int i=0;i<land_vel;++i){
			
		// 	if(random(20)<1) land_poses.append(random(-LAND_DISTORT,0)*30);
		// 	else land_poses.append(random(-LAND_DISTORT,LAND_DISTORT));
		// }


	}
}


