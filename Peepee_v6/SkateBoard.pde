class SkateBoard{
	

	float x,y,wid,hei;
	float wheel_rad;
	float board_rad;

	int mwind=(int)random(2,5);


	SkateBoard(float x_,float y_,float wid_,float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		wheel_rad=random(.2,.5)*hei;
		board_rad=random(.2,.6)*wid;
	}

	void draw(PGraphics pg){

		float draw_portion=abs(sin((float)frameCount/80));
		pg.pushStyle();
		pg.fill(255);
		pg.stroke(0);
		pg.strokeWeight(1/TOTAL_SCALE);

		pg.pushMatrix();
		pg.translate(x,y);

		pg.beginShape();
			pg.vertex(0,0);
			pg.bezierVertex(-board_rad,0,-board_rad*1.3,hei,
						 0,hei);
			pg.bezierVertex(wid/3,hei+hei*.1*draw_portion,wid/3*2,hei+hei*.1*draw_portion,
						 wid,hei);
			pg.bezierVertex(wid+board_rad*1.3,hei,wid+board_rad,hei*.1*draw_portion,
						 wid,0);
			
			pg.bezierVertex(wid/3*2,hei*.1*draw_portion,wid/3*2,-hei*.1*draw_portion,
						 0,0);
		pg.endShape();

		drawWheel(0,hei+wheel_rad/2,pg);
		drawWheel(wid,hei+wheel_rad/2,pg);

		drawWind(-wid/2-wid/2.5,hei*1.5,wid/3,hei/2,pg);

		pg.popMatrix();

		pg.popStyle();
		
	}
	void drawWheel(float wx,float wy,PGraphics pg){
		pg.pushMatrix();
		pg.translate(wx,wy);
			for(int i=0;i<3;++i){
				float rad=wheel_rad/2;//-wheel_rad*i/10;
				pg.rotate((float)frameCount/2+i/2);
				pg.beginShape();
					pg.vertex(0,-rad/2);
					pg.bezierVertex(-rad,-rad/2,-rad,rad/2,
								 0,rad/2);
					pg.bezierVertex(rad,rad/2,rad,-rad/2,
								 0,-rad/2);
				pg.endShape();
			}
		pg.popMatrix();
	}

	void drawWind(float wx,float wy,float wwid,float whei,PGraphics pg){
		pg.pushMatrix();
			pg.translate(wx,wy);
			whei/=(float)3;
			for(int i=0;i<mwind;++i){
				wwid*=random(.5,2);
				pg.translate(wwid*.3*sin((float)frameCount),-whei);
				pg.beginShape();
					pg.vertex(wwid,0);
					pg.bezierVertex(wwid*random(.1,.5),whei*.1*random(-1,1),
								 wwid*random(.6,.9),whei*.1*random(-1,1),
								 0,0);

					// PVector ctrl=new PVector(-whei/2,0);
					// ctrl.rotate(PI*sin((float)frameCount));
					// pg.bezierVertex(-wwid/4*random(.5,1.5),0,
					// 			ctrl.x,ctrl.y-whei/4,
					// 			0,-whei/4);
					
				pg.endShape();
				pg.arc(0,-wwid/8,wwid/4,wwid/4,HALF_PI,PI/4+PI/2*3*sin((float)frameCount/2));
			}


		pg.popMatrix();
	}


}