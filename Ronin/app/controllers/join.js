import Ember from 'ember';
import ENV from '../config/environment';

export default Ember.Controller.extend({
    username: "",
    password: "",
    actions: {
        submitData: function(){
            //make a post request to the server
            var serverURL = ENV.serverURL + "/user/username/" + this.get("username") + "/password/" + this.get("password");
            $.post(serverURL).then(function(response){
                //store the response
                Cookies.set("userID", response.userID );
                this.transitionToRoute("user");
            }.bind(this));
        }
    }
});