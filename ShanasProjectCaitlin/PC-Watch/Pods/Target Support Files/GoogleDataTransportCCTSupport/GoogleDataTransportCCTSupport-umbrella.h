#ifdef __OBJC__
#import <Foundation/Foundation.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GDTCOREvent+GDTCCTSupport.h"

FOUNDATION_EXPORT double GoogleDataTransportCCTSupportVersionNumber;
FOUNDATION_EXPORT const unsigned char GoogleDataTransportCCTSupportVersionString[];

