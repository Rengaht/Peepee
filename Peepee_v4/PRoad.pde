
class PRoad extends PPart{
	
	color fcolor;

	PRoad(float x_,float y_,float wid_,float hei_){
		super(x_,y_,wid_,hei_);
		fcolor=color(random(150,180));
		ani_vel=random(80,120);
	}

	void draw(PGraphics pg,boolean draw_fill){

		float draw_portion=sin(getDrawAngle()%HALF_PI);
		if(random(500)<1) draw_portion*=(1+.3*draw_portion);

		pg.pushStyle();
		
		if(draw_fill){
		 	pg.noStroke();
		 	pg.fill(fcolor);
		}else{
		 	// pg.fill(fcolor);
		 	pg.noFill();
		 	pg.noStroke(); 
		}
		pg.pushMatrix();
		pg.translate(x+wid/2,y);

		pg.beginShape();
		float sh_p=.5;
		pg.vertex(-wid/2*sh_p,0);
		pg.vertex(-wid/2,hei);

		pg.vertex(wid/2,hei);
		pg.vertex(wid/2*sh_p,0);
		
		pg.endShape(CLOSE);
		
		if(draw_fill) pg.fill(255);
		else pg.noStroke();

		float sign_pos=hei-hei*abs(draw_portion);
		float sign_w=wid/10;
		pg.beginShape();
			pg.vertex(-sign_w*.3,0);
			pg.vertex(sign_w*.3,0);
			pg.vertex(sign_w*lerp(.3,1,sign_pos/hei),sign_pos);
			pg.vertex(-sign_w*lerp(.3,1,sign_pos/hei),sign_pos);
		pg.endShape();

		if(sign_pos+sign_w*3<hei){
		pg.beginShape();
			pg.vertex(-sign_w*lerp(.3,1,sign_pos/hei),sign_pos+sign_w*3);
			pg.vertex(sign_w*lerp(.3,1,sign_pos/hei),sign_pos+sign_w*3);
			pg.vertex(sign_w,hei);
			pg.vertex(-sign_w,hei);
		pg.endShape();
		}

		pg.popMatrix();
		pg.popStyle();
	}





}