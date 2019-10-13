import App from '../../app';
import Config from '../../config';
import Data from '../../data';
import Utils from '../../utils';

window.addEventListener('bank-nearest-open-app', function(data) {
    $('#bank-app-page').animate({
        height: '100%'
    }, { duration: 1000 });
});

window.addEventListener('bank-nearest-custom-close-app', function(data) {
    $('#bank-app-page').animate({
        height: '0%'
    }, { duration: 1000 }).promise().then(function() {
        window.dispatchEvent(new CustomEvent('custom-close-finish', { detail: data.detail }));
    });
});

window.addEventListener('bank-nearest-close-app', function() {

});

export default {}