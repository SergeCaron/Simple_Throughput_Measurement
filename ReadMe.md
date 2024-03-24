# Simple Throughput Measurement
As the name says, this is a quick and dirty throughput measurement between two endpoints, whether on the same system or between remote systems.

By design, this is a single-threaded task and it may be the source of the problem if the local CPU is underpowered.



Typical Usage:
- Run the script and select a file in the root of the selected endpoint.
- The script recursively compute a hash of all files on the selected endpoint. This presumes that the CPU utilization for this task has no incidence on the measurement. 

Sample output:
````
                 Test path: \\library\ArchivesDeveloppement
               Total bytes: 23,61GB
       Duration in seconds: 568,38
      Megabytes per second: 42,53
                     Files: 869
Average file size in bytes: 27,82MB
Press Enter to continue...:

````

You are left alone to interpret these results. In the example above, the minimum duration of this 23,61GB payload transfer over the network is approximately 204 seconds at a sustained rate of 95% of the bandwidth of a Gigabit network interface. This sample indeed ran over a Gigabit network and the 42,53 MB/s yields a troughput of roughly 350mbps. There probably is an issue on this path if you can compare the same payload using different endpoints.

A payload approximately 10 times the size of the above sample, read locally from a RAID array, yields the following results:
````
                 Test path: V:\SharedMedia
               Total bytes: 222,14GB
       Duration in seconds: 2374,07
      Megabytes per second: 95,81
                     Files: 9664
Average file size in bytes: 23,54MB
Press Enter to continue...:

````

Abstraction made of the equipment and software used in both samples, here the payload size ratio is 221,14/23,61 = 9,41. The product of the duration ratio (2374,07/568,38 = 4,177) by the troughput ratio (95,81/42,53 = 2,253) is 9,41. In this case, processing the payload takes too much time (hint: think Windows Security).



Your mileage will vary ;-)
