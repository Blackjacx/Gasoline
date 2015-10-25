//
//  ViewController.m
//  Gazz
//
//  Created by Stefan Herold on 17/09/15.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

// TODO: Save the date with a standardized time 12:00 afternoon
// TODO: Implement input checking using shouldChangeCharactersInRange
// TODO: Display of all records in a list
// TODO: Make the record list editable

// TODO: Taking Picture of the bill
// TODO: Localize all strings
// TODO: Use a scroll view to display the content
// TODO: Convert Pictures to b&w images to save space
// TODO: Offer to crop image to save space
// TODO: Migrate to core data
// TODO: OCR mileage in the car via camera

// TODO: put a next/done button on the num keypad
// TODO: Make fonts dark gray: 30, 60, ...
// TODO: Realize rows as table cells
// TODO: Hide picker inside cell
// TODO: Check the Date 22:00 after changing dateii


#import "ViewController.h"

typedef NS_ENUM(NSInteger, AlertViewTag) {
    AlertViewTagSaveConfirmation
};


NSString *kGazzUserDefaultsRecordList = @"kGazzUserDefaultsRecordList";

NSString *kGazzUserDefaultsRecordDictionaryItemId = @"kGazzUserDefaultsRecordDictionaryItemId";
NSString *kGazzUserDefaultsRecordDictionaryItemDate = @"kGazzUserDefaultsRecordDictionaryItemDate";
NSString *kGazzUserDefaultsRecordDictionaryItemTotalCosts = @"kGazzUserDefaultsRecordDictionaryItemTotalCosts";
NSString *kGazzUserDefaultsRecordDictionaryItemPricePerLiter = @"kGazzUserDefaultsRecordDictionaryItemPricePerLiter";
NSString *kGazzUserDefaultsRecordDictionaryItemLiterAmount = @"kGazzUserDefaultsRecordDictionaryItemLiterAmount";
NSString *kGazzUserDefaultsRecordDictionaryItemKilometer = @"kGazzUserDefaultsRecordDictionaryItemKilometer";

@interface ViewController () <UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *totalCostsLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricePerLiterLabel;
@property (weak, nonatomic) IBOutlet UILabel *literAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *kilometerAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UITextField *totalCostsEuroTextField;
@property (weak, nonatomic) IBOutlet UITextField *totalCostsCentTextField;
@property (weak, nonatomic) IBOutlet UITextField *pricePerLiterEuroTextField;
@property (weak, nonatomic) IBOutlet UITextField *pricePerLiterCentTextField;
@property (weak, nonatomic) IBOutlet UITextField *literAmountLiterTextField;
@property (weak, nonatomic) IBOutlet UITextField *literAmountCentiliterTextField;
@property (weak, nonatomic) IBOutlet UITextField *kilometerAmountTextField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.datePicker.maximumDate = [NSDate date];
    
    [self datePickerDidFinish:self.datePicker];
}

- (IBAction)onBackgroundTap:(id)sender {
    UIView *firstResponder = nil;
    
    if (self.view.isFirstResponder) {
        firstResponder = self.view;
    }
    else {
        for (UIView *subView in self.view.subviews) {
            if ([subView isFirstResponder]) {
                firstResponder = subView;
                break;
            }
        }
    }
    
    [firstResponder resignFirstResponder];
}

- (NSUInteger)recordCount {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:kGazzUserDefaultsRecordList] count];
}

- (IBAction)datePickerDidFinish:(UIDatePicker*)datePicker {
    self.dateLabel.text = [NSString stringWithFormat:@"%@ (%zd)", datePicker.date.description, [self recordCount]];
}

- (IBAction)onSave:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gz.createEntryViewController.saveAlert.title", @"Title of the alert view where users can confirm saving of the current entry.") message:NSLocalizedString(@"gz.createEntryViewController.saveAlert.message", @"Message of the alert view where users can confirm saving of the current entry.") delegate:self cancelButtonTitle:NSLocalizedString(@"gz.general.noButton.title", @"No button text") otherButtonTitles:NSLocalizedString(@"gz.general.yesButton.title", @"Yes button text"), nil];
    alert.tag = AlertViewTagSaveConfirmation;
    [alert show];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.totalCostsEuroTextField) {
        [self.totalCostsCentTextField becomeFirstResponder];
    }
    else if(textField == self.totalCostsCentTextField) {
        [self.pricePerLiterEuroTextField becomeFirstResponder];
    }
    else if(textField == self.pricePerLiterEuroTextField) {
        [self.pricePerLiterCentTextField becomeFirstResponder];
    }
    else if(textField == self.pricePerLiterCentTextField) {
        [self.literAmountLiterTextField becomeFirstResponder];
    }
    else if(textField == self.literAmountLiterTextField) {
        [self.literAmountCentiliterTextField becomeFirstResponder];
    }
    else if(textField == self.literAmountCentiliterTextField) {
        [self.kilometerAmountTextField becomeFirstResponder];
    }
    else if(textField == self.kilometerAmountTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertViewTagSaveConfirmation) {
        if (alertView.cancelButtonIndex != buttonIndex) {
            [self performSave];
        }
    }
}


#pragma mark - Saving Entries

- (void)performSave {    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *dataRecordList = [NSMutableArray arrayWithArray:[defaults objectForKey:kGazzUserDefaultsRecordList]];
    NSDictionary *newData = @{
                              kGazzUserDefaultsRecordDictionaryItemId:[NSUUID UUID].UUIDString,
                              kGazzUserDefaultsRecordDictionaryItemDate:self.datePicker.date,
                              kGazzUserDefaultsRecordDictionaryItemTotalCosts:@([[NSString stringWithFormat:@"%@.%@", self.totalCostsEuroTextField.text, self.totalCostsCentTextField.text] floatValue]),
                              kGazzUserDefaultsRecordDictionaryItemPricePerLiter:@([[NSString stringWithFormat:@"%@.%@", self.pricePerLiterEuroTextField.text, self.pricePerLiterCentTextField.text] floatValue]),
                              kGazzUserDefaultsRecordDictionaryItemLiterAmount:@([[NSString stringWithFormat:@"%@.%@", self.literAmountLiterTextField.text, self.literAmountCentiliterTextField.text] floatValue]),
                              kGazzUserDefaultsRecordDictionaryItemKilometer:@(self.kilometerAmountTextField.text.floatValue)};
    [dataRecordList addObject:newData];
    [defaults setObject:dataRecordList forKey:kGazzUserDefaultsRecordList];
    [defaults synchronize];
    
    [self datePickerDidFinish:self.datePicker];
}


@end
