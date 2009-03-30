require 'pathname'

def split(file_path, dest_dir, allowed_length = 5000000)
p = Pathname.new(file_path)
temp_line = ''
full_line = ''
i = 0
dest_filename = 'import_txt'
dest_filename_arr = []

p.each_line do |line|
  temp_line += line
  if line.match(/^--------\n$/)
    if ((full_line.length + temp_line.length) < allowed_length)
      full_line += temp_line
      temp_line = ''    
    else
      ((full_line.length + temp_line.length) > allowed_length)  
      if full_line == ''        
        full_line = temp_line 
        temp_line = ''
      end
      File.open("#{dest_dir}/#{dest_filename}_#{i}", 'w') {|f| f.write(full_line) }
      dest_filename_arr << "#{dest_filename}_#{i}"
      full_line = ''
      i += 1      
    end    
  end
end
File.open("#{dest_dir}/#{dest_filename}_#{i}", 'w') {|f| f.write(full_line) }
dest_filename_arr << "#{dest_filename}_#{i}"
end
