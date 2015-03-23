
final int mslice=12;
final int SHRINK_SPAN=50;
// final float DEST_RAD=50;

class Robot{
	
	float x,y,wid,hei;
	Slice[] slices;
	float dest_rad=50;
	
	boolean toShrink=false;
	int start_shrink_frame=0;

	Robot(float x_,float y_,float wid_,float hei_){
		x=x_; y=y_; dest_rad=wid_; //hei=hei_;
		slices=new Slice[mslice];
		for(int i=0;i<mslice;++i) slices[i]=new Slice();
	}

	void draw(PGraphics pg){

		pg.pushMatrix();
		pg.translate(x,y);

		float tmp_rad=dest_rad;//(!toShrink)?dest_rad:dest_rad*abs(cos((float)start_shrink_frame/(float)SHRINK_SPAN*PI));
		for(int i=0;i<mslice;++i){
			if(i%3==0) slices[i].draw(pg,tmp_rad);
			else slices[i].draw(pg,dest_rad);
			// println(i);
		}
		// pg.fill(255,0,0);
		// pg.rect(0,0,wid,hei);

		pg.popMatrix();

		// if(toShrink){
		// 	start_shrink_frame--;
		// 	if(start_shrink_frame==0) toShrink=false;
		// }else{
		// 	start_shrink_frame++;
		// 	if(start_shrink_frame==SHRINK_SPAN) toShrink=true;
		// }
	}


}


class Machine{
	
	float x,y,wid,hei;
	ArrayList<Window> windows;
	int mhoriz=8;
	int mvert=8;

	float delta_x;

	Machine(float x_,float y_,float wid_,float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		windows=new ArrayList<Window>();
		float tmpx=0;
		float tmpy=0;
		for(int i=0;i<mhoriz;++i){
			float tmpw=random(.2,3)*wid/(float)mhoriz;
			if(tmpx+tmpw>wid) tmpw=wid-tmpx;
			if(tmpw==0) break;

			tmpy=0;
			for(int j=0;j<mvert;++j){
				float tmph=random(.2,3)*hei/(float)mvert;
				if(tmpy+tmph>hei || j==mvert-1) tmph=hei-tmpy;
				if(tmph==0) break;
				windows.add(new Window(tmpx,tmpy,tmpw,tmph,x,wid));
				tmpy+=tmph;
			}
			tmpx+=tmpw;
		}
	}

	void draw(PGraphics pg,boolean draw_fill){
		
		float draw_portion=(sin((float)frameCount/(20)));

		pg.pushMatrix();
		pg.translate(x,y);
		if(draw_fill){pg.fill(70,120,255,180); pg.noStroke(); }
		else{ pg.noFill(); pg.stroke(0); }
		// pg.beginShape();
		// 	pg.vertex(wid*.1*(1-.05*draw_portion),-hei*.2);
		// 	pg.vertex(wid*(.95+.01*draw_portion),0);
		// 	pg.vertex(wid*(1-.01*draw_portion),hei);
		// 	pg.vertex(0,hei);
		// pg.endShape(CLOSE);
		// pg.beginShape();
		// 	pg.vertex(wid*.1*(1-.05*draw_portion),-hei*.2);
		// 	pg.vertex(wid*(.95+.01*draw_portion),0);
		// 	pg.vertex(wid*(.98),-hei*(.23+.05*draw_portion));
		// 	pg.vertex(wid*.2,-hei*.3);
		// pg.endShape(CLOSE);
		// pg.beginShape();
		// 	pg.vertex(wid*(.95+.01*draw_portion),0);
		// 	pg.vertex(wid*(.98),-hei*(.23+.05*draw_portion));
		// 	pg.vertex(wid*(1.2),hei);
		// 	pg.vertex(wid*(1-.01*draw_portion),hei);
		// pg.endShape(CLOSE);
		
		// pg.translate(wid*.1,0);
		// pg.shearX(-PI/12-PI/80*draw_portion);
		
		
		for(Window w: windows) w.draw(pg,draw_fill);

		pg.popMatrix();
	}
	void update(){
		float draw_portion=(sin((float)frameCount/(20)));
		delta_x=width/150*abs(draw_portion);
		for(Window w: windows) w.x+=delta_x;
	}



}

class Window{

	float x,y,wid,hei;
	int mhoriz,mvert;
	float[] edge_distort_x,edge_distort_y;
	color fcolor;
	boolean is_circle=random(3)<1;

	float dx=random(.01,.2);
	float dy=random(.01,.2);
	
	float parent_x,parent_wid;

	Window(float x_,float y_,float wid_,float hei_,float px_,float pw_){
		
		x=x_; y=y_; wid=wid_; hei=hei_;
		parent_x=px_;
		parent_wid=pw_;

		if(is_circle){
			float mtmp=(int)random(1,3);
			
			float swid=0;
			if(wid<hei){
				swid=wid/mtmp;
			}else swid=hei/mtmp;

			mhoriz=max(floor(wid/swid),1);
			mvert=max(floor(hei/swid),1);
			
			hei=min(mvert*swid,hei);
			wid=min(mhoriz*swid,wid);

		}else mvert=mhoriz=(int)random(1,3);
		
		if(mvert==1) dx=.01;
		if(mhoriz==1) dy=.01;

		// edge_distort_x=new float[mvert*mhoriz];
		// edge_distort_y=new float[mvert*mhoriz];
		

		// for(int i=0;i<mvert*mhoriz;++i){
		// 	if(is_circle) edge_distort_y[i]=edge_distort_x[i]=.2;
		// 	else{
		// 		edge_distort_x[i]=random(.01,.3);
		// 	 	edge_distort_y[i]=random(.01,.3);
		// 	}
		// }
		fcolor=color(random(120,180));//20+random(20,80),120+random(20,80),255+random(20,80));
	}	
	void draw(PGraphics pg,boolean draw_fill){
		
		// x+=delta_x;

		pg.pushStyle();
		if(draw_fill){
			pg.noStroke();
			pg.fill(fcolor);
		}else{
			pg.stroke(90,120);
			pg.noFill();
			// pg.fill(255);
		}

		float swid=wid/(float)mhoriz;
		float shei=hei/(float)mvert;
		pg.pushMatrix();
		pg.translate((x)%parent_wid+parent_x,y);
			// pg.rect(0,0,wid,hei);
			for(int i=0;i<mhoriz;++i)
				for(int j=0;j<mvert;++j){
					
					float distort_x=dx;//edge_distort_x[i*mvert+j];
					float distort_y=(is_circle)?dx:dy;//edge_distort_y[i*mvert+j];
					float tmp_wid=swid*(1-distort_x*2);
					float tmp_hei=shei*(1-distort_y*2);
					pg.pushMatrix();
					pg.translate((i+distort_x)*swid,(j+distort_y)*shei);
					if(is_circle){

						pg.beginShape();
							pg.vertex(tmp_wid/2,0);
							pg.bezierVertex(tmp_wid*1.25,0,tmp_wid,tmp_hei,
											tmp_wid/2,tmp_hei);
							pg.bezierVertex(-tmp_wid*.25,tmp_hei,0,0,
											tmp_wid/2,0);
							
						pg.endShape(CLOSE);

					}else{
						pg.beginShape();
							pg.vertex(0,0);
							pg.vertex(0,tmp_hei);
							pg.vertex(tmp_wid,tmp_hei);
							pg.vertex(tmp_wid,0);
						pg.endShape(CLOSE);
					}
					pg.popMatrix();
				}
		pg.popMatrix();
		
		pg.popStyle();	
	}

}