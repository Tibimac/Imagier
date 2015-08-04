//
//  ImagierViewController.h
//  Imagier
//
//  Created by Thibault Le Cornec on 25/05/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImagierView;

@interface ImagierViewController : UIViewController <UIScrollViewDelegate>
{
    ImagierView *imagierView;   // La vue controlée
    
//  Tableau à 2 dimensions contenant :
//      - un tableau d'objets "Image"
//      - un tableau d'objets NSURL avec le chemin de chaque image
    NSMutableArray *allImages;
    
    int numOfCurrentImage;
}

// Méthode déclenchée par le stepper.
// Elle sélectionne l'image suivante ou précédente en fonction de la valeur du stepper.
- (void)changeImage;

// Méthode déclenchée par les slider de zoom.
// Elle ajuste la largeur ou la hauteur de l'image en fonction du slider qui a été modifié.
- (void)sliderChangeScale;

// Méthode utilisée pour mettre à jour l'interface
- (void)updateUIWithScaleWidth:(CGFloat)scaleW andScaleHeight:(CGFloat)scaleH;
@end