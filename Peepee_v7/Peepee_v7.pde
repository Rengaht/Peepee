
color[] shoe_color=new color[]{color(166,107,55),color(242,132,68),color(242,105,56)};
color[] pant_color=new color[]{color(28,90,116),color(85,190,193),color(215,163,150)};


PAnimal pa;
boolean save_frame;

void setup(){
	
	size(800,400);
	reset();
}
void reset(){
	pa=new PAnimal(new PVector(width/2,height/2),new PVector(random(.6,1.2)*120,random(.8,1)*25));

}

void draw(){
	
	background(255);

	pa.draw(this.g);

	if(mousePressed) reset();

	if(save_frame) saveFrame("pee_#####.png");
}
void keyPressed(){
	if(key=='a'){
		save_frame=!save_frame;
	}
}