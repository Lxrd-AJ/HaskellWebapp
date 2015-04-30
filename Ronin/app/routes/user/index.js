import Ember from 'ember';
import ENV from '../../config/environment';

export default Ember.Route.extend({
    model: function(){
        //Get the users
        var userURL = ENV.serverURL + '/user';
        return $.get(userURL).then( function(resp){
            return resp;
        });
    },
    renderTemplate: function(){
        this.render({outlet: 'user'});
    }
});
