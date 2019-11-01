import App from '../../app';
import Config from '../../config';
import Data from '../../utils/data';
import Utils from '../../utils/utils';
import Test from '../../test';
import Notif from '../../utils/notification';

$('#screen-content').on('submit', '#send-maze-pay', function(e) {
    e.preventDefault();
    let data = $(this).serializeArray();

    $.post(Config.ROOT_ADDRESS + '/MazePay', JSON.stringify({
        destination: data[0].value,
        amount: data[1].value,
    }), function(status) {
        if (status) {
            Data.AddData('maze-pay', status);
            Notif.Alert('Money Has Been Transferred');
            App.GoBack();
        } else {
            Notif.Alert('Unable To Process Payment');
        }
    });
});

window.addEventListener('bank-mp-open-app', function(data) {
    let history = Data.GetData('maze-pay');
    $.each(Test.MazePayTransactions, function(index, transaction) {
        $('#maze-pay-history table tbody').append(`<tr><td data-tooltip="${moment(transaction.date).calendar()}">${moment(transaction.date).calendar()}</td><td data-tooltip="${transaction.type}">${transaction.type}</td><td data-tooltip="${Utils.FormatCurrency(transaction.amount)}">${Utils.FormatCurrency(transaction.amount)}</td><td data-tooltip="${transaction.player}">${transaction.player}</td></tr>`)
    });

    $('#maze-pay-history table tbody td').tooltip({
        enterDelay: 0,
        exitDelay: 0,
        inDuration: 0
    });

    $('#bank-app-page').animate({
        height: '100%'
    }, { duration: 1000 });
});

window.addEventListener('bank-mp-custom-close-app', function(data) {
    $('#bank-app-page').animate({
        height: '0%'
    }, { duration: 1000 }).promise().then(function() {
        window.dispatchEvent(new CustomEvent('custom-close-finish', { detail: data.detail }));
    });
});

window.addEventListener('bank-mp-close-app', function() {

});

export default {}