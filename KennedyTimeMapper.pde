/*
Reads in a Kennedy JSON file and maps date of Kennedy captures to the X axis and time to the Y axis.

This simple example shows how you can plot capture frequency over time.
*/

import java.text.SimpleDateFormat;
import java.util.Date;
import java.text.*;




SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

JSONArray jsonArray;

long startEpoch;
long endEpoch;

final int BORDER = 100;
final int MINUTES_IN_DAY = 1440;


void setup() {
	
	size(1024,800);
	smooth();
	chooseFileForProcessing();
}

void draw() {

	background(220);

	if (jsonArray != null) {
		if (startEpoch == 0) {
			startEpoch = getStartEpoch();
			endEpoch = getEndEpoch();
		}

		for (int i = 0; i < jsonArray.size(); i++) {
			
			long epoch = getEpoch(i);
			int numberOfMinutes = getNumberOfMinutes(i);
			float mappedX = map(epoch, startEpoch, endEpoch, BORDER, width-BORDER);
			float mappedY = map(numberOfMinutes,0,MINUTES_IN_DAY,BORDER,height-BORDER);
			fill(25, 182, 146);
			noStroke();
			ellipse(mappedX, mappedY,3, 3);
		}

		drawLabels();

	}
	
}

void drawLabels() {

	noStroke();
	fill(50);

	JSONObject jsonObject;
	Date date;
	SimpleDateFormat ft = new SimpleDateFormat ("EEE, d MMM yyyy");

	try {
		jsonObject = jsonArray.getJSONObject(0);
		date = format.parse(jsonObject.getString("captureDate"));
 		String endDate = ft.format(date);
 		jsonObject = jsonArray.getJSONObject(jsonArray.size()-1);
 		date = format.parse(jsonObject.getString("captureDate"));
 		String startDate = ft.format(date);
 		text(startDate, BORDER, height-BORDER+18);
 		stroke(50);
 		line(BORDER, height-BORDER, BORDER, height-BORDER-10);
 		text(endDate, width-BORDER-textWidth(endDate), height-BORDER+18);
 		line(width-BORDER, height-BORDER, width-BORDER, height-BORDER-10);
  } catch(ParseException pe) {
            
          }

}

long getStartEpoch() {

	try {
			JSONObject jsonObject = jsonArray.getJSONObject(jsonArray.size()-1);
			Date date = format.parse(jsonObject.getString("captureDate"));
			long epoch = date.getTime()/1000;
			return epoch;
		} catch(ParseException pe) {
            return -1;
          }
}

long getEndEpoch() {
	
	try {
			JSONObject jsonObject = jsonArray.getJSONObject(0);
			Date date = format.parse(jsonObject.getString("captureDate"));
			long epoch = date.getTime()/1000;
			return epoch;
		} catch(ParseException pe) {
            return -1;
          }
}

long getEpoch(int i) {
	
	try {
			JSONObject jsonObject = jsonArray.getJSONObject(i);
			Date date = format.parse(jsonObject.getString("captureDate"));
			long epoch = date.getTime()/1000;
			return epoch;
		} catch(ParseException pe) {
            return -1;
          }
}

int getNumberOfMinutes(int i) {
	try {
	JSONObject jsonObject = jsonArray.getJSONObject(i);
	Date date = format.parse(jsonObject.getString("captureDate"));
	SimpleDateFormat ft = new SimpleDateFormat ("H");
  	int hours =  int(ft.format(date));
  	ft = new SimpleDateFormat ("m");
  	int minutes = int(ft.format(date));
  	return (hours*60)+minutes;
  }catch(ParseException pe) {
            return -1;
          }
}





void chooseFileForProcessing() {

	selectInput("Select a JSON file to process:", "fileSelected");

}

void fileSelected(File selection) {
  if (selection == null) {
    exit();
  } else {
    parseJSONFile(selection.getAbsolutePath());
  }
}

void parseJSONFile(String path) {

	JSONObject json = loadJSONObject(path);

	jsonArray = json.getJSONArray("kennedy");

}