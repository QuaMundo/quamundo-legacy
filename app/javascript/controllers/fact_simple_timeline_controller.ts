// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

import { Controller } from "stimulus"
import { SimpleTimeline } from "../src/simple_timeline";

// Workaround due to compiler/type error
// see:
// https://github.com/stimulusjs/stimulus/issues/221#issuecomment-457275513
class FactSimpleTimelineControllerBase extends Controller {
  // Targets
  simpleTimelineTarget!: HTMLElement;

  // Values
  timelineStartValue: string;
  timelineEndValue: string;
  timelineAgeValue: string;
  factsUrlValue: string;
  factStartDateValue: string;
  factEndDateValue: string;
}

interface FactRange {
  start_date: Date;
  end_date: Date;
}

interface Fact extends FactRange {
  id?: number;
  name?: string;
  description?: string;
  world_id?: string;
  created_at?: string;
  updated_at?: string;
}

export default class extends (Controller as typeof FactSimpleTimelineControllerBase) {
  static targets = [
    'simpleTimeline'
  ]

  static values = {
    timelineStart: String,
    timelineEnd: String,
    factsUrl: String,
    factStartDate: String,
    factEndDate: String,
    timelineAge: String
  }

  private create_timeline(factsArray: Fact[]): void {
    // Filter out facts without start and end date
    const facts: Fact[] = factsArray.filter(f => (f.start_date || f.end_date));
    // Draw nothing if there is no fact
    if (facts.length < 1) { return; }

    const timelineRange = {
      start_date: new Date(this.timelineStartValue),
      end_date: new Date(this.timelineEndValue)
    };
    const timeline: SimpleTimeline = new SimpleTimeline(
      this.simpleTimelineTarget,
      timelineRange,
      facts
    );

    timeline.draw();

    // FIXME: Don't use hard coded selector!
    const bindTo: HTMLElement = this
    .simpleTimelineTarget
    .closest('div.collapse');
    if (bindTo == undefined) return;

    // https://getbootstrap.com/docs/4.5/components/collapse/
    // When using bootstrap collapse:
    // if collapse is closed, width of element is 0, so listen for
    // expand event (in bootstrap: 'shown.bs.collapse') and redraw
    // timeline
    // FIXME: This seems not to work (event not fired or catched) after
    // switching to TypeScript - so I'm using an MutationObserver instead
    /*
       bindTo.addEventListener(
       'shown.bs.collapse', function(e: Event) { this.timeline.redraw(); }
       );
     */

    // FIXME: Maybe it's possible to only use one observer calling
    // SimpleTimeline.redrawAll() ?
    const observer: MutationObserver = new MutationObserver((mutations, observer) => {
      if (bindTo.style.width || bindTo.style.height) {
        timeline.redraw();
      }
    });
    observer.observe(bindTo, { attributeFilter: ['style'] });
  }

  private get_facts_json(): void {
    // FIXME: Refactor error handling!
    fetch(this.factsUrlValue)
    .then(response => {
      if (response.ok) {
        return response.json()
      }
      else {
        throw('Error in fetching json data');
      }
    })
    .then(json => {
      // Ensure json is an array
      if (! (Array.isArray(json))) { json = [json]; }

      this.create_timeline(json);
    })
    .catch(e => console.log(e));
  }

  private get_facts_stimulus(): void {
    const startDate = this.factStartDateValue;
    const endDate = this.factEndDateValue;
    const facts: Fact[] = [{
      // FIXME: Add more fact attributes
      /*
      id: undefined,
      name: undefined,
      description: undefined,
      world_id: undefined,
      */
      start_date: startDate ? new Date(this.factStartDateValue) : undefined,
      end_date: endDate ? new Date(this.factEndDateValue) : undefined
    }];
    this.create_timeline(facts);
  }

  connect(): void {
    // return if no timelineAgeValue present
    if (!this.timelineAgeValue) { return; }

    if (this.factsUrlValue) {
      this.get_facts_json();
    }
    else {
      this.get_facts_stimulus();
    }

  }
}

