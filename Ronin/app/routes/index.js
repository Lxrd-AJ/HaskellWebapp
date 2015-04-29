import Ember from 'ember';
import ENV from '../config/environment';

export default Ember.Route.extend({
    model: function(){
        //Get some temperature stats
        var url = ENV.serverURL + "/temperature/stats";
        return $.get(url).then( function(response){
            var tempURL = ENV.serverURL + "/temperature";
            return $.get(tempURL).then( function(temperatures){
                return {
                    "average": response.average,
                    "sum": response.sum,
                    "total": response.total,
                    "highest": response.highest,
                    "lowest": response.lowest,
                    "temperatures": temperatures
                };
            });
        }).fail( function(response){
            Ember.Logger.log("Failed GET request => " + response.responseText );
        });
    }
});
