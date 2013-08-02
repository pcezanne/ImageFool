//
//  IFImageCell.h
//  Image Fool
//
//  Created by Paul Cezanne on 8/1/13.
//  Copyright (c) 2013 Enki Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString * const ImageCellIdentifier = @"ImageCell";

@interface IFImageCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *searchSuffix;
@property (weak, nonatomic) IBOutlet UILabel *flickrTitle;
@property (weak, nonatomic) IBOutlet UIView *background;

@end
