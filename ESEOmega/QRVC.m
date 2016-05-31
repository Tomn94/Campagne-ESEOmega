//
//  QRVC.m
//  ESEOmega
//
//  Created by Thomas Naudet on 13/02/2015.
//  Copyright © 2015 Thomas Naudet

//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.

//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see http://www.gnu.org/licenses/
//

#import "QRVC.h"

@implementation QRVC

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        if (!input) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pas d'accès à la caméra"
                                                            message:@"Autorisez ESEOmega dans\nRéglages › Confidentialité › Appareil photo"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            session = [[AVCaptureSession alloc] init];
            if ([session canAddInput:input])
            {
                [session addInput:input];
                
                output = [[AVCaptureMetadataOutput alloc] init];
                [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
                [session addOutput:output];
                output.metadataObjectTypes = [output availableMetadataObjectTypes];
                
                prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
                prevLayer.frame = self.view.bounds;
                prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                [self.view.layer addSublayer:prevLayer];
                
                detectView = [[UIView alloc] init];
                detectView.layer.borderColor = [UIColor colorWithRed:0.000 green:0.88 blue:1.000 alpha:1.000].CGColor;
                detectView.layer.borderWidth = 3;
                [self.view addSubview:detectView];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pas d'accès à la caméra"
                                                                message:@"Autorisez ESEOmega dans\nRéglages › Confidentialité › Appareil photo"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        
        [session startRunning];
    });
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self flashOff];
        [session stopRunning];
    });
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    tapInfos = NO;
    message  = NO;
    
    [self.navigationItem setTitle:@"Scanner un QRcode"];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"flash"]
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(toggleFlash)]];
    UIButton *info = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [info addTarget:self action:@selector(infosTeam) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:info]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(flashOff)
                                                 name:@"flashOff"
                                               object:nil];
    
    captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

- (void)   captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
          fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    
    for (AVMetadataObject *metadata in metadataObjects)
    {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode])
        {
            barCodeObject = (AVMetadataMachineReadableCodeObject *)[prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
            highlightViewRect = barCodeObject.bounds;
            detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            if (![detectionString isEqualToString:lastCheckS] || [NSDate timeIntervalSinceReferenceDate] - lastCheckT > 10)
            {
                [self codeDetecte:detectionString];
                lastCheckS = detectionString;
                lastCheckT = [NSDate timeIntervalSinceReferenceDate];
            }
            break;
        }
    }
    
    detectView.frame = highlightViewRect;
}

- (void) codeDetecte:(NSString *)code
{
    if ([TresorVC jeuDispo] != NSOrderedSame)
        return;
    if (tapInfos)
        return;
    if (message)
        return;
    
    message = YES;
    NSString *team = [[NSUserDefaults standardUserDefaults] objectForKey:@"teamQR"];
    NSURL     *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://176.32.230.7/eseomega.com/qr/scanqr.php?e=%@&c=%@",
                                           [team stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                           [code stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (error == nil)
                                          {
                                              NSString *source = [[NSString alloc] initWithData:data
                                                                                       encoding:NSISOLatin1StringEncoding];
                                              if ([source isEqualToString:@"0"])
                                              {
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bravo !"
                                                                                                  message:@"Vous avez trouvé un QRcode ESEOmega 💪⚡️\nTapez le bouton ⓘ pour visualiser vos points."
                                                                                                 delegate:self
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                                  return;
                                              }
                                              
                                              NSString *titre = @"Erreur inconnue";
                                              if ([source isEqualToString:@"1"])
                                                  titre = @"Le code a déjà été scanné par votre équipe.";
                                              else if ([source isEqualToString:@"2"])
                                                  titre = @"Le code scanné n'est pas reconnu.\n(Tentez-vous de tricher ?!)";
                                              else if ([source isEqualToString:@"4"])
                                                  titre = @"L'équipe n'existe pas.";
                                              
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur du QRcode"
                                                                                              message:titre
                                                                                             delegate:self
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                          }
                                          else
                                          {
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Impossible d'analyser le QRcode"
                                                                                              message:@"Vérifiez que vous avez accès à Internet"
                                                                                             delegate:self
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                          }
                                      }];
    [dataTask resume];
}

- (void) toggleFlash
{
    flash = !flash;
    
    [session beginConfiguration];
    [captureDevice lockForConfiguration:nil];
    [captureDevice setTorchMode:(flash) ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
    [captureDevice unlockForConfiguration];
    [session commitConfiguration];
    
    if (flash)
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"flashSel"]
                                                                                   style:UIBarButtonItemStylePlain
                                                                                  target:self
                                                                                  action:@selector(toggleFlash)]];
    else
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"flash"]
                                                                                   style:UIBarButtonItemStylePlain
                                                                                  target:self
                                                                                  action:@selector(toggleFlash)]];
}

- (void) flashOff
{
    if (flash)
        [self toggleFlash];
}

- (void) infosTeam
{
    if (tapInfos)
        return;
    
    tapInfos = YES;
    NSString *team   = [[NSUserDefaults standardUserDefaults] objectForKey:@"teamQR"];
    NSString *nom    = [[NSUserDefaults standardUserDefaults] objectForKey:@"nomQR"];
    NSString *prenom = [[NSUserDefaults standardUserDefaults] objectForKey:@"prenomQR"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://176.32.230.7/eseomega.com/qr/scoreteam.php?e=%@",
                                       [team stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (error == nil)
                                          {
                                              NSString *source = [[NSString alloc] initWithData:data
                                                                                       encoding:NSISOLatin1StringEncoding];
                                              BOOL pluriel = [source integerValue] > 1;
                                              
                                              CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
                                              NSMutableArray *boutons = [NSMutableArray arrayWithObjects:@"OK", nil];
                                              [alertView setDelegate:self];
                                              [alertView setButtonTitles:boutons];
                                              [alertView setUseMotionEffects:TRUE];
                                              
                                              CGFloat w = [UIScreen mainScreen].bounds.size.width - 70;
                                              UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 355)];
                                              
                                              UILabel *titre = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, w - 20, 70)];
                                              [titre setText:[NSString stringWithFormat:@"%@ %@\n%@\n%@ point%@", prenom, nom, team, source, (pluriel) ? @"s" : @""]];
                                              [titre setTextColor:self.view.tintColor];
                                              [titre setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:17]];
                                              [titre setTextAlignment:NSTextAlignmentCenter];
                                              [titre setNumberOfLines:0];
                                              [customView addSubview:titre];
                                              
                                              UITextView *desc = [[UITextView alloc] initWithFrame:CGRectMake(16, 85, w - 32, 270)];
                                              [desc setText:TXT_LIEUX_QR];
                                              [desc setTextColor:[UIColor darkGrayColor]];
                                              [desc setFont:[UIFont systemFontOfSize:14]];
                                              [desc setBackgroundColor:[UIColor clearColor]];
                                              [desc setEditable:NO];
                                              [customView addSubview:desc];
                                              
                                              [alertView setContainerView:customView];
                                              [alertView show];
                                          }
                                          else
                                          {
                                              CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
                                              NSMutableArray *boutons = [NSMutableArray arrayWithObjects:@"OK", nil];
                                              [alertView setDelegate:self];
                                              [alertView setButtonTitles:boutons];
                                              [alertView setUseMotionEffects:TRUE];
                                              
                                              CGFloat w = [UIScreen mainScreen].bounds.size.width - 70;
                                              UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 355)];
                                              
                                              UILabel *titre = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, w - 20, 50)];
                                              [titre setText:[NSString stringWithFormat:@"%@ %@\n%@\n(nombre de points inconnu)", prenom, nom, team]];
                                              [titre setTextColor:self.view.tintColor];
                                              [titre setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:17]];
                                              [titre setTextAlignment:NSTextAlignmentCenter];
                                              [titre setNumberOfLines:0];
                                              [customView addSubview:titre];
                                              
                                              UITextView *desc = [[UITextView alloc] initWithFrame:CGRectMake(16, 65, w - 32, 290)];
                                              [desc setText:TXT_LIEUX_QR];
                                              [desc setTextColor:[UIColor darkGrayColor]];
                                              [desc setFont:[UIFont systemFontOfSize:14]];
                                              [desc setBackgroundColor:[UIColor clearColor]];
                                              [desc setEditable:NO];
                                              [customView addSubview:desc];
                                              
                                              [alertView setContainerView:customView];
                                              [alertView show];
                                          }
                                      }];
    [dataTask resume];
}

- (void)        alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    message = NO;
}

- (void) customIOS7dialogButtonTouchUpInside:(id)alertView
                        clickedButtonAtIndex:(NSInteger)buttonIndex
{
    tapInfos = NO;
    [alertView close];
}

@end
