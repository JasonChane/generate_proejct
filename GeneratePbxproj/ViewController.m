//
//  ViewController.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/8.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "ViewController.h"
#import "CreateFile.h"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [CreateFile createProject];
    
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
