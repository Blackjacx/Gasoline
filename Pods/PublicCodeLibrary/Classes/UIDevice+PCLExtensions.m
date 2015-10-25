/*!
 @file		UIDevice+PCLExtension.m
 @brief		Extensions for the class UIDevice
 @author	Stefan Herold
 @date		2015-07-29
 @copyright	Copyright © 2015 Stefan Herold. All rights reserved.
 */

#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/socket.h> // Per msqr
#include <net/if.h>
#include <net/if_dl.h>

#import "UIDevice+PCLExtensions.h"

/*
 Thanks to Apple for providing this code (https://developer.apple.com/library/prerelease/ios/documentation/UserExperience/Conceptual/TransitionGuide/SupportingEarlieriOS.html#//apple_ref/doc/uid/TP40013174-CH14-SW1)
 */
NSUInteger DeviceSystemMajorVersion();
NSUInteger DeviceSystemMajorVersion() {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}


@implementation UIDevice (PCLExtensions)

+ (BOOL)pcl_isPad
{
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (BOOL)pcl_isPhone
{
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

+ (BOOL)pcl_isIOS7OrHigher
{
    BOOL returnValue = DeviceSystemMajorVersion() >= 7;
    return returnValue;
}

+ (BOOL)pcl_isIOS8OrHigher
{
    BOOL returnValue = DeviceSystemMajorVersion() >= 8;
    return returnValue;
}

+ (BOOL)pcl_isIOS9OrHigher
{
    BOOL returnValue = DeviceSystemMajorVersion() >= 9;
    return returnValue;
}

+ (NSUInteger)pcl_majorOSVersion
{
	return DeviceSystemMajorVersion();
}

- (NSString *)pcl_machine
{
	NSString *result = nil;
	
	//
	// Obtain machine type.
	//
	
	size_t size = 0;
	
	if ( sysctlbyname("hw.machine", NULL, &size, NULL, 0) )
	{
		return result;
	}
	
	char *machineCString = malloc(size);
	
	@try
	{
		if ( sysctlbyname("hw.machine", machineCString, &size, NULL, 0) )
		{
			return result;
		}
		
		result = @(machineCString);
	}
	@finally 
	{
		free( machineCString );
		machineCString = NULL;
	}
	
	return result;
}

- (NSString *)pcl_macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;

    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;

    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }

    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }

    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }

    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }

    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);

    return outstring;
}

@end
