//
//  main.m
//  EasyMagicChartDemo
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 Leonidas. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <KSCrash/KSCrash.h>
// Include to use the email reporter.
#import <KSCrash/KSCrashInstallationEmail.h>


//void installKSCrash(int i);
void installKSCrash(int i){
    printf("%d", i);
    [[KSCrash sharedInstance] install];

    KSCrashInstallationEmail *emailInstallation = [KSCrashInstallationEmail sharedInstance];
    emailInstallation.recipients = @[@"153s8392301@qq.com"];
    [emailInstallation setReportStyle:KSCrashEmailReportStyleApple useDefaultFilenameFormat:YES];
    emailInstallation.subject = @"subject:  test";
    emailInstallation.message = @"message:  test";

    [emailInstallation install];

    
    
}
int main(int argc, const char * argv[]) {
    installKSCrash(123456);
    return NSApplicationMain(argc, argv);
}


