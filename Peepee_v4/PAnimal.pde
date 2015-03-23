final float LAND_DISTORT=.6;
final int MAX_GENERATION=5;

class PAnimal{
	
	float x,y,wid,hei;
	float head_wid,head_hei;
	float body_wid,body_hei;
	
	float leg_wid,leg_hei;
	int mleg;
	FloatList leg_span;
	IntList leg_direction;

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
	float run_vel=150;
	float alien_vel=random(220,500);

	
	float s_body_hei_incre=0;

	PVector first_foot_base;
	PVector last_foot_base;

	float stop_draw_portion;
	float stop_run_portion;

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
		leg_direction=new IntList();
		
		for(int i=0;i<mleg;++i){
			leg_span.append(random(0.05,0.5));
			leg_direction.append((random(2)<1?1:0));
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

		
		start_frame=frameCount;
	}
	void draw(PGraphics pg,boolean draw_fill){
		
		
		
		
		float draw_portion=1.5*abs(sin((float)frameCount/(120/land_vel)));

		float run_portion=(float)(frameCount-start_frame)/(run_vel/land_vel)+run_phi;
					

		float frame_portion=(float)(frameCount-start_frame)/(alien_vel/land_vel)+phi;
		frame_portion%=(TWO_PI*2);
		int new_alien_stage=(int)((frame_portion)/(PI/2));
		

		float cur_body_wid=body_wid;
		float cur_head_pos=0;
		float cur_tail_pos=0;


		pg.pushStyle();
		
		if(draw_fill){
		 	pg.noStroke();
		 	pg.fill(fcolor);
		}else{
		 	// pg.noFill();
		 	pg.fill(fcolor);
			pg.stroke(80); 
		}

		pg.pushMatrix();

		if(transport_mode==0){
			pg.translate(x+land_vel/8*wid*sin(frame_portion),y+land_vel/50*hei*abs(sin(frame_portion)));
			
		}

		pg.beginShape();
		pg.vertex(0,cur_tail_pos);
		pg.bezierVertex(cur_body_wid/3,-body_hei*.3*draw_portion+s_body_hei_incre+lerp(cur_tail_pos,cur_head_pos,.33),
						 cur_body_wid/3*2,-body_hei*.3*draw_portion+s_body_hei_incre+lerp(cur_tail_pos,cur_head_pos,.66),
						 cur_body_wid,cur_head_pos);

		PVector ear_base1=new PVector(head_hei,0);
		ear_base1.rotate((-PI/3)*draw_portion-PI/6-PI/4);
		PVector ear_base2=new PVector(head_hei,0);
		ear_base2.rotate(-PI/3*draw_portion-PI/4);


		pg.bezierVertex(cur_body_wid+ear_base1.x,cur_head_pos+ear_base1.y,
					  cur_body_wid+ear_base2.x,cur_head_pos+ear_base2.y,
					  cur_body_wid,cur_head_pos);

		pg.bezierVertex(cur_body_wid+head_wid/2,cur_head_pos-body_hei*.1*draw_portion,
					 cur_body_wid+head_wid,cur_head_pos+head_hei+body_hei*.4*draw_portion,
					 cur_body_wid,cur_head_pos+head_hei);
			
		
		pg.vertex(cur_body_wid*(1-(float)(0+leg_span.get(0))/mleg),cur_head_pos+body_hei);

		for(int i=0;i<mleg;++i){
			float cur_tmp_pos=lerp(cur_head_pos,cur_tail_pos,((float)(i+leg_span.get(i))/mleg));
			if(i>0) pg.vertex(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei+cur_tmp_pos);
			if(transport_mode==0){
				drawRunLeg(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei+cur_tmp_pos,leg_wid,leg_hei,i,pg,run_portion);
			} 					
		}
		
		pg.bezierVertex(-cur_body_wid*.1*draw_portion,cur_tail_pos+body_hei,
					 -cur_body_wid*.1*draw_portion,cur_tail_pos,
					 0,cur_tail_pos);


		pg.endShape();
		
		


		if(!draw_fill){
			pg.stroke(red(fcolor)/1.1,green(fcolor)/1.1,blue(fcolor)/1.3);
			pg.beginShape();
			for(int i=0;i<80;++i){
					// pg.strokeWeight(random(2));
					float tmp_x=random(cur_body_wid);
					float cur_tmp_pos=lerp(cur_head_pos,cur_tail_pos,1-tmp_x/cur_body_wid);
					pg.vertex(tmp_x,
							   cur_tmp_pos+random(-body_hei*.1,body_hei/2));
			
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
				// }
				break;

		}
		
	}
	void drawRunLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg,float frame_portion){


		
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		
		float kang=-PI/4*(sin(frame_portion));
		if(leg_direction.get(leg_index)==1) kang=-PI/4*(sin(frame_portion+PI/2*sin(leg_index)));
		float fang=0;//+PI/1.8;
		
		switch(stage){
			case 0:
				fang=kang+PI/3;//*(sin(frame_portion));
				break;
			case 1:
				fang=kang+PI/3*((sin(frame_portion)));
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
				fang=kang+PI/3*(1-abs(sin(frame_portion)));
				break;
				
		}
		drawLegs(kang,fang,lx,ly,lw,lh,leg_index,pg);
		
	}	
	void drawStandLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg,float frame_portion){

		
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		
		float kang=0;//-PI/2.5*(sin(frame_portion))*((leg_index%2==0)?1:-1);
		float fang=kang;
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

		// switch(transport_mode){
		// 	case 1:
		// 		if(leg_index==0) first_foot_base=new PVector(lx-lw+foot_base.x,ly+foot_base.y);
		// 		else if(leg_index==mleg-1) last_foot_base=new PVector(lx+lw+foot_base.x,ly+foot_base.y);
		// 		break;
		// 	case 2:
		// 		if(leg_index==0) first_foot_base=new PVector(lx-lw+foot_base.x,ly+lh);
		// 		else if(leg_index==mleg-1) last_foot_base=new PVector(lx+lw+foot_base.x,ly+lh);
		// 		break;
		// 	case 7:
		// 		if(leg_index==0) first_foot_base=new PVector(lx-lw+foot_base.x,lx-lw+lh*sin(PI/6));
		// 		else if(leg_index==mleg-1) last_foot_base=new PVector(lx+lw+foot_base.x,lx+lw-lh*sin(PI/6),lx+lw+lh*sin(PI/6));
		// 		break;
		// }
	}

}


