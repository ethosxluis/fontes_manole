const axios = require('axios');
const cheerio = require('cheerio');
const puppeteer = require('puppeteer');
const ReturnNotify = require("./apiRest.js");



const urlCarrefour = 'https://marketplace.carrefour.com.br/login'


module.exports.scraperCarrefour = async () => {

    const chromeOptions = {
        headless: false,
        defaultViewport: null,
        slowMo: 10,
    };

    const browser = await puppeteer.launch(chromeOptions)
    const page = await browser.newPage()
    await page.goto(urlCarrefour)

    await page.type('#username', 'fsw@ethosx.com');
    await page.type('#password', '!Ethosx@2020');

    await page.click('#submitButton.btn.btn-lg.btn-login.btn-primary');

    const urlRel = "https://marketplace.carrefour.com.br/sellerpayment/shop/transaction?limit=100"

    await console.log("passou aqui")
    await page.goto(urlRel)

    await page.waitForSelector('a.btn.btn-solid.btn-solid-primary');

    await page.click('a.btn.btn-solid.btn-solid-primary');


    const notifyResponse = await ReturnNotify.notify({
        "cMarketP": "Carrefour",
        "cArquivo": "transaction-logs"
    })

}




