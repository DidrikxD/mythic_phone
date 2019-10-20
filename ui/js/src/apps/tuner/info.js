window.addEventListener('tuner-info-open-app', function() {
    $('#tuner-legal-container .inner-app').fadeIn();
});

window.addEventListener('tuner-info-close-app', function() {
    $('#tuner-legal-container .inner-app').fadeOut();
});

export default {}