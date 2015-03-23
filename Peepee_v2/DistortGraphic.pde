class DistortGraphic{
	
	PGraphics pg;
	ArrayList<PVector> vertexPoints;
	ArrayList<PVector> texturePoints;
	FloatList phases;

	float overlap=0.3;
	int play_vel=5;
	int transform_vel=16;
	int WID_SEG=20;
	float transform_mag=1.4;

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

	void draw(){
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
	void update(){

		int len=vertexPoints.size();

		if(frameCount%play_vel==0){
			for(int i=0;i<len;++i){
				PVector p=vertexPoints.get(i);
				p.x+=sin(frameCount%transform_vel*TWO_PI/transform_vel+phases.get(i))*transform_mag;
				p.y+=cos(frameCount%transform_vel*TWO_PI/transform_vel+phases.get(i))*transform_mag;	
			}
		}
	}	
	void reset(){
		int len=vertexPoints.size();
		for(int i=0;i<len;++i){
			PVector vp=vertexPoints.get(i);
			PVector tp=texturePoints.get(i);
			vp.x=tp.x; vp.y=tp.y;
		}
	}
	void beginDraw(){
		pg.beginDraw();
		pg.pushMatrix();
		pg.translate(width*overlap,height*overlap);
	}
	void endDraw(){

		pg.popMatrix();
		pg.endDraw();
	}
	
	void background(color c){
		pg.background(c);
	}

	void fill(color c){
		pg.pushStyle();
		pg.noStroke();
		pg.fill(c);
		pg.rect(0,0,pg.width,pg.height);
		pg.popStyle();
	}
}