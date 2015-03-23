 final float LAND_DISTORT=.6;

class PAnimal{
	
	float x,y,wid,hei;
	float head_wid,head_hei;
	float body_wid,body_hei;
	
	float leg_wid,leg_hei;
	int mleg;
	FloatList leg_span;

	float tail_wid,tail_hei;
	color fcolor;
	
	float phi;
	float elastic_strength;
	int elastic_stage=0;

	FloatList land_poses;
	int land_length;
	float land_vel;
	int land_index;

	// MeatTexture mtext;
	SkateBoard sktb;
	// boolean onSkate=false;
	
	SwimWater water;
	FireWheel[] wheels;
	SpaceShip sship;


	int transport_mode=0;
	float wheel_vel=27;
	float swim_vel=80;
	float skate_vel=60;
	float run_vel=50;
	float jump_vel=random(50,90);
	float disco_vel=60;
	
	int disco_stage=-2;

	float v_jump_dest_y;
	float v_jump_vel=random(10,24);

	float s_body_hei_incre=0;

	PVector first_foot_base;
	PVector last_foot_base;

	Cookie cookie;
	Volcano volcano;

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
		


		land_poses=new FloatList();
		land_length=(int)(random(.5,1.2)*width);
		for(int i=0;i<land_length;++i){
			if(random(20)<1) land_poses.append(random(-LAND_DISTORT,0)*30);
			else land_poses.append(random(-LAND_DISTORT,LAND_DISTORT));
		} 
		land_vel=(int)random(3,10);
		land_index=0;

		elastic_strength=(float)land_vel/10*random(1,3);


		 // mtext=new MeatTexture(-body_wid*.1,-body_hei*.3,wid,body_hei,fcolor);
		// mtext.draw();
		sktb=new SkateBoard(0,body_hei+leg_hei/4*3,wid*random(.5,.8),hei*random(.1,.4));

		water=new SwimWater(wid/4,hei/2,hei*random(.2,.6)+body_hei/5,hei/10);
		wheels=new FireWheel[2];
		wheels[0]=new FireWheel(wid/4,hei,hei*random(.3,.5));
		wheels[1]=new FireWheel(wid/4*3,hei,hei*random(.3,.5));

		sship=new SpaceShip(x,hei*random(1,3),wid,hei,phi,jump_vel,transport_mode);

		// cookie=new Cookie(body_wid/2,hei+body_hei,wid*random(.2,.5),hei*random(.2,.4));

		volcano=new Volcano(x,height-hei*random(7),wid*random(.8,1.5),hei*random(.2,.4),v_jump_vel,phi);
		v_jump_dest_y=volcano.dest_rad;
	}	

	void draw(PGraphics pg,boolean draw_fill){
		
		if(transport_mode==3|| transport_mode==4){
			boolean change=sship.draw(pg,draw_fill);
			if(change){

				transport_mode++;
				sship.play_mode=transport_mode;
				//println("change transport_mode to "+transport_mode);
			}
		}
		
		if(transport_mode==5){
			//println("animal finished!");
			return;
		}
 		//image(mtext.pg,0,0,wid,hei);
		pg.pushStyle();
		
		if(draw_fill){
		 	pg.noStroke();
		 	pg.fill(fcolor);
		 	if(transport_mode==8) pg.fill(red(fcolor),green(fcolor)*2,blue(fcolor)*2,150);
		}else{
		 	// pg.noFill();
		 	pg.fill(fcolor);
		 	pg.stroke(0);
		}
		
		float draw_portion=1.5*abs(sin((float)frameCount/(120/land_vel)));



		float elastic_portion=.6+elastic_strength*abs(sin((float)frameCount/(180/land_vel)+phi));
		
		int new_elastic_stage=(int)((((float)frameCount/(180/land_vel)+phi)%PI)/(PI/2));

		float cur_body_wid=(transport_mode==0)?body_wid*elastic_portion:body_wid;
		if(transport_mode==0)
			if(elastic_stage==1 && new_elastic_stage==0) x+=body_wid*(0.6+elastic_strength)-body_wid*.6;
		elastic_stage=new_elastic_stage;


		float jump_portion=(transport_mode==4)?(float)frameCount/(jump_vel)+phi
											  :(float)frameCount/(v_jump_vel)+phi;
		jump_portion%=TWO_PI;
		int jump_stage=0;//sship.stage;//(int)((jump_portion)/(PI/2));
		float jump_pos_y=0;
		float jump_pos_x=0;
		if(transport_mode==4){
			jump_stage=sship.stage;
			if(jump_stage==2||jump_stage==3){
				jump_pos_y=sship.ray_cur_y-y-body_hei;
				jump_pos_x=sship.ship_delta_x;
			}
		}
		if(transport_mode==6){
			jump_stage=(int)(jump_portion/(PI/2));
			int jump_y_cycle=floor(((float)frameCount/(v_jump_vel)+phi)/TWO_PI);
			float jump_y_portion=1;//.3+1.2*abs(sin(jump_y_cycle));
			if(jump_stage==2||jump_stage==3){
				jump_pos_y=-abs(v_jump_dest_y*jump_y_portion*sin(jump_portion));	
			}else{
				jump_pos_y=abs(leg_hei*sin((jump_portion)));
			}
			if(jump_stage==2||jump_stage==1) volcano.draw(pg,draw_fill,true,false);	
			else volcano.draw(pg,draw_fill,false,false);
			
		}
		if(transport_mode==8){
			float swim_portion=(float)frameCount/(swim_vel/land_vel)+phi;
			int swim_stage=(int)((swim_portion%TWO_PI)/(PI/2));
			if(swim_stage==3){
				y+=-sq(sin(swim_portion-PI/2))*body_hei/3*abs(cos(phi)+.1);	
				// s_body_hei_incre=-abs(sin(swim_portion)*body_hei);
			}else if(swim_stage==2){
				y+=-sq(sin(swim_portion-PI/2))*body_hei/2*abs(cos(phi)+.1);	
			}else{
				y+=-sq(sin(swim_portion))*body_hei/12*abs(cos(phi)+.1);	
			}
			
			s_body_hei_incre=-abs(sin((swim_portion%TWO_PI)/2)*body_hei*abs(cos(phi)+.1));
			if(y<-height/3) y=height+height/3;

		}else s_body_hei_incre=0;

		if(transport_mode==7){
			float disco_portion=(float)frameCount/(disco_vel/land_vel/2)+phi;
			int new_disco_stage=(int)((disco_portion%TWO_PI)/(PI/2));
			
			int disco_cycle=(int)((disco_portion+PI/2)/(TWO_PI));
			int steps=int(abs(sin(phi))*2+1);

			if(disco_stage==-2) disco_stage=new_disco_stage;
			if(disco_stage==2 && new_disco_stage==3){
				// println(disco_cycle%(steps*2));
				int icycle=disco_cycle%(steps*2);
				if(icycle>0 && icycle<steps) x+=leg_hei*sin(PI/6)*4+last_foot_base.y;//(first_foot_base.y);
				else if(icycle>steps && icycle<steps*2)
					x-=leg_hei*sin(PI/6)*4+last_foot_base.y;
				// println("go!");
			}
			disco_stage=new_disco_stage;

			// println(disco_stage);
			disco_portion%=TWO_PI;
			if(disco_cycle%(steps*2)<steps){
				if(disco_stage==0||disco_stage==3){
					jump_pos_x=-last_foot_base.x;
				}else{
					jump_pos_x=-((first_foot_base.x-first_foot_base.y)+last_foot_base.y);//-body_wid);//*(sin(disco_portion));
				}
			}else{
				if(disco_stage==1||disco_stage==2){
					jump_pos_x=-last_foot_base.x;
				}else{
					jump_pos_x=-((first_foot_base.x-first_foot_base.y)+last_foot_base.y);//-body_wid);//*(sin(disco_portion));
				}

			}

			// else if(disco_stage==3){
			// 	jump_pos_x=body_wid;//*(sin(disco_portion));
			// }
		}

		//if(!draw_fill) pg.line(x,y,x+wid,y);
		

		pg.pushMatrix();

		if(transport_mode==8) pg.rotate(sin(phi)*PI/4);

		if(transport_mode==0){
			if(elastic_stage==0) pg.translate(x,y);
			else pg.translate(x+body_wid*(0.6+elastic_strength)-cur_body_wid,y);
		}else if(transport_mode==7){
			pg.translate(width/2,height/2);
			pg.rotate(phi/2);
			pg.translate(-width/2,-height/2);
			
			pg.translate(x+jump_pos_x,y+jump_pos_y);

		}else{
			pg.translate(x+jump_pos_x,y+jump_pos_y);
		}
		
		if(transport_mode==1 && draw_fill){
			//sktb.x=x+cur_body_wid/2;
			sktb.draw(pg);
		}
		if(transport_mode==2){
		// 	//water.x=cur_body_wid/4;
			
				
			wheels[0].setPos(first_foot_base);
			wheels[1].setPos(last_foot_base);
			float frame_portion=(float)frameCount/(wheel_vel/land_vel)+phi;
			int stage=(int)((frame_portion%TWO_PI)/(PI/2));
			if(stage>1 && draw_fill)
				for(FireWheel wheel:wheels) wheel.draw(pg,draw_fill);
			
		}
		// if(transport_mode==7 && !draw_fill){
		// 	pg.pushStyle();
		// 	pg.stroke(255,0,0);
		// 	pg.strokeWeight(2);
		// 	pg.line(jump_pos_x,0,jump_pos_x,100);
		// 	pg.stroke(0,255,0);
		// 	pg.line(first_foot_base.y,0,first_foot_base.y,100);
		// 	pg.popStyle();
		// }

		pg.beginShape();
		pg.vertex(0,0+s_body_hei_incre);
		if(transport_mode==7){
			pg.bezierVertex(cur_body_wid/3,-body_hei*.3*draw_portion+body_hei*.3*random(-1,1),
						 cur_body_wid/3*2,-body_hei*.3*draw_portion+body_hei*.3*random(-1,1),
						 cur_body_wid,0);
		}else
			pg.bezierVertex(cur_body_wid/3,-body_hei*.3*draw_portion+s_body_hei_incre,
						 cur_body_wid/3*2,-body_hei*.3*draw_portion+s_body_hei_incre,
						 cur_body_wid,0);


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
		// vertex(cur_body_wid,body_hei);
		// bezierVertex(cur_body_wid*.95,body_hei,cur_body_wid,body_hei,
		// 			
	
		pg.vertex(cur_body_wid*(1-(float)(0+leg_span.get(0))/mleg),body_hei);

		for(int i=0;i<mleg;++i){
			if(i>0) pg.vertex(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei);

			if(transport_mode==1) drawLegOnSkateBoard(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei,leg_wid,leg_hei,i,pg);
			else if(transport_mode==0) drawRunLeg(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei,leg_wid,leg_hei,i,pg);
			else if(transport_mode==2) drawWheelLeg(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei,leg_wid,leg_hei,i,pg);
			else if(transport_mode==6) drawJumpLeg(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei,leg_wid,leg_hei,i,pg);
			else if(transport_mode==8) drawSwimLeg(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei,leg_wid,leg_hei,i,pg);
			else if(transport_mode==7) drawDiscoLeg(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei,leg_wid,leg_hei,i,pg);
					
		}
		
		pg.bezierVertex(-cur_body_wid*.1*draw_portion,body_hei,
					 -cur_body_wid*.1*draw_portion,0,
					 0,0+s_body_hei_incre);


		pg.endShape();
		if(!draw_fill){
			pg.stroke(red(fcolor)/1.1,green(fcolor)/1.1,blue(fcolor)/1.3);
			pg.beginShape();
			for(int i=0;i<80;++i){
					// pg.strokeWeight(random(2));
					pg.vertex(random(cur_body_wid),
							   random(-body_hei*.1,body_hei/2));
			
			}
			pg.endShape();
		}


		if(draw_fill && transport_mode==0) drawLand(pg);
		if(transport_mode==2 && !draw_fill){
			for(FireWheel wheel:wheels) wheel.draw(pg,draw_fill);
			// for(FireWheel wheel:wheels) wheel.draw(pg,draw_fill);
		}

		pg.popMatrix();
		

		pg.popStyle();

		
		update();
	}

	void update(){
		switch(transport_mode){
			case 0:
				if(random(500)<1){
				 land_vel+=(int)random(-2,2);
				 elastic_strength=(float)land_vel/10*random(1,3);
				}
				land_vel=constrain(land_vel, 5, 20);

				if(x<width/20*land_vel) x+=land_vel/10;
				else if(x>width/20*land_vel) x-=land_vel/10;
				break;

			case 1:
			case 2:
				land_vel=constrain(land_vel, 5, 20);
				x+=(transport_mode==2)?land_vel/2:land_vel/3;
				break;
			case 3:
				//x=width/2;
				break;
		}
		
	}
	void drawRunLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg){


		float frame_portion=(float)frameCount/(run_vel/land_vel)+phi;
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		
		float kang=-PI/2.5*(sin(frame_portion));
		if(leg_index%2==1) kang=-PI/2.5*(sin(frame_portion+PI/2));
		float fang=0;//kang+PI/1.8;
		
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
	void drawLegOnSkateBoard(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg){


		float frame_portion=(float)frameCount/(skate_vel/land_vel)+phi;
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		
	
		float fang=PI/8;
		if(leg_index>(mleg-1)/2) fang-=-PI/10*abs(sin(frame_portion));//PI/6*(sin(frame_portion+PI/2));
		float kang=fang;

		drawLegs(kang,fang,lx,ly,lw,lh,leg_index,pg);
			


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
	void drawSwimLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg){

		float frame_portion=(float)frameCount/(swim_vel/land_vel)+phi;
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		
		float kang=0;//*(sin(frame_portion));
		boolean left_leg=(leg_index<(mleg+1)/2);
		// if(!left_leg) kang=-PI/3*(sin(frame_portion));
		float fang=0;//kang+PI/1.8;
		
		float ang=frame_portion%TWO_PI;		
		switch(stage){
			case 0:
				kang=PI/6*(left_leg?1:-1);
				
				// kang=(-(PI/3+PI/6)*(sin(ang))+PI/6)*(left_leg?1:-1);
				// kang=(-(PI/3)*(sin(ang)))*(left_leg?1:-1);
				fang=kang+PI/1.3*(sin(ang))*((left_leg)?1:-1);

				break;
			case 1:
				// kang=-PI/3*(left_leg?1:-1);//
				kang=(-(PI/3+PI/6)*(sin(ang-PI/2))+PI/6)*(left_leg?1:-1);
				fang=kang+PI/1.3*((left_leg)?1:-1);//*((sin(frame_portion)))*((left_leg)?1:-1);
				break;
			case 2:
				kang=-PI/3*(sin(ang-PI/2))*(left_leg?1:-1);
				fang=kang;//+PI/1.3*sin((ang-PI/2))*(left_leg?1:-1);
				break;
			
			case 3:
				kang=-PI/6*(sin((ang-PI/2)))*(left_leg?1:-1);
				fang=kang;
				break;
				
		}
		
		drawLegs(kang,fang,lx,ly,lw,lh,leg_index,pg);

	
	}

	void drawWheelLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg){

		float frame_portion=(float)frameCount/(wheel_vel/land_vel)+phi;
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		
		float kang=-PI/2*(sin(frame_portion));
		if(leg_index%2==1) kang=-PI/2*(sin(frame_portion+PI/4));
		float fang=0;//kang+PI/1.8;
		
		switch(stage){
			case 0:
				fang=kang+PI/1.6;
				break;
			case 1:
				fang=kang+PI/1.6*((sin(frame_portion)));
				break;
			case 2:
				fang=kang;
				break;
			case 3:
				fang=kang+PI/1.6*(1-abs(sin(frame_portion)));
				break;
				
		}
		
		drawLegs(kang,fang,lx,ly,lw,lh,leg_index,pg);

	}

	void drawJumpLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg){

		float frame_portion=(float)frameCount/(v_jump_vel)+phi;
		frame_portion%=TWO_PI;
		int stage=(int)((frame_portion)/(PI/2));
		
		boolean left=(leg_index>(mleg-1)/2);
		float aoffset=0;//((left)?-PI/6:PI/6);
		
		float kang=0;//-PI/2*(sin(frame_portion));
		float fang=0;//kang+PI/1.8;
		
		switch(stage){
			case 0:
				kang=-PI/3*((sin(frame_portion)))+aoffset;
				fang=kang+PI/1.7*((sin(frame_portion)));
				break;
			case 1:
				kang=-PI/3*sin((frame_portion))+aoffset;
				fang=kang+PI/1.7*((sin(frame_portion)));
				break;
			case 2:
				if(left) kang=0+PI/4*sin((frame_portion));
				else kang=0-PI/4*sin((frame_portion));
				fang=kang;//+PI/3*(1-abs(sin(frame_portion)));
				break;
			case 3:
				if(left) kang=0+PI/4*sin((frame_portion));
				else kang=0-PI/4*sin((frame_portion));//-PI/3*sin((frame_portion-PI/2*3)*2+PI/2*3);
				fang=kang;
				break;
				
		}
		//kang-=PI/6;
		// if(leg_index>(mleg-1)/2){
		// 	kang-=PI/6;// fang*=-1;
		// }else{
		// 	kang+=PI/6;
		// }


		drawLegs(kang,fang,lx,ly,lw,lh,leg_index,pg);

	}
	void drawDiscoLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg){


		float frame_portion=(float)frameCount/(disco_vel/land_vel/2)+phi;
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		frame_portion%=TWO_PI;
		
		float fang=-PI/6*(sin(frame_portion));
		boolean isLeft=!(leg_index>(mleg-1)/2);// fang=-PI/8*(sin(frame_portion));//PI/6*(sin(frame_portion+PI/2));
		if(!isLeft) fang*=-1;
		float kang=fang;

		drawDancingLegs(kang,fang,lx,ly,lw,lh,leg_index,pg);
			
	}
	void drawDancingLegs(float kang,float fang,float lx,float ly,float lw,float lh,int leg_index,PGraphics pg){	
		PVector knee_base=new PVector(0,lh/2);
		knee_base.rotate(kang);

		PVector foot_base=new PVector(0,lh/2);
		foot_base.rotate(fang);
		

		PVector foot_base2=new PVector(-lw,lh/2);
		foot_base2.rotate(fang);
		
		foot_base.add(knee_base);
		foot_base2.add(knee_base);
		
		float frame_portion=(float)frameCount/(disco_vel/land_vel/2)+phi;
		float draw_portion=sin(frame_portion);//*random(-1,1);

		pg.bezierVertex(lx+knee_base.x+lw*draw_portion,ly+knee_base.y,
					 lx+foot_base.x+lw*draw_portion,ly+foot_base.y,
					 lx+foot_base.x,ly+foot_base.y);
		// vertex(lx+knee_base.x,ly+knee_base.y);
		// vertex(lx+foot_base.x,ly+foot_base.y);
		
		pg.vertex(lx+foot_base2.x,ly+foot_base2.y);

		// vertex(lx-lw+knee_base.x,ly+knee_base.y);
		// vertex(lx-lw,ly);

		pg.bezierVertex(lx-lw+knee_base.x+lw*draw_portion,ly+knee_base.y,
					 lx-lw+knee_base.x+lw*draw_portion,ly+knee_base.y,
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
}


