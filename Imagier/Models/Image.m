//
//  Image.m
//  Imagier
//
//  Created by Thibault Le Cornec on 25/05/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "Image.h"

@implementation Image
#pragma mark -

#pragma mark Constructor
- (id)initWithName:(NSString *)imageName andScaleWidth:(CGFloat)scaleW andScaleHeight:(CGFloat)scaleH
{
    if(self = [super init])
    {
        _name = [imageName copy];
        _scaleWidth = scaleW;
        _scaleHeight = scaleH;
        
        return self;
    }
    else
    {
        return nil;
    }
}

- (void)dealloc
{
    [_name release];
    [super dealloc];
}
@end