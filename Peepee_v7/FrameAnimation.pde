class FrameAnimation{
	
	float ani_t,ani_vel;
	float delay_fr;

	float start_pos,end_pos;

	boolean ani_start=false;
	boolean is_reverse=false;
	boolean is_loop=false;
	boolean ani_end=false;

	boolean is_elastic=false;

	int total_count=0;

	FrameAnimation(float set_length){
		setup(set_length,0);
	}
	FrameAnimation(float set_length,float set_delay){
		setup(set_length,set_delay);
	}
	FrameAnimation(float set_length,float set_delay,float set_start,float set_end){
		setup(set_length,set_delay);
		setPos(set_start,set_end);
	}
	private void setup(float set_length,float set_delay){

		ani_vel=1.0/set_length;
		delay_fr=set_delay;

		Reset();
	}
	void Start(){
		ani_start=true;
		ani_end=false;
	}
	float GetPortion(){
		if(ani_t<0) return 0;
		if(ani_t==1) return 1;
		float k=0.5f;
		float r=0.5-0.5*cos(ani_t*(PI));
		if(is_elastic) r=0.5f-0.51f*cos(PI*ani_t+k*ani_t-k*0.5f);
		
		return is_reverse?(1-r):r;
	}
	float GetPos(){
		// Update();
		if(ani_t<0) return start_pos;
		return lerp(start_pos,end_pos,GetPortion());
	}
	void Update(){
		if(!ani_start) return;

		if(ani_t<1) ani_t+=ani_vel;
		else{
			if(is_loop){
				ani_t=-delay_fr*ani_vel;
				total_count++;
			}else{
				ani_start=false;
				ani_t=1;
			}
			
		}
	}
	void Pause(){
		ani_start=false;
	}
	void Reset(){
		ani_start=false;
		ani_t=-delay_fr*ani_vel;
		// Start();
	}
	void Restart(){
		Reset();
		Start();
		is_reverse=false;
	}
	void Reverse(){
		Reset();
		Start();
		is_reverse=true;
	}
	
	void setPos(float set_start,float set_end){
		start_pos=set_start;
		end_pos=set_end;
	}
	void setDelay(float set_delay){
		delay_fr=set_delay;		
	}
	boolean reachEnd(){
		return ani_t==1;
	}
}