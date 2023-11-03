PImage fondo, instruccionesFondo, simuladorFondo;
PFont font;
PImage acercadeFondo; 

float transitionAlpha = 255; // Initialize to fully visible

int buttonWidth = 350;
int buttonHeight = 140;

int simuladorButtonX = 720;
int simuladorButtonY = 480;

int instruccionesButtonX =720;
int instruccionesButtonY = 260;

boolean instruccionesVisible = false;
boolean simuladorVisible = false;
boolean slidersVisible = false; // Flag to indicate whether sliders should be shown
boolean acercaDeVisible = false;

float distortionRadius = 0;
float distortionMaxRadius = 50;
float distortionStrength = 5;

int slider1Value = 50;  // Rang o: 0 a 100
int slider2Value = 40;  // Rango: 0 a 90
int slider3Value = 0; // Rango: 0 a 200
int sliderWidth = 200;
int sliderHeight = 20;
float rectBottom;
ArrayList<PVector> positions = new ArrayList<PVector>();
float maxHeight = 0;
float totalTime = 0;
float totalDistanceX = 0;

PImage backgroundImage;
boolean button1Pressed = false;
boolean button2Pressed = false;
float buttonWidth1 = 60;
float buttonHeight1 = 30;
float buttonSpacing = 10; // Espacio entre los botones
float button1X, button1Y, button2X, button2Y; // Coordenadas de los botones
float maxHeightReached = 0;

int acercaX = 1050;
int acercaY = 360;
int acercaSize = 200;
float slider1ButtonX;
float slider2ButtonX;
PImage hamsterImage;
float hamsterWidth = 50;  // Adjust as needed
float hamsterHeight = 50;
// Define sliders


public void setup() {
  /* size commented out by preprocessor */  ;
  frameRate(144); // Set the frame rate to 60 FPS
  fondo = loadImage("foto1.png");
  instruccionesFondo = loadImage("instrucciones.png");
  simuladorFondo = loadImage("simulator.png");
  acercadeFondo = loadImage("acercade.png");  // Reemplaza "acercade.jpg" con la ruta de tu imagen
slider1ButtonX = 50 + sliderWidth / 2;
  slider2ButtonX = 50 + sliderWidth / 2;
  noStroke();
  font = createFont("Arial", 24);
  textFont(font);
  fill(0);
  textAlign(LEFT);

  // Initialize sliders with adjusted positions && value ranges


  backgroundImage = loadImage("simulator.png");

  rectBottom = (2 * height) / 3;
  hamsterImage = loadImage("hamster1.png");

  // Font setup
  font = createFont("Arial", 16);

  // Button position setup
  float buttonTop = rectBottom + 50;
  float sliderRight = 50 + sliderWidth;
  float spacing = 30;
  float buttonOffset = 50;
  button1X = sliderRight + spacing + buttonOffset + 100;
  button1Y = buttonTop;
  button2X = sliderRight + spacing + buttonOffset + 100;
  button2Y = button1Y + buttonHeight + buttonSpacing;

  myBall = new Ball(slider1Value, slider2Value);
  myBall.setupGUI();
}
public void draw() {
  background(255);  // Limpia el fondo

  if (acercaDeVisible) {
    // Código para la interfaz "Acerca de"
    image(acercadeFondo, 0, 0, width, height);
    drawButton(1100, 600, "Regresar");
  } else if (instruccionesVisible) {
    // Código para la interfaz de Instrucciones
    image(instruccionesFondo, 0, 0, width, height);
    drawButton(1000, 550, "Regresar");
  } else if (simuladorVisible) {


    image(simuladorFondo, 0, 0, width, height);
    

    if (slidersVisible) {
      if (myBall.isAtMaxHeight()) {
        float xAtMaxHeight = myBall.posX;
        float yAtMaxHeight = myBall.calculateYAtMaxHeight();
        fill(255, 0, 0); // Red color
        ellipse(xAtMaxHeight, yAtMaxHeight, 10, 10);
      }

      // Draw the upper rectangle for the Cartesian plane
      noFill();


      // Draw the X and Y axes in the upper rectangle
      // Cambia el color de las líneas a negro
      line(50, 50, 50, rectBottom - 50); // Vertical Y-axis
      line(50, rectBottom - 50, width - 50, rectBottom - 50); // Horizontal X-axis

      // Draw axis labels
      fill(0); // Cambia el color del texto a negro
      textFont(font);
      textSize(16);
      textAlign(RIGHT);
      text("X (m)", width - 60, rectBottom - 60);
      textAlign(LEFT);
      text("Y (m)", 60, 60);

      // Draw marks along the Y-axis
      // Draw marks along the Y-axis with 101.79 pixel spacing
      float pixelSpacingY = 101.79f;

      // Define la primera etiqueta en el eje Y (en este caso, 0)
      float labelValue = 0;

      for (float yMark = rectBottom - 50; yMark >= 50; yMark -= pixelSpacingY) {
        stroke(0); // Cambia el color de las marcas del eje Y a negro
        line(45, yMark, 55, yMark);
        textAlign(RIGHT);
        fill(0); // Cambia el color del texto de las marcas del eje Y a negro
        text(nf(labelValue, 0, 0), 45 - 5, yMark); // Asegúrate de que el texto no tenga decimales
        labelValue += 100; // Aumenta el valor de etiqueta en 100 unidades
      }
      // Draw marks along the X-axis

      float pixelSpacing = 101.79f;
      float xPosition = 50;
      int distance = 0;

      while (xPosition <= width - 50) {
         // Cambia el color de las marcas en el eje X a negro
        line(xPosition, rectBottom - 45, xPosition, rectBottom - 55);
        textAlign(CENTER);
        fill(0); // Cambia el color del texto de las marcas a negro
        text(Integer.toString(distance), xPosition, rectBottom - 60);
        xPosition += pixelSpacing;
        distance += 100;
      }




      // Draw the sliders with labels
      drawSlider(50, rectBottom + 50, slider1Value, "Velocidad m/s", 0, 100);
      drawSlider(50, rectBottom + 100, slider2Value, "Angulo", 0, 90);


      // Draw the buttons a little more to the right of the sliders


      // Calculate the angle in radians based on the slider2Value


      if (button1Pressed) {
        myBall.move();
      }

      // Dibuja la pelota
      myBall.display();
      PVector currentPos = new PVector(myBall.posX, myBall.posY);
      positions.add(currentPos);

      // Dibuja la trayectoria parabólica
      noFill();
      stroke(88, 56, 99); // Color rojo para la trayectoria
      beginShape();
      for (PVector pos : positions) {
        vertex(pos.x, pos.y);
      }
      endShape();


      // Muestra las propiedades de la pelota al lado de los botones
      float textOffset = 100; // Number of pixels to move the text to the right

      // Display the properties of the ball to the right of the buttons
      float propertiesX = 610;
      float propertiesY = 515;

      myBall.mostrarPropiedades(propertiesX, propertiesY);

      textAlign(LEFT);
      fill(0);

      if (maxHeight < 0) {
        maxHeight = 0;
      }

      text("Altura Actual: " + nf(maxHeight, 0, 2) + " m", propertiesX, propertiesY + 60);
      text("Tiempo Total: " + nf(totalTime, 0, 2) + " s", propertiesX, propertiesY + 100);

      text("Altura Max : " + nf(maxHeightReached, 0, 2) + " m", propertiesX, propertiesY + 80);


      text("Recorrido: " + nf(totalDistanceX, 0, 2) + " m", propertiesX, propertiesY + 120);


      float timeToMaxHeight = totalTime/2;
      fill(0); // Cambia el color del texto a negro
      textAlign(LEFT);
      text("Tiempo Hmax  " + nf(timeToMaxHeight, 0, 2) + " s", propertiesX, propertiesY + 140);
    }
  } else {
    // Código para otras interfaces (e.g., Fondo)
    image(fondo, 0, 0);
    drawButton(instruccionesButtonX, instruccionesButtonY, "Instrucciones");
    drawButton(simuladorButtonX, simuladorButtonY, "Simulador");
    drawButtonn(acercaX, acercaY, "Acerca de");
  }

  if (distortionRadius > 0) {
    fill(0, 100);
    ellipse(mouseX, mouseY, distortionRadius * 2, distortionRadius * 2);
    distortionRadius += distortionStrength;

    if (distortionRadius > distortionMaxRadius) {
      distortionRadius = 0;
    }
  }
}


public void drawButton(int x, int y, String label) {
  fill(150, 0);
  rect(x - buttonWidth / 2, y - buttonHeight / 2, buttonWidth, buttonHeight);
  fill(0, 0);
  textAlign(CENTER, CENTER);
  text(label, x, y);
}

public void mousePressed() {
  if (mouseX >= 320 && mouseX <= 470 && mouseY >= 550 && mouseY <= 600) {
    // Botón de lanzamiento
    // Inicia el movimiento de la pelota.
    button1Pressed = true;
    myBall.launch();
  }

  if (mouseX >= 320 && mouseX <= 470 && mouseY >= 630 && mouseY <= 680) {
    // Botón de restablecimiento
    // Detiene el movimiento de la pelota y la restablece a su posición original.
    button1Pressed = false;
    myBall.resetPosition();

    // Restablece los datos de los cálculos a 0
    maxHeight = 0;
    totalTime = 0;
    totalDistanceX = 0;
    maxHeightReached = 0;
  }


  if (instruccionesVisible && mouseX >= 900 - buttonWidth / 2 && mouseX <= 900 + buttonWidth / 2 &&
    mouseY >= 500 - buttonHeight / 2 && mouseY <= 500 + buttonHeight / 2) {
    instruccionesVisible = false;
    slidersVisible = false; // Hide sliders when switching screens
  } else if (simuladorVisible && mouseX >= 1100 - buttonWidth / 2 && mouseX <= 1100 + buttonWidth / 2 &&
    mouseY >= 600 - buttonHeight / 2 && mouseY <= 600 + buttonHeight / 2) {
    simuladorVisible = false;
    slidersVisible = false; // Hide sliders when switching screens
  } else if (mouseX >= instruccionesButtonX - buttonWidth / 2 && mouseX <= instruccionesButtonX + buttonWidth / 2 &&
    mouseY >= instruccionesButtonY - buttonHeight / 2 && mouseY <= instruccionesButtonY + buttonHeight / 2) {
    instruccionesVisible = true;
    slidersVisible = false; // Hide sliders when switching screens
  } else if (mouseX >= simuladorButtonX - buttonWidth / 2 && mouseX <= simuladorButtonX + buttonWidth / 2 &&
    mouseY >= simuladorButtonY - buttonHeight / 2 && mouseY <= simuladorButtonY + buttonHeight / 2) {

    simuladorVisible = true;
    slidersVisible = true; // Show sliders when "Simulador" is pressed
    if (mouseX >= button1X && mouseX <= button1X + buttonWidth && mouseY >= button1Y && mouseY <= button1Y + buttonHeight) {
      // Botón de lanzamiento
      // Inicia el movimiento de la pelota.
      button1Pressed = true;
      myBall.launch();
    }

    if (mouseX >= button2X && mouseX <= button2X + buttonWidth && mouseY >= button2Y && mouseY <= button2Y + buttonHeight) {
      // Botón de restablecimiento
      // Detiene el movimiento de la pelota y la restablece a su posición original.
      button1Pressed = false;
      myBall.resetPosition();

      // Restablece los datos de los cálculos a 0
      maxHeight = 0;
      totalTime = 0;
      totalDistanceX = 0;
      maxHeightReached = 0;
    }
  } else if (mouseX >= acercaX - acercaSize / 2 && mouseX <= acercaX + acercaSize / 2 &&
    mouseY >= acercaY - acercaSize / 2 && mouseY <= acercaY + acercaSize / 2) {
    acercaDeVisible = true;
  }
  if (acercaDeVisible && mouseX >= buttonWidth / 2 && mouseX <= buttonWidth / 2 + buttonWidth && mouseY >= height - 100 && mouseY <= height - 50) {
    acercaDeVisible = false;
  }
  if (acercaDeVisible) {
    if (mouseX >= width - buttonWidth / 2 && mouseX <= width - buttonWidth / 2 + buttonWidth && mouseY >= height - 100 && mouseY <= height - 50) {
      acercaDeVisible = false;
    }
  }
}






public void mouseReleased() {
  // Stop dragging sliders when the mouse is released
}



public void drawCartesianPlane(float originX, float originY, float planeWidth, float planeHeight) {
  // Draw X-axis (positive part)
  stroke(0); // Set stroke color to black
  line(originX, originY, 1150, originY); // X-axis (ajustado a 1150)

  // Draw arrowhead for X-axis
  float arrowSize = 10;
  triangle(1150 - arrowSize, originY - arrowSize / 2, 1150, originY, 1150 - arrowSize, originY + arrowSize / 2);

  // Customize axis labels and tick marks for X-axis
  textSize(14);
  fill(0);
  textAlign(RIGHT, CENTER);
  for (int x = floor(originX), i = 0; x < 1100; x += 50, i++) {
    line(x, originY - 5, x, originY + 5);
    text(i, x, originY + 20);
  }

  // Draw Y-axis (positive part)
  line(originX, originY, originX, 110); // Y-axis (ajustado a 110)

  // Draw arrowhead for Y-axis
  triangle(originX - arrowSize / 2, 110 + arrowSize, originX, 110, originX + arrowSize / 2, 110 + arrowSize);

  // Customize axis labels and tick marks for Y-axis
  textAlign(CENTER, BOTTOM);
  for (int y = floor(originY), i = 0; y > 110; y -= 50, i++) {
    line(originX - 5, y, originX + 5, y);
    text(i, originX - 20, y);
  }

  // Customize axis labels
  textSize(20);
  text("X", 1150, originY + 20); // Ajustado a 1150 para el eje X
  text("Y", originX + 20, 110); // Ajustado a 110 para el eje Y
}


Ball myBall;

class Ball {
  float vel1X;
  float vel1Y;
  float gravity = 9.81f;
  float angle;
  float initialX;
  float initialY;
  float posX;
  float posY;
  float time;
float v1 = 50; // Valor inicial para v1
float ang = 40; // Valor inicial para ang

  Ball(float v1, float ang) {
    vel1X = v1 * cos(radians(ang));
    vel1Y = v1 * sin(radians(ang));
    angle = ang;
    initialX = 50;
    initialY = 416;
    posX = initialX;
    posY = initialY;
    time = 0;
  }

  public void setupGUI() {
  }

  public void mostrarPropiedades(float x, float y) {
    textSize(16);
    fill(255);
    textAlign(LEFT);
    fill(0);
    text("Voₓ: " + nf(vel1X, 0, 2) + " m/s", 970, 70);
    text("Voγ " + nf(vel1Y, 0, 2) + " m/s", 970, 160);
  }

  public void resetPosition() {
    posX = 50;
    posY = 416;
    time = 0;
    isMoving = true;
    positions.clear();
  }

  public void launch() {
    time = 0;
  }
  public boolean reachedMaxHeight() {
    for (int i = 1; i < positions.size(); i++) {
      if (positions.get(i).y > positions.get(i - 1).y) {
        return false; // La pelota aún no ha alcanzado su altura máxima
      }
    }
    return true; // La pelota ha alcanzado su altura máxima
  }
  boolean isMoving = true;

  public void move() {
    if (isMoving) {
      time += 1.0f / frameRate;

      float delta_x = vel1X * time;
      float delta_y = (vel1Y * time) - (0.5f * gravity * pow(time, 2));
      posX = initialX + delta_x;
      posY = initialY - delta_y;

      if (angle == 90) {
        totalDistanceX = 0;
      } else {
        totalDistanceX = (posX - initialX)-0.1996f;
      }
      // Check if the ball has reached its maximum height and draw a red mark
      if (reachedMaxHeight()) {
        fill(255, 0, 0); // Red color
        ellipse(posX, posY, 10, 10);

        // Actualiza la altura máxima alcanzada si es mayor
        if (initialY - posY > maxHeightReached) {
          maxHeightReached = initialY - posY;
        }
      }

      maxHeight = round((initialY - posY) * 100000.0f) / 100000.0f;

      totalTime = (round(time * 100000.0f) / 100000.0f) - 0.05764f+0.0554f;

      if (posY >= rectBottom - 50) {
        isMoving = false;
        posY = rectBottom - 50;
      }
    }
  }



  public void resumeMovement() {
    isMoving = true;
    time = 0;
  }

  public void updateVelocity(int newVelocity) {
    vel1X = newVelocity * cos(radians(angle));
    vel1Y = newVelocity * sin(radians(angle));
  }

  public void updateHeight(int newHeight) {
    initialY = rectBottom - newHeight;
  }

  public void updateAngle(int newAngle) {
    angle = newAngle;
    updateVelocity(slider1Value);
  }

  public void display() {
    // Calculate the position to center the image
    float imageX = posX - hamsterWidth / 2;
    float imageY = posY - hamsterHeight / 2;

    // Display the hamster image at the centered position
    image(hamsterImage, imageX, imageY, hamsterWidth, hamsterHeight);
  }

  public boolean isAtMaxHeight() {
    if (posY >= rectBottom - 50) {
      for (int i = 0; i < positions.size(); i++) {
        if (i > 0 && positions.get(i).y > positions.get(i - 1).y) {
          return true;
        }
      }
    }
    return false;
  }

  public float calculateYAtMaxHeight() {
    return max(positions.get(0).y, positions.get(1).y);
  }
}



public void drawButton(float x, float y, float w, float h, String label, boolean pressed) {

  fill(255); // Cambiar a color(88, 56, 99)
  rect(x, y, w, h);
  fill(0); // Cambia el color del texto a negro
  textFont(font);
  textAlign(CENTER, CENTER);
  textSize(16);
  text(label, x + w / 2, y + h / 2);
}
public void mouseDragged() {
  if (slidersVisible) {
    if (mouseX >= 50 && mouseX <= 50 + sliderWidth) {
      if (mouseY >= rectBottom + 90 && mouseY <= rectBottom + 100 + sliderHeight) {
        slider1Value = PApplet.parseInt(map(constrain(mouseX, 50, 50 + sliderWidth), 50, 50 + sliderWidth, 0, 100));
        int newV1 = slider1Value;
        myBall.updateVelocity(constrain(newV1, 0, 100)); // Asegura que v1 esté dentro del rango

       
        slider1ButtonX = constrain(mouseX, 50, 50 + sliderWidth - 20);
      }
      if (mouseY >= rectBottom + 120 && mouseY <= rectBottom + 150 + sliderHeight) {
        slider2Value = PApplet.parseInt(map(constrain(mouseX, 50, 50 + sliderWidth), 50, 50 + sliderWidth, 0, 90));
        int newAng = slider2Value;
        myBall.updateAngle(constrain(newAng, 0, 90)); // Asegura que ang esté dentro del rango

        
        slider2ButtonX = constrain(mouseX, 50, 50 + sliderWidth - 20);
      }
    }
  }
}




public void mousePressedbtn() {
  if (mouseX >= button1X && mouseX <= button1X + buttonWidth && mouseY >= button1Y && mouseY <= button1Y + buttonHeight) {
    // Botón de lanzamiento
    // Inicia el movimiento de la pelota.
    button1Pressed = true;
    myBall.launch();
  }

  if (mouseX >= button2X && mouseX <= button2X + buttonWidth && mouseY >= button2Y && mouseY <= button2Y + buttonHeight) {
    // Botón de restablecimiento
    // Detiene el movimiento de la pelota y la restablece a su posición original.
    button1Pressed = false;
    myBall.resetPosition();

    // Restablece los datos de los cálculos a 0
    maxHeight = 0;
    totalTime = 0;
    totalDistanceX = 0;
    maxHeightReached = 0;
  }
}

public void drawSlider(float x, float y, int value, String label, int minVal, int maxVal) {
  y += 50; // Ajusta la posición vertical del slider 100 píxeles más abajo

  // Draw the label above the slider
  fill(0); // Cambia el color del texto a negro
  textFont(font);
  textAlign(CENTER, CENTER);
  textSize(16);
  text(label + ": " + value, x + sliderWidth / 2, y - 20);

  // Draw the slider bar
  fill(88, 56, 99); // Cambiar a color(88, 56, 99)
  rect(x, y, sliderWidth, sliderHeight);

  // Draw the slider button
  float buttonX = map(value, minVal, maxVal, x, x + sliderWidth - 20);
  fill(150, 150, 200); // Cambiar a color(88, 56, 99)
  float buttonWidth = 20; // Ancho del botón del slider
  float buttonHeight = sliderHeight; // Altura del botón del slider
  rect(buttonX, y, buttonWidth, buttonHeight);
}



public void drawButtonn(int x, int y, String label) {
    noStroke();  // Elimina el borde del botón
  fill(150, 0);
  rect(x - buttonWidth / 2, y - buttonHeight / 2, buttonWidth, buttonHeight);
  fill(0, 0);
  textAlign(CENTER, CENTER);
  text(label, x, y);
}


public void settings() {
  size(1200, 700);
}
public void drawSliderButton(float x, float y) {
  fill(150, 150, 200);
  float buttonWidth = 20;
  float buttonHeight = sliderHeight;
  rect(x, y, buttonWidth, buttonHeight);
}
