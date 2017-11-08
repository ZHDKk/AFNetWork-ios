//
//  BookModel.h
//  AFNetwork
//
//  Created by zh dk on 2017/8/31.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookModel : NSObject
//书籍实体类
@property (retain,nonatomic) NSString *bookName;
@property (retain,nonatomic) NSString *bookPrice;
@property (retain,nonatomic) NSString *bookPublisher;
@property (retain,nonatomic) NSString *author;
@property (retain,nonatomic) NSString *Score;
@end
