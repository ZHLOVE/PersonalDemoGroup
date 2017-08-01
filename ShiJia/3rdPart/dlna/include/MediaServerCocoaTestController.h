//
//  MediaServerCocoaTestController.h
//  Platinum
//
//  Created by Sylvain on 9/14/10.
//  Copyright 2010 Plutinosoft LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PltUPnPObject.h"
#import "PltMediaServerObject.h"

@interface MediaServerCocoaTestController : NSObject <PLT_MediaServerDelegateObject, NSTableViewDataSource, NSTableViewDelegate> {
    IBOutlet NSWindow*	window;
    IBOutlet NSButton*  mainButton;
    
    
    IBOutlet NSButton*  playButton;
    IBOutlet NSButton*  pauseButton;
    IBOutlet NSButton*  transferInfoButton;
    
    IBOutlet NSButton *endBtn;
    IBOutlet NSButton *stopBtn;
    
    IBOutlet NSTableView *tv;
    IBOutlet NSScrollView *scrollButton;
    IBOutlet NSTextField *urlInput;
    //IBOutlet NSButton *stopBtn;
    //PlatinumInterface* mPlatinumInterface;
    PLT_UPnPObject* upnp;
}

@end
