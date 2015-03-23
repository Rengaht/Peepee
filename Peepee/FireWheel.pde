class FireWheel{
	
	float x,y,rad;
	int mcurve;
	float phi;
	float phi2;
	FireWheel(float x_,float y_,float rad_){
		x=x_; y=y_; rad=rad_;
		mcurve=(int)random(8,15);

		phi=random(TWO_PI);
		phi2=random(TWO_PI);
	}
	void setPos(PVector pos){
		if(pos==null) return;
		x=pos.x; y=pos.y;
	}
	void draw(PGraphics pg,boolean draw_fill){
		float draw_portion=(sin((float)frameCount/5+phi));
		pg.pushStyle();
		if(draw_fill){
			pg.fill(255,phi/TWO_PI*255,0,255);
			pg.noStroke();
		}else{
			// pg.fill(255,255);
			pg.noFill();
			pg.stroke(255,200);
			// pg.strokeWeight(1);
		}

		pg.pushMatrix();
		pg.translate(x,y);
		float ang=(float)frameCount/4+phi;//q(sin(draw_portion))*PI/4+PI/6;
		//pg.translate(rad/2,0);
		
		//pg.translate(-rad/2,0);
		
			pg.beginShape();

				pg.vertex(rad/2,0);
				float etheta=TWO_PI/(float)mcurve;
				for(int i=0;i<=mcurve;++i){
					float theta=i*etheta;
					float random_strength1=random(1.5,5);
					float random_strength2=random(1.5,5);
					// if(theta>PI){
					// 	random_strength1*=2;
					// 	random_strength2*=2;
					// }
					if(theta>=PI/2 && theta<=PI/2*3){
						// pg.bezierVertex(rad/2*cos(theta+etheta)*random_strength1,rad/2*sin(theta+etheta)*random_strength1,
						// 			rad/2*cos(theta+etheta)*random_strength2,rad/2*sin(theta+etheta)*random_strength2,
						pg.vertex(rad/2*cos(theta+etheta/2)-rad*random(1.5,(draw_fill)?4.5:2.5)*(1-abs(theta-PI)/PI*2),rad/2*sin(theta+etheta/2));
						pg.vertex(rad/2*cos(theta)*random(0.5,2.5),rad/2*sin(theta));
					}else
						pg.vertex(rad/2*cos(theta)*random(0.5,1.5),rad/2*sin(theta));
				}
			pg.endShape();

		if(!draw_fill){ 
			pg.rotate(ang);
			pg.beginShape();
				pg.vertex(rad/2,0);
				// float etheta=TWO_PI/(float)mcurve;
				for(int i=0;i<=mcurve;++i){
					float theta=i*etheta;
					// float random_strength1=random(1,1.5);
					// float random_strength2=random(1,1.5);
					// pg.bezierVertex(rad/2*cos(theta+etheta/2)*random_strength1,rad/2*sin(theta+etheta/2)*random_strength1,
					// 				rad/2*cos(theta+etheta/2)*random_strength2,rad/2*sin(theta+etheta/2)*random_strength2,
					// 				rad/2*cos(theta)*random(.6,1),rad/2*sin(theta)*random(.6,1));
					pg.vertex(rad/2*cos(theta),rad/2*sin(theta));
				}
			pg.endShape();
			
			//float etheta=TWO_PI/(float)mcurve;
			for(int i=0;i<=mcurve;++i){
				float theta=i*etheta;
				pg.bezier(0,0,
						 rad/4*cos(theta+etheta/2),rad/4*sin(theta+etheta/2),
						 rad/4*cos(theta+etheta/2),rad/4*sin(theta+etheta/2),
						 rad/2*cos(theta)*random(.8,1),rad/2*sin(theta)*random(.8,1));

			}
		}
			
		pg.popMatrix();
		//for(int i=0;i<5;++i) drawTurb(x-random(width-x),random(-cur_wid,cur_wid),pg);
		pg.popStyle();
	}

}