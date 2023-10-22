## PURPOSE: this script will quiet any sidekiq workers it finds,
## and then shut them down when they are no longer handling jobs

# utility class for logging and running commands
class Utils
  require "open3"
  attr_accessor :output

  def initialize(output)
    @output = output
  end

  def run_command(command)
    log("RUNNING: \"#{command}\"")
    stdout, stderr, status = Open3.capture3(command)
    return stdout.strip if status.success?
    # handle errors
    stderr = stderr.strip
    if stderr.empty?
      log("FATAL:\nCommand: \"#{command}\"")
    else
      log("FATAL:\nCommand: \"#{command}\"\nError: #{stderr}")
    end
    exit(-1)
  end

  def log(message)
    line = "[#{Time.now}] #{message}"
    (@output == "stdout") ? puts(line) : File.open(@output, "a") { |file| file.puts(line) }
  end

  def log_underline
    log("-" * 70)
  end
end

# class to encapsulate the worker manager
class WorkerManager
  attr_accessor :timeout, :utils

  STATUS_WAITING_THREADS = :waiting_threads
  STATUS_CAN_BE_TERMINATED = :can_be_terminated
  STATUS_CAN_BE_QUIETED = :can_be_quieted

  POLL_FREQUENCY = 10

  def initialize(timeout, utils)
    @timeout = timeout
    @utils = utils
  end

  def initiate_shutdown
    @utils.log("*******************************")
    @utils.log("** STARTED SHUTDOWN SEQUENCE **")
    @utils.log("*******************************")
    # figure out the timeout time
    current_time = Time.now
    timeout_time = current_time + @timeout
    # fetch latest worker info
    workers = materialize_workers
    while Time.now <= timeout_time && !workers.empty?
      # do what is needed for each worker
      workers.each { |worker| worker.handle_shutdown(false) }
      # sleep for the poll time
      @utils.log("...sleeping for #{POLL_FREQUENCY} seconds...")
      sleep(POLL_FREQUENCY)
      # fetch latest worker info
      workers = materialize_workers
    end
    if Time.now > timeout_time && !workers.empty?
      @utils.log("[[ TIMED-OUT ]]")
      # fetch latest worker info
      workers = materialize_workers
      # do what is needed for each worker
      workers.each { |worker| worker.handle_shutdown(true) }
      # give process time to respond to the signals
      @utils.log("...sleeping for #{POLL_FREQUENCY} seconds...")
      sleep(POLL_FREQUENCY)
    end
  end

  private

  def materialize_workers
    workers = []
    stdout = @utils.run_command('ps aux | grep [s]idekiq | grep busy\] || true')
    stdout.lines.each do |line|
      line = line.strip
      if line =~ Worker::WORKER_REGEX
        pid = $~[:pid].to_i
        version = $~[:version]
        active_threads = $~[:worker_count].to_i
        total_threads = $~[:total_threads].to_i
        is_quiet = line =~ /stopping$/
        worker = Worker.new(pid, version, active_threads, total_threads, is_quiet, @utils)
        workers << worker
      end
    end
    @utils.log_underline
    if workers.empty?
      @utils.log("CURRENT STATE: No workers found!")
    else
      @utils.log("CURRENT STATE:")
      workers.each { |worker| @utils.log(worker.status_text) }
    end
    @utils.log_underline
    workers
  end
end

# class to encapsulate workers
class Worker
  attr_accessor :utils, :pid, :status, :active_threads, :total_threads, :version

  STATUS_WAITING_THREADS = :waiting_threads
  STATUS_CAN_BE_TERMINATED = :can_be_terminated
  STATUS_CAN_BE_QUIETED = :can_be_quieted

  WORKER_REGEX = /^.*?\s+(?<pid>\d+).*sidekiq\s+(?<version>[\d.]+).*?\[(?<worker_count>\d+)\sof\s(?<total_threads>\d+) busy\]/

  def initialize(pid, version, active_threads, total_threads, is_quiet, utils)
    @utils = utils
    @pid = pid
    @version = version
    @active_threads = active_threads
    @total_threads = total_threads
    @status = parse_status(active_threads, is_quiet)
  end

  def status_text
    output = (@status == STATUS_CAN_BE_QUIETED) ? "[ACTIVE]" : "[QUIET]"
    output = "#{output} [PID:#{@pid}] [VERSION:#{@version}] [#{@active_threads} of #{@total_threads}]"
    return "#{output} - waiting for threads to complete" if status == STATUS_WAITING_THREADS
    return "#{output} - can be terminated" if status == STATUS_CAN_BE_TERMINATED
    "#{output} - can be quieted" if status == STATUS_CAN_BE_QUIETED
  end

  def handle_shutdown(aggressive)
    if aggressive
      # kill worker
      @utils.run_command("kill -9 #{@pid}")
    elsif @status == STATUS_CAN_BE_QUIETED
      major_version = @version.gsub(/\..*/, "").to_i
      if major_version < 5
        # quiet worker
        @utils.run_command("kill -USR1 #{@pid}")
      else
        # quiet worker
        @utils.run_command("kill -TSTP #{@pid}")
      end
    elsif @status == STATUS_CAN_BE_TERMINATED
      # stop worker
      @utils.run_command("kill -TERM #{@pid}")
    end
  end

  private

  def parse_status(active_threads, is_quiet)
    return STATUS_CAN_BE_QUIETED unless is_quiet
    return STATUS_WAITING_THREADS if active_threads > 0
    STATUS_CAN_BE_TERMINATED
  end
end

# parse arguments
require "optparse"
require "ostruct"
options = OpenStruct.new
options.timeout = 120
options.output = "stdout"
OptionParser.new do |opts|
  opts.banner = "Usage: sidekiq_safe_shutdown.rb [options]"
  opts.on("-o [ARG]", "--output [ARG]", "File-path or stdout (default: stdout)") { |v| options.output = v }
  opts.on("-t [ARG]", "--timeout [ARG]", "Timeout in seconds (default: 120)") { |v| options.timeout = v }
  opts.on("-h", "--help", "Display this help") do
    puts opts
    exit
  end
end.parse!

# handle timeou
utils = Utils.new(options.output)
options.timeout = options.timeout.to_i
if options.timeout < 10
  utils.log("FATAL:\nTimeout #{options.timeout} too short!")
  exit(-1)
end

# initiate shutdown
WorkerManager.new(options.timeout, utils).initiate_shutdown
