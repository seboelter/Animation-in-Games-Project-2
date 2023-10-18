//public class Vec3 {
//  public float x, y, z;

//  //public Vec2(float x, float y) {
//  //  this.x = x;
//  //  this.y = y;
//  //}
  
//  public Vec3(float x, float y, float z) {
//    this.x = x;
//    this.y = y;
//    this.z = z;
//  }

//  public String toString() {
//    return "(" + x + "," + y + ")";
//  }

//  public float length() {
//    return sqrt(x * x + y * y);
//  }

//  public float lengthSqr() {
//    return x * x + y * y;
//  }

//  public Vec3 plus(Vec3 rhs) {
//    return new Vec3(x + rhs.x, y + rhs.y, z+rhs.z);
//  }

//  public void add(Vec3 rhs) {
//    x += rhs.x;
//    y += rhs.y;
//    z += rhs.z;
//  }

//  public Vec3 minus(Vec3 rhs) {
//    return new Vec3(x - rhs.x, y - rhs.y, z-rhs.z);
//  }

//  public void subtract(Vec3 rhs) {
//    x -= rhs.x;
//    y -= rhs.y;
//    z -= rhs.z;
//  }

//  public Vec3 times(float rhs) {
//    return new Vec3(x * rhs, y * rhs, z * rhs);
//  }

//  public void mul(float rhs) {
//    x *= rhs;
//    y *= rhs;
//  }

//  public void clampToLength(float maxL) {
//    float magnitude = sqrt(x * x + y * y);
//    if (magnitude > maxL) {
//      x *= maxL / magnitude;
//      y *= maxL / magnitude;
//    }
//  }

//  public void setToLength(float newL) {
//    float magnitude = sqrt(x * x + y * y);
//    x *= newL / magnitude;
//    y *= newL / magnitude;
//  }

//  public void normalize() {
//    float magnitude = sqrt(x * x + y * y);
//    x /= magnitude;
//    y /= magnitude;
//  }

//  public Vec3 normalized() {
//    float magnitude = sqrt(x * x + y * y+z*z);
//    return new Vec3(x / magnitude, y / magnitude, z/magnitude);
//  }

//  public float distanceTo(Vec3 rhs) {
//    float dx = rhs.x - x;
//    float dy = rhs.y - y;
//    float dz = rhs.z - z;
//    return sqrt(dx * dx + dy * dy + dz*dz);
//  }
//}

//Vec3 interpolate(Vec3 a, Vec3 b, float t) {
//  return a.plus((b.minus(a)).times(t));
//}

////float interpolate(float a, float b, float t) {
////  return a + ((b - a) * t);
////}

//float dot(Vec3 a, Vec3 b) {
//  return a.x * b.x + a.y * b.y + a.z * b.z;
//}

//// 2D cross product is a funny concept
//// ...its the 3D cross product but with z = 0
//// ... (only the resulting z component is not zero so we just store it as a scalar)
////float cross(Vec2 a, Vec2 b) {
////  return a.x * b.y - a.y * b.x;
////}

////Vec2 projAB(Vec2 a, Vec2 b) {
////  return b.times(a.x * b.x + a.y * b.y);
////}

////Vec2 perpendicular(Vec2 a) {
////  return new Vec2(-a.y, a.x, a.z);
////}
