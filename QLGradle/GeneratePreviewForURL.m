#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#define MINIMUM_ASPECT_RATIO (1.0/2.0)

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
    @autoreleasepool {
        
        NSURL *URL = (__bridge NSURL *)url;
        NSLog(@"url %@", url);
        
        NSString *dataType = (__bridge NSString *)contentTypeUTI;
        NSLog(@"type %@", dataType);
        
        NSMutableDictionary *maxSize = [NSMutableDictionary alloc];

        float width = 1024.0;
        float height = 800.0;
        
        NSData* data = [NSData dataWithContentsOfURL:URL];
        
        if (data) {
            NSRect viewRect = NSMakeRect(0.0, 0.0, 600.0, 800.0);
            float scale = height / 800.0;
            NSSize scaleSize = NSMakeSize(scale, scale);
            CGSize thumbSize = NSSizeToCGSize(
                                              NSMakeSize((width * (600.0/800.0)),
                                                         height));
            
            WebView* webView = [[WebView alloc] initWithFrame: viewRect];
            [webView scaleUnitSquareToSize: scaleSize];
            [[[webView mainFrame] frameView] setAllowsScrolling:NO];
            [[webView mainFrame] loadData: data
                                 MIMEType: @"text/html"
                         textEncodingName: @"utf-8"
                                  baseURL: nil];
            
            while([webView isLoading]) {
                CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true);
            }
            
            [webView display];
            
            //CGContextRef context =
            //QLThumbnailRequestCreateContext(thumbnail, thumbSize, false, NULL);
            
            /*
            if (context) {
                NSGraphicsContext* nsContext =
                [NSGraphicsContext
                 graphicsContextWithGraphicsPort: (void*) context
                 flipped: [webView isFlipped]];
                
                [webView displayRectIgnoringOpacity: [webView bounds]
                                          inContext: nsContext];
                
                QLThumbnailRequestFlushContext(thumbnail, context);
                
                CFRelease(context);
            }
             */
        }
        
    }
    
    return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview)
{
    // Implement only if supported
}
