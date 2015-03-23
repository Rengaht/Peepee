
class Tunnel{
	
	float x,y,wid,hei;

	Tunnel(float x_,float y_,float wid_,float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;
	}

	void draw(PGraphics pg, boolean draw_fill){

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