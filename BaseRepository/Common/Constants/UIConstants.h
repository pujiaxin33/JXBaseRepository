//
//  UIConstants.h
//  BaseRepository
//
//  Created by jiaxin on 2018/3/6.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#define WindowsSize                  [UIScreen mainScreen].bounds.size

#define kLineHeight                 1./[UIScreen mainScreen].scale


#define ImageWithName(name)         [UIImage imageNamed:name]


#define kLineColor                   COLOR_WITH_HEX(0xf0f0f7, 1.0f)

#define COLOR_WITH_RGB(r,g,b,a)      [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]
#define COLOR_WITH_HEX(rgbValue,a)   COLOR_WITH_RGB((float)((rgbValue & 0xFF0000) >> 16),(float)((rgbValue & 0xFF00) >> 8),(float)(rgbValue & 0xFF),a)
