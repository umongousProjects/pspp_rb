if RUBY_VERSION < '2.2'
  require 'posix/spawn'
else
  require 'open3'
end

module PsppRb
  class Pspp
    class Exec
      include POSIX::Spawn if RUBY_VERSION < '2.2'

      attr_accessor :pspp_cli_path

      def initialize(pspp_cli_path)
        self.pspp_cli_path = Shellwords.shellescape(pspp_cli_path)
        raise PsppError, "cannot execute '#{self.pspp_cli_path}' program" unless system(self.pspp_cli_path, '--version')
      end

      if RUBY_VERSION < '2.2'
        def execute(commands, err_log_file, out_log_file)
          pid, stdin, stdout, stderr = popen4(env, pspp_cli_path, '-b', '-o', out_log_file, '-e', err_log_file, '-O', 'box=unicode')
          stdin.write(commands)
          stdin.close
          _, result = Process.waitpid2(pid)
          result.success?
        ensure
          [stdin, stdout, stderr].reject(&:nil?).reject(&:closed?).each(&:close)
        end
      else
        def execute(commands, err_log_file, out_log_file)
          result = false
          Open3.popen3(env, pspp_cli_path, '-b', '-o', out_log_file, '-e', err_log_file, '-s', '-O', 'box=unicode') do |stdin, stdout, stderr, wait_thr|
            stdin.write(commands)
            stdin.close
            stdout.close # just for sure
            stderr.close
            result = wait_thr.value.success?
          end
          result
        end
      end

      def env
        { 'LANG' => 'C',
          'LC_ALL' => 'en_CA.UTF-8' }.freeze
          {}
      end
    end
  end
end
