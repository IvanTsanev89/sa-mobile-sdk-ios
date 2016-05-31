//
//  SAVASTCreative.m
//  Pods
//
//  Created by Gabriel Coman on 09/03/2016.
//
//

// import header
#import "SAVASTCreative.h"

// import utils
#import "SAUtils.h"

@implementation SAVASTCreative

- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super init]) {
        _type = (SAVASTCreativeType)[jsonDictionary safeIntForKey:@"type"];
        __id = [jsonDictionary safeStringForKey:@"id"];
        _sequence = [jsonDictionary safeStringForKey:@"sequence"];
        _Duration = [jsonDictionary safeStringForKey:@"Duration"];
        _ClickThrough = [jsonDictionary safeStringForKey:@"ClickThrough"];
        _playableDiskURL = [jsonDictionary safeStringForKey:@"playableDiskURL"];
        _isOnDisk = [jsonDictionary safeBoolForKey:@"isOnDisk"];
        _MediaFiles = [[[NSArray alloc] initWithJsonArray:[jsonDictionary objectForKey:@"MediaFiles"] andIterator:^id(id item) {
            return [[SAVASTMediaFile alloc] initWithJsonDictionary:(NSDictionary*)item];
        }] mutableCopy];
        _TrackingEvents = [[[NSArray alloc] initWithJsonArray:[jsonDictionary objectForKey:@"TrackingEvents"] andIterator:^id(id item) {
            return [[SAVASTTracking alloc] initWithJsonDictionary:(NSDictionary*)item];
        }] mutableCopy];
        _ClickTracking = [[[NSArray alloc] initWithJsonArray:[jsonDictionary objectForKey:@"ClickTracking"] andIterator:^id(id item) {
            return (NSString*)item;
        }] mutableCopy];
        _CustomClicks = [[[NSArray alloc] initWithJsonArray:[jsonDictionary objectForKey:@"CustomClicks"] andIterator:^id(id item) {
            return (NSString*)item;
        }] mutableCopy];
    }
    return self;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"type": @(_type),
        @"id": nullSafe(__id),
        @"sequence": nullSafe(_sequence),
        @"Duration": nullSafe(_Duration),
        @"ClickThrough": nullSafe(_ClickThrough),
        @"playableDiskURL": nullSafe(_playableDiskURL),
        @"isOnDisk": @(_isOnDisk),
        @"MediaFiles": [_MediaFiles dictionaryRepresentation],
        @"TrackingEvents": [_TrackingEvents dictionaryRepresentation],
        @"ClickTracking": [_ClickTracking dictionaryRepresentation],
        @"CustomClicks" : [_CustomClicks dictionaryRepresentation]
    };
}

- (void) sumCreative:(SAVASTCreative *)creative {
    // perform a "Sum" operation
    // first override some unimportant variables
    __id = creative._id;
    _sequence = creative.sequence;
    _Duration = creative.Duration;
    
    if ([SAUtils isValidURL:creative.ClickThrough]) {
        _ClickThrough = creative.ClickThrough;
    }
    if ([SAUtils isValidURL:creative.playableMediaURL]){
        _playableMediaURL = creative.playableMediaURL;
    }
    if (creative.playableDiskURL != NULL){
        _playableDiskURL = creative.playableDiskURL;
    }
    
    // then concatenate arrays (this is what's important)
    [_MediaFiles addObjectsFromArray:creative.MediaFiles];
    [_TrackingEvents addObjectsFromArray:creative.TrackingEvents];
    [_ClickTracking addObjectsFromArray:creative.ClickTracking];
    [_CustomClicks addObjectsFromArray:creative.CustomClicks];
}

@end