/**
 * Created by linyang on 17/3/7.
 */
let request = require('request');
let config = require('../conf/config');

/**
 * 报钉钉错误
 * @param msg
 */
exports.error = function (msg) {
    if (config.webhook) {
        let content = `${msg}`;
        let contentBody = {'msgtype': 'text', 'text': {'content': content}, 'at': {'isAtAll': true}};
        let options = {
            url: config.webhook,
            method: 'POST',
            headers: {'Content-Type': 'application/json'},//headers array
            body: JSON.stringify(contentBody),//method为post时的body
            timeout: 2000//超时时间(单位:秒),<=0时不计算超时
        };
        this.send(options, function (err) {
            console.log('dingding send err:', err ? err.message : null);
        });
    }
};

/**
 * 发送http请求.
 * @param args {array}
 * @param callback {function}
 */
exports.send = function (args, callback) {
    request(args, function (err, res, body) {
        if (err) {
            callback(err, err);
        } else if (res.statusCode != 200) {
            callback('err', res.statusCode);
        } else {
            callback(null, body);
        }
    });
};