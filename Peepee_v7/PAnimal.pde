class PAnimal{
	PVector _pos,_size;
	float vel=80;
	float ang=PI/3;

	int mstage=2;
	ArrayList<PVector[]> uphand_joint;
	ArrayList<PVector[]> lowhand_joint;

	ArrayList<PVector[]> upleg_joint;
	ArrayList<PVector[]> lowleg_joint;
	FrameAnimation anima;

	color fcolor;
	color pcolor1,pcolor2,scolor1,scolor2;

	PAnimal(PVector set_pos,PVector set_size){
		_pos=set_pos;
		_size=set_size;

		fcolor=color(random(100,255),random(20,80)+100,random(20,85));
		pcolor1=pant_color[(int)random(3)];
		pcolor2=pant_color[(int)random(3)];
		scolor1=shoe_color[(int)random(3)];
		scolor2=shoe_color[(int)random(3)];

		anima=new FrameAnimation(vel);
		anima.is_loop=true;
		anima.Restart();

		uphand_joint=new ArrayList<PVector[]>();
		uphand_joint.add(new PVector[]{new PVector(_size.x/5,-_size.y*.4),new PVector(_size.x/5,-_size.y*.4)});
		uphand_joint.add(new PVector[]{new PVector(-_size.x/4,-_size.y*.9),new PVector(-_size.x/8,-_size.y*1.2)});
		uphand_joint.add(new PVector[]{new PVector(-_size.x/2,-_size.y/4),new PVector(-_size.x/2.5,-_size.y/4)});

		lowhand_joint=new ArrayList<PVector[]>();
		lowhand_joint.add(new PVector[]{new PVector(_size.x/4,_size.y*.2),new PVector(_size.x/4,_size.y*.4)});
		lowhand_joint.add(new PVector[]{new PVector(-_size.x/6,_size.y),new PVector(-_size.x/8,_size.y*1.2)});
		lowhand_joint.add(new PVector[]{new PVector(-_size.x/3,-_size.y/3),new PVector(-_size.x/2,_size.y)});

		upleg_joint=new ArrayList<PVector[]>();
		upleg_joint.add(new PVector[]{new PVector(_size.x,-_size.y*.65),new PVector(_size.x,-_size.y*.55)});
		upleg_joint.add(new PVector[]{new PVector(_size.x*1.4,_size.y*.5),new PVector(_size.x*1.4,-_size.y*.7)});
		upleg_joint.add(new PVector[]{new PVector(_size.x*1.8,-_size.y*.7),new PVector(_size.x*1.7,-_size.y*.9)});

		lowleg_joint=new ArrayList<PVector[]>();
		lowleg_joint.add(new PVector[]{new PVector(_size.x,_size.y*.3),new PVector(_size.x,_size.y*.3)});
		lowleg_joint.add(new PVector[]{new PVector(_size.x*1.3,_size.y*.86),new PVector(_size.x*1.5,_size.y*.8)});
		lowleg_joint.add(new PVector[]{new PVector(_size.x*1.5,_size.y*.2),new PVector(_size.x*1.8,_size.y*1.2)});

	}
	void draw(PGraphics pg){

		anima.Update();
		float tdraw=anima.GetPortion();
		int iport=anima.total_count%mstage;

		pg.pushStyle();
		// pg.noStroke();
		pg.fill(fcolor);

		pg.pushMatrix();
		pg.translate(_pos.x,_pos.y);
		
		pg.pushMatrix();
			pg.translate(0,-_size.x*1.5);
			pg.rotate(-tdraw*ang);
			pg.translate(0,_size.x*1.5);
		
			drawBody(pg);
			drawLeg(pg,tdraw,iport);

			drawHand(pg,tdraw,iport,true);
		pg.popMatrix();

			drawManLeg(pg,tdraw);

		pg.pushMatrix();
			pg.translate(0,-_size.x*1.5);
			pg.rotate(-tdraw*ang);
			pg.translate(0,_size.x*1.5);
		
			drawHand(pg,tdraw,iport,false);
			drawHead(pg);
		pg.popMatrix();

		pg.popMatrix();

		pg.popStyle();
	}
	void drawHand(PGraphics pg,float tdraw,int iport,boolean draw_front){
		float wid=_size.x/2;
		float hei=_size.y/3;
		pg.pushMatrix();
		pg.translate(0,_size.y/2);
			
			if(draw_front) drawAniSkel(pg,uphand_joint,hei,false,tdraw,iport);			
			else drawAniSkel(pg,lowhand_joint,hei,true,tdraw,iport);			
		

		pg.popMatrix();
	}
	void drawLeg(PGraphics pg,float tdraw,int iport){
		float wid=_size.x/2;
		float hei=_size.y/3;
		pg.pushMatrix();
		pg.translate(0,_size.y/2);
						
			drawAniSkel(pg,lowleg_joint,hei,true,tdraw,iport);			
			drawAniSkel(pg,upleg_joint,hei,false,tdraw,iport);			

		pg.popMatrix();
	}

	void drawAniSkel(PGraphics pg,ArrayList<PVector[]> aj,float wid,boolean is_left,float tdraw,int iport){
		PVector j1=PVector.lerp(aj.get(0)[iport%mstage],aj.get(0)[(iport+1)%mstage],tdraw);
		PVector j2=PVector.lerp(aj.get(1)[iport%mstage],aj.get(1)[(iport+1)%mstage],tdraw);
		PVector j3=PVector.lerp(aj.get(2)[iport%mstage],aj.get(2)[(iport+1)%mstage],tdraw);

		drawSkel(pg,j1,j2,j3,wid,is_left);
	}
	void drawHead(PGraphics pg){
		
		float rad=_size.x/3;
		float hseg1=.1;
		float hseg2=.55;

		pg.pushMatrix();
		pg.translate(_size.x/8,-_size.y/5);
			pg.beginShape();
				pg.vertex(0,0);
				pg.bezierVertex(-rad/4,0,-rad/4,rad*hseg1,
								-rad/2,rad*hseg1);
				pg.bezierVertex(-rad,rad*hseg1,-rad,rad*hseg2,
								-rad/2,rad*hseg2);
				pg.bezierVertex(rad,rad*hseg2,rad,0,
								rad/8,0);					
			pg.endShape(CLOSE);

			for(int i=0;i<2;++i){

				float tear=.5+.3*i;//.2*abs(sin((float)frameCount/50))+.7;
				float earx1=bezierPoint(-rad/2,rad,rad,rad/8,tear);
				float eary1=bezierPoint(-rad/3*2,rad,0,0,tear);
				
				float wid=.05;
				float earx2=bezierPoint(-rad/2,rad,rad,rad/8,tear+wid);
				float eary2=bezierPoint(-rad/3*2,rad,0,0,tear+wid);

				PVector dir=new PVector(earx2-earx1,eary2-eary1);
				dir.rotate(PI/2-PI/4*sin((float)frameCount/40));
				dir.setMag(rad*.4);

				pg.bezier(earx1,eary1,
						  earx1+dir.x,eary1+dir.y,earx2+dir.x,eary2+dir.y,		
						  earx2,eary2);
			}
		pg.popMatrix();
	}
	void drawBody(PGraphics pg){
		float rad=_size.x;
		float seg1=.15;
		float seg2=.25;

		pg.pushMatrix();
		pg.translate(_size.x*.05,_size.y/5);
			pg.beginShape();
				pg.vertex(0,0);
				pg.bezierVertex(0,-rad*seg1*.5,rad,-rad*seg1,
								rad,0);
				pg.bezierVertex(rad,rad*seg2,0,rad*seg2,
								0,0);
				
			pg.endShape(CLOSE);

			// float tear=.8;//.2*abs(sin((float)frameCount/50))+.7;
			// float earx1=bezierPoint(-rad/2,rad,rad,rad/8,tear);
			// float eary1=bezierPoint(-rad/3*2,rad,0,0,tear);
			
			// float wid=.05;
			// float earx2=bezierPoint(-rad/2,rad,rad,rad/8,tear+wid);
			// float eary2=bezierPoint(-rad/3*2,rad,0,0,tear+wid);

			// PVector dir=new PVector(earx2-earx1,eary2-eary1);
			// dir.rotate(PI/2+PI/5*sin((float)frameCount/40));
			// dir.setMag(rad*.4);

			// pg.bezier(earx1,eary1,
			// 		  earx1+dir.x,eary1+dir.y,earx2+dir.x,eary2+dir.y,		
			// 		  earx2,eary2);

		pg.popMatrix();
	}

	void drawSkel(PGraphics pg,PVector j1,PVector j2,PVector j3,float wid,boolean is_left){


		pg.beginShape();
			pg.vertex(j1.x,j1.y);
			pg.bezierVertex(j2.x,j2.y,
							j2.x,j2.y,
							j3.x,j3.y);
			
			PVector ctrl1=PVector.sub(j3,j2);
			PVector norm1=getNorm(PVector.sub(j2,j1)); 
			norm1.setMag(wid*.6);	

			ctrl1.setMag(wid);
			// ctrl1.rotate(PI/8);

			pg.bezierVertex(j3.x+ctrl1.x,j3.y+ctrl1.y,j3.x+norm1.x+ctrl1.x,j3.y+norm1.y+ctrl1.y,
							j3.x+norm1.x,j3.y+norm1.y);

			// PVector ctrl2=PVector.lerp(j1,j2,(is_left?.2:.8));
			// PVector norm2=getNorm(PVector.sub(j2,j1));
			// norm2.setMag(wid);
			
			norm1.setMag(wid*1.1);

			pg.bezierVertex(j2.x+norm1.x,j2.y+norm1.y,j2.x+norm1.x,j2.y+norm1.y,
							j1.x+norm1.x,j1.y+norm1.y);
			
			PVector ctrl2=PVector.sub(j1,j2);
			ctrl2.setMag(wid);
			ctrl2.rotate(-PI/7);

			// pg.bezierVertex(j1.x+ctrl2.x,j1.y+ctrl2.y,j1.x+ctrl2.x,j1.y+ctrl2.y,
			// 				j1.x,j1.y);

		pg.endShape();


	}
	void drawManLeg(PGraphics pg,float tdraw){
		
		// back leg
		pg.pushMatrix();
		pg.translate(-_size.x/8,_size.y*1.5);
			drawPantShoe(pg,tdraw*-ang,false);	
		pg.popMatrix();

		// front leg
		pg.pushMatrix();
		pg.translate(-_size.x,0);
			drawPantShoe(pg,tdraw*ang,true);
		pg.popMatrix();
	}
	void drawPantShoe(PGraphics pg,float rot,boolean front){
		float wid=_size.x/4;
		float hei=_size.x*1.5;
		float shei=_size.x/7;

		pg.pushStyle();
		if(front) pg.fill(pcolor1);
		else pg.fill(pcolor2);

		pg.pushMatrix();
		pg.translate(0,-hei);
		pg.rotate(rot);
		pg.translate(0,hei);
		
		pg.beginShape();
			pg.vertex(-wid,-hei);
			pg.bezierVertex(-wid*.2,-hei/2,-wid*.3,-hei/2,
							0,0);
			pg.vertex(-wid*1.2,0);
			pg.bezierVertex(-wid*1.2,-hei/2,-wid*1.6,-hei/2,
							-wid*2,-hei);			
		pg.endShape();

		if(front) pg.fill(scolor1);
		else pg.fill(scolor2);
		
		pg.beginShape();
			pg.vertex(-wid*.1,0);
			pg.vertex(0,shei*1.1);
			pg.bezierVertex(-wid*5,shei*1.2,-wid*4,shei/2,
							-wid,0);
			
		pg.endShape();

		pg.popMatrix();
		
		pg.popStyle();
	}


}

PVector getNorm(PVector pv){
	PVector norm=pv.get();
	norm.normalize();
	norm.rotate(HALF_PI);
	return norm;
}
