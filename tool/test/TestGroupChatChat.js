var https=require('http');
var fs=require('fs');
var TymLib = require("TymLib.js");
var query = require("querystring");    //解析POST请求
var urlencode = require('urlencode');
//https请求参数
var option = {
   hostname: '120.25.129.101',
  //hostname: '192.168.168.69',
    port: 0,
    path: '',
    method: 'POST',
    //passphrase: 'tymtym',
   // pfx: fs.readFileSync("../../certs/client.pfx"),
    rejectUnauthorized: false,
    headers: {
     "Content-Length": 0
 }
}

//测试用例列表
var unitsShop =
        [


        // {info:'测试 Send',port:23241,path:'/?sMethod=Send&sBusiness=GroupChat'
        // , post_data:{ lUserId : 50009, lGroupId : 20, iType : 1 , sContent : "8888888"}}


     // {info:'测试 Send',port:23241,path:'/?sMethod=Send&sBusiness=GroupChat'
      //, post_data:{ lUserId : 50037,  sOrderNo : '50037123456782141',sPassWord : '123456',lGroupId : 1, iType : 5 ,iCoinType : 2, sContent : "2,3"}}

    // {info:'测试 UnPackLkMoney',port:23241,path:'/?sMethod=UnPackLkMoney&sBusiness=GroupChat'
     //, post_data:{ lUserId : 50062, sKey : '918531515827145343'}}

      {info:'测试 QueryLkByOrder',port:23241,path:'/?sMethod=QueryLkByOrder&sBusiness=GroupChat'
      , post_data:{  sKey : '4712041515999656691704'}}

          //{info:'测试 MyChat',port:23241,path:'/?sMethod=MyChat&sBusiness=GroupChat'
        //  , post_data:{ lGroupId: 20 ,lUserId : 93525,lAddTime : 0 , iCount : 3}}



        ]

//当前用例列表
var units = [];
//在这里配置当前用例
Concat(unitsShop);//加入用例

//当前用例序号
var index = 0;
// 请求的结果回调
var CallBackRes = function (res){
    TymLib.Log("info","statusCode:" + res.statusCode);
    res.setEncoding('utf8');
    res.on('data',function(chunk){

        TymLib.Log("info","res:"+ chunk);

        var sDeAes = TymLib.DeAesCipher(chunk);
        TymLib.Log("info","des:"+ sDeAes);
        var entity = JSON.parse(sDeAes);

        if( entity.list != undefined){
            TymLib.Log("info","iRet:" + entity.iRet);
            for(var i  = 0 ; i < entity.list.length ; i ++){
                TymLib.Log("info",entity.list[i]);
            }
        }else{
            TymLib.Log("info",entity);
        }

        index ++;
        if( index < units.length){
            Request();
        }
    });
}

function Request(){
    option.path = units[index].path;
    option.port = units[index].port;
    TymLib.Log("info","\n"   + units[index].info + "\npath:" + option.path  );
    var sAes = TymLib.AesCipher(JSON.stringify(units[index].post_data));

    var sCurTime = TymLib.GetCurSecond();
    var sAppid = "425388c9c928c3d36856e67b6d86cc11";
    var appKey = TymLib.GetAppKeyByAppid(sAppid);   

    var sSid  = TymLib.md5(appKey.sAppKey  + sAes  + sCurTime+  sAppid );

    option.path += "&sAppid=" + sAppid + "&sTimeStamp=" + sCurTime + "&sSign=" + sSid ;
    TymLib.Log("info","path:" + option.path);

    TymLib.Log("info","time:" + TymLib.GetCurMilliSecond());
    option.headers["Content-Length"] = sAes.length;
    var req = https.request(option,CallBackRes);
    req.on('error',function (err){
        TymLib.Log("info","Request error:" + err.code);
    });
    
    req.write(sAes + "\n");
    req.end();
}

function Main(){
    Request();
}

function Concat(u){
    for(var i = 0 ; i < u.length ; i ++){
        units.push(u[i]);
    }
}

//开始测试
TymLib.SetLog("test","debug");
TymLib.Log("info","start");
for(var i = 0 ; i < 1 ; i++){
   Main();
}

TymLib.Log("info","end");


