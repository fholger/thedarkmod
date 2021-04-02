#include "minizip_extra.h"
#include "mz_strm_os.h"
#include "mz_strm.h"
#include "mz_strm_mem.h"
#include "mz_zip.h"

typedef struct mz_zip_s {
    mz_zip_file file_info;
    mz_zip_file local_file_info;

    void *stream;                   /* main stream */
    void *cd_stream;                /* pointer to the stream with the cd */
    void *cd_mem_stream;            /* memory stream for central directory */
    void *compress_stream;          /* compression stream */
    void *crypt_stream;             /* encryption stream */
    void *file_info_stream;         /* memory stream for storing file info */
    void *local_file_info_stream;   /* memory stream for storing local file info */

    int32_t  open_mode;
    uint8_t  recover;
    uint8_t  data_descriptor;

    uint32_t disk_number_with_cd;   /* number of the disk with the central dir */
    int64_t  disk_offset_shift;     /* correction for zips that have wrong offset start of cd */

    int64_t  cd_start_pos;          /* pos of the first file in the central dir stream */
    int64_t  cd_current_pos;        /* pos of the current file in the central dir */
    int64_t  cd_offset;             /* offset of start of central directory */
    int64_t  cd_size;               /* size of the central directory */
    uint32_t cd_signature;          /* signature of central directory */

    uint8_t  entry_scanned;         /* entry header information read ok */
    uint8_t  entry_opened;          /* entry is open for read/write */
    uint8_t  entry_raw;             /* entry opened with raw mode */
    uint32_t entry_crc32;           /* entry crc32  */

    uint64_t number_entry;

    uint16_t version_madeby;
    char     *comment;
} mz_zip;

typedef struct mz_compat_s {
    void     *stream;
    void     *handle;
    uint64_t entry_index;
    int64_t  entry_pos;
    int64_t  total_out;
} mz_compat;

extern unzFile unzReOpen (const char* path, unzFile file)
{
	void *stream;
	if (mz_stream_os_create(&stream) == NULL)
		return NULL;

	if (mz_stream_open(stream, path, MZ_OPEN_MODE_READ) != MZ_OK) {
		mz_stream_delete(&stream);
		return NULL;
	}

	mz_compat *orig = (mz_compat *)file;
	mz_zip *src = (mz_zip *)orig->handle;
	mz_zip *zip = mz_zip_create(NULL);
	memcpy(zip, src, sizeof(mz_zip));
	zip->stream = stream;
	zip->cd_stream = stream;
	zip->cd_mem_stream = NULL;
	mz_stream_mem_create(&zip->file_info_stream);
	mz_stream_mem_open(zip->file_info_stream, NULL, MZ_OPEN_MODE_CREATE);
	mz_stream_mem_create(&zip->local_file_info_stream);
	mz_stream_mem_open(zip->local_file_info_stream, NULL, MZ_OPEN_MODE_CREATE);
	zip->open_mode = MZ_OPEN_MODE_READ;

    mz_compat *newFile = (mz_compat *)MZ_ALLOC(sizeof(mz_compat));
	newFile->stream = stream;
	newFile->handle = zip;
	newFile->entry_index = orig->entry_index;
	newFile->entry_pos = orig->entry_pos;
	newFile->total_out = orig->total_out;

	unzOpenCurrentFile( newFile );
	return newFile;
}

extern int ZEXPORT unzseek(unzFile file, z_off_t offset, int origin)
{
	return unzseek64(file, (ZPOS64_T)offset, origin);
}

extern int ZEXPORT unzseek64(unzFile file, ZPOS64_T offset, int origin)
{
	return unzSeek64( file, offset, origin );
}
