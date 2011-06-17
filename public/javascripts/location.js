var latitude, longitude, callback;

function checkGeoLocation() {
    return navigator.geolocation;
}
function updateLocation(fn) {
    if (checkGeoLocation())
    {
        callback = fn;
        navigator.geolocation.getCurrentPosition(savePosition);
        return true;
    } else {
        console.log('Device not capable of geo-location.');
        fn(false);
        return false;
    }                
}
function savePosition(position) {
    latitude = position.coords.latitude;
    longitude = position.coords.longitude;
    if (callback) {
        callback(getLocation());
    }
}
function getLocation() {
    if (latitude && longitude) {
        return {
            latitude: latitude,
            longitude: longitude
        }
    } else {
        console.log('No location available. Try calling updateLocation() first.');
        return false;
    }
}