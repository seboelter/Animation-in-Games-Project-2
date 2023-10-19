// Simulation and visualization of swinging ropes
boolean isDraggingObstacle = false;
PVector lastIntersection;


// Simulation Parameters
float floorHeight = 50;
PVector gravitationalForce = new PVector(0, 9.810, 0);

float nodeRadius = 1;
PVector obstaclePosition = new PVector(180, 90, 10);

float obstacleRadius = 10;
PVector ropeStringTop = new PVector(150, 50, 0);

float ropeRestLength = 1;
float nodeMass =    10.0; 
float springConstant = 100; 
float dampingCoefficient = 10; 

// Initial positions and velocities of masses
static int maxNodesCount = 50;
static int maxRopesCount = 40;

PVector nodePositions[][] = new PVector[maxRopesCount][maxNodesCount];
PVector nodeVelocities[][] = new PVector[maxRopesCount][maxNodesCount];
PVector nodeAccelerations[][] = new PVector[maxRopesCount][maxNodesCount];

int totalNodes = 12;
int totalRopes = 35;
Camera mainCamera;


void setup() {
    size(800, 800, P3D);
    mainCamera = new Camera();
    mainCamera.position = new PVector(200, 100, 200);
    surface.setTitle("Project 2");
    initializeScene();
}

void draw() {
    background(255);
    mainCamera.Update(1.0/frameRate);
   
    for (int i = 0; i < 40; i++) {
        update(1 / (40 * frameRate));
    }

    pointLight(255, 255, 255, width/2, height/2, 200);
  
    // Render ropes
    fill(125, 125, 0);
    strokeWeight(0);
    for (int j = 0; j < totalRopes - 1; j++) {
        for (int i = 0; i < totalNodes - 1; i++) {
            beginShape();
            vertex(nodePositions[j][i].x, nodePositions[j][i].y, nodePositions[j][i].z);
            vertex(nodePositions[j+1][i].x, nodePositions[j+1][i].y, nodePositions[j+1][i].z);
            vertex(nodePositions[j+1][i+1].x, nodePositions[j+1][i+1].y, nodePositions[j+1][i+1].z);
            vertex(nodePositions[j][i+1].x, nodePositions[j][i+1].y, nodePositions[j][i+1].z);
            endShape();
        }
    }

    pushMatrix();
    translate(obstaclePosition.x, obstaclePosition.y, obstaclePosition.z);
    fill(255, 255, 0);
    sphere(obstacleRadius);
    popMatrix();
}

void keyPressed() {
    mainCamera.HandleKeyPressed();
}

void keyReleased() {
    mainCamera.HandleKeyReleased();
}



void initializeScene() {
    float horizontalSpacing = ropeRestLength;
    float verticalSpacing = ropeRestLength;

    for (int j = 0; j < totalRopes; j++) {
        for (int i = 0; i < totalNodes; i++) {
            nodePositions[j][i] = new PVector(ropeStringTop.x + j * horizontalSpacing, ropeStringTop.y, ropeStringTop.z + i * verticalSpacing);
            nodeVelocities[j][i] = new PVector(0, 0, 0);
        }
    }
}
