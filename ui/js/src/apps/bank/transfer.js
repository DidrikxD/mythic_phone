import App from '../../app';
import Config from '../../config';
import Data from '../../data';
import Utils from '../../utils';

window.addEventListener('bank-transfer-open-app', function(data) {
    $(".transfer-inner-wrapper").show('scale', function() {
        console.log('wat');
    });
});

window.addEventListener('bank-transfer-custom-close-app', function(data) {
    $(".transfer-inner-wrapper").hide('scale', function() {
        window.dispatchEvent(new CustomEvent('custom-close-finish', { detail: data.detail }));
    });
});

window.addEventListener('bank-transfer-close-app', function() {

});

export default {}