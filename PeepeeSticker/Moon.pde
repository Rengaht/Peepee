
float moon_edge_y=width/2;
int mmoon_noise=(int)random(5,12);

void drawMoon(PGraphics pg,boolean draw_fill){

	float draw_portion=abs(sin((float)frameCount/50));
	pg.pushStyle();
	if(draw_fill){
		color fc=color(200+50*draw_portion,40*draw_portion+120,80);
		pg.noStroke(); pg.fill(fc);
	}else{
		pg.stroke(0); pg.noFill();
	}

	pg.beginShape();
		pg.vertex(-width/2,height*1.1);
		pg.vertex(width*5/4,height*1.1);
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
		// pg.scale(TOTAL_SCALE);
		pg.beginShape();
			// pg.vertex(0,0);
			// for(int x=0;x<2;++x){
				pg.vertex((width/8-width/25)*(1-sub_portion)-random(width/25),-width/8*(1-sub_portion)*random(.8,1.2));
				pg.vertex((width/8-width/25)*sub_portion-random(width/25),-width/8*sub_portion);
			// }
							// (width/8+width/25)*draw_portion+random(width/35),-width/8*draw_portion,
							// 0,0);
		pg.endShape();
		pg.popMatrix();
	}


}