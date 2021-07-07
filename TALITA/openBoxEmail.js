const http = require(`https`);
const fs = require(`fs`);
const ReturnNotify = require("./apiRest.js");


var Imap = require('imap'),
    inspect = require('util').inspect;

var imap = new Imap({
    user: 'teste@ethosx.com',
    password: 'Ethosx@2020',
    host: 'imap.ethosx.com',
    connTimeout: 20000,
    port: 143,
    tls: false
});

function openInbox(cb) {
    imap.openBox('INBOX', false, cb);
}

const getMailList = () => {

    const emailList = []
    const attrList = []
    return new Promise((resolve, reject) => {
        imap.once('ready', function () {
            openInbox(function (err, box) {
                console.log("openBox.boxOpened")
                if (err) throw err;

                imap.search(['UNSEEN'], function (err, results) {
                    if (err) throw err;
                    box.messages.total
                    if (!results || results.length === 0) {
                        console.log("openBox.noEmailFound")
                        imap.end();
                        return resolve([])
                    }

                    imap.setFlags(results, ['\\Seen'], err => {
                        if (err) error(err);
                        console.log('Flags added');
                    });

                    var f = imap.fetch(results, {
                        markSeen: true,
                        bodies: ['HEADER.FIELDS (FROM TO SUBJECT DATE)', 'TEXT'],
                        struct: true
                    });
                    f.on('message', function (msg, messageId) {
                        console.log('Message #%d', messageId);
                        var prefix = '(#' + messageId + ') ';
                        msg.on('body', function (stream, info) {
                            if (info.which === 'TEXT')
                                console.log(prefix + 'Body [%s] found, %d total bytes', inspect(info.which), info.size);
                            var buffer = '', count = 0;
                            stream.on('data', function (chunk) {
                                count += chunk.length; // recebe os bytes
                                buffer += chunk.toString('utf8'); // faz o parse para string
                                // console.log('BUFFER', buffer)
                                if (info.which === 'TEXT') {
                                    console.log(prefix + 'Body [%s] (%d/%d)', inspect(info.which), count, info.size);
                                }
                            });
                            stream.once('end', function () {
                                if (info.which !== 'TEXT')
                                    // console.log(prefix + 'Parsed header: %s', inspect(Imap.parseHeader(buffer)));
                                    console.log(prefix + 'Parsed header: %s');
                                else {
                                    console.log(prefix + 'Body [%s] Finished', inspect(info.which));
                                    emailList.push({
                                        'id': messageId,
                                        'content': buffer
                                    })
                                    // return resolve(buffer)
                                }
                            });
                        });
                        msg.once('attributes', function (attrs) {
                            // console.log(prefix + 'Attributes: %s', inspect(attrs, false, 8));
                            const x = emailList.map((item) => {
                                if (item.id === messageId)
                                    item['date'] = attrs['date']
                                return item
                            })
                            console.log(prefix + 'Attributes: %s');
                        });
                        msg.once('end', function () {
                            console.log(prefix + 'Finished');
                        });
                    });
                    f.once('error', function (err) {
                        console.log('Fetch error: ' + err);
                    });
                    f.once('end', function () {
                        console.log('Done fetching all messages!');
                    });
                    imap.end();
                });
            });
        });

        imap.once('error', function (err) {
            console.log('imap.error', err);
        });

        imap.once('end', function () {
            console.log('Imap Connection ended');
            return resolve(emailList)
        });
        imap.connect();
    })
}


module.exports.downloadFile = async () => {
    const mailList = await getMailList()
    console.log("downloadFile.mailList.length", mailList.length)

    mailList.map(async mailItem => {
        console.log("downloadFile.mailitem", mailItem)
        const mailBody = mailItem.content.replaceAll('=\r\n', '')
        const separator = "https://storage.googleapis.com/payment_transfer_report/repasse-editoramanole-"
        const splited = mailBody.split(separator)

        const content = splited && splited[1]

        if (!content) {
            console.log("downloadFile.invalidContentEmail")
            return
        }
        const endOfUrl = content.indexOf('"')

        const finalUrl = separator + content.substring(0, endOfUrl)
        const mailDate = new Date(mailItem.date).toLocaleDateString().replaceAll('/', '-')

        const decoded = decodeEntities(finalUrl).replaceAll('=3D', '=')
        const fileName = `magalu-${mailDate}.csv`
        const download = await writeFile(fileName, decoded)
        console.log("downloadFile.fileSaved")

        const notifyResponse = await ReturnNotify.notify({
            "cMarketP": "Magalu",
            "cArquivo": fileName
        })

    });
    return true
}


const decodeEntities = (encodedString) => {
    var translate_re = /&(nbsp|amp|quot|lt|gt);/g;
    var translate = {
        "nbsp": " ",
        "amp": "&",
        "quot": "\"",
        "lt": "<",
        "gt": ">"
    };
    return encodedString.replace(translate_re, function (match, entity) {
        return translate[entity];
    }).replace(/&#(\d+);/gi, function (match, numStr) {
        var num = parseInt(numStr, 10);
        return String.fromCharCode(num);
    });

}

const writeFile = (fileName, content) => {
    return new Promise((resolve, reject) => {

        const file = fs.createWriteStream(fileName);

        http.get(content, (response) => {
            console.log('http.get.response', {
                'statusCode': response.statusCode,
                'statusMessage': response.statusMessage,
            });
            response.pipe(file);
            return resolve({
                'statusCode': response.statusCode,
                'statusMessage': response.statusMessage,
            })
        });
    })
}
