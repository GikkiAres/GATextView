//
//  GATextView.m
//  GATextView
//
//  Created by GikkiAres on 9/23/16.
//  Copyright © 2016 GikkiAres. All rights reserved.
//

#import "GATextView.h"

static const int PlaceholderHorizontalPadding = 5;
static const int PlaceholderVerticalPadding = 8;


@interface GATextView()<UITextViewDelegate>




@end


@implementation GATextView

#pragma mark 1 init

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangedNotificationHandler:) name:UITextViewTextDidChangeNotification object:self];
    self.borderColor = [UIColor lightGrayColor];
    self.placeholderColor = [UIColor lightGrayColor];
    self.delegate = self;
    self.maxTextLength = -1;
    self.borderWidth = 1;

}

#pragma mark 2 xib预览
- (void)prepareForInterfaceBuilder {
    [self setNeedsDisplay];
}

#pragma mark 3 字符改变刷新

- (void)drawRect:(CGRect)rect {
    if (self.hasText) {
        [super drawRect:rect];
    }else{
        //采用画的方式得到placeholder文字,采用自身的字体和灰色的颜色
        NSMutableDictionary *attr = [NSMutableDictionary dictionary];
        attr[NSFontAttributeName] = self.font;
        attr[NSForegroundColorAttributeName] = self.placeholderColor;
        CGRect placeholderRect = CGRectMake(PlaceholderHorizontalPadding, PlaceholderVerticalPadding, rect.size.width - PlaceholderHorizontalPadding*2, rect.size.height - PlaceholderVerticalPadding*2);
        [self.placeholder drawInRect:placeholderRect withAttributes:attr];
    }
    self.layer.borderColor = [self.borderColor CGColor];
    self.layer.borderWidth = self.borderWidth;
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.masksToBounds = YES;
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark getter,setter
- (void)setAutoAdjustHeight:(BOOL)autoAdjustHeight {
    _autoAdjustHeight = autoAdjustHeight;
    self.scrollEnabled = !_autoAdjustHeight;
    [self adjustHeight];
}

#pragma mark 4 通知处理

- (void)textChangedNotificationHandler:(NSNotification *)notification {
    [self setNeedsDisplay];
    //进行字数限制
    if (_maxTextLength !=-1) {
    NSString *lang = [[self.nextResponder textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (self.text.length > self.maxTextLength) {
                self.text = [self.text substringToIndex:self.maxTextLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (self.text.length > self.maxTextLength) {
            self.text = [ self.text substringToIndex:self.maxTextLength];
        }
    }
    }
    [self adjustHeight];

    
}

- (void)adjustHeight {
    //根据现在的text更新计算高度,如果是空的,就返回一行的高度
    if(self.text.length==0) {
        self.calculatedTextHeight = [@" " boundingRectWithSize:CGSizeMake(self.bounds.size.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size.height;
    }
    else {
        self.calculatedTextHeight =  [self sizeThatFits:self.frame.size].height;
    }
    //自动变化
    if(_autoAdjustHeight) {
        CGRect frame = self.frame;
        frame.size.height = _calculatedTextHeight;
        self.frame = frame;
    }
}



@end
