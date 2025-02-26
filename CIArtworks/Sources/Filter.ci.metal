#include<CoreImage/CoreImage.h>
extern "C" {
	float4 myColor(coreimage::sample_t s, float2 val) {
        return s.ggga * val.xxyy;
    }
	float2 myWarp(coreimage::destination dest) {
		return dest.coord();
	}
	float4 myBlend(coreimage::sample_t foreground, coreimage::sample_t background) {
		return (foreground + background) / 2.0;
	}
}
