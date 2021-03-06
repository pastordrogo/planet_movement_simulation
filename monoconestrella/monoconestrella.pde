int n_corps = 2;
float escala = 1.342*pow(10,-9);
//Gravitational constraint
float G = 6.647E-11;
float anguloP = radians(270);
float anguloS = radians(0);

//Star
Corp star;
float wstar = 1.99E30*escala;
float posxstar = 20*cos(anguloS);
float posystar = 20*sin(anguloS);
float widthstar = 10;
float heightstar = 10;
float speedXstar = 0;
float speedYstar = 0;


//Planet
Corp planet;
float wplanet = 5.972E24*escala;
float posxplanet = 150;
float posyplanet = 50*sqrt(7);
float widthplanet = 5;
float heightplanet = 5;
float speedXplanet;
float speedYplanet;
//Tiempo
float timeinterval;
float lasttimecheck;

Universe U;
int i,j;
float delta;
PVector totalForce;
PVector acceleration;
PVector fij;


void setup(){
  size(800, 800);
  background(255);
  totalForce = new PVector();
  acceleration = new PVector();
  fij = new PVector();
  totalForce.x = 0;
  totalForce.y = 0;
  acceleration.x = 0;
  acceleration.y = 0;
  lasttimecheck = millis();
  timeinterval = 1000;
  delta =0.01;
  speedXplanet = 3.99999;
  speedYplanet = -4.9999;
  star = new Corp(wstar,posxstar,posystar,speedXstar,speedYstar);
  planet = new Corp(wplanet,posxplanet,posyplanet,speedXplanet,speedYplanet);
}

void Gravitation(){
  
    
  if(millis() > (lasttimecheck + timeinterval)){
   
    //PVector sumForce = sumOfAllForces(planet, star);
    fij = forceBetween(planet, star);
    //Force between planet -> star
    totalForce.x = totalForce.x + fij.x;
    totalForce.y = totalForce.y + fij.y;
    
    //Force between star -> planet
    fij = forceBetween(star, planet);
    totalForce.x = totalForce.x + fij.x;
    totalForce.y = totalForce.y + fij.y;
    println("Suma fuerzas de gravedad: ", totalForce);
    //Centripetal Force
    totalForce.x = totalForce.x + planet.mass * pow(planet.speed.x,2) / planet.position.mag();
    totalForce.y = totalForce.y + planet.mass * pow(planet.speed.y,2) / planet.position.mag();
    
    //Centrifuge Force
    totalForce.x = totalForce.x - planet.mass * pow(planet.speed.x,2) / planet.position.mag();
    totalForce.y = totalForce.y - planet.mass * pow(planet.speed.y,2) / planet.position.mag();
    
    
    PVector.div(totalForce ,planet.mass, acceleration);
    
    println("Distancia: ", dist(planet.position.x,planet.position.y,star.position.x,star.position.y));
    println("Angulo entre vector de velocidad tangencial y vector radial: ",degrees(PVector.angleBetween(planet.position, planet.speed)));
    //Draw planet
    stroke(0);
    fill(255,255,0);
    ellipse(planet.position.x,planet.position.y,widthplanet,heightplanet);
    //Update speed    
    planet.speed.x = planet.speed.x + acceleration.x * delta;
    planet.speed.y = planet.speed.y + acceleration.y * delta;
    //Update position
    planet.position.x = planet.position.x + planet.speed.x * delta;
    planet.position.y = planet.position.y + planet.speed.y * delta;
    println("STATS Force: ", totalForce,"Accel: ",acceleration, "Speed: ",planet.speed, "Pos: ",planet.position);
    //Restart sums
    totalForce.x = 0;
    totalForce.y = 0;
    acceleration.x = 0;
    acceleration.y = 0;
   
}
      
      
}

PVector forceBetween(Corp ci, Corp cj){
  PVector rij = new PVector();
  rij.x = ci.position.x - cj.position.x;
  rij.y = ci.position.y - cj.position.y;
  float rijMag = rij.mag();
  PVector UnitaryVector = rij.normalize();
  PVector Fij = UnitaryVector.mult(- G * ci.mass * cj.mass).div(pow(rijMag,2));
  return Fij;
  
}


PVector sumOfAllForces(Corp ci, Corp cj){
  PVector sumForce = new PVector(0,0);
  PVector rij = new PVector();
  rij.x = ci.position.x - cj.position.x;
  rij.y = ci.position.y - cj.position.y;
  float rijMag = rij.mag();
  //Gravity Force
  PVector gForce = rij.mult(-G*ci.mass*cj.mass/pow(rijMag,2));
  sumForce.x = sumForce.x + gForce.x;
  sumForce.y = sumForce.y + gForce.y;
  // Opposite Gravity Force
  PVector oppositgForce = gForce.mult(-1);
  sumForce.x = sumForce.x + oppositgForce.x;
  sumForce.y = sumForce.y + oppositgForce.y;
  //Centripetal Force
  translate(ci.position.x,ci.position.y);
  sumForce.x = sumForce.x + ci.speed.mult(ci.mass).x;
  sumForce.y = sumForce.y + (1);
  translate(width/2,height/2);
  //Centrifuge Force
  //sumForce.x = sumForce.x + (1);
  //sumForce.y = sumForce.y + (1);
  return sumForce;
}



void draw(){
  //background(255);
  translate(400,400);
  stroke(0);
  fill(255,0,0);
  ellipse(posystar,posystar,widthstar,heightstar);
  //Arreglar esta rotacion para que estrella gire
  posxstar = 20*cos(anguloS*delta);
  posystar = 20*sin(anguloS*delta);
  anguloS = anguloS + radians(90);
  Gravitation();
  
}
