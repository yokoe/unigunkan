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
EOS


  it "Should be ok" do
    ret = Modifier.add_build_files(src, "[added]")
    expected = <<EOS
/* Begin PBXBuildFile section */
[added]
EOS
    ret.index(expected).should_not be_nil
  end
end