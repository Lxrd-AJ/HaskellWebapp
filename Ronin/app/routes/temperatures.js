import Ember from 'ember';
import ENV from '../config/environment';

export default Ember.Route.extend({
    model: function() {
        var tempURL = ENV.serverURL + "/temperature";
        return $.get(tempURL).then(function (temperatures) {
            return temperatures.reverse();
        });
    }

    
});