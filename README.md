# Clash Subscription Rules Service

Provide Clash subs with [SubConvertor](https://github.com/tindy2013/subconverter)

## Usage

Start services: `touch config.yml && docker compose up -d`

Update the subscription URL (SUB_URL) in ./clash-ctl.sh, then update config manually: `./clash-ctl.sh update`

Set crontab for update config interval, add below lines to crontab by executing `crontab -e`

```crontab
0 3 * * * /share/Container/clash/clash-ctl.sh update 2>&1 >> /tmp/refreshConfig.log
*/5 * * * * /share/Container/clash/clash-ctl.sh check 2>&1 >> /tmp/checkConfig.log
```
