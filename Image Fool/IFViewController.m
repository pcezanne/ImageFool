//
//  IFViewController.m
//  Image Fool
//
//  Created by Paul Cezanne on 8/1/13.
//  Copyright (c) 2013 Enki Labs. All rights reserved.
//

#import "IFViewController.h"
#import "IFImageCell.h"
#import "IFURLImage.h"


@interface IFViewController () 
- (void) setTrashButtonAppearance;
@end

@implementation IFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setTrashButtonAppearance];
    _searchStringLabel.text = kIMAGE_FOOL_HELP_TEXT;

    
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];

    [self.collectionView registerClass:[IFImageCell class]  forCellWithReuseIdentifier:ImageCellIdentifier];
    UINib *cellNib = [UINib nibWithNibName:@"IFImageCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:ImageCellIdentifier];
    self.imageNibLoaded = YES;

    self.photoDictionary = [NSMutableDictionary dictionary];
    
    self.flickrImageQueue = [[NSOperationQueue alloc] init];
    self.flickrImageQueue.maxConcurrentOperationCount = 3;
    
    self.flickrSearchQueue = [[NSOperationQueue alloc] init];
    self.flickrSearchQueue.maxConcurrentOperationCount = 2;
    
    self.doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processDoubleTap:)];
    [_doubleTapGesture setNumberOfTapsRequired:2];
    [_doubleTapGesture setNumberOfTouchesRequired:1];
    //[_doubleTapGesture requireGestureRecognizerToFail:_doubleTapGesture];

    [self.view addGestureRecognizer:_doubleTapGesture];
    
    self.singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processSingleTap:)];
    [_singleTapGesture setNumberOfTapsRequired:1];
    [_singleTapGesture setNumberOfTouchesRequired:1];
    [_singleTapGesture requireGestureRecognizerToFail:_doubleTapGesture];
    
    [self.view addGestureRecognizer:_singleTapGesture];

    [self reloadFlickr];
}

#pragma mark Image Methods

- (void) reloadFlickr;
{
    
    // kill the old one first
    self.photoDictionary = nil;
    self.photoDictionary = [NSMutableDictionary dictionary];
    
    __weak IFViewController *weakSelf = self;
    [weakSelf.collectionView reloadData];

    for (int i = 0; i < kIMAGE_FOOL_MAX_CELLS; i++) {
        
        __weak IFViewController *weakSelf = self;
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{

          
            IFFlickrPhoto *newFlickr = [[IFFlickrPhoto alloc] init];
            newFlickr.delegate = weakSelf;
            NSString *searchString;
            
            NSString *searchSuffix = [NSString stringWithFormat:@"%c", [imageLetters characterAtIndex:i]];
            
            if (_searchPrefix) {
                searchString = [NSString stringWithFormat:@"%@%@", weakSelf.searchPrefix, searchSuffix];
            } else {
                searchString = searchSuffix;    // just the suffix since prefix is empty.
            }
            [newFlickr loadFlickrPhotos:searchString];
            
            [weakSelf.photoDictionary setObject:newFlickr forKey:searchString];
                        
        }];
        
        [operation setQueuePriority:NSOperationQueuePriorityVeryLow];
        [self.flickrImageQueue addOperation:operation];
    }
    
                                       
}

#pragma mark UICollectionView Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return kIMAGE_FOOL_MAX_CELLS;
}


// based on http://www.skeuo.com/uicollectionview-custom-layout-tutorial
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];

    if (_imageNibLoaded == NO) {
        UINib *cellNib = [UINib nibWithNibName:@"IFImageCell" bundle:nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:ImageCellIdentifier];
        self.imageNibLoaded = YES;
    }
    
    IFImageCell *imageCell =  [collectionView dequeueReusableCellWithReuseIdentifier:ImageCellIdentifier forIndexPath:indexPath];
    
    
    NSString *searchSuffix = [NSString stringWithFormat:@"%c", [imageLetters characterAtIndex: row]];
    
    NSString *searchSuffixPretty;
    
    if ([searchSuffix isEqualToString:@" "]) {
        searchSuffixPretty = @"space";
    } else {
        searchSuffixPretty = searchSuffix;
    }
    
    // build the key to look up the flickrPhoto
    NSString *key;
    if (_searchPrefix) {
        key = [_searchPrefix stringByAppendingFormat:@"%@", searchSuffix];
    } else {
        key = searchSuffix;
    }
    
    imageCell.searchSuffix.text = searchSuffixPretty;
    
    // only put up the images if we have images to put up
    //
    IFFlickrPhoto *flickrPhoto = [_photoDictionary objectForKey:key];
    
    if ( flickrPhoto) {
        
        imageCell.flickrTitle.text = flickrPhoto.name;
        imageCell.background.alpha = 1.0;

        // load photo images in the background
        __weak IFViewController *weakSelf = self;
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            
            NSURL *url = [NSURL URLWithString:flickrPhoto.url];
            IFURLImage *flickrImage = [IFURLImage imageWithURL:url];
            UIImage *image = [flickrImage image];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // then set them via the main queue if the cell is still visible.
                if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                    IFImageCell *cell =
                    (IFImageCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                    cell.imageView.image = image;
                    cell.background.alpha = 1.0;

                }
            });
        }];
        [operation setQueuePriority:NSOperationQueuePriorityHigh];
        [self.flickrImageQueue addOperation:operation];

    } else {
        imageCell.background.alpha = 0.5;
    }
    return imageCell;
}


#pragma mark Tap Methods


- (void) processDoubleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint point = [sender locationInView:_collectionView];
        NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:point];
        if (indexPath) {
            NSInteger row = [indexPath row];            
            
            // first, get the large URL
            //
            NSString *searchSuffix = [NSString stringWithFormat:@"%c", [imageLetters characterAtIndex: row]];
            
            // build the key to look up the flickrPhoto
            NSString *key;
            if (_searchPrefix) {
                key = [_searchPrefix stringByAppendingFormat:@"%@", searchSuffix];
            } else {
                key = searchSuffix;
            }

            IFFlickrPhoto *flickrPhoto = [_photoDictionary objectForKey:key];
            
            // second, build and present the full image VC
            //
            IFFullImageViewController *fullImageVC = [[IFFullImageViewController alloc]
                                                      init];
            fullImageVC.delegate = self;
            fullImageVC.flickrPhoto = flickrPhoto;
            
            UINavigationController *navigationController = [[UINavigationController alloc]
                                                            initWithRootViewController:fullImageVC];
            [self presentViewController:navigationController animated:YES completion: nil];

        }

    }
}

- (void) processSingleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)  {
        CGPoint point = [sender locationInView:_collectionView];
        NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:point];
        if (indexPath)  {
            NSInteger row = [indexPath row];
            NSString *searchSuffix = [NSString stringWithFormat:@"%c", [imageLetters characterAtIndex: row]];
            
            if (_searchPrefix) {
                self.searchPrefix = [_searchPrefix stringByAppendingFormat:@"%@", searchSuffix];
            } else {
                self.searchPrefix = searchSuffix;
            }
            
            _searchStringLabel.text = _searchPrefix;
            [self setTrashButtonAppearance];
                        
            [self reloadFlickr];
        }
    }
}

#pragma mark Trash Methods

- (void) setTrashButtonAppearance
{
    if ([_searchPrefix length]) {
        
        if (_trashButton.alpha < 0.01) {
            [UIView animateWithDuration:1.0
                                  delay:0
                                options: UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 _trashButton.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 ;
                             }];
            _trashButton.enabled = YES;
        }
    } else {
        [UIView animateWithDuration:1.0
                              delay:0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _trashButton.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             ;
                         }];
        _trashButton.enabled = NO;
        
    }
}

- (IBAction)trashPressed:(id)sender
{
    self.searchPrefix = nil;
    _searchStringLabel.text = kIMAGE_FOOL_HELP_TEXT;
    
    [self setTrashButtonAppearance];
    [self reloadFlickr];
}

#pragma mark IFFlickrPhotoDelegate Methods

- (void) urlRecieved:(NSString *) last;
{
    // figure out which cell finished, we do this based on the passed character
    NSRange range = [imageLetters rangeOfString:last options:NSCaseInsensitiveSearch range:NSMakeRange(0, kIMAGE_FOOL_MAX_CELLS-1)];

    if (range.location == NSNotFound) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:range.location inSection:0];
    
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    });
    
}
#pragma mark IFFullImageVCDelegate Methods

- (void)didDismissModalView;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Boilerplat Methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
