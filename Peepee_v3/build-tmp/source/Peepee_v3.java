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

public class Peepee_v3 extends PApplet {


final int M_MODE=8;

int mpas=10;
ArrayList<PAnimal> pas;

float mid_pos;
float dest_pos;


PImage texture_img;
boolean save_frame=false;


DistortGraphic fill_canvas,stroke_canvas;
int back_color=color(172,199,204);

int play_mode=0;

int mpas_to_play=0;
float angle_for_mode=0;


public void setup(){
	
	size(800,800,P3D);
	
 	//mtext_pg=createGraphics(width,height);
	
	pas=new ArrayList<PAnimal>();
	float tmp_pos=0;
	for(int i=0;i<mpas;++i){
		float tmp_h=random(0.6f,1.2f)*height/mpas;
		pas.add(new PAnimal(random(50,width-50),tmp_pos+tmp_h,width/5*random(.6f,1.4f),tmp_h));
		tmp_pos+=tmp_h;
		if(tmp_h>height) return;
	}
	mpas=pas.size();

	mid_pos=0;

	fill_canvas=new DistortGraphic(25);
	fill_canvas.transform_mag=2;
	fill_canvas.transform_vel=28;
	stroke_canvas=new DistortGraphic(1);

	initCloud();


}

public void draw(){
	
	background(back_color);	
	

	fill_canvas.beginDraw();
	stroke_canvas.beginDraw();
	
	fill_canvas.background(color(255,0));
	stroke_canvas.background(color(255,0));

	// background(255);
	
	drawSkyBackground(fill_canvas.pg,true);
	drawSkyBackground(stroke_canvas.pg,false);
	updateSky();

	for(int i=0;i<mpas_to_play;++i){
		PAnimal pa=pas.get(i);
		pa.draw(stroke_canvas.pg,false);
		pa.draw(fill_canvas.pg,true);
		// image(pa.mtext.pg,pa.x,pa.y);
	}

	
	stroke_canvas.endDraw();
	fill_canvas.endDraw();
	// if(play_mode>2) blendMode(ADD);
   	fill_canvas.draw();
   	//stroke_canvas.draw();
   	// blendMode(NORMAL);
   	image(stroke_canvas.pg,-width/20,0);


	
	

	frame.setTitle(String.valueOf(frameRate));
	if(save_frame) saveFrame("pee-####.png");
}

public void keyPressed(){

	switch(key){
		case 'a':
			for(PAnimal pa:pas){
			 	pa.x=random(20,width-20);
			 	pa.land_vel=(int)random(2,10);
			 }
			break;
		case 's':
			save_frame=!save_frame;
			break;
		case 'd':
			
			fill_canvas.reset();

			play_mode=(play_mode+1)%M_MODE;
			float tmpx=0;
			float tmpy=0;
			// moon_edge_y=height;
			for(PAnimal pa:pas){
			 	pa.transport_mode=play_mode;
			 	
			 	pa.land_vel=(int)random(2,10);
			 		
			}
			// if(play_mode==7){
			// 	for(SpotLight sp:sps) sp.setRandomPaSource();
			// }
			// moon_edge_y*=.8;
			// mid_pos=0;
			// for(PAnimal pa:pas) mid_pos+=(pa.x+pa.wid);
			// mid_pos/=pas.size();
			// mid_pos*=.8;
			// angle_for_mode=-PI/4;
			break;
		case 'q':
			if(mpas_to_play<mpas){
				mpas_to_play++;
				// pas.get(mpas_to_play-1).x=0;
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
class Helicopt{
	
	float wid,hei;
	int mwing;
	float ang_pos;
	float vel;
	float phi=random(TWO_PI);
	
	float hei_strength;
	float hei_base;
	float delta_hei;

	Helicopt(float wid_,float hei_){
		wid=wid_; hei=hei_;
		mwing=(int)random(3,5);
		ang_pos=random(TWO_PI);
		vel=TWO_PI/random(5,25);

		hei_strength=random(1,5)*hei;
		hei_base=random(.5f,2)*hei;
		
	
	}

	public void draw(PGraphics pg,boolean draw_fill,float x,float y){

		float draw_portion=(float)frameCount/10+phi;
		
		delta_hei=hei_strength*sin(draw_portion);
		float tail_hei=hei_base+hei_strength;	
		
		pg.pushStyle();
		if(!draw_fill){
			pg.noFill();
			pg.stroke(20,35,40);
		}else{
			pg.fill(184*random(.8f,1.2f),180);
			pg.noStroke();
		}
		pg.pushMatrix();
		pg.translate(x,y);
		if(!draw_fill){
			pg.beginShape();
				pg.vertex(0,0);
				pg.bezierVertex(wid/25*sin(draw_portion),-tail_hei/4,wid/32*sin(draw_portion),-tail_hei/3*2.5f,
								0,-tail_hei);
			pg.endShape();
		
			pg.translate(0,-tail_hei);
			float eang=TWO_PI/(float)mwing;
			for(int i=0;i<mwing;++i){
				drawWing(pg,eang*i+ang_pos);
			}
		}else{

			pg.translate(0,-tail_hei);
			
			pg.beginShape();
			float eang=TWO_PI/(float)mwing/2;
			for(int i=0;i<mwing*2;++i){
				float ang_=i*eang+ang_pos;
				float rad_=random(-.1f,1.1f);
				PVector pos=new PVector(wid*cos(ang_),hei*sin(ang_)*abs((float)i/10));
				pg.vertex(pos.x,pos.y);
			}
			pg.endShape(CLOSE);
		}
		
		pg.popMatrix();

		pg.popStyle();
		
		ang_pos+=vel;

	}
	public void drawWing(PGraphics pg,float ang){
		// PVector pos=new PVector(rad*cos(ang),rad*sin(ang));
		pg.beginShape();
			pg.vertex(0,0);
			int mvert=(int)random(3,8);
			for(int i=0;i<mvert;++i){
				float ang_=ang+random(-.05f,.05f)*TWO_PI/(float)mwing;
				float rad_=random(-.1f,1.1f);
				PVector pos=new PVector(wid*rad_*cos(ang_),hei*rad_*sin(ang_)*abs((float)i/10));
				pg.vertex(pos.x,pos.y);
			}
		pg.endShape();
	}

}
final float LAND_DISTORT=.6f;
final int MAX_GENERATION=5;

class PAnimal{
	
	float x,y,wid,hei;
	float head_wid,head_hei;
	float body_wid,body_hei;
	
	float leg_wid,leg_hei;
	int mleg;
	FloatList leg_span;
	IntList leg_direction;

	float tail_wid,tail_hei;
	int fcolor;
	
	float phi,run_phi;
	float elastic_strength;
	int alien_stage=0;

	FloatList land_poses;
	int land_length;
	float land_vel;
	int land_index;


	int transport_mode=0;
	float run_vel=150;
	float alien_vel=random(220,500);

	
	float s_body_hei_incre=0;

	PVector first_foot_base;
	PVector last_foot_base;

	float stop_draw_portion;
	float stop_run_portion;

	int start_frame;

	Helicopt head_heli;
	Helicopt tail_heli;

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
		leg_direction=new IntList();
		
		for(int i=0;i<mleg;++i){
			leg_span.append(random(0.05f,0.5f));
			leg_direction.append((random(2)<1?1:0));
		}


		fcolor=color(random(100,255),random(20,80)+100,random(20,85));

		phi=random(HALF_PI);
		run_phi=random(HALF_PI);
				


		land_poses=new FloatList();
		land_length=(int)(random(.5f,1.2f)*width);
		for(int i=0;i<land_length;++i){
			if(random(20)<1) land_poses.append(random(-LAND_DISTORT,0)*30);
			else land_poses.append(random(-LAND_DISTORT,LAND_DISTORT));
		} 
		land_vel=(int)random(3,10);
		land_index=0;

		elastic_strength=(float)land_vel/10*random(1,3);
		start_frame=frameCount;
		// child_animal=new PAnimal(this);
		
		head_heli=new Helicopt(wid/8,wid/8*random(.2f,.5f));
		tail_heli=new Helicopt(wid/8,wid/8*random(.2f,.5f));

	}	
	PAnimal(PAnimal copy_pa){

		float shrink=random(.7f,.96f);
		x=copy_pa.x; y=copy_pa.y; wid=copy_pa.wid*shrink; hei=copy_pa.hei*shrink;
		
		head_wid=copy_pa.head_wid*shrink;
		body_wid=copy_pa.body_wid*shrink;
		
		body_hei=copy_pa.body_hei*shrink;
		head_hei=copy_pa.head_hei*shrink;
		
		leg_hei=hei-body_hei;

		mleg=copy_pa.mleg;
		leg_wid=copy_pa.leg_wid*shrink;
		leg_span=new FloatList();
		//leg_span.append(0);
		for(int i=0;i<mleg;++i){
			leg_span.append(copy_pa.leg_span.get(i));
		}

		int pcolor=copy_pa.fcolor;
		fcolor=color(red(pcolor)/shrink,green(pcolor)/shrink,blue(pcolor));

		phi=random(HALF_PI);
		run_phi=copy_pa.stop_run_portion%TWO_PI;


		// land_poses=new FloatList();
		// land_length=(int)(random(.5,1.2)*width);
		// for(int i=0;i<land_length;++i){
		// 	if(random(20)<1) land_poses.append(random(-LAND_DISTORT,0)*30);
		// 	else land_poses.append(random(-LAND_DISTORT,LAND_DISTORT));
		// } 
		land_vel=(int)random(3,10);
		land_index=0;

		// elastic_strength=(float)land_vel/10*random(1,3);

		
		start_frame=frameCount;
	}
	public void draw(PGraphics pg,boolean draw_fill){
		
		
		
		
		float draw_portion=1.5f*abs(sin((float)frameCount/(120/land_vel)));

		float run_portion=(float)(frameCount-start_frame)/(run_vel/land_vel)+run_phi;
					

		float frame_portion=(float)(frameCount-start_frame)/(alien_vel/land_vel)+phi;
		frame_portion%=(TWO_PI*2);
		int new_alien_stage=(int)((frame_portion)/(PI/2));
		

		float cur_body_wid=body_wid;
		float cur_head_pos=head_heli.delta_hei;
		float cur_tail_pos=tail_heli.delta_hei;


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

		if(transport_mode==0){
			pg.translate(x+land_vel/8*wid*sin(frame_portion),y+land_vel/50*hei*abs(sin(frame_portion)));
			
		}

		pg.beginShape();
		pg.vertex(0,cur_tail_pos);
		pg.bezierVertex(cur_body_wid/3,-body_hei*.3f*draw_portion+s_body_hei_incre+lerp(cur_tail_pos,cur_head_pos,.33f),
						 cur_body_wid/3*2,-body_hei*.3f*draw_portion+s_body_hei_incre+lerp(cur_tail_pos,cur_head_pos,.66f),
						 cur_body_wid,cur_head_pos);

		PVector ear_base1=new PVector(head_hei,0);
		ear_base1.rotate((-PI/3)*draw_portion-PI/6-PI/4);
		PVector ear_base2=new PVector(head_hei,0);
		ear_base2.rotate(-PI/3*draw_portion-PI/4);


		pg.bezierVertex(cur_body_wid+ear_base1.x,cur_head_pos+ear_base1.y,
					  cur_body_wid+ear_base2.x,cur_head_pos+ear_base2.y,
					  cur_body_wid,cur_head_pos);

		pg.bezierVertex(cur_body_wid+head_wid/2,cur_head_pos-body_hei*.1f*draw_portion,
					 cur_body_wid+head_wid,cur_head_pos+head_hei+body_hei*.4f*draw_portion,
					 cur_body_wid,cur_head_pos+head_hei);
			
		
		pg.vertex(cur_body_wid*(1-(float)(0+leg_span.get(0))/mleg),cur_head_pos+body_hei);

		for(int i=0;i<mleg;++i){
			float cur_tmp_pos=lerp(cur_head_pos,cur_tail_pos,((float)(i+leg_span.get(i))/mleg));
			if(i>0) pg.vertex(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei+cur_tmp_pos);
			if(transport_mode==0){
				drawRunLeg(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei+cur_tmp_pos,leg_wid,leg_hei,i,pg,run_portion);
			} 					
		}
		
		pg.bezierVertex(-cur_body_wid*.1f*draw_portion,cur_tail_pos+body_hei,
					 -cur_body_wid*.1f*draw_portion,cur_tail_pos,
					 0,cur_tail_pos);


		pg.endShape();
		
		


		if(!draw_fill){
			pg.stroke(red(fcolor)/1.1f,green(fcolor)/1.1f,blue(fcolor)/1.3f);
			pg.beginShape();
			for(int i=0;i<80;++i){
					// pg.strokeWeight(random(2));
					float tmp_x=random(cur_body_wid);
					float cur_tmp_pos=lerp(cur_head_pos,cur_tail_pos,1-tmp_x/cur_body_wid);
					pg.vertex(tmp_x,
							   cur_tmp_pos+random(-body_hei*.1f,body_hei/2));
			
			}
			pg.endShape();
		}

		head_heli.draw(pg,draw_fill,cur_body_wid,cur_head_pos);
		tail_heli.draw(pg,draw_fill,0,cur_tail_pos);


		pg.popMatrix();
		

		pg.popStyle();

		
	
		update();
	}

	public void update(){
		switch(transport_mode){
			case 0:
				// if(random(500)<1){
				//  land_vel+=(int)random(-2,2);
				// }
				break;

		}
		
	}
	public void drawRunLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg,float frame_portion){


		
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		
		float kang=-PI/4*(sin(frame_portion));
		if(leg_direction.get(leg_index)==1) kang=-PI/4*(sin(frame_portion+PI/2*sin(leg_index)));
		float fang=0;//+PI/1.8;
		
		switch(stage){
			case 0:
				fang=kang+PI/3;//*(sin(frame_portion));
				break;
			case 1:
				fang=kang+PI/3*((sin(frame_portion)));
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
				fang=kang+PI/3*(1-abs(sin(frame_portion)));
				break;
				
		}
		drawLegs(kang,fang,lx,ly,lw,lh,leg_index,pg);
		
	}	
	public void drawStandLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg,float frame_portion){

		
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		
		float kang=0;//-PI/2.5*(sin(frame_portion))*((leg_index%2==0)?1:-1);
		float fang=kang;
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

		// switch(transport_mode){
		// 	case 1:
		// 		if(leg_index==0) first_foot_base=new PVector(lx-lw+foot_base.x,ly+foot_base.y);
		// 		else if(leg_index==mleg-1) last_foot_base=new PVector(lx+lw+foot_base.x,ly+foot_base.y);
		// 		break;
		// 	case 2:
		// 		if(leg_index==0) first_foot_base=new PVector(lx-lw+foot_base.x,ly+lh);
		// 		else if(leg_index==mleg-1) last_foot_base=new PVector(lx+lw+foot_base.x,ly+lh);
		// 		break;
		// 	case 7:
		// 		if(leg_index==0) first_foot_base=new PVector(lx-lw+foot_base.x,lx-lw+lh*sin(PI/6));
		// 		else if(leg_index==mleg-1) last_foot_base=new PVector(lx+lw+foot_base.x,lx+lw-lh*sin(PI/6),lx+lw+lh*sin(PI/6));
		// 		break;
		// }
	}

}



ArrayList<Cloud> acloud;
ArrayList<Eye> aeye;

public void initCloud(){
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
						 ewid,ewid*random(.2f,.4f),random(10,30),random(TWO_PI),(int)random(3,9)));
	}
}
public void drawSkyBackground(PGraphics pg,boolean draw_fill){
	for(Cloud c:acloud) c.draw(pg,draw_fill);
	if(draw_fill)
		for(Eye e:aeye) e.draw(pg,draw_fill);
}
public void updateSky(){
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
			arc_pos.append(random(-.5f,.5f)*hei);
			
			if(tmp_pos==wid) break;

			tmp_pos+=random(.1f,2.5f)*wid/marc;
			if(tmp_pos>wid) tmp_pos=wid;
		}
		marc=arc_pos.size();

		delta_x=wid*random(.1f,.4f);
		vel_y=random(2,6);

		// int meye=(int)random(0,4);
		// float eye_vel=random(10,30);
		// float eye_phi=random(TWO_PI);
		// int mhair=(int)random(3,9);
		// aeye=new Eye[meye];
		// float ewid=wid/(float)(meye+2);
		// for(int i=0;i<meye;++i) aeye[i]=new Eye((i+1)*ewid,hei/2,ewid*.4,min(ewid*.2,hei*.2),eye_vel,eye_phi,mhair);
	}
	public void draw(PGraphics pg,boolean draw_fill){
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
					else pg.bezierVertex(lerp(cur_tur.x,last_tur.x,-.3f),cur_tur.y,
										lerp(cur_tur.x,last_tur.x,1.3f),last_tur.y,
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
			pg.translate(delta_x*sin(draw_portion)*random(.2f,1.2f),0);
			pg.beginShape();
			for(int i=0;i<mtur_;++i){
				PVector cur_tur=new PVector(wid/(float)mtur_*i,random(-.5f,.5f)*hei);
				if(i%3==0) pg.vertex(cur_tur.x,cur_tur.y);
				else pg.bezierVertex(lerp(cur_tur.x,last_tur_.x,-.3f),cur_tur.y,
									lerp(cur_tur.x,last_tur_.x,1.3f),last_tur_.y,
									cur_tur.x,cur_tur.y);
				last_tur_=cur_tur.get();
			}
			pg.endShape();
		}
		pg.popMatrix();

		pg.popStyle();
	}
	public void update(){
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
	public void draw(PGraphics pg,boolean draw_fill){
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
			float eye_top=bezierPoint(0,-hei,-hei,0,.5f);//bezierPoint(0,hei*sin(draw_portion),hei*sin(draw_portion),0,.5);
			float eye_bottom=bezierPoint(0,hei,hei,0,.5f);
			float eye_rad=(eye_bottom-eye_top)*.8f;
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
	public void update(){
		if(random(50)<1) y+=vel_y*8;
		else y+=vel_y;
		if(y>height+hei) y=-hei;

	}
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Peepee_v3" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
