import App from '../../app';
import Config from '../../config';
import Data from '../../utils/data';
import Notif from '../../utils/notification';

window.addEventListener('irc-convo-open-app', function(data) {
    let messages = Data.GetData('irc-messages').filter(c => c.channel === data.detail.channel);

    console.log(messages);
});

window.addEventListener('irc-convo-close-app', function() {
    
});

export default {}