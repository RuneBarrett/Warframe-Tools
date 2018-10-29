public class ArcaneInfo { // implements Comparable<ArcaneInfo> 
  String name;
  int r0Price;
  int r3Price;
  int combValue;
  int diff;

  ArcaneInfo(String name, int r0Price, int r3Price) {
    this.name = name;
    this.r0Price = r0Price;
    this.r3Price = r3Price;
    combValue = r0Price+r3Price;
    diff = Math.abs(r0Price*10 - r3Price);
  }

  //public int compareTo(ArcaneInfo ai) {
  //  int lastCmp = combValue.compareTo(ai.combValue);
  //  return (lastCmp != 0 ? lastCmp : firstName.compareTo(n.firstName));
  //}

  public String toString() {
    return(
      name+" - R3 cheapest: "+((r0Price*10 - r3Price) > 0)+
      "\n\r\tR0: "+r0Price+
      "p | R3: "+r3Price+
      "p | Diff: "+diff + "\n\r");
  }
  public String toTextString() {
    return (name+
      "R0: "+r0Price+
      "p | R3: "+r3Price+
      "p | Diff: "+diff + "\n\r");
  }
}



class SortByValue implements Comparator<ArcaneInfo> 
{ 
  // Used for sorting in ascending order of 
  // roll number 
  public int compare(ArcaneInfo a, ArcaneInfo b) 
  { 
    return b.combValue - a.combValue;
  }
}