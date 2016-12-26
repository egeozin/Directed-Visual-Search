import java.io.File;

float[][] center = {{638.35, 478}};
 
int numFolders = 1; 
int numImages = 16;
int numSelected = 20;
 
File[] allFiles = new File[numFolders];  

PImage[] images = new PImage[1];

void setup(){
  size(1275, 956);
  background(255);
  smooth();

    for(int i=0; i < numSelected; i++ ){ 
      background(255);
      //String path = files[i].getAbsolutePath();

      // check the file type and work with jpg files
      String path = "/Users/egeozin/Desktop/Sinha_Lab/Experiments/2_processed/pseudo/pseudo_selected_"+(i+1)+".jpg";
      if( path.toLowerCase().endsWith(".jpg") ) {

        PImage imago = loadImage(path); 

        imageMode(CENTER);
         if (imago.width >= imago.height){
           imago.resize(180, 0);
         } else {
           imago.resize(0, 180);
         }
         image(imago, center[0][0], center[0][1]);
      
    
      String stringo = "centered_pseudo" + (i+1) + ".jpg";
      save(stringo);
      println("saved " + stringo);
      }
     }
     
}


void keyPressed(){
  save("first.jpg");
  println("saved");
}