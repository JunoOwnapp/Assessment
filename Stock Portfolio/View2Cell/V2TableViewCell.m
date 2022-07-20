//
//  V2TableViewCell.m
//  Stock Portfolio
//
//  Created by Juno Chen Kwan Lok on 20/07/2022.
//

#import "V2TableViewCell.h"

@implementation V2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLbl.layer.cornerRadius = 2;
    self.titleLbl.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.titleLbl.layer.borderWidth = 1;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellData:(V2TBData *)data{
    self.titleLbl.text = [NSString stringWithFormat:@" %@ ",[data.title capitalizedString]];
    self.currentYearLbl.text = data.year1;
    self.previousYearLbl.text = data.year2;
}

@end

@implementation V2TBData

@end
