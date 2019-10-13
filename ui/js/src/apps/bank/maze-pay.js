import App from '../../app';
import Config from '../../config';
import Data from '../../data';
import Utils from '../../utils';
import Test from '../../test';

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