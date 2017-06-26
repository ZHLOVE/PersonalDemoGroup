# 16-02-15 星期三

# 问题
```objc
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
//        NSLog(@"A:%s",__func__);
        NSLog(@"A:%s subviews.count=%i",__func__,self.view.subviews.count);// 
    }
    return self;
}
```

出现的提示信息

```
2016-02-17 13:32:18.016 ViewController[23387:410968] *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Could not load NIB in bundle: 'NSBundle </Users/qiang/Library/Developer/CoreSimulator/Devices/A369B98A-3557-4D02-9DAA-798472A55845/data/Containers/Bundle/Application/BB4FB8E2-4ABE-4DBA-A389-F59E8EC4E992/ViewController.app> (loaded)' with name 'HX9-DL-jp1-view-r7C-4P-XJC''
*** First throw call stack:
(
	0   CoreFoundation                      0x0000000105ebae65 __exceptionPreprocess + 165
	1   libobjc.A.dylib                     0x0000000105931deb objc_exception_throw + 48
	2   CoreFoundation                      0x0000000105ebad9d +[NSException raise:format:] + 205
	3   UIKit                               0x00000001066243cf -[UINib instantiateWithOwner:options:] + 499
	4   UIKit                               0x00000001063fdeea -[UIViewController _loadViewFromNibNamed:bundle:] + 381
	5   UIKit                               0x00000001063fe816 -[UIViewController loadView] + 178
	6   ViewController                      0x000000010542d9b6 -[ViewControllerA loadView] + 54
	7   UIKit                               0x00000001063feb74 -[UIViewController loadViewIfRequired] + 138
	8   UIKit                               0x00000001063ff2e7 -[UIViewController view] + 27
	9   ViewController                      0x000000010542d80d -[ViewControllerA initWithCoder:] + 141
	10  UIKit                               0x00000001066257db -[UIClassSwapper initWithCoder:] + 241
	11  UIKit                               0x00000001067f9822 UINibDecoderDecodeObjectForValue + 705
	12  UIKit                               0x00000001067f9558 -[UINibDecoder decodeObjectForKey:] + 278
	13  UIKit                               0x00000001066254b1 -[UIRuntimeConnection initWithCoder:] + 180
	14  UIKit                               0x00000001067f9822 UINibDecoderDecodeObjectForValue + 705
	15  UIKit                               0x00000001067f99e3 UINibDecoderDecodeObjectForValue + 1154
	16  UIKit                               0x00000001067f9558 -[UINibDecoder decodeObjectForKey:] + 278
	17  UIKit                               0x00000001066246c3 -[UINib instantiateWithOwner:options:] + 1255
	18  UIKit                               0x000000010698cc40 -[UIStoryboard instantiateViewControllerWithIdentifier:] + 181
	19  UIKit                               0x000000010698cd93 -[UIStoryboard instantiateInitialViewController] + 69
	20  UIKit                               0x0000000106267fa6 -[UIApplication _loadMainStoryboardFileNamed:bundle:] + 94
	21  UIKit                               0x00000001062682d6 -[UIApplication _loadMainInterfaceFile] + 260
	22  UIKit                               0x0000000106266b54 -[UIApplication _runWithMainScene:transitionContext:completion:] + 1390
	23  UIKit                               0x0000000106263e7b -[UIApplication workspaceDidEndTransaction:] + 188
	24  FrontBoardServices                  0x0000000108c68754 -[FBSSerialQueue _performNext] + 192
	25  FrontBoardServices                  0x0000000108c68ac2 -[FBSSerialQueue _performNextFromRunLoopSource] + 45
	26  CoreFoundation                      0x0000000105de6a31 __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 17
	27  CoreFoundation                      0x0000000105ddc95c __CFRunLoopDoSources0 + 556
	28  CoreFoundation                      0x0000000105ddbe13 __CFRunLoopRun + 867
	29  CoreFoundation                      0x0000000105ddb828 CFRunLoopRunSpecific + 488
	30  UIKit                               0x00000001062637cd -[UIApplication _run] + 402
	31  UIKit                               0x0000000106268610 UIApplicationMain + 171
	32  ViewController                      0x000000010542e83f main + 111
	33  libdyld.dylib                       0x000000010860e92d start + 1
)
libc++abi.dylib: terminating with uncaught exception of type NSException
(lldb) 
```

打断点显示:
```
(lldb) po self.view
error: Execution was interrupted, reason: internal ObjC exception breakpoint(-3)..
The process has been returned to the state before expression evaluation.
(lldb) 
```