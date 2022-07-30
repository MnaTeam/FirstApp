//
//  ViewController.m
//  TestXCProj
//
//  Created by kevinhao on 2022/7/30.
//

#import "ViewController.h"
#import <LibMnaLog/MnaShareLog.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MnaLogDebug(@"MnaLogDebug test");
}


@end
