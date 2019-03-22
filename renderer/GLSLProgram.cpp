/*****************************************************************************
The Dark Mod GPL Source Code

This file is part of the The Dark Mod Source Code, originally based
on the Doom 3 GPL Source Code as published in 2011.

The Dark Mod Source Code is free software: you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version. For details, see LICENSE.TXT.

Project: The Dark Mod (http://www.thedarkmod.com/)

******************************************************************************/

#include "precompiled.h"
#include "GLSLProgram.h"
#include "GLSLUniforms.h"
#include <memory>
#include <regex>

idCVar r_debugGLSL("r_debugGLSL", "0", CVAR_BOOL|CVAR_ARCHIVE, "If enabled, checks and warns about additional potential sources of GLSL shader errors.");

GLuint GLSLProgram::currentProgram = 0;

GLSLProgram::GLSLProgram( const char *name ) : name( name ), program( 0 ) {}

GLSLProgram::~GLSLProgram() {
	Destroy();
}

void GLSLProgram::Init() {
	program = qglCreateProgram();
	if( program == 0 ) {
		common->Error( "Call to glCreateProgram failed for program %s", name.c_str() );
	}
}

void GLSLProgram::Destroy() {
	if( currentProgram == program ) {
		Deactivate();
	}

	for( auto &it : uniformGroups ) {
		delete it.group;
	}
	uniformGroups.clear();

	if( program != 0 ) {
		qglDeleteProgram( program );
		program = 0;
	}
}

void GLSLProgram::AttachVertexShader( const char *sourceFile, const idDict &defines ) {
	LoadAndAttachShader( GL_VERTEX_SHADER, sourceFile, defines );
}

void GLSLProgram::AttachGeometryShader( const char *sourceFile, const idDict &defines ) {
	LoadAndAttachShader( GL_GEOMETRY_SHADER, sourceFile, defines );
}

void GLSLProgram::AttachFragmentShader( const char *sourceFile, const idDict &defines ) {
	LoadAndAttachShader( GL_FRAGMENT_SHADER, sourceFile, defines );
}

void GLSLProgram::BindAttribLocation( unsigned location, const char *attribName ) {
		qglBindAttribLocation( program, location, attribName );
}

bool GLSLProgram::Link() {
	common->Printf( "Linking GLSL program %s ...\n", name.c_str() );
	qglLinkProgram( program );

	GLint result = GL_FALSE;
	qglGetProgramiv( program, GL_LINK_STATUS, &result );
	if( result != GL_TRUE ) {
		// display program info log, which may contain clues to the linking error
		GLint length;
		qglGetProgramiv( program, GL_INFO_LOG_LENGTH, &length );
		auto log = std::make_unique<char[]>( length );
		qglGetProgramInfoLog( program, length, &result, log.get() );
		common->Warning( "Linking program %s failed:\n%s\n", name.c_str(), log.get() );
	}

	return result;
}

void GLSLProgram::Activate() {
	//TODO: uncomment this thing when everything uses GLSLProgram
	//right now there are too many places where qglUseProgram is called
	//if( currentProgram != program ) {
		qglUseProgram( program );
		currentProgram = program;
	//}
}

void GLSLProgram::Deactivate() {
	qglUseProgram( 0 );
	currentProgram = 0;
}

int GLSLProgram::GetUniformLocation(const char *uniformName) const {
    const int location = qglGetUniformLocation( program, uniformName );
	if( location < 0 && r_debugGLSL.GetBool() ) {
		common->Warning( "In program %s: uniform %s is unknown or unused.", name.c_str(), uniformName );
	}
	return location;
}

GLSLUniformGroup *&GLSLProgram::FindUniformGroup( const std::type_index &type ) {
	int n = (int)uniformGroups.size();
	for (int i = 0; i < n; i++)
		if (uniformGroups[i].type == type)
			return uniformGroups[i].group;
	uniformGroups.push_back(ActiveUniformGroup{type, nullptr});
	return uniformGroups[n].group;
}

bool GLSLProgram::Validate() {
	GLint result = GL_FALSE;
	qglValidateProgram( program );
	qglGetProgramiv( program, GL_VALIDATE_STATUS, &result );
	if( result != GL_TRUE ) {
		// display program info log, which may contain clues to the linking error
		GLint length;
		qglGetProgramiv( program, GL_INFO_LOG_LENGTH, &length );
		auto log = std::make_unique<char[]>( length );
		qglGetProgramInfoLog( program, length, &result, log.get() );
		common->Warning( "Validation for program %s failed:\n%s\n", name.c_str(), log.get() );
	}
	return result;
}

void GLSLProgram::LoadAndAttachShader( GLint shaderType, const char *sourceFile, const idDict &defines ) {
	if( program == 0 ) {
		common->Error( "Tried to attach shader to an uninitialized program %s", name.c_str() );
	}

	GLuint shader = CompileShader( shaderType, sourceFile, defines );
	if( shader == 0) {
		common->Warning( "Failed to attach shader %s to program %s.\n", sourceFile, name.c_str() );
		return;
	}
	qglAttachShader( program, shader );
	// won't actually be deleted until the program it's attached to is deleted
	qglDeleteShader( shader );
}

namespace {

	std::string ReadFile( const char *sourceFile ) {
		void *buf = nullptr;
		int len = fileSystem->ReadFile( idStr("glprogs/") + sourceFile, &buf );
		if( buf == nullptr ) {
			common->Warning( "Could not open shader file %s", sourceFile );
			return "";
		}
		std::string contents( static_cast< char* >( buf ), len );
		fileSystem->FreeFile( buf );

		return contents;
	}

	/**
	 * Resolves include statements in GLSL source files.
	 * Note that the parsing is primitive and not context-sensitive. It will not respect multi-line comments
	 * or conditional preprocessor blocks, so keep includes simple in the source files!
	 * 
	 * Include directives should look like this:
	 * 
	 * #pragma tdm_include "somefile.glsl" // optional comment
	 */
	void ResolveIncludes( std::string &source, std::vector<std::string> &includedFiles ) {
		static const std::regex includeRegex( R"regex([ \t]*#[ \t]*pragma[ \t]+tdm_include[ \t]+"(.*)"[ \t]*(?:\/\/.*)?\r?\n)regex" );

		unsigned int currentFileNo = includedFiles.size() - 1;
		unsigned int totalIncludedLines = 0;

		std::smatch match;
		while( std::regex_search( source, match, includeRegex ) ) {
			std::string fileToInclude( match[ 1 ].first, match[ 1 ].second );
			if( std::find( includedFiles.begin(), includedFiles.end(), fileToInclude ) == includedFiles.end() ) {
				int nextFileNo = includedFiles.size();
				std::string includeContents = ReadFile( fileToInclude.c_str() );
				includedFiles.push_back( fileToInclude );
				ResolveIncludes( includeContents, includedFiles );

				// also add a #line instruction at beginning and end of include so that
				// compile errors are mapped to the correct file and line
				// unfortunately, #line does not take an actual filename, but only an integral reference to a file :(
				unsigned int currentLine = std::count( source.cbegin(), match[ 0 ].first, '\n' ) + 1 - totalIncludedLines;
				std::string includeBeginMarker = "#line 0 " + std::to_string( nextFileNo ) + '\n';
				std::string includeEndMarker = "\n#line " + std::to_string( currentLine ) + ' ' + std::to_string( currentFileNo );
				totalIncludedLines += std::count( includeContents.begin(), includeContents.end(), '\n' ) + 2;

				// replace include statement with content of included file
				std::string replacement = includeBeginMarker + includeContents + includeEndMarker + "\n";
				source.replace( match.position( 0 ), match.length( 0 ), replacement );
			} else {
				std::string replacement = "// already included " + fileToInclude + "\n";
				source.replace( match.position( 0 ), match.length( 0 ), replacement );
			}
		}
	}

	/**
	 * Resolves dynamic defines statements in GLSL source files.
	 * Note that the parsing is primitive and not context-sensitive. It will not respect multi-line comments
	 * or conditional preprocessor blocks!
	 * 
	 * Define directives should look like this:
	 * 
	 * #pragma tdm_define "DEF_NAME" // optional comment
	 * 
	 * If DEF_NAME is contained in defines, the line will be replaced by
	 * #define DEF_NAME <value>
	 * 
	 * Otherwise, it will be commented out.
	 */
	void ResolveDefines( std::string &source, const idDict &defines ) {
		static const std::regex defineRegex( R"regex([ \t]*#[ \t]*pragma[ \t]+tdm_define[ \t]+"(.*)"[ \t]*(?:\/\/.*)?\r?\n)regex" );
		
		std::smatch match;
		while( std::regex_search( source, match, defineRegex ) ) {
			std::string define( match[ 1 ].first, match[ 1 ].second );
			auto defIt = defines.FindKey( define.c_str() );
			if( defIt != nullptr ) {
				std::string replacement = "#define " + define + " " + defIt->GetValue().c_str() + "\n";
				source.replace( match.position( 0 ), match.length( 0 ), replacement );
			} else {
				std::string replacement = "// #undef " + define + "\n";
				source.replace( match.position( 0 ), match.length( 0 ), replacement );
			}
		}
	}

}

GLuint GLSLProgram::CompileShader( GLint shaderType, const char *sourceFile, const idDict &defines ) {
	std::string source = ReadFile( sourceFile );
	if( source.empty() ) {
		return 0;
	}

	std::vector<std::string> sourceFiles { sourceFile };
	ResolveIncludes( source, sourceFiles );
	ResolveDefines( source, defines );

	GLuint shader = qglCreateShader( shaderType );
	GLint length = source.size();
	const char *sourcePtr = source.c_str();
	qglShaderSource( shader, 1, &sourcePtr, &length );
	qglCompileShader( shader );

	// check if compilation was successful
	GLint result;
	qglGetShaderiv( shader, GL_COMPILE_STATUS, &result );
	if( result == GL_FALSE ) {
		// display the shader info log, which contains compile errors
		int length;
		qglGetShaderiv( shader, GL_INFO_LOG_LENGTH, &length );
		auto log = std::make_unique<char[]>( length );
		qglGetShaderInfoLog( shader, length, &result, log.get() );
		std::stringstream ss;
		ss << "Compiling shader file " << sourceFile << " failed:\n" << log.get() << "\n\n";
		// unfortunately, GLSL compilers don't reference any actual source files in their errors, but only
		// file index numbers. So we'll display a short legend which index corresponds to which file.
		ss << "File indexes:\n";
		for( size_t i = 0; i < sourceFiles.size(); ++i ) {
			ss << "  " << i << " - " << sourceFiles[i] << "\n";
		}
		common->Warning( "%s", ss.str().c_str() );

		qglDeleteShader( shader );
		return 0;
	}

	return shader;
}


/// UNIT TESTS FOR SHADER INCLUDES AND DEFINES

#include "../tests/testing.h"

namespace {
	const std::string BASIC_SHADER =
		"#version 150\n"
		"void main() {}";
	const std::string SHARED_COMMON =
		"uniform vec4 someParam;\n"
		"\n"
		"vec4 doSomething {\n"
		"  return someParam * 2;\n"
		"}\n";
	const std::string INCLUDE_SHADER =
		"#version 140\n"
		"#pragma tdm_include \"tests/shared_common.glsl\"\r\n"
		"void main() {}\n";

	const std::string NESTED_INCLUDE =
		"#pragma tdm_include \"tests/shared_common.glsl\"\n"
		"float myFunc() {\n"
		"  return 0.3;\n"
		"}";

	const std::string ADVANCED_INCLUDES =
		"#version 330\n"
		"\n"
		" #  pragma tdm_include \"tests/nested_include.glsl\"\n"
		"#pragma  tdm_include \"tests/shared_common.glsl\"  // ignore this comment\n"
		"#pragma tdm_include \"tests/advanced_includes.glsl\"\n"
		"void main() {\n"
		"  float myVar = myFunc();\n"
		"}\n"
		"#pragma tdm_include \"tests/basic_shader.glsl\"\n";

	const std::string EXPANDED_INCLUDE_SHADER =
		"#version 140\n"
		"#line 0 1\n"
		"uniform vec4 someParam;\n"
		"\n"
		"vec4 doSomething {\n"
		"  return someParam * 2;\n"
		"}\n"
		"\n#line 2 0\n"
		"void main() {}\n";
	const std::string EXPANDED_ADVANCED_INCLUDES =
		"#version 330\n"
		"\n"
		"#line 0 1\n"
		"#line 0 2\n"
		"uniform vec4 someParam;\n"
		"\n"
		"vec4 doSomething {\n"
		"  return someParam * 2;\n"
		"}\n"
		"\n#line 1 1\n"
		"float myFunc() {\n"
		"  return 0.3;\n"
		"}"
		"\n#line 3 0\n"
		"// already included tests/shared_common.glsl\n"
		"// already included tests/advanced_includes.glsl\n"
		"void main() {\n"
		"  float myVar = myFunc();\n"
		"}\n"
		"#line 0 3\n"
		"#version 150\n"
		"void main() {}"
		"\n#line 9 0\n";

	std::string LoadSource( const std::string &sourceFile ) {
		std::vector<std::string> includedFiles { sourceFile };
		std::string source = ReadFile( sourceFile.c_str() );
		ResolveIncludes( source, includedFiles );
		return source;
	}

	TEST_CASE("Shader include handling") {
		INFO( "Preparing test shaders" );
		fileSystem->WriteFile( "glprogs/tests/basic_shader.glsl", BASIC_SHADER.c_str(), BASIC_SHADER.size(), "fs_savepath", "" );
		fileSystem->WriteFile( "glprogs/tests/shared_common.glsl", SHARED_COMMON.c_str(), SHARED_COMMON.size(), "fs_savepath", "" );
		fileSystem->WriteFile( "glprogs/tests/include_shader.glsl", INCLUDE_SHADER.c_str(), INCLUDE_SHADER.size(), "fs_savepath", "" );
		fileSystem->WriteFile( "glprogs/tests/nested_include.glsl", NESTED_INCLUDE.c_str(), NESTED_INCLUDE.size(), "fs_savepath", "" );
		fileSystem->WriteFile( "glprogs/tests/advanced_includes.glsl", ADVANCED_INCLUDES.c_str(), ADVANCED_INCLUDES.size(), "fs_savepath", "" );

		SUBCASE( "Basic shader without includes remains unaltered" ) {
			REQUIRE( LoadSource( "tests/basic_shader.glsl" ) == BASIC_SHADER );
		}

		SUBCASE( "Simple include works" ) {
			REQUIRE( LoadSource( "tests/include_shader.glsl" ) == EXPANDED_INCLUDE_SHADER );
		}

		SUBCASE( "Multiple and nested includes" ) {
			REQUIRE( LoadSource( "tests/advanced_includes.glsl" ) == EXPANDED_ADVANCED_INCLUDES );
		}

		INFO( "Cleaning up" );
		fileSystem->RemoveFile( "tests/basic_shader.glsl", "" );
		fileSystem->RemoveFile( "tests/shared_common.glsl", "" );
		fileSystem->RemoveFile( "tests/include_shader.glsl", "" );
		fileSystem->RemoveFile( "tests/nested_include.glsl", "" );
		fileSystem->RemoveFile( "tests/advanced_includes.glsl", "" );
	}

	TEST_CASE("Shader defines handling") {
		const std::string shaderWithDynamicDefines =
			"#version 140\n"
			"#pragma tdm_define \"FIRST_DEFINE\"\n"
			"\n"
			"  # pragma   tdm_define   \"SECOND_DEFINE\"\n"
			"void main() {\n"
			"#ifdef FIRST_DEFINE\n"
			"  return;\n"
			"#endif\n"
			"}\n" ;

		const std::string expectedResult =
			"#version 140\n"
			"#define FIRST_DEFINE 1\n"
			"\n"
			"// #undef SECOND_DEFINE\n"
			"void main() {\n"
			"#ifdef FIRST_DEFINE\n"
			"  return;\n"
			"#endif\n"
			"}\n" ;

		std::string source = shaderWithDynamicDefines;
		idDict defines;
		defines.Set( "FIRST_DEFINE", "1" );
		ResolveDefines( source, defines );
		REQUIRE( source == expectedResult );
	}
}
