//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by wangguiping on 14-11-23.
//  Copyright (c) 2014年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”https://b.alipay.com/order/myorder.htm
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088611075529585"
//收款支付宝账号
#define SellerID  @"zcdtcm@163.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"d364tasfi3eydmzd2ikbmmt1rfl8dvnm"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKFDng6b+72YeojMQ0zDkMRW2t6jpCcn0aBaQkt1/Gurb3qIHba3TX5MMbeeUD9eFMGbVqwcnXlRc6HCppt6ViaMdWDKvmR6c7ypKoQiZ02G+Imjxz8hggfZJPb/i/RhqCmxZzbOWZhAL4y/CGvv6g/w3QklFY0JGEht+byrPZ6dAgMBAAECgYAfTA8tyKoHtsL5L6NUD5RV9oFNujaOftTZKQs6t/BAOSpOfoI9xr9cZo8zkp8CXVDr7ijZCEirldo6J5vMCucTD0s2LdzPHGZ+5TgxsfEm9jxKogyxZEfYkJu6ZgQ0qj5x+4Td7C5jVqCjK6eCj0sKTaCE/vYXZf9dJGeNErCYwQJBAMx/Lh0tlhiK3ilba7PtciQHxf9t4rxmmUufyGGpFh930HJy+pDhJT5KXl+JWAY62x95CfiQpU00uguTL33LWXECQQDJ4QjaEUea+oj2sxRxjv4eV2BOeqmvQGivxWiMZ0rlpBi34d7Jq+eLZ+mXiZR4ZT8RyBkHJBCw/BGJ+ifumGHtAkAhNN22GzruTU56BMBefUY1l5WNPri8wyRNZWrSgPR4s6oDi6wobobvsH/Wn6TNji0a1TrLRCGzgcZcLtBdavHhAkAqbqlcpIsncQd+yw89+y9Ak18Dv9aQpnoaj+S0tjVQ5VfotooMW5yUeafomRti3u0NwMA59wOnH6RUGwdvqAnVAkA9cyT7rtYxw+q6xx2BwfdvRzzyjbpgNkCMBRyUO2VStZKTDX4nXYXaYpdksKEGLllOMZUzNDIgpy5paq2ASiwg"


//支付宝公钥
#define AlipayPubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#define Notify_Url @"http://www.0731zhongchou.com/api/payment/alipay/notify_url.aspx"

#endif
