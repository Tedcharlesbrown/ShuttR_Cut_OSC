#include "A_ofApp.h"


//--------------------------------------------------------------
// MARK: ---------- XML----------
//--------------------------------------------------------------

void ofApp::saveXML() {
    XML.setValue("settings::ip", inputIP);
    XML.setValue("settings::id", inputID);
    XML.saveFile( ofxiOSGetDocumentsDirectory() + "settings.xml" );
    XML.saveFile( "settings.xml" );
}

//--------------------------------------------------------------

void ofApp::getXML() {
    if( XML.loadFile(ofxiOSGetDocumentsDirectory() + "settings.xml") ){
        message = "settings.xml loaded from documents folder!";
    }else if( XML.loadFile("settings.xml") ){
        message = "settings.xml loaded from data folder!";
    }else{
        message = "unable to load settings.xml check data/ folder";
    }
    
    inputIP = XML.getValue("settings::ip", "");
    inputID = XML.getValue("settings::id", "1");
}

//--------------------------------------------------------------
// MARK: ---------- IP ADDRESS ----------
//--------------------------------------------------------------

string ofApp::getIPAddress() {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    string ip = ofxNSStringToString(address);
    if (ip == "error") {
        ip = "CHECK WIFI";
        hasWifi = false;
    } else {
        hasWifi = true;
    }
    return ip;
}

//--------------------------------------------------------------
// MARK: ---------- IPHONE NOTCH HEIGHT ----------
//--------------------------------------------------------------

void ofApp::getNotchHeight() {
    
    string deviceName = ofxiOSGetDeviceRevision();
    if (deviceName.find("iPhone") != std::string::npos) { //DEVICE IS IPHONE
        int indexValueEnd = deviceName.find(",");
        int iPhoneGeneration = ofToInt(deviceName.substr(6, indexValueEnd - 6)); //GET DEVICE GENERATION
        int iPhoneVersion = ofToInt(deviceName.substr(indexValueEnd + 1)); //GET DEVICE VERSION
        int iPhoneID = iPhoneGeneration * 10 + iPhoneVersion; //SET ID TO GENERATION.VERSION NUMBER
        
        //        iPhoneID = 101; //IPHONE 8
        //        iPhoneID = 102; //IPHONE 8+ //5.5inch screenshot
        //        iPhoneID = 123; //IPHONE PRO + PRO MAX //6.5inch screenshot
        
        switch(iPhoneID) {
            case 11: //iPhone           - 1x
            case 12: //iPhone3G         - 1x
            case 21: //iPhone3Gs        - 1x
                notchHeight = 22;
                break;
            case 31: //iPhone4          - 2x
            case 32: //iPhone4 GSM      - 2x
            case 33: //iPhone4 CDMA     - 2x
            case 41: //iPhone4s         - 2x
            case 51: //iPhone5_GSM      - 2x
            case 52: //iPhone5_CMDA     - 2x
            case 53: //iPhone5c_GSM     - 2x
            case 54: //iPhone5c         - 2x
            case 61: //iPhone5s_GSM     - 2x
            case 62: //iPhone5s         - 2x
                notchHeight = 44;
                break;
            case 71: //iPhone6_Plus     - 3x
                notchHeight = 66;
                break;
            case 72: //iPhone6          - 2x
            case 81: //iPhone6s         - 2x
                notchHeight = 44;
                break;
            case 82: //iPhone6s_Plus    - 3x
                notchHeight = 66;
                break;
            case 84: //iPhoneSE         - 2x
            case 91: //iPhone7          - 2x
                notchHeight = 44;
                break;
            case 92: //iPhone7_Plus     - 3x
                notchHeight = 66;
                break;
            case 93: //iPhone7_Alt      - 2x
                notchHeight = 44;
                break;
            case 94: //iPhone7_Plus_Alt - 3x
                notchHeight = 66;
                break;
            case 101: //iPhone8         - 2x
                notchHeight = 44;
                break;
            case 102: //iPhone8_Plus    - 3x
                notchHeight = 66;
                break;
            case 103: //iPhoneX         - 3x - NOTCH
                notchHeight = 132;
                break;
            case 104: //iPhone8_Alt     - 2x
                notchHeight = 44;
                break;
            case 105: //iPhone8_Plus    - 3x
                notchHeight = 66;
                break;
            case 106: //iPhoneX_GSM     - 3x - NOTCH
            case 112: //iPhoneXS        - 3x - NOTCH
            case 114: //iPhoneXS_Max    - 3x - NOTCH
            case 116: //iPhoneXS_Max_A  - 3x - NOTCH
                notchHeight = 132;
                break;
            case 118: //iPhoneXR        - 2x - NOTCH
            case 121: //iPhone11        - 2x - NOTCH
                notchHeight = 88;
                break;
            case 123: //iPhone11_Pro    - 3x - NOTCH
            case 125: //iPhone11_ProMax - 3x - NOTCH
                notchHeight = 132;
                break;
            case 128: //iPhoneSE_2ndGen - 2x
                notchHeight = 44;
                break;
            default:
                notchHeight = 44;
        }
    } else if (deviceName.find("iPad") != std::string::npos) {
        int indexValueEnd = deviceName.find(",");
        int iPhoneGeneration = ofToInt(deviceName.substr(6, indexValueEnd - 6)); //GET DEVICE GENERATION
        int iPhoneVersion = ofToInt(deviceName.substr(indexValueEnd + 1)); //GET DEVICE VERSION
        int iPhoneID = iPhoneGeneration * 10 + iPhoneVersion; //SET ID TO GENERATION.VERSION NUMBER
        
        switch(iPhoneID) {
            case 11: // iPad
            case 12: // iPad 3G
            case 21: // 2nd Gen iPad
            case 22: // 2nd Gen iPad GSM
            case 23: // 2nd Gen iPad CDMA
            case 24: // 2nd Gen iPad New Revision
            case 25: // iPad mini
            case 26: // iPad mini GSM+LTE
            case 27: // iPad mini CDMA+LTE
                notchHeight = 22;
                break;
            case 31: // 3rd Gen iPad
            case 32: // 3rd Gen iPad CDMA
            case 33: // 3rd Gen iPad GSM
            case 34: // 4th Gen iPad
            case 35: // 4th Gen iPad GSM+LTE
            case 36: // 4th Gen iPad CDMA+LTE
            case 41: // iPad Air (WiFi)
            case 42: // iPad Air (GSM+CDMA)
            case 43: // 1st Gen iPad Air (China)
            case 44: // iPad mini Retina (WiFi)
            case 45: // iPad mini Retina (GSM+CDMA)
            case 46: // iPad mini Retina (China)
            case 47: // iPad mini 3 (WiFi)
            case 48: // iPad mini 3 (GSM+CDMA)
            case 49: // iPad Mini 3 (China)
            case 51: // iPad mini 4 (WiFi)
            case 52: // 4th Gen iPad mini (WiFi+Cellular)
            case 53: // iPad Air 2 (WiFi)
            case 54: // iPad Air 2 (Cellular)
            case 63: // iPad Pro (9.7 inch, WiFi)
            case 64: // iPad Pro (9.7 inch, WiFi+LTE)
            case 67: // iPad Pro (12.9 inch, WiFi)
            case 68: // iPad Pro (12.9 inch, WiFi+LTE)
            case 611: // iPad (2017)
            case 612: // iPad (2017)
            case 71: // iPad Pro 2nd Gen (WiFi)
            case 72: // iPad Pro 2nd Gen (WiFi+Cellular)
            case 73: // iPad Pro 10.5-inch
            case 74: // iPad Pro 10.5-inch
            case 75: // iPad 6th Gen (WiFi)
            case 76: // iPad 6th Gen (WiFi+Cellular)
            case 711: // iPad 7th Gen 10.2-inch (WiFi)
            case 712: // iPad 7th Gen 10.2-inch (WiFi+Cellular)
            case 81: // iPad Pro 11 inch (WiFi)
            case 82: // iPad Pro 11 inch (1TB, WiFi)
            case 83: // iPad Pro 11 inch (WiFi+Cellular)
            case 84: // iPad Pro 11 inch (1TB, WiFi+Cellular)
            case 85: // iPad Pro 12.9 inch 3rd Gen (WiFi)
            case 86: // iPad Pro 12.9 inch 3rd Gen (1TB, WiFi)
            case 87: // iPad Pro 12.9 inch 3rd Gen (WiFi+Cellular)
            case 88: // iPad Pro 12.9 inch 3rd Gen (1TB, WiFi+Cellular)
            case 89: // iPad Pro 11 inch 2nd Gen (WiFi)
            case 111: // iPad mini 5th Gen (WiFi)
            case 112: // iPad mini 5th Gen
            case 113: // iPad Air 3rd Gen (WiFi)
            case 114: // iPad Air 3rd Gen
            case 810: // iPad Pro 11 inch 2nd Gen (WiFi+Cellular)
            case 811: // iPad Pro 12.9 inch 4th Gen (WiFi)
            case 812: // iPad Pro 12.9 inch 4th Gen (WiFi+Cellular)
                notchHeight = 44;
                break;
        }
    } else if (deviceName.find("iPod") != std::string::npos) {
        int indexValueEnd = deviceName.find(",");
        int iPhoneGeneration = ofToInt(deviceName.substr(6, indexValueEnd - 6)); //GET DEVICE GENERATION
        int iPhoneVersion = ofToInt(deviceName.substr(indexValueEnd + 1)); //GET DEVICE VERSION
        int iPhoneID = iPhoneGeneration * 10 + iPhoneVersion; //SET ID TO GENERATION.VERSION NUMBER
        
        switch(iPhoneID) {
            case 11: // 1st Gen iPod
            case 21: // 2nd Gen iPod
            case 31: // 3rd Gen iPod
                notchHeight = 22;
                break;
            case 41: // 4th Gen iPod
            case 51: // 5th Gen iPod
            case 71: // 6th Gen iPod
            case 91: // 7th Gen iPod
                notchHeight = 44;
                break;
        }
    }
}
