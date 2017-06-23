//
//  SoapHelper.m
//  WebServiceDemo
//
//  Created by niit on 16/3/31.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "SoapHelper.h"

#import "TBXML.h"

#define kAppKey @"fb29edb2b6474e7598ffd805f8b0264a"

@implementation SoapHelper

// 需要创建的字符串格式如下:
//<?xml version="1.0" encoding="utf-8"?>
//<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//<soap:Body>
//<GetMobileOwnership xmlns="http://www.36wu.com/">
//<mobile>string</mobile>
//<authkey>string</authkey>
//</GetMobileOwnership>
//</soap:Body>
//</soap:Envelope>
+ (NSString *)makeSoapInfo:(NSString *)mobileId
{
    NSString *str = [NSString stringWithFormat:
                     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                     "<soap:Body>"
                     "<GetMobileOwnership xmlns=\"http://www.36wu.com/\">"
                     "<mobile>%@</mobile>"
                     "<authkey>%@</authkey>"
                     "</GetMobileOwnership>"
                     "</soap:Body>"
                     "</soap:Envelope>",mobileId,kAppKey];
    
    return str;
}

// 需要解析的数据如下:
//<?xml version="1.0" encoding="utf-8"?>
//<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    //<soap:Body>
        //<GetMobileOwnershipResponse xmlns="http://www.36wu.com/">
            //<GetMobileOwnershipResult>
                //<status>int</status>
                //<message>string</message>
                //<data>
                    //<province>string</province>
                    //<city>string</city>
                    //<areaCode>string</areaCode>
                    //<postCode>string</postCode>
                    //<corp>string</corp>
                    //<card>string</card>
                //</data>
            //</GetMobileOwnershipResult>
        //</GetMobileOwnershipResponse>
    //</soap:Body>
//</soap:Envelope>
+ (NSDictionary *)parseSoapInfo:(NSData *)data
{
    TBXML *xml = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *root = xml.rootXMLElement;
    
    if(!root)
    {
        NSLog(@"没有根节点对象");
        return nil;
    }
    TBXMLElement *soapBody = [TBXML childElementNamed:@"soap:Body" parentElement:root];
    TBXMLElement *response = [TBXML childElementNamed:@"GetMobileOwnershipResponse" parentElement:soapBody];
    TBXMLElement *result = [TBXML childElementNamed:@"GetMobileOwnershipResult" parentElement:response];
    TBXMLElement *resultData = [TBXML childElementNamed:@"data" parentElement:result];
    
    TBXMLElement *status = [TBXML childElementNamed:@"status" parentElement:result];
    TBXMLElement *message = [TBXML childElementNamed:@"message" parentElement:result];
    TBXMLElement *province = [TBXML childElementNamed:@"province" parentElement:resultData];
    TBXMLElement *city = [TBXML childElementNamed:@"city" parentElement:resultData];
    
    NSDictionary *resultDict = @{@"status":[TBXML textForElement:status],
                                 @"message":[TBXML textForElement:message],
                                 @"province":[TBXML textForElement:province],
                                 @"city":[TBXML textForElement:city]};
    
    return resultDict;
}
@end
