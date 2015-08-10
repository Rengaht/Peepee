
class FPAnimal extends PPart{
	
	color fcolor;	
	PRoad road;
	
	FPAnimal(float x_,float y_,float wid_,float hei_){
		super(x_,y_,wid_,hei_);
		// fcolor=color(random(150,255),random(20,80)+150,random(120,185));
		fcolor=color(205+random(-10,10),186,150);

		road=new PRoad(-wid/1.2,hei/3,wid*2,hei*2);
	}

	void draw(PGraphics pg,boolean draw_fill){
		
		float draw_portion=getDrawPortion();
		if(random(500)<1) draw_portion*=(1+.3*draw_portion);

		pg.pushStyle();
		
		if(draw_fill){
		 	pg.noStroke();
		 	pg.fill(fcolor);
		}else{
		 	// pg.fill(fcolor);
		 	pg.noFill();
		 	pg.stroke(80); 
		}

		pg.pushMatrix();
		pg.translate(x,y);

		// pface.draw(pg,draw_fill);
		road.draw(pg,draw_fill);

		// drawBody(pg,draw_fill,-wid/4,0,wid,hei*.9,draw_portion);
		drawBodyRun(pg,draw_fill,-wid/4,0,wid,hei*.9,draw_portion);
		drawHead(pg,draw_fill,wid*.05,0,wid*.35,hei*(.35+.02*draw_portion),draw_portion);

		
		pg.popMatrix();

		pg.popStyle();

	}
	void drawHead(PGraphics pg,boolean draw_fill,float hx,float hy,float hw,float hh,float draw_portion){
		
		// if(!draw_fill) pg.fill(fcolor);

		pg.pushMatrix();
		pg.translate(hx+hw/2,hy);

		pg.beginShape();
			PVector face_ctrl=new PVector(0,hh/3*(1+.2*abs(draw_portion)));
			face_ctrl.rotate(PI/24);		

			pg.vertex(-hw/2.5,0);
			// pg.bezierVertex(-hw/2+face_ctrl.x,face_ctrl.y,-face_ctrl.x,hh,
			// 				0,hh);
			// pg.bezierVertex(-face_ctrl.x,hh,hw/2-face_ctrl.x,hh,
			// 				hw/2,0);
			pg.bezierVertex(-hw/2+face_ctrl.x,face_ctrl.y,-hw/3,hh/5*3,
							-hw/3,hh/5*3);
			pg.bezierVertex(-hw/3*random(.95,1.08),hh/6*5,-hw/3,hh/8*7,
							0,hh);
			pg.bezierVertex(hw/3,hh,hw/3,hh/4*3,
							hw/3,hh/7*4);

			pg.bezierVertex(hw/3*random(.95,1.08),hh/7*4,hw/2-face_ctrl.x,face_ctrl.y,
							hw/2.5,0);

			PVector ear_ctrl=new PVector(0,-hh/4);
			ear_ctrl.rotate(PI/15-PI/22*draw_portion);

			pg.bezierVertex(hw/2-ear_ctrl.x,ear_ctrl.y,hw/3-ear_ctrl.x,ear_ctrl.y,
							hw/3,0);
			pg.bezierVertex(hw/4,-hh/5,-hw/4,-hh/8,
							-hw/3,0);
			pg.bezierVertex(-hw/3-ear_ctrl.x*1.2,ear_ctrl.y,-hw/2-ear_ctrl.x*.9,ear_ctrl.y,
							-hw/2,0);
		pg.endShape();

		pg.popMatrix();

		
	}
	void drawBody(PGraphics pg,boolean draw_fill,float bx,float by,float bw,float bh,float draw_portion){
		pg.pushMatrix();
		pg.translate(bx+bw/2,by);

		pg.beginShape();
			PVector body_ctrl=new PVector(0,bh);
			body_ctrl.rotate(PI/24);		
			float fw=bw/10;
			float lf_h=bh*(1+.3*draw_portion);
			float rf_h=bh*(1-.2*draw_portion);

			float bf_pos=bw/2.5*(1+.1*draw_portion);
			float ff_pos=bw/4*(1+.3*draw_portion);
			float w_pos=bw/3;
			float h_pos=bw/1.7*(1+.2*draw_portion);

			if(!draw_fill) pg.vertex(-bw/5,0);
			else pg.vertex(0,0);

			pg.bezierVertex(-bw/5,0,-ff_pos,0,
							-ff_pos+fw/2,lf_h);
			pg.vertex(-ff_pos-fw/2,lf_h);
			pg.bezierVertex(-ff_pos-fw,bh/6,-w_pos*1.3,-bh/6,
							-w_pos,-bh/6);

			pg.bezierVertex(-w_pos,-bh/6,-bf_pos*1.2,0,
							-bf_pos,lf_h*.8);

			pg.vertex(-bf_pos-fw,lf_h*.8);
			pg.bezierVertex(-bf_pos-fw*2,0,-h_pos,-bh/2,
							0,-bh/2);
			PVector tail_ctrl=new PVector(0,-bh/4);
			tail_ctrl.rotate(PI/25*abs(draw_portion));
			pg.bezierVertex(tail_ctrl.x,-bh/2+tail_ctrl.y,tail_ctrl.x*2,-bh/2+tail_ctrl.y,
							tail_ctrl.x,-bh/2+tail_ctrl.x);

			pg.bezierVertex(h_pos*1.2,-bh/2,bf_pos+fw*2,0,
							bf_pos,rf_h*.8);

			pg.vertex(bf_pos-fw,rf_h*.8);
			pg.bezierVertex(bf_pos,0,w_pos,-bh/6,
							w_pos,-bh/6);

			pg.bezierVertex(w_pos+fw,bh/3,ff_pos*1.2,bh/2,
							ff_pos-fw/2,rf_h);

			pg.vertex(ff_pos-fw*3/2,rf_h);
			if(draw_fill) pg.bezierVertex(ff_pos-fw,0,bw/5,0,
							   			   0,0);
			else pg.bezierVertex(ff_pos-fw,0,bw/5,0,
							   	 bw/5,0);

		pg.endShape();

		drawBackTexture(pg,draw_fill,bh,bf_pos,fw,h_pos);

		pg.popMatrix();

	}
	void drawBodyRun(PGraphics pg,boolean draw_fill,float bx,float by,float bw,float bh,float draw_portion){
		pg.pushMatrix();
		pg.translate(bx+bw/2,by);

		pg.beginShape();
			PVector body_ctrl=new PVector(0,bh);
			body_ctrl.rotate(PI/24);		
			float fw=bw/10;
			float lf_h=bh*(.7+.3*draw_portion);
			float rf_h=bh*(1-.2*draw_portion);

			float bf_pos=bw/2.5*(1+.1*draw_portion);
			float ff_pos=bw/4*(1+.3*draw_portion);
			float w_pos=bw/3;
			float h_pos=bw/1.7*(1+.2*draw_portion);

			if(!draw_fill) pg.vertex(-bw/5,0);
			else pg.vertex(0,0);

			// left_front_foot
			PVector bend_ctrl=new PVector(ff_pos,0);
			bend_ctrl.rotate(-PI/8*(draw_portion));
			pg.bezierVertex(-bw/5-bend_ctrl.x,bh/6+bend_ctrl.y,
				            -bend_ctrl.x,bh/6+bend_ctrl.y,
							-ff_pos+fw/2,lf_h);
			pg.vertex(-ff_pos-fw/2,lf_h);
			pg.bezierVertex(-ff_pos-fw-bend_ctrl.x,bh/6+bend_ctrl.y,
				 			-w_pos*1.3-bend_ctrl.x,-bh/6+bend_ctrl.y,
							-w_pos,-bh/6);

			// left_back_foot
			pg.bezierVertex(-w_pos,-bh/6,-bf_pos*1.2,0,
							-bf_pos,lf_h*.8);

			pg.vertex(-bf_pos-fw,lf_h*.8);
			pg.bezierVertex(-bf_pos-fw*2,0,-h_pos,-bh/2,
							0,-bh/2);

			PVector tail_ctrl=new PVector(0,-bh/4);
			tail_ctrl.rotate(PI/25*abs(draw_portion));
			pg.bezierVertex(tail_ctrl.x,-bh/2+tail_ctrl.y,tail_ctrl.x*2,-bh/2+tail_ctrl.y,
							tail_ctrl.x,-bh/2+tail_ctrl.x);

			// right_back_foot
			pg.bezierVertex(h_pos*1.2,-bh/2,bf_pos+fw*2,0,
							bf_pos,rf_h*.8);

			pg.vertex(bf_pos-fw,rf_h*.8);
			pg.bezierVertex(bf_pos,0,w_pos,-bh/6,
							w_pos,-bh/6);


			// right_front_foot
			pg.bezierVertex(w_pos+fw,bh/3,ff_pos*1.2,bh/2,
							ff_pos-fw/2,rf_h);

			pg.vertex(ff_pos-fw*3/2,rf_h);
			if(draw_fill) pg.bezierVertex(ff_pos-fw,0,bw/5,0,
							   			   0,0);
			else pg.bezierVertex(ff_pos-fw,0,bw/5,0,
							   	 bw/5,0);

		pg.endShape();

		drawBackTexture(pg,draw_fill,bh,bf_pos,fw,h_pos);

		pg.popMatrix();

	}
	void drawBackTexture(PGraphics pg,boolean draw_fill,float bh,float bf_pos,float fw,float h_pos){
		
		if(draw_fill){
			pg.pushStyle();
			pg.stroke(red(fcolor)/1.1,green(fcolor)/1.1,blue(fcolor)/1.3,120);
			pg.noFill();
			pg.beginShape();
			for(int i=0;i<80;++i){
					float tmp_t=random(.3,1);
					float tmp_y=bezierPoint(bh*.8,0,-bh/2,-bh/2,tmp_t);
					float tmp_x=bezierPoint(-bf_pos-fw,-bf_pos-fw,-h_pos,0,tmp_t);


					pg.vertex(random(tmp_x,-tmp_x),tmp_y*random(.7,1));
					pg.vertex(tmp_x*random(.9,1.05),tmp_y);
					// pg.vertex(random,tmp_y);			
			}
			pg.endShape();
			pg.popStyle();
		}		
	}
	void drawBezier(float x1,float y1,float x2,float y2){

	}
}