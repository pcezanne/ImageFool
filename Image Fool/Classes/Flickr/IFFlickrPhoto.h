//
//  IFFlickrPhoto.h
//  Image Fool
//
//  Created by Paul Cezanne on 8/1/13.
//  Copyright (c) 2013 Enki Labs. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface IFFlickrPhoto : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *largeUrl;

- (void)loadFlickrPhotos:(NSString *) searchString;

@end



