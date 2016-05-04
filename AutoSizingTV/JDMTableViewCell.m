//
//  JDMTableViewCell.m
//  AutoSizingTV
//
//  Created by Justin Madewell on 8/17/15.
//  Copyright © 2015 Justin Madewell. All rights reserved.
//

#import "JDMTableViewCell.h"

@implementation JDMTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.textLabel.textAlignment = NSTextAlignmentRight;
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.separatorInset = UIEdgeInsetsMake(8, 8, 8, 8);
        
        
        [[self contentView] addConstraints:[self makeConstraints]];
        
        
        

        
    }
    
    return self;
}



-(NSArray*)makeConstraints
{
    
    NSMutableArray *c  = [[NSMutableArray alloc]init];
    
    
    [c addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[imageView]-[textLabel]-|" options:0 metrics:nil views:@{@"textLabel":self.textLabel,@"imageView" : self.imageView}]];
    
    [c addObjectsFromArray:@[
                             
                             [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeFirstBaseline relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:30],
                             
                             [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.textLabel attribute:NSLayoutAttributeBaseline multiplier:1.0 constant:30],
                             
                            [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:0 multiplier:1.0 constant:44.0],
                             
                             [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.75/3.0 constant:0.0],
                             
                             [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeWidth multiplier:0.95 constant:0.0],
                             
                             [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
                             
                             
                             ]];
    
    return c;
    
}


- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    self.textLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.textLabel.frame);

}



@end
