

class Cookie{

	float x,y,wid,hei;
	float[] wid_portion;
	color fc;
	int mchip;
	ArrayList<PVector> cookie_verts;
	ArrayList<PVector> chip_verts;

	Cookie(float x_,float y_,float wid_,float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		wid_portion=new float[4];
		for(int i=0;i<4;++i) wid_portion[i]=random(.8,1.2);

		fc=color(random(50,100)+150,random(20,40)+120,80);

		mchip=(int)random(4,9)*2;
		cookie_verts=new ArrayList<PVector>();
		chip_verts=new ArrayList<PVector>();

		float ac_ang=0;
		for(int i=0;i<mchip;++i){
			float tmp_ang=random(.4,1.6)*TWO_PI/(float)mchip;
			ac_ang=constrain(ac_ang+tmp_ang,0,TWO_PI);
			cookie_verts.add(new PVector(random(.8,1.2),ac_ang));
			
		}


		// chip_verts=new ArrayList<ArrayList<PVector>>();
		// for(int i=0;i<mchip;++i){
		// 	ArrayList<PVector> tmp=new ArrayList<PVector>();
		// 	int mv=(int)random(4,8);
		// 	PVector center=new PVector(random(wid),random(hei));
		// 	float rad=random(mag(wid,hei)/2-center.dist(new PVector(x,y)));

		// 	float theta=0;
		// 	for(int x=0;x<mv;++x){
		// 		theta+=random(PI/(float)mv);
		// 		float rp=random(.5,1.8);
		// 		tmp.add(new PVector(center.x+rad*rp*sin(theta),center.y+rad*rp*cos(theta)));
		// 	}
		// 	chip_verts.add(tmp);
		// }

	}

	void draw(PGraphics pg,boolean draw_fill){
		
		float draw_portion=abs(sin((float)frameCount/30));

		pg.pushStyle();
		if(draw_fill){
			pg.noStroke(); pg.fill(fc);
		}else{
			pg.stroke(0); pg.noFill();
		}

		pg.pushMatrix();
		pg.translate(x,y);
			for(int i=0;i<mchip;++i){
			
				pg.beginShape();
			// pg.vertex(0,-hei/3*draw_portion);
			// pg.bezierVertex(-wid*wid_portion[0],-hei/3*draw_portion,-wid*wid_portion[1],hei+hei/3*draw_portion,
			// 			.0,hei+hei/3*draw_portion);

			// pg.bezierVertex(wid*wid_portion[2],hei+hei/3*draw_portion,wid*wid_portion[3],-hei/3*draw_portion,
			// 			.0,-hei/3*draw_portion);
				
			
				float rad=wid*cookie_verts.get(i).x;
				float ang=cookie_verts.get(i).y;
				float arc_strength=rad/8*draw_portion;

			pg.pushMatrix();
			// pg.translate(rad*sin(ang),rad*cos(ang));
			// pg.rotate(PI*draw_portion);	
			// pg.translate(-rad*sin(ang),-rad*cos(ang));
			
				PVector orig=new PVector(arc_strength*2*sin(ang),arc_strength*2*cos(ang));
				pg.vertex(orig.x,orig.y);

				// pg.vertex(rad*sin(ang),rad*cos(ang));
				
				PVector ctrl=new PVector(rad/2*sin(ang),rad/2*cos(ang));
				ctrl.add(new PVector(arc_strength*cos(ang),-arc_strength*sin(ang)));
				
				pg.bezierVertex(ctrl.x,ctrl.y,ctrl.x,ctrl.y,
								rad*sin(ang),rad*cos(ang));

				float rad2=wid*cookie_verts.get((i+1)%mchip).x;
				float ang2=cookie_verts.get((i+1)%mchip).y;
				
				pg.vertex(rad2*sin(ang2),rad2*cos(ang2));
				
				PVector ctrl2=new PVector(rad2/2*sin(ang2),rad2/2*cos(ang2));
				ctrl2.add(new PVector(-arc_strength*cos(ang2),arc_strength*sin(ang2)));
				

				pg.bezierVertex(ctrl2.x,ctrl2.y,ctrl2.x,ctrl2.y,
								orig.x,orig.y);
		
				pg.endShape(CLOSE);
			pg.popMatrix();
			}	

		if(draw_fill) for(PVector vs:chip_verts) drawChip(pg,vs);

		pg.popMatrix();



	}


	void drawChip(PGraphics pg,PVector vert){
		pg.pushStyle();
			// pg.fill(red(fc)/2,green(fc)/2,blue(fc)/2);

			// pg.pushMatrix();
			// // pg.translate(cx,cy);
			// 	pg.beginShape();
			// 		for(PVector v: vertices) pg.vertex(v.x,v.y);
			// 	pg.endShape(CLOSE);
			// pg.popMatrix();

		pg.popStyle();
	}


}