final int MANG=7;

class Slice{

	float start_ang;
	float end_ang;
	float dest_end_ang;

	float rad_ratio=random(.1,1);
	float thick_ratio=random(.01,.05);
	float vel=PI/random(10,120);
	float phi=random(PI);

	Slice(){
		start_ang=random(TWO_PI);
		dest_end_ang=random(PI/2,PI*3/2);
		end_ang=0;
	}
	void draw(PGraphics pg,float cur_rad){

		pg.pushStyle();
		// noFill();
		// stroke(255);

		pg.pushMatrix();
		// scale(cur_rad);

		boolean pulse=random(15)<1;
		int start_corner=(pulse)?floor(start_ang/(TWO_PI/MANG*2)):floor(start_ang/(TWO_PI/MANG));
		int end_corner=(pulse)?floor((start_ang+end_ang)/(TWO_PI/MANG*2)):floor((start_ang+end_ang)/(TWO_PI/MANG));

		
		if(pulse){
			pg.stroke(144,0,144);
			pg.fill(144,0,144,80);
		}else{
			pg.stroke(127,255,212);
			pg.fill(127,255,212,20);
		}
		pg.beginShape();
			// vertex(0,0);
			PVector svert=getInterPoint(cur_rad*rad_ratio,start_ang);
			pg.vertex(svert.x,svert.y);

			if(end_corner>start_corner){
				for(int i=start_corner+1;i<=end_corner;++i){
					PVector cvert=new PVector(cur_rad*(rad_ratio)*sin(i*((pulse)?(TWO_PI/MANG*2):(TWO_PI/MANG))),cur_rad*(rad_ratio)*cos(i*((pulse)?(TWO_PI/MANG*2):(TWO_PI/MANG))));
					pg.vertex(cvert.x,cvert.y);
				}
			}

			PVector evert=getInterPoint(cur_rad*rad_ratio,start_ang+end_ang);
			pg.vertex(evert.x,evert.y);
			
			PVector evert2=getInterPoint(cur_rad*(rad_ratio-thick_ratio),start_ang+end_ang);
			pg.vertex(evert2.x,evert2.y);
			
			if(end_corner>start_corner){
				for(int i=end_corner;i>=start_corner+1;--i){
					PVector cvert=new PVector(cur_rad*(rad_ratio-thick_ratio)*sin(i*((pulse)?(TWO_PI/MANG*2):(TWO_PI/MANG))),cur_rad*(rad_ratio-thick_ratio)*cos(i*((pulse)?(TWO_PI/MANG*2):(TWO_PI/MANG))));
					pg.vertex(cvert.x,cvert.y);
				}
			}

			PVector svert2=getInterPoint(cur_rad*(rad_ratio-thick_ratio),start_ang);
			pg.vertex(svert2.x,svert2.y);


		pg.endShape(CLOSE);

		pg.popMatrix();
		pg.popStyle();
		start_ang+=vel*sin((float)frameCount/50+phi);
		// vel*=1.01;
		// if(vel>PI/5) vel=PI/random(5,120);
		end_ang=dest_end_ang*abs(sin((float)frameCount/50+phi));
		
	}
	PVector getInterPoint(float rad,float ang){
		// println(rad+" "+ang);

		
		float start_corner=floor(ang/(TWO_PI/MANG))*TWO_PI/MANG;
		float end_corner=ceil(ang/(TWO_PI/MANG))*TWO_PI/MANG;
		PVector cstart=new PVector(rad*sin(start_corner),rad*cos(start_corner));
		PVector cend=new PVector(rad*sin(end_corner),rad*cos(end_corner));

		// stroke(255,0,0);
		// line(cstart.x,cstart.y,cend.x,cend.y);
		
		return PVector.lerp(cstart,cend,(ang-start_corner)/(end_corner-start_corner));
	}
}