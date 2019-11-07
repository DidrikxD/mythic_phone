import App from '../app';
import Data from '../utils/data';

var apps = null;

window.addEventListener('message', function(event) {
    switch (event.data.action) {
        case 'updateUnread':
            UpdateUnread(event.data.app, event.data.unread);
            break;
        case 'EnableApp':
            $.each(Data.GetData('apps'), function(index, app) {
                if (app.container === event.data.app) {
                    Data.UpdateObjectData('apps', 'container', event.data.app, 'enabled', true);
                    return false;
                }
            });

            ToggleApp(event.data.app, true);
            break;
        case 'DisableApp':
            $.each(Data.GetData('apps'), function(index, app) {
                if (app.container === event.data.app) {
                    Data.UpdateObjectData('apps', 'container', event.data.app, 'enabled', false);
                    return false;
                }
            });
            ToggleApp(event.data.app, false);
            break;
        case 'SyncUnread':
            $.each(Data.GetData('apps'), function(index, app) {
                if (event.data.unread[app.container] !== null) {
                    Data.UpdateObjectData('apps', 'container', app.container, 'unread', event.data.unread[app.container]);
                }
            });
            break;
    }
});

$('.phone-screen').on('click', '#home-container .app-button', function(event) {
    let app = $(this).data('app');
    App.OpenApp(app.container, null, false, false, app.customExit);
});

window.addEventListener('home-open-app', function() {
    SetupApp();
});

function SetupApp() {
    apps = Data.GetData('apps');
    $.each(apps, function(index, app) {
        if (app.enabled) {
            if (app.unread > 0) {
                $('.inner-app').append(
                    '<div class="app-button" data-tooltip="' +
                        app.name +
                        '"><div class="app-icon" id="' +
                        app.container +
                        '-app" style="background-color: ' +
                        app.color +
                        '"> ' +
                        app.icon +
                        '<div class="badge pulse">' +
                        app.unread +
                        '</div></div></div>'
                );
            } else {
                $('.inner-app').append(
                    '<div class="app-button" data-tooltip="' +
                        app.name +
                        '"><div class="app-icon" id="' +
                        app.container +
                        '-app" style="background-color: ' +
                        app.color +
                        '"> ' +
                        app.icon +
                        '</div></div>'
                );
            }
            let $app = $('#home-container .app-button:last-child');

            $app.tooltip({
                enterDelay: 0,
                exitDelay: 0,
                inDuration: 0
            });

            $app.data('app', app);
        }
    });
}

function ToggleApp(name, status) {
    let pApp = Apps.filter(app => app.container === name)[0];

    if (!status) {
        $('#' + pApp.container + '-app')
            .parent()
            .fadeOut();
        pApp.enabled = false;
    } else {
        pApp.enabled = true;
        SetupApp();
    }
}

function UpdateUnread(name, unread) {
    if (apps == null) {
        apps = Data.GetData('apps');
    }

    $.each(apps, function(index, app) {
        if (app.container == name) {
            app.unread = unread;
            return false;
        }
    });

    Data.StoreData('apps', apps);

    if (App.GetCurrentApp() === 'home') {
        SetupApp();
    }
}

export default { ToggleApp, UpdateUnread };
