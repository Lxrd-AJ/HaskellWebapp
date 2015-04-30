import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
    this.route('login');
    this.route('temperatures');
    this.route('join');
    this.route('user', function(){
        this.route('index', {path: '/'});
        this.route('location');
    });
});

export default Router;
