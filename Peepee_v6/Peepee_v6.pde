import javax.media.opengl.GL2;

final float TOTAL_SCALE=4;
PImage img_tex;

SpaceShip sship;
SpaceSheet ssheet;


void setup(){
	
	size(800,800,P3D);
	sship=new SpaceShip(width/2,height/2,width/8,height/16,220,random(TWO_PI),0);

	ssheet=new SpaceSheet(width/2,height/2,width/4,height/8,random(TWO_PI));

	img_tex=loadImage("Penguin.png");

}


void draw(){
	
	hint(DISABLE_DEPTH_TEST);

	background(255);
	// directionalLight(51, 102, 126, 1, 0, 0);

	float ang=map(mouseX,0,width,-TWO_PI,TWO_PI);
	PVector vup=new PVector(0,1,0);
	// camera(width/2,height/2+500,500,width/2,height/2,0,0,vup.y,vup.z);

	translate(width/2,height/2);
	rotateY((float)frameCount/100);
	PGL pgl = beginPGL();
  	pgl.enable(PGL.CULL_FACE);	
	
  	ssheet.draw(this.g,pgl,true);
	// ssheet.draw(this.g,pgl,false);
	

	endPGL();

	
}


