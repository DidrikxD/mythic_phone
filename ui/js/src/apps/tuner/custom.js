import App from '../../app';
import Config from '../../config';
import Data from '../../utils/data';
import Notif from '../../utils/notification';

var sliders = {
    boost: document.getElementById('slider-boost'),
    suspension: document.getElementById('slider-suspension'),
    tranny: document.getElementById('slider-tranny'),
    brakes: document.getElementById('slider-brakes'),
    dt: document.getElementById('slider-dt')
}

function InitSliders() {
    for (let key in sliders) {
        let slider = sliders[key];
        noUiSlider.create(slider, {
            start: [5],
            connect: [true, false],
            step: 1,
            orientation: 'horizontal',
            range: {
                'min': 0,
                'max': 10
            },
            pips: {
                mode: 'steps',
                stepped: true,
                density: 10
            }
        });
    }
}

function SetSliders(boost, tranny, suspension, brakes, dt) {
    if (sliders.boost != null) {
        sliders.boost.noUiSlider.set(boost);
        sliders.tranny.noUiSlider.set(tranny);
        sliders.suspension.noUiSlider.set(suspension);
        sliders.brakes.noUiSlider.set(brakes);
        sliders.dt.noUiSlider.set(dt);
    }
}

$('#screen-content').on('submit', '#new-tune', function(e) {
    e.preventDefault();
    let data = $(this).serializeArray();

    $.post(Config.ROOT_ADDRESS + '/TunerNew', JSON.stringify({
        label: data[0].value,
        carOnly: data[1] != null ? true : false,
        carModel: null,
        boost: sliders.boost.noUiSlider.get(),
        suspension: sliders.suspension.noUiSlider.get(),
        tranny: sliders.tranny.noUiSlider.get(),
        brakes: sliders.brakes.noUiSlider.get(),
        dt: sliders.dt.noUiSlider.get()
    }), function(tune) {
        if (tune != null) {
            Data.AddData('custom-tunes', tune);
            Notif.Alert('Tune Saved');
            let modal = M.Modal.getInstance($('#save-tune-popup'));
            modal.close();
        } else {
            Notif.Alert('Error Saving Tune');
        }
    });
})

$('#screen-content').on('click', '#tuner-custom-saved', function() {
    let tunes = Data.GetData('custom-tunes');
    let factory = Data.GetData('factory-tunes');
    $('#custom-tunes-popup').find('#car-only').html('');
    $('#custom-tunes-popup').find('#generic').html('');

    let carOnly = tunes.filter(function(tune) {
        return tune.carOnly && tune.carModel === Data.GetData('currentVeh').model;
    });

    let generic = tunes.filter(function(tune) {
        return !tune.carOnly;
    });

    if (carOnly.length > 0) {
        CreateSavedTuneList($('#custom-tunes-popup').find('#car-only'), carOnly);
    } else {
        $('#tab-car-only').removeClass('active');
        $('#tab-generic').addClass('active');
        let tabs = M.Tabs.getInstance($('#custom-tunes-tabs'));
        tabs.updateTabIndicator();
    }

    CreateSavedTuneList($('#custom-tunes-popup').find('#generic'), factory, true);
    CreateSavedTuneList($('#custom-tunes-popup').find('#generic'), generic);

    let modal = M.Modal.getInstance($('#custom-tunes-popup'));
    modal.open();
});

$('#screen-content').on('click', '#custom-tunes-popup .quick-tune-button', function(e) {
    let tune = $(this).data('tune');
    SetSliders(tune.boost, tune.suspension, tune.tranny, tune.brakes, tune.dt);
    Notif.Alert('Tune Loaded, Press Apply To Apply It');
    let modal = M.Modal.getInstance($('#custom-tunes-popup'));
    modal.close();
});

$('#screen-content').on('click', '#custom-tunes-popup .quick-tune-delete', function(e) {
    let tune = $(this).parent().find('.quick-tune-button').data('tune');

    $.post(Config.ROOT_ADDRESS + '/TunerDelete', JSON.stringify({
        id: tune.id
    }), function(status) {
        if (status) {
            Data.RemoveObjectData('custom-tunes', 'id', tune.id);
            $(this).parent().fadeOut('fast', function() {
                $(this).remove();
            });
            Notif.Alert('Tune Deleted');
        } else {

        }
    })
});

$('#screen-content').on('click', '#tuner-custom-quick', function() {
    App.OpenApp('tuner-quick', null, false, true);
});

$('#screen-content').on('click', '#tuner-custom-apply', function() {
    ApplyTune();
});

function CreateSavedTuneList(element, tunes, removeDelete = false) {
    $.each(tunes, function(index, tune) {
        element.append(`
            <div class="tuner-options">
                <button type="button" class="btn waves-effect waves-light teal darken-4 quick-tune-button">${tune.label}</button>
                <button type="button" class="btn waves-effect waves-light materialize-red darken-4 quick-tune-delete${removeDelete ? ' disabled' : ''}"><i class="fas fa-trash-alt"></i></button>
            </div>
        `);

        element.find('.tuner-options:last-child .quick-tune-button').data('tune', tune);
    });
}

function ApplyTune(tune = null) {
    let boost = sliders.boost.noUiSlider.get();
    let suspension = sliders.suspension.noUiSlider.get();
    let tranny = sliders.tranny.noUiSlider.get();
    let brakes = sliders.brakes.noUiSlider.get();
    let dt = sliders.dt.noUiSlider.get();

    if (tune != null) {
        boost = tune.boost;
        suspension = tune.suspension;
        tranny = tune.tranny;
        brakes = tune.brakes;
        dt = tune.dt;
    }

    $.post(Config.ROOT_ADDRESS + '/ApplyTune', JSON.stringify({
        boost: boost,
        suspension: suspension,
        tranny: tranny,
        brakes: brakes,
        dt: dt
    }), function(status) {
        if (status) {
            let veh = Data.GetData('currentVeh');
            veh.tune.active = {
                boost: boost,
                suspension: suspension,
                tranny: tranny,
                brakes: brakes,
                dt: dt
            }
            Data.StoreData('currentVeh', veh);
            Notif.Alert('Tune Applied');
        } else {
            Notif.Alert('Unable To Apply Tune');
        }
    });
}

window.addEventListener('tuner-custom-open-app', function(data) {
    sliders = {
        boost: document.getElementById('slider-boost'),
        suspension: document.getElementById('slider-suspension'),
        tranny: document.getElementById('slider-tranny'),
        brakes: document.getElementById('slider-brakes'),
        dt: document.getElementById('slider-dt')
    }

    InitSliders();

    if (data.detail != null && data.detail.tune != null) {
        SetSliders(data.detail.tune.boost, data.detail.tune.tranny, data.detail.tune.suspension, data.detail.tune.brakes, data.detail.tune.dt);
        ApplyTune(data.detail.tune);
        Notif.Alert('Tune Applied', 1000);
    } else {
        let veh = Data.GetData('currentVeh');
        SetSliders(veh.tune.active.boost, veh.tune.active.tranny, veh.tune.active.suspension, veh.tune.active.brakes, veh.tune.active.dt);
    }

    $('#tuner-custom-container .inner-app').fadeIn();
});

window.addEventListener('tuner-custom-close-app', function() {
    $('#tuner-custom-container .inner-app').fadeOut();
});

export default { }