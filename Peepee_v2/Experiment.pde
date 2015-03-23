class Experiment{
		
	float x,y,wid,hei;


	float phi=random(TWO_PI);
	float vel=random(1,15);

	Experiment(float x_,float y_,float wid_,float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;

	}

	void draw(PGraphics pg){
		float draw_portion=(float)frameCount/vel+phi;
		draw_portion%=TWO_PI;
		
		pg.pushStyle();
		pg.noFill();
		pg.stroke(0);

		pg.pushMatrix();
		pg.translate(x,y);
		pg.beginShape();
			pg.vertex(0,0);
			pg.bezierVertex(wid/3*sin(draw_portion),-hei/5,
							wid/2*sin(draw_portion),-y,
							wid/4*sin(draw_portion),-hei);
		pg.endShape();
		pg.popMatrix();

		pg.popStyle();
	}

}

class Machine2{
	
	float dest_x;
	float dest_y;
	float dest_strength;
	float vel;
	float phi;
	float cur_x=width/2,cur_y;
	float delta_y;

	float wid=50;
	float hei=120;

	boolean isSet=false;

	Machine2(){

	}
	
	void draw(PGraphics pg,boolean draw_fill){
		pg.pushStyle();
		if(draw_fill){
			pg.noStroke(); pg.fill(120);
		}else{
			pg.noFill(); pg.stroke(0);
		}
		
		

		if(isSet){
			
			float frame_portion=(float)(frameCount-0)/vel+phi;
			frame_portion%=(TWO_PI);
			int draw_stage=floor(frame_portion/(PI/2));
			if(draw_stage<1){
				isSet=false;
				// println("dest unlock!");
			}
			delta_y=(height-hei-dest_y-dest_strength)*sin(frame_portion);
			// println(dest_x+"-"+tmp_y);

			if(cur_x!=dest_x) cur_x+=(dest_x-cur_x)/8;
		}else delta_y=0;

		
		float draw_portion=-abs(sin((float)frameCount/(50)));

		pg.pushMatrix();
		pg.translate(hei,0);
		float tmp_hei=height-hei+delta_y;
		pg.beginShape();
			pg.vertex(cur_x+wid,height);
			pg.vertex(cur_x+wid,tmp_hei+hei);
			pg.bezierVertex(cur_x+wid,tmp_hei+hei-hei*.55+hei/15*draw_portion,
							cur_x+wid-hei+hei*.55,tmp_hei+hei/5*draw_portion,
							cur_x+wid-hei*1.2,tmp_hei-hei/12);
			pg.bezierVertex(cur_x+wid-hei*.9,tmp_hei-hei/12,
							cur_x+wid-hei*.85,tmp_hei+wid-hei/12,
							cur_x+wid-hei,tmp_hei+wid);
			pg.bezierVertex(cur_x+wid-hei+(hei-wid)*.65,tmp_hei+wid,
							cur_x,tmp_hei+hei-(hei-wid)*.55,
							cur_x,tmp_hei+hei+hei/12*draw_portion);
			
			pg.bezierVertex(cur_x,tmp_hei+hei,
							cur_x,tmp_hei+hei,
							cur_x-wid/2,height+hei);

			// pg.vertex(cur_x,tmp_hei-hei);
			
		pg.endShape();
		pg.translate(cur_x+wid-hei*1.2,tmp_hei);
		if(draw_fill) pg.fill(125,0,0);

		pg.beginShape();
			pg.vertex(0,-hei/12);
			pg.bezierVertex(hei/2*(1-.2),-hei/12,
							hei/2*(1-.2),hei/2,
							0,hei/2);
			pg.bezierVertex(-hei/2*(1-.2),hei/2,
							-hei/2*(1-.5),-hei/12,
							0,-hei/12);
		pg.endShape();
		// pg.fill(255);
		// pg.translate(0,hei/25);
		// pg.beginShape();
		// 	pg.vertex(0,hei/12*draw_portion);
		// 	pg.bezierVertex(hei/2*(1+.05*draw_portion),0,
		// 					hei/2*(1+.05*draw_portion),hei/2,
		// 					0,hei/2);
		// 	pg.bezierVertex(-hei/2*(1+.05*draw_portion),hei/2,
		// 					-hei/2*(1+.05*draw_portion),0,
		// 					0,hei/12*draw_portion);
		// pg.endShape();


		pg.popMatrix();
		pg.popStyle();
	}

	void update(float x_,float y_,float strength_,float vel_,float phi_){
		if(!isSet){
			if(x_>width) return;
			cur_x=dest_x; cur_y=dest_y;

			dest_x=x_; dest_y=y_; vel=vel_; phi=phi_;
			dest_strength=strength_;
			isSet=true;
			// println("dest set!");
		}
	}
}