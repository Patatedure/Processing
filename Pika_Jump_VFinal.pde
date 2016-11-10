/*---------------------Musique---------------------*/
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
Minim minim;
AudioPlayer audiofond;
AudioPlayer jump;
AudioPlayer pikachu1;
AudioPlayer pikachu2;
AudioPlayer pikachu3;

/*-------------------Variables--------------------*/
int gravite, deplacement, gravitespeciale; //x,y du personnage + gravité individuel pour le rebond
PImage pikachu; //image du personnage
float Xvelmax=50; //nbr de pixel max lors du rebon
float gravity = 4; //intenssité de la gravité
float rebond = 4; ////intenssité du rebond
float deplacementgauche = -15; //intenssité du mouvement
float deplacementdroite = 15; //intenssité du mouvement
boolean keysrealesed = true; //button appuyer ou non?
boolean droite, gauche; // mouvement du personnage
boolean perdu; //perdu ou non?
int score=0; //varaiables score
boolean gravitetf=false; //en gravité ou non?
int statut=0; // nbr de pixel lors du rebond
int flag=0, choix=4, page=1; //etat dy jeux
float y, y1, y2, y3, y4, y5, y6, y7, xa, ya; //platefores
float taille=height/17.06; //taille du personnage
//String[] data = loadStrings("data.txt");
PImage choixp, choix1, choix2, choix3, choix4; //personnages
PImage choix1clique, choix2clique, choix3clique, choix4clique; //quand la souris passe dessus les personnages

/*-------------------Initialisation-----------------------------*/
void setup ()
{
  //adaptation de l'écran
  size(displayWidth, displayHeight); 
  frameRate(60);
  if (frame != null) { 
    frame.setResizable(true);
  } 
  //initialisation des scores

  // initialisation général
  initialisation (); // initialisation perso+platformes+mouvement
  //Musique de fond
  minim = new Minim(this);
  audiofond= minim.loadFile("Musique de fond.mp3");
  audiofond.loop();
}

/* ------------------------Initialisation-------------------------- */
void initialisation ()
{
  //image principale du personnage choisit
  if (choix==2)
  {
    pikachu = loadImage("pika4.png");
  }
  if (choix==1)
  {
    pikachu = loadImage("pichu.png");
  }
  if (choix==3)
  {
    taille=height/11.06;
    pikachu = loadImage("luca.png");
  }
  if (choix==4)
  {
    taille=height/11.06;
    pikachu = loadImage("raichu.png");
  }  

  //initialisation des mouvement et de l'emplacement du joueur
  droite=false;
  gauche=false;
  gravite=height/2-200;
  deplacement=height/2+150;
  perdu = false;

  //initialisation des platformes 
  xa=height-700;
  y=50;
  y1=150;
  y2=300;
  y3=400;
  y4=500;
  y5=700;
  y6=800;
  y7=900;
}

//Deuxième initialisation de la partie "jeux"
void initialisation2()
{
  menu();
  plateformes();
  joueur();
  graviterebond();
  retour();
  mouvement();

  //affichage du score en haut a gauche
  textSize(50);
  text(score, 0, 50);
}
/* --------------------------------------------------------------- */

/*---------------Mouvement du Joueur------------ */

//Mouvement gauche droite
void mouvement()
{
  if (gauche!=false) 
  {
    deplacement+=deplacementgauche;
  }

  if (droite!=false)
  {
    deplacement+=deplacementdroite;
  }
}

//retour de gauche à droite et de droite à gauche
void retour()
{
  if (deplacement<1)
  {
    deplacement=width;
  }

  if (deplacement>width)
  {
    deplacement=1;
  }
}

//rebond sur platforme
void graviterebond ()
{
  //cela peut dépendre du personnage, les images ne sont pas toute de la même grandeur
  if (choix==1)
  {
    gravitespeciale=gravite+60;
  }
  if (choix==2)
  {
    gravitespeciale=gravite+60;
  }
  if (choix==3)
  {
    gravitespeciale=gravite+85;
  }
  if (choix==4)
  {
    gravitespeciale=gravite+75;
  }

  color colli = get(deplacement, gravitespeciale); //colli prend les valeurs de la position du joueur
  if (colli==#000000) //donc quand colli se trouve à la même postion que du noir 
  {
    gravitetf=true; //gravité en true
    score+=1; //incrément du score à +1
    //joue un son à chaque rebond
    minim = new Minim(this);
    jump= minim.loadFile("jump.wav");
    jump.play();
  }

  if (gravitetf!=false) //quand la gravité est "true"
  {
    gravite-=rebond; //rebond
    statut++; //1 pixel= +1

    //on change d'image, personnage en mode "saut"
    if (keysrealesed==true)
    {
      if (choix==2)
      {
        taille=height/12.8;
        pikachu = loadImage("pikasaut.png");
      }
      if (choix==1)
      {
        taille=height/12.8;
        pikachu = loadImage("pichusaut.png");
      }
      if (choix==3)
      {
        taille=height/12.8;
        pikachu = loadImage("lucasaute.png");
      }
      if (choix==4)
      {
        taille=height/12.8;
        pikachu = loadImage("raichusaute.png");
      }
    }

    //quand statut dépasse Xvelmax (dans les variables)
    if (statut>Xvelmax)
    {  
      gravitetf=false; //gravité se met "false"
      //rechangement, le personnage ce met en "normal"
      if (choix==2)
      {
        taille=height/17.06;
        pikachu = loadImage("pika4.png");
      }
      if (choix==1)
      {
        taille=height/17.06;
        pikachu = loadImage("pichu.png");
      }
      if (choix==3)
      {
        taille=height/11.06;
        pikachu = loadImage("luca.png");
      }
      if (choix==4)
      {
        taille=height/11.06;
        pikachu = loadImage("raichu.png");
      }
      statut=0; //statut reprend la valeur initiale
    }
  }
  if (gravitetf!=true) //la gravité reprend le dessus
  {
    gravite+=gravity;
  }
}

/*------------------------------------------------------------- */
/*-----------------------Joueur-------------------------- */
void joueur()
{ 
  //apparition du personnage
  image(pikachu, deplacement, gravite, taille, taille);
  Perdu();
}

/*void highscore()
 {
 if (flag==2)
 {
 String scores [] = loadStrings("data.txt");
 int hightscore = new int[scores];
 hightscore[1] = scores;
 textSize(30);
 text(scores,width/2, height/2);
 }
 }*/
/*------------------------------------------------------------- */

/*-------------création des platformes---------------*/
void bouge() //la plateforme qui bouge
{
  xa+=5;
  if (xa>width-200)
    xa=-1;
  if (xa<1)
    xa+=5;
}

void plateformes()
{
  //initialisation de toutes les plateformes 
  stroke(0);
  fill(0);
  rect(height-150, y, width/6.4, height/146.2);
  rect(height-200, y1, width/6.4, height/146.2);
  rect(height-300, y2, width/6.4, height/146.2);
  rect(height-450, y3, width/6.4, height/146.2);
  rect(height-600, y4, width/6.4, height/146.2);
  rect(xa, ya, width/6.4, height/146.2); //celle qui bouge
  rect(height-700, y5, width/6.4, height/146.2);
  rect(height-800, y6, width/6.4, height/146.2);
  rect(height-900, y7, width/6.4, height/146.2);

  bouge(); //et celles qui bougent

  if (gravite>height/2-600 && gravitetf!=false) //a chaque rebond du personnage les plateformes descendent 
  {
    y+=5;  
    y1+=5;
    y2+=5;
    y3+=5;
    y4+=5; 
    ya+=5;
    y5+=5;
    y6+=5;
    y7+=5;
  }

  //Plateformes infinies et aléatoires

  if (y>height) //si la plateforme dépasse le bas 
  {
    y=random(10, height-random(10, height-100)); //elle remonte automatiquement et aléatoirement
  }

  if (y1>height)
  {
    y1=random(10, height-random(10, height-100));
  }

  if (y2>height)
  {
    y2=random(10, height-random(10, height-100));
  }

  if (y3>height)
  {
    y3=random(10, height-random(10, height-100));
  }

  if (y4>height)
  {
    y4=random(10, height-random(10, height-100));
  } 
  if (ya>height)
  {
    ya=random(10, height-random(10, height-100));
  } 
  if (y5>height)
  {
    y5=random(10, height-random(10, height-100));
  } 

  if (y6>height)
  {
    y6=random(10, height-random(10, height-100));
  } 

  if (y7>height)
  {
    y7=random(10, height-random(10, height-100));
  }
}
/*------------------------------------------------------------- */
/*-----------------------DRAW-----------------------*/
//Assemble le tout
void draw ()
{
  background(#D8B70F); //fond de couleur jaune
  menu(); //menu
  if (flag==1) //si le choix est jouer, initialise le jeux
  {  
    initialisation2();
  }
}
/*------------------------------------------------------------- */
/*--------------------Perdu------------------------ */
void Perdu()
{
  if (gravite>height/2+350)
  {
    gravite+=50; //Disparition subite du joueur
    flag=3;
    initialisation ();
    if (choix==2)
    {
      minim = new Minim(this);
      pikachu2= minim.loadFile("pikachu2.mp3");
      pikachu2.play();
      initialisation ();
    }
    if (choix==1)
    {
      minim = new Minim(this);
      pikachu2= minim.loadFile("pichu3.mp3");
      pikachu2.play();
      initialisation ();
    }
    if (choix==4)
    {
      minim = new Minim(this);
      pikachu2= minim.loadFile("raichu3.mp3");
      pikachu2.play();
      initialisation ();
    }
    if (choix==3)
    {
      minim = new Minim(this);
      pikachu2= minim.loadFile("luca3.mp3");
      pikachu2.play();
      initialisation ();
    }
    //   String str = Integer.toString(score);
    //    String[] data = new String[1];
    //    data[1]= str;
    //    saveStrings("data/data.txt", data);
  }
}

/*--------------------------------------------------------------------*/
/*---------------------------Menu---------------------------------------*/
void page1()
{
  //page 1 des choix du personnage
  choix1clique = loadImage("Choixpichuclique.png");
  choix2clique = loadImage("Choixpikaclique.png");

  if (page==1)
  {
    choix1 = loadImage("Choixpichu.png"); 
    image (choix1, width/12.8, height/2.048, width/2.37, height/2.92);

    choix2 = loadImage("Choixpika.png"); 
    image (choix2, width/1.97, height/2.048, width/2.37, height/2.92);

    color colli = get(mouseX, mouseY);
    if (colli==#e9cd46  && mouseX>width/2) { //pikachu
      image(choix2clique, width/1.97, height/2.048, width/2.37, height/2.92);
      if (mouseButton == LEFT) {
        choix=2;
        choixp = loadImage("Choixpika2.png"); 
        image (choixp, width/3.28, height/3.28, 500, 250);
      }
    }

    if (colli==#e2d753  && mouseX<width/2) { //pichu
      image(choix1clique, width/12.8, height/2.048, width/2.37, height/2.92);
      if (mouseButton == LEFT) {
        choix=1;
        choixp = loadImage("Choixpichu2.png"); 
        image (choixp, width/3.28, height/3.28, 500, 250);
      }
    }
  }
}
void page2()
{
  //page 2 du choix des personnages
  choix3clique = loadImage("Choixlucaclique.png");
  choix4clique = loadImage("Choixraichuclique.png");
  if (page==2)
  {

    choix3 = loadImage("Choixluca.png"); 
    image (choix3, width/12.8, height/2.048, width/2.37, height/2.92);

    choix4 = loadImage("Choixraichu.png"); 
    image (choix4, width/1.97, height/2.048, width/2.37, height/2.92);

    color colli2 = get(mouseX, mouseY); 
    if (colli2==#c4daec  && mouseX<width/2) { //lucario
      image(choix3clique, width/12.8, height/2.048, width/2.37, height/2.92);
      if (mouseButton == LEFT) {
        choix=3;
        choixp = loadImage("Choixlucario2.png"); 
        image (choixp, width/3.28, height/3.28, 500, 250);
      }
    }

    if (colli2==#ec985a  && mouseX>width/2) { //raichu
      image(choix4clique, width/1.97, height/2.048, width/2.37, height/2.92);
      if (mouseButton == LEFT) {
        choix=4;
        choixp = loadImage("Choixraichu2.png"); 
        image (choixp, width/3.28, height/3.28, 500, 250);
      }
    }
  }
} 

void page()
{ 
  //flèche droite et flèche gauche du menu de choix des personnages
  PImage flechedroite; //droite
  flechedroite = loadImage("flechedroite.png"); 
  image (flechedroite, width/1.10, height/1.63, width/12.8, height/10.24);
  PImage flechedroiteclique; //changement de couleur
  flechedroiteclique = loadImage("flechedroiteclique.png"); 

  textSize(25);
  fill(0);
  text("CHOISIS TON PERSONNAGE !", width/2-150, height/2); //texte juste au dessus des têtes des perso

  color colli3 = get(mouseX, mouseY); 
  if (colli3==#917662 && mouseX>width/2) { 
    image (flechedroiteclique, width/1.10, height/1.63, width/12.8, height/10.24);
    if (mouseButton == LEFT)
    { 
      page=2;
    }
  }

  PImage flechegauche; //gauche
  flechegauche = loadImage("flechegauche.png");
  image (flechegauche, width/42.66, height/1.63, width/12.8, height/10.24);
  PImage flechegaucheclique; //changement de couleur
  flechegaucheclique = loadImage("flechegaucheclique.png");
  color colli4 = get(mouseX, mouseY); 
  if (colli4==#856852 && mouseX<width/2) { 
    image (flechegaucheclique, width/42.66, height/1.63, width/12.8, height/10.24);
    if (mouseButton == LEFT) 
    {
      page=1;
    }
  }
}


void menu ()
{
  if (flag==0)
  { 
    page();
    page1();
    page2();

    PImage playB; // Image du bouton pour jouer
    playB = loadImage("boutonPlayBleu.png"); // Bleu car la souris n'est pas dessus
    image (playB, width/12.8, height/25.6, width/2.37, height/2.92);

    PImage reglesB; // Image du bouton pour accéder aux règles
    reglesB = loadImage("BoutonRèglesBleu.png"); // Bleu car la souris n'est pas dessus
    image (reglesB, width/1.97, height/25.6, width/2.37, height/2.92);

    PImage playR;
    playR = loadImage("boutonPlayRouge.png"); // Rouge car la souris est dessus

    PImage reglesR;
    reglesR = loadImage("BoutonRèglesRouge.png"); // Rouge car la souris est dessus

    color colli = get(mouseX, mouseY);
    if (colli==#35799e && mouseX<width/2) {
      image(playR, width/12.8, height/25.6, width/2.37, height/2.92);
      if (mouseButton == LEFT) {
        flag=1;
        if (choix==2)
        {
          minim = new Minim(this);
          pikachu1= minim.loadFile("pikachu1.mp3");
          pikachu1.play();
        }
        if (choix==1)
        {
          minim = new Minim(this);
          pikachu1= minim.loadFile("pichu1.mp3");
          pikachu1.play();
        }
        if (choix==4)
        {
          minim = new Minim(this);
          pikachu1= minim.loadFile("raichu.mp3");
          pikachu1.play();
        }
        if (choix==3)
        {
          minim = new Minim(this);
          pikachu1= minim.loadFile("luca.mp3");
          pikachu1.play();
        }
      }
    }

    if (colli==#35799e  && mouseX>width/2) {
      image(reglesR, width/1.97, height/25.6, width/2.37, height/2.92);
      if (mouseButton == LEFT) {
        flag=2;
        if (choix==2)
        {
          minim = new Minim(this);
          pikachu3= minim.loadFile("pikachu3.mp3");
          pikachu3.play();
        }
        if (choix==1)
        {
          minim = new Minim(this);
          pikachu3= minim.loadFile("pichu2.mp3");
          pikachu3.play();
        }
        if (choix==4)
        {
          minim = new Minim(this);
          pikachu1= minim.loadFile("raichu2.mp3");
          pikachu1.play();
        }
        if (choix==3)
        {
          minim = new Minim(this);
          pikachu1= minim.loadFile("luca.mp3");
          pikachu1.play();
        }
      }
    }
  }
  if (flag==2)
  {
    regles();
  }

  if (flag==3)
  {
    textSize(50);
    fill(0);
    text("Ton score est de "+score+" points ! Bravo ! Tu rejoues ?", width/2-575, height/2+250); //affichage du score à la fin
    PImage RetourA; 
    RetourA = loadImage("RetourBleu.png"); 
    image (RetourA, width/12.8, height/4.096, width/2.37, height/2.92);

    PImage RetourB; 
    RetourB = loadImage("RetourRouge.png"); 

    PImage RejouerA;
    RejouerA = loadImage("RejouerBleu.png"); 
    image (RejouerA, width/1.97, height/4.096, width/2.37, height/2.92);

    PImage RejouerB;
    RejouerB = loadImage("RejouerRouge.png"); 

    color colli = get(mouseX, mouseY);
    if (colli==#35799e && mouseX<width/2) {
      image(RetourB, width/12.8, height/4.096, width/2.37, height/2.92);
      if (mouseButton == LEFT) {
        flag=0;
        score=0;
      }
    }

    if (colli==#1d688f  && mouseX>width/2) {
      image(RejouerB, width/1.97, height/4.096, width/2.37, height/2.92);
      if (mouseButton == LEFT)
      {
        flag=1;
        score = 0;
        if (choix==2)
        {
          minim = new Minim(this);
          pikachu1= minim.loadFile("pikachu1.mp3");
          pikachu1.play();
        }
        if (choix==1)
        {
          minim = new Minim(this);
          pikachu1= minim.loadFile("pichu1.mp3");
          pikachu1.play();
        }
        if (choix==4)
        {
          minim = new Minim(this);
          pikachu1= minim.loadFile("raichu.mp3");
          pikachu1.play();
        }
        if (choix==3)
        {
          minim = new Minim(this);
          pikachu1= minim.loadFile("luca.mp3");
          pikachu1.play();
        }
      }
    }
  }
}
/*----------------------Affichage des règles----------------------------*/
void regles ()
{
  if (flag==2)
  {
    PImage ImageRegles;
    ImageRegles = loadImage("Image avec Règles.png");
    image (ImageRegles, 0, -150, width-80, height-20);

    PImage RetourA; 
    RetourA = loadImage("RetourBleu.png"); 
    image (RetourA, width/3.66, height/1.6, width/2.61, height/3.10);

    PImage RetourB; 
    RetourB = loadImage("RetourRouge.png");

    color colli = get(mouseX, mouseY);
    if (colli==#35799e && mouseX<width/2) {
      image(RetourB, width/3.66, height/1.6, width/2.61, height/3.10);
      if (mouseButton == LEFT) {
        flag=0;
      }
    }
  }
}
/*-------------------------------------------------------------------*/
/*----------------------ACTION DU JOUEUR----------------------------*/
void keyPressed()
{ 
  if (key == CODED) {
    if (keyCode == LEFT) {
      gauche = true;
      if (choix==2)
      {
        pikachu = loadImage("pikasautgauche.png");
      }
      if (choix==1)
      {
        pikachu = loadImage("pichusautgauche.png");
      }
      if (choix==3)
      {
        pikachu = loadImage("lucasautgauche.png");
      }
      if (choix==4)
      {
        taille=height/11.06;
        pikachu = loadImage("raichusautegauche.png");
      }
      keysrealesed= false;
    }
  }

  if (key == CODED) {
    if (keyCode == RIGHT) {
      droite = true;
      if (choix==2)
      {
        pikachu = loadImage("pikasautdroit.png");
      }
      if (choix==1)
      {
        pikachu = loadImage("pichusautdroit.png");
      }
      if (choix==3)
      {
        pikachu = loadImage("lucasautdroit.png");
      }
      if (choix==4)
      {
        taille=height/11.06;
        pikachu = loadImage("raichusautedroit.png");
      }
      keysrealesed= false;
    }
  }
  if (key == CODED) {
    if (keyCode == DOWN) {
      if (choix==3)
      {
        taille=height/11.06;
        pikachu = loadImage("lucatransfo.png");
      }
    }
  }
}

void keyReleased()
{ 
  if (key == CODED) {
    if (keyCode == LEFT) {
      gauche = false;
      keysrealesed= true;
    }
  }

  if (key == CODED) {
    if (keyCode == RIGHT) {
      droite = false;
      keysrealesed= true;
    }
  }
}
/*-------------------------------------------------------*/
