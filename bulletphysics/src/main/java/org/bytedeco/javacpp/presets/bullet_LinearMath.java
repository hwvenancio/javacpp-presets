
package org.bytedeco.javacpp.presets;

import java.util.List;

import org.bytedeco.javacpp.annotation.Platform;
import org.bytedeco.javacpp.annotation.Properties;
import org.bytedeco.javacpp.tools.Info;
import org.bytedeco.javacpp.tools.InfoMap;
import org.bytedeco.javacpp.tools.InfoMapper;

/**
 * 
 * @author hwvenancio
 *
 */
@Properties(target="org.bytedeco.javacpp.bullet_LinearMath", value={
    @Platform(include={"bullet/LinearMath/btScalar.h", "bullet/LinearMath/btVector3.h"},
				link={"LinearMath"})
	})
public class bullet_LinearMath implements InfoMapper {
	public void map(InfoMap infoMap) {
		infoMap
//			.put(new Info("SIMD_FORCE_INLINE").base("inline"))
			.put(new Info("SIMD_EPSILON", "SIMD_INFINITY").skip())
			.put(new Info("_WIN32").define(false))
			.put(new Info("__CELLOS_LV2__", "BT_USE_NEON").define(false))
//			.put(new Info("BT_NAN").javaText("public static final float BT_NAN = java.lang.Float.NaN;"))
//			.put(new Info("BT_INFINITY").javaText("public static final float BT_INFINITY = java.lang.Float.POSITIVE_INFINITY;"))
			.put(new Info("BT_NAN", "btNanMask","BT_INFINITY", "btInfinityMask", "btInfMaskConverter").define().skip())
			.put(new Info("BT_USE_DOUBLE_PRECISION").define(false))
			.put(new Info("BT_FORCE_DOUBLE_FUNCTIONS").define(false))
			;
	}
}