//
//  SuperAwesome.m
//  SAMobileSDK
//
//  Created by Balázs Kiss on 29/07/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import "SuperAwesome.h"
#import "SAServerResponse.h"
#import "SAAppConfig.h"
#import "SKLogger.h"

@interface SuperAwesome ()

@end

@implementation SuperAwesome

+ (SuperAwesome *)sharedManager
{
    static SuperAwesome *sharedManager = nil;
    @synchronized(self) {
        if (sharedManager == nil){
            sharedManager = [[self alloc] init];
        }
    }
    return sharedManager;
}

- (instancetype)init
{
    if(self = [super init]){
        _adManager = [[SAAdManager alloc] init];
        NSLog(@"%@", [self version]);
        [self setClientConfiguration:SAClientConfigurationStaging];
    }
    return self;
}

- (NSString *)version
{
    return @"SuperAwesome iOS SDK version 2.0.0";
}


- (void)setClientConfiguration:(SAClientConfiguration)clientConfiguration
{
    _clientConfiguration = clientConfiguration;
    
    if(self.clientConfiguration == SAClientConfigurationProduction){
        self.adManager.baseURL = @"http://beta.ads.superawesome.tv/v2";
        [self setLoggingLevel:SALoggingLevelWarning];
    }else if(self.clientConfiguration == SAClientConfigurationStaging){
        self.adManager.baseURL = @"http://staging.beta.ads.superawesome.tv/v2";
        [self setLoggingLevel:SALoggingLevelWarning];
    }else{
        self.adManager.baseURL = @"http://dev.ads.superawesome.tv/v2";
        [self setLoggingLevel:SALoggingLevelDebug];
    }
}

- (void)setLoggingLevel:(SALoggingLevel)loggingLevel
{
    _loggingLevel = loggingLevel;
    
    switch (loggingLevel) {
        case SALoggingLevelNone:
            [SKLogger setLogLevel:SourceKitLogLevelNone];
            break;
        case SALoggingLevelError:
            [SKLogger setLogLevel:SourceKitLogLevelError];
            break;
        case SALoggingLevelWarning:
            [SKLogger setLogLevel:SourceKitLogLevelWarning];
            break;
        case SALoggingLevelInfo:
            [SKLogger setLogLevel:SourceKitLogLevelInfo];
            break;
        case SALoggingLevelDebug:
            [SKLogger setLogLevel:SourceKitLogLevelDebug];
            break;
        default:
            break;
    }
    
}


@end