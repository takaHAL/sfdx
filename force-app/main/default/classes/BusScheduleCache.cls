public with sharing class BusScheduleCache {
  private Cache.OrgPartition part;
  String partitionName = 'local.BusSchedule';

  public BusScheduleCache() {
    if (partitionName != null) {
      Cache.OrgPartition orgPart = new Cache.OrgPartition(partitionName);
      part = orgPart;
    }
  }
  public void putSchedule(String busLine, Time[] schedule) {
    if (part != null) {
      part.put(busLine, schedule);
    }
  }
  public Time[] getSchedule(String busLine) {
    List<Time> schedule = new List<Time>();

    Object obj = part.get(busLine);

    Time t2;
    if (obj != null) {
      t2 = (Time) obj;
    }
    if (t2 != null) {
      schedule.add(t2);
    } else {
      Time t3 = Time.newInstance(8, 0, 0, 0);
      if (t3 != null) {
        schedule.add(t3);
      }
      Time t4 = Time.newInstance(17, 0, 0, 0);
      if (t4 != null) {
        schedule.add(t4);
      }
    }
    return schedule;
  }
}
