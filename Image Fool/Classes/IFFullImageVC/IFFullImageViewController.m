//
//  IFFullImageViewController.m
//  Image Fool
//
//  Created by Paul Cezanne on 8/2/13.
//  Copyright (c) 2013 Enki Labs. All rights reserved.
//

#import "IFFullImageViewController.h"
#import "IFFlickrPhoto.h"
#import "IFURLImage.h"

@interface IFFullImageViewController ()

@end

@implementation IFFullImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self
                                               action:@selector(dismissView:)];
    
    
    __weak IFFullImageViewController *weakSelf = self;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // switch to a background thread and perform your expensive operation
        
        NSURL *url = [NSURL URLWithString:weakSelf.flickrPhoto.largeUrl];
        IFURLImage *flickrImage = [IFURLImage imageWithURL:url];
        UIImage *image = [flickrImage image];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // switch back to the main thread to update your UI
            weakSelf.imageView.image = image;
        });
    });
    
    
    
    

}


- (void)dismissView:(id)sender
{
    if([_delegate respondsToSelector:@selector(didDismissModalView)])
        [_delegate didDismissModalView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
