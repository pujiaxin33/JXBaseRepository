//
//  BaseTableViewCell.m
//  BaseRepository
//
//  Created by jiaxin on 2018/3/6.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell()

@property (nonatomic, strong) CALayer *bottomLineLayer;

@end

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.lineView.top = self.height - 1;
    self.bottomLineLayer.frame = CGRectMake(self.bottomLineLayer.frame.origin.x,
                                            self.bottomLineLayer.frame.origin.y,
                                            self.frame.size.width,
                                            self.bottomLineLayer.frame.size.height);

}

- (void)initView
{
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame] ;
    self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];

    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = backgroundView;

    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
    self.bottomLineLayer = [CALayer layer];
    self.bottomLineLayer.backgroundColor = kLineColor.CGColor;
    self.bottomLineLayer.frame = CGRectMake(0, self.height-kLineHeight, self.width, kLineHeight);
    [self.layer addSublayer:self.bottomLineLayer];

    [self addSubview:self.lineView];

    self.separatorInsets = 0;
}

- (void)setSeparatorInsets:(float)separatorInsets
{
    _separatorInsets = separatorInsets;
    self.lineView.left = self.separatorInsets;
    self.lineView.top = self.height - 1;
}

@end
