# How to run sample program. 

1. Install maven. 
2. Edit src/java/main/com/altinity/demo/App.java to add correct account and host name for MySQL. 
3. From this directory execute `mvn compile exec:java -Dexec.mainClass="com.altinity.demo.App" -Dexec.cleanupDaemonThreads=false`.
