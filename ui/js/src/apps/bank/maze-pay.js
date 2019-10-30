import Config from '../../config';
import Data from '../../utils/data';
import Utils from '../../utils/utils';
import Test from '../../test';

$('#screen-content').on('submit', '#maze-pay-form', function(e) {
    e.preventDefault();
    let data = $(this).serializeArray();

    $.post(Config.ROOT_ADDRESS + '/MazePay', JSON.stringify({
        account: data[0].value,
        destination: data[1].value,
        amount: data[2].value,
    }), function(status) {
        if (status != null) {
            Data.AddData('maze-pay', status);
            Notif.Alert('Transfer Submitted, Will Be Processed Within 3 Days (3 hours)');
            App.GoBack();
        } else {
            Notif.Alert('Error Occured While Attempting The Transfer');
        }
    });
});

window.addEventListener('bank-mp-open-app', function(data) {
    let accounts = Data.GetData('bank-accounts');
    let stuff = new Array();
    
    stuff.push({ label: 'Personal Accounts', data: accounts.filter(function(account) {
        return account.type === 1;
    })});

    $.each(stuff, function(index, type) {
        $('#bank-transfer-accounts').append(`<optgroup label="${type.label}"></optgroup>`);

        $.each(type.data, function(index2, account) {
            $('#bank-transfer-accounts').append(`<option value="${account.id}">Account #${account.id} ${Utils.FormatCurrency(account.balance)}</option>`);
        });
    });

    $('#bank-transfer-accounts').formSelect();

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