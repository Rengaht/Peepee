
class MeatTexture{
	
	float x,y,wid,hei;
	color fcolor;
	int mspot;
	float spot_w,spot_h;

	float spot_angle;
	// PGraphics pg;
	ArrayList<PVector> spot_sizes;
	int mspot_v;
	int mspot_h;

	MeatTexture(float x_,float y_,float wid_,float hei_,color f_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		fcolor=f_;//color(random(100,255),random(20,80)+100,random(20,85));
		mspot=(int)random(20,60);
		spot_angle=random(PI/4,PI/2);

		// pg=createGraphics((int)wid,(int)hei);

		spot_w=wid/random(8,12);
		spot_h=hei/random(4,12);

		spot_sizes=new ArrayList<PVector>();
		mspot_v=(int)(wid/spot_w);
		mspot_h=(int)(wid/spot_h);
		
		
		for(int i=0;i<mspot_v;++i){
			for(int j=0;j<mspot_h;++j){
				spot_sizes.add(new PVector(spot_w*random(1,2),spot_h*random(1,2)));
				//spot_sizes.add(new PVector(spot_w,spot_h));
			}
		}	
	}	

	void draw(){
		
		//println("mtext.draw!");
		
		//pg.background(fcolor);
		pushStyle();
		pushMatrix();
		translate(x,y);
		
		fill(fcolor);
		noStroke();

		//rect(0,0,wid,hei);
		mspot_v=(int)(wid/spot_w);
		mspot_h=(int)(hei/spot_h);
		
		
		for(int i=0;i<mspot_v;++i){
			for(int j=0;j<mspot_h;++j){
				if(i*mspot_h+j>spot_sizes.size()-1) continue;
				//fill(red(fcolor)*random(.8,1.2),green(fcolor)*random(.6,1.4),blue(fcolor)*random(.7,1.2),random(100,255));
				drawSpot(spot_w*i,spot_h*j,spot_sizes.get(i*mspot_h+j).x,spot_sizes.get(i*mspot_h+j).y,spot_angle);
			}
		}

		popMatrix();

	
		popStyle();

	}

	void drawSpot(float sx,float sy,float sw,float sh,float ang){
		pushMatrix();
		translate(sx,sy);
		rotate(PI/6*random(.8,1.2));

		beginShape();
			vertex(0,sh/2);
			PVector ctrl=new PVector(mag(sw,sh)*3,0);
			ctrl.rotate(ang);
			bezierVertex(ctrl.x,sh/2-ctrl.y,ctrl.x,sh/2+ctrl.y,
						 0,sh/2);

			// bezierVertex(sw-ctrl.x,sh/2+ctrl.y,ctrl.x,sh/2+ctrl.y,
			// 			 0,sh/2);
			// vertex(0,sh);
			// vertex(sw,sh);
			// vertex(sw,0);
		endShape();

		popMatrix();
	}
}

