require 'fileutils'
require 'pathname'
require 'securerandom'

class Unigunkan::Processor
  def initialize(proj_file, opts)
    @proj_file = proj_file
    @opts = opts

    f = open(@proj_file)
    @src = f.read
    f.close
  end

  def create_backup
    STDOUT.puts "Creating a backup of project.pbxproj..."
    backup_filepath = @proj_file + ".backup" + Time.now.strftime("%Y%m%d%H%M%S")
    FileUtils.cp(@proj_file, backup_filepath)
    STDOUT.puts "A backup created -> #{backup_filepath}"
  end

  # Disable iphone5 support
  # (Remove lines which include 'Default-568h@2x.png'.)
  def disable_retina_4inch_support
    src = @src
    STDOUT.puts "Disabling Retina 4inch support..."
    dst = src.split("\n")
    src = ""
    lines_removed = 0
    for line in dst
      if line.index("Default-568h@2x.png") == nil
        src += "#{line}\n"
      else
        lines_removed += 1
      end
    end
    if lines_removed > 0
      STDOUT.puts "#{lines_removed} lines removed."
    else
      STDOUT.puts "Default-568h@2x.png not found in this project. No lines removed."
    end

    begin
      default_png_path = Pathname.new(@proj_file + "/../../Default-568h@2x.png").realpath
      FileUtils.mv default_png_path, default_png_path.to_s + ".backup" + Time.now.strftime("%Y%m%d%H%M%S")
    rescue
      STDOUT.puts "Warning: No Default-568h@2x.png found."
    end

    @src = src
  end

  def add_folder_refs
    if OPTS[:folder_refs].nil?
      return
    end

    folders = OPTS[:folder_refs].split(",")

    STDOUT.puts "Adding folder refs..."

    file_refs_to_add = []
    build_files_to_add = []
    resource_build_phase_files_to_add = []
    entry_in_tree_to_add = []

    for folder in folders
      file_ref = SecureRandom.hex
      build_file = SecureRandom.hex
      file_refs_to_add << "#{file_ref} /* #{folder} */ = {isa = PBXFileReference; lastKnownFileType = folder; path = #{folder}; sourceTree = \"<group>\"; };"
      build_files_to_add << "#{build_file} /* #{folder} in Resources */ = {isa = PBXBuildFile; fileRef = #{file_ref} /* #{folder} */; };"
      resource_build_phase_files_to_add << "#{build_file} /* #{folder} in Resources */,"
      entry_in_tree_to_add << "#{file_ref} /* #{folder} */,"
    end
    puts build_files_to_add.join("\n")
    puts file_refs_to_add.join("\n")
    puts resource_build_phase_files_to_add.join("\n")
    puts entry_in_tree_to_add.join("\n")

    add_block_after "/* Begin PBXBuildFile section */", build_files_to_add.join("\n")
    add_block_after "/* Begin PBXFileReference section */", file_refs_to_add.join("\n")

    # Rewrite ResourcesBuildPhase section
    target = /Resources \*\/ = {\n\t\t\tisa = PBXResourcesBuildPhase;\n\t\t\tbuildActionMask = (.*?);\n\t\t\tfiles = \(/
    mask = @src.scan(target)[0][0]
    build_phases = "Resources */ = {\n\t\t\tisa = PBXResourcesBuildPhase;\n\t\t\tbuildActionMask = #{mask};\n\t\t\tfiles = (\n"
    @src.gsub!(target, build_phases + resource_build_phase_files_to_add.join("\n"))

    # Rewrite PBXGroup section
    target = /\/\* Begin PBXGroup section \*\/\n\t\t(.*?)\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = \(/
      # isa = PBXGroup;
      # children = \("
    p @src.scan(target)
    group_id = @src.scan(target)[0][0]
    group = "/* Begin PBXGroup section */
\t\t#{group_id}
\t\t\tisa = PBXGroup;
\t\t\tchildren = ("
    @src.gsub!(target, group + "\n" + entry_in_tree_to_add.join("\n"))
  end

  def new_uuid
    SecureRandom.hex(10)
  end

  def link_library(library, path)
    if library.end_with?(".dylib")
      framework = {:name => library, :uuid => new_uuid, :fileref => new_uuid, :path => path, :last_known_type => "compiled.mach-o.dylib", :source_tree => "SDKROOT"}

      # file refs
      fw_name = framework[:name]
      fileref = framework[:fileref]
      path = framework[:path]
      uuid = framework[:uuid]
      last_known_type = framework[:last_known_type]
      source_tree = framework[:source_tree]
      
      # file refs
      file_info = "isa = PBXFileReference; lastKnownFileType = #{last_known_type}; name = #{fw_name}; path = #{path}; sourceTree = #{source_tree}; "
      file_refs_to_add << "#{fileref} /* #{fw_name} */ = {#{file_info}};"
      
      # build files
      file_info = "isa = PBXBuildFile; fileRef = #{fileref} /* #{fw_name} */; settings = {ATTRIBUTES = (Weak, ); }; "
      build_files_to_add << "#{uuid} /* #{fw_name} in Frameworks */ = {#{file_info}};"
      
      # build phases
      build_phases_to_add << "\t\t\t\t#{uuid} /* #{fw_name} */,"
      if fw_name.end_with?(".a")
        path_components = path.split("/")
        path_components.pop
        library_search_paths << "$(SRCROOT)/../#{path_components.join("/")}"
      end
      
      # file groups (tree)
      files_in_group_to_add << "\t\t\t\t#{fileref} /* #{fw_name} */,"
    else
      puts "Unsupported: #{library}"
    end
  end

  def integrate_testflight_sdk(sdk_path, token)
    puts "Integrate TestFlight SDK #{sdk_path}, #{token}"
    link_library "libz.dylib"
  end

  def add_block_after(line, block)
    @src.gsub!(line, line + "\n" + block)
  end

  def delete_original_project_file
    FileUtils.rm @proj_file
  end

  def write
    open(@proj_file, "w") {|f|
      f.puts @src
    }
  end
end