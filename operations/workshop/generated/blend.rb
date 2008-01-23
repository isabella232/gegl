#!/usr/bin/env ruby

copyright = '
/* !!!! AUTOGENERATED FILE generated by blend.rb !!!!! 
 *
 *  Copyright 2006 Øyvind Kolås <pippin@gimp.org>
 *
 * !!!! AUTOGENERATED FILE !!!!!
 *
 * The formulas used for the blend modes are from:
 *     http://www.pegtop.net/delphi/articles/blendmodes/
 *
 */'

a = [
      ['average',       '(cA + aB)/2'],
      #['screen',        '1.0 - ((1.0-cA) * (1.0-cB))'],
      #['darken',        'cA < cB ? cA : cB'],
      #['lighten',       'cA > cB ? cA : cB'],
      #['difference',    'fabs(cA-cB)'],
      ['negation',      '1.0 - fabs(1.0-cA-cB)'],
      #['exclusion',     'cA + cB - 2*cA*cB'],
      #['overlay',       'cA<0.5?2*(cA*cB):1.0-2*(1.0-cA)*(1.0-cB)'],
      #['hard_light',    'cB<0.5?2*(cA*cB):1.0-2*(1.0-cA)*(1.0-cB)'],
      #['soft_light',    '2*cA*cB+cA*cA-2*cA*cA*cB'],
      #['color_dodge',   'cA / (1.0 - cB)'],
      ['soft_dodge',    '(cA+cB<1.0)?0.5*cA / (1.0 - cB):1.0-0.5*(1.0 - cB)/cA'],
      #['color_burn',    'cB<=0.0?0.0:1.0-(1.0-cA)/cB'],
      ['soft_burn',     '(cA+cB<1.0)?0.5*cB / (1.0 - cA):1.0-0.5*(1.0 - cA) / cB'],
      ['blend_reflect', 'cB>=1.0?1.0:cA*cA / (1.0-cB)'],
      ['subtractive',   'cA+cB-1.0']
    ]

a.each do
    |item|

    name     = item[0] + ''
    filename = name + '.c'

    puts "generating #{filename}"
    file = File.open(filename, 'w')

    name        = item[0]
    capitalized = name.capitalize
    swapcased   = name.swapcase
    formula     = item[1]

    file.write copyright
    file.write "
#if GEGL_CHANT_PROPERTIES
/* no properties */
#else

#define GEGL_CHANT_NAME          #{name}
#define GEGL_CHANT_SELF          \"#{filename}\"
#define GEGL_CHANT_CATEGORIES    \"compositors:blend\"
#define GEGL_CHANT_DESCRIPTION   \"Image blending operation '#{name}' (<tt>c = #{formula}</tt>)\"

#define GEGL_CHANT_POINT_COMPOSER
#define GEGL_CHANT_PREPARE

#include \"gegl-old-chant.h\"
#include \"math.h\"

static void prepare (GeglOperation *self)
{
  Babl *format = babl_format (\"RaGaBaA float\");

  gegl_operation_set_format (self, \"input\", format);
  gegl_operation_set_format (self, \"aux\", format);
  gegl_operation_set_format (self, \"output\", format);
}



static gboolean
process (GeglOperation *op,
          void          *in_buf,
          void          *aux_buf,
          void          *out_buf,
          glong          n_pixels)
{
  gint i;
  gfloat *in = in_buf;
  gfloat *aux = aux_buf;
  gfloat *out = out_buf;

  if (aux==NULL)
    return TRUE;

  for (i=0; i<n_pixels; i++)
    {
      int  j;
      gfloat aA, aB;

      aA=in[3];
      aB=aux[3];
      for (j=0; j<3; j++)
          {
              gfloat cA, cB;

              cA=in[j];
              cB=aux[j];
              out[j] = cA + (#{formula}-cA) * cB;
          }
      out[j] = aA;
      in  += 4;
      aux += 4;
      out += 4;
    }
  return TRUE;
}

#endif
"

  file.close
end
