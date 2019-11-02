import App from '../app';
import Config from '../config';
import Data from '../utils/data';
import Notif from '../utils/notification';
import Utils from '../utils/utils';

$('#screen-content').on('submit', '#phone-settings', function(e) {
    e.preventDefault();
    let data = $(this).serializeArray();
    console.log(JSON.stringify(data));

    let settings ={
        volume: parseInt(data[0].value),
        wallpaper: parseInt(data[1].value),
        ringtone: parseInt(data[2].value),
        text: parseInt(data[3].value)
    }

    $.post(Config.ROOT_ADDRESS + '/UpdateSettings', JSON.stringify(settings), function(status) {
        if (status) {
            Data.StoreData('settings', settings);
            Utils.UpdateWallpaper(`url(./imgs/back00${settings.wallpaper}.png)`);
            Utils.SetMute(settings.volume === 0);
            Notif.Alert('Settings Saved');
        } else {
            Notif.Alert('Unable To Save Settings');
        }
    });
})

window.addEventListener('settings-open-app', function(data) {
    let settings = Data.GetData('settings');

    $('#settings-volume').val(settings.volume);
    $('#settings-wallpaper').val(settings.wallpaper);
    $('#settings-ringtone').val(settings.ringtone);
    $('#settings-text').val(settings.text);

    $('#settings-volume').formSelect();
    $('#settings-wallpaper').formSelect();
    $('#settings-ringtone').formSelect();
    $('#settings-text').formSelect();
});

window.addEventListener('settings-close-app', function() {
    
});

export default {}