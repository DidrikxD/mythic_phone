import App from '../../app';
import Config from '../../config';
import Data from '../../data';
import Utils from '../../utils';

import Transfer from './transfer';
import MazePay from './maze-pay';
import Transaction from './transaction'
import Nearest from './nearest';

var timeInt = null;

$('#screen-content').on('submit', '#bank-transfer', function(e) {
    e.preventDefault();
    let data = $(this).serializeArray();

    console.log(data);
});

$('#screen-content').on('keyup keydown blur', '#target-account', function(e) {
    switch(e.which) {
        case 69:
        case 107: // Numpad Equals
        case 109: // Numpad Minus
        case 110: // Numpad Decimal
        case 187: // =/+
        case 189: // -/_
        case 190: // ./>
            e.preventDefault();
            break;
        default:
            if ($(this).val() != '') {
                $(this).val(parseInt($(this).val()));
            }
            break;
    }
});

$('#screen-content').on('keyup keydown blur', '#transfer-amount', function(e) {
    $(this).val(function(index, value) {
        return value
        .replace(/\D/g, "")
        .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
        ;
    });
});

$('#screen-content').on('click', '.bank-quick-action', function(e) {
    if (!$(this).hasClass('disabled')) {
        let app = $(this).data('nav');
        $(this).addClass('disabled');
        App.OpenApp(app, null, false, true, true);
    }
});

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
            $('.accounts').append(`<div class="account type-${account.type}" data-tooltip="Account #${account.id} - Balance: ${Utils.FormatCurrency(account.balance)}"><div class="account-label"><div class="bank-label-name">${account.label}</div><small>Account Owner</small></div><div class="account-balance">${Utils.FormatCurrency(account.balance)}</div></div>`)
        } else {
            $('.accounts').append(`<div class="account type-${account.type}" data-tooltip="Account #${account.id} - Balance: ${Utils.FormatCurrency(account.balance)}"><div class="account-label"><div class="bank-label-name">${account.label}</div><small>Authorized User</small></div><div class="account-balance">${Utils.FormatCurrency(account.balance)}</div></div>`)
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