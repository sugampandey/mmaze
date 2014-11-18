root_path = File.join(File.expand_path('../../', __FILE__))

every :sunday, :at => '11pm' do
  command "cd #{root_path} && backup perform --trigger musiquemaze --config-file #{root_path}/config/backup/config.rb --log-path #{root_path}/log"
end
