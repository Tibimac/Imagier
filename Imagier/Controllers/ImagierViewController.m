//
//  ImagierViewController.m
//  Imagier
//
//  Created by Thibault Le Cornec on 25/05/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "ImagierViewController.h"
#import "ImagierView.h"
#import "Image.h"

@implementation ImagierViewController
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* ========================================================= INIT FRAME ========================================================= */
//  On "construit" la vue en appelant sa méthode initWithFrame:
    imagierView = [[ImagierView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [imagierView setController:self];               // On indique à la vue qu'on va la controler.
    [[imagierView scrollView] setDelegate:self];    // On indique à la vue que c'est nous qui gérons le protocol de délégation
//  On ajoute la vue construite à notre controller en liant la vue à la propritété (UIView *)view de UIViewController.
//  On lui indique ainsi quelle vue il controle.
//  addSubview fait un retain sur l'objet référencé (imagierView ici), donc release après.
//  Le propriétaire ne sera donc plus le controler (ImagierViewController ici) directement mais l'objet (UIView *)view du controller.
    [[self view] addSubview:imagierView];
    [imagierView release];
    /* ============================================================================================================================== */
    
    
    /* ================================================== CREATION TABLEAU IMAGES =================================================== */
    #pragma mark Creation Images Array with Paths
    // URL du dossier des images
//    NSError *err;
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    NSURL *imagesURL = [NSURL URLWithString:@"Images" relativeToURL:bundleURL];
    
    // Liste le contenu du répertoire des images à l'URL imagesURL et récupère le chemin de chaque fichier
    // NSDirectoryEnumerationSkipsHiddenFiles permet de ne pas lister les fichiers invisibles
    NSArray *allImagesURL = [[NSArray alloc] initWithArray:[[NSFileManager defaultManager]
                                                            contentsOfDirectoryAtURL:imagesURL
                                                          includingPropertiesForKeys:nil
                                                                             options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                               error:nil]];
    
//    if(err)
//    {
//        NSLog(@"Erreur : %@", err); // Génère une erreur l'execution ... 
//        [err release];
//    }
//    else // Le listing du répertoire a réussi
//    {
        allImages = [[NSMutableArray alloc] init];
        NSMutableArray *imagesWithNameandScales = [[NSMutableArray alloc] init]; // Tableau pour stocker les objets "Image"
        
        for (int i = 0; i < [allImagesURL count]; i++) // Parcours du tableau allImagesURL pour récupérer les noms de fichier
        {
            // Création d'un objet "Image" avec le nom d'une image et ses scales par défaut
            Image *image = [[Image alloc] initWithName:[[allImagesURL objectAtIndex:i] lastPathComponent] andScaleWidth:0.25 andScaleHeight:0.25];
            [imagesWithNameandScales addObject:image]; // addObject fait un retain sur l'objet
            
            [image release];
        }

        #pragma mark Define Stepper Maximum Value
        //  On défini la valeur maximale du stepper en fonction du nombre d'images chargées
        [[imagierView stepper] setMaximumValue:[allImagesURL count]-1];
        [allImages addObject:imagesWithNameandScales];
        [allImages addObject:allImagesURL];

    
        // Ajout d'un observateur pour être averti lorsque la statusBar change de taille
        NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
        [notifCenter addObserver:self selector:@selector(statusBarDidChange) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    
        [imagesWithNameandScales release];
        [allImagesURL release];
//    }
    /* ============================================================================================================================= */
    
    [self changeImage];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
///FIXME: Realease & Dealloc ou pas ?
//    [allImages release];
//    [allImages dealloc];
//    allImages = nil;
    [super dealloc];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Update UI Methods

-(void)statusBarDidChange
{
    [imagierView setViewFromOrientation:[[UIApplication sharedApplication] statusBarOrientation] withStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
}



- (void)updateUIWithScaleWidth:(CGFloat)scaleW
                andScaleHeight:(CGFloat)scaleH
{
    // Enregistre les nouvelles valeur dans l'objet Image
    [[[allImages objectAtIndex:0] objectAtIndex:numOfCurrentImage] setScaleWidth:scaleW];
    [[[allImages objectAtIndex:0] objectAtIndex:numOfCurrentImage] setScaleHeight:scaleH];
    
    // Mise à jour des slider
    [[imagierView scaleWidthSlider] setValue:(scaleW*100) animated:YES];
    [[imagierView scaleHeightSlider] setValue:(scaleH*100) animated:YES];

    // Mise à jour des labels affichant la valeur de zoom
    int scaleValueWToLabel = [[NSNumber numberWithFloat:(scaleW*100)] intValue]; // Obligé de passer par NSNumber pour avoir "1%" car
    int scaleValueHToLabel = [[NSNumber numberWithFloat:(scaleH*100)] intValue]; // (int)(scaleH*100) = 0.9 et non 1 bien que scaleH = 0.010000 !!!
    [[imagierView scaleWidthValueLabel] setText:[NSString stringWithFormat:@"%d%@",scaleValueWToLabel, @"%"]];
    [[imagierView scaleHeightValueLabel] setText:[NSString stringWithFormat:@"%d%@",scaleValueHToLabel, @"%"]];
    
    // Mise à jour de la zone d'affichage de l'image (UIImageView)
    [[imagierView currentImage] setFrame:CGRectMake(0, 0, [[[imagierView currentImage] image] size].width*scaleW, [[[imagierView currentImage] image] size].height*scaleH)];
    // Mise à jour de la scrollView
    [[imagierView scrollView] setContentSize:[imagierView currentImage].frame.size];
}



#pragma mark -
#pragma mark Actions Methods
- (void)changeImage
{
    if (allImages == nil)
    {
        [self viewDidLoad];
    }
    numOfCurrentImage = (int)[[imagierView stepper] value];                                                 // Récupère valeur stepper
    Image *imageObject = [[allImages objectAtIndex:0] objectAtIndex:numOfCurrentImage];                     // Récupère l'objet Image
    NSURL *fileURL = [[allImages objectAtIndex:1] objectAtIndex:numOfCurrentImage];                         // Récupère le chemin vers le fichier
    NSString *fileName = [NSString stringWithString:[[imageObject name] stringByDeletingPathExtension]];    // Récupère le nom de l'image dans l'objet Image
    CGFloat imageScaleW = [imageObject scaleWidth];                                                         // Récupère valeur échelle largeur dans l'objet Image (valeur entre 0 et 1)
    CGFloat imageScaleH = [imageObject scaleHeight];                                                        // Récupère valeur échelle hauteur dans l'objet Image (valeur entre 0 et 1)
    
    [[imagierView imageNameLabel] setText:fileName];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:fileURL]];                 // Récupère l'image à l'endroit indiqué
    [[imagierView currentImage] setImage:image];                                                            // Affecte l'image (UIImage) à la UIImageView
    
    [image release];

    [self updateUIWithScaleWidth:imageScaleW andScaleHeight:imageScaleH];
}



- (void)sliderChangeScale
{
    // Récupère valeurs des slider (Valeur entre 1 et 100)
    CGFloat scaleSliderW = ([[imagierView scaleWidthSlider] value]/100);
    CGFloat scaleSliderH = ([[imagierView scaleHeightSlider] value]/100);
    
    [self updateUIWithScaleWidth:scaleSliderW andScaleHeight:scaleSliderH];
}



#pragma mark -
#pragma mark Delegate for UIScrollView
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [imagierView currentImage];
}



- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(UIView *)view
                        atScale:(CGFloat)scale
{
    [self updateUIWithScaleWidth:scale andScaleHeight:scale];
}



#pragma mark -
#pragma mark Delegate for Rotation
- (BOOL)shouldAutoRotate // La vue DOIT (should) pivoter automatiquement lorsque le iDevices pivote
{
    return YES;
}



/* Donc implémentation de la méthode willRotateToInterfaceOrientation:duration: dans notre UIViewController qui appel la méthode setViewFromOrientation: de la vue, puis la vue s'occupe de se "dessiner" en fonction de l'orientation qu'on lui envoi */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [imagierView setViewFromOrientation:[[UIApplication sharedApplication] statusBarOrientation] withStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
}

@end