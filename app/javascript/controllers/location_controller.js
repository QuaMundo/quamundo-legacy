// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "coords"
  ]

  getPosition(e) {
    var coordsTarget = this.coordsTarget;
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        function(pos) {
          coordsTarget
            .value = pos.coords.latitude + ', ' + pos.coords.longitude;
        },
        function(err) {
          // FIXME: Show error mesg to user!
          console.log(err);
        }
      );
    }
  }

  connect() {
  }
}
