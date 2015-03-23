
void drawSpace(PGraphics pg,boolean draw_fill){

	int noise_scale=10;
	// pg.beginDraw();
	// pg.background(0);
	pg.noStroke();
	PVector color_separate=new PVector(0.33,0.33,0.33);
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