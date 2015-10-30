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
    # The optional locking_constant parameter allows you to specify a different
    # constant than LOCK_EX. See the File.flock documentation for more info.
    #
    def self.flock_synchronize(key, locking_constant=File::LOCK_EX)
        filename = File.join(Dir.tmpdir, "#{key}.flock")
        begin
            File.open(filename, 'w') do |f|
                f.flock(locking_constant)
                yield
            end
        ensure
            File.unlink filename if File.exists? filename
        end
    end
end
