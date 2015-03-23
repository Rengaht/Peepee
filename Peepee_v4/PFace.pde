
class PFace{
	
	float x,y,wid,hei;
	float ani_vel,ani_phi;
	color fcolor;	

	PFace(float x_,float y_,float wid_,float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		fcolor=color(255,random(200,230),random(180,200));
		
		ani_vel=random(20,40);
		ani_phi=random(TWO_PI);

	}

	void draw(PGraphics pg, boolean draw_fill){
		pg.pushStyle();
		
		if(draw_fill){
		 	pg.noStroke();
		 	pg.fill(fcolor);
		}else{
		 	// pg.noFill();
		 	pg.fill(fcolor);
			pg.stroke(80); 
		}

		pg.pushMatrix();
		pg.translate(x+wid/2,y);

		pg.beginShape();
			PVector ear_ctrl=new PVector(hei/8,0);
			ear_ctrl.rotate(PI/12);
			
			pg.vertex(-wid/2,-hei/5);
			pg.vertex(-wid/2,0);
			pg.bezierVertex(-wid/2-ear_ctrl.x,-ear_ctrl.y,-wid/2-ear_ctrl.x,hei/5+ear_ctrl.y,
							-wid/2,hei/5);
			
			PVector face_ctrl=new PVector(0,hei/2);
			face_ctrl.rotate(-PI/12);
			pg.bezierVertex(-wid/2+face_ctrl.x,hei/5+face_ctrl.y,wid/2-face_ctrl.x,hei/5+face_ctrl.y,
							wid/2,hei/5);
			pg.bezierVertex(wid/2+ear_ctrl.x,hei/5+ear_ctrl.y,wid/2+ear_ctrl.x,-ear_ctrl.y,
							wid/2,0);

			pg.vertex(wid/2,-hei/5);

		pg.endShape();


		pg.popMatrix();

		pg.popStyle();

	}


}