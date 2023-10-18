// HW2
// Based on in-class Physical Simulation Exercise
// Sarah Boelter <boelt072@umn.edu>

//Processing documentation was used for file-io


PrintWriter output;

// Node struct
class Node {
  Vec2 pos;
  Vec2 vel;
  Vec2 last_pos;

  Node(Vec2 pos) {
    this.pos = pos;
    this.vel = new Vec2(0, 0);
    this.last_pos = pos;
  }
}
//Delta T milliseconds
int deltaT = 50;
//interval for timing
int interval = 0;

//Link Length
float link_length = 1;

//Mass of Node
float m = 1;

//Energy
float kinetic_energy = 0;
float potential_energy = 0; 

//Number of nodes
static int numNodes = 5;
static int numWidth = 5;

//List to hold nodes
Node links[] = new Node[numNodes];
ArrayList<Node[]> linksWidth = new ArrayList<Node[]>();

//Populate Nodes

//Initial node positions
//Establishing base
Vec2 base_pos = new Vec2(3, 2);

void setup() {
  size(500, 500);
  linksWidth = new ArrayList<Node[]>();
  surface.setTitle("Homework 2");
  scene_scale = width / 10.0f;
  populateNodes();
  output = createWriter("graphData.txt");
 
}

void populateNodes(){
  //Creating a base_pos that can be added to for both x and y
  //This inidcates a corner of the cloth
  float base_pos_update = base_pos.x;
  float base_pos_update_y = base_pos.y;
  for (int j = 0; j < numWidth; j++){
    //Going through nodes and adding positions
    Node link[] = new Node[numNodes];
    for (int i = 0; i < numNodes; i++){
      link[i] = new Node(new Vec2(base_pos_update, base_pos_update_y));
      base_pos_update = base_pos_update + 1;
      //println(link[i].pos);
    }
    //println(link);
    //This assumes that the blanket is either a square
    linksWidth.add(link);
    //println(links[j].pos);
    base_pos_update_y = base_pos_update_y + 1;
    base_pos_update = base_pos.x;
  }
}

// Gravity
Vec2 gravity = new Vec2(0, 10);


// Scaling factor for the scene
float scene_scale = width / 10.0f;

//Total Length Error
float total_length_error;

//Physics Params
//Num Substeps
int num_substeps = 1;
//Num Relaxation Steps
int num_relaxation_steps = 100;


void update_physics(float dt) {
  // Semi-implicit Integration
  for (int j = 0; j < numNodes; j++){
    for (int i = 1; i < numWidth; i++){
      linksWidth.get(j)[i].last_pos = linksWidth.get(j)[i].pos;
      //links[i].last_pos = links[i].pos;
      linksWidth.get(j)[i].vel = linksWidth.get(j)[i].vel.plus(gravity.times(dt));
      //links[i].vel = links[i].vel.plus(gravity.times(dt));
      //links[i].pos = links[i].pos.plus(links[i].vel.times(dt));
      linksWidth.get(j)[i].pos = linksWidth.get(j)[i].pos.plus(linksWidth.get(j)[i].vel.times(dt));
    }
  }
  
  // Constrain the distance between nodes to the link length
  for (int k = 0; k < num_relaxation_steps; k++) {
      for (int j = 0; j < numNodes; j++){
        for (int i = 1; i < numWidth; i++){
          Vec2 delta = linksWidth.get(j)[i].pos.minus(linksWidth.get(j)[i-1].pos);
          float delta_len = delta.length();
          float correction = delta_len - link_length;
          Vec2 delta_normalized = delta.normalized();
          
          linksWidth.get(j)[i].pos = linksWidth.get(j)[i].pos.minus(delta_normalized.times(correction / 2));
          linksWidth.get(j)[i-1].pos = linksWidth.get(j)[i-1].pos.minus(delta_normalized.times(correction / 2));         
        }
      }
      float base_pos_update = base_pos.x;
      float base_pos_update_y = base_pos.y;
      for (int i = 1; i < numWidth; i++){
        //fix the base node in place
        linksWidth.get(i)[0].pos = new Vec2(base_pos_update, base_pos_update_y);
        base_pos_update = base_pos_update + 1;
        base_pos_update_y = base_pos_update_y +0;
      
      }
  }
  
  //// Update the velocities (PBD)
  for (int j = 0; j < numNodes; j++){
    for (int i = 1; i < numWidth; i++){
    linksWidth.get(j)[i].vel = linksWidth.get(j)[i].pos.minus(linksWidth.get(j)[i].last_pos).times(1 / dt); 
    }
  }

}

boolean paused = false;

void keyPressed() {
  exit(); 
}

float time = 0;
void draw() {
  float dt = 1.0 / 20; //Dynamic dt: 1/frameRate;
 
  if (!paused) {


      for (int i = 0; i < num_substeps; i++) {
        time += dt / num_substeps;
        update_physics(dt / num_substeps);
      }

  }



  background(255);
  stroke(0);
  strokeWeight(2);

  // Draw Nodes (green with black outline)
  fill(0, 255, 0);
  stroke(0);
  strokeWeight(0.02 * scene_scale);

  for (int i = 0; i < numWidth; i++){
    for (int j = 0; j < numNodes; j++){
      ellipse(linksWidth.get(i)[j].pos.x * scene_scale,linksWidth.get(i)[j].pos.y * scene_scale, 0.3 * scene_scale, 0.3 * scene_scale);      
    }
  }

  //Draw Links (black)
  stroke(0);
  strokeWeight(0.02 * scene_scale);
  
  for (int i = 1; i < numWidth; i++){
    for (int j = 0; j < numNodes; j++){
      line(linksWidth.get(i-1)[j].pos.x * scene_scale, linksWidth.get(i-1)[j].pos.y * scene_scale, linksWidth.get(i)[j].pos.x * scene_scale, linksWidth.get(i)[j].pos.y * scene_scale);
      line(linksWidth.get(j)[i-1].pos.x * scene_scale, linksWidth.get(j)[i-1].pos.y * scene_scale, linksWidth.get(j)[i].pos.x * scene_scale, linksWidth.get(j)[i].pos.y * scene_scale);
      //diagonal lines
      //line(linksWidth.get(i-1)[j-1].pos.x * scene_scale, linksWidth.get(i-1)[j-1].pos.y * scene_scale, linksWidth.get(i)[j].pos.x * scene_scale, linksWidth.get(i)[j].pos.y * scene_scale);
      //line(linksWidth.get(i-1)[j-1].pos.x * scene_scale, linksWidth.get(i)[j-1].pos.y * scene_scale, linksWidth.get(i)[j].pos.x * scene_scale, linksWidth.get(i-1)[j-1].pos.y * scene_scale);
    }
}
  //for (int j = 1; j < links.length; j++){
  //   line(links[j-1].pos.x * scene_scale, links[j-1].pos.y * scene_scale, links[j].pos.x * scene_scale, links[j].pos.y * scene_scale); 
  //}
}
