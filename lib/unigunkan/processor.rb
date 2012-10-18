class Unigunkan::Processor
  def initialize(proj_file)
    @proj_file = proj_file
    p @proj_file
  end

  def create_backup
    STDOUT.puts "Creating a backup of project.pbxproj..."
    backup_filepath = @proj_file + ".backup" + Time.now.strftime("%Y%m%d%H%M%S")
    FileUtils.cp(@proj_file, backup_filepath)
    STDOUT.puts "A backup created -> #{backup_filepath}"
  end
end