import App from '../../app';
import Config from '../../config';
import Data from '../../utils/data';
import Utils from '../../utils/utils';
import Test from '../../test';

$("#screen-content").on('change', '#bank-transaction-accounts', function() {
    let id = $(this).val();
    let account = Data.GetData('bank-accounts').filter(function(item) {
        return item.id == id;
    })[0];

    App.OpenApp('bank-transaction', account, false, true, true);
});

window.addEventListener('bank-transaction-open-app', function(data) {
    let account = data.detail;
    let arr = Test.Transactions.filter(function(item) {
        return item.account == account.id
    })[0];

    $('#bank-app-page').addClass(`type-${account.type}`);

    let accounts = Data.GetData('bank-accounts');
    let stuff = new Array();

    stuff.push({ label: 'Personal Accounts', data: accounts.filter(function(account) {
        return account.type === 1;
    })});

    stuff.push({ label: 'Business Accounts', data: accounts.filter(function(account) {
        return account.type === 2;
    })});

    stuff.push({ label: 'Government Accounts', data: accounts.filter(function(account) {
        return account.type === 3;
    })});

    $.each(stuff, function(index, type) {
        $('#bank-transaction-accounts').append(`<optgroup label="${type.label}"></optgroup>`);

        $.each(type.data, function(index2, act) {
            $('#bank-transaction-accounts').append(`<option value="${act.id}">Account #${act.id} ${Utils.FormatCurrency(act.balance)}</option>`);
            
            if (act.id == account.id) {
                $('#bank-transaction-accounts option:last-child').attr('selected', 'selected');
            }
        });
    });

    $('#bank-transaction-accounts').formSelect();

    if (arr != null && arr.transactions.length > 0) {
        $.each(arr.transactions, function(index, trans) {
            $('.transaction-body table').append(`<tr><td>${moment(trans.date).calendar()}</td><td>${Utils.FormatCurrency(trans.amount)}</td><td>${trans.note}</td></tr>`)
        });
    } else {
        $('.transaction-body').html('<div class="no-transactions">No Recent Transactions</div>')
    }

    $('#bank-app-page').animate({
        height: '100%'
    }, { duration: 1000 }).promise().then(function() {
        $('.select-wrapper').fadeIn('fast');
    });
});

window.addEventListener('bank-transaction-custom-close-app', function(data) {
    $('.select-wrapper').fadeOut('fast');
    $('#bank-app-page').animate({
        height: '0%'
    }, { duration: 1000 }).promise().then(function() {
        window.dispatchEvent(new CustomEvent('custom-close-finish', { detail: data.detail }));
    });
});

window.addEventListener('bank-transaction-close-app', function() {
    
});

export default {}