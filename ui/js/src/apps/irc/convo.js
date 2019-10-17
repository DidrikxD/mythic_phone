import App from '../../app';
import Config from '../../config';
import Data from '../../utils/data';
import Notif from '../../utils/notification';
import Utils from '../../utils/utils';

window.addEventListener('irc-convo-open-app', function(data) {
    let messages = Data.GetData('irc-messages').filter(c => c.channel === data.detail.channel);

    messages.sort(Utils.DateSortOldest);

    $('.irc-channel').html(data.detail.channel);

    $.each(messages, function(index, message) {
        $('.message-list').append(`<div class="irc-message"><span class="message-text">${message.message}</span><span class="message-time">${moment(message.date).fromNowOrNow()}</span></div>`)
    })
});

window.addEventListener('irc-convo-close-app', function() {
    
});

export default {}