//
//  ZipMemDemo.swift
//  mugshot
//
//  Created by junyu on 15/6/12.
//  Copyright (c) 2015年 dexter. All rights reserved.
//
//  for more information:https://github.com/nmoinvaz/minizip

import UIKit

class ZipMemDemo: NSObject {
    var	mZipFile: zipFile!
    var mZipmem = ourmemory_t()

    //析构
    deinit {
        //注意:这个一定要手动释放
        if mZipmem.base != nil {
            free(mZipmem.base)
        }
    }

    func openZipFileMem() {
        var filefunc32 = zlib_filefunc_def()
        mZipmem.grow = 1
        fill_memory_filefunc(&filefunc32, &mZipmem)
        mZipFile = zipOpen2("__notused__", APPEND_STATUS_CREATE, nil, &filefunc32)
    }

    func addFileToZipFileMem(data: NSData, newName: String) -> Bool {
        var zipInfo = zip_fileinfo()
        let tempName = UTF_8toGB_18030_2000(newName)
        var ret = zipOpenNewFileInZip(
            mZipFile,
            UnsafePointer<Int8>(tempName.bytes),
            &zipInfo, nil, 0, nil, 0, nil,
            Z_DEFLATED, Z_DEFAULT_COMPRESSION
        )
        if ret != Z_OK {
            return false
        }

        let dataLen = UInt32(data.length)
        ret = zipWriteInFileInZip(
            mZipFile,
            data.bytes,
            dataLen)
        if ret != Z_OK {
            zipCloseFileInZip(mZipFile)
            return false
        }

        ret = zipCloseFileInZip(mZipFile)
        if ret != Z_OK {
            return false
        }
        return true
    }

    func closeZipFileMem() {
        zipClose(mZipFile, nil)
    }

    func UTF_8toGB_18030_2000(inputStr: String) -> NSData {
        let enc = CFStringConvertEncodingToNSStringEncoding(
            CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
        return inputStr.dataUsingEncoding(enc, allowLossyConversion: true)!
    }
}
