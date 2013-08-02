//
//  IFURLImage.h
//  Image Fool
//
//  Created by Paul Cezanne on 8/1/13.
//  Copyright (c) 2013 Enki Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#if 0
Flickr keys
Key:
bfd2ef81664bbae62c982dd42752eb5d

Secret:
68269ff31ae2d49e
#endif

@interface IFURLImage : NSObject

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *image;

+ (IFURLImage *)imageWithURL:(NSURL *)imageURL;

- (id)initWithURL:(NSURL *)imageURL;

@end
