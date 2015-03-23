

class Volcano{
	float x,y,wid,hei;
	color fc;
	float dest_rad;
	float vel;
	float phi;

	ArrayList<PVector> top_vertex;
	ArrayList<PVector> ash_vertex;
	ArrayList<VDrop> ash_drops;

	FloatList firework_vertex;
	
	Volcano(float x_,float y_,float wid_,float hei_,float vel_,float phi_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		vel=vel_; phi=phi_;

		fc=color(random(50,100)+150,random(20,40)+120,80);

		int mvert=(int)random(8,28);
		top_vertex=new ArrayList<PVector>();
		for(int i=0;i<mvert;++i)
			top_vertex.add(new PVector(wid/8*5-wid/4/(float)mvert*i,random(-.3,.3)*hei));
		
		dest_rad=y;//random(8,20)*hei;	
		ash_vertex=new ArrayList<PVector>();
		for(int i=0;i<mvert;++i)
			ash_vertex.add(new PVector(PI/2/(float)mvert*random(.2,.6),random(-.5,1.5)*hei));
			// ash_vertex.add(new PVector(wid/8*5-wid/4/(float)mvert*i,random(-.5,1.5)*hei));
	
		// firework_vertex=new FloatList();
		// float tmp_ang=0;
		// for(int i=0;i<mvert;++i){
		// 	float ang=random(TWO_PI/(float)mvert);
		// 	ang=constrain(ang,tmp_ang,TWO_PI-tmp_ang);
		// 	firework_vertex.append(ang+tmp_ang);
		// 	tmp_ang+=ang;
		// }

		ash_drops=new ArrayList<VDrop>();
		for(int i=0;i<mvert*5;++i)
			ash_drops.add(new VDrop(random(wid/8*3,wid/8*5),random(-.3,.3)*hei,dest_rad,i>mvert*5/2));
	}


	void draw(PGraphics pg,boolean draw_fill,boolean draw_ash,boolean draw_fire){

		float draw_portion=abs(sin((float)frameCount/vel));

		pg.pushStyle();
		if(draw_fill){
			pg.noStroke(); pg.fill(fc);
		}else{
			pg.stroke(0); pg.noFill();
		}

		pg.pushMatrix();
		pg.translate(x-wid/2,y);

			if(draw_ash)	drawAsh(pg,draw_fill);
			if(draw_fire)	drawFireworks(pg,draw_fill,draw_portion);
			
			
			pg.beginShape();
				if(draw_fill){
					pg.vertex(0,hei);
					pg.bezierVertex(wid/3*draw_portion,hei+hei/8*draw_portion,wid/3*2*draw_portion,hei+hei/8*draw_portion,
								wid,hei);
				}else pg.vertex(wid,hei);
				pg.bezierVertex(wid/8*7,hei/3*2+hei/2*draw_portion,wid/8*6,hei/3+hei/2*draw_portion,
								wid/8*5,-hei/12*draw_portion);
				
				for(PVector v:top_vertex) pg.vertex(v.x,v.y+v.y/2*draw_portion);

				pg.bezierVertex(wid/8*3,hei/3+hei/4*draw_portion,wid/8,hei/3*2+hei/2*draw_portion,
								0,hei+hei/12*draw_portion);
			pg.endShape();

			
			if(draw_fill){
				// pg.stroke(fc);
				pg.stroke(30,80);
				pg.noFill();
				pg.translate(wid*sin(phi),hei);
				int mvert=8;//(int)random(6,16);
				float last_x=0,last_y=0;
				pg.beginShape();
					pg.vertex(0,0);
					for(int x=0;x<mvert;++x){
						// float tmp_x=x*wid/8*cos(phi*draw_portion+x)+wid/4*draw_portion;
						// float tmp_y=(hei/12*x)*(1+draw_portion+2*cos(phi));
						float tmp_x=x*wid/8*cos(phi+x)+wid/4;
						float tmp_y=(hei/12*x)*(1+1+2*cos(phi));
						if(random(3)<1) 
							pg.vertex(tmp_x,tmp_y);
						else pg.bezierVertex(tmp_x+wid/8,tmp_y-hei/2*sin(x),last_x-wid/8,last_y-hei/2*sin(x),
											 tmp_x,tmp_y);

						last_x=tmp_x; last_y=tmp_y;
					}	
				pg.endShape();
			}
				

		pg.popMatrix();

		pg.popStyle();

	}
	void drawAsh(PGraphics pg,boolean draw_fill){
		
		float jump_portion=((float)frameCount/(vel)+phi)%TWO_PI;
		int jump_stage=(int)(jump_portion/(PI/2));

		int jump_y_cycle=floor(((float)frameCount/(vel)+phi)/TWO_PI);
		float cycle_dest_y=dest_rad;//(.3+1.2*abs(sin(jump_y_cycle)))*dest_rad;

		float draw_portion=0;
		if(jump_stage==2||jump_stage==3) draw_portion=abs(sin(jump_portion));
		
		pg.pushStyle();
		if(draw_fill){
			pg.noStroke(); pg.fill(red(fc)*2.5,green(fc)/2,0,180);
		}else{
			pg.stroke(0,170); pg.noFill();
		}

			pg.pushMatrix();
				pg.translate(0,hei/2);
				float mash=ash_vertex.size();
				float rad=dest_rad*draw_portion;

				PVector dest=null;
				for(int i=0;i<mash;++i){
					// float ang=-PI/4+PI/2/mash*i+PI;
					// PVector v=ash_vertex.get(i);
					
					// int mnoise=abs((int)(v.x*100));//(int)random(4,12);
					// pg.beginShape();

					// 	for(int x=0;x<mnoise;++x){
					// 		float trad=random(v.y,rad);
					// 		float tang=random(-v.x,v.x)+ang;
					// 		if(x%3==0) pg.vertex(wid/2+trad*sin(tang),trad*cos(tang));
					// 		else pg.bezierVertex(wid/2+trad*sin(tang)*draw_portion,trad*cos(tang),
					// 						wid/2+trad*sin(tang),trad*cos(tang)*draw_portion,
					// 						wid/2+trad*sin(tang),trad*cos(tang));
					// 	}

					// pg.endShape();

					VDrop drop=ash_drops.get(i);

					int mnoise=(int)random(3,8);
					pg.beginShape();
						float last_tx=0,last_ty=0;
						for(int x=0;x<mnoise;++x){

							float tx,ty;
							if(jump_stage==2){
								tx=random(-wid/12,wid/12)+drop.x;
								ty=random(-drop.y-cycle_dest_y/3,hei/2);
								if(ty<-cycle_dest_y){
									ty=ty+random(-.3,.3)*cycle_dest_y;
									tx=random(-wid/2,wid/2)+drop.x;
								}
								if(x%3==0) pg.vertex(tx,ty);
								else pg.bezierVertex((last_tx+tx)/2*draw_portion,(last_ty+ty)/2,
													(last_tx+tx)/2,(last_ty+ty)/2*draw_portion,
													tx,ty);
							}else{
								tx=random(-wid/25,wid/25)+drop.x;
								ty=random(-hei,0);
								pg.vertex(tx,ty);
							}
							
							last_tx=tx;
							last_ty=ty;
						}

					pg.endShape();
					// pg.arc(drop.x,-drop.y,10,10,0,PI);

					drop.update(jump_stage,jump_portion,cycle_dest_y);
					if(drop.x>wid||drop.x<-wid) drop.reset();
				}

			pg.popMatrix();
		

		pg.popStyle();

	}
	void drawFireworks(PGraphics pg,boolean draw_fill,float draw_portion){

		pg.pushStyle();
		if(draw_fill){
			pg.noStroke(); pg.fill(red(fc)*2.5,green(fc)/2,0);
		}else{
			pg.stroke(0); pg.noFill();
		}

		pg.pushMatrix();
			pg.translate(wid/2,-dest_rad*1.5);



			// int mfire=firework_vertex.size();
			// float ang_wid=PI/(float)mfire*draw_portion;
			// for(int i=0;i<mfire;++i){
			// 	float ang=firework_vertex.get(i);
				
			// 	int mnoise=(int)random(2,7);
			// 	pg.beginShape();

			// 		for(int x=0;x<mnoise;++x){
			// 			float tang=random(-ang_wid,ang_wid)+ang;
			// 			float trad=random(dest_rad/5*(1-draw_portion),dest_rad/2);
			// 			if(x%3==0) pg.vertex(trad*sin(tang),trad*cos(tang));
			// 			else pg.bezierVertex(trad*sin(tang)*draw_portion,trad*cos(tang),
			// 							trad*sin(tang),trad*cos(tang)*draw_portion,
			// 							trad*sin(tang),trad*cos(tang));
			// 		}

			// 	pg.endShape();

			// }

		pg.popMatrix();
		pg.popStyle();
	}

}

class VDrop{
	
	float origin_x,origin_y;
	float x,y;
	float dest_y;
	float vel;
	boolean onleft;

	VDrop(float x_,float y_,float dest_,boolean left_){
		x=x_; y=y_;
		origin_x=x_; origin_y=y_;
		dest_y=dest_;
		vel=1;//random(.02,.1)*(dest_y-y);
		onleft=left_;
	}
	void update(int jump_stage,float jump_portion,float cycle_dest){
		switch(jump_stage){
			case 2:
				y=origin_y+(cycle_dest-origin_y)*abs(sin(jump_portion));
				break;
		}
		
	}
	void reset(){
		x=origin_x; y=origin_y;
	}


}