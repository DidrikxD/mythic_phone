import App from '../app';
import Config from '../config';
import Data from '../utils/data';
import Notif from '../utils/notification';
import Utils from '../utils/utils';

window.addEventListener('message', function(event) {
    switch (event.data.action) {
        case 'InsertSDCard':
            if (event.data.advanced) {
                $('.sdcard').addClass('advanced');
            }

            $('.sdcard').fadeIn('fast');
            break;
    }
});



window.addEventListener('dumper-open-app', function(data) {
    $('#remove-sdcard-card').on('click', function() {
        let modal = M.Modal.getInstance($('#remove-sdcard-conf'));
        modal.close();

        $.post(Config.ROOT_ADDRESS + '/EjectSDCard', JSON.stringify({}), function(status) {
            if (status) {
                Notif.Alert('SD Card Ejected');
            } else {
                Notif.Alert('Issue Ejectiong SD Card');
            }
        });
    });
});

window.addEventListener('dumper-open-app', function(data) {
    let apps = Data.GetData('apps');

    $.each(apps, function(index, app) {
        if (app.enabled) {
            if (app.dumpable) {
                $('#dumper-container').find('.inner-app').append(`<div class="dumper-app"><div class="dumper-icon dumpable"><i class="fas fa-skull-crossbones"></i></div><div class="dumper-app-label">${app.name}</div></div>`);
            } else {
                $('#dumper-container').find('.inner-app').append(`<div class="dumper-app"><div class="dumper-icon"><i class="fas fa-skull-crossbones"></i></div><div class="dumper-app-label">${app.name}</div></div>`);
            }
        }
    });
});

window.addEventListener('dumper-close-app', function() {
    Notif.Alert('Dumper Is Closing');
});

export default {}