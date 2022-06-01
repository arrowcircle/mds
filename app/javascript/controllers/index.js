// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"
import { Autocomplete } from 'stimulus-autocomplete'
import FlashController from "./flash_controller"

application.register('autocomplete', Autocomplete)
application.register("flash", FlashController)

const artistSearch = document.getElementById("artist_search");

if (artistSearch) {
  artistSearch.addEventListener('autocomplete.change', (event) => {
    const trackSearch = document.getElementById("track_search");
    trackSearch.dataset.autocompleteUrlValue = `/artists/${event.detail.value}/tracks/search`;
    const trackSearchInput = document.getElementById("playlist_track_name");
    trackSearchInput.disabled = false;
  })
}

