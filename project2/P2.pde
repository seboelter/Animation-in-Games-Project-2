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
float COR = 0.7; // Coefficient of restitution

//Link Length
float link_length = 25;

//Mass of Node
float m = 1;

//radius of node
int r=7;

//Number of nodes
static int numNodes = 5;

//Lists to hold nodes, 6 hanging strings
Node links0[] = new Node[numNodes];
Node links1[] = new Node[numNodes];
Node links2[] = new Node[numNodes];
Node links3[] = new Node[numNodes];
Node links4[] = new Node[numNodes];
Node links5[] = new Node[numNodes];

//Populate the external ball
Node externalNode;

//Populate Nodes

//Initial node positions
//Establishing base
Vec2 base_pos0 = new Vec2(100, 200);
Vec2 base_pos1 = new Vec2(150, 200);
Vec2 base_pos2 = new Vec2(200, 200);
Vec2 base_pos3 = new Vec2(250, 200);
Vec2 base_pos4 = new Vec2(300, 200);
Vec2 base_pos5 = new Vec2(350, 200);

ArrayList<Node[]> linksWidth = new ArrayList<Node[]>();

void setup() {
  size(700, 700);
  surface.setTitle("Project 2");
  linksWidth = new ArrayList<Node[]>();
  populateNodes();
}

void populateNodes(){
  //Creating a base_pos that can be added to
  float base_pos_update = base_pos0.y;
  //Going through nodes and adding positions
  for (int i = 0; i < numNodes; i++){
    links0[i] = new Node(new Vec2(base_pos0.x, base_pos_update));
    links1[i] = new Node(new Vec2(base_pos1.x, base_pos_update));
    links2[i] = new Node(new Vec2(base_pos2.x, base_pos_update));
    links3[i] = new Node(new Vec2(base_pos3.x, base_pos_update));
    links4[i] = new Node(new Vec2(base_pos4.x, base_pos_update));
    links5[i] = new Node(new Vec2(base_pos5.x, base_pos_update));
    base_pos_update = base_pos_update + 35;
  }
  //links3[2] = new Node(new Vec2(base_pos3.x+30, base_pos_update+30));
  linksWidth.add(links0);
  linksWidth.add(links1);
  linksWidth.add(links2);
  linksWidth.add(links3);
  linksWidth.add(links4);  
  linksWidth.add(links5);
  
  externalNode = new Node(new Vec2(circleX, circleY));
}

// Gravity
Vec2 gravity = new Vec2(0, 80);


// Scaling factor for the scene

//Total Length Error
float total_length_error;

//Physics Params
//Num Substeps
int num_substeps = 1;
//Num Relaxation Steps
int num_relaxation_steps = 10;

float circleX = 50;
float circleY = 100;
float circleR = 10;


void update_physics(float dt) {
  // Semi-implicit Integration
  for (int i = 0; i < linksWidth.size(); i++){
    for (int j = 1; j < numNodes; j++){
      linksWidth.get(i)[j].last_pos = linksWidth.get(i)[j].pos;
      linksWidth.get(i)[j].vel = linksWidth.get(i)[j].vel.plus(gravity.times(dt));
      linksWidth.get(i)[j].pos = linksWidth.get(i)[j].pos.plus(linksWidth.get(i)[j].vel.times(dt));
        for (int k = 0; k < linksWidth.size(); k++){
          for (int l = 0; l < numNodes; l++){
              if (k != i && l != j){
                if (linksWidth.get(i)[j].pos.distanceTo(linksWidth.get(k)[l].pos) < (r+r)){
                    Vec2 normal = (linksWidth.get(i)[j].pos.minus(linksWidth.get(k)[l].pos)).normalized();
                    linksWidth.get(i)[j].pos = linksWidth.get(k)[l].pos.plus(normal.times(r).times(.5));
                    linksWidth.get(k)[l].pos = linksWidth.get(i)[j].pos.plus(normal.times(r).times(.5));
                    Vec2 velNormal = normal.times(dot(linksWidth.get(i)[j].vel,normal));
                    linksWidth.get(i)[j].vel.subtract(velNormal.times(.5));
                    linksWidth.get(k)[l].vel.subtract(velNormal.times(.5));
                }
              }
          }
       }
       if (linksWidth.get(i)[j].pos.distanceTo(externalNode.pos) < (r+r)){
            Vec2 normal = (linksWidth.get(i)[j].pos.minus(externalNode.pos)).normalized();
            linksWidth.get(i)[j].pos = externalNode.pos.plus(normal.times(r).times(.5));
            
            Vec2 velNormal = normal.times(dot(externalNode.vel,normal));
            linksWidth.get(i)[j].vel.subtract(velNormal.times(.5 + COR));

     }
       
    }
  }

  // Constrain the distance between nodes to the link length
  for (int i = 0; i < num_relaxation_steps; i++) {
       for (int j = 0; j < linksWidth.size(); j++){
           for (int k = 1; k < numNodes; k++){
              Vec2 delta = linksWidth.get(j)[k].pos.minus(linksWidth.get(j)[k-1].pos);
              float delta_len = delta.length();
              float correction = delta_len - link_length;
              Vec2 delta_normalized = delta.normalized();
              linksWidth.get(j)[k].pos = linksWidth.get(j)[k].pos.minus(delta_normalized.times(correction / 2));
              linksWidth.get(j)[k-1].pos = linksWidth.get(j)[k-1].pos.plus(delta_normalized.times(correction / 2));
        
            }
        
      }

     linksWidth.get(0)[0].pos = base_pos0;
     linksWidth.get(1)[0].pos = base_pos1;
     linksWidth.get(2)[0].pos = base_pos2;
     linksWidth.get(3)[0].pos = base_pos3;
     linksWidth.get(4)[0].pos = base_pos4;
     linksWidth.get(5)[0].pos = base_pos5;

  }
  // Update the velocities (PBD)
    for (int i = 0; i < linksWidth.size(); i++){
      for (int j = 1; j < numNodes; j++){
         linksWidth.get(i)[j].vel = linksWidth.get(i)[j].pos.minus(linksWidth.get(i)[j].last_pos).times(1 / dt);   
    }
  }

}

boolean paused = false;


void keyPressed() {
  output.flush();  
  output.close();  
  exit(); 
}

void mouseDragged() {
  if (dist(mouseX, mouseY, circleX, circleY) < 2*r && mousePressed) {
      externalNode.pos = new Vec2(mouseX, mouseY);
      circleX = mouseX;
      circleY = mouseY;
  } 
}

float time = 0;
void draw() {
  float dt = 1.0 / 20; //Dynamic dt: 1/frameRate;
 
  if (!paused) {
    if( millis() - interval > deltaT){
      interval = millis();
      for (int i = 0; i < num_substeps; i++) {
        time += dt / num_substeps;
        update_physics(dt / num_substeps);
      }

    }

  }
  

  background(255);
  stroke(0);
  strokeWeight(2);
  
  //Draw circle for interaction
  fill(0, 255, 0);
  stroke(0);
  ellipse(circleX, circleY, r, r);

  // Draw Nodes (green with black outline)
  fill(0, 255, 0);
  stroke(0);
  strokeWeight(1);
  for (int i = 0; i < linksWidth.size(); i++){
    for (int j = 0; j < numNodes; j++){
     ellipse(linksWidth.get(i)[j].pos.x, linksWidth.get(i)[j].pos.y, r,r); 
    }
  }

  // Draw Links (black)
  stroke(0);
  strokeWeight(1);
    for (int i = 0; i < linksWidth.size(); i++){
      for (int j = 1; j < numNodes; j++){
       line(linksWidth.get(i)[j-1].pos.x, linksWidth.get(i)[j-1].pos.y, linksWidth.get(i)[j].pos.x, linksWidth.get(i)[j].pos.y); 
      }
    }
}
