require "flock_synchronize/version"
require 'tmpdir'

module FlockSynchronize
    # flock_synchronize wraps a block with a flock-based mutex.
    #
    # Any other process calling flock_synchronize with the same key will
    # wait for the previous block to exit before executing.
    #
    # NOTE: This only works on a per-process basis and is not compatible with
    # Ruby threads. For that, see the built-in Mutex library
    #
    #  FlockSynchronize.flock_synchronize("my operation") do
    #    some.code_that_needs(synchronizing)
    #  end
    #
    # Options available:
    #
    #   locking_constant: use a different constant than LOCK_EX. See the
    #                     File.flock documentation for more info.
    #   timeout:          automatically unlock if the lock was created more
    #                     this number of seconds ago
    #
    def self.flock_synchronize(key, options={})
        # Previous versions took locking_constant as second param and now it's
        # a hash
        if !options.kind_of? Hash
            options = {locking_constant: options}
        end
        options[:locking_constant] ||= File::LOCK_EX
        
        filename = File.join(Dir.tmpdir, "#{key}.flock")
        begin
            if options[:timeout]
                if File.exists? filename and (Time.now - File.mtime(filename)) > options[:timeout]
                    File.unlink filename
                end
            end
            File.open(filename, 'w') do |f|
                f.flock(options[:locking_constant])
                yield
            end
        ensure
            File.unlink filename if File.exists? filename
        end
    end
end
