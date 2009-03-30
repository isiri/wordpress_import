require 'logger'
require 'pathname'
require 'importer.rb'
require 'splitter.rb'
require 'image_parse.rb'
require 'update_links'
require 'ftools'

file_path = '/media/sda1/wordpress_import/mt-export.txt'
allowed_length = 5000000
dest_dir = '/media/sda1/wordpress_import/splitted_files'
wordpress_import_file = '/var/www/wordpress/wp-content/mt-export.txt'

puts "Starting import file split"

dest_files = split(file_path, dest_dir, allowed_length)

puts "Successfully split the files into #{dest_files.join(',')}"

dest_files.each do |dest_file|
  puts "Starting import of #{dest_file}..."
  
  dest_path = File.join(dest_dir, dest_file)
  File.copy(dest_path, wordpress_import_file)
  
  start_import
  puts "Finished importing the file #{dest_file}"
end

puts "Import process done."

puts "Updating permalinks"
update_permalinks
puts "Done updating permalinks"

puts "Processing images"
process_images



