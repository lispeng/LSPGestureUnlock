//
//  LSPLockView.h
//  手势解锁
//
//  Created by mac on 15-9-17.
//  Copyright (c) 2015年 Lispeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSPLockView;
@protocol LSPLockViewdelegate <NSObject>

@optional

- (void)lockView:(LSPLockView *)lockView didFinishPath:(NSString *)path;

@end
@interface LSPLockView : UIView

@property (nonatomic, assign) IBOutlet id<LSPLockViewdelegate> delegate;

@end
