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

      def execute(commands, err_log_file, out_log_file)
        system(env, "#{pspp_cli_path} -o #{out_log_file} -e #{err_log_file} < #{commands}")
      end

      def env
        { 'LANG' => 'en_US.UTF-8',
          'LANGUAGE' => 'en_US.UTF-8',
          'LC_CTYPE' => 'en_US.UTF-8',
          'LC_ALL' => 'en_US.UTF-8' }.freeze
      end
    end
  end
end
