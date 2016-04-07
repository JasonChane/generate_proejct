//
//  Lion_MIME2.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_MIME2.h"

#pragma mark -

@implementation LionMIME2

static NSMutableDictionary * __MIME = nil;

+ (NSString *)text_plain
{
    return @"text/plain";
}

+ (NSString *)text_html
{
    return @"text/html";
}

+ (NSString *)octet_stream
{
    return @"application/octet-stream";
}

+ (NSString *)fromFileExtension:(NSString *)fileExt
{
    if ( nil == fileExt )
        return nil;
    
    if ( nil == __MIME )
    {
        __MIME = [[NSMutableDictionary alloc] init];
        
        __MIME[@"html"]		= @"text/html";
        __MIME[@"htm"]		= @"text/html";
        __MIME[@"shtml"]	= @"text/html";
        __MIME[@"css"]		= @"text/css";
        __MIME[@"xml"]		= @"text/xml";
        __MIME[@"gif"]		= @"image/gif";
        __MIME[@"jpeg"]		= @"image/jpeg";
        __MIME[@"jpg"]		= @"image/jpeg";
        __MIME[@"js"]		= @"application/javascript";
        __MIME[@"atom"]		= @"application/atom+xml";
        __MIME[@"rss"]		= @"application/rss+xml";
        __MIME[@"mml"]		= @"text/mathml";
        __MIME[@"txt"]		= @"text/plain";
        __MIME[@"jad"]		= @"text/vnd.sun.j2me.app-descriptor";
        __MIME[@"wml"]		= @"text/vnd.wap.wml";
        __MIME[@"htc"]		= @"text/x-component";
        __MIME[@"png"]		= @"image/png";
        __MIME[@"tif"]		= @"image/tiff";
        __MIME[@"tiff"]		= @"image/tiff";
        __MIME[@"wbmp"]		= @"image/vnd.wap.wbmp";
        __MIME[@"ico"]		= @"image/x-icon";
        __MIME[@"jng"]		= @"image/x-jng";
        __MIME[@"bmp"]		= @"image/x-ms-bmp";
        __MIME[@"svg"]		= @"image/svg+xml";
        __MIME[@"svgz"]		= @"image/svg+xml";
        __MIME[@"webp"]		= @"image/webp";
        __MIME[@"woff"]		= @"application/font-woff";
        __MIME[@"jar"]		= @"application/java-archive";
        __MIME[@"war"]		= @"application/java-archive";
        __MIME[@"ear"]		= @"application/java-archive";
        __MIME[@"hqx"]		= @"application/mac-binhex40";
        __MIME[@"doc"]		= @"application/msword";
        __MIME[@"pdf"]		= @"application/pdf";
        __MIME[@"ps"]		= @"application/postscript";
        __MIME[@"eps"]		= @"application/postscript";
        __MIME[@"ai"]		= @"application/postscript";
        __MIME[@"rtf"]		= @"application/rtf";
        __MIME[@"xls"]		= @"application/vnd.ms-excel";
        __MIME[@"eot"]		= @"application/vnd.ms-fontobject";
        __MIME[@"ppt"]		= @"application/vnd.ms-powerpoint";
        __MIME[@"wmlc"]		= @"application/vnd.wap.wmlc";
        __MIME[@"kml"]		= @"application/vnd.google-earth.kml+xml";
        __MIME[@"kmz"]		= @"application/vnd.google-earth.kmz";
        __MIME[@"7z"]		= @"application/x-7z-compressed";
        __MIME[@"cco"]		= @"application/x-cocoa";
        __MIME[@"jardiff"]	= @"application/x-java-archive-diff";
        __MIME[@"jnlp"]		= @"application/x-java-jnlp-file";
        __MIME[@"run"]		= @"application/x-makeself";
        __MIME[@"pl"]		= @"application/x-perl";
        __MIME[@"pm"]		= @"application/x-perl";
        __MIME[@"prc"]		= @"application/x-pilot";
        __MIME[@"pdb"]		= @"application/x-pilot";
        __MIME[@"rar"]		= @"application/x-rar-compressed";
        __MIME[@"rpm"]		= @"application/x-redhat-package-manager";
        __MIME[@"sea"]		= @"application/x-sea";
        __MIME[@"swf"]		= @"application/x-shockwave-flash";
        __MIME[@"sit"]		= @"application/x-stuffit";
        __MIME[@"tcl"]		= @"application/x-tcl";
        __MIME[@"tk"]		= @"application/x-tcl";
        __MIME[@"der"]		= @"application/x-x509-ca-cert";
        __MIME[@"pem"]		= @"application/x-x509-ca-cert";
        __MIME[@"crt"]		= @"application/x-x509-ca-cert";
        __MIME[@"xpi"]		= @"application/x-xpinstall";
        __MIME[@"xhtml"]	= @"application/xhtml+xml";
        __MIME[@"zip"]		= @"application/zip";
        __MIME[@"bin"]		= @"application/octet-stream";
        __MIME[@"exe"]		= @"application/octet-stream";
        __MIME[@"dll"]		= @"application/octet-stream";
        __MIME[@"deb"]		= @"application/octet-stream";
        __MIME[@"dmg"]		= @"application/octet-stream";
        __MIME[@"iso"]		= @"application/octet-stream";
        __MIME[@"img"]		= @"application/octet-stream";
        __MIME[@"msi"]		= @"application/octet-stream";
        __MIME[@"msp"]		= @"application/octet-stream";
        __MIME[@"msm"]		= @"application/octet-stream";
        __MIME[@"docx"]		= @"application/vnd.openxmlformats-officedocument.wordprocessingml.document";
        __MIME[@"xlsx"]		= @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        __MIME[@"pptx"]		= @"application/vnd.openxmlformats-officedocument.presentationml.presentation";
        __MIME[@"mid"]		= @"audio/midi";
        __MIME[@"midi"]		= @"audio/midi";
        __MIME[@"kar"]		= @"audio/midi";
        __MIME[@"mp3"]		= @"audio/mpeg";
        __MIME[@"ogg"]		= @"audio/ogg";
        __MIME[@"m4a"]		= @"audio/x-m4a";
        __MIME[@"ra"]		= @"audio/x-realaudio";
        __MIME[@"3gp"]		= @"video/3gpp";
        __MIME[@"3gpp"]		= @"video/3gpp";
        __MIME[@"mp4"]		= @"video/mp4";
        __MIME[@"mpeg"]		= @"video/mpeg";
        __MIME[@"mpg"]		= @"video/mpeg";
        __MIME[@"mov"]		= @"video/quicktime";
        __MIME[@"webm"]		= @"video/webm";
        __MIME[@"flv"]		= @"video/x-flv";
        __MIME[@"m4v"]		= @"video/x-m4v";
        __MIME[@"mng"]		= @"video/x-mng";
        __MIME[@"asx"]		= @"video/x-ms-asf";
        __MIME[@"asf"]		= @"video/x-ms-asf";
        __MIME[@"wmv"]		= @"video/x-ms-wmv";
        __MIME[@"avi"]		= @"video/x-msvideo";
    }
    
    return [__MIME objectForKey:fileExt.lowercaseString];
}

@end
