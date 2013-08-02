//
//  IFFlickrPhoto.h
//  Image Fool
//
//  Created by Paul Cezanne on 8/1/13.
//  Copyright (c) 2013 Enki Labs. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol IFFlickrPhotoDelegate;

@interface IFFlickrPhoto : NSObject

@property (weak,nonatomic) NSObject <IFFlickrPhotoDelegate> *delegate;


@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *largeUrl;

- (void)loadFlickrPhotos:(NSString *) searchString;


@end


@protocol IFFlickrPhotoDelegate <NSObject>

- (void) urlRecieved:(NSString *) last;


@end
