import Ember from 'ember';
import ENV from '../../config/environment';

export default Ember.Controller.extend({
    locationName: "",
    tempValue: "",
    tempDate: null,
    locationID : "",
    clear: function(){
        this.set('locationName',"");
        this.set('tempValue',"");
        this.set('tempDate', "");
        this.set('locationID',"");
    },
    actions: {
        submitData: function(){
            var userID = Cookies.get('userID');
            var locationURL = ENV.serverURL + '/user/' + userID + '/location/' + this.get('locationName');
            if( this.get('locationName') !== '' ){
                $.post(locationURL).then(function(){
                    location.reload();
                }.bind(this));
            }
        },

        submitTemperatures: function(){
            var temp = this.get('tempValue');
            var userID = Cookies.get('userID');
            var tempDate = this.get('tempDate');
            var locationID = this.get('locationID');
            if( temp !== '' && tempDate && locationID !== '') {
                tempDate = new Date(tempDate).toISOString();
                var tempURL = ENV.serverURL + '/user/' + userID + '/location/' + locationID + '/temperature/date/' +
                    tempDate + '/temp/' + temp;
                $.post(tempURL).then(function(){
                    this.clear();
                }.bind(this));
            }
        }
    }
});