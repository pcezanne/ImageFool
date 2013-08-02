//
//  IFFlickrPhoto.m
//  Image Fool
//
//  Created by Paul Cezanne on 8/1/13.
//  Copyright (c) 2013 Enki Labs. All rights reserved.
//

#import "IFFlickrPhoto.h"

@implementation IFFlickrPhoto



// from http://www.techrepublic.com/blog/ios-app-builder/build-your-own-ios-flickr-app-part-1/
// modified to use NSJSONSerialization
//
- (void)loadFlickrPhotos:(NSString *) searchString
{
    
    // 1. Build your Flickr API request w/Flickr API key in FlickrAPIKey.h
    
    // only get ONE photo because Image Fool only needs the first hit
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&safe_search=1&per_page=1&format=json&nojsoncallback=1", @"bfd2ef81664bbae62c982dd42752eb5d",searchString];
    NSURL *url = [NSURL URLWithString:urlString];
    // 2. Get URLResponse string & parse JSON to Foundation objects.
    
    NSData* jsonData = [NSData dataWithContentsOfURL:url];
    NSError* error;
    
    // parse the JSON
    
    if (jsonData) {
        
        NSDictionary* results = [NSJSONSerialization
                                 JSONObjectWithData:jsonData
                                 options:kNilOptions
                                 error:&error];
        
        
        // extract the title and name
        NSArray *photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
        
        if ([photos count]) {
            
            NSDictionary *photo = [photos objectAtIndex:0];     // only use the first one
            
            self.name = [photo objectForKey:@"title"];
            
            NSString *baseURL = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
            
            self.url = [NSString stringWithFormat:@"%@.jpg", baseURL];
            self.largeUrl = [NSString stringWithFormat:@"%@_b.jpg", baseURL];
            
            //NSLog(self.name);
            //NSLog(self.url);
            
            // now tell the delegate to update just the cell with the
            // last character of the search
            
            NSUInteger length = [searchString length];
            NSString *last = [NSString stringWithFormat:@"%c", [searchString characterAtIndex: length - 1]];

            
            
            if([_delegate respondsToSelector:@selector(urlRecieved:)])
                [_delegate urlRecieved:last];
        }
    }
}




@end
