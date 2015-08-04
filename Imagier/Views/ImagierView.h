//
//  ImagierView.h
//  Imagier
//
//  Created by Thibault Le Cornec on 25/05/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImagierViewController;

@interface ImagierView : UIView
{
    #pragma mark Private Objects
//  Objets privées
    UILabel *scaleWidthLabel;   // Label "Largeur : "
    UILabel *scaleHeightLabel;  // Label "Hauteur : "

//  Enregistre, lors de l'initialisation de la vue, si l'appli s'execute sur un iPhone ou un iPad.
//  Permet par la suite de définir l'affichage et le placement des éléments de la vue en fonction du iDevice.
    BOOL isiPhone;
}
#pragma mark -
#pragma mark Properties
// Objets devant être accessiblent par le controleur
@property (readonly, copy) UIStepper        *stepper;               // Stepper pour passer d'une image à l'autre
@property (readonly, copy) UILabel          *imageNameLabel;        // Nom de la photo
@property (readonly, copy) UIScrollView     *scrollView;            // ScrollView pour afficher, zoomer et scroller sur l'image
@property (readonly, copy) UIImageView      *currentImage;          // Zone d'affichage de l'image
@property (readonly, copy) UILabel          *scaleWidthValueLabel;  // Valeur du scale largeur actuel
@property (readonly, copy) UILabel          *scaleHeightValueLabel; // Valeur du scale heuteur actuel
@property (readonly, copy) UISlider         *scaleWidthSlider;      // Slider pour modifier la largeur de l'image
@property (readonly, copy) UISlider         *scaleHeightSlider;     // Slider pour modifier la hauteur de l'image

// Controleur de la vue.
// Les évènements sur la vue seront reçus par le controleur.
@property (readwrite, retain) UIViewController <UIScrollViewDelegate> *controller;

#pragma mark -
#pragma mark Public Methods
//  setViewFromOrientation: gère le positionnement de l'ensemble des objets de la vue
//  en fonction de l'orientation ((UIInterfaceOrientation)orientation).
//  Appelée par la classe à l'initialisation.
//  Appelée par le controleur lors d'un changement d'orientation du iDevice.
- (void)setViewFromOrientation:(UIInterfaceOrientation)orientation withStatusBarFrame:(CGRect)statusBarFrame;
@end
