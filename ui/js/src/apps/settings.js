import App from '../app';
import Config from '../config';
import Data from '../utils/data';
import Notif from '../utils/notification';
import Utils from '../utils/utils';
import Test from '../test';

window.addEventListener('settings-open-app', function(data) {
    $.each(Config.Settings, function(index, category) {
        $('.inner-app').append(`<div class="settings-category">${category.category}</div>`);

        $.each(category.data, function(index, data) {
            $('.inner-app .settings-category:last-child').append(`<div>${data.label}</div>`);
        });
    });
});

window.addEventListener('settings-close-app', function() {
    
});

export default {}