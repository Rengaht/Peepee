class Helicopt{
	
	float wid,hei;
	int mwing;
	float ang_pos;
	float vel;
	float phi=random(TWO_PI);
	
	float hei_strength;
	float hei_base;
	float delta_hei;

	Helicopt(float wid_,float hei_){
		wid=wid_; hei=hei_;
		mwing=(int)random(3,5);
		ang_pos=random(TWO_PI);
		vel=TWO_PI/random(5,25);

		hei_strength=random(1,5)*hei;
		hei_base=random(.5,2)*hei;
		
	
	}

	void draw(PGraphics pg,boolean draw_fill,float x,float y){

		float draw_portion=(float)frameCount/10+phi;
		
		delta_hei=hei_strength*sin(draw_portion);
		float tail_hei=hei_base+hei_strength;	
		
		pg.pushStyle();
		if(!draw_fill){
			pg.noFill();
			pg.stroke(20,35,40);
		}else{
			pg.fill(184*random(.8,1.2),180);
			pg.noStroke();
		}
		pg.pushMatrix();
		pg.translate(x,y);
		if(!draw_fill){
			pg.beginShape();
				pg.vertex(0,0);
				pg.bezierVertex(wid/25*sin(draw_portion),-tail_hei/4,wid/32*sin(draw_portion),-tail_hei/3*2.5,
								0,-tail_hei);
			pg.endShape();
		
			pg.translate(0,-tail_hei);
			float eang=TWO_PI/(float)mwing;
			for(int i=0;i<mwing;++i){
				drawWing(pg,eang*i+ang_pos);
			}
		}else{

			pg.translate(0,-tail_hei);
			
			pg.beginShape();
			float eang=TWO_PI/(float)mwing/2;
			for(int i=0;i<mwing*2;++i){
				float ang_=i*eang+ang_pos;
				float rad_=random(-.1,1.1);
				PVector pos=new PVector(wid*cos(ang_),hei*sin(ang_)*abs((float)i/10));
				pg.vertex(pos.x,pos.y);
			}
			pg.endShape(CLOSE);
		}
		
		pg.popMatrix();

		pg.popStyle();
		
		ang_pos+=vel;

	}
	void drawWing(PGraphics pg,float ang){
		// PVector pos=new PVector(rad*cos(ang),rad*sin(ang));
		pg.beginShape();
			pg.vertex(0,0);
			int mvert=(int)random(3,8);
			for(int i=0;i<mvert;++i){
				float ang_=ang+random(-.05,.05)*TWO_PI/(float)mwing;
				float rad_=random(-.1,1.1);
				PVector pos=new PVector(wid*rad_*cos(ang_),hei*rad_*sin(ang_)*abs((float)i/10));
				pg.vertex(pos.x,pos.y);
			}
		pg.endShape();
	}

}