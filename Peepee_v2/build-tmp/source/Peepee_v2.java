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

public class Peepee_v2 extends PApplet {


final int M_MODE=8;

int mpas=10;
ArrayList<PAnimal> pas;
ArrayList<PAnimalSlice> paslices;

float mid_pos;
float dest_pos;


PImage texture_img;
boolean save_frame=false;

PGraphics mtext_pg;


DistortGraphic fill_canvas,stroke_canvas;


int play_mode=0;

int mpas_to_play=0;
float angle_for_mode=0;



Robot robot;
Machine machine;
Machine2 machine2;
Machine2 machine3;


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
	paslices=new ArrayList<PAnimalSlice>();
	tmp_pos=0;
	for(int i=0;i<mpas;++i){
		
		if(i%5==0) tmp_pos=0;

		float tmp_h=random(0.6f,1.2f)*height/mpas;
		float tmp_w=width/5*random(.6f,1.4f);
		// paslices.add(new PAnimalSlice(tmp_pos,height/5*(floor(i/5)+1),tmp_w,tmp_h));
		paslices.add(new PAnimalSlice(0,height/5,tmp_w,tmp_h));
		tmp_pos+=tmp_w;

		if(tmp_h>width) return;
	}
	mpas=pas.size();

	mid_pos=0;

	fill_canvas=new DistortGraphic(25);
	fill_canvas.transform_mag=2;
	fill_canvas.transform_vel=28;
	stroke_canvas=new DistortGraphic(1);

	robot=new Robot(width/2,height/1.2f,width/12,width/4);
	// machines=new Machine[20];
	// for(int i=0;i<20;++i)
	machine=new Machine(-width/4,0,width*1.5f,height);
	machine2=new Machine2();
	
}

public void draw(){
	
	background(0);	
	

	fill_canvas.beginDraw();
	stroke_canvas.beginDraw();
	
	fill_canvas.background(color(255,0));
	stroke_canvas.background(color(255,0));
	// drawMeatSpace(fill_canvas.pg,false);
	if(play_mode==0){
		background(255);
		drawMeatSpace(this.g,true);

	}
	// for(int i=0;i<mpas_to_play;++i){
	// 	PAnimal pa=pas.get(i);
	// 	pa.draw(stroke_canvas.pg,false);
	// 	pa.draw(fill_canvas.pg,true);
	// 	// image(pa.mtext.pg,pa.x,pa.y);
	// }
	// robot.draw(stroke_canvas.pg);
	// machine.update();
	machine.draw(fill_canvas.pg,true);
	machine.draw(stroke_canvas.pg,false);

	machine2.draw(stroke_canvas.pg,false);
	machine2.draw(fill_canvas.pg,true);


	for(int i=0;i<mpas_to_play;++i){
		PAnimalSlice pa=paslices.get(i);

		if(pa.draw_stage>1){
			machine2.update(pa.x%width+pa.wid/2,pa.y+pa.hei,pa.elastic_strength,pa.alien_vel/pa.land_vel,pa.phi);
		}
		pa.draw(stroke_canvas.pg,false,true);
		pa.draw(fill_canvas.pg,true,true);

		pa.draw(stroke_canvas.pg,false,false);
		pa.draw(fill_canvas.pg,true,false);
		// image(pa.mtext.pg,pa.x,pa.y);


	}


	
	stroke_canvas.endDraw();
	fill_canvas.endDraw();

	blendMode(LIGHTEST);
   	fill_canvas.draw();
   	//stroke_canvas.draw();

   	blendMode(NORMAL);
   	image(stroke_canvas.pg,-width*stroke_canvas.overlap,-width*stroke_canvas.overlap);


	
	switch(play_mode){
		
		case 0:
			// if(frameCount%100==0){
			// 	mid_pos=0;
			// 	for(int i=0;i<mpas_to_play;++i){
			// 		PAnimal pa=pas.get(i);
			// 		mid_pos+=(pa.x+pa.wid);
			// 	}
			// 	mid_pos/=pas.size();
			// 	mid_pos*=.8;
			// // println(mid_pos);
			// }else{
			// 	for(int i=0;i<mpas_to_play;++i){
			// 		PAnimal pa=pas.get(i);
			// 		pa.x-=(play_mode==1)?mid_pos/80:mid_pos/100;
			// 	}
			// }
			break;


	}
	

	frame.setTitle(String.valueOf(frameRate));
	if(save_frame) saveFrame("pee-2-####.png");
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
			for(PAnimal pa:pas){
			 	pa.transport_mode=play_mode;
			 	pa.land_vel=(int)random(2,10);
			 	// pa.start_frame=frameCount;
			 		
			}
			
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
		case 'e':
			machine=new Machine(-width/4,0,width*1.5f,height);
			break;
	}
}


class DistortGraphic{
	
	PGraphics pg;
	ArrayList<PVector> vertexPoints;
	ArrayList<PVector> texturePoints;
	FloatList phases;

	float overlap=0.3f;
	int play_vel=5;
	int transform_vel=16;
	int WID_SEG=20;
	float transform_mag=1.4f;

	DistortGraphic(int wid_seg){
		vertexPoints=new ArrayList<PVector>();
		texturePoints=new ArrayList<PVector>();
		phases=new FloatList();
		
		WID_SEG=wid_seg;

		float w=width*(1+overlap*2)/WID_SEG;
		for(int i=0;i<WID_SEG;++i)
			for(int j=0;j<WID_SEG;++j){
				vertexPoints.add(new PVector(i*w,j*w));
				texturePoints.add(new PVector(i*w,j*w));
			
				phases.append(random(TWO_PI));
			}
		pg=createGraphics((int)(width*(1+overlap*2)),(int)(height*(1+overlap*2)));
	}

	public void draw(){
		// int len=vertexPoints.size();
		pushMatrix();
		translate(-width*overlap,-height*overlap);
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
		pg.pushMatrix();
		pg.translate(width*overlap,height*overlap);
	}
	public void endDraw(){

		pg.popMatrix();
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
class Experiment{
		
	float x,y,wid,hei;


	float phi=random(TWO_PI);
	float vel=random(1,15);

	Experiment(float x_,float y_,float wid_,float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;

	}

	public void draw(PGraphics pg){
		float draw_portion=(float)frameCount/vel+phi;
		draw_portion%=TWO_PI;
		
		pg.pushStyle();
		pg.noFill();
		pg.stroke(0);

		pg.pushMatrix();
		pg.translate(x,y);
		pg.beginShape();
			pg.vertex(0,0);
			pg.bezierVertex(wid/3*sin(draw_portion),-hei/5,
							wid/2*sin(draw_portion),-y,
							wid/4*sin(draw_portion),-hei);
		pg.endShape();
		pg.popMatrix();

		pg.popStyle();
	}

}

class Machine2{
	
	float dest_x;
	float dest_y;
	float dest_strength;
	float vel;
	float phi;
	float cur_x=width/2,cur_y;
	float delta_y;

	float wid=50;
	float hei=120;

	boolean isSet=false;

	Machine2(){

	}
	
	public void draw(PGraphics pg,boolean draw_fill){
		pg.pushStyle();
		if(draw_fill){
			pg.noStroke(); pg.fill(120);
		}else{
			pg.noFill(); pg.stroke(0);
		}
		
		

		if(isSet){
			
			float frame_portion=(float)(frameCount-0)/vel+phi;
			frame_portion%=(TWO_PI);
			int draw_stage=floor(frame_portion/(PI/2));
			if(draw_stage<1){
				isSet=false;
				// println("dest unlock!");
			}
			delta_y=(height-hei-dest_y-dest_strength)*sin(frame_portion);
			// println(dest_x+"-"+tmp_y);

			if(cur_x!=dest_x) cur_x+=(dest_x-cur_x)/8;
		}else delta_y=0;

		
		float draw_portion=-abs(sin((float)frameCount/(50)));

		pg.pushMatrix();
		pg.translate(hei,0);
		float tmp_hei=height-hei+delta_y;
		pg.beginShape();
			pg.vertex(cur_x+wid,height);
			pg.vertex(cur_x+wid,tmp_hei+hei);
			pg.bezierVertex(cur_x+wid,tmp_hei+hei-hei*.55f+hei/15*draw_portion,
							cur_x+wid-hei+hei*.55f,tmp_hei+hei/5*draw_portion,
							cur_x+wid-hei*1.2f,tmp_hei-hei/12);
			pg.bezierVertex(cur_x+wid-hei*.9f,tmp_hei-hei/12,
							cur_x+wid-hei*.85f,tmp_hei+wid-hei/12,
							cur_x+wid-hei,tmp_hei+wid);
			pg.bezierVertex(cur_x+wid-hei+(hei-wid)*.65f,tmp_hei+wid,
							cur_x,tmp_hei+hei-(hei-wid)*.55f,
							cur_x,tmp_hei+hei+hei/12*draw_portion);
			
			pg.bezierVertex(cur_x,tmp_hei+hei,
							cur_x,tmp_hei+hei,
							cur_x-wid/2,height+hei);

			// pg.vertex(cur_x,tmp_hei-hei);
			
		pg.endShape();
		pg.translate(cur_x+wid-hei*1.2f,tmp_hei);
		if(draw_fill) pg.fill(125,0,0);

		pg.beginShape();
			pg.vertex(0,-hei/12);
			pg.bezierVertex(hei/2*(1-.2f),-hei/12,
							hei/2*(1-.2f),hei/2,
							0,hei/2);
			pg.bezierVertex(-hei/2*(1-.2f),hei/2,
							-hei/2*(1-.5f),-hei/12,
							0,-hei/12);
		pg.endShape();
		// pg.fill(255);
		// pg.translate(0,hei/25);
		// pg.beginShape();
		// 	pg.vertex(0,hei/12*draw_portion);
		// 	pg.bezierVertex(hei/2*(1+.05*draw_portion),0,
		// 					hei/2*(1+.05*draw_portion),hei/2,
		// 					0,hei/2);
		// 	pg.bezierVertex(-hei/2*(1+.05*draw_portion),hei/2,
		// 					-hei/2*(1+.05*draw_portion),0,
		// 					0,hei/12*draw_portion);
		// pg.endShape();


		pg.popMatrix();
		pg.popStyle();
	}

	public void update(float x_,float y_,float strength_,float vel_,float phi_){
		if(!isSet){
			if(x_>width) return;
			cur_x=dest_x; cur_y=dest_y;

			dest_x=x_; dest_y=y_; vel=vel_; phi=phi_;
			dest_strength=strength_;
			isSet=true;
			// println("dest set!");
		}
	}
}
public void drawMeatSpace(PGraphics pg,boolean draw_fill){

	int noise_scale=8;
	// pg.beginDraw();
	// pg.background(0);
	if(draw_fill) pg.noStroke();
	else{ pg.stroke(0); pg.noFill(); noise_scale=60;}

	PVector color_separate=new PVector(0.9f,0.9f,0.9f);
	// int cycle=(int)((float)frameCount/80)%3;
	// if(cycle==0) color_separate.x=1;
	// if(cycle==1) color_separate.y=1;
	// if(cycle==2) color_separate.z=1;
	
	for(int x=0;x<=pg.width;x+=noise_scale)
		for(int y=0;y<=pg.height;y+=noise_scale){
    		float val=noise(x+random(-1,1),y+random(-1,1));
    		if(draw_fill) pg.fill(val*220*color_separate.x,val*220*color_separate.y,val*220*color_separate.z);
    		pg.rectMode(CENTER);
    		pg.rect(x,y,noise_scale,noise_scale);
  		}



  	// pg.endDraw();


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
	float run_vel=50;
	float alien_vel=random(120,250);

	
	float s_body_hei_incre=0;

	PVector first_foot_base;
	PVector last_foot_base;

	float stop_draw_portion;
	float stop_run_portion;

	PAnimal child_animal;
	int generation=0;
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
		//leg_span.append(0);
		for(int i=0;i<mleg;++i){
			leg_span.append(random(0.05f,0.5f));
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

		generation=copy_pa.generation+1;
		println("create child at generation "+generation);

		start_frame=frameCount;
	}
	public void draw(PGraphics pg,boolean draw_fill){
		
		
		
		
		float draw_portion=1.5f*abs(sin((float)frameCount/(120/land_vel)));

		float run_portion=(float)(frameCount-start_frame)/(run_vel/land_vel)+run_phi;
					

		float frame_portion=(float)(frameCount-start_frame)/(alien_vel/land_vel)+phi;
		frame_portion%=(TWO_PI*2);
		int new_alien_stage=(int)((frame_portion)/(PI/2));
		

		float cur_body_wid=body_wid;
		if(generation!=MAX_GENERATION){
			switch(alien_stage){
				case 2:
					if(new_alien_stage==3){
					 	stop_run_portion=run_portion;
					 	if(generation<MAX_GENERATION){
					 		if(child_animal==null) child_animal=new PAnimal(this);
					 	}
					}
					break;
				case 3:
					if(new_alien_stage==4){
						stop_draw_portion=draw_portion;
						// alien_stage=4;
					}
					run_portion=stop_run_portion;
					break;				
				case 4:
				case 5:
				case 6:
				case 7:
					draw_portion=stop_draw_portion;
					run_portion=stop_run_portion;
					break;

			}
		}
		if(alien_stage<7) alien_stage=new_alien_stage;
		// println(alien_stage+"  "+new_alien_stage);
		
		if(alien_stage>=3){
			if(child_animal!=null) child_animal.draw(pg,draw_fill);	
			else if(generation<MAX_GENERATION) child_animal=new PAnimal(this);
		} 

		pg.pushStyle();
		
		if(draw_fill){
		 	pg.noStroke();
		 	pg.fill(255,0);
		 	// pg.noFill();
		 	// if(alien_stage<6) pg.fill(fcolor);
		 	// else if(alien_stage==6) pg.fill(fcolor,abs(255*sin(frame_portion)));
		}else{
		 	pg.noFill();
		 	// if(alien_stage<6){
		 	 // pg.fill(fcolor);
		 	 pg.stroke(0);
		 	// }else if(alien_stage==6){
		 	// 	pg.fill(fcolor,255*abs(cos(frame_portion)));
		 	// 	pg.stroke(0,255*abs(cos(frame_portion)));
		 	// }else{
		 	// 	pg.noStroke();
		 	// 	pg.noFill();
		 	// }
		}

		pg.pushMatrix();

		if(transport_mode==0){
			pg.translate(x,y);
			
		}

		pg.beginShape();
		pg.vertex(0,0+s_body_hei_incre);
		pg.bezierVertex(cur_body_wid/3,-body_hei*.3f*draw_portion+s_body_hei_incre,
						 cur_body_wid/3*2,-body_hei*.3f*draw_portion+s_body_hei_incre,
						 cur_body_wid,0);

		if(alien_stage<3 || generation==MAX_GENERATION){
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
			
		}
		pg.vertex(cur_body_wid*(1-(float)(0+leg_span.get(0))/mleg),body_hei);

		for(int i=0;i<mleg;++i){
			if(i>0) pg.vertex(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei);

			if(transport_mode==0){
				if(generation!=MAX_GENERATION && generation!=0 && alien_stage==0) continue;
				drawRunLeg(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei,leg_wid,leg_hei,i,pg,run_portion);
				
			} 
			
					
		}
		
		pg.bezierVertex(-cur_body_wid*.1f*draw_portion,body_hei,
					 -cur_body_wid*.1f*draw_portion,0,
					 0,0+s_body_hei_incre);


		pg.endShape();
		
		if(alien_stage>=3 && generation!=MAX_GENERATION){
			pg.pushMatrix();
			pg.translate(cur_body_wid,0);
			if(alien_stage==3) pg.rotate(-PI/1.2f*cos(frame_portion));
			else pg.rotate(-PI/1.2f);
			pg.translate(-cur_body_wid,0);

			pg.beginShape();
			pg.vertex(cur_body_wid,0);

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
			pg.endShape(CLOSE);
			pg.popMatrix();
		}
		


		if(draw_fill){
			pg.stroke(red(fcolor)/1.1f,green(fcolor)/1.1f,blue(fcolor)/1.3f);
			pg.beginShape();
			for(int i=0;i<80;++i){
					// pg.strokeWeight(random(2));
					pg.vertex(random(cur_body_wid),
							   random(-body_hei*.1f,body_hei/2));
			
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
				//  elastic_strength=(float)land_vel/10*random(1,3);
				// }
				// land_vel=constrain(land_vel, 5, 20);
				if(generation!=MAX_GENERATION && alien_stage>0 && alien_stage<3) x+=land_vel/10;
				else if(generation==MAX_GENERATION && x<width*1.5f) x+=land_vel/10;
				else if(generation==0  && alien_stage==0)  x+=land_vel/10;
				break;

		}
		
	}
	public void drawRunLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg,float frame_portion){


		
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		
		float kang=-PI/2.5f*(sin(frame_portion));
		if(leg_index%2==1) kang=-PI/2.5f*(sin(frame_portion+PI/2));
		float fang=0;//+PI/1.8;
		
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
}



class PAnimalSlice{
	
	float x,y,wid,hei;
	float head_wid,head_hei;
	float body_wid,body_hei;
	
	float leg_wid,leg_hei;
	int mleg;
	FloatList leg_span;

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
	float run_vel=50;
	float alien_vel=random(200,350);

	
	float s_body_hei_incre=0;

	PVector first_foot_base;
	PVector last_foot_base;

	float stop_draw_portion;
	float stop_run_portion;

	PAnimal child_animal;
	int generation=0;
	int start_frame;

	Experiment experi;

	float slice_angle=random(PI/8,PI/4);
	int draw_stage=0;

	
	PAnimalSlice(float x_,float y_,float wid_,float hei_){
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
		run_phi=random(HALF_PI);
				


		land_poses=new FloatList();
		land_length=(int)(random(.5f,1.2f)*width);
		for(int i=0;i<land_length;++i){
			if(random(20)<1) land_poses.append(random(-LAND_DISTORT,0)*30);
			else land_poses.append(random(-LAND_DISTORT,LAND_DISTORT));
		} 
		land_vel=(int)random(3,10);
		land_index=0;

		elastic_strength=height/2-y;
		start_frame=frameCount;
		// child_animal=new PAnimal(this);
		
		experi=new Experiment(0,0,body_wid,y+elastic_strength);
	}	
	PAnimalSlice(PAnimal copy_pa){

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

		generation=copy_pa.generation+1;
		println("create child at generation "+generation);

		start_frame=frameCount;
	}
	public void draw(PGraphics pg,boolean draw_fill,boolean drawMeat){
		
		pg.pushStyle();
		
		if(draw_fill){
		 	pg.noStroke();
		 	if(drawMeat){
		 		pg.pushMatrix();
				pg.translate(-3,-5);		 	 	
					pg.fill(fcolor);
					drawAnimal(pg,draw_fill,drawMeat);
				pg.popMatrix();
				pg.fill(0);
				
		 	}else pg.fill(fcolor);
		}else{
		 	 // pg.fill(red(fcolor));
		 	 if(drawMeat){

		 	 	pg.fill(255,0); 
		 	 }else{
		 	  pg.fill(fcolor);
		 	}
		 	 pg.stroke(0);

		}
		

		drawAnimal(pg,draw_fill,drawMeat);

		pg.popStyle();

		update();

	}
	public void drawAnimal(PGraphics pg,boolean draw_fill,boolean drawMeat){
		float draw_portion=1.5f*abs(sin((float)frameCount/(120/land_vel)));
		

		float run_portion=(float)(frameCount-start_frame)/(run_vel/land_vel)+run_phi;
					

		float frame_portion=(float)(frameCount-start_frame)/(alien_vel/land_vel)+phi;
		frame_portion%=(TWO_PI);
		draw_stage=floor(frame_portion/(PI/2));

		float down_height=0;
		// float cur_x=0;
		if(draw_stage>1) down_height=-elastic_strength*sin(frame_portion);
		else{
			x+=land_vel/5;

		}
		float cur_body_wid=body_wid;
		

		
		pg.pushMatrix();

		if(transport_mode==0){
			pg.translate(x%width,y+down_height);
			
			pg.pushMatrix();
			pg.rotate(PI/12);

			if(drawMeat){
				// pg.translate(x,y);
				pg.shearY(PI/12);
			}else{
				pg.translate(0,body_hei);
				// pg.shearY(PI/8*abs(draw_portion));
				if(draw_stage>1) pg.rotate(slice_angle*abs(sin(frame_portion)));
				pg.translate(0,-body_hei);
				pg.shearY(PI/12);
			}
		}

		pg.beginShape();
		pg.vertex(0,0+s_body_hei_incre);
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
			
		
		pg.vertex(cur_body_wid*(1-(float)(0+leg_span.get(0))/mleg),body_hei);

		for(int i=0;i<mleg;++i){
			if(i>0) pg.vertex(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei);

			if(transport_mode==0){
				drawStandLeg(cur_body_wid*(1-(float)(i+leg_span.get(i))/mleg),body_hei,leg_wid,leg_hei,i,pg,run_portion);
			} 
			
					
		}
		
		pg.bezierVertex(-cur_body_wid*.1f*draw_portion,body_hei,
					 -cur_body_wid*.1f*draw_portion,0,
					 0,0+s_body_hei_incre);


		pg.endShape();
		
		
		pg.pushStyle();
		if(false){//!draw_fill && drawMeat){
		 	pg.stroke(0);
		 	pg.fill(fcolor);
		// }else{
		//  	 // pg.fill(red(fcolor));
		//  	 pg.noFill();
		//  	 pg.stroke(0);
		// }
			draw_portion=1;
			pg.beginShape();
				float hx=bezierPoint(cur_body_wid,cur_body_wid+head_wid/2,cur_body_wid+head_wid,cur_body_wid,.5f);
				float hy=bezierPoint(0,-body_hei*(.1f*draw_portion+.1f),head_hei+body_hei*(.4f*draw_portion+.1f),head_hei,.5f);
				
				pg.vertex(hx,hy);
				pg.bezierVertex(cur_body_wid+head_wid/2,-body_hei*(.6f*draw_portion+s_body_hei_incre+.1f),
							 	cur_body_wid/5,-body_hei*(.5f*draw_portion+s_body_hei_incre+.1f),
								0,0+s_body_hei_incre);

		
				// pg.vertex(0,0+s_body_hei_incre);
				pg.bezierVertex(cur_body_wid/3,-body_hei*.1f*draw_portion+s_body_hei_incre,
								 cur_body_wid/3*2,-body_hei*.1f*draw_portion+s_body_hei_incre,
								 cur_body_wid,0);

				pg.bezierVertex(cur_body_wid+ear_base1.x,ear_base1.y,
							  cur_body_wid+ear_base2.x,ear_base2.y,
							  cur_body_wid,0);
			pg.endShape();
		}
		pg.popStyle();

		if(!draw_fill && !drawMeat){
			pg.stroke(red(fcolor)/1.1f,green(fcolor)/1.1f,blue(fcolor)/1.3f);
			pg.beginShape();
			float last_tx=0, last_ty=0;
			for(int i=0;i<20;++i){
					// pg.strokeWeight(random(2));
				float tx=random(cur_body_wid);
				float ty= random(-body_hei*.1f,body_hei/2);
				if(i%3==0) pg.vertex(tx,ty);
				else pg.bezierVertex((last_tx+tx)/2*draw_portion,(last_ty+ty)/2,
									(last_tx+tx)/2,(last_ty+ty)/2*draw_portion,
									tx,ty);
				last_tx=tx;
				last_ty=ty;
			}

			pg.endShape();
		}

		pg.popMatrix();
		if(!draw_fill) experi.draw(pg);

		pg.popMatrix();
		

		
	}

	public void update(){
		switch(transport_mode){
			case 0:
			 	// x+=land_vel/5;
			 	// x%=width*1.5;
				break;

		}
		
	}
	public void drawRunLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg,float frame_portion){


		
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		
		float kang=-PI/2.5f*(sin(frame_portion));
		if(leg_index%2==1) kang=-PI/2.5f*(sin(frame_portion+PI/2));
		float fang=0;//+PI/1.8;
		
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
	public void drawStandLeg(float lx,float ly,float lw,float lh,int leg_index,PGraphics pg,float frame_portion){

		
		int stage=(int)((frame_portion%TWO_PI)/(PI/2));
		
		float kang=0;
		float fang=0;
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
}



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

	public void draw(PGraphics pg){

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
			float tmpw=random(.2f,3)*wid/(float)mhoriz;
			if(tmpx+tmpw>wid) tmpw=wid-tmpx;
			if(tmpw==0) break;

			tmpy=0;
			for(int j=0;j<mvert;++j){
				float tmph=random(.2f,3)*hei/(float)mvert;
				if(tmpy+tmph>hei || j==mvert-1) tmph=hei-tmpy;
				if(tmph==0) break;
				windows.add(new Window(tmpx,tmpy,tmpw,tmph,x,wid));
				tmpy+=tmph;
			}
			tmpx+=tmpw;
		}
	}

	public void draw(PGraphics pg,boolean draw_fill){
		
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
	public void update(){
		float draw_portion=(sin((float)frameCount/(20)));
		delta_x=width/150*abs(draw_portion);
		for(Window w: windows) w.x+=delta_x;
	}



}

class Window{

	float x,y,wid,hei;
	int mhoriz,mvert;
	float[] edge_distort_x,edge_distort_y;
	int fcolor;
	boolean is_circle=random(3)<1;

	float dx=random(.01f,.2f);
	float dy=random(.01f,.2f);
	
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
		
		if(mvert==1) dx=.01f;
		if(mhoriz==1) dy=.01f;

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
	public void draw(PGraphics pg,boolean draw_fill){
		
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
							pg.bezierVertex(tmp_wid*1.25f,0,tmp_wid,tmp_hei,
											tmp_wid/2,tmp_hei);
							pg.bezierVertex(-tmp_wid*.25f,tmp_hei,0,0,
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
final int MANG=7;

class Slice{

	float start_ang;
	float end_ang;
	float dest_end_ang;

	float rad_ratio=random(.1f,1);
	float thick_ratio=random(.01f,.05f);
	float vel=PI/random(10,120);
	float phi=random(PI);

	Slice(){
		start_ang=random(TWO_PI);
		dest_end_ang=random(PI/2,PI*3/2);
		end_ang=0;
	}
	public void draw(PGraphics pg,float cur_rad){

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
	public PVector getInterPoint(float rad,float ang){
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Peepee_v2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
