const cron = require("node-cron");
const express = require("express");

const Magalu = require("./scraperMagalu");
const Carrefour = require("./scraperCarrefour");
const ReadEmail = require("./openBoxEmail");



try {
    (async () => {
        console.log('iniciando cron')
        const data = Date()

        const responseMagalu = await Promise.all([
            Magalu.scraperMagalu(),
        ])

        // const responseCarrefour = await Promise.all([
        //     Carrefour.scraperCarrefour(),
        // ])

        const downloadResponse = await Promise.all([
            ReadEmail.downloadFile(),
        ])

    })()
} catch (error) {

    EmailMonitor.sendMail(),
        console.log('cron.error', error)
}