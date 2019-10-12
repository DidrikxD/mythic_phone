import App from '../../app';
import Config from '../../config';
import Data from '../../data';
import Utils from '../../utils';

import Transfer from './transfer';
import Transaction from './transaction'

var timeInt = null;

$('#screen-content').on('click', '#bank-quick-transfer', function(e) {
    App.OpenApp('bank-transfer', null, false, true, true);
})

window.addEventListener('bank-open-app', function() {
    let myData = Data.GetData('myData');
    $('.message-name').html(myData.name);

    $('.message-text').html(`${moment().format('MMMM Do YYYY, h:mm:ss a')}`);

    timeInt = setInterval(function() {
        $('.message-text').html(`${moment().format('MMMM Do YYYY, h:mm:ss a')}`);
    }, 1000);

    $('.accounts').html('');
    let accounts = Data.GetData('bank-accounts');
    $.each(accounts, function(index, account) {
        if (account.owner) {
            $('.accounts').append(`<div class="account" data-tooltip="Account #${account.id} - Balance: ${Utils.FormatCurrency(account.balance)}"><div class="account-label"><div class="bank-label-name">${account.label}</div><small>Account Owner</small></div><div class="account-balance">${Utils.FormatCurrency(account.balance)}</div></div>`)
        } else {
            $('.accounts').append(`<div class="account" data-tooltip="Account #${account.id} - Balance: ${Utils.FormatCurrency(account.balance)}"><div class="account-label"><div class="bank-label-name">${account.label}</div><small>Authorized User</small></div><div class="account-balance">${Utils.FormatCurrency(account.balance)}</div></div>`)
        }
    });

    $('.account').tooltip({
        enterDelay: 0,
        exitDelay: 0,
        inDuration: 0
    });

    $('.quick-actions').animate({
        height: '20%'
    }, { duration: 1000 }).promise().then(function() {
        $('.bank-quick-action').fadeIn('normal').css('display', 'inline-block');
    });
});

window.addEventListener('bank-custom-close-app', function(data) {
    $('.bank-quick-action').fadeOut('normal').promise().then(function() {
        $('.quick-actions').animate({
            height: '100%'
        }, { duration: 1000 }).promise().then(function() {
            window.dispatchEvent(new CustomEvent('custom-close-finish', { detail: data.detail }));
        });
    });
});

window.addEventListener('bank-close-app', function() {
    clearInterval(timeInt);
});

export default {}