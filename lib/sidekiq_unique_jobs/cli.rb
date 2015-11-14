require 'thor'

module SidekiqUniqueJobs
  class Cli < Thor
    desc 'keys PATTERN', 'list all unique keys and their expiry time'
    option :count, aliases: :c, type: :numeric, default: 1000, desc: 'The max number of keys to return'
    def keys(pattern)
      Util.keys(pattern, count: options[:count])
    end

    desc 'del_by PATTERN', 'deletes unique keys from redis by pattern'
    option :dry_run, aliases: :d, type: :boolean, desc: 'set to false to perform deletion'
    option :count, aliases: :c, type: :numeric, default: 1000, desc: 'The max number of keys to return'
    def del_by(pattern)
      Util.del_by(pattern, dry_run: dry_run, count: count)
    end

    desc 'drop into a console', 'easy access to helper methods'
    def console
      puts "Use `keys '*', count: 1000 to display the first 1000 unique keys matching '*'"
      puts "Use `del '*', count: 1000 to see how many keys would be deleted for the pattern '*'"
      puts "Use `del '*', dry_run: false, count: 1000 to delete the first 1000 keys matching '*'"
      begin
        require 'pry'
        Object.include SidekiqUniqueJobs::Util
        Pry.start
      rescue LoadError
        require 'irb'
        Object.include SidekiqUniqueJobs::Util
        IRB.start
      end
    end
  end
end
