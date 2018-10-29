import java.util.*; 
import java.lang.*; 
import java.io.*;

JSONArray values;
ArrayList<String> arcaneNames;// = new ArrayList<String>();
ArrayList<ArcaneInfo> arcaneInfoList;// = new ArrayList<ArcaneInfo>();
JSONArray orders;
int xA, yA, xB, yB, yInc;

void setup() {
  background(0);
  size(600, 600);
  textSize(14);
  xA = 10; 
  yA = 10;
  xB = width/2+xA;
  yB = yA;
  yInc = 26;

  values = loadJSONArray("arcanes.json");
  arcaneNames = new ArrayList<String>();
  arcaneInfoList = new ArrayList<ArcaneInfo>();

  //Get local data from arcanes.json
  for (int i = 0; i < values.size(); i++) 
    arcaneNames.add(values.getJSONObject(i).getString("name").toLowerCase().replace(" ", "_"));


  //Get orders for each item from market
  for (int i = 0; i < arcaneNames.size(); i++) {
    print(" . ");
    if (!(arcaneNames.get(i).substring(0, 6).equals("arcane"))) continue;

    print(arcaneNames.get(i)+", ");
    orders = loadJSONObject("https://api.warframe.market/v1/items/"+arcaneNames.get(i)+"/orders").getJSONObject("payload").getJSONArray("orders");

    int lowestR0 = 9999999;
    int lowestR3 = 9999999;
    print(" orders: "+orders.size());
    for (int j = 0; j < orders.size(); j++) {     
      JSONObject o = (JSONObject)orders.get(j);
      if (o.getJSONObject("user").getString("status").equals("ingame") && o.getString("platform").equals("pc") && o.getString("order_type").equals("sell")) {
        int price = o.getInt("platinum");

        if (!o.isNull("mod_rank")) {
          if (o.getInt("mod_rank") == 0) 
            if (price < lowestR0) lowestR0 = price;
          if (o.getInt("mod_rank") == 3) 
            if (price < lowestR3) lowestR3 = price;
        } else {
          println("\n\r!!!!!!! no mod_rank field in order: "+j+", of " +arcaneNames.get(i) +" from user "+o.getJSONObject("user").getString("ingame_name"));
        }
      }
    }
    if (lowestR0 == 9999999) lowestR0 = -1;
    if (lowestR3 == 9999999) lowestR3 = -1;

    arcaneInfoList.add(new ArcaneInfo(arcaneNames.get(i), lowestR0, lowestR3));
  }
  println("\n\r");
  Collections.sort(arcaneInfoList, new SortByValue());
  for (int i = 0; i < arcaneInfoList.size(); i++)
    println(arcaneInfoList.get(i));
  println(System.currentTimeMillis());

  drawResults();
}



void drawResults() {
  text("R0 Cheapest", xA, yA);
  text("R3 Cheapest", xB, yB);
  yA += yInc;
  yB += yInc;
  for (int i = 0; i < arcaneInfoList.size(); i++) {

    ArcaneInfo a = arcaneInfoList.get(i);
    if ((a.r0Price*10 - a.r3Price) > 0) {
      text(a.name, xA, yA);
      text("R0: "+a.r0Price+
        "p | R3: "+a.r3Price+
        "p | Diff: "+a.diff, xA, yA+yInc/2);
      yA+=yInc;
    } else {
      text(a.name, xB, yB);
      text("R0: "+a.r0Price+
        "p | R3: "+a.r3Price+
        "p | Diff: "+a.diff, xB, yB+yInc/2);
      yB+=yInc;
    }
  }
}