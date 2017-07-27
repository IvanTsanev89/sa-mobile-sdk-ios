/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>
#import "FlashRuntimeExtensions.h"

/**
 * C method that sends a call back to the AIR SDK with data suitable for
 * an ad.
 *
 * @param context       current FREContext object
 * @param name          AIR ad name to send the callback to. This should be
 *                      unique and generated by the SDK
 * @param placementId   placement Id of the ad that sent the callback.
 * @param callback      callback method name
 */
void sendAdCallback (FREContext context, NSString *name, int placementId, NSString *callback);
