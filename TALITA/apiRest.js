const axios = require('axios');


//module.exports.notify = async () => {
const notify = async (headers) => {

    let response = false

    while (response !== true) {
        response = (await axios({
            method: 'post',
            url: 'http://localhost:1240/rest/MNWS0001/',
            headers: headers

        })).data;
        //console.log("response", response)
    }
}

(async () => {
    console.log('ok')
    notify()

})()
