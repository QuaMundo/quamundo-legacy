// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

import { Controller } from "stimulus"

// Workaround due to compiler/type error
// see:
// https://github.com/stimulusjs/stimulus/issues/221#issuecomment-457275513
class LocationControllerBase extends Controller {
  coordsTarget!: HTMLInputElement;
}

export default class extends (Controller as typeof LocationControllerBase) {
  static targets: string[] = [
    "coords"
  ]

  getPosition(e): void {
    const coordsTarget: HTMLInputElement = this.coordsTarget;
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
}
