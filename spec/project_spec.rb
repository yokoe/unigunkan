# -*- encoding: UTF-8 -*-
require File.expand_path(File.join('spec_helper'), File.dirname(__FILE__))

describe Modifier do

  src = <<EOS
// !$*UTF8*$!
{
  archiveVersion = 1;
  classes = {
  };
  objectVersion = 46;
  objects = {

/* Begin PBXBuildFile section */
    1900A7F415A6DCB500DDA291 /* AFHTTPClient.m in Sources */ = {isa = PBXBuildFile; fileRef = 1900A7E015A6DCB500DDA291 /* AFHTTPClient.m */; settings = {COMPILER_FLAGS = "-fno-objc-arc"; }; };
    1900A7F515A6DCB500DDA291 /* AFHTTPRequestOperation.m in Sources */ = {isa = PBXBuildFile; fileRef = 1900A7E215A6DCB500DDA291 /* AFHTTPRequestOperation.m */; settings = {COMPILER_FLAGS = "-fno-objc-arc"; }; };
    1900A7F615A6DCB500DDA291 /* AFImageRequestOperation.m in Sources */ = {isa = PBXBuildFile; fileRef = 1900A7E415A6DCB500DDA291 /* AFImageRequestOperation.m */; settings = {COMPILER_FLAGS = "-fno-objc-arc"; }; };
    1900A7F715A6DCB500DDA291 /* AFJSONRequestOperation.m in Sources */ = {isa = PBXBuildFile; fileRef = 1900A7E615A6DCB500DDA291 /* AFJSONRequestOperation.m */; settings = {COMPILER_FLAGS = "-fno-objc-arc"; }; };
    1900A7F815A6DCB500DDA291 /* AFJSONUtilities.m in Sources */ = {isa = PBXBuildFile; fileRef = 1900A7E815A6DCB500DDA291 /* AFJSONUtilities.m */; settings = {COMPILER_FLAGS = "-fno-objc-arc"; }; };
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
    19C7BC9D1679ECA000282DD7 /* en */ = {isa = PBXFileReference; lastKnownFileType = file.xib; name = en; path = en.lproj/SYViewController.xib; sourceTree = "<group>"; };
    19C7BCA41679ECAE00282DD7 /* libz.dylib */ = {isa = PBXFileReference; lastKnownFileType = "compiled.mach-o.dylib"; name = libz.dylib; path = usr/lib/libz.dylib; sourceTree = SDKROOT; };

/* Begin PBXFrameworksBuildPhase section */
		19C7BC7A1679ECA000282DD7 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
				19C7BC821679ECA000282DD7 /* UIKit.framework in Frameworks */,
				19C7BC841679ECA000282DD7 /* Foundation.framework in Frameworks */,
				19C7BC861679ECA000282DD7 /* CoreGraphics.framework in Frameworks */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */
EOS


  it "should add buildfile" do
    ret = Modifier.add_build_files(src, "[buildfile]")
    expected = <<EOS
/* Begin PBXBuildFile section */
[buildfile]
EOS
    ret.index(expected).should_not be_nil
  end

  it "should add fileref" do
    ret = Modifier.add_file_ref(src, "[fileref]")
    expected = <<EOS
/* Begin PBXFileReference section */
[fileref]
EOS
    ret.index(expected).should_not be_nil
  end

  it "should add framework build phase" do
    ret = Modifier.add_framework_build_phase(src, "[framework]")
    expected = <<EOS
      isa = PBXFrameworksBuildPhase;
      buildActionMask = 2147483647;
      files = (
[framework]
EOS
  end
end