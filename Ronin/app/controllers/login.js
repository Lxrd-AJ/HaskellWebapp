/* global $ */
import Ember from 'ember';
import ENV from '../config/environment';

export default Ember.Controller.extend({
	username: null,
	password: null,
	actions: {
		login: function(){
            //make the request
            var url = ENV.serverURL + "/user/username/" + this.get("username") + "/password/" + this.get("password");
            $.get(url).then( function(response){
                Ember.Logger.log("Success: " + response);
                this.transitionToRoute('user');
            }.bind(this)).fail( function(response){
                Ember.Logger.log( "Error: " + response.responseText );
            }.bind(this));
		}
	}
});
