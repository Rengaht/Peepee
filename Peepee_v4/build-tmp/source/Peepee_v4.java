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

public class Peepee_v4 extends PApplet {


final int M_MODE=8;

int mpas=1;
ArrayList<FPAnimal> pas;

float mid_pos;
float dest_pos;


PImage texture_img;
boolean save_frame=false;


DistortGraphic fill_canvas,stroke_canvas;
int back_color=color(205,205,180);

int play_mode=0;

int mpas_to_play=0;
float angle_for_mode=0;


public void setup(){
	
	size(800,800,P3D);
	
 	//mtext_pg=createGraphics(width,height);
	
	initPee();
	

	mid_pos=0;

	fill_canvas=new DistortGraphic(25);
	fill_canvas.transform_mag=2;
	fill_canvas.transform_vel=28;
	stroke_canvas=new DistortGraphic(1);

	


}

public void draw(){
	
	background(back_color);	
	

	fill_canvas.beginDraw();
	stroke_canvas.beginDraw();
	
	fill_canvas.background(color(255,0));
	stroke_canvas.background(color(255,0));

	// background(255);
	
	
	for(int i=0;i<mpas_to_play;++i){
		FPAnimal pa=pas.get(i);
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
	
   	if(frameCount%24==0 && random(3)<1) initPee();


	frame.setTitle(String.valueOf(frameRate));
	if(save_frame) saveFrame("pee-####.png");
}
public void initPee(){
	if(pas==null) pas=new ArrayList<FPAnimal>();
	else pas.clear();

	float tmp_pos=0;
	for(int i=0;i<mpas;++i){
		float tmp_h=random(0.6f,1.2f)*height/5;
		pas.add(new FPAnimal(random(50,width-50),tmp_pos+tmp_h,tmp_h*random(.3f,.6f),tmp_h));
		tmp_pos+=tmp_h/5;
		if(tmp_h>height) return;
	}
	mpas=pas.size();
	mpas_to_play=mpas;

}
public void keyPressed(){

	switch(key){
		case 'a':
			for(FPAnimal pa:pas){
			 	pa.x=random(20,width-20);
			 	// pa.land_vel=(int)random(2,10);
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
			for(FPAnimal pa:pas){
			 	// pa.transport_mode=play_mode;
			 	
			 	// pa.land_vel=(int)random(2,10);
			 		
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
			initPee();
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

class FPAnimal extends PPart{
	
	int fcolor;	
	PRoad road;
	
	FPAnimal(float x_,float y_,float wid_,float hei_){
		super(x_,y_,wid_,hei_);
		// fcolor=color(random(150,255),random(20,80)+150,random(120,185));
		fcolor=color(205+random(-10,10),186,150);

		road=new PRoad(-wid/1.2f,hei/3,wid*2,hei*2);
	}

	public void draw(PGraphics pg,boolean draw_fill){
		
		float draw_portion=getDrawPortion();
		if(random(500)<1) draw_portion*=(1+.3f*draw_portion);

		pg.pushStyle();
		
		if(draw_fill){
		 	pg.noStroke();
		 	pg.fill(fcolor);
		}else{
		 	// pg.fill(fcolor);
		 	pg.noFill();
		 	pg.stroke(80); 
		}

		pg.pushMatrix();
		pg.translate(x,y);

		// pface.draw(pg,draw_fill);
		road.draw(pg,draw_fill);

		drawBody(pg,draw_fill,-wid/4,0,wid,hei*.9f,draw_portion);
		drawHead(pg,draw_fill,wid*.05f,0,wid*.35f,hei*(.35f+.02f*draw_portion),draw_portion);

		
		pg.popMatrix();

		pg.popStyle();

	}
	public void drawHead(PGraphics pg,boolean draw_fill,float hx,float hy,float hw,float hh,float draw_portion){
		
		// if(!draw_fill) pg.fill(fcolor);

		pg.pushMatrix();
		pg.translate(hx+hw/2,hy);

		pg.beginShape();
			PVector face_ctrl=new PVector(0,hh/3*(1+.2f*abs(draw_portion)));
			face_ctrl.rotate(PI/24);		

			pg.vertex(-hw/2.5f,0);
			// pg.bezierVertex(-hw/2+face_ctrl.x,face_ctrl.y,-face_ctrl.x,hh,
			// 				0,hh);
			// pg.bezierVertex(-face_ctrl.x,hh,hw/2-face_ctrl.x,hh,
			// 				hw/2,0);
			pg.bezierVertex(-hw/2+face_ctrl.x,face_ctrl.y,-hw/3,hh/5*3,
							-hw/3,hh/5*3);
			pg.bezierVertex(-hw/3*random(.95f,1.08f),hh/6*5,-hw/3,hh/8*7,
							0,hh);
			pg.bezierVertex(hw/3,hh,hw/3,hh/4*3,
							hw/3,hh/7*4);

			pg.bezierVertex(hw/3*random(.95f,1.08f),hh/7*4,hw/2-face_ctrl.x,face_ctrl.y,
							hw/2.5f,0);

			PVector ear_ctrl=new PVector(0,-hh/4);
			ear_ctrl.rotate(PI/15-PI/22*draw_portion);

			pg.bezierVertex(hw/2-ear_ctrl.x,ear_ctrl.y,hw/3-ear_ctrl.x,ear_ctrl.y,
							hw/3,0);
			pg.bezierVertex(hw/4,-hh/5,-hw/4,-hh/8,
							-hw/3,0);
			pg.bezierVertex(-hw/3-ear_ctrl.x*1.2f,ear_ctrl.y,-hw/2-ear_ctrl.x*.9f,ear_ctrl.y,
							-hw/2,0);
		pg.endShape();

		pg.popMatrix();

		
	}
	public void drawBody(PGraphics pg,boolean draw_fill,float bx,float by,float bw,float bh,float draw_portion){
		pg.pushMatrix();
		pg.translate(bx+bw/2,by);

		pg.beginShape();
			PVector body_ctrl=new PVector(0,bh);
			body_ctrl.rotate(PI/24);		
			float fw=bw/10;
			float lf_h=bh*(1+.3f*draw_portion);
			float rf_h=bh*(1-.2f*draw_portion);

			float bf_pos=bw/2.5f*(1+.1f*draw_portion);
			float ff_pos=bw/4*(1+.3f*draw_portion);
			float w_pos=bw/3;
			float h_pos=bw/1.7f*(1+.2f*draw_portion);

			if(!draw_fill) pg.vertex(-bw/5,0);
			else pg.vertex(0,0);

			pg.bezierVertex(-bw/5,0,-ff_pos,0,
							-ff_pos+fw/2,lf_h);
			pg.vertex(-ff_pos-fw/2,lf_h);
			pg.bezierVertex(-ff_pos-fw,bh/6,-w_pos*1.3f,-bh/6,
							-w_pos,-bh/6);

			pg.bezierVertex(-w_pos,-bh/6,-bf_pos*1.2f,0,
							-bf_pos,lf_h*.8f);

			pg.vertex(-bf_pos-fw,lf_h*.8f);
			pg.bezierVertex(-bf_pos-fw*2,0,-h_pos,-bh/2,
							0,-bh/2);
			PVector tail_ctrl=new PVector(0,-bh/4);
			tail_ctrl.rotate(PI/25*abs(draw_portion));
			pg.bezierVertex(tail_ctrl.x,-bh/2+tail_ctrl.y,tail_ctrl.x*2,-bh/2+tail_ctrl.y,
							tail_ctrl.x,-bh/2+tail_ctrl.x);

			pg.bezierVertex(h_pos*1.2f,-bh/2,bf_pos+fw*2,0,
							bf_pos,rf_h*.8f);

			pg.vertex(bf_pos-fw,rf_h*.8f);
			pg.bezierVertex(bf_pos,0,w_pos,-bh/6,
							w_pos,-bh/6);

			pg.bezierVertex(w_pos+fw,bh/3,ff_pos*1.2f,bh/2,
							ff_pos-fw/2,rf_h);

			pg.vertex(ff_pos-fw*3/2,rf_h);
			if(draw_fill) pg.bezierVertex(ff_pos-fw,0,bw/5,0,
							   			   0,0);
			else pg.bezierVertex(ff_pos-fw,0,bw/5,0,
							   	 bw/5,0);

		pg.endShape();


		if(draw_fill){
			pg.pushStyle();
			pg.stroke(red(fcolor)/1.1f,green(fcolor)/1.1f,blue(fcolor)/1.3f,120);
			pg.noFill();
			pg.beginShape();
			for(int i=0;i<80;++i){
					float tmp_t=random(.3f,1);
					float tmp_y=bezierPoint(bh*.8f,0,-bh/2,-bh/2,tmp_t);
					float tmp_x=bezierPoint(-bf_pos-fw,-bf_pos-fw,-h_pos,0,tmp_t);


					pg.vertex(random(tmp_x,-tmp_x),tmp_y*random(.7f,1));
					pg.vertex(tmp_x*random(.9f,1.05f),tmp_y);
					// pg.vertex(random,tmp_y);			
			}
			pg.endShape();
			pg.popStyle();
		}

		pg.popMatrix();

	}
	public void drawBezier(float x1,float y1,float x2,float y2){

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
		float cur_head_pos=0;
		float cur_tail_pos=0;


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



class PFace{
	
	float x,y,wid,hei;
	float ani_vel,ani_phi;
	int fcolor;	

	PFace(float x_,float y_,float wid_,float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;
		fcolor=color(255,random(200,230),random(180,200));
		
		ani_vel=random(20,40);
		ani_phi=random(TWO_PI);

	}

	public void draw(PGraphics pg, boolean draw_fill){
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

class PPart{

	float x,y,wid,hei;
	float ani_vel,ani_phi;
	
	PPart(float x_,float y_,float wid_,float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;
	
		ani_vel=random(10,20);
		ani_phi=random(TWO_PI);
	}

	public float getDrawPortion(){
		return sin(((float)frameCount/ani_vel+ani_phi));
	}
	public float getDrawAngle(){
		return (float)frameCount/ani_vel+ani_phi;
	}
}

class PRoad extends PPart{
	
	int fcolor;

	PRoad(float x_,float y_,float wid_,float hei_){
		super(x_,y_,wid_,hei_);
		fcolor=color(random(150,180));
		ani_vel=random(80,120);
	}

	public void draw(PGraphics pg,boolean draw_fill){

		float draw_portion=sin(getDrawAngle()%HALF_PI);
		if(random(500)<1) draw_portion*=(1+.3f*draw_portion);

		pg.pushStyle();
		
		if(draw_fill){
		 	pg.noStroke();
		 	pg.fill(fcolor);
		}else{
		 	// pg.fill(fcolor);
		 	pg.noFill();
		 	pg.noStroke(); 
		}
		pg.pushMatrix();
		pg.translate(x+wid/2,y);

		pg.beginShape();
		float sh_p=.5f;
		pg.vertex(-wid/2*sh_p,0);
		pg.vertex(-wid/2,hei);

		pg.vertex(wid/2,hei);
		pg.vertex(wid/2*sh_p,0);
		
		pg.endShape(CLOSE);
		
		if(draw_fill) pg.fill(255);
		else pg.noStroke();

		float sign_pos=hei-hei*abs(draw_portion);
		float sign_w=wid/10;
		pg.beginShape();
			pg.vertex(-sign_w*.3f,0);
			pg.vertex(sign_w*.3f,0);
			pg.vertex(sign_w*lerp(.3f,1,sign_pos/hei),sign_pos);
			pg.vertex(-sign_w*lerp(.3f,1,sign_pos/hei),sign_pos);
		pg.endShape();

		if(sign_pos+sign_w*3<hei){
		pg.beginShape();
			pg.vertex(-sign_w*lerp(.3f,1,sign_pos/hei),sign_pos+sign_w*3);
			pg.vertex(sign_w*lerp(.3f,1,sign_pos/hei),sign_pos+sign_w*3);
			pg.vertex(sign_w,hei);
			pg.vertex(-sign_w,hei);
		pg.endShape();
		}

		pg.popMatrix();
		pg.popStyle();
	}





}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Peepee_v4" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
