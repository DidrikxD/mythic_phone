import App from '../../app';
import Config from '../../config';
import Data from '../../utils/data';
import Notif from '../../utils/notification';
import Utils from '../../utils/utils';

import Convo from './convo';

$('#screen-content').on('click', '.irc-channel', function(e) {
    App.OpenApp('irc-convo', { channel: $(this).data('channel') }, false, true, false);
});

window.addEventListener('irc-open-app', function() {
    let channels = Data.GetData('irc-channels');

    $('.channel-list').html('');
    $.each(channels, function(index, channel) {
        $('.channel-list').append(`<div class="irc-channel"><span>${channel.channel}</span></div>`);
        $('.channel-list .irc-channel:last-child').data('channel', channel);
    })
});

window.addEventListener('irc-close-app', function() {
    
});

export default {}