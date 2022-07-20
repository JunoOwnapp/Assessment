//
//  View1TableViewCell.m
//  Stock Portfolio
//
//  Created by Juno Chen Kwan Lok on 20/07/2022.
//

#import "View1TableViewCell.h"

@implementation View1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
