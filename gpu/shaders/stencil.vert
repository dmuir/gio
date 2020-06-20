#version 310 es

// SPDX-License-Identifier: Unlicense OR MIT

precision highp float;

layout(binding = 0) uniform Block {
	vec4 transform;
};

layout(location=0) in float corner;
layout(location=1) in float maxy;
layout(location=2) in vec2 from;
layout(location=3) in vec2 ctrl;
layout(location=4) in vec2 to;

layout(location=0) out vec2 vFrom;
layout(location=1) out vec2 vCtrl;
layout(location=2) out vec2 vTo;

void main() {
	// Add a one pixel overlap so curve quads cover their
	// entire curves. Could use conservative rasterization
	// if available.
	vec2 from = from;
	vec2 ctrl = ctrl;
	vec2 to = to;
	float maxy = maxy;
	vec2 pos;
	float c = corner;
	if (c >= 0.375) {
		// North.
		c -= 0.5;
		pos.y = maxy + 1.0;
	} else {
		// South.
		pos.y = min(min(from.y, ctrl.y), to.y) - 1.0;
	}
	if (c >= 0.125) {
		// East.
		pos.x = max(max(from.x, ctrl.x), to.x)+1.0;
	} else {
		// West.
		pos.x = min(min(from.x, ctrl.x), to.x)-1.0;
	}
	vFrom = from-pos;
	vCtrl = ctrl-pos;
	vTo = to-pos;
	pos = pos*transform.xy + transform.zw;
    gl_Position = vec4(pos, 1, 1);
}

