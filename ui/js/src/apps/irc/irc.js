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
    let messages = Data.GetData('irc-messages');
    let channels = new Array();

    $.each(messages, function(index, message) {
        let channel = channels.filter(c => c.channel === message.channel)[0];

        if (channel == null) {
            channels.push(message);
        } else {
            if (message.date > channel.date) {
                $.each(channels, function(index, c) {
                    if (c == channel) {
                        channels[index] = message;
                        return false;
                    }
                });
            }
        }
    });

    channels.sort(Utils.DateSortNewest);

    $('.channel-list').html('');

    $.each(channels, function(index, channel) {
        $('.channel-list').append(`<div class="irc-channel"><span>${channel.channel}</span></div>`);
        $('.channel-list .irc-channel:last-child').data('channel', channel.channel);
    })
});

window.addEventListener('irc-close-app', function() {
    
});

export default {}