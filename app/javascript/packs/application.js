// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//= require handlebars.runtime
//= require_tree ./templates

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import 'jquery'
import "@nathanvda/cocoon"
const GistClient = require("gist-client")
const gistClient = new GistClient()
import './answers'
import './questions'
import './votes'

window.jQuery = $;
window.$ = $;
window.gistClient = gistClient;


Rails.start()
Turbolinks.start()
ActiveStorage.start()