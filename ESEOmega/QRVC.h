//
//  QRVC.h
//  ESEOmega
//
//  Created by Thomas Naudet on 10/02/2015.
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

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TresorVC.h"
#import "CustomIOS7AlertView.h"

#define TXT_LIEUX_QR @"7 QRcodes faciles (2 points) :\n\
- La salle de l’impulsion de…\n\
- Un peu de sport ! Montez 75 marches.\n\
- À côté du monte-charge comme dirait Jérôme !\n\
- La raie du (cin)q.\n\
- Poséidon, Hadès et Midas en détiennent un chacun.\n\n\
6 QRcodes moyens (4 points) :\n\
- Quand tu veux retirer de l’argent pour aller à la Trinquette.\n\
- La fontaine à embrouille, heureusement on peut s’y faire pardonner pas très loin.\n\
- La porte de Zeus.\n\
- Dionysos se rend régulièrement dans cette rue pour se désaltérer.\n\
- RU Croix Rouge.\n\
- L’endroit pour mater et faire semblant de travailler.\n\n\
5 QRcodes pour les dieux (6 points) :\n\
- Place du marché le mardi matin.\n\
- L’ancien bercail.\n\
- Sous Confluence.\n\
- Martin y va tous les ans.\n\
- La colonne 11A, j’optimisme.\n\
\n\
+ 2 pts si tous les défis moyens réalisés\n\
+ 4 pts si tous les défis difficiles réalisés\n"

@interface QRVC : UIViewController <AVCaptureMetadataOutputObjectsDelegate, CustomIOS7AlertViewDelegate, UIAlertViewDelegate>
{
    AVCaptureVideoPreviewLayer *prevLayer;
    AVCaptureMetadataOutput *output;
    AVCaptureDevice *captureDevice;
    AVCaptureSession *session;
    NSTimeInterval lastCheckT;
    NSString *lastCheckS;
    UIView *detectView;
    BOOL tapInfos;
    BOOL message;
    BOOL flash;
}

- (void) codeDetecte:(NSString *)code;
- (void) toggleFlash;
- (void) flashOff;
- (void) infosTeam;

@end
