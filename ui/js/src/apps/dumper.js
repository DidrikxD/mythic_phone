import App from '../app';
import Config from '../config';
import Data from '../utils/data';
import Notif from '../utils/notification';
import Utils from '../utils/utils';

window.addEventListener('message', (event) => {
    switch (event.data.action) {
        case 'Logout':
            $('.sdcard').fadeOut('fast').promise().then(() => {
                $('.sdcard').removeClass('advanced');
            });
            break;
        case 'InsertSDCard':
            if (event.data.advanced) {
                $('.sdcard').addClass('advanced');
            }
            $('.sdcard').fadeIn('fast');
            break;
    }
});

$('#remove-sdcard-card').on('click', () => {
    let modal = M.Modal.getInstance($('#remove-sdcard-conf'));
    modal.close();

    $.post(Config.ROOT_ADDRESS + '/EjectSDCard', JSON.stringify({
        advanced: $('.sdcard').hasClass('advanced')
    }), (status) => {
        if (status) {
            $('.sdcard').fadeOut('fast').promise().then(() => {
                $('.sdcard').removeClass('advanced');
            });
            Notif.Alert('SD Card Ejected');

            if (App.GetCurrentApp() === 'dumper') {
                App.GoHome();
            }
        } else {
            Notif.Alert('Issue Ejectiong SD Card');
        }
    });
});

window.addEventListener('dumper-open-app', (data) => {
    $('#dumper-container').on('click', '.dumper-app', (event) => {

    })
});

window.addEventListener('dumper-open-app', (data) => {
    console.log($('.sdcard').is(':visible'));
    if ($('.sdcard').is(':visible')) {
        let apps = Data.GetData('apps');
        $.each(apps, (index, app) => {
            if (app.enabled) {
                if (app.dumpable) {
                    $('#dumper-container').find('.inner-app').append(`<div class="dumper-app"><div class="dumper-icon dumpable"><i class="fas fa-skull-crossbones"></i></div><div class="dumper-app-label">${app.name}</div></div>`);
                } else {
                    $('#dumper-container').find('.inner-app').append(`<div class="dumper-app"><div class="dumper-icon"><i class="fas fa-skull-crossbones"></i></div><div class="dumper-app-label">${app.name}</div></div>`);
                }
            }
        });
    } else {
        $('#dumper-container').find('.inner-app').html('No SD Card Found').addClass('error');
    }
});

window.addEventListener('dumper-close-app', () => {
    
});

export default {}