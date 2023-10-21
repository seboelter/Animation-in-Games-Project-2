
//Simulation paramaters
static int maxParticles = 2000;
float r = 5;
float genRate = 20;
float obstacleSpeed = 50;
float COR = 1;
float k_smooth_radius = 10;
float k_stiff = 150.0;
float k_stiffN = 1000.0;
float k_rest_density = 0.2;
Vec2 gravity = new Vec2(0,200);
int waterCreated = 0;
ArrayList<Pair> pairs= new ArrayList<Pair>();

// Node struct
class Ball {
  Vec2 pos;
  Vec2 vel;
  Vec2 last_pos;
  float dens;
  float press;
  float densN;
  float pressN;

  Ball(Vec2 pos) {
    this.pos = pos;
    this.vel = new Vec2(0, 0);
    this.last_pos = pos;
    this.dens = 0.0;
    this.press = 0.0;
    this.densN = 0.0;
    this.pressN = 0.0;
  }
}

class Pair {
  Ball ball1;
  Ball ball2;
  float press;
  float q;
  float qq;
  float qqq;


  Pair(Ball ball1, Ball ball2, float q) {
    this.ball1 = ball1;
    this.ball2 = ball2;
    this.press = 0;
    this.q = q;
    this.qq = q*q;
    this.qqq = q*q*q;
  }
}
Ball water[] = new Ball[maxParticles];
int numParticles = 0;


void setup(){
  size(600,400);
  surface.setTitle("Water");
  strokeWeight(2); //Draw thicker lines 
}


void createWater(){
  for (int i = 0; i < maxParticles; i++){
    water[i] = new Ball(new Vec2(20+random(20), 200+random(20)));
    water[i].pos = new Vec2(20+random(30), 200+random(30));
    water[i].vel = new Vec2(60,-200); 
    numParticles += 1;
    }
    waterCreated =1;

}

void update(float dt){
   if(waterCreated ==0){
     createWater();
   }
  
  
  for (int i = 0; i < numParticles; i++){

    //Compute vel from positions updated via pressure forces
    water[i].vel = (water[i].pos.minus(water[i].last_pos)).times(1/dt);
    water[i].vel = water[i].vel.plus(gravity.times(dt));
     
    //Update position based on velocity
    //water[i].pos.add(water[i].vel.times(dt)); 
    
    //Border of simmulation
    if (water[i].pos.y > height - r){
      water[i].pos.y = height - r;
      water[i].vel.y *= -0.3;
    }
    if (water[i].pos.y < r){
      water[i].pos.y = r;
      water[i].vel.y *= -0.3;
    }
    if (water[i].pos.x > width - r){
      water[i].pos.x = width - r;
      water[i].vel.x *= -0.3;
    }
    if (water[i].pos.x < r){
      water[i].pos.x = r;
      water[i].vel.x *= -0.3;
    }
    //p.vel += 10*dt*((mousePos - p.pos)/grab_radius - p.vel)
    //water[i].vel = 10*dt
    //ToDo Move grabbed particles toward mouse
    water[i].last_pos = new Vec2(water[i].pos.x, water[i].pos.y);
    water[i].pos = water[i].pos.plus(water[i].vel.times(dt));
    water[i].dens = 0.0;
    water[i].densN = 0.0;
  }
    
    //Find all neighboring particles
    pairs= new ArrayList<Pair>();
    for (int j = 0; j <  numParticles; j++){
         for (int k = 0; k <  numParticles; k++){
           float dist = water[j].pos.distanceTo(water[k].pos);
           if (dist < k_smooth_radius && j < k){
             float q = 1 - (dist/k_smooth_radius);
             pairs.add(new Pair(water[j], water[k], q));
           }
      }
    }
    //Accumulate per-particle density
    for(int j = 0; j < pairs.size(); j++){
      pairs.get(j).ball1.dens = pairs.get(j).ball1.dens + pairs.get(j).qq;
      pairs.get(j).ball2.dens = pairs.get(j).ball2.dens + pairs.get(j).qq;     
      pairs.get(j).ball1.densN = pairs.get(j).ball1.densN + pairs.get(j).qqq;
      pairs.get(j).ball2.densN = pairs.get(j).ball2.densN + pairs.get(j).qqq;     
    }
    
    //Computer per-particle pressure: stiffness*(density - rest_density)
    for (int j = 0; j <  numParticles; j++){
      water[j].press = k_stiff*(water[j].dens-k_rest_density);
      water[j].pressN = k_stiffN*(water[j].densN);
      if(water[j].press > 30){
         water[j].press =30;
      }
      if(water[j].pressN > 300){
         water[j].pressN =300;
      }
    }
    for(int j = 0; j < pairs.size(); j++){
      Ball a = pairs.get(j).ball1;
      Ball b = pairs.get(j).ball2;
      float total_pressure = (a.press + b.press) * pairs.get(j).q + (a.pressN +b.pressN) * pairs.get(j).qq; 
      float displace = total_pressure *(dt * dt);     
      //println(a.pos);
      a.pos = a.pos.plus(a.pos.minus(b.pos).normalized().times(displace));
      b.pos = b.pos.plus(b.pos.minus(a.pos).normalized().times(displace));       
    }
    
    
 
  
}

boolean leftPressed, rightPressed, upPressed, downPressed, shiftPressed;
void keyPressed(){
  if (key == ' ') paused = !paused;
}

boolean paused = true;
void draw(){
  for(int i = 0; i<10; i++){
  float sim_dt = 0.003;
  if (!paused) update(sim_dt);
  }
  background(255); //White background
  stroke(0,0,0);
  for (int i = 0; i < numParticles; i++){
    float q = water[i].press/30;
    fill(120,120,20);
    circle(water[i].pos.x, water[i].pos.y, r*2); //(x, y, diameter)
  }
  
}
