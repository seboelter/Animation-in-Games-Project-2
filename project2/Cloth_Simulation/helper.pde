void update(float deltaTime) {
    applyGravityToNodes();

    computeForcesBetweenNeighbors();

    updateNodesUsingEulerIntegration(deltaTime);

    handleFloorAndObstacleCollisions();
}

void applyGravityToNodes() {
    for (int j = 0; j < totalRopes; j++) {
        for (int i = 0; i < totalNodes; i++) {
            if (nodeAccelerations[j][i] == null) {
                nodeAccelerations[j][i] = new PVector();
            } else {
                nodeAccelerations[j][i].set(0, 0, 0);
            }
            nodeAccelerations[j][i].add(gravitationalForce);
        }
    }
}

void computeForcesBetweenNeighbors() {
    for (int j = 0; j < totalRopes; j++) {
        for (int i = 0; i < totalNodes; i++) {
            if (j < totalRopes - 1) {
                computeForceBetweenNodes(j, i, j + 1, i);
            }
            if (i < totalNodes - 1) {
                computeForceBetweenNodes(j, i, j, i + 1);
            }
        }
    }
}

void computeForceBetweenNodes(int j1, int i1, int j2, int i2) {
    PVector difference = PVector.sub(nodePositions[j2][i2], nodePositions[j1][i1]);
    float springForce = -springConstant * (difference.mag() - ropeRestLength);
    difference.normalize();
    float projVel1 = PVector.dot(nodeVelocities[j1][i1], difference);
    float projVel2 = PVector.dot(nodeVelocities[j2][i2], difference);
    float dampingForce = -dampingCoefficient * (projVel2 - projVel1);
    PVector totalForce = difference.mult(springForce + dampingForce);

    nodeAccelerations[j1][i1].add(totalForce.copy().mult(-1.0 / nodeMass));
    nodeAccelerations[j2][i2].add(totalForce.mult(1.0 / nodeMass));
}

void updateNodesUsingEulerIntegration(float deltaTime) {
    for (int j = 0; j < totalRopes; j++) {
        for (int i = 1; i < totalNodes; i++) {
            eulerIntegration(j, i, deltaTime);
        }
    }
}

void eulerIntegration(int j, int i, float deltaTime) {
    nodeVelocities[j][i].add(nodeAccelerations[j][i].copy().mult(deltaTime));
    nodeVelocities[j][i].mult(0.9999); // Damping factor
    nodePositions[j][i].add(nodeVelocities[j][i].copy().mult(deltaTime));
}

void handleFloorAndObstacleCollisions() {
    handleFloorCollisions();
    handleObstacleCollisions();
}

void handleFloorCollisions() {
    for (int j = 0; j < totalRopes; j++) {
        for (int i = 0; i < totalNodes; i++) {
            if (nodePositions[j][i].z + nodeRadius > floorHeight) {
                nodeVelocities[j][i].y *= -0.5; // Damping factor upon collision
                nodePositions[j][i].y = floorHeight - nodeRadius;
            }
        }
    }
}

void handleObstacleCollisions() {
    for (int j = 0; j < totalRopes; j++) {
        for (int i = 0; i < totalNodes; i++) {
            float distanceToObstacle = nodePositions[j][i].dist(obstaclePosition);
            if (distanceToObstacle < obstacleRadius + 0.09) {
                PVector normal = PVector.sub(nodePositions[j][i], obstaclePosition).normalize();
                float overlap = obstacleRadius + 0.1 - distanceToObstacle;
                nodePositions[j][i].add(normal.copy().mult(overlap));

                float velocityInNormalDir = PVector.dot(normal, nodeVelocities[j][i]);
                PVector collisionResponse = normal.mult(velocityInNormalDir * 1.1);
                nodeVelocities[j][i].sub(collisionResponse);
            }
        }
    }
}
