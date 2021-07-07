const nodemailer = require(`nodemailer`);

const transporter = nodemailer.createTransport({
    host: 'smtp.ethosx.com',
    port: 587,
    secure: false, // true for 465, false for other ports
    auth: {
        user: 'teste@ethosx.com',
        pass: 'Ethosx@2020'
    },
    tls: { rejectUnauthorized: false }
});

const data = Date()

var emailASerEnviado = {

    from: 'teste@ethosx.com',
    to: 'fsw@ethosx.com',
    subject: 'Urgente - Monitoramento Manole - Log de Erro',
    text: `Erro ao executar o Scraper Manole 
    em ${data}`,
};

console.log(emailASerEnviado);

module.exports.transporter.sendMail(emailASerEnviado, function (error) {
    if (error) {
        console.log(error);
    } else {
        console.log('Email enviado com sucesso.');
    }
});