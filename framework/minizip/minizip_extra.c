#include "minizip_extra.h"
#include "mz_strm_os.h"
#include "mz_strm.h"
#include "mz_zip.h"


extern unzFile unzReOpen (const char* path, unzFile file)
{
	void *stream;
	if (mz_stream_os_create(&stream) == NULL)
		return NULL;

	if (mz_stream_open(stream, path, MZ_OPEN_MODE_READ) != MZ_OK) {
		mz_stream_delete(&stream);
		return NULL;
	}

	void *handle = NULL;
	mz_zip_create(&handle);
}

extern int ZEXPORT unzseek(unzFile file, z_off_t offset, int origin)
{
	return unzseek64(file, (ZPOS64_T)offset, origin);
}

extern int ZEXPORT unzseek64(unzFile file, ZPOS64_T offset, int origin)
{
	return unzSeek64( file, offset, origin );
}
