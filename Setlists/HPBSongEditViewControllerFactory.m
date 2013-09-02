//
//  HPBSongEditViewControllerFactory
//  JamNotes
//
//  Created by Phil Christensen on 9/2/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "HPBSongEditViewControllerFactory.h"

#import <QuickDialog/QuickDialog.h>

@implementation HPBSongEditViewControllerFactory

+ (UIViewController*) viewController {
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"Hello World";
    root.grouped = YES;
    QSection *section = [[QSection alloc] init];
    QLabelElement *label = [[QLabelElement alloc] initWithTitle:@"Hello" Value:@"world!"];
    
    [root addSection:section];
    [section addElement:label];
    
    UIViewController* controller = [QuickDialogController controllerForRoot:root];
    return controller;
}

@end
