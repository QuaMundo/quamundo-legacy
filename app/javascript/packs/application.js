/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb
import "../src/application.scss"


// Import bootstrap
import 'bootstrap'
import 'startbootstrap-sb-admin-2/js/sb-admin-2'

// Import fontawesome svgs
import '../src/default-images'

// Use rails-ujs
import Rails from 'rails-ujs';

Rails.start();

// Use activestorage
import * as ActiveStorage from 'activestorage'

ActiveStorage.start()

console.log('Hello World from Webpacker')

