let fs = require("fs");
let config = require('./conf/config');

let appPath = process.env.APP_PATH;
<!--let appPath = __dirname;-->
if (!appPath) {
    process.exit('ENV APP_PATH not found');
    return;
}
let cronFile = appPath + '/cron.json';
if (!fs.existsSync(cronFile)) {
    process.exit('cron.json not found');
    return;
}
let content = fs.readFileSync(cronFile);
if (!content) {
    process.exit('cron.json content is null');
}

config.name = process.env.APP_NAME;
config.webhook = process.env.APP_MONITOR_HOOK;

let data = JSON.parse(content);
if (!data) {
    process.exit('json parse error');
}

if (data.hook) {
    console.log('webhook override by cron.json');
    config.webhook = data.hook;
}

if (data.jobs) {
    console.log('checked', data);
    require('./service/task/server').start(data.jobs);
}