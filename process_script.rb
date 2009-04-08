require 'global_settings'
require 'importer.rb'
require 'splitter.rb'
require 'image_parse.rb'
require 'update_links.rb'
require 'configure_wordpress.rb'
require 'update_users.rb'
require 'fix_broken_url.rb'

puts "Starting import file split"
dest_files = split($wordpress_export_filename, $split_file_path, $allowed_length)

puts "Successfully split the files into #{dest_files.join(',')}"

dest_files.each do |dest_file|
  puts "Starting import of #{dest_file}..."
  
  dest_path = File.join($split_file_path, dest_file)
  File.copy(dest_path, $wordpress_import_file)
  
  start_import
  puts "Finished importing the file #{dest_file}"
end

puts "Import process done."

puts "Updating permalinks"
update_permalinks
puts "Done updating permalinks"

puts "Processing images"
process_images

puts "Configuring wordpress"
configure_wordpress

puts "Fixing broken urls"
fix_broken_url

