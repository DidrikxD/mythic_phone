import App from '../../app';
import Config from '../../config';
import Data from '../../utils/data';
import Notif from '../../utils/notification';
import Utils from '../../utils/utils';


window.addEventListener('dumper-details-open-app', (data) => {

});

window.addEventListener('dumper-details-open-app', (data) => {
    let app = data.detail;
    
    $('.dumper-top-bar').css('background', app.color);
    $('.section-header').css('color', app.color);

    $('.dumper-top-text span').html(app.name);
    $('#name .section-data').html(app.name);
    $('#package .section-data').html(app.container);

    switch(+app.dumpable) {
        case 1:
            $('#dumper-clone, #APP_CLONE, #APP_NONE').remove();
            $('#permissions .section-data').html('APP_TRANSFER');
            break;
        case 2:
            $('#APP_NONE').remove();
            $('#permissions .section-data').html('APP_TRANSFER, APP_CLONE');
            break;
        default:
            $('#dumper-clone, #dumper-transfer, #APP_CLONE, #APP_TRANSFER').remove();
            $('#permissions .section-data').html('APP_NONE');
            break;
    }

    $('.dumper-top-actions i').tooltip({
        enterDelay: 0,
        exitDelay: 0,
        inDuration: 0
    });
});

window.addEventListener('dumper-details-close-app', () => {
    
});

export default {}