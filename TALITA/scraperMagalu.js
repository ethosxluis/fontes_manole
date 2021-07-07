const axios = require('axios');
const cheerio = require('cheerio');
const puppeteer = require('puppeteer');

const urlMagalu = 'https://id-b2b.magazineluiza.com.br/auth/realms/B2B/protocol/openid-connect/auth?client_id=IntegraCommerceSellerAdmin&redirect_uri=https%3A%2F%2Fmarketplace.integracommerce.com.br%2Fsignin-oidc&response_type=code&scope=openid%20profile&response_mode=form_post&nonce=637401079846363710.MTI2ZGNhOGItZDNmZC00MWY1LTgwMzQtMWFhMjU4MTNiZGRhOGY3Y2Q3NWItMGZlZi00NmQ4LWI1NmItZTFmMTQ4MDA4NmEz&state=CfDJ8Ns10f90CGJBkjhRtJME6UOB67u2zgDyXUyhz5R63M8zOCQq_FZgRNXRNoGJijxmJpyFmvtVEYsJ-0ARSTlHK49i5e2QsYQTeyvXSOVN8Ujg7gX6bODnA1P9LQgjVg490Fw45pO1BXFr4KLe9ftk3EVPknPCry4UBqVcq9crKrzfHjroIF1qsLffmeIx2EhdJc3MRxOY8unij8GqyQF3HoLDBWC_71mSJoC_I64gbc_1oZvLvvlXrhGN_JtsivhNwjYKw-tYjG5bBnrVn-d1ScBLlct4Q6cbzICIq_v0bL3mFWejWAl_ZPvCTV0E8RllfqaCLus7Jq4lhBDrnRru1IgdEBlmjeJsSH4bbzLjaUClQD3U_0x2vF7OM-M1ORKqTA&x-client-SKU=ID_NET461&x-client-ver=5.3.0.0';

module.exports.scraperMagalu = async () => {

    console.log('dentro do cron')
    const chromeOptions = {
        headless: false,
        defaultViewport: null,
        slowMo: 10,
    };

    const data = Date()
    console.log(data);

    const browser = await puppeteer.launch(chromeOptions)
    const page = await browser.newPage()
    await page.goto(urlMagalu)

    await page.type('#username', 'fsw@ethosx.com');
    await page.type('#password', '4kTyo0');

    await page.click('#kc-login');

    await page.waitForSelector('#username');

    await page.type('#username', 'fsw@ethosx.com');
    await page.type('#password', '4kTyo0');

    await page.click('#kc-login');
    await page.waitForSelector('#banner');

    const cCamIni = "https://marketplace.integracommerce.com.br/SellerFinancial/TransferReport"

    await page.goto(cCamIni)

    setTimeout(() => 300000)
    await page.click('.btn.btn-teal')

    await page.$eval('input[name=StartDate]', el => el.value = '01-01-2020');
    await page.$eval('input[name=EndDate]', el => el.value = '01-01-2021');

    await page.$eval('input[name=Email]', el => el.value = 'teste@ethosx.com');

    await page.click('.btn.btn-sm.btn-teal');

    await page.waitForSelector('.modal-header.text-center');
    await page.waitForSelector('.btn.btn-primary');

    await page.click('.btn.btn-primary');

    await browser.close();
    return []
}

