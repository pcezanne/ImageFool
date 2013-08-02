//
//  IFFullImageViewController.h
//  Image Fool
//
//  Created by Paul Cezanne on 8/2/13.
//  Copyright (c) 2013 Enki Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IFFullImageVCDelegate;
@class IFFlickrPhoto;

@interface IFFullImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak,nonatomic) NSObject <IFFullImageVCDelegate> *delegate;

@property (weak, nonatomic) IFFlickrPhoto *flickrPhoto;
@end


@protocol IFFullImageVCDelegate <NSObject>
- (void)didDismissModalView;
@end