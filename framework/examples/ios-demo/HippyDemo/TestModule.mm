/*!
* iOS SDK
*
* Tencent is pleased to support the open source community by making
* Hippy available.
*
* Copyright (C) 2019 THL A29 Limited, a Tencent company.
* All rights reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*   http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

#import "TestModule.h"
#import "HippyRootView.h"
#import "AppDelegate.h"
#import "HippyBundleURLProvider.h"
#import "DemoConfigs.h"
#import "UIView+NativeRender.h"
#import "HippyBridgeDelegate.h"
#import "HippyBridge.h"

@interface TestModule ()<HippyBridgeDelegate> {
    HippyBridge *_bridge;
}

@end

@implementation TestModule

HIPPY_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue {
	return dispatch_get_main_queue();
}

HIPPY_EXPORT_METHOD(debug:(nonnull NSNumber *)instanceId) {
}

HIPPY_EXPORT_METHOD(remoteDebug:(nonnull NSNumber *)instanceId bundleUrl:(nonnull NSString *)bundleUrl)
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *rootViewController = delegate.window.rootViewController;
    UIViewController *vc = [[UIViewController alloc] init];
    BOOL isSimulator = NO;
#if TARGET_IPHONE_SIMULATOR
    isSimulator = YES;
#endif
    NSString *urlString = [[HippyBundleURLProvider sharedInstance] bundleURLString];
    if (bundleUrl.length > 0) {
        urlString = bundleUrl;
    }
    NSURL *url = [NSURL URLWithString:bundleUrl];
    HippyRootView *rootView = [[HippyRootView alloc] initWithFrame:rootViewController.view.bounds];
    NSNumber *rootTag = rootView.componentTag;
    NSDictionary *launchOptions = @{@"EnableTurbo": @(DEMO_ENABLE_TURBO), @"DebugMode": @(YES)};;
    NSArray<NSURL *> *bundleURLs = @[url];
    NSURL *sandboxDirectory = [url URLByDeletingLastPathComponent];
    HippyBridge *bridge = [[HippyBridge alloc] initWithDelegate:self
                                                 moduleProvider:nil
                                                  launchOptions:launchOptions
                                                    engineKey:@"Demo"];
    [bridge setupRootTag:rootView.componentTag rootSize:rootView.bounds.size
          frameworkProxy:bridge rootView:rootView.contentView
             screenScale:[UIScreen mainScreen].scale];
    [bridge loadBundleURLs:bundleURLs];
    [bridge loadInstanceForRootView:rootTag  withProperties:@{@"isSimulator": @(isSimulator)}];
    bridge.sandboxDirectory = sandboxDirectory;
    bridge.contextName = @"Demo";
    bridge.moduleName = @"Demo";
    _bridge = bridge;
    rootView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [vc.view addSubview:rootView];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [rootViewController presentViewController:vc animated:YES completion:NULL];
}

- (BOOL)shouldStartInspector:(HippyBridge *)bridge {
    return bridge.debugMode;
}

- (NSURL *)inspectorSourceURLForBridge:(HippyBridge *)bridge {
    return bridge.bundleURL;
}

- (void)bridge:(HippyBridge *)bridge willLoadBundle:(NSURL *)bundleURL {
    //vendor.ios.js for release and minify=false for debug
    NSString *component = [bundleURL absoluteString];
    if ([component hasSuffix:@"vendor.ios.js"] || [component hasSuffix:@"false"]) {
        NSDictionary *dic1 = @{@"name": @"zs", @"gender": @"male"};
        NSDictionary *dic2 = @{@"name": @"ls", @"gender": @"male"};
        NSDictionary *dic3 = @{@"name": @"ww", @"gender": @"female"};

        NSDictionary *ret = @{@"info1": dic1, @"info2": dic2, @"info3": dic3};
        [bridge addPropertiesToUserGlobalObject:ret];
    }
#ifdef HIPPYDEBUG
#else
    if ([component hasSuffix:@"index.ios.js"]) {
        NSDictionary *dic = @{@"secKey":@"value",
                 @"secNum":@(12),
                 @"secDic": @{@"key1":@"value", @"number": @(2)},
                 @"thrAry":@[@"value1", @"value2", @(3), @[@"vv1", @"vv2"], @{@"k1": @"v1", @"k2": @"v2"}]
        };
        [bridge addPropertiesToUserGlobalObject:dic];
    }
#endif
}

- (void)bridge:(HippyBridge *)bridge endLoadingBundle:(NSURL *)bundle {
    
}

@end