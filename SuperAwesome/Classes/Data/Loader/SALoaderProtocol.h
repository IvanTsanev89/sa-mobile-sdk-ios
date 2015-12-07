//
//  SALoaderProtocol.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//

#import <Foundation/Foundation.h>

// forward declaration
@class SAAd;

// @brief:
// SALoader protocol defines two main optional functions that a user might
// implement if he wants to preload Ads
// This protocol is implemented by a SALoader class delegate
@protocol SALoaderProtocol <NSObject>

// main protocol functions
@optional

// @brief: function that gets called when an Ad is succesfully called
// @return: returns a valid SAAd object
- (void) didLoadAd:(SAAd*)ad;

// @brief: function that gets called when an Ad has failed to load
// @return: it returns a placementId of the failing ad through callback
- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId;

@end
