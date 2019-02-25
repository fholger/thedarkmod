/*****************************************************************************
                    The Dark Mod GPL Source Code
 
 This file is part of the The Dark Mod Source Code, originally based 
 on the Doom 3 GPL Source Code as published in 2011.
 
 The Dark Mod Source Code is free software: you can redistribute it 
 and/or modify it under the terms of the GNU General Public License as 
 published by the Free Software Foundation, either version 3 of the License, 
 or (at your option) any later version. For details, see LICENSE.TXT.
 
 Project: The Dark Mod Updater (http://www.thedarkmod.com/)
 
******************************************************************************/

#pragma once

#include <memory>
#include "StdFilesystem.h"

namespace fs = stdext;

namespace tdm
{

class SvnClient;
typedef std::shared_ptr<SvnClient> SvnClientPtr;

/**
 * An object providing a few SVN client methods.
 * This is used to query file states. The implementation is
 * dependent on the preprocessor variables. In Linux the tdm_update
 * project compiles with a dummy implementation to reduce linker deps.
 */
class SvnClient
{
public:
	virtual ~SvnClient() {}

	// Activate/Deacticate the client. Deactivated clients will return true in FileIsUnderVersionControl().
	virtual void SetActive(bool active) = 0;

	// Returns true if the given file is under version control, false in all other cases
	virtual bool FileIsUnderVersionControl(const fs::path& path) = 0;

	// Factory method to retrieve an implementation of this class
	static SvnClientPtr Create();
};

// Dummy implementation returning false on all queries / doing nothing
class SvnClientDummy :
	public SvnClient
{
public:
	// Activate/Deacticate the client. Deactivated clients will return true in FileIsUnderVersionControl().
	void SetActive(bool active)
	{}

	// Returns true if the given file is under version control, false in all other cases
	bool FileIsUnderVersionControl(const fs::path& path)
	{
		return false;
	}
};

} // namespace
