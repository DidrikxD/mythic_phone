import App from '../../app';
import Config from '../../config';
import Data from '../../utils/data';
import Utils from '../../utils/utils';
import Test from '../../test';

window.addEventListener('bank-transfer-open-app', function(data) {
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
        $('#bank-transfer-accounts').append(`<optgroup label="${type.label}"></optgroup>`);

        $.each(type.data, function(index2, account) {
            $('#bank-transfer-accounts').append(`<option value="${account.id}">Account #${account.id} ${Utils.FormatCurrency(account.balance)}</option>`);
        });
    });

    $('#bank-transfer-accounts').formSelect();

    $('#bank-app-page').animate({
        height: '100%'
    }, { duration: 1000 });
});

window.addEventListener('bank-transfer-custom-close-app', function(data) {
    $('#bank-app-page').animate({
        height: '0%'
    }, { duration: 1000 }).promise().then(function() {
        window.dispatchEvent(new CustomEvent('custom-close-finish', { detail: data.detail }));
    });
});

window.addEventListener('bank-transfer-close-app', function() {

});

export default {}