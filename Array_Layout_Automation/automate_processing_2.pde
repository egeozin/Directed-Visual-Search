import java.io.File;

// look-up table of centers of the location of Target Objects
float[][] centers = {{638, 102.5}, {781.5, 131}, {902.5, 213}, {984.5, 334}, {1013, 477.5},
          {984.5,622}, {903.5, 744}, {782, 826}, {637.5, 854.5},{493, 826},
           {371, 745},{290,622},{260.3, 478},{289.5, 334},{372, 212},{493.5, 131}};
       
// look-up table of the corners of the location of Target Objects
float[][] corners = {{593, 57.5}, {736.5, 86}, {857.5, 168},{939.5, 289}, {968, 432.5},
           {939.5, 577},{858.5, 699}, {737, 781}, {592.5, 809.5}, {448, 781},
           {326, 700}, {245, 577}, {215.3, 433},{244.5, 289}, {327,167}, {448.5, 86}};
           
float[][] centers30 = {{481.5, 204}, {796.5, 204}, {954.85, 477}, {796.5, 751.1}, {480.5, 751.1}, {322.85, 478.5}};

float[][] centers10 = { {638.35, 102}, {859.5, 174}, {995, 361}, {995, 593}, {859.5, 781.5}, {638.35, 855}, {417, 781.5}, {281, 593}, {281, 361}, {417, 174} };


int numFolders = 20; 
int numImages = 10;
 
File[] allFiles = new File[numFolders];  

PImage[] images = new PImage[10];

void setup(){
  size(1275, 956);
  smooth();
  
  for (int k =1; k< numFolders+1; k++){
    background(255);
    String globalPath = "/Users/egeozin/Desktop/Sinha_Lab/Experiments/Automate/prakash_pseudo/prakash_pseudo_"+k;
    File dir = new File(globalPath);
    File[] files = dir.listFiles();
    
    for(int i=0; i < files.length; i++ ){ 
      
      String path = files[i].getAbsolutePath();

      // check the file type and work with jpg files
      if( path.toLowerCase().endsWith(".jpg") ) {

        PImage imago = loadImage( path );
        images[i] = imago; 

      }
     }

     for (int j=0; j < images.length; j++) {
       imageMode(CENTER);
       if (images[j].width >= images[j].height){
         images[j].resize(180, 0);
       } else {
         images[j].resize(0, 180);
       }
       image(images[j], centers10[j][0], centers10[j][1]);
    // 
    }
    
    String stringo = "ds_prakash_array_pseudo_" + k + ".jpg";
    save(stringo);
    println("saved " + stringo);
  } 
}

void keyPressed(){
  save("first.jpg");
  println("saved");
}