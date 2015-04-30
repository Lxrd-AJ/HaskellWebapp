import Ember from 'ember';
import ENV from '../config/environment';

export default Ember.Route.extend({
    model: function(){
        //Get some temperature stats
        var url = ENV.serverURL + "/temperature/stats";
        return $.get(url).then( function(response){
            return response;
        }).fail( function(response){
            Ember.Logger.log("Failed GET request => " + response.responseText );
        });
    }
});
