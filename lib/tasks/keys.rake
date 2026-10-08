desc "Installs access key into .env via lastpass."
task setup_keys: :environment do
  entra_content = JSON.parse(`lpass show Shared-ITIMS-Passwords/DLS/pulmap-entraid-staging -j`).first
  File.open(".env", "w") do |f|
    f.puts "ENTRA_CLIENT_ID=#{entra_content['username']}"
    f.puts "ENTRA_CLIENT_SECRET=#{entra_content['password']}"
  end
  puts "Generated .env file"
end
