

class SwimWater{
	

	float x,y,wid,hei;
	int mcurve;
	float phi;

	SwimWater(float x_,float y_,float wid_, float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		mcurve=(int)random(8,15);

		phi=random(TWO_PI);
	}

	void draw(PGraphics pg,boolean draw_fill){
		float draw_portion=abs(sin((float)frameCount/50+phi));
		pg.pushStyle();
		if(draw_fill){
			pg.fill(255,120);
			pg.noStroke();
		}else{
			pg.fill(255);
			pg.stroke(0);
		}

		pg.pushMatrix();
		pg.translate(x,y);
		float ang=PI/10;//q(sin(draw_portion))*PI/4+PI/6;
		pg.translate(wid/2,0);
		pg.rotate(ang);
		pg.translate(-wid/2,0);
		
			pg.beginShape();
			pg.vertex(0,0);

			float cur_wid=wid+wid*.2*abs(sin(draw_portion));
			for(int i=1;i<mcurve;++i){
				// pg.bezierVertex((i-1)*cur_wid/(float)mcurve,hei*(1+random(-.8,.8)),
				// 			 i*cur_wid/(float)mcurve,hei*(1+random(-.8,.8)),
				// 			 i*cur_wid/(float)mcurve,random(-.6,.6));
				pg.vertex(i*cur_wid/(float)mcurve,random(-.6,.6));
			}

			// PVector border1=new PVector(-width+x,0);
			// PVector border2=new PVector(-width+x,cur_wid*sin(ang));
			// border1.rotate(-ang);
			// border2.rotate(-ang);
			
			
			// pg.vertex(border2.x,border2.y);
			// pg.vertex(border1.x,border1.y);
			for(int i=1;i<mcurve;++i){
				PVector border=new PVector(-width/4*(1+draw_portion)*abs(sin((float)i/4)*random(.4,1))+x,(mcurve-i)*cur_wid/(float)mcurve);
				border.rotate(-ang);
				// pg.bezierVertex((i-1)*cur_wid/(float)mcurve,hei*(1+random(-.4,.4)),
				// 			 i*cur_wid/(float)mcurve,hei*(1+random(-.4,.4)),
				pg.vertex(border.x,border.y);
			}
			pg.endShape(CLOSE);

			
		pg.popMatrix();
		//for(int i=0;i<5;++i) drawTurb(x-random(width-x),random(-cur_wid,cur_wid),pg);
		pg.popStyle();

	}


	void drawTurb(float tx,float ty,PGraphics pg){
		pg.pushStyle();
		pg.noFill();
		pg.stroke(255);

		int mturb=(int)random(5,20);
		float turbw=random(.1,.2)*wid;
		pg.pushMatrix();
		pg.translate(tx,ty);
		pg.beginShape();
			pg.vertex(0,0);
			for(int i=0;i<mturb;++i)
				pg.bezierVertex((i+1)*turbw*random(0.5,1.5),turbw*random(0.5,1.5),
								(i-1)*turbw*random(0.5,1.5),turbw*random(0.5,1.5),
								i*turbw,0);

		pg.endShape();
		pg.popMatrix();
		pg.popStyle();
	}

}