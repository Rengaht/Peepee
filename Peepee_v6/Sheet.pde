class SpaceSheet{
	
	float x,y,wid,hei;		
	float vel,phi;
	PShape _shape;


	SpaceSheet(float x_,float y_,float wid_,float hei_,float phi_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		phi=phi_;
		vel=100;

		float draw_portion=1;

		_shape=createShape();
		_shape.setFill(color(20,phi*125*random(.8,1.2),phi/TWO_PI*20+180));
		_shape.beginShape();
				_shape.normal(-1,0,0);
				_shape.vertex(0,0);
				_shape.bezierVertex(wid/8,-hei/8*draw_portion,
							wid/8,-hei/8*draw_portion,
							wid/4,-hei/12);
				_shape.bezierVertex(wid/4,-hei/3-hei/6*draw_portion,
							wid/4*3+wid/8,-hei/4-hei/6*draw_portion,
							wid/4*3,-hei/12);
				_shape.bezierVertex(wid/8*7,-hei/8*draw_portion,
							wid/8*7,-hei/8*draw_portion,
							wid,-hei/12);
				_shape.bezierVertex(wid/8*7,hei/5+hei/7*draw_portion,
							 wid/2*sin(phi),hei/4+hei/7*draw_portion,
							 0,0);
				_shape.bezierVertex(wid/8,hei/8*draw_portion,
							wid/8,hei/8*draw_portion,
							wid/4,hei/12);
				_shape.bezierVertex(wid/4,hei/3+hei/16*draw_portion,
							wid/4*3+wid/8,hei/4+hei/6*draw_portion,
							wid/4*3,hei/12);
				_shape.bezierVertex(wid/12*7,hei/8*draw_portion,
							wid/12*11,hei/11*draw_portion,
							wid,0);

			_shape.endShape();

	}

	void draw(PGraphics pg){
		// draw(pg,false);
	}
	void draw(PGraphics pg,PGL pgl,boolean back_side){


		if(back_side){
			_shape.setFill(color(20,phi*125*random(.8,1.2),phi/TWO_PI*20+180));
			// pgl.disable(PGL.CULL_FACE);	
		} 
		else{
			_shape.setFill(color(120,phi*25*random(.8,1.2),phi/TWO_PI*20+180));	
			// pgl.enable(PGL.CULL_FACE);	
		} 

		float tdraw=sin((float)frameCount/vel+phi);

		// pg.rotateY(tdraw*TWO_PI);
		pg.shape(_shape,0,0);

		// endPGL();

		// pg.pushStyle();
		// pg.fill(20,125,180);
		// pg.textureMode(NORMAL);

		// pg.pushMatrix();
		// pg.translate(x,y);

		// 	pg.beginShape();
		// 		// pg.texture(img_tex);
		// 		// pg.normal(-sin(tdraw*TWO_PI),0,-cos(tdraw*TWO_PI));
		// 		// pg.normal(1,0,0);
		// 		pg.vertex(wid*sin(tdraw*TWO_PI),0,wid*cos(tdraw*TWO_PI),0,0);
		// 		pg.vertex(wid*sin(tdraw*TWO_PI),hei,wid*cos(tdraw*TWO_PI),0,1);
		// 		pg.vertex(wid*sin(tdraw*TWO_PI+PI/3),hei,wid*cos(tdraw*TWO_PI+PI/3),1,1);
		// 		pg.vertex(wid*sin(tdraw*TWO_PI+PI/3),0,wid*cos(tdraw*TWO_PI+PI/3),1,0);				
		// 	pg.endShape();


		// 	// pg.fill(220,225,20);
		// 	// pg.beginShape();
		// 	// 	pg.vertex(wid*.95*sin(tdraw*TWO_PI),0,wid*.95*cos(tdraw*TWO_PI));
		// 	// 	pg.vertex(wid*.95*sin(tdraw*TWO_PI),hei,wid*.95*cos(tdraw*TWO_PI));
		// 	// 	pg.vertex(wid*.95*sin(tdraw*TWO_PI+PI/3),hei,wid*.95*cos(tdraw*TWO_PI+PI/3));
		// 	// 	pg.vertex(wid*.95*sin(tdraw*TWO_PI+PI/3),0,wid*.95*cos(tdraw*TWO_PI+PI/3));				
		// 	// pg.endShape();

		// pg.popMatrix();

		// pg.popStyle();

	

	}


}