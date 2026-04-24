#ifndef CONFIG_H
#define CONFIG_H

#define PACKAGE_NAME "opus"
#define PACKAGE_VERSION "1.5.2-official"

#define OPUS_BUILD 1
#define HAVE_LRINT 1
#define HAVE_LRINTF 1
#define HAVE_MEMORY_H 1
#define HAVE_STDINT_H 1
#define HAVE_STDLIB_H 1
#define HAVE_STRINGS_H 1
#define HAVE_STRING_H 1
#define HAVE_SYS_STAT_H 1
#define HAVE_SYS_TYPES_H 1
#define HAVE_UNISTD_H 1

/* Optimización para punto fijo (mejor en móviles antiguos/gama media) */
/* #define FIXED_POINT 1 */
/* Optimización para punto flotante (mejor en móviles modernos) */
#define FLOAT_APPROX 1

#define VAR_ARRAYS 1

#endif
