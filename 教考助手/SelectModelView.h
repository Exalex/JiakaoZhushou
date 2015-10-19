//
//  SelectModelView.h
//  教考助手
//
//  Created by Alex on 15/10/19.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
//状态枚举
typedef enum {
    testModel,
    lookingModel
}SelectModel;
typedef void (^SelectTouch)(SelectModel model);
@interface SelectModelView : UIView
@property (nonatomic,assign)SelectModel model;
-(SelectModelView *)initWithFrame:(CGRect)frame addTouch:(SelectTouch)touch;
@end
