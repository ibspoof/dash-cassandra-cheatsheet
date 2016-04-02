cheatsheet do
    title 'cassandra.yaml' # Will be displayed by Dash in the docset list
    docset_file_name 'cassandra'    # Used for the filename of the docset
    keyword 'cassandra'             # Used as the initial search keyword (listed in Preferences > Docsets)
    # resources 'resources_dir'  # An optional resources folder which can contain images or anything else

    # introduction 'cassandra.yaml config'  # Optional, can contain Markdown or HTML

    style '
.name h1, .name h1 code {
  font-size: 1.3em;
  color: #666;
  margin-top:-4px;
  margin-bottom: 8px;
}

section.category .notes h2{
  font-size: 1.0em;
  margin-bottom: 5px;
  font-weight: bold;
  text-align: left;
  color: #4a4848;
}

section.category .notes h2 em {
  font-weight: normal;
}

section.category .notes .notice {
  background-color: #d9edf7;
  border-color: #bce8f1;
  color: #31708f;
  padding:15px;
  margin-bottom: 20px;
  border-radius: 4px;
}

.notes {
  margin-bottom: 20px;
}

div.indent {
    margin-left: 25px;
}

'


    # A cheat sheet must consist of categories
    category do
        id 'Main' # Must be unique and is used as title of the category

        entry do
            name '# cluster_name' # A short name, can contain Markdown or HTML
            notes '## Default: _\'Test Cluster\'_

            The name of the cluster. This is mainly used to prevent machines in one logical cluster from joining another.'
        end

        entry do
            name '# num_tokens'
            notes '## Default: _256_

            This defines the number of tokens randomly assigned to this node on the ring
       The more tokens, relative to other nodes, the larger the proportion of data
       that this node will store. You probably want all nodes to have the same number
       of tokens assuming they have equal hardware capability.

       If you leave this unspecified, Cassandra will use the default of 1 token for legacy compatibility,
       and will use the ``initial_token``.

       Specifying ``initial_token`` will override this setting on the node\'s initial start,
       on subsequent starts, this setting will apply even if initial token is set.

       If you already have a cluster with 1 token per node, and wish to migrate to
       multiple tokens per node, see http://wiki.apache.org/cassandra/Operations'
        end

        entry do
            name '# initial_token'
            notes '## Default:

      Allows you to specify tokens manually.  While you can use # it with
      vnodes (num_tokens > 1, above) -- in which case you should provide a
      comma-separated list -- it\'s primarily used when adding nodes # to legacy clusters
      that do not have vnodes enabled.'
        end

        entry do
            name '# endpoint_snitch'
            notes '## Default: _SimpleSnitch_

            Set this to a class that implements
            IEndpointSnitch.  The snitch has two functions:

            <div class="indent">
            - it teaches Cassandra enough about your network topology to route
            requests efficiently

            - it allows Cassandra to spread replicas around your cluster to avoid
            correlated failures. It does this by grouping machines into
            "datacenters" and "racks."  Cassandra will do its best not to have
            more than one replica on the same "rack" (which may not actually
            be a physical location)
            </div>

            <div class="notice">NOTE: If you change the snitch after data is inserted into the cluster,
            you must run a full repair, since the snitch affects where replicas
            are placed.</div>


            Out of the box, Cassandra provides:
<div class="indent">
            **SimpleSnitch**<br/>
            Treats Strategy order as proximity. This can improve cache
            locality when disabling read repair.  Only appropriate for
            single-datacenter deployments.

            **GossipingPropertyFileSnitch**<br/>
            This should be your go-to snitch for production use.  The rack
            and datacenter for the local node are defined in
            cassandra-rackdc.properties and propagated to other nodes via
            gossip.  If cassandra-topology.properties exists, it is used as a
            fallback, allowing migration from the PropertyFileSnitch.

            **PropertyFileSnitch**<br/>
            Proximity is determined by rack and data center, which are
            explicitly configured in cassandra-topology.properties.

            **Ec2Snitch**<br/>
            Appropriate for EC2 deployments in a single Region. Loads Region
            and Availability Zone information from the EC2 API. The Region is
            treated as the datacenter, and the Availability Zone as the rack.
            Only private IPs are used, so this will not work across multiple
            Regions.

            **Ec2MultiRegionSnitch**<br/>
            Uses public IPs as ``broadcast_address`` to allow cross-region
            connectivity.  (Thus, you should set seed addresses to the public
            IP as well.) You will need to open the ``storage_port`` or
            ``ssl_storage_port`` on the public IP firewall.  (For intra-Region
            traffic, Cassandra will switch to the private IP after
            establishing a connection.)

            **RackInferringSnitch**<br/>
            Proximity is determined by rack and data center, which are
            assumed to correspond to the 3rd and 2nd octet of each node\'s IP
            address, respectively.  Unless this happens to match your
            deployment conventions, this is best used as an example of
            writing a custom Snitch class and is provided in that spirit.
</div>
<br/>
## Additional Snitches:

<div class="indent">

<b>GoogleCloudSnitch</b>:<br/>
Use the GoogleCloudSnitch for Cassandra deployments on [Google Cloud Platform](https://cloud.google.com/) across one or more regions. The region is treated as a data center and the availability zones are treated as racks within the data center. All communication occurs over private IP addresses within the same logical network.
Note: Data center and rack names are case-sensitive.
<br/>
<br/>
<b>CloudstackSnitch</b>:<br/>
Use the CloudstackSnitch for Apache Cloudstack environments. Because zone naming is free-form in Apache Cloudstack, this snitch uses the widely-used {country} {location} {az} notation.
</div>
<br/>
        You can use a custom Snitch by setting this to the full class name
            of the snitch, which will be assumed to be on your classpath.
       '
        end

        entry do
            name '# seeds'
            notes '## Default: _"127.0.0.1"_

            Addresses of hosts that are deemed contact points.
            Cassandra nodes use this list of hosts to find each other and learn
            the topology of the ring.  You must change this if you are running
            multiple nodes!

          '
        end



        entry do
            name '# listen_address'
            notes '## Default: _localhost_

             Address to bind to and tell other Cassandra nodes to connect to.
     You _must_ change this if you want multiple nodes to be able to communicate!

     Set ``listen_address`` OR ``listen_interface``, _not both_. Interfaces must correspond
     to a single address, IP aliasing is not supported.

     Leaving it blank leaves it up to InetAddress.getLocalHost(). This
     will always do the Right Thing _if_ the node is properly configured
     (hostname, name resolution, etc), and the Right Thing is to use the
     address associated with the hostname (it might not be).

     Setting ``listen_address`` to 0.0.0.0 _is always wrong_.
          '
        end

        entry do
            name '# listen\_interface'
            notes '## Default: _eth0_

             Interface to bind to and tell other Cassandra nodes to connect to.

     Set ``listen_address`` OR ``listen_interface``, not both. Interfaces must correspond
     to a single address, IP aliasing is not supported.

     If you choose to specify the interface by name and the interface has an ipv4 and an ipv6 address
 you can specify which should be chosen using ``listen_interface_prefer_ipv6``. If false the first ipv4
 address will be used. If true the first ipv6 address will be used. Defaults to false preferring
 ipv4. If there is only one address it will be selected regardless of ipv4/ipv6.

          '
        end

        entry do
            name '# listen\_interface\_prefer\_ipv6'
            notes '## Default: _false_

            If true the first ipv6 address found on the interface will be used. Defaults to false preferring
           ipv4. If there is only one address it will be selected regardless of ipv4/ipv6.
          '
        end

        entry do
            name '# broadcast_address'
            notes '## Default: _(disabled)_

            Address to broadcast to other Cassandra nodes.

            Leaving this blank will set it to the same value as ``listen_address``.
          '
        end


        entry do
            name '# rpc\_address'
            notes '## Default: _localhost_

             The address or interface to bind the Thrift RPC service and native transport
             server to.

             Set ``rpc_address`` OR ``rpc_interface``, not both. Interfaces must correspond
             to a single address, IP aliasing is not supported.

             Leaving ``rpc_address`` blank has the same effect as on listen_address
             (i.e. it will be based on the configured hostname of the node).

             <div class="notice">Note: unlike listen_address, you can specify 0.0.0.0, but you must also
             set ``broadcast_rpc_address`` to a value other than 0.0.0.0.</div>

             For security reasons, you should not expose this port to the internet.  Firewall it if needed.
          '
        end

        entry do
            name '# rpc\_interface'
            notes '## Default: _(diabled)_

            Set ``rpc_address`` OR ``rpc_interface``, not both. Interfaces must correspond
            to a single address, IP aliasing is not supported.
          '
        end

        entry do
            name '# rpc\_interface\_prefer\_ipv6'
            notes '## Default: _false_

            If you choose to specify the interface by name and the interface has an ipv4 and an ipv6 address
            you can specify which should be chosen using ``rpc_interface_prefer_ipv6``. If false the first ipv4
            address will be used. If true the first ipv6 address will be used. Defaults to false preferring
            ipv4.

            If there is only one address it will be selected regardless of ipv4/ipv6.
          '
        end

        entry do
            name '# rpc\_port'
            notes '## Default: _9160_

            Port for Thrift to listen for clients on
          '
        end


    end

    category do
        id 'File Location & Policies'

        entry do
            name '# data\_file\_directories'
            notes '## Default: _/var/lib/cassandra/data_

            Directories where Cassandra should store data on disk.  Cassandra
             will spread data evenly across them, subject to the granularity of
             the configured compaction strategy.

             If not set, the default directory is ``$CASSANDRA_HOME/data/data.``'
        end

        entry do
            name '# commitlog_directory'
            notes '## Default: _/var/lib/cassandra/commitlog_

            When running on magnetic HDD, this should be a
       separate spindle than the data directories.

       If not set, the default directory is ``$CASSANDRA_HOME/data/commitlog.``'
        end

        entry do
            name '# commitlog_sync'
            notes '## Default: _periodic_

             May be either "periodic" or "batch."

 When in batch mode, Cassandra won\'t ack writes until the commit log
 has been fsynced to disk.  It will wait ``commitlog_sync_batch_window_in_ms``
 milliseconds between fsyncs.

 This window should be kept short because the writer threads will
 be unable to do extra work while waiting.  (You may need to increase
 ``concurrent_writes`` for the same reason.)

 Alternative option:

 - commitlog_sync: batch
 - commitlog\_sync\_batch\_window\_in\_ms: 2

 The other option is "periodic" where writes may be acked immediately
 and the CommitLog is simply synced every ``commitlog_sync_period_in_ms``
 milliseconds.

            '
        end

        entry do
            name '# commitlog\_sync\_period\_in\_ms'
            notes '## Default: _10000_

            This window should be kept short because the writer threads will
            be unable to do extra work while waiting.  (You may need to increase
            ``concurrent_writes`` for the same reason.)
            '
        end

        entry do
            name '# commitlog\_segment\_size\_in\_mb'
            notes '## Default: _32_

             The size of the individual commitlog file segments.  A commitlog
 segment may be archived, deleted, or recycled once all the data
 in it (potentially from each columnfamily in the system) has been
 flushed to sstables.

 The default size is 32, which is almost always fine, but if you are
 archiving commitlog segments (see commitlog_archiving.properties),
 then you probably want a finer granularity of archiving; 8 or 16 MB
 is reasonable.
            '
        end

        entry do
            name '# commitlog\_segment\_recycling'
            notes '## Default: _false_

            Reuse commit log files when possible. The default is false, and this
feature will be removed entirely in future versions of Cassandra.
            '
        end

        entry do
            name '# disk\_failure\_policy'
            notes '## Default: _stop_

            Policies for data disk failures:
<div class="indent">
            **die**: shut down gossip and client transports and kill the JVM for any fs errors or
                 single-sstable errors, so the node can be replaced.

            **stop_paranoid**: shut down gossip and client transports even for single-sstable errors,
                           kill the JVM for errors during startup.

            **stop**: shut down gossip and client transports, leaving the node effectively dead, but
                  can still be inspected via JMX, kill the JVM for errors during startup.

            **best_effort**: stop using the failed disk and respond to requests based on
                         remaining available sstables.  This means you WILL see obsolete
                         data at CL.ONE!

  **ignore**: ignore fatal errors and let requests fail, as in pre-1.2 Cassandra
</div>
       '
        end


        entry do
            name '# commit\_failure\_policy'
            notes '## Default: _stop_

 Policy for commit disk failures:
 <div class="indent">
 **die**: shut down gossip and Thrift and kill the JVM, so the node can be replaced.

 **stop**: shut down gossip and Thrift, leaving the node effectively dead, but
       can still be inspected via JMX.

 **stop_commit**: shutdown the commit log, letting writes collect but
              continuing to service reads, as in pre-2.0.5 Cassandra

 **ignore**: ignore fatal errors and let the batches fail
</div>
       '
        end


        entry do
            name '# saved\_caches\_directory'
            notes '## Default: _/var/lib/cassandra/saved\_caches_

            If not set, the default directory is ``$CASSANDRA_HOME/data/saved_caches``.
       '
        end



    end

    category do
        id 'Authentication & Security'

        entry do
            name '# authenticator'
            notes '## Default: _AllowAllAuthenticator_

            Authentication backend, implementing IAuthenticator; used to identify users
 Out of the box, Cassandra provides:
<div class="indent">

**AllowAllAuthenticator** performs no checks - set it to disable authentication.

**PasswordAuthenticator** relies on username/password pairs to authenticate
   users. It keeps usernames and hashed passwords in system_auth.credentials table.
   Please increase system_auth keyspace replication factor if you use this authenticator.
</div>
            '
        end

        entry do
            name '# authorizer'
            notes '## Default: _AllowAllAuthorizer_

            Authorization backend, implementing IAuthorizer; used to limit access/provide permissions
 Out of the box, Cassandra provides:
<div class="indent">
 **AllowAllAuthorizer** allows any action to any user - set it to disable authorization.

 **CassandraAuthorizer** stores permissions in system_auth.permissions table. Please
   increase system_auth keyspace replication factor if you use this authorizer.
</div>
            '
        end

        entry do
            name '# permissions\_validity\_in\_ms'
            notes '## Default: _2000_

            Validity period for permissions cache (fetching permissions can be an
 expensive operation depending on the authorizer, CassandraAuthorizer is
 one example). Defaults to 2000, set to 0 to disable.

 Will be disabled automatically for AllowAllAuthorizer.
            '
        end

        entry do
            name '#  permissions\_update\_interval\_in\_ms'
            notes '## Default: _1000_

            Refresh interval for permissions cache (if enabled).

 After this interval, cache entries become eligible for refresh. Upon next
 access, an async reload is scheduled and the old value returned until it
 completes. If permissions_validity_in_ms is non-zero, then this must be
 also.

 Defaults to the same value as permissions\_validity\_in\_ms.
            '
        end


        entry do
            name '# server\_encryption\_options'
            notes '## Default:

            Enable or disable inter-node encryption

            Default settings are TLS v1, RSA 1024-bit keys (it is imperative that
            users generate their own keys) ``TLS_RSA_WITH_AES_128_CBC_SHA`` as the cipher
            suite for authentication, key exchange and encryption of the actual data transfers.
            Use the DHE/ECDHE ciphers if running in FIPS 140 compliant mode.

            <div class="notice">NOTE: No custom encryption options are enabled at the moment, the available internode options are : all, none, dc, rack</div>

            If set to dc cassandra will encrypt the traffic between the DCs, If set to rack cassandra will encrypt the traffic between the racks

            The passwords used in these options must match the passwords used when generating
            the keystore and truststore.  For instructions on generating these files, see:
            http://download.oracle.com/javase/6/docs/technotes/guides/security/jsse/JSSERefGuide.html#CreateKeystore

            Sub configurations:
            <div class="indent">
            <pre>
internode\_encryption: none
keystore: conf/.keystore
keystore\_password: cassandra
truststore: conf/.truststore
truststore\_password: cassandra
protocol: TLS
algorithm: SunX509
store\_type: JKS
cipher\_suites: [TLS\\_RSA\\_WITH\\_AES\\_128\\_CBC\\_SHA,TLS\\_RSA\\_WITH\\_AES\\_256\\_CBC\\_SHA,TLS\\_DHE\\_RSA\\_WITH\\_AES\\_128\\_CBC\\_SHA,TLS\\_DHE\\_RSA\\_WITH\\_AES\\_256\\_CBC\\_SHA,TLS\\_ECDHE\\_RSA\\_WITH\\_AES\\_128\\_CBC\\_SHA,TLS\\_ECDHE\\_RSA\\_WITH\\_AES\\_256\\_CBC\\_SHA]
require\_client\_auth: false
            </pre></div>
            Read more about server certificates at: http://docs.datastax.com/en/cassandra/2.0/cassandra/security/secureSSLCertificates_t.html
            '
        end


        entry do
            name '# server\_encryption\_options'
            notes '## Default:

            Enable or disable client/server encryption.

            Sub configurations:
            <div class="indent">
            <pre>
enabled: false
keystore: conf/.keystore
keystore\_password: cassandra
require\_client_auth: false
\# Set trustore and truststore_password if require\_client\_auth is true
truststore: conf/.truststore
truststore\_password: cassandra
protocol: TLS
algorithm: SunX509
store\_type: JKS
cipher\_suites: [TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA,TLS_DHE_RSA_WITH_AES_128_CBC_SHA,TLS_DHE_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA]
</pre>
            </div>
            '
        end


    end

    category do
        id 'Cache & Memory'

        entry do
            name '# key\_cache\_size\_in\_mb'
            notes '## Default: _(auto)_

            Maximum size of the key cache in memory.

            Each key cache hit saves 1 seek and each row cache hit saves 2 seeks at the
            minimum, sometimes more. The key cache is fairly tiny for the amount of
            time it saves, so it\'s worthwhile to use it at large numbers.

            The row cache saves even more time, but must contain the entire row,
             so it is extremely space-intensive. It\'s best to only use the
             row cache if you have hot rows or static rows.

            <div class="notice">NOTE: if you reduce the size, you may not get you hottest keys loaded on startup.</div>

             Default value is empty to make it "auto" (min(5% of Heap (in MB), 100MB)). Set to 0 to disable key cache.

            '
        end

        entry do
            name '# key\_cache\_save\_period'
            notes '## Default: _14400_

            Duration in seconds after which Cassandra should
            save the key cache. Caches are saved to ``saved_caches_directory`` as
            specified in this configuration file.

            Saved caches greatly improve cold-start speeds, and is relatively cheap in
             terms of I/O for the key cache. Row cache saving is much more expensive and
             has limited use.

             Default is _14400_ or 4 hours.
            '
        end



        entry do
            name '# key\_cache\_keys\_to\_save'
            notes '## Default: _(disabled)_

            Number of keys from the key cache to save.

            Disabled by default, meaning all keys are going to be saved.
            '
        end



        entry do
            name '# row\_cache\_size\_in\_mb'
            notes '## Default: _0_

            Maximum size of the row cache in memory.

            <div class="notice">NOTE: if you reduce the size, you may not get you hottest keys loaded on startup.</div>

            Default value is _0_, to disable row caching.
            '
        end


        entry do
            name '# row\_cache\_save\_period'
            notes '## Default: _0_

            Duration in seconds after which Cassandra should
            save the row cache. Caches are saved to ``saved_caches_directory`` as specified
            in this configuration file.

            Saved caches greatly improve cold-start speeds, and is relatively cheap in
            terms of I/O for the key cache. Row cache saving is much more expensive and
            has limited use.

            Default is _0_ to disable saving the row cache.
            '
        end


        entry do
            name '# row\_cache\_keys\_to\_save'
            notes '## Default: _(disabled)_

            Number of keys from the row cache to save

            Disabled by default, meaning all keys are going to be saved
            '
        end

        entry do
            name '# counter\_cache\_size\_in\_mb'
            notes '## Default: _(auto)_

             Maximum size of the counter cache in memory.

             Counter cache helps to reduce counter locks\' contention for hot counter cells.

             In case of RF = 1 a counter cache hit will cause Cassandra to skip the read before
             write entirely. With RF > 1 a counter cache hit will still help to reduce the duration
             of the lock hold, helping with hot counter cell updates, but will not allow skipping
             the read entirely. Only the local (clock, count) tuple of a counter cell is kept
             in memory, not the whole counter, so it\'s relatively cheap.

             NOTE: if you reduce the size, you may not get you hottest keys loaded on startup.

             Default value is empty to make it "auto" (min(2.5% of Heap (in MB), 50MB)). Set to 0 to disable counter cache.

             NOTE: if you perform counter deletes and rely on low gcgs, you should disable the counter cache.
            '
        end


        entry do
            name '# counter\_cache\_save\_period'
            notes '## Default: _7200_

             Duration in seconds after which Cassandra should
             save the counter cache (keys only). Caches are saved to ``saved_caches_directory`` as
             specified in this configuration file.

             Default is _7200_ or 2 hours.
            '
        end


        entry do
            name '# counter\_cache\_keys\_to\_save'
            notes '## Default: _(disabled)_

            Number of keys from the counter cache to save

            Disabled by default, meaning all keys are going to be saved
            '
        end


        entry do
            name '# memory\_allocator'
            notes '## Default: _NativeAllocator_

            The off-heap memory allocator.  Affects storage engine metadata as
            well as caches.  Experiments show that JEMAlloc saves some memory
            than the native GCC allocator (i.e., JEMalloc is more
             fragmentation-resistant).

            Supported values are: NativeAllocator, JEMallocAllocator

            If you intend to use JEMallocAllocator you have to install JEMalloc as library and
            modify cassandra-env.sh as directed in the file.

            Defaults to _NativeAllocator_
            '
        end


    end

    category do
        id 'Memtables & Flushing'

        entry do
            name '# file\_cache\_size\_in\_mb'
            notes '## Default: __

            Total memory to use for sstable-reading buffers.

            Defaults to the smaller of 1/4 of heap or 512MB.
            '
        end

        entry do
            name '# memtable\_heap\_space\_in\_mb'
            notes '## Default: __

            Total permitted memory to use for memtables. Cassandra will stop
            accepting writes when the limit is exceeded until a flush completes,
            and will trigger a flush based on memtable_cleanup_threshold

            If omitted, Cassandra will set to 1/4 the size of the heap.
            '
        end

        entry do
            name '# memtable\_offheap\_space\_in\_mb'
            notes '## Default: __

            Total permitted memory to use for memtables. Cassandra will stop
            accepting writes when the limit is exceeded until a flush completes,
            and will trigger a flush based on memtable_cleanup_threshold

            If omitted, Cassandra will set to 1/4 the size of the heap.
            '
        end

        entry do
            name '# memtable\_cleanup\_threshold'
            notes '## Default: __

            Ratio of occupied non-flushing memtable size to total permitted size
             that will trigger a flush of the largest memtable.  Lager mct will
             mean larger flushes and hence less compaction, but also less concurrent
             flush activity which can make it difficult to keep your disks fed
             under heavy write load.

             Defaults to 1 / (``memtable_flush_writers`` + 1)
            '
        end

        entry do
            name '# memtable\_allocation\_type'
            notes '## Default: _heap_buffers_

            Specify the way Cassandra allocates and manages memtable memory.

            Options are:
            <div class="indent">
               **heap_buffers**:    on heap nio buffers

               **offheap_buffers**: off heap (direct) nio buffers

               **offheap_objects**: native memory, eliminating nio buffer heap overhead
               </div>
            '
        end

        entry do
            name '# commitlog\_total\_space\_in\_mb'
            notes '## Default: _8192_

            Total space to use for commitlogs.  Since commitlog segments are
             mmapped, and hence use up address space, the default size is 32
             on 32-bit JVMs, and 8192 on 64-bit JVMs.

             If space gets above this value (it will round up to the next nearest
             segment multiple), Cassandra will flush every dirty CF in the oldest
             segment and remove it.

             A small total commitlog space will tend
             to cause more flush activity on less-active columnfamilies.
            '
        end

        entry do
            name '# memtable\_flush\_writers'
            notes '## Default: __

            This sets the amount of memtable flush writer threads.  These will
            be blocked by disk io, and each one will hold a memtable in memory
            while blocked.

            Defaults to the smaller of (number of disks, number of cores),
            with a minimum of 2 and a maximum of 8.

            <div class="notice">Note: If your data directories are backed by SSD,
            you should increase this to the number of cores.</div>
            '
        end

        entry do
            name '# index\_summary\_capacity\_in\_mb'
            notes '## Default: __

            A fixed memory pool size in MB for for SSTable index summaries.  If the memory usage of
            all index summaries exceeds this limit, SSTables with low read rates will
            shrink their index summaries in order to meet this limit.  However, this
            is a best-effort process.

            In extreme conditions Cassandra may need to use
            more than this amount of memory.

            If left empty, this will default to _5% of the heap size_.
            '
        end

        entry do
            name '# index\_summary\_resize\_interval\_in\_minutes'
            notes '## Default: _60_

            How frequently index summaries should be resampled.  This is done
            periodically to redistribute memory from the fixed-size pool to sstables
            proportional their recent read rates.

            Setting to -1 will disable this
            process, leaving existing index summaries at their current sampling level.
            '
        end

        entry do
            name '# trickle\_fsync'
            notes '## Default: _false_

            Whether to, when doing sequential writing, fsync() at intervals in
            order to force the operating system to flush the dirty
            buffers. Enable this to avoid sudden dirty buffer flushing from
            impacting read latencies.

            <div class="notice">Note: Almost always a good idea on SSDs; not
            necessarily on platters.
            </div>
            '
        end

        entry do
            name '# trickle\_fsync\_interval\_in\_kb'
            notes '## Default: _10240_

            KB interval for ``trickle_fsync`` operations.
            '
        end

    end

    category do
        id 'Transports and Ports'

        entry do
            name '# storage\_port'
            notes '## Default: _7000_

            TCP port, for commands and data.

            For security reasons, you should not expose this port to the internet.  Firewall it if needed.
            '
        end

        entry do
            name '# ssl\_storage\_port'
            notes '## Default: _7001_

            SSL port, for encrypted communication.  Unused unless enabled in ``encryption_options``

            For security reasons, you should not expose this port to the internet.  Firewall it if needed.
            '
        end

        entry do
            name '# start\_native\_transport'
            notes '## Default: _true_

            Whether to start the native transport server.

            Please note that the address on which the native transport is bound is the
            same as the ``rpc_address``. The port however is different and specified below.
            '
        end

        entry do
            name '# native\_transport\_port'
            notes '## Default: _9042_

            Port for the CQL native transport to listen for clients on

            For security reasons, you should not expose this port to the internet.  Firewall it if needed.
            '
        end

        entry do
            name '# native\_transport\_max\_threads'
            notes '## Default: _(disabled)_

            The maximum threads for handling requests when the native transport is used.

            This is similar to ``rpc_max_threads`` though the default differs slightly (and
            there is no ``native_transport_min_threads``, idle threads will always be stopped
            after 30 seconds).

            Recommended value if set: 128
            '
        end

        entry do
            name '# native\_transport\_max\_frame\_size\_in\_mb'
            notes '## Default: _256_

            The maximum size of allowed frame. Frame (requests) larger than this will
            be rejected as invalid. The default is _256MB_.
            '
        end

        entry do
            name '# native\_transport\_max\_concurrent\_connections'
            notes '## Default: _-1 (unlimited)_

            The maximum number of concurrent client connections.

            The default is _-1_, which means unlimited.
            '
        end

        entry do
            name '# native\_transport\_max\_concurrent\_connections\_per\_ip'
            notes '## Default: _-1_
            The maximum number of concurrent client connections per source ip.

            The default is -1, which means unlimited.
            '
        end

        entry do
            name '# start\_rpc'
            notes '## Default: _true_

            Whether to start the thrift rpc server.
            '
        end

        entry do
            name '# broadcast\_rpc\_address'
            notes '## Default: _(disabled)_

            RPC address to broadcast to drivers and other Cassandra nodes. This _cannot
            be set to 0.0.0.0_.

            If left blank, this will be set to the value of
            ``rpc_address``. If ``rpc_address`` is set to 0.0.0.0, ``broadcast_rpc_address`` must
            be set.
            '
        end

        entry do
            name '# rpc\_keepalive'
            notes '## Default: _true_

            Enable or disable keepalive on rpc/native connections
            '
        end

        entry do
            name '# rpc\_server\_type'
            notes '## Default: _sync_

             Cassandra provides two out-of-the-box options for the RPC Server:

             **sync**
             <div class="indent">
             One thread per thrift connection. For a very large number of clients, memory
                      will be your limiting factor. On a 64 bit JVM, 180KB is the minimum stack size
                      per thread, and that will correspond to your use of virtual memory (but physical memory
                      may be limited depending on use of stack space).
            </div>
             **hsha**
             <div class="indent">
             Stands for "half synchronous, half asynchronous." All thrift clients are handled
                      asynchronously using a small number of threads that does not vary with the amount
                      of thrift clients (and thus scales well to many clients). The rpc requests are still
                      synchronous (one thread per active request). If hsha is selected then it is essential
                      that ``rpc_max_threads`` is changed from the default value of unlimited.
            </div>

             The default is sync because on Windows hsha is about 30% slower.  On Linux,
             sync/hsha performance is about the same, with hsha of course using less memory.

             Alternatively, you can provide your own RPC server by providing the fully-qualified class name
             of an o.a.c.t.TServerFactory that can create an instance of it.
            '
        end

        entry do
            name '# rpc\_min\_threads'
            notes '## Default: _(none)_

            Uncomment ``rpc_min_thread`` to set request pool size limits.

            Regardless of your choice of RPC server (see above), the number of maximum requests in the
             RPC thread pool dictates how many concurrent requests are possible (but if you are using the sync
             RPC server, it also dictates the number of clients that can be connected at all).

            Recommended value if set: 16
            '
        end

        entry do
            name '# rpc\_max\_threads'
            notes '## Default: _(unlimited)_

            Uncomment ``rpc_max_thread`` to set request pool size limits.

            Regardless of your choice of RPC server (see above), the number of maximum requests in the
            RPC thread pool dictates how many concurrent requests are possible (but if you are using the sync
            RPC server, it also dictates the number of clients that can be connected at all).

            The default is unlimited and thus provides no protection against clients overwhelming the server. You are
            encouraged to set a maximum that makes sense for you in production, but do keep in mind that
            ``rpc_max_threads`` represents the maximum number of client requests this server may execute concurrently.

            Recommended value if set: 2048
            '
        end

        entry do
            name '# rpc\_send\_buff\_size\_in\_bytes'
            notes '## Default: _(blank)_

            Uncomment to set socket buffer sizes on rpc connections
            '
        end
        entry do
            name '# rpc\_recv\_buff\_size\_in\_bytes'
            notes '## Default: _(blank)_

            Uncomment to set socket buffer sizes on rpc connections
            '
        end

        entry do
            name '# thrift\_framed\_transport\_size\_in\_mb'
            notes '## Default: _15_

            Frame size for thrift (maximum message length).
            '
        end


    end

    category do
        id 'Backup & Snapshots'

        entry do
            name '# incremental\_backups'
            notes '## Default: _false_

             Set to true to have Cassandra create a hard link to each sstable
     flushed or streamed locally in a backups/ subdirectory of the
     keyspace data.  Removing these links is the operator\'s
     responsibility.

     When incremental backups are enabled (disabled by default), Cassandra hard-links each
     flushed SSTable to a backups directory under the keyspace data directory. This allows
     storing backups offsite without transferring entire snapshots. Also,
     incremental backups combine with snapshots to provide a dependable, up-to-date
     backup mechanism.

     As with snapshots, Cassandra does not automatically clear incremental backup files.
     DataStax recommends setting up a process to clear incremental backup hard-links each
     time a new snapshot is created.
            '
        end

        entry do
            name '# snapshot\_before\_compaction'
            notes '## Default: _false_

             Whether or not to take a snapshot before each compaction.  Be
 careful using this option, since Cassandra won\'t clean up the
 snapshots for you.  Mostly useful if you\'re paranoid when there
 is a data format change.
            '
        end
        entry do
            name '# auto\_snapshot'
            notes '## Default: _true_

        Whether or not a snapshot is taken of the data before keyspace truncation
or dropping of column families.

The **STRONGLY** advised default of true
 should be used to provide data safety. If you set this flag to false, you will
 lose data on truncation or drop.
            '
        end

    end

    category do
        id 'Hinted Handoffs'

        entry do
            name '# hinted\_handoff\_enabled'
            notes '## Default: _true_

            See http://wiki.apache.org/cassandra/HintedHandoff

            May either be "true" or "false" to enable globally, or contain a list
            of data centers to enable per-datacenter.

            Example: hinted\_handoff\_enabled: DC1,DC2
            '
        end

        entry do
            name '# max\_hint\_window\_in\_ms'
            notes '## Default: _10800000  (3 hours)_

            Defines the maximum amount of time a dead host will have hints
generated.  After it has been dead this long, new hints for it will not be
created until it has been seen alive and gone down again.
            '
        end

        entry do
            name '# hinted\_handoff\_throttle\_in\_kb'
            notes '## Default: _1024_

            Maximum throttle in KBs per second, per delivery thread.  This will be
 reduced proportionally to the number of nodes in the cluster.

If there are two nodes in the cluster, each delivery thread will use the maximum
 rate; if there are three, each will throttle to half of the maximum,
 since we expect two nodes to be delivering hints simultaneously.
            '
        end

        entry do
            name '# max\_hints\_delivery\_threads'
            notes '## Default: _2_

            Number of threads with which to deliver hints;
 Consider increasing this number when you have multi-dc deployments, since
 cross-dc handoff tends to be slower
            '
        end

        entry do
            name '# batchlog\_replay\_throttle\_in\_kb'
            notes '## Default: _1024_

            Maximum throttle in KBs per second, total. This will be
     reduced proportionally to the number of nodes in the cluster.
            '
        end


    end

    category do
        id 'Indexes & Tombstones'


        entry do
            name '# column\_index\_size\_in\_kb'
            notes '## Default: _64_

             Granularity of the collation index of rows within a partition.
             Increase if your rows are large, or if you have a very large
             number of rows per partition.  The competing goals are these:
            <div class="indent">
               1) a smaller granularity means more index entries are generated
                  and looking up rows withing the partition by collation column
                  is faster

               2) but, Cassandra will keep the collation index in memory for hot
                  rows (as part of the key cache), so a larger granularity means
                  you can cache more hot rows
                </div>
        '
        end


        entry do
            name '# tombstone\_warn\_threshold'
            notes '## Default: _1000_

            Level of tombstones to scan before logging a warning.
'
        end

        entry do
            name '# tombstone\_failure\_threshold'
            notes '## Default: _100000_

            When executing a scan, within or across a partition, we need to keep the
           tombstones seen in memory so we can return them to the coordinator, which
           will use them to make sure other replicas also know about the deleted rows.

           With workloads that generate a lot of tombstones, this can cause performance
           problems and even exaust the server heap.
          (http://www.datastax.com/dev/blog/cassandra-anti-patterns-queues-and-queue-like-datasets)

            Adjust the thresholds here if you understand the dangers and want to
           scan more tombstones anyway.  These thresholds may also be adjusted at runtime
            using the StorageService mbean.

        '
        end


        entry do
            name '# column\_index\_size\_in\_kb'
            notes '## Default: _64_

            Granularity of the collation index of rows within a partition.
            Increase if your rows are large, or if you have a very large
            number of rows per partition.  The competing goals are these:

            <div class="indent">
               1) a smaller granularity means more index entries are generated
                  and looking up rows withing the partition by collation column
                  is faster

               2) but, Cassandra will keep the collation index in memory for hot
                  rows (as part of the key cache), so a larger granularity means
                  you can cache more hot rows
            </div>

'
        end
    end

    category do
        id 'SSTables and Compaction'

        entry do
            name '# concurrent\_reads'
            notes '## Default: _32_

            For workloads with more data than can fit in memory, Cassandra\'s
            bottleneck will be reads that need to fetch data from
            disk.

            Should be set to (16 * number_of_drives) in
            order to allow the operations to enqueue low enough in the stack
            that the OS and drives can reorder them.
            '
        end

        entry do
            name '# concurrent\_writes'
            notes '## Default: _32_

            The ideal number is dependent on the number of cores in
            your system.

            Recommended: 8 * number_of_cores
            '
        end

        entry do
            name '# concurrent\_counter\_writes'
            notes '## Default: _32_

            For workloads with more data than can fit in memory, Cassandra\'s
            bottleneck will be reads that need to fetch data from
            disk.

            Recommended value: 16 * number_of_drives in
            order to allow the operations to enqueue low enough in the stack
            that the OS and drives can reorder them.
            '
        end


        entry do
            name '# concurrent\_compactors'
            notes '## Default: _(auto)_

             Number of simultaneous compactions to allow, NOT including
             validation "compactions" for anti-entropy repair.  Simultaneous
             compactions can help preserve read performance in a mixed read/write
             workload, by mitigating the tendency of small sstables to accumulate
             during a single long running compactions.

             The default is usually
             fine and if you experience problems with compaction running too
             slowly or too fast, you should look at
             ``compaction_throughput_mb_per_sec`` first.

             Defaults to the smaller of (number of disks,
             number of cores), with a minimum of 2 and a maximum of 8.

<div class="notice">Note:
             If your data directories are backed by SSD, you should increase this
             to the number of cores.
             </div>
            '
        end

        entry do
            name '# compaction\_throughput\_mb\_per\_sec'
            notes '## Default: _16_

             Throttles compaction to the given total throughput across the entire
             system. The faster you insert data, the faster you need to compact in
             order to keep the sstable count down, but in general, setting this to
             16 to 32 times the rate you are inserting data is more than sufficient.

             Setting this to 0 disables throttling.

             <div class="notice"> Note: This accounts for all types
             of compaction, including validation compaction.</div>
            '
        end


        entry do
            name '# sstable\_preemptive\_open\_interval\_in\_mb'
            notes '## Default: _50_

            When compacting, the replacement sstable(s) can be opened before they
             are completely written, and used in place of the prior sstables for
             any range that has been written. This helps to smoothly transfer reads
             between the sstables, reducing page cache churn and keeping hot rows hot

            '
        end

        entry do
            name '# compaction\_large\_partition\_warning\_threshold\_mb'
            notes '## Default: _100_

            Log a warning when compacting partitions larger than this value
            '
        end

    end

    category do
        id 'Internode Settings'

        entry do
            name '# stream\_throughput\_outbound\_megabits\_per\_sec'
            notes '## Default: _200  (25 MB/s)_

            Throttles all outbound streaming file transfers on this node to the
            given total throughput in Mbps. This is necessary because Cassandra does
             mostly sequential IO when streaming data during bootstrap or repair, which
             can lead to saturating the network connection and degrading rpc performance.

            When unset, the default is _200 Mbps or 25 MB/s_.
            '
        end

        entry do
            name '# inter\_dc\_stream\_throughput\_outbound\_megabits\_per\_sec'
            notes '## Default: _(disabled)_

            Throttles all streaming file transfer between the datacenters,
            this setting allows users to throttle inter dc stream throughput in addition
            to throttling all network stream traffic as configured with
            ``stream_throughput_outbound_megabits_per_sec``
            '
        end


        entry do
            name '# read\_request\_timeout\_in\_ms'
            notes '## Default: _5000_

            How long the coordinator should wait for read operations to complete
            '
        end


        entry do
            name '# range\_request\_timeout\_in\_ms'
            notes '## Default: _10000_

            How long the coordinator should wait for seq or index scans to complete.
            '
        end


        entry do
            name '# write\_request\_timeout\_in\_ms'
            notes '## Default: _2000_

            How long the coordinator should wait for writes to complete.
            '
        end


        entry do
            name '# counter\_write\_request\_timeout\_in\_ms'
            notes '## Default: _5000_

            How long the coordinator should wait for counter writes to complete.
            '
        end


        entry do
            name '# cas\_contention\_timeout\_in\_ms'
            notes '## Default: _1000_

            How long a coordinator should continue to retry a CAS operation
            that contends with other proposals for the same row.
            '
        end


        entry do
            name '# truncate\_request\_timeout\_in\_ms'
            notes '## Default: _60000_

            How long the coordinator should wait for truncates to complete.

            This can be much longer, because unless ``auto_snapshot`` is disabled
             we need to flush first so we can snapshot before removing the data.
            '
        end


        entry do
            name '# request\_timeout\_in\_ms'
            notes '## Default: _10000_

            The default timeout for other, miscellaneous operations
            '
        end


        entry do
            name '# cross\_node\_timeout'
            notes '## Default: _false_

            Enable operation timeout information exchange between nodes to accurately
            measure request timeouts.  If disabled, replicas will assume that requests
            were forwarded to them instantly by the coordinator, which means that
            under overload conditions we will waste that much extra time processing
            already-timed-out requests.

            Warning: before enabling this property make sure to ntp is installed
            and the times are synchronized between the nodes.
            '
        end



        entry do
            name '# streaming\_socket\_timeout\_in\_ms'
            notes '## Default: _3600000_

             Enable socket timeout for streaming operation.

             When a timeout occurs during streaming, streaming is retried from the start
             of the current file. This _can_ involve re-streaming an important amount of
             data, so you should avoid setting the value too low.

            Default value is 3600000, which means streams timeout after an hour.
            '
        end


        entry do
            name '# phi\_convict\_threshold'
            notes '## Default: _8_

            phi value that must be reached for a host to be marked down.
            most users should never need to adjust this.

            The failure detector monitors gossip traffic, and if a node has not participated in the process for an interval, it marks the node as dead.

            <div class="notice">
            Note: If using AWS or another cloud provider increasing to 12 may be benificial.
            </div>
            '
        end

        entry do
            name '# dynamic\_snitch\_update\_interval\_in\_ms'
            notes '## Default: _100_

            Controls how often to perform the more expensive part of host score
             calculation.

            '
        end

        entry do
            name '# dynamic\_snitch\_reset\_interval\_in\_ms'
            notes '## Default: _600000_

            Controls how often to reset all host scores, allowing a bad host to
            possibly recover
            '
        end

        entry do
            name '# dynamic\_snitch\_badness\_threshold'
            notes '## Default: _0.1_

            If set greater than zero and ``read_repair_chance`` is < 1.0, this will allow
             \'pinning\' of replicas to hosts in order to increase cache capacity.

             The badness threshold will control how much worse the pinned host has to be
             before the dynamic snitch will prefer other replicas over it.  This is
             expressed as a double which represents a percentage.  Thus, a value of
             0.2 means Cassandra would continue to prefer the static snitch values
             until the pinned host was 20% worse than the fastest.
            '
        end


        entry do
            name '# request\_scheduler'
            notes '## Default: _org.apache.cassandra.scheduler.NoScheduler_

            Set this to a class that implements
             RequestScheduler, which will schedule incoming client requests
             according to the specific policy. This is useful for multi-tenancy
             with a single Cassandra cluster.

             <div class="notice">NOTE: This is specifically for requests from the client and does
             not affect inter node communication.</div>

             Options:
             <div class="indent">
             **org.apache.cassandra.scheduler.NoScheduler** - No scheduling takes place

            **org.apache.cassandra.scheduler.RoundRobinScheduler** - Round robin of
            client requests to a node with a separate queue for each
             ``request_scheduler_id``. The scheduler is further customized by
             ``request_scheduler_options`` as described below.
             </div>
            '
        end

        entry do
            name '# request\_scheduler\_options'
            notes '## Default: _(disabled)_

             Scheduler Options vary based on the type of scheduler:
<div class="indent">
             **NoScheduler** - Has no options

             **RoundRobin**
             <div class="indent">

              **throttle\_limit** -- The throttle\_limit is the number of in-flight
                                  requests per client.  Requests beyond
                                  that limit are queued up until
                                  running requests can complete.
                                  The value of 80 here is twice the number of
                                  ``concurrent_reads`` + ``concurrent_writes``.

              **default\_weight** -- optional and allows for
                                  overriding the default which is 1.

              **weights** -- Weights are optional and will default to 1 or the
                           overridden default\_weight. The weight translates into how
                           many requests are handled during each turn of the
                           RoundRobin, based on the scheduler id.
            </div></div>



            Example Usage:        <div class="indent">

            <pre>
request_scheduler_options:
    throttle\_limit: 80
    default\_weight: 5
    weights:
        Keyspace1: 1
        Keyspace2: 5
</pre>

            </div>
            '
        end

        entry do
            name '# request\_scheduler\_id'
            notes '## Default: _(disabled)_

            An identifier based on which to perform
            the request scheduling. Currently the only valid option is keyspace.
            '
        end

        entry do
            name '# internode\_compression'
            notes '## Default: _all_


            Controls whether traffic between nodes is compressed.
            Options:
            <div class="indent">
                **all**  - all traffic is compressed

                      **dc**   - traffic between different datacenters is compressed

                      **none** - nothing is compressed.
            </div>
            '
        end

        entry do
            name '# inter\_dc\_tcp\_nodelay'
            notes '## Default: _false_

            Enable or disable tcp_nodelay for inter-dc communication.

            Disabling it will result in larger (but fewer) network packets being sent,
            reducing overhead from the TCP protocol itself, at the cost of increasing
            latency if you block for cross-datacenter responses.
            '
        end

        entry do
            name '# internode_authenticator'
            notes '## Default: _(disabled)_

             Internode authentication backend, implementing IInternodeAuthenticator;
             used to allow/disallow connections from peer nodes.

            Options: org.apache.cassandra.auth.AllowAllInternodeAuthenticator
            '
        end

        entry do
            name '# partitioner'
            notes '## Default: _org.apache.cassandra.dht.Murmur3Partitioner_

            The partitioner is responsible for distributing groups of rows (by
            partition key) across nodes in the cluster.  You should leave this
            alone for new clusters.

            The partitioner can NOT be changed without
            reloading all data, so when upgrading you should set this to the
            same partitioner you were already using.

            Besides Murmur3Partitioner, partitioners included for backwards
            compatibility include:

- RandomPartitioner
- ByteOrderedPartitioner
- OrderPreservingPartitioner
            '
        end

        entry do
            name '# internode\_send\_buff\_size\_in\_bytes'
            notes '## Default: __

            Uncomment to set socket buffer size for internode communication
            Note that when setting this, the buffer size is limited by net.core.wmem_max
            and when not setting it it is defined by net.ipv4.tcp_wmem

            See:

- /proc/sys/net/core/wmem_max
- /proc/sys/net/core/rmem_max
- /proc/sys/net/ipv4/tcp_wmem
- /proc/sys/net/ipv4/tcp_wmem
- man tcp

            '
        end

        entry do
            name '# internode\_recv\_buff\_size\_in\_bytes'
            notes '## Default: __

            Uncomment to set socket buffer size for internode communication
            Note that when setting this, the buffer size is limited by net.core.wmem_max
            and when not setting it it is defined by net.ipv4.tcp_wmem

            See:

* /proc/sys/net/core/wmem_max
* /proc/sys/net/core/rmem_max
- /proc/sys/net/ipv4/tcp_wmem
- /proc/sys/net/ipv4/tcp_wmem
- man tcp
            '
        end



    end


    category do
        id 'Warnings Logged'

        entry do
            name '# gc\_warn\_threshold\_in\_ms'
            notes '## Default: _1000_

            GC Pauses greater than ``gc_warn_threshold_in_ms`` will be logged at WARN level
            Adjust the threshold based on your application throughput requirement

            By default, Cassandra logs GC Pauses greater than ``200`` ms at INFO level
            '
        end

        entry do
            name '# batch\_size\_warn\_threshold\_in\_kb'
            notes '## Default: _5_

            Log WARN on any batch size exceeding this value. 5kb per batch by default.

            Caution should be taken on increasing the size of this threshold as it can lead to node instability.
            '
        end


    end

    notes '
    Version: 1.0.0

    Date: 2016.04.02

    Generated by Brad Vernon <bv@bradvernon.com>'
end
