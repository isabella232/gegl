/* !!!! AUTOGENERATED FILE generated by svg-colormatrix.sh !!!!!  
 *                                                                
 *  Copyright 2006 Geert Jordaens <geert.jordaens@telenet.be>     
 *                                                                
 * !!!! AUTOGENERATED FILE !!!!!                                  
 *                                                                
 */
#if GEGL_CHANT_PROPERTIES
  gegl_chant_string (values, "", "list of <number>s")
#else

#define GEGL_CHANT_POINT_FILTER
#define GEGL_CHANT_NAME          svg_huerotate
#define GEGL_CHANT_DESCRIPTION   "SVG color matrix operation svg_huerotate"
#define GEGL_CHANT_CATEGORIES    "compositors:svgfilter"
#define GEGL_CHANT_SELF          "svg_huerotate.c"
#define GEGL_CHANT_PREPARE
#include "gegl-old-chant.h"

#include <math.h>
#include <stdlib.h>

static void prepare (GeglOperation *operation)
{
  Babl *format = babl_format ("RaGaBaA float");

  gegl_operation_set_format (operation, "input", format);
  gegl_operation_set_format (operation, "output", format);
}

static gboolean
process (GeglOperation *op,
          void          *in_buf,
          void          *out_buf,
          glong          n_pixels)
{
  gfloat      *in = in_buf;
  gfloat      *out = out_buf;
  gfloat      *m;

  gfloat ma[25] = { 1.0, 0.0, 0.0, 0.0, 0.0,
                    0.0, 1.0, 0.0, 0.0, 0.0,
                    0.0, 0.0, 1.0, 0.0, 0.0,
                    0.0, 0.0, 0.0, 1.0, 0.0,
                    0.0, 0.0, 0.0, 0.0, 1.0};
  char        *endptr;
  gfloat       value;
  const gchar  delimiter=',';
  const gchar *delimiters=" ";
  gchar      **values;
  glong        i;

  m = ma;

  if ( GEGL_CHANT_OPERATION (op)->values != NULL ) 
    {
      g_strstrip(GEGL_CHANT_OPERATION (op)->values);      
      g_strdelimit (GEGL_CHANT_OPERATION (op)->values, delimiters, delimiter);
      values = g_strsplit (GEGL_CHANT_OPERATION (op)->values, &delimiter, 1);
      if ( values[0] != NULL )
        {
          value = g_ascii_strtod(values[0], &endptr);
          if (endptr != values[0])
            ma[0] = .213 + cos(value)*.787 - sin(value)*.213;          
        }
      g_strfreev(values);
    }
  for (i=0; i<n_pixels; i++)
    {
      out[0] =  m[0]  * in[0] +  m[1]  * in[1] + m[2]  * in[2] + m[3]  * in[3] + m[4];
      out[1] =  m[5]  * in[0] +  m[6]  * in[1] + m[7]  * in[2] + m[8]  * in[3] + m[9];
      out[2] =  m[10] * in[0] +  m[11] * in[1] + m[12] * in[2] + m[13] * in[3] + m[14];
      out[3] =  m[15] * in[0] +  m[16] * in[1] + m[17] * in[2] + m[18] * in[3] + m[19];
      in  += 4;
      out += 4;
    }
  return TRUE;
}

#endif
