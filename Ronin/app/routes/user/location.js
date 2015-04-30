import Ember from 'ember';
import ENV from '../../config/environment';

export default Ember.Route.extend({
    model: function(){
        var userID = Cookies.get('userID');
        var locationURL = ENV.serverURL + '/user/' + userID + '/location';
        return $.get(locationURL).then( function(resp){
            return resp;
        });
    },
    renderTemplate: function(){
        this.render({outlet: 'user'});
    }
});