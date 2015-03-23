import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Peepee extends PApplet {


final int M_MODE=8;

int mpas=10;
ArrayList<PAnimal> pas;

float mid_pos;
float dest_pos;


PImage texture_img;
boolean save_frame=false;

ArrayList<MeatTexture> mtexts;
PGraphics mtext_pg;


DistortGraphic fill_canvas,stroke_canvas;

SkateBoard sktb;
int play_mode=0;

int mpas_to_play=0;
float angle_for_mode=0;

ArrayList<SpotLight> sps;



public void setup(){
	
	size(800,800,P3D);
	
 	//mtext_pg=createGraphics(width,height);
	
	pas=new ArrayList<PAnimal>();
	float tmp_pos=0;
	for(int i=0;i<mpas;++i){
		float tmp_h=random(0.6f,1.2f)*height/mpas;
		pas.add(new PAnimal(0,tmp_pos+tmp_h,width/5*random(.6f,1.4f),tmp_h));
		tmp_pos+=tmp_h;
		if(tmp_h>height) return;
	}
	mpas=pas.size();

	mid_pos=0;

	fill_canvas=new DistortGraphic(25);
	fill_canvas.transform_mag=2;
	fill_canvas.transform_vel=28;
	stroke_canvas=new DistortGraphic(1);

	// texture_img=loadImage("Oil_Paint_01.jpg");

	// mtext_pg=createGraphics(width,height);
	// mtexts=new ArrayList<MeatTexture>();
	// for(int i=0;i<mpas;++i){
	// 	PAnimal pa=pas.get(i);
	// 	mtexts.add(new MeatTexture(0,pa.y,width,pa.hei,mtext_pg));
	// }
	// updateMText();

	sps=new ArrayList<SpotLight>();
	for(int i=0;i<3;++i)
		sps.add(new SpotLight(i));

}

public void draw(){
	
	background(0);	
	

	fill_canvas.beginDraw();
	stroke_canvas.beginDraw();
	
	if(play_mode==7){
		stroke_canvas.background(color(255,0));
		fill_canvas.fill(color(0,20));
	}else{
		fill_canvas.background(color(255,0));
		stroke_canvas.background(color(255,0));
	}
	if(play_mode==8) fill_canvas.transform_vel=32;
	else fill_canvas.transform_vel=28;

	if(play_mode==0){
		background(255);
	}else if(play_mode==1){
		background(255);
		fill_canvas.pg.translate(width/2,height/2);
		fill_canvas.pg.rotate(PI/4);
		fill_canvas.pg.translate(-width/2,-height/2);
		
		stroke_canvas.pg.translate(width/2,height/2);
		stroke_canvas.pg.rotate(PI/4);
		stroke_canvas.pg.translate(-width/2,-height/2);
	}else if(play_mode==2){

		background(0,0,255);	

		fill_canvas.pg.translate(width/2,height*.5f);
		fill_canvas.pg.rotate(angle_for_mode);
		fill_canvas.pg.translate(-width/2,-height*.5f);
		
		stroke_canvas.pg.translate(width/2,height*.5f);
		stroke_canvas.pg.rotate(angle_for_mode);
		stroke_canvas.pg.translate(-width/2,-height*.5f);

	}else if(play_mode==3||play_mode==4){
		background(20);
	}else if(play_mode==6){
		background(0);
		drawMoon(stroke_canvas.pg,false);
		drawMoon(fill_canvas.pg,true);	
	}else if(play_mode==7){
		background(0,0,3);
		drawSpace(this.g,true);
	}
	for(int i=0;i<mpas_to_play;++i){
		PAnimal pa=pas.get(i);
		pa.draw(stroke_canvas.pg,false);
		pa.draw(fill_canvas.pg,true);
		// image(pa.mtext.pg,pa.x,pa.y);
	}

	if(play_mode==7){
		
		for(SpotLight sp:sps)
			sp.drawCone(fill_canvas.pg,true);
		// translate(width/2,height/2);
		// rotate(-PI/4);
		// translate(-width/2,-height/2);
	}
	stroke_canvas.endDraw();
	fill_canvas.endDraw();
	if(play_mode>2) blendMode(ADD);
   	fill_canvas.draw();
   	//stroke_canvas.draw();
   	blendMode(NORMAL);
   	image(stroke_canvas.pg,-width/20,0);


	
	switch(play_mode){
		case 1:
		case 2:
			float cur_min_pos=Integer.MAX_VALUE;
			for(int i=0;i<mpas_to_play;++i){
				PAnimal pa=pas.get(i); 
				cur_min_pos=min(pa.x,cur_min_pos);
			}
			cur_min_pos/=pas.size();
			//println(cur_min_pos);
			if(cur_min_pos>width/7){
				for(int i=0;i<mpas_to_play;++i){
					PAnimal pa=pas.get(i); 
					pa.x=-random(width/2);
				 	pa.land_vel=(int)random(2,10);
				 }
				 angle_for_mode=-PI/8;
			}
			break;
		case 0:
			if(frameCount%100==0){
				mid_pos=0;
				for(int i=0;i<mpas_to_play;++i){
					PAnimal pa=pas.get(i);
					mid_pos+=(pa.x+pa.wid);
				}
				mid_pos/=pas.size();
				mid_pos*=.8f;
			// println(mid_pos);
			}else{
				for(int i=0;i<mpas_to_play;++i){
					PAnimal pa=pas.get(i);
					pa.x-=(play_mode==1)?mid_pos/80:mid_pos/100;
				}
			}
			break;


	}
	if(play_mode==2){
		//angle_for_mode+=.02;
		//angle_for_mode=constrain(angle_for_mode,-PI/4,PI/4);
	}

	//tint(255,120);
	//blend(texture_img,(int)(mid_pos%texture_img.width),0,width,height,0,0,width,height,BURN);
	//updateMText();

	// image(mtext_pg,0,0,width,height);
	// if(mousePressed) updateMText();

	frame.setTitle(String.valueOf(frameRate));
	if(save_frame) saveFrame("pee-####.png");
}

public void keyPressed(){

	switch(key){
		case 'a':
			for(PAnimal pa:pas) pa.x=0;
			break;
		case 's':
			save_frame=!save_frame;
			break;
		case 'd':
			
			fill_canvas.reset();

			play_mode=(play_mode+1)%M_MODE;
			float tmpx=0;
			float tmpy=0;
			moon_edge_y=height;
			for(PAnimal pa:pas){
			 	pa.transport_mode=play_mode;
			 	if(play_mode==3){
			 		pa.x=tmpx;
			 		pa.y=constrain(random(height/2,height),pa.sship.y,height-pa.hei*2);
			 		tmpx+=(float)width/mpas*random(0.6f,1.5f);
			 		if(tmpx>width) tmpx-=(float)width/mpas*random(1,3);
			 		
			 		pa.sship.x=pa.x;
					pa.sship.ray_bottom_y=pa.y+pa.body_hei;//+jump_pos_y;
					pa.sship.ray_animal_y=pa.y;
					pa.sship.start_frame=frameCount;

			 	}else if(play_mode<3){
			 		 float tmp_h=random(0.6f,1.2f)*height/mpas;
				 	 pa.x=0;
				 	 pa.y=tmpy+tmp_h;
				 	 tmpy+=tmp_h;
			 	}else if(play_mode==6){
			 		pa.volcano.x=pa.x+pa.body_wid/2;
			 		// pa.volcano.y=pa.y+pa.body_hei*3;
			 		pa.y=pa.volcano.y-pa.hei-pa.leg_hei;
			 		moon_edge_y=min(moon_edge_y,pa.volcano.y);
			 	}else if(play_mode==7){
			 		float tmp_h=random(0.6f,1.2f)*height/mpas;
			 		pa.x=random(pa.wid,width-pa.wid);
				 	pa.y=tmpy+tmp_h;
				 	pa.disco_stage=-2;
				 	tmpy+=tmp_h;
			 	}
			 	pa.land_vel=(int)random(2,10);
			 		
			}
			// if(play_mode==7){
			// 	for(SpotLight sp:sps) sp.setRandomPaSource();
			// }
			moon_edge_y*=.8f;
			mid_pos=0;
			for(PAnimal pa:pas) mid_pos+=(pa.x+pa.wid);
			mid_pos/=pas.size();
			mid_pos*=.8f;
			angle_for_mode=-PI/4;
			break;
		case 'q':
			if(mpas_to_play<mpas){
				mpas_to_play++;
				pas.get(mpas_to_play-1).x=0;
			}
			break;
		case 'w':
			mpas_to_play--;
			mpas_to_play=constrain(mpas_to_play, 0, mpas);
			break;
		case 'z':
			pas.clear();
			float tmp_pos=0;
			for(int i=0;i<mpas;++i){
				float tmp_h=random(0.6f,1.2f)*height/mpas;
				pas.add(new PAnimal(0,tmp_pos+tmp_h,width/5*random(.6f,1.4f),tmp_h));
				tmp_pos+=tmp_h;
				if(tmp_h>height) return;
			}
			for(PAnimal pa:pas) pa.transport_mode=play_mode;
			mpas=pas.size();
			break;
	}
}


public void updateMText(){
	// for(int i=0;i<mpas;++i){
	// 	PAnimal pa=pas.get(i);
	// 	MeatTexture mt=mtexts.get(i);
	// 	mt.x=pa.x; mt.y=pa.y; 
	// 	mt.wid=pa.wid; mt.hei=pa.hei; 	
	// }
	mtext_pg.beginDraw();
	mtext_pg.background(255,0);	
		for(MeatTexture mt:mtexts) mt.draw();
	mtext_pg.endDraw();
}



class Cookie{

	float x,y,wid,hei;
	float[] wid_portion;
	int fc;
	int mchip;
	ArrayList<PVector> cookie_verts;
	ArrayList<PVector> chip_verts;

	Cookie(float x_,float y_,float wid_,float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		wid_portion=new float[4];
		for(int i=0;i<4;++i) wid_portion[i]=random(.8f,1.2f);

		fc=color(random(50,100)+150,random(20,40)+120,80);

		mchip=(int)random(4,9)*2;
		cookie_verts=new ArrayList<PVector>();
		chip_verts=new ArrayList<PVector>();

		float ac_ang=0;
		for(int i=0;i<mchip;++i){
			float tmp_ang=random(.4f,1.6f)*TWO_PI/(float)mchip;
			ac_ang=constrain(ac_ang+tmp_ang,0,TWO_PI);
			cookie_verts.add(new PVector(random(.8f,1.2f),ac_ang));
			
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

	public void draw(PGraphics pg,boolean draw_fill){
		
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


	public void drawChip(PGraphics pg,PVector vert){
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


class DiscoLight{
	
	float x,y,rad;
	int light_color;
	float splash_time;

	float dest_x,dest_y,dest_rad;
	float orig_x,orig_y,orig_rad;
	// float update_t;
	float vel=random(30,90);
	float phi=random(TWO_PI);
	
	int update_stage;
	boolean finished=false;
	int dest_iani;

	int color_index;

	DiscoLight(int color_i){
		color_index=color_i;
		int iani=(int)random(mpas_to_play);
		PAnimal pa=pas.get(iani);
		orig_x=x=pa.x+pa.body_wid/2;
		orig_y=y=pa.y;
		orig_rad=rad=max(pa.wid,pa.hei);

		resetColor();
		splash_time=2+random(5);

	}
	DiscoLight(float x_,float y_,float rad_){
		x=x_; y=y_; rad=rad_;
		orig_x=x_; orig_y=y_; orig_rad=rad_;
		
		light_color=color(255,20,147);
		splash_time=2+random(5);

	}

	
	public void draw(PGraphics pg,boolean draw_fill){
		pg.pushStyle();
		if(draw_fill){
			pg.noStroke();
			if(random(splash_time)<1) pg.fill(light_color);
		}
		pg.pushMatrix();
		pg.translate(x,y);
		pg.ellipse(0,0,rad,rad);
		pg.popMatrix();

		pg.popStyle();

		update();
	}

	public void update(){
		
		float frame_portion=(float)frameCount/(vel)+phi;
		frame_portion%=TWO_PI;
		int new_stage=(int)((frame_portion)/(PI/2));

		PAnimal pa=pas.get(dest_iani);
		dest_x=pa.x+pa.body_wid/2; dest_y=pa.y; dest_rad=max(pa.wid,pa.hei);
		
				
		if(update_stage==3 && new_stage==0){
			setRandomPaDest();
			resetColor();
		}
		update_stage=new_stage;
		switch(update_stage){
			case 0:
				rad=orig_rad-orig_rad/2*sin(frame_portion);
				break;
			case 1:
				x=(dest_x-orig_x)*sin((frame_portion-PI/2))+orig_x;
				y=(dest_y-orig_y)*sin((frame_portion-PI/2))+orig_y;
				break;
			case 2:
				rad=orig_rad/2+(dest_rad-orig_rad)*sin(frame_portion-PI);
				break;
			case 3:
				x=dest_x; y=dest_y; rad=dest_rad*random(.8f,2.5f);
				resetColor();
				break;
		}
	}
	public void setDest(float x_,float y_,float rad_){
		
		dest_x=x_; dest_y=y_; dest_rad=rad_;
		orig_x=x; orig_y=y; orig_rad=rad;

		finished=true;
	}
	public boolean finisheUpdate(){
		return finished;
	}
	public void setRandomPaDest(){
		int iani=(int)random(mpas_to_play);
		PAnimal pa=pas.get(iani);
		setDest(pa.x+pa.body_wid/2,pa.y,max(pa.wid,pa.hei));
		dest_iani=iani;

	}
	public void resetColor(){
		switch(color_index){
			case 0:
				light_color=color(200+random(50),50+random(50),60+random(50),120);
				break;
			case 1:
				light_color=color(200+random(50),200+random(50),random(50),120);
				break;
			case 2:
				light_color=color(random(50),200+random(50),random(50),120);
				break;
				
		}
	}
}
class DistortGraphic{
	
	PGraphics pg;
	ArrayList<PVector> vertexPoints;
	ArrayList<PVector> texturePoints;
	FloatList phases;


	int play_vel=5;
	int transform_vel=16;
	int WID_SEG=20;
	float transform_mag=1.4f;

	DistortGraphic(int wid_seg){
		vertexPoints=new ArrayList<PVector>();
		texturePoints=new ArrayList<PVector>();
		phases=new FloatList();
		
		WID_SEG=wid_seg;

		float w=width*1.2f/WID_SEG;
		for(int i=0;i<WID_SEG;++i)
			for(int j=0;j<WID_SEG;++j){
				vertexPoints.add(new PVector(i*w,j*w));
				texturePoints.add(new PVector(i*w,j*w));
			
				phases.append(random(TWO_PI));
			}
		pg=createGraphics((int)(width*1.2f),(int)(height*1.2f));
	}

	public void draw(){
		// int len=vertexPoints.size();
		pushMatrix();
		translate(-width/20,0);
		for(int i=0;i<WID_SEG-1;++i)
			for(int j=0;j<WID_SEG-1;++j){			
				PVector p1=vertexPoints.get(i*WID_SEG+j);
				PVector p2=vertexPoints.get((i+1)*WID_SEG+j);
				PVector p3=vertexPoints.get((i+1)*WID_SEG+j+1);
				PVector p4=vertexPoints.get(i*WID_SEG+j+1);
				
				PVector t1=texturePoints.get(i*WID_SEG+j);
				PVector t2=texturePoints.get((i+1)*WID_SEG+j);
				PVector t3=texturePoints.get((i+1)*WID_SEG+j+1);
				PVector t4=texturePoints.get(i*WID_SEG+j+1);
				
				noStroke();
				beginShape();
				texture(pg);
					vertex(p1.x,p1.y,t1.x,t1.y);
					vertex(p2.x,p2.y,t2.x,t2.y);
					vertex(p3.x,p3.y,t3.x,t3.y);
					vertex(p4.x,p4.y,t4.x,t4.y);
				endShape();
			}
		popMatrix();
		update();
	}
	public void update(){

		int len=vertexPoints.size();

		if(frameCount%play_vel==0){
			for(int i=0;i<len;++i){
				PVector p=vertexPoints.get(i);
				p.x+=sin(frameCount%transform_vel*TWO_PI/transform_vel+phases.get(i))*transform_mag;
				p.y+=cos(frameCount%transform_vel*TWO_PI/transform_vel+phases.get(i))*transform_mag;	
			}
		}
	}	
	public void reset(){
		int len=vertexPoints.size();
		for(int i=0;i<len;++i){
			PVector vp=vertexPoints.get(i);
			PVector tp=texturePoints.get(i);
			vp.x=tp.x; vp.y=tp.y;
		}
	}
	public void beginDraw(){
		pg.beginDraw();
	}
	public void endDraw(){
		pg.endDraw();
	}
	
	public void background(int c){
		pg.background(c);
	}

	public void fill(int c){
		pg.pushStyle();
		pg.noStroke();
		pg.fill(c);
		pg.rect(0,0,pg.width,pg.height);
		pg.popStyle();
	}
}
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
	public void setPos(PVector pos){
		if(pos==null) return;
		x=pos.x; y=pos.y;
	}
	public void draw(PGraphics pg,boolean draw_fill){
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
					float random_strength1=random(1.5f,5);
					float random_strength2=random(1.5f,5);
					// if(theta>PI){
					// 	random_strength1*=2;
					// 	random_strength2*=2;
					// }
					if(theta>=PI/2 && theta<=PI/2*3){
						// pg.bezierVertex(rad/2*cos(theta+etheta)*random_strength1,rad/2*sin(theta+etheta)*random_strength1,
						// 			rad/2*cos(theta+etheta)*random_strength2,rad/2*sin(theta+etheta)*random_strength2,
						pg.vertex(rad/2*cos(theta+etheta/2)-rad*random(1.5f,(draw_fill)?4.5f:2.5f)*(1-abs(theta-PI)/PI*2),rad/2*sin(theta+etheta/2));
						pg.vertex(rad/2*cos(theta)*random(0.5f,2.5f),rad/2*sin(theta));
					}else
						pg.vertex(rad/2*cos(theta)*random(0.5f,1.5f),rad/2*sin(theta));
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
						 rad/2*cos(theta)*random(.8f,1),rad/2*sin(theta)*random(.8f,1));

			}
		}
			
		pg.popMatrix();
		//for(int i=0;i<5;++i) drawTurb(x-random(width-x),random(-cur_wid,cur_wid),pg);
		pg.popStyle();
	}

}

class MeatTexture{
	
	float x,y,wid,hei;
	int fcolor;
	int mspot;
	float spot_w,spot_h;

	float spot_angle;
	// PGraphics pg;
	ArrayList<PVector> spot_sizes;
	int mspot_v;
	int mspot_h;

	MeatTexture(float x_,float y_,float wid_,float hei_,int f_){
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

	public void draw(){
		
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

	public void drawSpot(float sx,float sy,float sw,float sh,float ang){
		pushMatrix();
		translate(sx,sy);
		rotate(PI/6*random(.8f,1.2f));

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


float moon_edge_y=width/2;
int mmoon_noise=(int)random(5,12);

public void drawMoon(PGraphics pg,boolean draw_fill){

	float draw_portion=abs(sin((float)frameCount/50));
	pg.pushStyle();
	if(draw_fill){
		int fc=color(200+50*draw_portion,40*draw_portion+120,80);
		pg.noStroke(); pg.fill(fc);
	}else{
		pg.stroke(0); pg.noFill();
	}

	pg.beginShape();
		pg.vertex(-width/2,height*1.1f);
		pg.vertex(width*5/4,height*1.1f);
		pg.vertex(width*5/4,moon_edge_y);
		pg.bezierVertex(width/2+width/4*draw_portion,moon_edge_y-height/8,
						width/2-width/4*draw_portion,moon_edge_y-height/8*draw_portion,
						-width/2,height/2);
	pg.endShape(CLOSE);

	pg.popStyle();
	if(draw_fill){
		pg.stroke(255,80); pg.noFill();
	}else{
		return;
	}
	for(int i=0;i<mmoon_noise;++i){
		float sub_portion=sin(draw_portion+i);
		pg.pushMatrix();
		pg.translate(width/(float)mmoon_noise*i,height/4*abs(sin(i)));
		pg.rotateZ(-PI/5);
		pg.beginShape();
			// pg.vertex(0,0);
			// for(int x=0;x<2;++x){
				pg.vertex((width/8-width/25)*(1-sub_portion)-random(width/25),-width/8*(1-sub_portion)*random(.8f,1.2f));
				pg.vertex((width/8-width/25)*sub_portion-random(width/25),-width/8*sub_portion);
			// }
							// (width/8+width/25)*draw_portion+random(width/35),-width/8*draw_portion,
							// 0,0);
		pg.endShape();
		pg.popMatrix();
	}


}
 final float LAND_DISTORT=.6f;

class PAnimal{
	
	float x,y,wid,hei;
	float head_wid,head_hei;
	float body_wid,body_hei;
	
	float leg_wid,leg_hei;
	int mleg;
	FloatList leg_span;

	float tail_wid,tail_hei;
	int fcolor;
	
	float phi;
	float elastic_strength;
	int elastic_stage=0;

	FloatList land_poses;
	int land_length;
	float land_vel;
	int land_index;

	// MeatTexture mtext;
	SkateBoard sktb;
	// boolean onSkate=false;
	
	SwimWater water;
	FireWheel[] wheels;
	SpaceShip sship;


	int transport_mode=0;
	float wheel_vel=27;
	float swim_vel=80;
	float skate_vel=60;
	float run_vel=50;
	float jump_vel=random(50,90);
	float disco_vel=60;
	
	int disco_stage=-2;

	float v_jump_dest_y;
	float v_jump_vel=random(10,24);

	float s_body_hei_incre=0;

	PVector first_foot_base;
	PVector last_foot_base;

	Cookie cookie;
	Volcano volcano;

	PAnimal(float x_,float y_,float wid_,float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		

		float hhead_portion=random(.3f,.5f);
		head_wid=hhead_portion*wid;
		body_wid=wid-head_wid;
		
		body_hei=(hei)*random(.3f,.5f);
		float vhead_portion=random(.4f,.8f);
		head_hei=vhead_portion*body_hei;
		
		leg_hei=hei-body_hei;

		mleg=(int)random(3,6);
		leg_wid=body_wid/mleg*random(.2f,.4f);
		leg_span=new FloatList();
		//leg_span.append(0);
		for(int i=0;i<mleg;++i){
			leg_span.append(random(0.05f,0.5f));
		}


		fcolor=color(random(100,255),random(20,80)+100,random(20,85));

		phi=random(HALF_PI);
		


		land_poses=new FloatList();
		land_length=(int)(random(.5f,1.2f)*width);
		for(int i=0;i<land_length;++i){
			if(random(20)<1) land_poses.append(random(-LAND_DISTORT,0)*30);
			else land_poses.append(random(-LAND_DISTORT,LAND_DISTORT));
		} 
		land_vel=(int)random(3,10);
		land_index=0;

		elastic_strength=(float)land_vel/10*random(1,3);


		 // mtext=new MeatTexture(-body_wid*.1,-body_hei*.3,wid,body_hei,fcolor);
		// mtext.draw();
		sktb=new SkateBoard(0,body_hei+leg_hei/4*3,wid*random(.5f,.8f),hei*random(.1f,.4f));

		water=new SwimWater(wid/4,hei/2,hei*random(.2f,.6f)+body_hei/5,hei/10);
		wheels=new FireWheel[2];
		wheels[0]=new FireWheel(wid/4,hei,hei*random(.3f,.5f));
		wheels[1]=new FireWheel(wid/4*3,hei,hei*random(.3f,.5f));

		sship=new SpaceShip(x,hei*random(1,3),wid,hei,phi,jump_vel,transport_mode);

		// cookie=new Cookie(body_wid/2,hei+body_hei,wid*random(.2,.5),hei*random(.2,.4));

		volcano=new Volcano(x,height-hei*random(7),wid*random(.8f,1.5f),hei*random(.2f,.4f),v_jump_vel,phi);
		v_jump_dest_y=volcano.dest_rad;
	}	

	public void draw(PGraphics pg,boolean draw_fill){
		
		if(transport_mode==3|| transport_mode==4){
			boolean change=sship.draw(pg,draw_fill);
			if(change){

				transport_mode++;
				sship.play_mode=transport_mode;
				//println("change transport_mode to "+transport_mode);
			}
		}
		
		if(transport_mode==5){
			//println("animal finished!");
			return;
		}
 		//image(mtext.pg,0,0,wid,hei);
		pg.pushStyle();
		
		if(draw_fill){
		 	pg.noStroke();
		 	pg.fill(fcolor);
		 	if(transport_mode==8) pg.fill(red(fcolor),green(fcolor)*2,blue(fcolor)*2,150);
		}else{
		 	// pg.noFill();
		 	pg.fill(fcolor);
		 	pg.stroke(0);
		}
		
		float draw_portion=1.5f*abs(sin((float)frameCount/(120/land_vel)));



		float elastic_portion=.6f+elastic_strength*abs(sin((float)frameCount/(180/land_vel)+phi));
		
		int new_elastic_stage=(int)((((float)frameCount/(180/land_vel)+phi)%PI)/(PI/2));

		float cur_body_wid=(transport_mode==0)?body_wid*elastic_portion:body_wid;
		if(transport_mode==0)
			if(elastic_stage==1 && new_elastic_stage==0) x+=body_wid*(0.6f+elastic_strength)-body_wid*.6f;
		elastic_stage=new_elastic_stage;


		float jump_portion=(transport_mode==4)?(float)frameCount/(jump_vel)+phi
											  :(float)frameCount/(v_jump_vel)+phi;
		jump_portion%=TWO_PI;
		int jump_stage=0;//sship.stage;//(int)((jump_portion)/(PI/2));
		float jump_pos_y=0;
		float jump_pos_x=0;
		if(transport_mode==4){
			jump_stage=sship.stage;
			if(jump_stage==2||jump_stage==3){
				jump_pos_y=sship.ray_cur_y-y-body_hei;
				jump_pos_x=sship.ship_delta_x;
			}
		}
		if(transport_mode==6){
			jump_stage=(int)(jump_portion/(PI/2));
			int jump_y_cycle=floor(((float)frameCount/(v_jump_vel)+phi)/TWO_PI);
			float jump_y_portion=1;//.3+1.2*abs(sin(jump_y_cycle));
			if(jump_stage==2||jump_stage==3){
				jump_pos_y=-abs(v_jump_dest_y*jump_y_portion*sin(jump_portion));	
			}else{
				jump_pos_y=abs(leg_hei*sin((jump_portion)));
			}
			if(jump_stage==2||jump_stage==1) volcano.draw(pg,draw_fill,true,false);	
			else volcano.draw(pg,draw_fill,false,false);
			
		}
		if(transport_mode==8){
			float swim_portion=(float)frameCount/(swim_vel/land_vel)+phi;
			int swim_stage=(int)((swim_portion%TWO_PI)/(PI/2));
			if(swim_stage==3){
				y+=-sq(sin(swim_portion-PI/2))*body_hei/3*abs(cos(phi)+.1f);	
				// s_body_hei_incre=-abs(sin(swim_portion)*body_hei);
			}else if(swim_stage==2){
				y+=-sq(sin(swim_portion-PI/2))*body_hei/2*abs(cos(phi)+.1f);	
			}else{
				y+=-sq(sin(swim_portion))*body_hei/12*abs(cos(phi)+.1f);	
			}
			
			s_body_hei_incre=-abs(sin((swim_portion%TWO_PI)/2)*body_hei*abs(cos(phi)+.1f));
			if(y<-height/3) y=height+height/3;

		}else s_body_hei_incre=0;

		if(transport_mode==7){
			float disco_portion=(float)frameCount/(disco_vel/land_vel/2)+phi;
			int new_disco_stage=(int)((disco_portion%TWO_PI)/(PI/2));
			
			int disco_cycle=(int)((disco_portion+PI/2)/(TWO_PI));
			int steps=PApplet.parseInt(abs(sin(phi))*2+1);

			if(disco_stage==-2) disco_stage=new_disco_stage;
			if(disco_stage==2 && new_disco_stage==3){
				// println(disco_cycle%(steps*2));
				int icycle=disco_cycle%(steps*2);
				if(icycle>0 && icycle<steps) x+=leg_hei*sin(PI/6)*4+last_foot_base.y;//(first_foot_base.y);
				else if(icycle>steps && icycle<steps*2)
					x-=leg_hei*sin(PI/6)*4+last_foot_base.y;
				// println("go!");
			}
			disco_stage=new_disco_stage;

			// println(disco_stage);
			disco_portion%=TWO_PI;
			if(disco_cycle%(steps*2)<steps){
				if(disco_stage==0||disco_stage==3){
					jump_pos_x=-last_foot_base.x;
				}else{
					jump_pos_x=-((first_foot_base.x-first_foot_base.y)+last_foot_base.y);//-body_wid);//*(sin(disco_portion));
				}
			}else{
				if(disco_stage==1||disco_stage==2){
					jump_pos_x=-last_foot_base.x;
				}else{
					jump_pos_x=-((first_foot_base.x-first_foot_base.y)+last_foot_base.y);//-body_wid);//*(sin(disco_portion));
				}

			}

			// else if(disco_stage==3){
			// 	jump_pos_x=body_wid;//*(sin(disco_portion));
			// }
		}

		//if(!draw_fill) pg.line(x,y,x+wid,y);
		

		pg.pushMatrix();

		if(transport_mode==8) pg.rotate(sin(phi)*PI/4);

		if(transport_mode==0){
			if(elastic_stage==0) pg.translate(x,y);
			else pg.translate(x+body_wid*(0.6f+elastic_strength)-cur_body_wid,y);
		}else if(transport_mode==7){
			pg.translate(width/2,height/2);
			pg.rotate(phi/2);
			pg.translate(-width/2,-height/2);
			
			pg.translate(x+jump_pos_x,y+jump_pos_y);

		}else{
			pg.translate(x+jump_pos_x,y+jump_pos_y);
		}
		
		if(transport_mode==1 && draw_fill){
			//sktb.x=x+cur_body_wid/2;
			sktb.draw(pg);
		}
		if(transport_mode==2){
		// 	//water.x=cur_body_wid/4;
			
				
			wheels[0].setPos(first_foot_base);
			wheels[1].setPos(last_foot_base);
			float frame_portion=(float)frameCount/(wheel_vel/land_vel)+phi;
			int stage=(int)((frame_portion%TWO_PI)/(PI/2));
			if(stage>1 && draw_fill)
				for(FireWheel wheel:wheels) wheel.draw(pg,draw_fill);
			
		}
		// if(transport_mode==7 && !draw_fill){
		// 	pg.pushStyle();
		// 	pg.stroke(255,0,0);
		// 	pg.strokeWeight(2);
		// 	pg.line(jump_pos_x,0,jump_pos_x,100);
		// 	pg.stroke(0,255,0);
		// 	pg.line(first_foot_base.y,0,first_foot_base.y,100);
		// 	pg.popStyle();
		// }

		pg.beginShape();
		pg.vertex(0,0+s_body_hei_incre);
		if(transport_mode==7){
			pg.bezierVertex(cur_body_wid/3,-body_hei*.3f*draw_portion+body_hei*.3f*random(-1,1),
						 cur_body_wid/3*2,-body_hei*.3f*draw_portion+body_hei*.3f*random(-1,1),
						 cur_body_wid,0);
		}else
			pg.bezierVertex(cur_body_wid/3,-body_hei*.3f*draw_portion+s_body_hei_incre,
						 cur_body_wid/3*2,-body_hei*.3f*draw_portion+s_body_hei_incre,
						 cur_body_wid,0);


		PVector ear_base1=new PVector(head_hei,0);
		ear_base1.rotate((-PI/3)*draw_portion-PI/6-PI/4);
		PVector ear_base2=new PVector(head_hei,0);
		ear_base2.rotate(-PI/3*draw_portion-PI/4);
		
		pg.bezierVertex(cur_body_wid+ear_base1.x,ear_base1.y,
					  cur_body_wid+ear_base2.x,ear_base2.y,
					  cur_body_wid,0);

		pg.bezierVertex(cur_body_wid+head_wid/2,-body_hei*.1f*draw_portion,
					 cur_body_wid+head_wid,head_hei+body_hei*.4f*draw_portion,
					 cur_body_wid,head_hei);
		// vertex(cur_body_wid,body_hei);
		// bezierVertex(cur_body_wid*.95,body_hei,cur_body_wid,body_hei,
		// 			
	
		pg.vertex(cur_body_wid*(1-(float)(0+leg_span.get(0))/mleg),body_hei);

		for(int i=0;i<mleg;++i){
			if(i>0) pg.vertex(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei);

			if(transport_mode==1) drawLegOnSkateBoard(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei,leg_wid,leg_hei,i,pg);
			else if(transport_mode==0) drawRunLeg(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei,leg_wid,leg_hei,i,pg);
			else if(transport_mode==2) drawWheelLeg(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei,leg_wid,leg_hei,i,pg);
			else if(transport_mode==6) drawJumpLeg(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei,leg_wid,leg_hei,i,pg);
			else if(transport_mode==8) drawSwimLeg(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei,leg_wid,leg_hei,i,pg);
			else if(transport_mode==7) drawDiscoLeg(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei,leg_wid,leg_hei,i,pg);
					
		}
		
		pg.bezierVertex(-cur_body_wid*.1f*draw_portion,body_hei,
					 -cur_body_wid*.1f*draw_portion,0,
					 0,0+s_body_hei_incre);


		pg.endShape();
		if(!draw_fill){
			pg.stroke(red(fcolor)/1.1f,green(fcolor)/1.1f,blue(fcolor)/1.3f);
			pg.beginShape();
			for(int i=0;i<80;++i){
					// pg.strokeWeight(random(2));
					pg.vertex(random(cur_body_wid),
							   random(-body_hei*.1f,body_hei/2));
			
			}
			pg.endShape();
		}


		if(draw_fill && transport_mode==0) drawLand(pg);
		if(transport_mode==2 && !draw_fill){
			for(FireWheel wheel:wheels) wheel.draw(pg,draw_fill);
			// for(FireWheel wheel:wheels) wheel.draw(pg,draw_fill);
		}

		pg.popMatrix();
		

		pg.popStyle();

		
		update();
	}

	public void update(){
		switch(transport_mode){
			case 0:
				if(random(500)<1){
				 land_vel+=(int)random(-2,2);
				 elastic_strength=(float)land_vel/10*random(1,3);
				}
				land_vel=constrain(land_vel, 5, 20);

				if(x<width/20*land_vel) x+=land_vel/10;
				else if(x>width/20*land_vel) x-=land_vel/10;
				break;

			case 1:
			case 2:
				land_vel=constrain(land_vel, 5, 20);
				x+=(transport_mode==2)?land_vel/2:land_vel/3;
				break;
			case 3:
				//x=width/2;
				break;
		}
		
	}
	public void drawRunLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg){


		float frame_portion=(float)frameCount/(run_vel/land_vel)+phi;
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		
		float kang=-PI/2.5f*(sin(frame_portion));
		if(leg_index%2==1) kang=-PI/2.5f*(sin(frame_portion+PI/2));
		float fang=0;//kang+PI/1.8;
		
		switch(stage){
			case 0:
				fang=kang+PI/1.6f;//*(sin(frame_portion));
				break;
			case 1:
				fang=kang+PI/1.6f*((sin(frame_portion)));
				break;
				//println(stage+"  "+((sin(frame_portion))));
			case 2:
				//kang=PI/3;//*(sin(frame_portion));
				fang=kang;//PI/1.6*(sin(frame_portion));
				//ang=kang+PI/1.6;//*abs(sin(frame_portion%TWO_PI*2));
				break;
			
			case 3:
				float ang=frame_portion%TWO_PI-PI/2*3;
				//kang=PI/3*(sin(ang*2+PI/2*3));
				fang=kang+PI/1.6f*(1-abs(sin(frame_portion)));
				break;
				
		}
		drawLegs(kang,fang,lx,ly,lw,lh,leg_index,pg);
		
	}	
	public void drawLegs(float kang,float fang,float lx,float ly,float lw,float lh,int leg_index,PGraphics pg){	
		PVector knee_base=new PVector(0,lh/2);
		knee_base.rotate(kang);

		PVector foot_base=new PVector(0,lh/2);
		foot_base.rotate(fang);
		

		PVector foot_base2=new PVector(-lw,lh/2);
		foot_base2.rotate(fang);
		
		

		foot_base.add(knee_base);
		foot_base2.add(knee_base);
		
		pg.bezierVertex(lx+knee_base.x,ly+knee_base.y,
					 lx+foot_base.x,ly+foot_base.y,
					 lx+foot_base.x,ly+foot_base.y);
		// vertex(lx+knee_base.x,ly+knee_base.y);
		// vertex(lx+foot_base.x,ly+foot_base.y);
		
		pg.vertex(lx+foot_base2.x,ly+foot_base2.y);

		// vertex(lx-lw+knee_base.x,ly+knee_base.y);
		// vertex(lx-lw,ly);

		pg.bezierVertex(lx-lw+knee_base.x,ly+knee_base.y,
					 lx-lw+knee_base.x,ly+knee_base.y,
					 lx-lw,ly);

		switch(transport_mode){
			case 1:
				if(leg_index==0) first_foot_base=new PVector(lx-lw+foot_base.x,ly+foot_base.y);
				else if(leg_index==mleg-1) last_foot_base=new PVector(lx+lw+foot_base.x,ly+foot_base.y);
				break;
			case 2:
				if(leg_index==0) first_foot_base=new PVector(lx-lw+foot_base.x,ly+lh);
				else if(leg_index==mleg-1) last_foot_base=new PVector(lx+lw+foot_base.x,ly+lh);
				break;
			case 7:
				if(leg_index==0) first_foot_base=new PVector(lx-lw+foot_base.x,lx-lw+lh*sin(PI/6));
				else if(leg_index==mleg-1) last_foot_base=new PVector(lx+lw+foot_base.x,lx+lw-lh*sin(PI/6),lx+lw+lh*sin(PI/6));
				break;
		}
	}
	public void drawLegOnSkateBoard(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg){


		float frame_portion=(float)frameCount/(skate_vel/land_vel)+phi;
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		
	
		float fang=PI/8;
		if(leg_index>(mleg-1)/2) fang-=-PI/10*abs(sin(frame_portion));//PI/6*(sin(frame_portion+PI/2));
		float kang=fang;

		drawLegs(kang,fang,lx,ly,lw,lh,leg_index,pg);
			


	}
	public void drawLand(PGraphics pg){
		pg.pushStyle();
		//noFill();
		pg.stroke(0,120);
		pg.translate(-wid,hei);
		

		pg.beginShape();
		int len=land_poses.size();
		for(int i=0;i<len;++i) pg.vertex(i,land_poses.get((i+land_index)%len));
		for(int i=len;i>=0;--i){
		 if(i<0 || i>=land_poses.size()) continue;
		 pg.vertex(i,land_poses.get((i+land_index)%len)+random(-LAND_DISTORT,LAND_DISTORT));
		}
		pg.endShape();
		
		pg.popStyle();
		
		land_index+=land_vel;

		// for(int i=0;i<land_vel;++i) land_poses.remove(0);
		// for(int i=0;i<land_vel;++i){
			
		// 	if(random(20)<1) land_poses.append(random(-LAND_DISTORT,0)*30);
		// 	else land_poses.append(random(-LAND_DISTORT,LAND_DISTORT));
		// }


	}
	public void drawSwimLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg){

		float frame_portion=(float)frameCount/(swim_vel/land_vel)+phi;
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		
		float kang=0;//*(sin(frame_portion));
		boolean left_leg=(leg_index<(mleg+1)/2);
		// if(!left_leg) kang=-PI/3*(sin(frame_portion));
		float fang=0;//kang+PI/1.8;
		
		float ang=frame_portion%TWO_PI;		
		switch(stage){
			case 0:
				kang=PI/6*(left_leg?1:-1);
				
				// kang=(-(PI/3+PI/6)*(sin(ang))+PI/6)*(left_leg?1:-1);
				// kang=(-(PI/3)*(sin(ang)))*(left_leg?1:-1);
				fang=kang+PI/1.3f*(sin(ang))*((left_leg)?1:-1);

				break;
			case 1:
				// kang=-PI/3*(left_leg?1:-1);//
				kang=(-(PI/3+PI/6)*(sin(ang-PI/2))+PI/6)*(left_leg?1:-1);
				fang=kang+PI/1.3f*((left_leg)?1:-1);//*((sin(frame_portion)))*((left_leg)?1:-1);
				break;
			case 2:
				kang=-PI/3*(sin(ang-PI/2))*(left_leg?1:-1);
				fang=kang;//+PI/1.3*sin((ang-PI/2))*(left_leg?1:-1);
				break;
			
			case 3:
				kang=-PI/6*(sin((ang-PI/2)))*(left_leg?1:-1);
				fang=kang;
				break;
				
		}
		
		drawLegs(kang,fang,lx,ly,lw,lh,leg_index,pg);

	
	}

	public void drawWheelLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg){

		float frame_portion=(float)frameCount/(wheel_vel/land_vel)+phi;
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		
		float kang=-PI/2*(sin(frame_portion));
		if(leg_index%2==1) kang=-PI/2*(sin(frame_portion+PI/4));
		float fang=0;//kang+PI/1.8;
		
		switch(stage){
			case 0:
				fang=kang+PI/1.6f;
				break;
			case 1:
				fang=kang+PI/1.6f*((sin(frame_portion)));
				break;
			case 2:
				fang=kang;
				break;
			case 3:
				fang=kang+PI/1.6f*(1-abs(sin(frame_portion)));
				break;
				
		}
		
		drawLegs(kang,fang,lx,ly,lw,lh,leg_index,pg);

	}

	public void drawJumpLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg){

		float frame_portion=(float)frameCount/(v_jump_vel)+phi;
		frame_portion%=TWO_PI;
		int stage=(int)((frame_portion)/(PI/2));
		
		boolean left=(leg_index>(mleg-1)/2);
		float aoffset=0;//((left)?-PI/6:PI/6);
		
		float kang=0;//-PI/2*(sin(frame_portion));
		float fang=0;//kang+PI/1.8;
		
		switch(stage){
			case 0:
				kang=-PI/3*((sin(frame_portion)))+aoffset;
				fang=kang+PI/1.7f*((sin(frame_portion)));
				break;
			case 1:
				kang=-PI/3*sin((frame_portion))+aoffset;
				fang=kang+PI/1.7f*((sin(frame_portion)));
				break;
			case 2:
				if(left) kang=0+PI/4*sin((frame_portion));
				else kang=0-PI/4*sin((frame_portion));
				fang=kang;//+PI/3*(1-abs(sin(frame_portion)));
				break;
			case 3:
				if(left) kang=0+PI/4*sin((frame_portion));
				else kang=0-PI/4*sin((frame_portion));//-PI/3*sin((frame_portion-PI/2*3)*2+PI/2*3);
				fang=kang;
				break;
				
		}
		//kang-=PI/6;
		// if(leg_index>(mleg-1)/2){
		// 	kang-=PI/6;// fang*=-1;
		// }else{
		// 	kang+=PI/6;
		// }


		drawLegs(kang,fang,lx,ly,lw,lh,leg_index,pg);

	}
	public void drawDiscoLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg){


		float frame_portion=(float)frameCount/(disco_vel/land_vel/2)+phi;
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		frame_portion%=TWO_PI;
		
		float fang=-PI/6*(sin(frame_portion));
		boolean isLeft=!(leg_index>(mleg-1)/2);// fang=-PI/8*(sin(frame_portion));//PI/6*(sin(frame_portion+PI/2));
		if(!isLeft) fang*=-1;
		float kang=fang;

		drawDancingLegs(kang,fang,lx,ly,lw,lh,leg_index,pg);
			
	}
	public void drawDancingLegs(float kang,float fang,float lx,float ly,float lw,float lh,int leg_index,PGraphics pg){	
		PVector knee_base=new PVector(0,lh/2);
		knee_base.rotate(kang);

		PVector foot_base=new PVector(0,lh/2);
		foot_base.rotate(fang);
		

		PVector foot_base2=new PVector(-lw,lh/2);
		foot_base2.rotate(fang);
		
		foot_base.add(knee_base);
		foot_base2.add(knee_base);
		
		float frame_portion=(float)frameCount/(disco_vel/land_vel/2)+phi;
		float draw_portion=sin(frame_portion);//*random(-1,1);

		pg.bezierVertex(lx+knee_base.x+lw*draw_portion,ly+knee_base.y,
					 lx+foot_base.x+lw*draw_portion,ly+foot_base.y,
					 lx+foot_base.x,ly+foot_base.y);
		// vertex(lx+knee_base.x,ly+knee_base.y);
		// vertex(lx+foot_base.x,ly+foot_base.y);
		
		pg.vertex(lx+foot_base2.x,ly+foot_base2.y);

		// vertex(lx-lw+knee_base.x,ly+knee_base.y);
		// vertex(lx-lw,ly);

		pg.bezierVertex(lx-lw+knee_base.x+lw*draw_portion,ly+knee_base.y,
					 lx-lw+knee_base.x+lw*draw_portion,ly+knee_base.y,
					 lx-lw,ly);

		switch(transport_mode){
			case 1:
				if(leg_index==0) first_foot_base=new PVector(lx-lw+foot_base.x,ly+foot_base.y);
				else if(leg_index==mleg-1) last_foot_base=new PVector(lx+lw+foot_base.x,ly+foot_base.y);
				break;
			case 2:
				if(leg_index==0) first_foot_base=new PVector(lx-lw+foot_base.x,ly+lh);
				else if(leg_index==mleg-1) last_foot_base=new PVector(lx+lw+foot_base.x,ly+lh);
				break;
			case 7:
				if(leg_index==0) first_foot_base=new PVector(lx-lw+foot_base.x,lx-lw+lh*sin(PI/6));
				else if(leg_index==mleg-1) last_foot_base=new PVector(lx+lw+foot_base.x,lx+lw-lh*sin(PI/6),lx+lw+lh*sin(PI/6));
				break;
		}
	}
}


class SkateBoard{
	

	float x,y,wid,hei;
	float wheel_rad;
	float board_rad;

	int mwind=(int)random(2,5);


	SkateBoard(float x_,float y_,float wid_,float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		wheel_rad=random(.2f,.5f)*hei;
		board_rad=random(.2f,.6f)*wid;
	}

	public void draw(PGraphics pg){

		float draw_portion=abs(sin((float)frameCount/80));
		pg.pushStyle();
		pg.fill(255);
		pg.stroke(0);

		pg.pushMatrix();
		pg.translate(x,y);

		pg.beginShape();
			pg.vertex(0,0);
			pg.bezierVertex(-board_rad,0,-board_rad*1.3f,hei,
						 0,hei);
			pg.bezierVertex(wid/3,hei+hei*.1f*draw_portion,wid/3*2,hei+hei*.1f*draw_portion,
						 wid,hei);
			pg.bezierVertex(wid+board_rad*1.3f,hei,wid+board_rad,hei*.1f*draw_portion,
						 wid,0);
			
			pg.bezierVertex(wid/3*2,hei*.1f*draw_portion,wid/3*2,-hei*.1f*draw_portion,
						 0,0);
		pg.endShape();

		drawWheel(0,hei+wheel_rad/2,pg);
		drawWheel(wid,hei+wheel_rad/2,pg);

		drawWind(-wid/2-wid/2.5f,hei*1.5f,wid/3,hei/2,pg);

		pg.popMatrix();

		pg.popStyle();
		
	}
	public void drawWheel(float wx,float wy,PGraphics pg){
		pg.pushMatrix();
		pg.translate(wx,wy);
			for(int i=0;i<3;++i){
				float rad=wheel_rad/2;//-wheel_rad*i/10;
				pg.rotate((float)frameCount/2+i/2);
				pg.beginShape();
					pg.vertex(0,-rad/2);
					pg.bezierVertex(-rad,-rad/2,-rad,rad/2,
								 0,rad/2);
					pg.bezierVertex(rad,rad/2,rad,-rad/2,
								 0,-rad/2);
				pg.endShape();
			}
		pg.popMatrix();
	}

	public void drawWind(float wx,float wy,float wwid,float whei,PGraphics pg){
		pg.pushMatrix();
			pg.translate(wx,wy);
			whei/=(float)3;
			for(int i=0;i<mwind;++i){
				wwid*=random(.5f,2);
				pg.translate(wwid*.3f*sin((float)frameCount),-whei);
				pg.beginShape();
					pg.vertex(wwid,0);
					pg.bezierVertex(wwid*random(.1f,.5f),whei*.1f*random(-1,1),
								 wwid*random(.6f,.9f),whei*.1f*random(-1,1),
								 0,0);

					// PVector ctrl=new PVector(-whei/2,0);
					// ctrl.rotate(PI*sin((float)frameCount));
					// pg.bezierVertex(-wwid/4*random(.5,1.5),0,
					// 			ctrl.x,ctrl.y-whei/4,
					// 			0,-whei/4);
					
				pg.endShape();
				pg.arc(0,-wwid/8,wwid/4,wwid/4,HALF_PI,PI/4+PI/2*3*sin((float)frameCount/2));
			}


		pg.popMatrix();
	}


}

public void drawSpace(PGraphics pg,boolean draw_fill){

	int noise_scale=10;
	// pg.beginDraw();
	// pg.background(0);
	pg.noStroke();
	PVector color_separate=new PVector(0.33f,0.33f,0.33f);
	int cycle=(int)((float)frameCount/80)%3;
	if(cycle==0) color_separate.x=1;
	if(cycle==1) color_separate.y=1;
	if(cycle==2) color_separate.z=1;
	
	for(int x=0;x<pg.width;x+=noise_scale)
		for(int y=0;y<pg.height;y+=noise_scale){
    		float val=noise(x+random(-1,1),y+random(-1,1));
    		pg.fill(val*220*color_separate.x,val*220*color_separate.y,val*220*color_separate.z);
    		pg.rectMode(CENTER);
    		pg.rect(x,y,noise_scale*sq(val),noise_scale*sq(val));
  		}





  	// pg.endDraw();


}
class SpaceShip{
	
	float x,y,wid,hei;		
	float phi;
	int mwindow;
	FloatList window_portion;
	int mray;
	FloatList ray_portion;
	float vel;
	
	float ray_bottom_y; 
	float play_mode;
	
	float rot_vel;
	float ray_wid;
	float ray_animal_y;
	float ray_cur_y;

	float ship_delta_x;
	float ship_far_pos;

	int stage=0;
	int start_frame;
	float portion=0;

	SpaceShip(float x_,float y_,float wid_,float hei_,float phi_,float vel_,int mode_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		phi=phi_;
		vel=vel_;
		mwindow=(int)random(3,8);	
		window_portion=new FloatList();
		for(int i=0;i<mwindow;++i){
			window_portion.append(random(.2f,1));
		}
		mray=(int)random(4,12);
		ray_portion=new FloatList();
		// for(int i=0;i<mray;++i) ray_portion.append(random(.1,1));

		play_mode=mode_;

		rot_vel=random(10,50);
		ray_wid=random(PI/50,PI/8);
		ship_far_pos=width*((random(2)>1)?1:-1)*random(-2,2);
		
		start_frame=frameCount;

	}
	

	public boolean draw(PGraphics pg,boolean draw_fill){
		

		boolean finished=false;
		boolean draw_ray=(play_mode==4);

		portion=((float)(frameCount-start_frame)/vel+phi)%TWO_PI;
		float draw_portion=abs(cos(portion));
		
		int new_stage=(int)(portion/PI*2);
		if(new_stage==0&&stage==3){
			finished=true;
			stage=new_stage;
			return finished;
		}
		stage=new_stage;
		
		if(draw_ray){
			if(stage==3|| stage==0) ship_delta_x=ship_far_pos*cos(portion);
			else ship_delta_x=0;
		}else{
			if(stage==3 || stage==0) ship_delta_x=cos(portion)*ship_far_pos;
			else ship_delta_x=(wid)*cos(portion)*(ship_far_pos/abs(ship_far_pos));
		}
		


		pg.pushStyle();
		if(draw_fill){
			pg.fill(20,phi*125*random(.8f,1.2f),phi/TWO_PI*20+180,255);
			pg.noStroke();
		}else{
			// pg.fill(255,255);
			pg.noFill();
			pg.stroke(255,200);
			// pg.strokeWeight(1);
		}

		pg.pushMatrix();
		pg.translate(x+ship_delta_x,y+hei/2);


		pg.pushMatrix();
		pg.translate(0,0);
			pg.beginShape();

				pg.vertex(0,0);
				pg.bezierVertex(wid/8,-hei/8*draw_portion,
							wid/8,-hei/8*draw_portion,
							wid/4,-hei/12);
				pg.bezierVertex(wid/4,-hei/3-hei/6*draw_portion,
							wid/4*3+wid/8,-hei/4-hei/6*draw_portion,
							wid/4*3,-hei/12);
				pg.bezierVertex(wid/8*7,-hei/8*draw_portion,
							wid/8*7,-hei/8*draw_portion,
							wid,-hei/12);
				pg.bezierVertex(wid/8*7,hei/5+hei/7*draw_portion,
							 wid/2*sin(phi),hei/4+hei/7*draw_portion,
							 0,0);

			pg.endShape();
			pg.beginShape();

				pg.vertex(0,0);
				pg.bezierVertex(wid/8,hei/8*draw_portion,
							wid/8,hei/8*draw_portion,
							wid/4,hei/12);
				pg.bezierVertex(wid/4,hei/3+hei/16*draw_portion,
							wid/4*3+wid/8,hei/4+hei/6*draw_portion,
							wid/4*3,hei/12);
				pg.bezierVertex(wid/12*7,hei/8*draw_portion,
							wid/12*11,hei/11*draw_portion,
							wid,0);

			pg.endShape();
		

		
		pg.popStyle();

		pg.pushStyle();
		if(draw_fill){
			pg.fill(255);
			pg.noStroke();
		}else{
			pg.noFill();
			pg.stroke(0,200);
		}


		pg.pushMatrix();
		pg.translate(wid/3.5f*draw_portion/5+wid/4,0);
		float wwindow=wid/2/(float)mwindow*.65f;

		
		// window
		pg.beginShape(QUADS);
		for(int i=0;i<mwindow;++i){
				float port=window_portion.get(i);
				pg.vertex(wwindow*i,0);
				pg.vertex(wwindow*(i+port),0);
				pg.vertex(wwindow*(i+sin(port)),-hei/12);
				pg.vertex(wwindow*i*cos(port),-hei/12);				
		}
		pg.endShape();

		pg.popMatrix();
		pg.popStyle();

		pg.popMatrix();

		pg.pushStyle();
		
			//light
			
			if(draw_fill){
				pg.noFill();
				pg.stroke(255,40);
			}else{
				pg.noFill();
				pg.stroke(255,200);
			}
			// float cur_phi=(draw_ray)?0:PI/8*sin((float)frameCount/25+phi);
		float cur_phi=(draw_ray)?0:getCurrentRayPhi();
		PVector rayv=new PVector(0,ray_bottom_y);
		rayv.rotate(-cur_phi);

		PVector rayv_b=new PVector(0,ray_bottom_y);
		rayv_b.rotate(-cur_phi-ray_wid);
		
		
		if(!draw_ray&&draw_fill){
			pg.beginShape();
				
				for(int i=0;i<mray;++i){
					float rad=random(ray_bottom_y);
					float theta=random(0,ray_wid)+cur_phi;
					pg.vertex(wid/2+rad*sin(theta),rad*cos(theta));
				}
			pg.endShape();
		}


		pg.popStyle();

		
		pg.popMatrix();
		if(draw_ray){
			drawCatchRay(x+wid/2+ship_delta_x,y+hei/2,ray_bottom_y,ray_animal_y,wid,pg,draw_fill);
		}
		
		return finished;

	}


	public float getCurrentRayPhi(){

		float rot_portion=(float)frameCount/(rot_vel)+phi;
		rot_portion%=TWO_PI;
		int rot_stage=(int)((rot_portion)/(PI/4));
		float ang=0;
		switch(rot_stage){
			case 0:
			case 1:
			case 2:
				rot_portion-=PI/4*rot_stage;
				ang=ray_wid*(sin((rot_portion)*4));
				break;
			case 3:
				rot_portion-=PI/4*3;
				ang=PI*sin((rot_portion)*2);
				break;
			case 4:
			case 5:
			case 6:
				rot_portion-=PI/4*rot_stage;
				ang=PI+ray_wid*(sin((rot_portion)*4));
				break;
			case 7:
				rot_portion-=PI/8*7;
				ang=PI+PI*sin((rot_portion)*2);
				break;
		}
		//println(ang/PI);
		return ang-ray_wid/2;

	}

	public void drawCatchRay(float top_x,float top_y,float bottom_y,float animal_y,float animal_w,PGraphics pg,boolean draw_fill){
		
		pg.pushStyle();
		if(draw_fill){
			pg.stroke(0,255,255);
			pg.noFill();
		}else{
			pg.stroke(255,255,0);
			pg.noFill();
		}

		pg.pushMatrix();
		pg.translate(top_x,0);
			// float portion=((float)frameCount/vel+phi)%TWO_PI;
			// int stage=(int)(portion/PI*2);

			ray_cur_y=bottom_y;
			float tmp_wid=animal_w;
			float close_wid=0;

			switch(stage){
				case 0: // down
					ray_cur_y=(bottom_y-top_y)*abs(sin(portion))+top_y;
					tmp_wid=map(ray_cur_y-top_y,0,bottom_y-top_y,0,animal_w);
 					pg.beginShape();
						pg.vertex(tmp_wid/2,ray_cur_y);
						if(ray_cur_y>animal_y) pg.vertex(tmp_wid/2,animal_y);
						
						pg.vertex(0,top_y);
						
						if(ray_cur_y>animal_y) pg.vertex(-tmp_wid/2,animal_y);
						pg.vertex(-tmp_wid/2,ray_cur_y);		
					pg.endShape();
					break;
 				case 1: // close
 					close_wid=map(portion,PI/2,PI,tmp_wid/2,0);
 					pg.beginShape();
 						pg.vertex(close_wid,bottom_y);
						pg.vertex(tmp_wid/2,bottom_y);
						pg.vertex(tmp_wid/2,animal_y);
						
						pg.vertex(0,top_y);
						
						pg.vertex(-tmp_wid/2,animal_y);
						pg.vertex(-tmp_wid/2,bottom_y);		
						pg.vertex(-close_wid,bottom_y);
					pg.endShape();
					break;
				case 2: // up
					ray_cur_y=(bottom_y-top_y-(bottom_y-animal_y)*2)*abs(cos(portion))+top_y+(bottom_y-animal_y)*2;
					pg.beginShape();
 						pg.vertex(close_wid,ray_cur_y);
						pg.vertex(tmp_wid/2,ray_cur_y);
						pg.vertex(tmp_wid/2,ray_cur_y-(bottom_y-animal_y));
						
						pg.vertex(0,top_y);
						
						pg.vertex(-tmp_wid/2,ray_cur_y-(bottom_y-animal_y));
						pg.vertex(-tmp_wid/2,ray_cur_y);		
						pg.vertex(-close_wid,ray_cur_y);
					pg.endShape();
					break;
 				case 3: // stay up
 					ray_cur_y=top_y+(bottom_y-animal_y)*1.5f;
					pg.beginShape();
 						pg.vertex(close_wid,ray_cur_y);
						pg.vertex(tmp_wid/2,ray_cur_y);
						pg.vertex(tmp_wid/2,ray_cur_y-(bottom_y-animal_y));
						
						pg.vertex(0,top_y);
						
						pg.vertex(-tmp_wid/2,ray_cur_y-(bottom_y-animal_y));
						pg.vertex(-tmp_wid/2,ray_cur_y);		
						pg.vertex(-close_wid,ray_cur_y);
					pg.endShape();
					break;

			}
			
		pg.popMatrix();

		pg.popStyle();
	}

}


class SpotLight{
	
	float x,y,rad;
	int light_color;
	float splash_time;

	float dest_x,dest_y,dest_rad;
	float orig_x,orig_y,orig_rad;
	// float update_t;
	float vel=random(5,20);
	float phi=random(TWO_PI);
	
	int update_stage;
	boolean finished=false;
	int dest_iani;

	int color_index;

	SpotLight(int color_i){
		color_index=color_i;
		int iani=(int)random(mpas_to_play);
		PAnimal pa=pas.get(iani);
		orig_x=x=random(width/3);//pa.x+pa.body_wid/2;
		if(random(2)<1) orig_x=0-orig_x;
		else orig_x=width+orig_x;

		orig_y=y=random(height);//pa.y;
		orig_rad=rad=random(width/2,width*3);//max(pa.wid,pa.hei);

		resetColor();
		splash_time=2+random(5);

	}
	SpotLight(float x_,float y_,float rad_){
		x=x_; y=y_; rad=rad_;
		orig_x=x_; orig_y=y_; orig_rad=rad_;
		
		light_color=color(255,20,147);
		splash_time=2+random(5);

	}

	
	public void draw(PGraphics pg,boolean draw_fill){
		pg.pushStyle();
		if(draw_fill){
			pg.noStroke();
			if(random(splash_time)<1) pg.fill(light_color);
		}
		pg.pushMatrix();
		pg.translate(x,y);
		pg.ellipse(0,0,rad,rad);
		pg.popMatrix();

		pg.popStyle();

		update();
	}
	public void drawCone(PGraphics pg,boolean draw_fill){
		pg.pushStyle();
		if(draw_fill){
			pg.noStroke();
			if(random(splash_time)<1) pg.fill(light_color);
		}
		pg.pushMatrix();
		pg.translate(orig_x,orig_y);
		pg.rotate(phi);
		pg.beginShape();
			pg.vertex(0,0);
			float frame_portion=(float)frameCount/(vel)+phi;
			frame_portion%=TWO_PI;
			float theta=PI/3*frame_portion;
			pg.vertex(rad*cos(theta+PI/15)*8,rad*sin(theta+PI/15)*8);
			pg.vertex(rad*cos(theta-PI/15)*8,rad*sin(theta-PI/15)*8);
		pg.endShape();

		pg.popMatrix();

		pg.popStyle();

		resetColor();
		
		// update();
	}

	public void update(){
		
		float frame_portion=(float)frameCount/(vel)+phi;
		frame_portion%=TWO_PI;
		int new_stage=(int)((frame_portion)/(PI/2));

		PAnimal pa=pas.get(dest_iani);
		dest_x=pa.x+pa.body_wid/2; dest_y=pa.y; dest_rad=max(pa.wid,pa.hei);
		
				
		if(update_stage==3 && new_stage==0){
			setRandomPaDest();
			resetColor();
		}
		update_stage=new_stage;
		switch(update_stage){
			case 0:
				rad=orig_rad-orig_rad/2*sin(frame_portion);
				break;
			case 1:
				x=(dest_x-orig_x)*sin((frame_portion-PI/2))+orig_x;
				y=(dest_y-orig_y)*sin((frame_portion-PI/2))+orig_y;
				break;
			case 2:
				rad=orig_rad/2+(dest_rad-orig_rad)*sin(frame_portion-PI);
				break;
			case 3:
				x=dest_x; y=dest_y; rad=dest_rad*random(.8f,2.5f);
				resetColor();
				break;
		}
	}
	public void setDest(float x_,float y_,float rad_){
		
		dest_x=x_; dest_y=y_; dest_rad=rad_;
		orig_x=x; orig_y=y; orig_rad=rad;

		finished=true;
	}
	public boolean finisheUpdate(){
		return finished;
	}
	public void setRandomPaDest(){
		int iani=(int)random(mpas_to_play);
		PAnimal pa=pas.get(iani);
		setDest(pa.x+pa.body_wid/2,pa.y,max(pa.wid,pa.hei));
		dest_iani=iani;

	}
	public void setRandomPaSource(){
		int iani=(int)random(mpas_to_play);
		PAnimal pa=pas.get(iani);
		orig_x=x=random(width/3);//pa.x+pa.body_wid/2;
		if(random(2)<1) orig_x=0-orig_x;
		else orig_x=width+orig_x;

		orig_y=y=random(height);//pa.y;
		// orig_rad=max(pa.wid,pa.hei);
		// dest_iani=iani;

	}
	public void resetColor(){
		switch(color_index){
			case 0:
				light_color=color(200+random(50),50+random(50),60+random(50),60);
				break;
			case 1:
				light_color=color(200+random(50),200+random(50),random(50),60);
				break;
			case 2:
				light_color=color(random(50),200+random(50),random(50),60);
				break;
				
		}
	}
}


class SwimWater{
	

	float x,y,wid,hei;
	int mcurve;
	float phi;

	SwimWater(float x_,float y_,float wid_, float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		mcurve=(int)random(8,15);

		phi=random(TWO_PI);
	}

	public void draw(PGraphics pg,boolean draw_fill){
		float draw_portion=abs(sin((float)frameCount/50+phi));
		pg.pushStyle();
		if(draw_fill){
			pg.fill(255,120);
			pg.noStroke();
		}else{
			pg.fill(255);
			pg.stroke(0);
		}

		pg.pushMatrix();
		pg.translate(x,y);
		float ang=PI/10;//q(sin(draw_portion))*PI/4+PI/6;
		pg.translate(wid/2,0);
		pg.rotate(ang);
		pg.translate(-wid/2,0);
		
			pg.beginShape();
			pg.vertex(0,0);

			float cur_wid=wid+wid*.2f*abs(sin(draw_portion));
			for(int i=1;i<mcurve;++i){
				// pg.bezierVertex((i-1)*cur_wid/(float)mcurve,hei*(1+random(-.8,.8)),
				// 			 i*cur_wid/(float)mcurve,hei*(1+random(-.8,.8)),
				// 			 i*cur_wid/(float)mcurve,random(-.6,.6));
				pg.vertex(i*cur_wid/(float)mcurve,random(-.6f,.6f));
			}

			// PVector border1=new PVector(-width+x,0);
			// PVector border2=new PVector(-width+x,cur_wid*sin(ang));
			// border1.rotate(-ang);
			// border2.rotate(-ang);
			
			
			// pg.vertex(border2.x,border2.y);
			// pg.vertex(border1.x,border1.y);
			for(int i=1;i<mcurve;++i){
				PVector border=new PVector(-width/4*(1+draw_portion)*abs(sin((float)i/4)*random(.4f,1))+x,(mcurve-i)*cur_wid/(float)mcurve);
				border.rotate(-ang);
				// pg.bezierVertex((i-1)*cur_wid/(float)mcurve,hei*(1+random(-.4,.4)),
				// 			 i*cur_wid/(float)mcurve,hei*(1+random(-.4,.4)),
				pg.vertex(border.x,border.y);
			}
			pg.endShape(CLOSE);

			
		pg.popMatrix();
		//for(int i=0;i<5;++i) drawTurb(x-random(width-x),random(-cur_wid,cur_wid),pg);
		pg.popStyle();

	}


	public void drawTurb(float tx,float ty,PGraphics pg){
		pg.pushStyle();
		pg.noFill();
		pg.stroke(255);

		int mturb=(int)random(5,20);
		float turbw=random(.1f,.2f)*wid;
		pg.pushMatrix();
		pg.translate(tx,ty);
		pg.beginShape();
			pg.vertex(0,0);
			for(int i=0;i<mturb;++i)
				pg.bezierVertex((i+1)*turbw*random(0.5f,1.5f),turbw*random(0.5f,1.5f),
								(i-1)*turbw*random(0.5f,1.5f),turbw*random(0.5f,1.5f),
								i*turbw,0);

		pg.endShape();
		pg.popMatrix();
		pg.popStyle();
	}

}

class Tunnel{
	
	float x,y,wid,hei;

	Tunnel(float x_,float y_,float wid_,float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;
	}

	public void draw(PGraphics pg, boolean draw_fill){

		pg.pushStyle();
		if(draw_fill){
			pg.noStroke();
		}else{
			pg.noFill();
			pg.stroke(0);
		}
		pg.pushMatrix();
		pg.translate(x,y);

			





		pg.popMatrix();
		pg.popStyle();

	}


}


class Volcano{
	float x,y,wid,hei;
	int fc;
	float dest_rad;
	float vel;
	float phi;

	ArrayList<PVector> top_vertex;
	ArrayList<PVector> ash_vertex;
	ArrayList<VDrop> ash_drops;

	FloatList firework_vertex;
	
	Volcano(float x_,float y_,float wid_,float hei_,float vel_,float phi_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		vel=vel_; phi=phi_;

		fc=color(random(50,100)+150,random(20,40)+120,80);

		int mvert=(int)random(8,28);
		top_vertex=new ArrayList<PVector>();
		for(int i=0;i<mvert;++i)
			top_vertex.add(new PVector(wid/8*5-wid/4/(float)mvert*i,random(-.3f,.3f)*hei));
		
		dest_rad=y;//random(8,20)*hei;	
		ash_vertex=new ArrayList<PVector>();
		for(int i=0;i<mvert;++i)
			ash_vertex.add(new PVector(PI/2/(float)mvert*random(.2f,.6f),random(-.5f,1.5f)*hei));
			// ash_vertex.add(new PVector(wid/8*5-wid/4/(float)mvert*i,random(-.5,1.5)*hei));
	
		// firework_vertex=new FloatList();
		// float tmp_ang=0;
		// for(int i=0;i<mvert;++i){
		// 	float ang=random(TWO_PI/(float)mvert);
		// 	ang=constrain(ang,tmp_ang,TWO_PI-tmp_ang);
		// 	firework_vertex.append(ang+tmp_ang);
		// 	tmp_ang+=ang;
		// }

		ash_drops=new ArrayList<VDrop>();
		for(int i=0;i<mvert*5;++i)
			ash_drops.add(new VDrop(random(wid/8*3,wid/8*5),random(-.3f,.3f)*hei,dest_rad,i>mvert*5/2));
	}


	public void draw(PGraphics pg,boolean draw_fill,boolean draw_ash,boolean draw_fire){

		float draw_portion=abs(sin((float)frameCount/vel));

		pg.pushStyle();
		if(draw_fill){
			pg.noStroke(); pg.fill(fc);
		}else{
			pg.stroke(0); pg.noFill();
		}

		pg.pushMatrix();
		pg.translate(x-wid/2,y);

			if(draw_ash)	drawAsh(pg,draw_fill);
			if(draw_fire)	drawFireworks(pg,draw_fill,draw_portion);
			
			
			pg.beginShape();
				if(draw_fill){
					pg.vertex(0,hei);
					pg.bezierVertex(wid/3*draw_portion,hei+hei/8*draw_portion,wid/3*2*draw_portion,hei+hei/8*draw_portion,
								wid,hei);
				}else pg.vertex(wid,hei);
				pg.bezierVertex(wid/8*7,hei/3*2+hei/2*draw_portion,wid/8*6,hei/3+hei/2*draw_portion,
								wid/8*5,-hei/12*draw_portion);
				
				for(PVector v:top_vertex) pg.vertex(v.x,v.y+v.y/2*draw_portion);

				pg.bezierVertex(wid/8*3,hei/3+hei/4*draw_portion,wid/8,hei/3*2+hei/2*draw_portion,
								0,hei+hei/12*draw_portion);
			pg.endShape();

			
			if(draw_fill){
				// pg.stroke(fc);
				pg.stroke(30,80);
				pg.noFill();
				pg.translate(wid*sin(phi),hei);
				int mvert=8;//(int)random(6,16);
				float last_x=0,last_y=0;
				pg.beginShape();
					pg.vertex(0,0);
					for(int x=0;x<mvert;++x){
						// float tmp_x=x*wid/8*cos(phi*draw_portion+x)+wid/4*draw_portion;
						// float tmp_y=(hei/12*x)*(1+draw_portion+2*cos(phi));
						float tmp_x=x*wid/8*cos(phi+x)+wid/4;
						float tmp_y=(hei/12*x)*(1+1+2*cos(phi));
						if(random(3)<1) 
							pg.vertex(tmp_x,tmp_y);
						else pg.bezierVertex(tmp_x+wid/8,tmp_y-hei/2*sin(x),last_x-wid/8,last_y-hei/2*sin(x),
											 tmp_x,tmp_y);

						last_x=tmp_x; last_y=tmp_y;
					}	
				pg.endShape();
			}
				

		pg.popMatrix();

		pg.popStyle();

	}
	public void drawAsh(PGraphics pg,boolean draw_fill){
		
		float jump_portion=((float)frameCount/(vel)+phi)%TWO_PI;
		int jump_stage=(int)(jump_portion/(PI/2));

		int jump_y_cycle=floor(((float)frameCount/(vel)+phi)/TWO_PI);
		float cycle_dest_y=dest_rad;//(.3+1.2*abs(sin(jump_y_cycle)))*dest_rad;

		float draw_portion=0;
		if(jump_stage==2||jump_stage==3) draw_portion=abs(sin(jump_portion));
		
		pg.pushStyle();
		if(draw_fill){
			pg.noStroke(); pg.fill(red(fc)*2.5f,green(fc)/2,0,180);
		}else{
			pg.stroke(0,170); pg.noFill();
		}

			pg.pushMatrix();
				pg.translate(0,hei/2);
				float mash=ash_vertex.size();
				float rad=dest_rad*draw_portion;

				PVector dest=null;
				for(int i=0;i<mash;++i){
					// float ang=-PI/4+PI/2/mash*i+PI;
					// PVector v=ash_vertex.get(i);
					
					// int mnoise=abs((int)(v.x*100));//(int)random(4,12);
					// pg.beginShape();

					// 	for(int x=0;x<mnoise;++x){
					// 		float trad=random(v.y,rad);
					// 		float tang=random(-v.x,v.x)+ang;
					// 		if(x%3==0) pg.vertex(wid/2+trad*sin(tang),trad*cos(tang));
					// 		else pg.bezierVertex(wid/2+trad*sin(tang)*draw_portion,trad*cos(tang),
					// 						wid/2+trad*sin(tang),trad*cos(tang)*draw_portion,
					// 						wid/2+trad*sin(tang),trad*cos(tang));
					// 	}

					// pg.endShape();

					VDrop drop=ash_drops.get(i);

					int mnoise=(int)random(3,8);
					pg.beginShape();
						float last_tx=0,last_ty=0;
						for(int x=0;x<mnoise;++x){

							float tx,ty;
							if(jump_stage==2){
								tx=random(-wid/12,wid/12)+drop.x;
								ty=random(-drop.y-cycle_dest_y/3,hei/2);
								if(ty<-cycle_dest_y){
									ty=ty+random(-.3f,.3f)*cycle_dest_y;
									tx=random(-wid/2,wid/2)+drop.x;
								}
								if(x%3==0) pg.vertex(tx,ty);
								else pg.bezierVertex((last_tx+tx)/2*draw_portion,(last_ty+ty)/2,
													(last_tx+tx)/2,(last_ty+ty)/2*draw_portion,
													tx,ty);
							}else{
								tx=random(-wid/25,wid/25)+drop.x;
								ty=random(-hei,0);
								pg.vertex(tx,ty);
							}
							
							last_tx=tx;
							last_ty=ty;
						}

					pg.endShape();
					// pg.arc(drop.x,-drop.y,10,10,0,PI);

					drop.update(jump_stage,jump_portion,cycle_dest_y);
					if(drop.x>wid||drop.x<-wid) drop.reset();
				}

			pg.popMatrix();
		

		pg.popStyle();

	}
	public void drawFireworks(PGraphics pg,boolean draw_fill,float draw_portion){

		pg.pushStyle();
		if(draw_fill){
			pg.noStroke(); pg.fill(red(fc)*2.5f,green(fc)/2,0);
		}else{
			pg.stroke(0); pg.noFill();
		}

		pg.pushMatrix();
			pg.translate(wid/2,-dest_rad*1.5f);



			// int mfire=firework_vertex.size();
			// float ang_wid=PI/(float)mfire*draw_portion;
			// for(int i=0;i<mfire;++i){
			// 	float ang=firework_vertex.get(i);
				
			// 	int mnoise=(int)random(2,7);
			// 	pg.beginShape();

			// 		for(int x=0;x<mnoise;++x){
			// 			float tang=random(-ang_wid,ang_wid)+ang;
			// 			float trad=random(dest_rad/5*(1-draw_portion),dest_rad/2);
			// 			if(x%3==0) pg.vertex(trad*sin(tang),trad*cos(tang));
			// 			else pg.bezierVertex(trad*sin(tang)*draw_portion,trad*cos(tang),
			// 							trad*sin(tang),trad*cos(tang)*draw_portion,
			// 							trad*sin(tang),trad*cos(tang));
			// 		}

			// 	pg.endShape();

			// }

		pg.popMatrix();
		pg.popStyle();
	}

}

class VDrop{
	
	float origin_x,origin_y;
	float x,y;
	float dest_y;
	float vel;
	boolean onleft;

	VDrop(float x_,float y_,float dest_,boolean left_){
		x=x_; y=y_;
		origin_x=x_; origin_y=y_;
		dest_y=dest_;
		vel=1;//random(.02,.1)*(dest_y-y);
		onleft=left_;
	}
	public void update(int jump_stage,float jump_portion,float cycle_dest){
		switch(jump_stage){
			case 2:
				y=origin_y+(cycle_dest-origin_y)*abs(sin(jump_portion));
				break;
		}
		
	}
	public void reset(){
		x=origin_x; y=origin_y;
	}


}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Peepee" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
