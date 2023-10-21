
//Simulation paramaters
static int maxParticles = 700;
float r = 5;
float genRate = 20;
float obstacleSpeed = 50;
float COR = 1;
float k_smooth_radius = 0.035;
float k_stiff = 150.0;
float k_rest_density = 0.2;
Vec2 gravity = new Vec2(0,500);
int waterCreated = 0;

// Node struct
class Ball {
  Vec2 pos;
  Vec2 vel;
  Vec2 last_pos;
  float dens;
  float press;

  Ball(Vec2 pos) {
    this.pos = pos;
    this.vel = new Vec2(0, 0);
    this.last_pos = pos;
    this.dens = 0.0;
    this.press = 0.0;
  }
}

class Pair {
  Ball ball1;
  Ball ball2;
  float q;
  float qq;
  float qqq;


  Pair(Ball ball1, Ball ball2, float q) {
    this.ball1 = ball1;
    this.ball2 = ball2;
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

Vec2 obstacleVel = new Vec2(0,0);


void createWater(){
  for (int i = 0; i < maxParticles; i++){
    water[i] = new Ball(new Vec2(20+random(20), 200+random(20)));
    water[i].pos = new Vec2(20+random(20), 200+random(20));
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
    //Gravity
    Vec2 acc = gravity; 
    
    //Compute vel from positions updated via pressure forces
    water[i].vel = (water[i].pos.minus(water[i].last_pos)).times(1/dt);
    water[i].vel = water[i].vel.plus(gravity);
     
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
    //Collision of Paricles
    for (int j = 0; j <  numParticles; j++){
      if(i != j){
        if (water[i].pos.distanceTo(water[j].pos) < (r+r)){
          Vec2 normal = (water[i].pos.minus(water[j].pos)).normalized();
          water[i].pos = water[j].pos.plus(normal.times(r+r).times(1));
          water[j].pos = water[i].pos.plus(normal.times(r+r).times(1));

        }
      }
    }
    
    //ToDo Move grabbed particles toward mouse
    water[i].last_pos = water[i].pos;
    water[i].pos = water[i].pos.plus(water[i].vel.times(dt));
    water[i].dens = 0.0;
  }
    
    //Find all neighboring particles
    ArrayList<Pair> pairs= new ArrayList<Pair>();
    for (int j = 0; j <  numParticles; j++){
         for (int k = 0; k <  numParticles; k++){
           float dist = water[j].pos.distanceTo(water[k].pos);
           if (dist < k_smooth_radius || j < k){
             float q = 1 - (dist/k_smooth_radius);
             pairs.add(new Pair(water[j], water[k], q));
           }
    }
    }
    //Accumulate per-particle density
    for(int j = 0; j < pairs.size(); j++){
      pairs.get(j).ball1.dens = pairs.get(j).ball1.dens + pairs.get(j).qq;
      pairs.get(j).ball2.dens = pairs.get(j).ball2.dens + pairs.get(j).qq;    
    }
    
    //Computer per-particle pressure: stiffness*(density - rest_density)
    for (int j = 0; j <  numParticles; j++){
      water[j].press = k_stiff*(water[j].dens-k_rest_density);
      if(water[j].press > 20){
         water[j].press =20;
      }
    }
    for(int j = 0; j < pairs.size(); j++){
      Ball a = pairs.get(j).ball1;
      Ball b = pairs.get(j).ball2;
      float q = pairs.get(j).q;
      float displace = (a.press + b.press) * pairs.get(j).q *(dt * dt);
      //a.pos = new Vec2(a.pos.plus(a.pos.minus(b.pos).normalized().times(displace)), a.pos.y + a.pos.minus(b.pos).normalized().times(displace).y);
      //println(a.pos);
      //a.pos.x = float(int(a.pos.x + a.pos.minus(b.pos).normalized().times(displace).x));
      //a.pos.y = float(int(a.pos.y + a.pos.minus(b.pos).normalized().times(displace).y));
      //b.pos.x = float(int(b.pos.x + b.pos.minus(a.pos).normalized().times(displace).x));
      //b.pos.y = float(int(b.pos.y + b.pos.minus(a.pos).normalized().times(displace).y));
      //pairs.set(j, new Pair(a.pos.plus(a.pos.minus(b.pos).normalized().times(displace)), b.pos.plus(b.pos.minus(b.pos).normalized().times(displace)), q));
       
    }
    
    
 
  
}

boolean leftPressed, rightPressed, upPressed, downPressed, shiftPressed;
void keyPressed(){
  if (key == ' ') paused = !paused;
}

boolean paused = true;
void draw(){
  if (!paused) update(1.0/frameRate);
  
  background(255); //White background
  stroke(0,0,0);
  for (int i = 0; i < numParticles; i++){
    float q = water[i].press/20;
    fill(120,120,20);
    circle(water[i].pos.x, water[i].pos.y, r*2); //(x, y, diameter)
  }
  
}
