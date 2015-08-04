//
//  ImagierView.m
//  Imagier
//
//  Created by Thibault Le Cornec on 25/05/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "Image.h"
#import "ImagierView.h"
#import "ImagierViewController.h"

@implementation ImagierView
#pragma mark -

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        /* ============================================= INITIALISATION OBJETS / VUE ============================================= */
        
        /* -------------------- Background Image -------------------- */
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
//            iPhone (écran 3.5" (Retina car iOS 7 n'existe pas terminal 3.5" non Retina) ou 4" (Retina))
            isiPhone = YES;
//            backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background-1136x1136.jpg"]];
        }
        else
        {
            // iPad (écran 7,9" (Retina ou non) ou 9,7" (Retina ou non))
            isiPhone = NO;
           
//            CGFloat screenScale = [[UIScreen mainScreen] scale];
//            if (screenScale == 1.0)
//            {
//                backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background-1024x1024.jpg"]];
//            }
//            else if (screenScale == 2.0)
//            {
//                backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background-2048x2048.jpg"]];
//            }
            
        }
//!     A ajouter en 1er car c'est le fond ! Les éléments étant ajoutés les uns au dessus des autres.
//        [self addSubview:backgroundImage];
        
        
        /* ------------------------------------------------------- Stepper ------------------------------------------------------- */
        // La valeur maximale sera définie par le controleur en fonction du nombre d'images chargées
        _stepper = [[UIStepper alloc] init];
        [_stepper setMinimumValue:0.0];
        [_stepper setStepValue:1];
        [_stepper setValue:0.0];
        [_stepper setAutorepeat:NO];  // Nombre de clic = nombre de photos que l'on veut "passer"
        [_stepper setContinuous:YES]; // Valeur du stepper renvoyée dés que le clique est fini
        [_stepper setWraps:YES];      // Si la valeur du stepper dépasse sa valeur maxi il revient à sa valeur mini et inversement.
        [_stepper addTarget: _controller action:@selector(changeImage) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_stepper];
        
        
        /* -------------------------------------------------- Label Nom Image ---------------------------------------------------- */
        _imageNameLabel = [[UILabel alloc] init];
        // Alignement texte défini en fonction de la position, voir setViewFromOriention:
        [_imageNameLabel setTextColor:[UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:1]];
        [self addSubview:_imageNameLabel];
        
        
        /* ------------------------------------------------------ ScrollView ----------------------------------------------------- */
        // Le delegate de la scrollView sera défini par le controleur de la vue
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setMinimumZoomScale:0.01];
        [_scrollView setMaximumZoomScale:1.0];
        [_scrollView setScrollEnabled:YES];
        [self addSubview:_scrollView]; // Ajout de la scroolView à la vue
        
        
        /* ------------------------------------------------------ ImageView ------------------------------------------------------ */
        _currentImage = [[UIImageView alloc] init]; // Initialiation de la UIImageView dans laquelle le controller insérera l'image.
        [_scrollView addSubview:_currentImage];     // Ajout de la UIImageView dans la scrollView
        
    
        /* ------------------------------------------------ Label Echelle Largeur ------------------------------------------------ */
        scaleWidthLabel = [[UILabel alloc] init];
        [scaleWidthLabel setText:@"Largeur :"];
        [scaleWidthLabel setTextAlignment:NSTextAlignmentCenter];
        [scaleWidthLabel setTextColor:[UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:1]];
        [self addSubview:scaleWidthLabel];
        
        
        /* --------------------------------------------- Label Valeur Echelle Largeur -------------------------------------------- */
        _scaleWidthValueLabel = [[UILabel alloc] init];

        [_scaleWidthValueLabel setTextAlignment:NSTextAlignmentCenter];
        [_scaleWidthValueLabel setTextColor:[UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:1]];
        [self addSubview:_scaleWidthValueLabel];
        
        
        /* ---------------------------------------------------- Slider Largeur --------------------------------------------------- */
        _scaleWidthSlider = [[UISlider alloc] init];
        [_scaleWidthSlider setMinimumValue:1];
        [_scaleWidthSlider setMaximumValue:100];
        [_scaleWidthSlider addTarget:_controller action:@selector(sliderChangeScale) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_scaleWidthSlider];
        
        
        /* ------------------------------------------------ Label Echelle Hauteur ------------------------------------------------ */
        scaleHeightLabel = [[UILabel alloc] init];
        [scaleHeightLabel setText:@"Hauteur :"];
        [scaleHeightLabel setTextAlignment:NSTextAlignmentCenter];
        [scaleHeightLabel setTextColor:[UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:1]];
        [self addSubview:scaleHeightLabel];
        
        
        /* --------------------------------------------- Label Valeur Echelle Hauteur -------------------------------------------- */
        _scaleHeightValueLabel = [[UILabel alloc] init];
        [_scaleHeightValueLabel setTextAlignment:NSTextAlignmentCenter];
        [_scaleHeightValueLabel setTextColor:[UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:1]];
        [self addSubview:_scaleHeightValueLabel];
        
        
        /* ---------------------------------------------------- Slider Hauteur --------------------------------------------------- */
        _scaleHeightSlider = [[UISlider alloc] init];
        [_scaleHeightSlider setMinimumValue:1];
        [_scaleHeightSlider setMaximumValue:100];
        [_scaleHeightSlider addTarget:_controller action:@selector(sliderChangeScale) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_scaleHeightSlider];
    
        
        #pragma mark Parallax Effects
        /* =================================================== Effets Parallax =================================================== */
        // Effet parallaxe vertical
        UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        [verticalMotionEffect setMinimumRelativeValue:@(50)];
        [verticalMotionEffect setMaximumRelativeValue:@(-50)];
        
        // Effet parallaxe horizontal
        UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        [horizontalMotionEffect setMinimumRelativeValue:@(50)];
        [horizontalMotionEffect setMaximumRelativeValue:@(-50)];
        
        // Groupement des effets
        UIMotionEffectGroup *groupMotionEffects = [[UIMotionEffectGroup alloc] init];
        [groupMotionEffects setMotionEffects:[NSArray arrayWithObjects:verticalMotionEffect, horizontalMotionEffect, nil]];
        
        // Ajout des effets sur l'image
//        [_currentImage addMotionEffect:groupMotionEffects];
        /* ======================================================================================================================= */
        
        
        // Positionnement des objets dans la vue en fonction de l'orientation actuelle passée en paramètre
        [self setViewFromOrientation:[[UIApplication sharedApplication] statusBarOrientation]
                  withStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
        /* ======================================================================================================================= */
        
        
        /* ============================ RELEASE ============================ */
        // Abandon de la propriété des objets créés
        [_stepper release];                 [_imageNameLabel release];
        [_scrollView release];              [_currentImage release];
        [scaleWidthLabel release];          [_scaleWidthSlider release];
        [_scaleWidthValueLabel release];    [scaleHeightLabel release];
        [_scaleHeightSlider release];       [_scaleHeightValueLabel release];
        [verticalMotionEffect release];     [horizontalMotionEffect release];
        [groupMotionEffects release];
        /* ================================================================= */
        
        return self;
    }
    else
    {
        return nil;
    }
}


#pragma mark -
#pragma mark Draw Methods
- (void)setViewFromOrientation:(UIInterfaceOrientation)orientation withStatusBarFrame:(CGRect)statusBarFrame
{
    #pragma mark Debug UI Position
    /* ============================================================ DEBUG ============================================================ */
//    [_stepper setBackgroundColor:[UIColor yellowColor]];
//    [_imageNameLabel setBackgroundColor:[UIColor yellowColor]];         [_scrollView setBackgroundColor:[UIColor yellowColor]];
//    [scaleWidthLabel setBackgroundColor:[UIColor yellowColor]];         [_scaleWidthSlider setBackgroundColor:[UIColor yellowColor]];
//    [_scaleWidthValueLabel setBackgroundColor:[UIColor yellowColor]];   [scaleHeightLabel setBackgroundColor:[UIColor yellowColor]];
//    [_scaleHeightSlider setBackgroundColor:[UIColor yellowColor]];      [_scaleHeightValueLabel setBackgroundColor:[UIColor yellowColor]];
    /* ================================================================================================================================ */
    
    
    #pragma mark Positioning Objects
    
    /* ----------------- INFO ----------------- *\
    |  CGRectMake(pos.X, pos.Y, width, height);  |
    \* ---------------------------------------- */
    
    #define MARGE_X 10
    #define MARGE_Y 25
    #define MARGE_BAS 95
    CGFloat MARGE_STATUSBAR = 0.0;
    
    if (statusBarFrame.size.height > 20) { MARGE_STATUSBAR = statusBarFrame.size.height-20; }
    
    /* ========== Définition de la hauteur et largeur de la vue principale en fonction de l'orientation du iDevice ========== */
    if(UIInterfaceOrientationIsPortrait(orientation))
    {
        [self setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-MARGE_STATUSBAR)];
    }
    else if (UIInterfaceOrientationIsLandscape(orientation))
    {
        [self setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)];
    }
    
    
    /* ========== iPhone (Portrait) ========== */
    if (isiPhone && UIInterfaceOrientationIsPortrait(orientation))
    {
        [_scaleWidthSlider setTransform:CGAffineTransformMakeRotation(0)];
        [_scaleHeightSlider setTransform:CGAffineTransformMakeRotation(0)];
        
        [_imageNameLabel setFrame:CGRectMake([self bounds].size.width-(MARGE_X+200), MARGE_Y, 200, 29)]; // A droite
        [_imageNameLabel setTextAlignment:NSTextAlignmentRight];
        
        [_stepper setFrame: CGRectMake(MARGE_X, MARGE_Y, 100, 29)];
        // 29+10 = 10pt en dessous du stepper | 150 = hauteurs sliders + label slider + espaces |
        [_scrollView setFrame:      CGRectMake(0, MARGE_Y+29+10, [self bounds].size.width, [self bounds].size.height-(MARGE_BAS+MARGE_Y+29+10))];
        
        [scaleWidthLabel setText:@"Largeur :"];
        // 100 = espace pris par les éléments en dessous + espaces
        [scaleWidthLabel        setFrame:CGRectMake(MARGE_X                              , [self bounds].size.height-85, 71                                                  , 35)];
        // 71 = largeur label gauche | 50 = largeur label droite | 5 = espace entre slider et les labels
        [_scaleWidthSlider      setFrame:CGRectMake(MARGE_X+71+5                         , [self bounds].size.height-85, [self bounds].size.width-(MARGE_X+71+5+5+50+MARGE_X), 35)];
        [_scaleWidthValueLabel  setFrame:CGRectMake([self bounds].size.width-(MARGE_X+50), [self bounds].size.height-85, 50                                                  , 35)];
        
        [scaleHeightLabel setText:@"Hauteur :"];
        // 55 = espace pris par les éléments en dessous + espaces
        [scaleHeightLabel       setFrame:CGRectMake(MARGE_X                              , [self bounds].size.height-45, 71                                                  , 35)];
        // 71 = largeur label gauche | 50 = largeur label droite | 5 = espace entre slider et les labels
        [_scaleHeightSlider     setFrame:CGRectMake(MARGE_X+71+5                         , [self bounds].size.height-45, [self bounds].size.width-(MARGE_X+71+5+5+50+MARGE_X), 35)];
        [_scaleHeightValueLabel setFrame:CGRectMake([self bounds].size.width-(MARGE_X+50), [self bounds].size.height-45, 50                                                  , 35)];
    }
    /* ========== iPhone (Paysage) ========== */
    if ((isiPhone && UIInterfaceOrientationIsLandscape(orientation)))
    {
        CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 1.5);
        _scaleWidthSlider.transform = trans;
        _scaleHeightSlider.transform = trans;
        
        [scaleWidthLabel setText:@"Largeur"];
        // 100 = espace pris par les éléments en dessous + espaces
        [scaleWidthLabel        setFrame:CGRectMake(MARGE_X                              , MARGE_Y                          , 70                                                , 29)];
        // 71 = largeur label gauche | 50 = largeur label droite | 5 = espace entre slider et les labels
        [_scaleWidthSlider      setFrame:CGRectMake(MARGE_X+20                           , MARGE_Y+29+10                    , 35, [self bounds].size.height-(MARGE_Y+29+10+10+25+10))];
        [_scaleWidthValueLabel  setFrame:CGRectMake(MARGE_X+10                           , [self bounds].size.height-(10+25), 50                                                , 25)];
        
        [scaleHeightLabel setText:@"Hauteur"];
        // 55 = espace pris par les éléments en dessous + espaces
        [scaleHeightLabel       setFrame:CGRectMake(MARGE_X+10+70                        , MARGE_Y                          , 70                                                , 29)];
        // 71 = largeur label gauche | 50 = largeur label droite | 5 = espace entre slider et les labels
        [_scaleHeightSlider     setFrame:CGRectMake(MARGE_X+20+35+10+35                  , MARGE_Y+29+10                    , 35, [self bounds].size.height-(MARGE_Y+29+10+10+25+10))];
        [_scaleHeightValueLabel setFrame:CGRectMake(MARGE_X+10+50+10+20                  , [self bounds].size.height-(10+25), 50                                                , 25)];
        
        [_stepper setFrame: CGRectMake(MARGE_X+70+10+70+10, MARGE_Y, 100, 29)];
        
        [_imageNameLabel setFrame:CGRectMake([self bounds].size.width-(MARGE_X+70+10+70+10+100+MARGE_X+MARGE_X), MARGE_Y, ([self bounds].size.width)-(MARGE_X+70+10+70+10+100+MARGE_X+MARGE_X), 29)]; // A droite
        [_imageNameLabel setTextAlignment:NSTextAlignmentCenter];
        
        // 29+10 = 10pt en dessous du stepper | 150 = hauteurs sliders + label slider + espaces |
        [_scrollView setFrame:      CGRectMake(MARGE_X+70+10+70+10, MARGE_Y+29+10, ([self bounds].size.width)-(MARGE_X+70+10+70+10+MARGE_X), [self bounds].size.height-(MARGE_Y+29+10+10))];
    }
    
    if (!isiPhone)
    {
        /* ========== iPad (Portrait ou Paysage) ========== */
        [_imageNameLabel setFrame:CGRectMake(([self bounds].size.width-350)/2, MARGE_Y, 350, 29)]; // Au milieu
        [_imageNameLabel setTextAlignment:NSTextAlignmentCenter];
        
        [_stepper setFrame: CGRectMake(MARGE_X, MARGE_Y, 100, 29)];
        // 29+10 = 10pt en dessous du stepper | 150 = hauteurs sliders + label slider + espaces |
        [_scrollView setFrame:      CGRectMake(0, MARGE_Y+29+10, [self bounds].size.width, [self bounds].size.height-(MARGE_BAS+MARGE_Y+29+10))];
        
        // 100 = espace pris par les éléments en dessous + espaces
        [scaleWidthLabel        setFrame:CGRectMake(MARGE_X                              , [self bounds].size.height-85, 71                                                  , 35)];
        // 71 = largeur label gauche | 50 = largeur label droite | 5 = espace entre slider et les labels
        [_scaleWidthSlider      setFrame:CGRectMake(MARGE_X+71+5                         , [self bounds].size.height-85, [self bounds].size.width-(MARGE_X+71+5+5+50+MARGE_X), 35)];
        [_scaleWidthValueLabel  setFrame:CGRectMake([self bounds].size.width-(MARGE_X+50), [self bounds].size.height-85, 50                                                  , 35)];
        
        // 55 = espace pris par les éléments en dessous + espaces
        [scaleHeightLabel       setFrame:CGRectMake(MARGE_X                              , [self bounds].size.height-45, 71                                                  , 35)];
        // 71 = largeur label gauche | 50 = largeur label droite | 5 = espace entre slider et les labels
        [_scaleHeightSlider     setFrame:CGRectMake(MARGE_X+71+5                         , [self bounds].size.height-45, [self bounds].size.width-(MARGE_X+71+5+5+50+MARGE_X), 35)];
        [_scaleHeightValueLabel setFrame:CGRectMake([self bounds].size.width-(MARGE_X+50), [self bounds].size.height-45, 50                                                  , 35)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
@end