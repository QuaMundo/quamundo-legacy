import * as d3 from "d3";

const Height: number = 8;               // height of timeline bar
const SVGHeight: number = 30;           // height, including labels
const StrokeWidth: number = 1;
const TimelineColor: string = 'orange'; // color of timeline bar
const MinLength: number = 8;            // minimal length of timeline rect
const ArrowWidth: number = 6;           // width of marker triangle

window.onresize = () => SimpleTimeline.redrawAll();

interface TimelineRange {
  start_date?: Date;
  end_date?: Date;
}

interface Fact extends TimelineRange {
  id?: number;
  name?: string;
  description?: string;
  world_id?: string;
  created_at?: string;
  updated_at?: string;
}

export class SimpleTimeline {
  private element: HTMLElement;
  private timelineRange: TimelineRange;
  private facts: Fact[];
  private scale;
  private svg;
  private localData;
  private worldGroup;
  private factGroup;
  private xAxis;
  private label;

  private static timelines: SimpleTimeline[] = [];

  static redrawAll(): void {
    SimpleTimeline.timelines.forEach(
      (e) => {
        if (e.localData.get(e.svg) != e.width) {
          e.clear();
          e.draw();
          e.localData.set(e.svg, e.width);
        }
      }
    );
  }

  constructor(selection: HTMLElement,
              timelineRange: TimelineRange,
              facts: Fact[] = []) {
    SimpleTimeline.timelines.push(this);

    this.element = selection;
    this.timelineRange = timelineRange;

    this.facts = this.processFacts(facts);

    this.scale = d3.scaleTime()
      .domain([this.timelineRange.start_date, this.timelineRange.end_date]);

    this.svg = d3.select(this.element)
      .append('svg')
      .classed('simple-timeline', true)
      .attr('width', '100%')
      .attr('height', SVGHeight)
      .attr('preserveAspectRatio', 'none');

    // store width in d3 local variable to check if redraw is neccessary
    this.localData = d3.local();
    this.localData.set(this.svg, this.width);

    this.worldGroup = this.svg.append('g')
      .classed('simple-timeline-world-group', true);

    this.factGroup = this.svg.append('g')
      .classed('simple-timeline-fact-group', true);

    this.xAxis = d3.axisBottom()
      .scale(this.scale)
      .ticks(4);
    this.label = this.svg.append('g')
      .attr('transform', 'translate(0, ' + Height + ')');

    this.label.selectAll('line, path')
      .attr('vector-effect', 'non-scaling-stroke');
  }

  draw(): void {
    this.init();
    this.drawWorld();
    this.drawFacts();
    this.drawLabels();
  }

  redraw(): void {
    if (this.localData.get(this.svg) != this.width) {
      this.localData.set(this.svg, this.width);
      this.clear();
      this.draw();
    }
  }

  clear(): void {
    this.factGroup.selectAll('rect, polygon').remove();
    this.worldGroup.selectAll('*').remove();
    this.label.selectAll('*').remove();
  }

  get width(): number   { return this.element.getBoundingClientRect().width; }

  private processFacts(facts: Fact[]): Fact[] {
    return facts.map((i) => {
      return {
        id: i.id ? i.id : undefined,
        start_date: i.start_date ? i.start_date : this.timelineRange.start_date,
        end_date: i.end_date ? i.end_date : this.timelineRange.end_date
      };
    });
  }
  private init(): void {
    // set viewbox of svg
    this
      .svg
      .attr('viewBox', [0, 0, this.width + 2 * StrokeWidth, SVGHeight])
    // set scale range
    this.scale.range([0, this.width]);
  }

  private drawWorld(): void {
    this.worldGroup.append('rect')
      .attr('x', 0)
      .attr('y', 0)
      .attr('width', this.width)
      .attr('height', Height)
      .attr('stroke', 'none')
      .attr('fill', '#eeeeee')
      .attr('vector-effect', 'non-scaling-stroke');
  }

  private drawFacts(): void {
    const timeline: SimpleTimeline = this;
    this.factGroup.selectAll('rect')
      .data(timeline.facts)
      .enter()
      .each(function(data, index) {
        const start = timeline.scale(new Date(data.start_date));
        const end   = timeline.scale(new Date(data.end_date));
        const dur   = end - start;
        if (dur < MinLength) {
          // range is too short, draw marker
          const center = start + dur / 2.0,
            points = [
              center - ArrowWidth,      0,
              center + ArrowWidth,      0,
              center,                   Height
          ];
          d3.select(this)
            .append('polygon')
            .attr('points', points)
            .attr('stroke', TimelineColor)
            .attr('stroke-width', StrokeWidth)
            .attr('fill', TimelineColor)
            .attr('vector-effect', 'non-scaling-stroke')
            .classed('fact tiny-fact', true);
        }
        else {
          // draw rect
          d3.select(this)
            .append('rect')
            .attr('x', start)
            .attr('y', 0)
            .attr('width', dur)
            .attr('height', Height)
            .attr('stroke', TimelineColor)
            .attr('stroke-width', StrokeWidth)
            .attr('fill', TimelineColor)
            .attr('vector-effect', 'non-scaling-stroke')
            .classed('fact ranged-fact', true);
        }
      });
  }

  private drawLabels() {
    // add labels (this.label.call(this.xAxis)
    this.label.call(this.xAxis);
  }
}
