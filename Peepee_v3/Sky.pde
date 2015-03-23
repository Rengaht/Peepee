
ArrayList<Cloud> acloud;
ArrayList<Eye> aeye;

void initCloud(){
	acloud=new ArrayList<Cloud>();
	int mcloud=(int)random(8,20);
	for(int i=0;i<mcloud;++i){
		acloud.add(new Cloud(random(20,width-20),random(20,height-20),random(120,450),random(12,20)));
	}

	int meye=(int)random(8,24);
	aeye=new ArrayList<Eye>();
	for(int i=0;i<meye;++i){
		float ewid=random(8,25);
		 aeye.add(new Eye(random(20,width-20),random(20,height-20),
						 ewid,ewid*random(.2,.4),random(10,30),random(TWO_PI),(int)random(3,9)));
	}
}
void drawSkyBackground(PGraphics pg,boolean draw_fill){
	for(Cloud c:acloud) c.draw(pg,draw_fill);
	if(draw_fill)
		for(Eye e:aeye) e.draw(pg,draw_fill);
}
void updateSky(){
	for(Cloud c:acloud) c.update();	
	for(Eye e:aeye) e.update();
}
class Cloud{
	
	float x,y,wid,hei;
	FloatList arc_pos;
	int marc;
	float vel=random(10,40);
	float phi=random(TWO_PI);
	float delta_x;
	float vel_y;

	Eye[] aeye;

	Cloud(float x_,float y_,float wid_,float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		marc=(int)random(23,38);
		arc_pos=new FloatList();
		float tmp_pos=0;
		for(int i=0;i<marc;++i){
			// arc_pos.append(tmp_pos);
			arc_pos.append(random(-.5,.5)*hei);
			
			if(tmp_pos==wid) break;

			tmp_pos+=random(.1,2.5)*wid/marc;
			if(tmp_pos>wid) tmp_pos=wid;
		}
		marc=arc_pos.size();

		delta_x=wid*random(.1,.4);
		vel_y=random(2,6);

		// int meye=(int)random(0,4);
		// float eye_vel=random(10,30);
		// float eye_phi=random(TWO_PI);
		// int mhair=(int)random(3,9);
		// aeye=new Eye[meye];
		// float ewid=wid/(float)(meye+2);
		// for(int i=0;i<meye;++i) aeye[i]=new Eye((i+1)*ewid,hei/2,ewid*.4,min(ewid*.2,hei*.2),eye_vel,eye_phi,mhair);
	}
	void draw(PGraphics pg,boolean draw_fill){
		float draw_portion=(float)frameCount/vel+phi;	
		pg.pushStyle();
		if(draw_fill){
			pg.fill(180); pg.noStroke();
		}else{
			// pg.popStyle();
			// // return;
			pg.noFill(); pg.stroke(120,180);
		}
		pg.pushMatrix();
		pg.translate(x,y);
		// pg.translate(x+delta_x*sin(draw_portion),y);
		// pg.beginShape();
		// 	for(int i=0;i<marc;++i){
		// 		if(i==0) pg.vertex(arc_pos.get(i),0);
		// 		else pg.bezierVertex(lerp(arc_pos.get(i-1),arc_pos.get(i),.3),-hei*1.5*(.5+.25*sin(draw_portion+i))*random(.6,1.3),
		// 							 lerp(arc_pos.get(i-1),arc_pos.get(i),.66),-hei*1.8*(.5+.25*sin(draw_portion+i))*random(.6,1.3),
		// 							 arc_pos.get(i),0);
		// 	}
		// 	pg.vertex(wid,hei);
		// 	pg.vertex(0,hei);
		// pg.endShape(CLOSE);
			int mtur=marc;//(int)random(8,20);
			PVector last_tur=new PVector(0,0);
			pg.beginShape();
				for(int i=0;i<mtur;++i){
					PVector cur_tur=new PVector(wid/(float)mtur*i,arc_pos.get(i));
					if(i%3==0) pg.vertex(cur_tur.x,cur_tur.y);
					else pg.bezierVertex(lerp(cur_tur.x,last_tur.x,-.3),cur_tur.y,
										lerp(cur_tur.x,last_tur.x,1.3),last_tur.y,
										cur_tur.x,cur_tur.y);
					last_tur=cur_tur.get();
				}
				pg.vertex(wid,hei);
				pg.vertex(0,hei);
			pg.endShape(CLOSE);

		if(draw_fill){
			// int meye=aeye.length;
			// println(meye+" eye to draw!");
			// for(int i=0;i<meye;++i) aeye[i].draw(pg,draw_fill);
		}else{
			pg.noFill();
			pg.stroke(200,180);
			int mtur_=(int)random(8,20);
			PVector last_tur_=new PVector(0,0);
			pg.translate(delta_x*sin(draw_portion)*random(.2,1.2),0);
			pg.beginShape();
			for(int i=0;i<mtur_;++i){
				PVector cur_tur=new PVector(wid/(float)mtur_*i,random(-.5,.5)*hei);
				if(i%3==0) pg.vertex(cur_tur.x,cur_tur.y);
				else pg.bezierVertex(lerp(cur_tur.x,last_tur_.x,-.3),cur_tur.y,
									lerp(cur_tur.x,last_tur_.x,1.3),last_tur_.y,
									cur_tur.x,cur_tur.y);
				last_tur_=cur_tur.get();
			}
			pg.endShape();
		}
		pg.popMatrix();

		pg.popStyle();
	}
	void update(){
		if(random(50)<1) y+=vel_y*8;
		else y+=vel_y;
		if(y>height+hei) y=-hei;

	}
}

class Eye{
	float x,y,wid,hei;
	float vel,phi;
	int mhair;
	float vel_y;
	Eye(float x_,float y_,float wid_,float hei_,float vel_,float phi_,int mhair_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		vel=vel_;
		phi=phi_;
		mhair=mhair_;
		vel_y=random(2,6);
	}
	void draw(PGraphics pg,boolean draw_fill){
		// if(draw_fill) return;

		float draw_portion=(float)frameCount/vel+phi;
		pg.pushStyle();
		pg.fill(back_color);
		pg.stroke(120);	
		// pg.fill(0);

		pg.pushMatrix();
		pg.translate(x-wid/2,y);
		// pg.rect(0,0,wid,hei);
		

		pg.beginShape();
			pg.vertex(0,0);
			pg.bezierVertex(0,hei,wid,hei,
							wid,0);
			// pg.bezierVertex(wid,hei*sin(draw_portion),0,hei*sin(draw_portion),
			//                 0,0);
		pg.endShape();

		pg.pushStyle();
			float eye_top=bezierPoint(0,-hei,-hei,0,.5);//bezierPoint(0,hei*sin(draw_portion),hei*sin(draw_portion),0,.5);
			float eye_bottom=bezierPoint(0,hei,hei,0,.5);
			float eye_rad=(eye_bottom-eye_top)*.8;
			pg.fill(120);
			pg.ellipse(wid/2,eye_top+eye_rad/2,eye_rad,eye_rad);
		pg.popStyle();

		pg.stroke(0,0);
		pg.beginShape();
			pg.vertex(0,0);
			pg.vertex(0,-hei);
			pg.vertex(wid,-hei);
			pg.vertex(wid,0);
			pg.bezierVertex(wid,hei*sin(draw_portion),0,hei*sin(draw_portion),
			                0,0);
		pg.endShape();
		pg.stroke(80);
		pg.noFill();
		pg.beginShape();
			pg.vertex(wid,0);
			pg.bezierVertex(wid,hei*sin(draw_portion),0,hei*sin(draw_portion),
			                0,0);
		pg.endShape();

		pg.stroke(80);
		float eang=1/(float)mhair;
		for(int i=0;i<mhair;++i){
			float tmp_x=bezierPoint(0,0,wid,wid,eang*i);
			float tmp_y=bezierPoint(0,hei,hei,0,eang*i);
			float tan_x=-bezierTangent(0,hei,hei,0,eang*i)/9;
			float tan_y=bezierTangent(0,0,wid,wid,eang*i)/9;
			
			pg.line(tmp_x,tmp_y,tmp_x+tan_x,tmp_y+tan_y);
		}

		
		pg.popMatrix();
		pg.popStyle();

	}
	void update(){
		if(random(50)<1) y+=vel_y*8;
		else y+=vel_y;
		if(y>height+hei) y=-hei;

	}
}