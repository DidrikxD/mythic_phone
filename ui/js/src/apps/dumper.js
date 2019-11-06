import App from '../app';
import Config from '../config';
import Data from '../utils/data';
import Notif from '../utils/notification';
import Utils from '../utils/utils';

window.addEventListener('dumper-open-app', function(data) {
    Notif.Alert('Dumper Is Opening');
});

window.addEventListener('dumper-close-app', function() {
    Notif.Alert('Dumper Is Closing');
});

export default {}