//
//  IFURLImage.h
//  Image Fool
//
//  Created by Paul Cezanne on 8/1/13.
//  Copyright (c) 2013 Enki Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFURLImage : NSObject

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *image;

+ (IFURLImage *)imageWithURL:(NSURL *)imageURL;

- (id)initWithURL:(NSURL *)imageURL;

@end
