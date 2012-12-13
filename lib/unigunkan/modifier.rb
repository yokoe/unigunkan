class Modifier
  def self.add_build_files(src, files)
    return add_block_after(src, "/* Begin PBXBuildFile section */", files)
  end

  def self.add_file_ref(src, files)
  	return add_block_after(src, "/* Begin PBXFileReference section */", files)
  end

  def self.add_framework_build_phase(src, files)
  	src_ = src
    target = /Frameworks \*\/ = {\n\t\t\tisa = PBXFrameworksBuildPhase;\n\t\t\tbuildActionMask = (.*?);\n\t\t\tfiles = \(/
    mask = src_.scan(target)[0][0]
    build_phases = "Frameworks */ = {\n\t\t\tisa = PBXFrameworksBuildPhase;\n\t\t\tbuildActionMask = #{mask};\n\t\t\tfiles = (\n"
    return src_.gsub(build_phases, build_phases + files + ",")
  end

  def self.add_file_to_tree(src, file)
  	target = "/* CustomTemplate */ = {
			isa = PBXGroup;
			children = ("
	return add_block_after(src, target, file)
  end

  def self.add_library_search_paths(src, paths)
  	# TODO This won't work in non-unity projects. Fix later.
    target = '$(SRCROOT)/Libraries\"",'
    return add_block_after(src, target, paths)
  end

  def self.add_block_after(src, line, block)
    src.gsub(line, line + "\n" + block)
  end
end