//
//  HiTVWebServer.m
//  HiTV
//
//  Created by Lanbo Zhang on 1/10/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import "HiTVWebServer.h"
#ifdef GCDWebServer
#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerFileResponse.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>
#import <GCDWebServer/GCDWebServerResponse.h>
#import <GCDWebServer/GCDWebServerErrorResponse.h>
#import "MobileCoreServices/MobileCoreServices.h"

@import AssetsLibrary;

#define kFileReadBufferSize (64 * 1024)

@interface AssetWebServerResponse (){
    NSUInteger _offset;
    NSUInteger _size;
}
@property (nonatomic, strong) ALAssetRepresentation* assetRepresentation;
@property (nonatomic, strong) NSMutableData* dataBuffer;

@end
@implementation AssetWebServerResponse

- (instancetype)initWithAsset:(ALAssetRepresentation*) assetRepresentation
                 andByteRange:(NSRange)range{
    if ((self = [super init])) {
        self.assetRepresentation = assetRepresentation;
        
        NSUInteger fileSize = [assetRepresentation size];
        
        BOOL hasByteRange = ((range.location != NSUIntegerMax) || (range.length > 0));
        if (hasByteRange) {
            if (range.location != NSUIntegerMax) {
                range.location = MIN(range.location, fileSize);
                range.length = MIN(range.length, fileSize - range.location);
            } else {
                range.length = MIN(range.length, fileSize);
                range.location = fileSize - range.length;
            }
            if (range.length == 0) {
                return nil;  // TODO: Return 416 status code and "Content-Range: bytes */{file length}" header
            }
        } else {
            range.location = 0;
            range.length = fileSize;
        }
        
        if (hasByteRange) {
            [self setStatusCode:206];
            [self setValue:[NSString stringWithFormat:@"bytes %lu-%lu/%lu", (unsigned long)_offset, (unsigned long)(_offset + _size - 1), (unsigned long)fileSize] forAdditionalHeader:@"Content-Range"];
        }
        
        _offset = range.location;
        _size = range.length;
        
        self.contentType = (__bridge_transfer NSString*)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)[assetRepresentation UTI], kUTTagClassMIMEType);
        
        [self setValue:@"bytes" forAdditionalHeader:@"Accept-Ranges"];
        
        self.contentLength = range.length;
    }
    return self;
}

- (BOOL)open:(NSError**)error {
    
    return YES;
}

- (NSData*)readData:(NSError**)error {
    size_t length = MIN((NSUInteger)kFileReadBufferSize, _size);
    
    if (!self.dataBuffer) {
        self.dataBuffer = [[NSMutableData alloc] initWithLength:kFileReadBufferSize];
    }
    
    ssize_t result = [self.assetRepresentation getBytes:self.dataBuffer.mutableBytes fromOffset:_offset length:length error:error];
    
    if (result < 0) {
        return nil;
    }
    if (result > 0) {
        _offset += result;
        _size -= result;
    }
    return [NSData dataWithBytesNoCopy:self.dataBuffer.mutableBytes length:result freeWhenDone:NO];
}

- (void)close {
    self.assetRepresentation = nil;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithString:[super description]];
    [description appendFormat:@"\n\n{%@}", self.assetRepresentation.url];
    return description;
}


@end

#endif
#import "TSLibraryImport.h"
//#import "AssetWebServerResponse.h"
#import "LocalMediaManager.h"
#import "IPDetector.h"

@import AssetsLibrary;
@import MobileCoreServices;

static NSString* const KHiTVWebServerAssetsLibraryPrefix = @"assets-library://";
static NSString* const KHiTVWebServeriPodLibraryPrefix = @"ipod-library://";

static NSString* const KHiTVWebServerAssetsLibraryProcessedPrefix = @"assets-library/";
static NSString* const KHiTVWebServeriPodLibraryProcessedPrefix = @"ipod-library/";

static BOOL const KHiTVWebServerSupportExportingVideo = YES;

@interface HiTVWebServer ()
#ifdef GCDWebServer
@property (nonatomic, strong) GCDWebServer* webServer;
#endif
@property (nonatomic, strong) TSLibraryImport* tsLibrayImport;
@property (nonatomic, strong) AVAssetExportSession *session;
@end

@implementation HiTVWebServer

+ (instancetype)sharedInstance{
    static HiTVWebServer* instance = nil;
    
    DDLogInfo(@"KHiTVWebServerSupportExportingVideo is: %@", KHiTVWebServerSupportExportingVideo ? @"YES" : @"NO");
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


- (void)start{
#if 0
    if (self.webServer) {
        return;
    }
    
    // Create server
    self.webServer = [[GCDWebServer alloc] init];
    
    [self p_addAssetsLibrarySupport];
    [self p_addPodLibrarySupport];
    
    // Start server on port 8090
    [self.webServer startWithPort:8090 bonjourName:nil];
    DDLogInfo(@"%@", self.webServer.serverURL);
#endif
}

- (void)stop{
#ifdef GCDWebServer
    [self.webServer stop];
    self.webServer = nil;
#endif
}

- (NSString*)webURLForLocalUrl:(NSString*)localUrl{
#ifdef GCDWebServer
    BOOL found = NO;
    for (NSString* supportedPrefix in [self p_supportedPrefix]) {
        if ([localUrl hasPrefix:supportedPrefix]) {
            //supported url
            found = YES;
            break;
        }
    }
    if (!found) {
        return localUrl;
    }
    
    

    //http://192.168.5.103:8090/assets-library/asset/asset.MOV?id=B090D3BB-2002-4D83-A6C0-D95F914BCE9E&ext=MOV
    NSMutableString* localWebServerURL = [[NSMutableString alloc] initWithString:localUrl];
    [localWebServerURL replaceOccurrencesOfString:KHiTVWebServerAssetsLibraryPrefix withString:KHiTVWebServerAssetsLibraryProcessedPrefix options:NSCaseInsensitiveSearch range:NSMakeRange(0, localWebServerURL.length)];
    
    [localWebServerURL replaceOccurrencesOfString:KHiTVWebServeriPodLibraryPrefix withString:KHiTVWebServeriPodLibraryProcessedPrefix options:NSCaseInsensitiveSearch range:NSMakeRange(0, localWebServerURL.length)];
    [localWebServerURL replaceOccurrencesOfString:@"?id=" withString:@"/assetidplaceholder/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, localWebServerURL.length)];
    [localWebServerURL replaceOccurrencesOfString:@"&ext=" withString:@"/extplaceholder/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, localWebServerURL.length)];
    
    
    NSString* url = [[[self.webServer serverURL] absoluteString] stringByAppendingString:localWebServerURL];
    DDLogInfo(@"webURLForLocalUrl: Local web: %@  for resource : %@", url, localUrl);

    return url;
#else
    [self copyAsset2LocalTmp:localUrl];
    return nil;
#endif
}

#pragma mark - private methods
#ifdef GCDWebServer
- (void)p_addAssetsLibrarySupport{
    __weak typeof(self) weakSelf = self;
    [self.webServer addHandlerWithMatchBlock:^GCDWebServerRequest *(NSString* requestMethod, NSURL* requestURL, NSDictionary* requestHeaders, NSString* urlPath, NSDictionary* urlQuery) {
        return [HiTVWebServer p_requestWithPrefix:KHiTVWebServerAssetsLibraryProcessedPrefix
                                    requestMethod:requestMethod
                                              url:requestURL
                                   requestHeaders:requestHeaders
                                          urlPath:urlPath
                                         urlQuery:urlQuery];
        
    } asyncProcessBlock:^(GCDWebServerRequest *request, GCDWebServerCompletionBlock completionBlock) {
        DDLogInfo(@"handle request:%@", [request.URL absoluteString]);
        [weakSelf handleRequest:request
            withCompletionBlock:completionBlock];
    }];
}

- (void)p_addPodLibrarySupport{
    __weak typeof(self) this = self;
    [self.webServer addHandlerWithMatchBlock:^GCDWebServerRequest *(NSString* requestMethod, NSURL* requestURL, NSDictionary* requestHeaders, NSString* urlPath, NSDictionary* urlQuery) {
        return [HiTVWebServer p_requestWithPrefix:KHiTVWebServeriPodLibraryProcessedPrefix
                                    requestMethod:requestMethod
                                              url:requestURL
                                   requestHeaders:requestHeaders
                                          urlPath:urlPath
                                         urlQuery:urlQuery];
    } asyncProcessBlock:^(GCDWebServerRequest *request, GCDWebServerCompletionBlock completionBlock) {
        DDLogInfo(@"handle request:%@", [request.URL absoluteString]);
        
        [this p_handleMusicFOrRequest:request
                           completion:completionBlock];
    }];
}

- (NSArray*)p_supportedPrefix{
    return @[
             KHiTVWebServerAssetsLibraryPrefix,
             KHiTVWebServeriPodLibraryPrefix
             ];
}

+ (GCDWebServerRequest*)p_requestWithPrefix:(NSString*)prefix
                              requestMethod:(NSString*) requestMethod
                                        url:(NSURL*) requestURL
                             requestHeaders:(NSDictionary*) requestHeaders
                                    urlPath:(NSString*) urlPath
                                   urlQuery:(NSDictionary*) urlQuery{
    DDLogInfo(@"request:%@", requestURL);
    if (![requestMethod isEqualToString:@"GET"]) {
        return nil;
    }
    
    NSString* newPrefix = [NSString stringWithFormat:@"/%@", prefix];
    if ([urlPath hasPrefix:newPrefix]) {
        NSString* realPath = [[requestURL relativeString] substringFromIndex:1];
        
        //http://192.168.5.103:8090/assets-library/asset/asset.MOV?id=B090D3BB-2002-4D83-A6C0-D95F914BCE9E&ext=MOV
        NSMutableString* localWebServerURL = [[NSMutableString alloc] initWithString:realPath];
        [localWebServerURL replaceOccurrencesOfString:KHiTVWebServerAssetsLibraryProcessedPrefix withString:KHiTVWebServerAssetsLibraryPrefix options:NSCaseInsensitiveSearch range:NSMakeRange(0, localWebServerURL.length)];
        
        [localWebServerURL replaceOccurrencesOfString:KHiTVWebServeriPodLibraryProcessedPrefix withString:KHiTVWebServeriPodLibraryPrefix options:NSCaseInsensitiveSearch range:NSMakeRange(0, localWebServerURL.length)];
        [localWebServerURL replaceOccurrencesOfString:@"/assetidplaceholder/" withString:@"?id=" options:NSCaseInsensitiveSearch range:NSMakeRange(0, localWebServerURL.length)];
        [localWebServerURL replaceOccurrencesOfString:@"/extplaceholder/" withString:@"&ext=" options:NSCaseInsensitiveSearch range:NSMakeRange(0, localWebServerURL.length)];
        
        
        return [[GCDWebServerRequest alloc] initWithMethod:requestMethod url:requestURL headers:requestHeaders path:localWebServerURL query:urlQuery];
    }
    return nil;
}

- (void)p_handleMusicFOrRequest:(GCDWebServerRequest *)request
                     completion:(GCDWebServerCompletionBlock) completionBlock{
    if (!self.tsLibrayImport) {
        self.tsLibrayImport = [[TSLibraryImport alloc] init];
    }
    NSString* itemID = [request.URL lastPathComponent];
    NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:itemID];
    
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
        completionBlock([GCDWebServerFileResponse responseWithFile:path byteRange:request.byteRange]);
    }else{
        [self.tsLibrayImport importAsset:[NSURL URLWithString:request.path]
                                   toURL:[NSURL fileURLWithPath:path]
                         completionBlock:^(TSLibraryImport *import) {
                             completionBlock([GCDWebServerFileResponse responseWithFile:path byteRange:request.byteRange]);
                         }];
    }
}

#pragma mark - export video

- (void)handleRequest:(GCDWebServerRequest *) request
  withCompletionBlock:(GCDWebServerCompletionBlock) completionBlock{
    __weak typeof(self) weakSelf = self;
    
    NSURL* assetUrl = [NSURL URLWithString:request.path];
    [[LocalMediaManager shagedAssetsLibrary] assetForURL:assetUrl
                                             resultBlock:^(ALAsset* asset) {
                                                 if (asset) {
                                                     [weakSelf handleAsset:asset withCompletionBlock:completionBlock forRequest:request];
                                                 } else {
                                                     // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
                                                     
                                                     [[LocalMediaManager shagedAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                                                                                            usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                                                      {
                                                          [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                              if([result.defaultRepresentation.url isEqual:assetUrl])
                                                              {
                                                                  ///////////////////////////////////////////////////////
                                                                  // SUCCESS POINT #2 - result is what we are looking for
                                                                  ///////////////////////////////////////////////////////
                                                                  *stop = YES;
                                                                  
                                                                  [weakSelf handleAsset:result withCompletionBlock:completionBlock forRequest:request];
                                                              }
                                                          }];
                                                      }
                                                      
                                                                                                          failureBlock:^(NSError *error)
                                                      {
                                                          DDLogError(@"Error: Cannot load asset from photo stream - %@", [error localizedDescription]);
                                                          completionBlock([GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_NotFound
                                                                                                                     message:@"not found"]);
                                                      }];
                                                 }
                                             }
                                            failureBlock:^(NSError* error) {
                                                DDLogError(@"Error: %@", error);
                                                completionBlock([GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_NotFound
                                                                                                           message:@"not found"]);
                                            }
     ];
    
}

- (void)handleAsset:(ALAsset*) asset withCompletionBlock:(GCDWebServerCompletionBlock) completionBlock forRequest:(GCDWebServerRequest *) request{
    if (KHiTVWebServerSupportExportingVideo &&
            [[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
        NSURL* assetUrl = [NSURL URLWithString:request.path];
        
        [self.session cancelExport];
        
        NSString* parameter = [assetUrl query];
        parameter = [parameter stringByReplacingOccurrencesOfString:@"id=" withString:@""];
        NSString* fileName = [parameter stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];
        NSString* tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        NSFileManager* defaultManager = [NSFileManager defaultManager];
        if ([defaultManager fileExistsAtPath:tempPath]) {
            DDLogInfo(@"exported video existed already: %@", tempPath);
            completionBlock([[GCDWebServerFileResponse alloc] initWithFile:tempPath byteRange:request.byteRange]);
        }else{
            DDLogInfo(@"begin to export video to: %@", tempPath);
            AVURLAsset *asset = [AVURLAsset URLAssetWithURL:assetUrl options:nil];
            self.session = [[AVAssetExportSession alloc] initWithAsset:asset
                                                            presetName:AVAssetExportPresetMediumQuality];
            self.session.outputURL = [NSURL fileURLWithPath:tempPath];
            self.session.outputFileType = AVFileTypeQuickTimeMovie;
            
            __weak typeof(self) weakSelf = self;
            [self.session exportAsynchronouslyWithCompletionHandler:^{
                if (weakSelf.session.status == AVAssetExportSessionStatusCompleted){
                    completionBlock([[GCDWebServerFileResponse alloc] initWithFile:tempPath byteRange:request.byteRange]);
                }
                else if(weakSelf.session.status == AVAssetExportSessionStatusFailed)
                {
                    completionBlock([GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_NotFound
                                                                               message:@"not found"]);
                }
                else if(weakSelf.session.status == AVAssetExportSessionStatusFailed){
                    DDLogInfo(@"exporting cancelled");
                }
                else {
                    DDLogInfo(@"unknown sta");
                }
            }];
        }
    }else{
        completionBlock([[AssetWebServerResponse alloc] initWithAsset:[asset defaultRepresentation] andByteRange:request.byteRange]);
    }
}
#endif

- (void)copyAsset2LocalTmp:(NSString *) path {
    __weak typeof(self) weakSelf = self;
    
    NSURL* assetUrl = [NSURL URLWithString:path];
    [[LocalMediaManager shagedAssetsLibrary] assetForURL:assetUrl
                                             resultBlock:^(ALAsset* asset) {
                                                 if (asset) {
                                                     [weakSelf handleAsset:asset url:path];
                                                 } else {
                                                     // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
                                                     
                                                     [[LocalMediaManager shagedAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                                                                                            usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                                                      {
                                                          [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                              if([result.defaultRepresentation.url isEqual:assetUrl])
                                                              {
                                                                  ///////////////////////////////////////////////////////
                                                                  // SUCCESS POINT #2 - result is what we are looking for
                                                                  ///////////////////////////////////////////////////////
                                                                  *stop = YES;
                                                                  
                                                                  [weakSelf handleAsset:asset url:path];
                                                              }
                                                          }];
                                                      }
                                                      
                                                                                                          failureBlock:^(NSError *error)
                                                      {
                                                          DDLogError(@"Error: Cannot load asset from photo stream - %@", [error localizedDescription]);
                                                      }];
                                                 }
                                             }
                                            failureBlock:^(NSError* error) {
                                                DDLogError(@"Error: %@", error);
                                            }
     ];
    
}

-(void)check:(NSString*)fileName
{
    NSString* tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    NSFileManager* defaultManager = [NSFileManager defaultManager];
    if ([defaultManager fileExistsAtPath:tempPath]) {
        
    }
}

-(void)notif:(NSString*)fileName
{
    [[NSThread currentThread] setThreadPriority:1.0f];
    [NSThread sleepForTimeInterval:2];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* url = [NSString stringWithFormat:@"http://%@:8090/%@", [IPDetector getIPAddress], fileName];
        DDLogInfo(@"--------------- notif %@", url);
        self.block(url);
    });
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wconversion"
- (void)handleAsset:(ALAsset*) asset url:(NSString*) path {
    
    NSURL* assetUrl = [NSURL URLWithString:path];
    
    NSString* parameter = [assetUrl query];
    parameter = [parameter stringByReplacingOccurrencesOfString:@"id=" withString:@""];
    __block NSString* fileName = [parameter stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];
    NSString* tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    NSFileManager* defaultManager = [NSFileManager defaultManager];
    if ([defaultManager fileExistsAtPath:tempPath]) {
        DDLogInfo(@"exported video existed already: %@", tempPath);
        NSString* url = [NSString stringWithFormat:@"http://%@:8090/%@", [IPDetector getIPAddress], fileName];
        DDLogInfo(@"%@", url);
        self.block(url);
        return;
    }
    
    if (KHiTVWebServerSupportExportingVideo &&
        [[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
        
        DDLogInfo(@"begin to export video to: %@", tempPath);
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:assetUrl options:nil];
        self.session = [[AVAssetExportSession alloc] initWithAsset:asset
                                                        presetName:AVAssetExportPresetMediumQuality];
        self.session.outputURL = [NSURL fileURLWithPath:tempPath];
        self.session.outputFileType = AVFileTypeQuickTimeMovie;
        self.session.shouldOptimizeForNetworkUse = YES;
        __weak typeof(self) weakSelf = self;
        [self.session exportAsynchronouslyWithCompletionHandler:^{
            if (weakSelf.session.status == AVAssetExportSessionStatusCompleted){
                DDLogInfo(@"AVAssetExportSessionStatusCompleted");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString* url = [NSString stringWithFormat:@"http://%@:8090/%@", [IPDetector getIPAddress], fileName];
                    DDLogInfo(@"%@", url);
                    self.block(url);
                });
            }
            else if(weakSelf.session.status == AVAssetExportSessionStatusFailed)
            {
                DDLogError(@"Error: Cannot load asset from photo stream - %@", weakSelf.session.description);
            }
            else if(weakSelf.session.status == AVAssetExportSessionStatusFailed) {
                DDLogError(@"exporting cancelled");
            }
            else {
                DDLogError(@"unknown sta");
            }
        }];
        //        [self performSelectorInBackground:@selector(notif:) withObject:fileName];
        
    } else {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *buffer = (Byte*)malloc(rep.size);
        NSUInteger buffered = [rep getBytes:buffer fromOffset:0 length:rep.size error:nil];
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];//this is NSData may be what you want
        [data writeToFile:tempPath atomically:YES];//you can save image later
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* url = [NSString stringWithFormat:@"http://%@:8090/%@", [IPDetector getIPAddress], fileName];
            DDLogInfo(@"%@", url);
            self.block(url);
        });
    }
}


@end
#pragma clang diagnostic pop
