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

	public PVector tail_land_pos;
	public PVector head_land_pos;
	PVector[] leg_points;

	PVector[] land_points;

	float cur_body_wid;
	float cur_head_pos;
	float cur_tail_pos;

	float frame_portion,draw_portion;

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

		phi=random(TWO_PI);
		run_phi=random(TWO_PI);
				


		// land_poses=new FloatList();
		// land_length=(int)(random(.5,1.2)*width);
		// for(int i=0;i<land_length;++i){
		// 	if(random(20)<1) land_poses.append(random(-LAND_DISTORT,0)*30);
		// 	else land_poses.append(random(-LAND_DISTORT,LAND_DISTORT));
		// } 
		land_vel=(int)random(3,10);
		// land_index=0;

		elastic_strength=(float)land_vel/10*random(1,3);
		start_frame=frameCount;
		// child_animal=new PAnimal(this);

		float land_rad=body_wid*random(.8,1);
		float land_hei=body_hei+leg_hei*random(.8,1.5);
		// tail_land_pos=new PVector(body_wid/2-land_rad,land_hei);
		// head_land_pos=new PVector(body_wid/2+land_rad,land_hei);


		int mland=20;
		land_points=new PVector[mland];
		for(int i=0;i<mland;++i){
			float tmp_ang=PI/(float)mland*i*random(.8,1.3);
			float tmp_port=.3*(1-abs(tmp_ang-HALF_PI)/(HALF_PI));
			float tmp_rad=land_rad*random(1-tmp_port,1+tmp_port);
			float tmp_h=tmp_rad*(1-abs(cos(tmp_ang)));

			land_points[i]=new PVector(body_wid/2+tmp_rad*cos(tmp_ang),land_hei+tmp_h);
		}
	}	

	void draw(PGraphics pg,boolean draw_fill,PVector last_land_pos,PVector next_land_pos,PVector center_land_pos_1,PVector center_land_pos_2){
		
		// if(!draw_fill) 
			update(frame_portion);

		
		int new_alien_stage=(int)((frame_portion)/(PI/2));
		

		

		pg.pushStyle();
		
		if(draw_fill){
		 	pg.noStroke();
		 	// pg.stroke(255);
		 	// pg.strokeWeight(1);
		 	pg.fill(fcolor,200);
		}else{
		 	pg.noFill();
		 	// pg.fill(fcolor);
			pg.stroke(80,120); 
			pg.strokeWeight(2);
		}

		pg.pushMatrix();

		PVector cur_pos=getCurPos();
		if(transport_mode==0){
			pg.translate(cur_pos.x,cur_pos.y);
			pg.rotate(phi);
		}


		pg.beginShape();

		if(draw_fill){
		  pg.vertex(last_land_pos.x,last_land_pos.y);
		  pg.vertex(tail_land_pos.x,tail_land_pos.y);
		}else{
			// pg.vertex(last_land_pos.x,last_land_pos.y);
		  // pg.vertex(tail_land_pos.x,tail_land_pos.y);
		}
		pg.vertex(leg_points[mleg*6-3].x,leg_points[mleg*6-3].y);
		
		pg.bezierVertex(leg_points[mleg*6-2].x,leg_points[mleg*6-2].y,leg_points[mleg*6-2].x,leg_points[mleg*6-2].y,
						leg_points[mleg*6-1].x,leg_points[mleg*6-1].y);

		pg.bezierVertex(-cur_body_wid*.1*draw_portion,cur_tail_pos+body_hei,
					 -cur_body_wid*.1*draw_portion,cur_tail_pos,
					 0,cur_tail_pos);


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

		pg.bezierVertex(leg_points[1].x,leg_points[1].y,leg_points[1].x,leg_points[1].y,
						leg_points[2].x,leg_points[2].y);
		
		
		if(draw_fill){
			pg.vertex(head_land_pos.x,head_land_pos.y);	
			pg.vertex(next_land_pos.x,next_land_pos.y);
			pg.vertex(center_land_pos_1.x,center_land_pos_1.y);
			pg.vertex(center_land_pos_2.x,center_land_pos_2.y);
		}else{
			// pg.vertex(head_land_pos.x,head_land_pos.y);	
			
		}
		// if(draw_fill){
		// 	int mland=land_points.length;
		// 	// float eang=HALF_PI/(float)mland;
		// 	for(int i=0;i<mland;++i){
		// 		pg.vertex(land_points[i].x,land_points[i].y);
		// 	}
		// }
		

		for(int i=0;i<mleg-1;++i){
			pg.beginContour();
				pg.vertex(leg_points[(i+1)*6].x,leg_points[(i+1)*6].y);
				pg.bezierVertex(leg_points[(i+1)*6+2].x,leg_points[(i+1)*6+2].y,leg_points[(i+1)*6+2].x,leg_points[(i+1)*6+2].y,
								leg_points[i*6+3].x,leg_points[i*6+3].y);
				pg.bezierVertex(leg_points[i*6+4].x,leg_points[i*6+4].y,leg_points[i*6+4].x,leg_points[i*6+4].y,
								leg_points[i*6+5].x,leg_points[i*6+5].y);
				pg.vertex(leg_points[(i+1)*6].x,leg_points[(i+1)*6].y);
				
			pg.endContour();
		}

		


		pg.endShape();
		
		

		/***  back_stroke ***/
		if(draw_fill){
			pg.stroke(red(fcolor)/1.1,green(fcolor)/1.1,blue(fcolor)/1.3,80);
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

		
	
	}
	void drawLandLine(PGraphics pg,PAnimal next_animal,int index){
		pg.pushStyle();
		pg.stroke(80,120);
		pg.strokeWeight(2);
		pg.noFill();
		PVector ctrl=getCurFirstFootPos();
		ctrl.sub(next_animal.getCurLastFootPos());
		ctrl.rotate(PI/2);
		ctrl.setMag(hei*.7*random(.9,1.05));

		PVector center=getCurFirstFootPos();//
		center.add(next_animal.getCurLastFootPos());
		center.mult(.5);

		// if(index==0) pg.bezier( getCurFirstFootPos().x,getCurFirstFootPos().y,
		// 		   				center.x+ctrl.x,center.y+ctrl.y,center.x-ctrl.x,center.y-ctrl.y,
		// 						next_animal.getCurLastFootPos().x,next_animal.getCurLastFootPos().y);
		// else pg.bezier( getCurFirstFootPos().x,getCurFirstFootPos().y,
		// 		   		center.x+ctrl.x,center.y+ctrl.y,center.x+ctrl.x,center.y+ctrl.y,
		// 				next_animal.getCurLastFootPos().x,next_animal.getCurLastFootPos().y);
		PVector source=getCurFirstFootPos();
		PVector dest=next_animal.getCurLastFootPos();
		float mland=12;
		pg.beginShape();
		for(int i=0;i<=mland;++i){
			
			if(i%3!=0) pg.bezierVertex(lerp(source.x,dest.x,(float)(i-sin(i))/mland),lerp(source.y,dest.y,(float)(i-.5)/mland),
										lerp(source.x,dest.x,(float)(i+.5)/mland),lerp(source.y,dest.y,(float)(i+sin((float)i/5)*3)/mland),
											lerp(source.x,dest.x,(float)i/mland),lerp(source.y,dest.y,(float)i/mland));
			else pg.vertex(lerp(source.x,dest.x,(float)i/mland),lerp(source.y,dest.y,(float)i/mland));
		}
		pg.endShape();
		
		pg.popStyle();
	}
	PVector getCurPos(){
		return new PVector(x+wid/2*sin(frame_portion+(float)frameCount/land_vel/50),y+hei/2*(cos(frame_portion+phi)));
		// return new PVector(x,y);
	}
	PVector getWorldCood(PVector p){
		PVector cur_pos=getCurPos();
		p.rotate(phi);
		p.add(cur_pos);
		return p;
	}
	PVector getCurTailLandPos(){
		PVector tt=tail_land_pos.get();
		return getWorldCood(tt);
	}
	PVector getCurHeadLandPos(){	
		PVector hh=head_land_pos.get();
		return getWorldCood(hh);
	}
	PVector getCurFirstFootPos(){
		PVector fp=new PVector(leg_points[2].x,leg_points[2].y);
		return getWorldCood(fp);
	}
	PVector getCurLastFootPos(){
		PVector fp=new PVector(leg_points[mleg*6-3].x,leg_points[mleg*6-3].y);
		return getWorldCood(fp);
	}

	void update(float frame_portion){

		frame_portion=(float)(frameCount-start_frame)/(alien_vel/land_vel)+phi;
		frame_portion%=(TWO_PI*2);

		
		draw_portion=1.5*abs(sin((float)frameCount/(120/land_vel)));
		cur_body_wid=body_wid;
		cur_head_pos=body_hei/5*draw_portion;
		cur_tail_pos=body_hei/2*draw_portion;


		float run_portion=(float)(frameCount-start_frame)/(run_vel/land_vel)+run_phi;
		
		if(leg_points==null) leg_points=new PVector[mleg*6];
		for(int i=0;i<mleg;++i){
			 float cur_tmp_pos=lerp(cur_head_pos,cur_tail_pos,((float)(i+leg_span.get(i))/mleg));
			PVector[] leg_pts=getLegPoints(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei+cur_tmp_pos,leg_wid,leg_hei,i,run_portion);
			for(int j=0;j<6;++j){
				leg_points[i*6+j]=leg_pts[j];
			}
		}		

	}
	void drawRunLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg,float frame_portion){

		
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		
		float kang=-PI/6*(sin(frame_portion));
		if(leg_direction.get(leg_index)==1) kang=-PI/6*(sin(frame_portion+PI/2*sin(leg_index)));
		float fang=0;//+PI/1.8;
		
		switch(stage){
			case 0:
				fang=kang+PI/4;//*(sin(frame_portion));
				break;
			case 1:
				fang=kang+PI/4*((sin(frame_portion)));
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
				fang=kang+PI/4*(1-abs(sin(frame_portion)));
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
	PVector[] getLegPoints(float lx,float ly,float lw,float lh,int leg_index,float frame_portion){
		
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

		PVector[] leg_pts=new PVector[6];

		PVector knee_base=new PVector(0,lh/2);
		knee_base.rotate(kang);

		PVector foot_base=new PVector(0,lh/2);
		foot_base.rotate(fang);
		

		PVector foot_base2=new PVector(-lw,lh/2);
		foot_base2.rotate(fang);

		foot_base.add(knee_base);
		foot_base2.add(knee_base);
		
		leg_pts[0]=new PVector(lx,ly);
		leg_pts[1]=new PVector(lx+knee_base.x,ly+knee_base.y);
		leg_pts[2]=new PVector(lx+foot_base.x,ly+foot_base.y);

		leg_pts[3]=new PVector(lx+foot_base2.x,ly+foot_base2.y);
		leg_pts[4]=new PVector(lx-lw+knee_base.x,ly+knee_base.y);
		leg_pts[5]=new PVector(lx-lw,ly);
		
		return leg_pts;

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


