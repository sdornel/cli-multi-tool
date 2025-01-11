module RenameFile
    extend self
    def rename_files_with_sequential_naming_pattern
        puts "Enter the directory. Default is current directory"
        directory = $stdin.gets.chomp
        directory = "." if directory.empty?

    end
end