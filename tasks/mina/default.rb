task :environment do
end

task run_commands: :environment do
  commands.run(:remote) unless commands.queue.empty?
end

task debug_configuration_variables: :environment do
  if fetch(:debug_configuration_variables)
    puts
    puts '------- Printing current config variables -------'
    configuration.variables.each do |key, value|
      puts "#{key.inspect} => #{value.inspect}"
    end
  end
end

desc 'Runs a command in the server.'
task :run, [:command] => [:environment] do |_, args|
  ensure!(:deploy_to)
  command = args[:command]

  unless command
    puts "You need to provide a command. Try: mina 'run[ls -la]'"
    exit 1
  end

  in_path fetch(:deploy_to) do
    command command
  end
end

desc 'Open an ssh session to the server and cd to deploy_to folder'
task ssh: :environment do
  exec ssh_command + " 'cd #{deploy_to} && exec \$SHELL'"
end
