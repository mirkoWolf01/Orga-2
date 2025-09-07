#include "type.h"

// Definiciones de _new
fat32_t *new_fat32()
{
    fat32_t *f32 = malloc(sizeof(fat32_t));
    return f32;
}
ext4_t *new_ext4()
{
    ext4_t *ext = malloc(sizeof(ext4_t));
    return ext;
}
ntfs_t *new_ntfs()
{
    ntfs_t *ntf = malloc(sizeof(ntfs_t));
    return ntf;
}

// Definiciones de _copy
fat32_t *copy_fat32(fat32_t *file)
{
    fat32_t *f32 = malloc(sizeof(fat32_t));
    *f32 = *file;
    return f32;
}
ext4_t *copy_ext4(ext4_t *file)
{
    ext4_t *ext = malloc(sizeof(ext4_t));
    *ext = *file;
    return ext;
}
ntfs_t *copy_ntfs(ntfs_t *file)
{
    ntfs_t *ntf = malloc(sizeof(ntfs_t));
    *ntf = *file;
    return ntf;
}

// Definiciones de _rm
void rm_fat32(fat32_t *file)
{
    free(file);
}
void rm_ext4(ext4_t *file)
{
    free(file);
}
void rm_ntfs(ntfs_t *file)
{
    free(file);
}



funcCopy_t getCopyFunction(type_t t)
{
    switch (t)
    {
    case TypeFAT32:
        return (funcCopy_t)copy_fat32;
        break;
    case TypeEXT4:
        return (funcCopy_t)copy_ext4;
        break;
    case TypeNTFS:
        return (funcCopy_t)copy_ntfs;
        break;
    default:
        return NULL;
        break;
    }
}

funcRm_t getRmFunction(type_t t)
{
    switch (t)
    {
    case TypeFAT32:
        return (funcRm_t)rm_fat32;
        break;
    case TypeEXT4:
        return (funcRm_t)rm_ext4;
        break;
    case TypeNTFS:
        return (funcRm_t)rm_ntfs;
        break;
    default:
        return NULL;
        break;
    }
}