import Foundation
import CommonCrypto

 @objc class iOpticEncryption: NSObject {
    
    /*!
     @function   symetricKey
     @abstract   generate symetric key with salt
     
     @param      password  password used to prepare symetric key.
     @param      salt    private key
     @param rounds          The number of rounds of the Pseudo Random Algorithm
     to use. It cannot be zero.

     @return Data returns key as Data.
    
     */

    class func symetricKey(password:String, salt:String, rounds: UInt32 ) -> Data?{
        
        var setupSuccess = true
        let passwordData = password.data(using:String.Encoding.utf8)!
        
        var key = Data(repeating:0, count:kCCKeySizeAES256)
        var salt = salt.data(using: .utf8)!
        key.withUnsafeMutableBytes { (keyBytes : UnsafeMutablePointer<UInt8>) in
            salt.withUnsafeMutableBytes { (saltBytes: UnsafeMutablePointer<UInt8>) -> Void in
                
                let derivationStatus = CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2), password
                    , passwordData.count, saltBytes, salt.count, CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1), rounds, keyBytes, key.count)
                
                if derivationStatus != Int32(kCCSuccess)
                {
                    setupSuccess = false
                }
            }
        }
        
        return setupSuccess ? key : nil
    }
    
    
    /*!
     @function   aesEncrypt
     @abstract   Encrypt with AES and CBC with kCCOptionPKCS7Padding padding
     
     @param      input  The input string to be encrypted.
     @param      iv    initialization vector; if present, must
     be the same size as the current algorithm's block
     size. For sound encryption, always initialize iv with
     random data.
     @parm      key is a symertic key or assymetric key. SymetricKey is usually generated by HumEncryption.symetricKey(password:salt:rounds). Add new function for asymetric key in this class.
     
     @return dictionary with encrypted data with key "EncryptionData".
     
     */
    class func aesEncrypt(input:String, iv: Data, key: Data) -> Dictionary<String, Data>{
        var outDictionary = Dictionary<String, Data>.init()
        var dataToEncrypt = input.data(using: .utf8)!
        
        var numberOfBytesEncrypted : size_t = 0
        let size = dataToEncrypt.count + kCCBlockSizeAES128
        var encrypted = Data(repeating:0, count:size)
        let cryptStatus = iv.withUnsafeBytes {ivBytes in
            encrypted.withUnsafeMutableBytes {encryptedBytes  in
                dataToEncrypt.withUnsafeMutableBytes {clearTextBytes in
                    key.withUnsafeBytes {keyBytes in
                        CCCrypt(CCOperation(kCCEncrypt),
                                CCAlgorithm(kCCAlgorithmAES),
                                CCOptions(kCCOptionPKCS7Padding),
                                keyBytes,
                                key.count,
                                ivBytes,
                                clearTextBytes,
                                dataToEncrypt.count,
                                encryptedBytes,
                                size,
                                &numberOfBytesEncrypted)
                    }
                }
            }
        }
        if cryptStatus == Int32(kCCSuccess)
        {
            encrypted.count = numberOfBytesEncrypted
            outDictionary["EncryptionData"] = encrypted
        }
        return outDictionary
    }
    
    class func aesDecrypt(encrypted:Data, iv: Data, key: Data) -> Data
    {
        var decryptSuccess = false
        let size = encrypted.count + kCCBlockSizeAES128
        var clearTextData = Data.init(count: size)
        var numberOfBytesDecrypted : size_t = 0
        let cryptStatus = iv.withUnsafeBytes {ivBytes in
            clearTextData.withUnsafeMutableBytes {clearTextBytes in
                encrypted.withUnsafeBytes {encryptedBytes in
                    key.withUnsafeBytes {keyBytes in
                        CCCrypt(CCOperation(kCCDecrypt),
                                CCAlgorithm(kCCAlgorithmAES128),
                                CCOptions(kCCOptionPKCS7Padding),
                                keyBytes,
                                key.count,
                                ivBytes,
                                encryptedBytes,
                                encrypted.count,
                                clearTextBytes,
                                size,
                                &numberOfBytesDecrypted)
                    }
                }
            }
        }
        if cryptStatus == Int32(kCCSuccess)
        {
            clearTextData.count = numberOfBytesDecrypted
            decryptSuccess = true
        }

        return decryptSuccess ? clearTextData : Data.init(count: 0)
    }
    
    
}
