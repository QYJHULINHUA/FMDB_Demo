//
//  ViewController.m
//  FMDB_Demo
//
//  Created by ihefe－hulinhua on 16/3/22.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import "ViewController.h"
#import "IHFDataCache.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *tel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _name.delegate = self;
    _age.delegate  = self;
    _tel.delegate  = self;
    
    if ([IHFDataCache creatTable]) {
        NSLog(@"表创建成功");
    }
    
    if ([IHFDataCache removeAllRecord]) {
        NSLog(@"清空表中所有数据");
    }

    NSArray *ColArr = [IHFDataCache executeColumns];
    if (ColArr) {
        NSLog(@"表字段:  %@",ColArr);
    }
    

    
    

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   return [textField resignFirstResponder];
}

// 插入数据
- (IBAction)testBtn1:(UIButton *)sender {
    
    BOOL isok = [IHFDataCache insetData:_name.text age:_age.text tel:_tel.text];
    if (isok) NSLog(@"插入数据成功");
    else NSLog(@"插入数据失败");
}

// 插入一万条数据
- (IBAction)testBtn2:(UIButton *)sender {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        clock_t start = clock();
        BOOL isok = YES;
        for (int i = 0; i < 1000; i++) {
            isok = [IHFDataCache insetData:_name.text age:_age.text tel:_tel.text];
            if (isok == NO)
            {
                NSLog(@" 数据插入失败");
            }
        }
        
        if (isok) {
            NSLog(@"插入一千次成功_____时间%ld",clock() - start);
        }
    });
    
    
}

// 查询数据
- (IBAction)testBtn3:(UIButton *)sender {
    NSMutableArray *dataArr = [IHFDataCache executeQueryAll];
    
    if (dataArr) {
        NSLog(@"查询data ———— 数目%ld",dataArr.count);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
