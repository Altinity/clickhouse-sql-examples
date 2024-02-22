# Examples for ConFoo 2024 Talk

[Transactions? Pah! Joins? Overrated! Adventures in fast big data](https://confoo.ca/en/2024/session/transactions-pah-joins-overrated-adventure-in-fast-big-data)

## How to run Java example code. 
(It's just playing around and not part of the talk.)

1. Install maven. 
2. Edit src/java/main/com/altinity/demo/App.java to add correct account and host name for MySQL. 
3. From this directory execute `mvn compile exec:java -Dexec.mainClass="com.altinity.demo.App" -Dexec.cleanupDaemonThreads=false`.
