/* global $ */
import Ember from 'ember';
import ENV from '../config/environment';

export default Ember.Controller.extend({
	username: null,
	password: null,
	actions: {
		login: function(){
			if( ENV.environment == "production" ){
				//make the request
				var url = ENV.serverURL + "/user";
				var data = {
					"username": this.get('username'),
					"password": this.get('password')
				};
				$.get(url, data ).then( function(response){
					Ember.Logger.log(response);
					this.transitionToRoute('user');
				}.bind(this)).fail( function(response){
					Ember.Logger.log( "Error: " + response.responseText );
				}.bind(this));
			}else{
				//Development mode, just transition to the user page
				this.transitionToRoute('user');
			}
		}
	}
});
