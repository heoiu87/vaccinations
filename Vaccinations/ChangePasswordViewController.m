//
//  ChangePasswordViewController.m
//  Vaccinations
//
//  Created by Subash Dantuluri on 11/5/13.
//  Copyright (c) 2013 Subash Dantuluri. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "AppDelegate.h"

//#define kGetUrlToChangePassword @"http://192.168.1.72/changePhysicianPassword.php"
NSString *kGetUrlToChangePassword;

#define kuser_id @"user_id"

#define kpassword @"password"

#define knew_password @"new_password"


@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

@synthesize Password_Current;
@synthesize Password_New;
@synthesize Reenter_NewPassword;
@synthesize physician;
@synthesize user_id;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"Inside Change Password, physician ID: %@", physician);
   kGetUrlToChangePassword = [[NSString alloc] initWithFormat:@"http://%@/changePhysicianPassword.php", gServerIp];
   NSLog(@"kGetUrlToChangePassword: %@", kGetUrlToChangePassword);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(id)sender {
    [self.view removeFromSuperview];
}

- (IBAction)changePassword:(id)sender {
    // Check if all required fields have been filled
    if ([Password_Current.text  isEqual: @""] || [Password_New.text  isEqual: @""]
        || [Reenter_NewPassword.text  isEqual: @""] ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please fill in all required fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    } else {
       
        // Check if new passwords match
        if (![[Password_New text] isEqualToString: [Reenter_NewPassword text]]) {
            UIAlertView *passwordNotMatch = [[UIAlertView alloc] initWithTitle:@"Passwords Not Match" message:@"The new passwords don't match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [passwordNotMatch show];
        }
        // Check if new password is different to current password
        else if ([[Password_Current text] isEqualToString:[Password_New text]]) {
                UIAlertView *passwordHasBeenUsed = [[UIAlertView alloc] initWithTitle:@"Invalid input" message:@"The new password is the same as the current password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [passwordHasBeenUsed show];
        }
        // When all the inputs seem right, then we connect to the database to update the password
        else {
            NSMutableString *postString = [NSMutableString stringWithString:kGetUrlToChangePassword];
            [postString appendString:[NSString stringWithFormat:@"?%@=%@", kuser_id, user_id]];
            
            [postString appendString:[NSString stringWithFormat:@"&%@=%@", kpassword, [Password_Current text]]];
            [postString appendString:[NSString stringWithFormat:@"&%@=%@", knew_password, [Password_New text]]];
            
            NSLog(@"%@",postString);
            
            [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSURL *url = [NSURL URLWithString:postString];
            NSLog(@"This is the GET string for the Change Physician password: %@", url);
            
            NSString *postResult = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            
            // Check the result from database
            if ([postResult isEqualToString:@"Cannot update your password! Your current password is invalid."]) {
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Fail to update password" message:postResult delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [failAlert show];
                return;
                
            } else {
                UIAlertView *successfulAlert = [[UIAlertView alloc] initWithTitle:@"Successfully!" message:postResult delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [successfulAlert show];
                return;
                
                NSLog(@"Username has been created successfully.");
            }// End if-else Check result from database.
            
        }// End if-else When all the inputs seem right.

    } // End Check if all required fields have been filled.
    
     
}// End Change Password method

    


@end
