
class PPart{

	float x,y,wid,hei;
	float ani_vel,ani_phi;
	
	PPart(float x_,float y_,float wid_,float hei_){
		x=x_; y=y_; wid=wid_; hei=hei_;
	
		ani_vel=random(10,20);
		ani_phi=random(TWO_PI);
	}

	float getDrawPortion(){
		return sin(((float)frameCount/ani_vel+ani_phi));
	}
	float getDrawAngle(){
		return (float)frameCount/ani_vel+ani_phi;
	}
}