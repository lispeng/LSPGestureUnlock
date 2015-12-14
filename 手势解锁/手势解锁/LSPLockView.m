//
//  LSPLockView.m
//  手势解锁
//
//  Created by mac on 15-9-17.
//  Copyright (c) 2015年 Lispeng. All rights reserved.
//

#import "LSPLockView.h"
@interface LSPLockView()

@property (strong,nonatomic) NSMutableArray *lockBtns;

@property (strong,nonatomic) NSMutableArray *selectedBtns;

@property (nonatomic, assign) CGPoint movePoint;
@end
@implementation LSPLockView

- (NSMutableArray *)lockBtns
{
    if (_lockBtns == nil) {
        
        _lockBtns = [NSMutableArray array];
    }
    return _lockBtns;
}

- (NSMutableArray *)selectedBtns
{
    if (_selectedBtns == nil) {
        
        _selectedBtns = [NSMutableArray array];
    }
    return _selectedBtns;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super init]) {
        
        [self setupBtn];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setupBtn];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)layoutSubviews
{
    for (int index = 0; index < self.lockBtns.count; index ++) {
        
        UIButton *subBtn = self.lockBtns[index];
        
        CGFloat subBtnW = 74;
        CGFloat subBtnH = subBtnW;
        
        CGFloat margin = (self.frame.size.width - subBtnW * 3) * 0.25;
        
        int vocMargin = index % 3;
        int hovMargin = index / 3;
        CGFloat subBtnX = margin +(margin + subBtnW) * vocMargin;
        CGFloat subBtnY = margin + (margin + subBtnH) * hovMargin;
        
        subBtn.frame = CGRectMake(subBtnX, subBtnY, subBtnW, subBtnH);
        [self addSubview:subBtn];
    }
    
    
}

- (CGPoint)pointWithTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:touch.view];
    
    return point;
}

- (UIButton *)captureWithPoint:(CGPoint)point
{
    for(UIButton *btn in self.subviews)
    {
        if (CGRectContainsPoint(btn.frame, point)) {
            
            return btn;
        }
    }
    return nil;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    self.movePoint = CGPointZero;
    
    CGPoint point = [self pointWithTouches:touches];
    
    UIButton *btn = [self captureWithPoint:point];
    
    if (btn && btn.selected == NO) {
        
        
        btn.selected = YES;
        
        [self.selectedBtns addObject:btn];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [self pointWithTouches:touches];
    
    UIButton *btn = [self captureWithPoint:point];
    
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectedBtns addObject:btn];
    }
    else
    {
        self.movePoint = point;
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if(self.selectedBtns.count == 0) return;
    
       if ([self.delegate respondsToSelector:@selector(lockView:didFinishPath:)]) {
           NSMutableString *path = [NSMutableString string];
           for(UIButton *selectedBtn in self.selectedBtns)
           {
               [path appendFormat:@"%ld",selectedBtn.tag];
           }

        [self.delegate lockView:self didFinishPath:path];
    }
    for(UIButton *btn in self.selectedBtns)
    {
        //btn.selected == NO;
        [btn setSelected:NO];
    }
    //[self.selectedBtns makeObjectsPerformSelector:@selector(setSelector:) withObject:@(NO)];
    [self.selectedBtns removeAllObjects];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}


- (void)drawRect:(CGRect)rect
{
    
    if(self.selectedBtns.count == 0) return;
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int index = 0;index < self.selectedBtns.count; index ++) {
        
        UIButton *btn = self.selectedBtns[index];
        if (index == 0) {
            
            [path moveToPoint:btn.center];
        }
        else
        {
            [path addLineToPoint:btn.center];
        }
    }
    if (CGPointEqualToPoint(self.movePoint, CGPointZero) == NO) {
        
        [path addLineToPoint:self.movePoint];
    }
    
    
    [path setLineWidth:8];
    [[UIColor colorWithRed:32/255.0 green:210/255.0 blue:254/255.0 alpha:0.5] set];
    [path setLineJoinStyle:kCGLineJoinBevel];
    [path stroke];
}
- (void)setupBtn
{
    for (int index = 0; index < 9; index ++) {
        
        
        UIButton *lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lockBtn.tag = index;
        lockBtn.userInteractionEnabled = NO;
        [lockBtn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [lockBtn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
       // lockBtn.backgroundColor = [UIColor orangeColor];
        [self.lockBtns addObject:lockBtn];
        
    }
    
}
@end
