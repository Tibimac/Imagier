//
//  Image.h
//  Imagier
//
//  Created by Thibault Le Cornec on 25/05/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Image : NSObject

#pragma mark Properties
// Objets devant être accessiblent par le controleur
@property (readonly, copy)   NSString *name;
@property (readwrite, assign) CGFloat scaleWidth;
@property (readwrite, assign) CGFloat scaleHeight;

#pragma mark Constructor
- (id)initWithName:(NSString *)imageName
     andScaleWidth:(CGFloat)scaleW
    andScaleHeight:(CGFloat)scaleH;

- (void)dealloc;
@end
