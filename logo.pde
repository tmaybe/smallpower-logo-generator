 
// globals
SmallLayer[] layers;
boolean blackstroke;
boolean drawn;
// 1650 x 990
float side = round(random(21.0, 750.0));
float columns = round(1650 / side);
float rows = round(990 / side);

// Setup the Processing Canvas
void setup(){
	size(side * columns, side * rows);
	strokeWeight(0);
	frameRate(24);

	// remember
	drawn = false;

	// data
	// xpos, ypos, maxr, likely

	SmallSpot ls1 = new SmallSpot(side * 0.337931034, side * 0.337931034, side * 0.517241379, 1.0);
	SmallSpot ls2 = new SmallSpot(side * 0.586206897, side * 0.379310345, side * 0.517241379, 1.0);
	SmallSpot ls3 = new SmallSpot(side * 0.531034483, side * 0.627586207, side * 0.517241379, 1.0);
	SmallSpot ls4 = new SmallSpot(side * 0.268965517, side * 0.593103448, side * 0.172413793, 0.5);
	
	SmallSpot[] spots1 = {ls1, ls2, ls3};
	SmallSpot[] spots2 = {ls4};
	
	// maxcircles, array of spots
	SmallLayer ll1 = new SmallLayer(2, spots1);
	SmallLayer ll2 = new SmallLayer(1, spots2);
	
	layers = {ll1, ll2};
}

// Main draw loop
void draw(){
	if (drawn == false) {
		// Fill canvas white
		background(255);
		// no stroke
		noStroke(); 

		// decide whether the stroke will be black or greyscale
		blackstroke = (random(0, 1) < 0.25);
		
		float nextLeft = 0.0;
		float nextTop = 0.0;
		int numLogos = round(columns * rows);
		for (int logoIt=0; logoIt < numLogos; logoIt++) {
			// step through the layers
			int numl = layers.length;
			SmallLayer sl;
			for (int lc=0; lc < numl; lc++) {
				// remember the layer
				sl = layers[lc];
				// pick a random number of circles to be drawn on the spots on this layer
				int numC = floor(random(0, sl.maxcircles)) + 1;
				// step through the circles
				for (int cc=0; cc < numC; cc++) {
					// number of spots
					int nums = sl.spots.length;
					// stroke thickness (:NOTE: assumes thickness in each group is the same)
					int sthick = floor(random(0, sl.spots[0].maxr)) + 1;
					// the line color (black or grey)
					int greyv = round(random(0, 240));
					color strokeColor = (blackstroke == true) ? color(0, 0, 0) : color(greyv, greyv, greyv);
					// the fill color (always white)
					color fillColor = color(255, 255, 255);
					// reset the radius limit
					for (int src=0; src < nums; src++) {
						sl.spots[src].resetLimit();
					}

					// step through the spots
					SmallSpot ss;
					int cradius;
					ArrayList blueprints = new ArrayList();
					for (int sc=0; sc < nums; sc++) {
						// reference to the spot
						ss = sl.spots[sc];
						// maybe skip this one?
						if (random(0, 1) > ss.likely) { continue; }
						// the circle radius (max if this is the first group of circles)
						cradius = (cc > 0) ? floor(random(0, ss.limitr)) + 1 : ss.limitr;
						// reset the limit for next time
						ss.limitr = cradius;
						// make sure the inside's not larger than the outside
						if (sthick > cradius) { sthick = floor(random(0, cradius)) + 1; }
						// make a blueprint and save it
						Blueprint bp = new Blueprint(ss.xpos, ss.ypos, cradius, cradius - sthick, strokeColor, fillColor);
						blueprints.add(bp);
					}
        
					// draw the stroke circles
					int numbp = blueprints.size();
					Blueprint ba, bb;
					// draw the stroke circles
					for (int ca=0; ca < numbp; ca++) {
						ba = blueprints.get(ca);
						fill(ba.strokecolor);
						ellipse(ba.xpos + nextLeft, ba.ypos + nextTop, ba.sradius, ba.sradius);
						// println("circle at "+ba.xpos+", "+ba.ypos+" / radius: "+ba.sradius+" / color: "+ba.strokecolor+" / layer: "+lc+"-"+cc+"-s");
					}
					// draw the fill circles
					for (int cb=0; cb < numbp; cb++) {
						bb = blueprints.get(cb);
						fill(bb.fillcolor);
						ellipse(bb.xpos + nextLeft, bb.ypos + nextTop, bb.fradius, bb.fradius);
						// println("circle at "+bb.xpos+", "+bb.ypos+" / radius: "+bb.fradius+" / color: "+bb.fillcolor+" / layer: "+lc+"-"+cc+"-f");
					}
				}
			}
			// println("logoIt: "+logoIt+" / nextLeft: "+nextLeft+" nextTop: "+nextTop+" logoIt % 5: "+(logoIt % 5));
			nextLeft += side;
			if (logoIt % columns == columns - 1) {
				nextLeft = 0.0;
				nextTop += side;
			}
		}
	}
	drawn = true;
}

class Blueprint {
	float xpos, ypos, sradius, fradius;
	color strokecolor, fillcolor;
	Blueprint (float x, float y, float sr, float fr, color sc, color fc) {
		xpos = x;
		ypos = y;
		sradius = sr;
		fradius = fr;
		strokecolor = sc;
		fillcolor = fc;
	}
}

class SmallSpot { 
	float xpos, ypos, maxr, likely;
	// limitr keeps track of radius while drawing
	float limitr;
	SmallSpot (float x, float y, float mr, float li) {
		xpos = x;
		ypos = y;
		maxr = mr;
		likely = li;
		limitr = maxr;
	}
  
	// reset the radius limit
	void resetLimit() {
		limitr = maxr;
	}
}

class SmallLayer {
	float maxcircles;
	SmallSpot[] spots;
	SmallLayer (float mc, SmallSpot[] ss) {
		maxcircles = mc;
		int nums = ss.length;
		spots = new SmallSpot[nums];
		for(int i=0; i < nums; i++) {
			spots[i] = ss[i];
		}
	}
}

