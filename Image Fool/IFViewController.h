//
//  IFViewController.h
//  Image Fool
//
//  Created by Paul Cezanne on 8/1/13.
//  Copyright (c) 2013 Enki Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFFlickrPhoto.h"

#define kIMAGE_FOOL_MAX_CELLS 26 // 26 letters in the alphabet 
static NSString * const imageLetters = @"abcdefghijklmnopqrstuvwxyz";


@interface IFViewController : UIViewController <UICollectionViewDataSource,
UICollectionViewDelegate, IFFlickrPhotoDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *searchStringLabel;
@property (weak, nonatomic) IBOutlet UIButton *trashButton;

- (IBAction)trashPressed:(id)sender;

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong) NSString *searchPrefix;
@property (nonatomic, strong) NSMutableDictionary *photoDictionary;
@property (nonatomic, strong) NSOperationQueue *flickrImageQueue;
@property (nonatomic, strong) NSOperationQueue *flickrSearchQueue;


@property (nonatomic) BOOL imageNibLoaded;

- (void) reloadFlickr;

@end
